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

- Logs are readable through the `serverpod` MCP server.
- **Database:** Tables `serverpod_log`, `serverpod_query_log`, `serverpod_session_log` (when persistent enabled)
- **Console:** When console logging enabled (format: `text` or `json`)

Defaults: persistent logging is on when a database is configured, and it is only applied on PostgreSQL (SQLite has no persistent session logs). Console logging is on without a database and in the `development` run mode; the console format is `text` in `development` and `json` in the other run modes.

## Configuration

Under `sessionLogs:` in the config YAML:

| Setting | Default |
| ------- | ------- |
| persistentEnabled | true (with DB) |
| consoleEnabled | true (no DB, or development) |
| consoleLogFormat | text (development), json (other modes) |
| cleanupInterval | 24h |
| retentionPeriod | 90d |
| retentionCount | 100000 |

Each setting also has a `SERVERPOD_SESSION_*` environment variable, listed in [`serverpod-configuration/references/environment-variables.md`](../serverpod-configuration/references/environment-variables.md).

Set retention so log tables don't grow unbounded. Avoid logging sensitive data.

## Serverpod Insights

Companion app for viewing, searching, and filtering logs and inspecting failed/slow calls. Automatically available when using Serverpod Cloud.
