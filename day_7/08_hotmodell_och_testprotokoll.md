# Hotmodell och testprotokoll – Dag 7

## Systemdel

**Kommunikationsväg:**  
**Tillgång som ska skyddas:**  
**Avsändare:**  
**Mottagare:**  
**Protokoll och port:**  

## Hotmodell

| Hot eller fel | Möjlig konsekvens | Förebyggande kontroll | Test eller observation | Kvarvarande begränsning |
|---|---|---|---|---|
| Avlyssning |  |  |  |  |
| Falsk server |  |  |  |  |
| Obehörig klient |  |  |  |  |
| Läckta autentiseringsuppgifter |  |  |  |  |

## Testprotokoll

| Test | Förutsättning | Förväntat | Observerat | Godkänt? |
|---|---|---|---|---|
| MQTTS med fel CA | Broker körs | TLS stoppas före MQTT |  |  |

Inkorrekt CA kommer inte fram. 
Korrekt CA bekräftar TLS kryptering nyckeln o låter pub komma fram.

| MQTTS med rätt CA | Publisher och subscriber körs | JSON levereras |  |  |
| Betrodd TLS-server och rätt uppgift |  | Data returneras |  |  |
| Servercertifikat utan betrodd CA |  | TLS stoppas |  |  |
| Betrodd TLS-server utan uppgift |  | HTTP 401 |  |  |
| Betrodd TLS-server med fel uppgift |  | HTTP 401 |  |  |

## Hemlighetshantering

* Lagringsplats:
* Hur filen eller variabeln undantas från Git:
* Hur en ny uppgift kan införas:
* Hur en läckt uppgift kan återkallas:

## Slutsats

Beskriv vilken kontroll som skyddar mot vilket hot. Skilj genomförda tester från planerade förbättringar.
