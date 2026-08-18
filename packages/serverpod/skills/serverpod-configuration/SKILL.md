---
name: serverpod-configuration
description: Configure Serverpod — YAML config, environment variables, passwords, run modes, generator.yaml, TLS. Use when setting up environments, API/database/Redis settings, managing secrets or overriding configurations for tests.
---

# Serverpod Configuration

Priority (highest wins): **Dart config object** > **environment variables** > **YAML config files**. The config uses YAML files that live in `config/`. Secrets are in `config/passwords.yaml` or env vars with `SERVERPOD_PASSWORD_` prefix.

## Run mode

Config files by mode: `config/development.yaml`, `config/staging.yaml`, `config/production.yaml`, `config/test.yaml`. Set via `--mode` when starting server or `SERVERPOD_RUN_MODE` (default: `development`).

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

It is possible to use either PostgreSQL or SQLite as the database.

### PostgreSQL

```yaml
database:
  host: localhost
  port: 8090
  name: my_project
  user: postgres
  dataPath: .serverpod/development/pgdata  # embedded database, see below
```

Password in `passwords.yaml` under run mode or `SERVERPOD_PASSWORD_database`. Optional: `searchPaths`, `maxConnectionCount`, `requireSsl`, `isUnixSocket`.

**Embedded PostgreSQL:** with `dataPath` set, Serverpod launches and manages a PostgreSQL instance in that directory, so nothing has to be installed or run separately. New projects use it for development and testing. `serverpod database start [--mode <mode>] [--port <port>]` boots the same database on its own, without the server.

Without `dataPath` the database is external, and `serverpod start` starts Docker Compose services when the project has a compose file and PostgreSQL is on localhost (`--docker` / `--no-docker` override this).

### SQLite

```yaml
database:
  filePath: my_project.sqlite
```

No password is needed for SQLite.

## Redis

`redis.enabled`, `redis.host`, `redis.port`; password via `SERVERPOD_PASSWORD_redis`.

## Secrets (passwords.yaml)

Structure: `shared:` (all modes) + per-mode (`development:`, `production:`, etc.). Built-in keys: `database`, `redis`, `serviceSecret`. Custom keys available via `session.passwords['key']` or `pod.getPassword('key')`.

The built-in passwords also have dedicated environment variables: `SERVERPOD_DATABASE_PASSWORD`, `SERVERPOD_REDIS_PASSWORD` and `SERVERPOD_SERVICE_SECRET`. Any password, built-in or custom, can also be set with the `SERVERPOD_PASSWORD_` prefix.

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

Pass `config: ServerpodConfig(...)` to `Serverpod(...)` to skip file/env loading and use a Dart config object, with CLI flags still merged in.

For tests, it is possible to use `configOverride: (config) => config.copyWith(...)` to adjust the loaded config after YAML/env/CLI processing.

## TLS/SSL

Pass `SecurityContextConfig` to `Serverpod(...)` with a `SecurityContext` that loads cert chain and private key. Set on `apiServer`, `webServer`, and/or `insightsServer`. Client: pass `SecurityContext` with trusted certificates to `Client(...)`.

## Reference files

- [`references/environment-variables.md`](references/environment-variables.md) — the full `SERVERPOD_*` environment variable table.
- [`references/flutter-apps.md`](references/flutter-apps.md) — declaring the Flutter apps that `serverpod start` can launch.
