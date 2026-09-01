# API

## POST /api/readings

| Del | Exempel |
| --- | --- |
| Metod | POST |
| Sökväg | /api/readings |
| Content-Type | application/json |
| Request body | sensorId, value, unit |
| Lyckat svar | 201 Created |
| Felsvar | 400, 415 |

## Contract

```json
{
  "sensorId": "temp-01",
  "value": 21.7,
  "unit": "C"
}
```