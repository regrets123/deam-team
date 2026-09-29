# Klient- och felpolicyprotokoll – Dag 11

## API-kontrakt

| Fält | Värde |
|---|---|
| Metod och URL | GET och http://127.0.0.1:8093/api/config?scenario= |
| Lyckad status | 200 |
| `Content-Type` | |
| Obligatoriska svarsfält | |
| Autentisering | |

## Budget

| Budget | Värde | Motivering |
|---|---:|---|
| Anslutningstimeout | | |
| Lästimeout | | |
| Maxförsök | | |
| Total tid | | |

## Felmatris

| Fel | Permanent/tillfälligt | Retry? | Väntan | Slutligt fel till användaren |
|---|---|---|---|---|
| 400 | | | | |
| 401/403 | | | | |
| 404 | | | | |
| 429 | | | | |
| 5xx | | | | |
| Timeout | | | | |
| Parse-/schemafel | | | | |

## Testresultat

| Scenario | Försök | Status/fel | Väntan | Validering | Resultat |
|---|---:|---|---:|---|---|
| `ok` | 1 | 200 | - | - | success |
| `bad-request` | 1 | 400 | - | - | stop |
| `unauthorized` | 1 | 401 | - | - | stop |
| `rate-limit` | 2 | 429, 200 | 1000ms | - | retry, success |
| `flaky` | 2 | 500, 200 | 100ms | - | retry, success |
| `bad-json` | 1 | error=contract | - | - | stop |
| `wrong-type` | 1 | error=contract | - | - | stop |
| `slow` | 1 | error=timeout_or_connection | - | - | stop |

## Idempotens och loggning

**Varför är operationen säker eller osäker att återförsöka?**  

**Vilket ID skyddar mot dubletter?**  

**Vad loggas?**  

**Vad får inte loggas?**  
