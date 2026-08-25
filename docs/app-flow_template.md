# App Flow

Generic template for documenting the app's flow. Replace the placeholders below with the real steps, components, and states.

## 1. Overview

One or two sentences describing what this flow accomplishes and who/what triggers it.

## 2. High-level flow

```
[Trigger] -> [Step A] -> [Step B] -> [Step C] -> [Result]
```

## 3. Diagram

```mermaid
flowchart LR
    A[Start / Trigger] --> B[Step 1]
    B --> C{Decision?}
    C -->|Yes| D[Step 2a]
    C -->|No| E[Step 2b]
    D --> F[Step 3]
    E --> F[Step 3]
    F --> G[End / Result]
```

## 4. Sequence

```mermaid
sequenceDiagram
    participant User
    participant Component A
    participant Component B

    User->>Component A: Action
    Component A->>Component B: Request
    Component B-->>Component A: Response
    Component A-->>User: Result
```

## 5. States

```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Running: start
    Running --> Success: complete
    Running --> Failed: error
    Success --> [*]
    Failed --> [*]
```

## 6. Steps in detail

| Step | Component | Input | Output | Notes |
|------|-----------|-------|--------|-------|
| 1 | | | | |
| 2 | | | | |
| 3 | | | | |

## 7. Error / edge cases

- Case:
  - Handling:
- Case:
  - Handling:

## 8. Open questions

-
