---
name: serverpod-logging
description: Serverpod logging — session.log, log levels, persistence, retention, console output. Use when adding logging or debugging server calls.
---

# Serverpod Logging

Use `session.log()` during a request. Logs flush when the session closes. Stored in DB and/or printed to console.

## Usage

```dart
session.log('Operation completed');

session.log('Something went wrong',
  level: LogLevel.warning,
  exception: e,
  stackTrace: stackTrace);
```

Uncaught endpoint exceptions are logged as session failures in `serverpod_session_log`.

## Destinations

- **Database:** Tables `serverpod_log`, `serverpod_query_log`, `serverpod_session_log` (when persistent enabled)
- **Console:** When console logging enabled (format: `text` or `json`)

Defaults: with database configured, persistent on + console off; without database, persistent off + console on.

## Configuration

Under `sessionLogs:` in config YAML or env vars:

| Setting | Env var | Default |
| ------- | ------- | ------- |
| persistentEnabled | `SERVERPOD_SESSION_PERSISTENT_LOG_ENABLED` | true (with DB) |
| consoleEnabled | `SERVERPOD_SESSION_CONSOLE_LOG_ENABLED` | false (with DB) |
| consoleLogFormat | `SERVERPOD_SESSION_CONSOLE_LOG_FORMAT` | text |
| cleanupInterval | `SERVERPOD_SESSION_LOG_CLEANUP_INTERVAL` | 24h |
| retentionPeriod | `SERVERPOD_SESSION_LOG_RETENTION_PERIOD` | 90d |
| retentionCount | `SERVERPOD_SESSION_LOG_RETENTION_COUNT` | — |

Set retention so log tables don't grow unbounded. Avoid logging sensitive data.

## Serverpod Insights

Companion app for viewing, searching, and filtering logs and inspecting failed/slow calls. Automatically available when using Serverpod Cloud.
