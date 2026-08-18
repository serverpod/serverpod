# Environment variables

Reference for the [Serverpod Configuration](../SKILL.md) skill. Environment variables override YAML config and are overridden by a Dart config object.

| Category | Env var | YAML / default |
| -------- | ------- | -------------- |
| Server | `SERVERPOD_RUN_MODE` | `--mode` / development |
| | `SERVERPOD_SERVER_ID` | serverId |
| | `SERVERPOD_SERVER_ROLE` | role (monolith\|serverless\|maintenance) |
| | `SERVERPOD_LOGGING_MODE` | logging (normal\|verbose) |
| | `SERVERPOD_APPLY_MIGRATIONS` | applyMigrations |
| | `SERVERPOD_APPLY_REPAIR_MIGRATION` | applyRepairMigration |
| API server | `SERVERPOD_API_SERVER_PORT` | apiServer.port / 8080 |
| | `SERVERPOD_API_SERVER_PUBLIC_HOST` | apiServer.publicHost |
| | `SERVERPOD_API_SERVER_PUBLIC_PORT` | apiServer.publicPort |
| | `SERVERPOD_API_SERVER_PUBLIC_SCHEME` | apiServer.publicScheme |
| Insights | `SERVERPOD_INSIGHTS_SERVER_PORT` | insightsServer.port |
| | `SERVERPOD_INSIGHTS_SERVER_PUBLIC_HOST`, `_PORT`, `_SCHEME` | insightsServer.* |
| Web | `SERVERPOD_WEB_SERVER_PORT` | webServer.port |
| | `SERVERPOD_WEB_SERVER_PUBLIC_HOST`, `_PORT`, `_SCHEME` | webServer.* |
| Database | `SERVERPOD_DATABASE_DIALECT` | database.dialect (postgres\|sqlite) |
| | `SERVERPOD_DATABASE_HOST` | database.host |
| | `SERVERPOD_DATABASE_PORT` | database.port |
| | `SERVERPOD_DATABASE_NAME` | database.name |
| | `SERVERPOD_DATABASE_USER` | database.user |
| | `SERVERPOD_DATABASE_REQUIRE_SSL` | database.requireSsl |
| | `SERVERPOD_DATABASE_IS_UNIX_SOCKET` | database.isUnixSocket |
| | `SERVERPOD_DATABASE_SEARCH_PATHS` | database.searchPaths |
| | `SERVERPOD_DATABASE_MAX_CONNECTION_COUNT` | database.maxConnectionCount / 10 |
| | `SERVERPOD_DATABASE_FILE_PATH` | database.filePath |
| | `SERVERPOD_DATABASE_DATA_PATH` | database.dataPath (embedded PostgreSQL) |
| Redis | `SERVERPOD_REDIS_HOST`, `_PORT`, `_USER`, `_ENABLED`, `_REQUIRE_SSL` | redis.* |
| Other | `SERVERPOD_MAX_REQUEST_SIZE` | maxRequestSize / 524288 |
| | `SERVERPOD_VALIDATE_HEADERS` | validateHeaders |
| | `SERVERPOD_WEBSOCKET_PING_INTERVAL` | websocketPingInterval / 30s |
| | `SERVERPOD_FUTURE_CALL_EXECUTION_ENABLED` | futureCallExecutionEnabled |
| | `SERVERPOD_FUTURE_CALL_CONCURRENCY_LIMIT` | futureCall.concurrencyLimit |
| | `SERVERPOD_FUTURE_CALL_SCAN_INTERVAL` | futureCall.scanInterval (ms) |
| | `SERVERPOD_FUTURE_CALL_CHECK_BROKEN_CALLS` | futureCall.checkBrokenCalls |
| | `SERVERPOD_FUTURE_CALL_DELETE_BROKEN_CALLS` | futureCall.deleteBrokenCalls |
| Session logs | `SERVERPOD_SESSION_PERSISTENT_LOG_ENABLED` | sessionLogs.persistentEnabled |
| | `SERVERPOD_SESSION_CONSOLE_LOG_ENABLED` | sessionLogs.consoleEnabled |
| | `SERVERPOD_SESSION_CONSOLE_LOG_FORMAT` | sessionLogs.consoleLogFormat (text\|json) |
| | `SERVERPOD_SESSION_LOG_CLEANUP_INTERVAL` | sessionLogs.cleanupInterval |
| | `SERVERPOD_SESSION_LOG_RETENTION_PERIOD` | sessionLogs.retentionPeriod |
| | `SERVERPOD_SESSION_LOG_RETENTION_COUNT` | sessionLogs.retentionCount |
