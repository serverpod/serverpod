---
name: serverpod-configuration
description: Configure Serverpod — YAML config, environment variables, passwords, run modes, generator.yaml, TLS. Use when setting up environments, API/database/Redis settings, or managing secrets.
---

# Serverpod Configuration

Priority (highest wins): **Dart config object** > **environment variables** > **YAML config files**. YAML lives in `config/`. Secrets in `config/passwords.yaml` or env vars with `SERVERPOD_PASSWORD_` prefix.

## Run mode

Config files by mode: `config/development.yaml`, `config/staging.yaml`, `config/production.yaml`, `testing.yaml`. Set via `--mode` when starting server or `SERVERPOD_RUN_MODE` (default: `development`).

## API server (minimum)

```yaml
apiServer:
  port: 8080
  publicHost: localhost
  publicPort: 8080
  publicScheme: http
```

`publicHost`/`publicPort`/`publicScheme` are used for URLs returned to clients.

## Database

```yaml
database:
  host: localhost
  port: 8090
  name: my_project
  user: postgres
```

Password in `passwords.yaml` under run mode or `SERVERPOD_PASSWORD_database`. Optional: `searchPaths`, `maxConnectionCount`, `requireSsl`, `isUnixSocket`.

## Redis

`redis.enabled`, `redis.host`, `redis.port`; password via `SERVERPOD_PASSWORD_redis`.

## Environment variables reference

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
| Web | `SERVERPOD_WEB_SERVER_PORT` | webServer.port |
| Database | `SERVERPOD_DATABASE_HOST` | database.host |
| | `SERVERPOD_DATABASE_PORT` | database.port |
| | `SERVERPOD_DATABASE_NAME` | database.name |
| | `SERVERPOD_DATABASE_USER` | database.user |
| | `SERVERPOD_DATABASE_REQUIRE_SSL` | database.requireSsl |
| | `SERVERPOD_DATABASE_IS_UNIX_SOCKET` | database.isUnixSocket |
| | `SERVERPOD_DATABASE_SEARCH_PATHS` | database.searchPaths |
| | `SERVERPOD_DATABASE_MAX_CONNECTION_COUNT` | database.maxConnectionCount / 10 |
| Redis | `SERVERPOD_REDIS_HOST`, `_PORT`, `_USER`, `_ENABLED`, `_REQUIRE_SSL` | redis.* |
| Other | `SERVERPOD_MAX_REQUEST_SIZE` | maxRequestSize / 524288 |
| | `SERVERPOD_WEBSOCKET_PING_INTERVAL` | websocketPingInterval / 30s |
| | `SERVERPOD_FUTURE_CALL_EXECUTION_ENABLED` | futureCallExecutionEnabled |
| | `SERVERPOD_FUTURE_CALL_CONCURRENCY_LIMIT` | futureCall.concurrencyLimit |
| | `SERVERPOD_FUTURE_CALL_SCAN_INTERVAL` | futureCall.scanInterval (ms) |
| Session logs | `SERVERPOD_SESSION_PERSISTENT_LOG_ENABLED` | sessionLogs.persistentEnabled |
| | `SERVERPOD_SESSION_CONSOLE_LOG_ENABLED` | sessionLogs.consoleEnabled |
| | `SERVERPOD_SESSION_CONSOLE_LOG_FORMAT` | sessionLogs.consoleLogFormat (text\|json) |
| | `SERVERPOD_SESSION_LOG_CLEANUP_INTERVAL` | sessionLogs.cleanupInterval |
| | `SERVERPOD_SESSION_LOG_RETENTION_PERIOD` | sessionLogs.retentionPeriod |
| | `SERVERPOD_SESSION_LOG_RETENTION_COUNT` | sessionLogs.retentionCount |

## Secrets (passwords.yaml)

Structure: `shared:` (all modes) + per-mode (`development:`, `production:`, etc.). Built-in keys: `database`, `redis`, `serviceSecret`. Custom keys available via `session.passwords['key']` or `pod.getPassword('key')`.

```bash
export SERVERPOD_PASSWORD_stripeApiKey=sk_live_...  # → session.passwords['stripeApiKey']
```

Never commit real secrets; use env vars in production.

## generator.yaml

In `config/generator.yaml`:

- `type`: `server` (default), `module`, or `internal`
- `client_package_path`: path to client package
- `modules`: map of module names + optional `nickname`
- `server_test_tools_path`: test tools output path (remove to disable)
- `extraClasses`: custom serializable class URIs
- `features`: e.g. `database: true/false`

## Dart config override

Pass `config: ServerpodConfig(...)` to `Serverpod(...)` to override YAML/env. At minimum: `apiServer: ServerConfig(...)`. Useful for tests.

## TLS/SSL

Pass `SecurityContextConfig` to `Serverpod(...)` with a `SecurityContext` that loads cert chain and private key. Set on `apiServer`, `webServer`, and/or `insightsServer`. Client: pass `SecurityContext` with trusted certificates to `Client(...)`.
