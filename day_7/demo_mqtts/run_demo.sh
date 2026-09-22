#!/usr/bin/env bash
set -u

cd "$(dirname "$0")" || exit 1

find_command() {
  command_name=$1

  if command_path=$(command -v "$command_name" 2>/dev/null); then
    printf '%s\n' "$command_path"
    return 0
  fi

  # WSL does not apply Windows' PATHEXT lookup, so try the .exe name too.
  if command_path=$(command -v "${command_name}.exe" 2>/dev/null); then
    printf '%s\n' "$command_path"
    return 0
  fi

  # Some Bash installations do not import the Windows PATH.
  for install_dir in "/mnt/c/Program Files/Mosquitto" "/c/Program Files/Mosquitto"; do
    if test -x "$install_dir/${command_name}.exe"; then
      printf '%s\n' "$install_dir/${command_name}.exe"
      return 0
    fi
  done

  return 1
}

if ! find_command openssl >/dev/null; then
  echo "MISSING: openssl"
  exit 2
fi
if ! mosquitto_command=$(find_command mosquitto); then
  echo "MISSING: mosquitto"
  exit 2
fi
if ! mosquitto_pub_command=$(find_command mosquitto_pub); then
  echo "MISSING: mosquitto_pub"
  exit 2
fi
if ! mosquitto_sub_command=$(find_command mosquitto_sub); then
  echo "MISSING: mosquitto_sub"
  exit 2
fi

bash generate_certificates.sh || exit 1
broker_run_log="broker-$$.log"
"$mosquitto_command" -c mosquitto.conf >"$broker_run_log" 2>&1 &
broker_pid=$!
subscriber_pid=""
cleanup() {
  if test -n "$subscriber_pid"; then
    kill "$subscriber_pid" 2>/dev/null || true
    wait "$subscriber_pid" 2>/dev/null || true
  fi
  kill "$broker_pid" 2>/dev/null || true
  if command -v taskkill.exe >/dev/null 2>&1; then
    MSYS_NO_PATHCONV=1 taskkill.exe /PID "$broker_pid" /T /F >/dev/null 2>&1 || true
  fi
  wait "$broker_pid" 2>/dev/null || true
  if cp "$broker_run_log" broker.log 2>/dev/null; then
    rm -f "$broker_run_log"
  fi
}
trap cleanup EXIT

broker_ready=0
for unused_attempt in 1 2 3 4 5 6 7 8 9 10; do
  sleep 0.1
  if grep -q 'Error:' "$broker_run_log"; then
    echo "FAILED: Mosquitto did not start"
    cat "$broker_run_log"
    exit 1
  fi
  if ! kill -0 "$broker_pid" 2>/dev/null; then
    echo "FAILED: Mosquitto did not start"
    cat "$broker_run_log"
    exit 1
  fi
  if grep -q 'Opening ipv4 listen socket on port 8883' "$broker_run_log"; then
    broker_ready=1
    break
  fi
done
if test "$broker_ready" -ne 1; then
  echo "FAILED: Mosquitto did not become ready"
  cat "$broker_run_log"
  exit 1
fi

passed=0
printf '\nTEST 1: Publisher litar på fel CA\n'
if "$mosquitto_pub_command" -h localhost -p 8883 \
  --cafile generated/wrong-ca.crt \
  -t iot25/room-a/temperature \
  -m '{"value":21.7,"unit":"C"}' >/dev/null 2>&1; then
  echo "UNEXPECTED: TLS connection succeeded"
else
  echo "EXPECTED: TLS verification failed"
  passed=$((passed + 1))
fi

printf '\nTEST 2: Båda klienterna litar på rätt CA\n'
rm -f received.json
"$mosquitto_sub_command" -h localhost -p 8883 \
  --cafile generated/ca.crt \
  -t iot25/room-a/temperature \
  -C 1 >received.json &
subscriber_pid=$!
sleep 0.2
"$mosquitto_pub_command" -h localhost -p 8883 \
  --cafile generated/ca.crt \
  -t iot25/room-a/temperature \
  -m '{"sensorId":"room-a-temp-01","value":21.7,"unit":"C"}'
wait "$subscriber_pid"
subscriber_pid=""

if grep -q 'room-a-temp-01' received.json; then
  echo "RECEIVED: $(sed -n '1p' received.json)"
  passed=$((passed + 1))
else
  echo "UNEXPECTED: message was not received"
fi

printf '\nRESULT: %s/2 expected outcomes\n' "$passed"
test "$passed" -eq 2
