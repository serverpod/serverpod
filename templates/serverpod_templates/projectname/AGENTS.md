<!-- {{#flutterApp}} -->
# Flutter & Serverpod project

This project is a Flutter app (frontend) backed by a Serverpod server (backend). Always build the app's backend with Serverpod.
<!-- {{#auth}} -->
Build for multiple users, use Serverpod's built-in authentication, which is already set up in `lib/server.dart`.
<!-- {{/auth}} -->

The user starts the server and Flutter app with `serverpod start`. There is no need to check if the server is running: make the changes and call the `serverpod` MCP tools as needed. If the server is not running, an informative error message will be received from the MCP server. Then STOP and ask the user to start the server manually, or ask for permission to start it yourself with `serverpod start --no-tui` — that command runs until it is stopped, so start it in the background and keep working. NEVER start the server without asking first. The Flutter app is started along with it, or can be launched from the MCP tool `spawn_flutter_app`.

While running, `serverpod start` watches for file changes to run incremental code generation and hot reload both the server and the Flutter app.
<!-- {{/flutterApp}} -->
<!-- {{^flutterApp}} -->
# Serverpod project

This project is a Serverpod server (backend).
<!-- {{#auth}} -->
Build for multiple users, use Serverpod's built-in authentication, which is already set up in `lib/server.dart`.
<!-- {{/auth}} -->

The user starts the server with `serverpod start`. There is no need to check if the server is running: make the changes and call the `serverpod` MCP tools as needed. If the server is not running, an informative error message will be received from the MCP server. Then STOP and ask the user to start the server manually, or ask for permission to start it yourself with `serverpod start --no-tui` — that command runs until it is stopped, so start it in the background and keep working. NEVER start the server without asking first.

While running, `serverpod start` watches for file changes to run incremental code generation and hot reload the running server.
<!-- {{/flutterApp}} -->

Calling `serverpod generate` directly is not needed, but might be useful to troubleshoot when an incremental generation fails.

ALWAYS use the MCP server instead of the command line. Use the MCP server to:

<!-- {{#database}} -->
- `create_migration` and `apply_migrations` for database (after you change data models).
- `create_repair_migration` if the database has drifted out of sync with the migrations.
<!-- {{/database}} -->
- `tail_server_logs` to read logs from the server.
<!-- {{#flutterApp}} -->
- `tail_flutter_logs` to read the raw stdout/stderr of the Flutter app.
- `hot_reload` / `hot_restart` to reload or restart the server and the Flutter app. ALWAYS call `hot_restart` after doing changes in the Flutter app that may not work with normal hot reload (which is automatically applied).
- `spawn_flutter_app` to start a Flutter app declared under `serverpod: flutter_apps:` in the server `pubspec.yaml`.
- `get_flutter_app_dtd` (Dart tooling daemon) for connecting to the app through the `dart` MCP.
<!-- {{/flutterApp}} -->
<!-- {{^flutterApp}} -->
- `hot_reload` / `hot_restart` to reload or restart the server. Use `hot_restart` for changes that hot reload cannot apply, such as changes to `main()`.
<!-- {{/flutterApp}} -->
<!-- {{#skills}} -->

Serverpod agent skills are installed in this project. They cover models, migrations, the database ORM, endpoints, streams, authentication, testing, configuration and the web server — read the skill that matches the task before writing Serverpod code, starting with `serverpod-overview`.
<!-- {{/skills}} -->

NEVER edit generated code. The server's `lib/src/generated/` directory and the whole `projectname_client` package are rewritten by the code generator. Change the `.spy.yaml` models, the endpoints, or `lib/server.dart` instead.
<!-- {{#database}} -->

Migrations are the exception: the `migration.sql` of a generated migration MAY be edited by hand, for example to add a data transformation, or to reach a destructive change through non-destructive steps. Leave the other files in the migration directory alone, and keep the schema that the SQL ends up with identical to `definition.sql` — new databases are created from that file and never run `migration.sql`.
<!-- {{/database}} -->

Only when the server cannot be started at all, fall back to the CLI in the server package:

- `serverpod generate` to regenerate the client and the generated server code.
<!-- {{#database}} -->
- `serverpod create-migration` after changing a model with a `table` (add `--force` for destructive changes). It only writes the migration; `serverpod start` applies pending migrations when it boots the server.
<!-- {{/database}} -->

<!-- {{#postgres}} -->
Tests need no Docker. `config/test.yaml` sets `database.dataPath`, so Serverpod starts and manages the test database (an embedded PostgreSQL) itself, and the project's `docker-compose.yaml` is not used for it. Just run `dart test` in the server package.

<!-- {{/postgres}} -->
<!-- {{#sqlite}} -->
Tests need no database server. `config/test.yaml` points at a SQLite file that Serverpod creates itself. Just run `dart test` in the server package.

<!-- {{/sqlite}} -->
Checklist after doing changes, in this order:

- `dart analyze` (CLI)
- `dart format` (CLI)
<!-- {{#database}} -->
- `create_migration` and `apply_migrations` (MCP - only if necessary)
<!-- {{/database}} -->
<!-- {{#flutterApp}} -->
- Do `serverpod` MCP `hot_restart` if required (hot reload is done automatically). Will also hot restart Flutter app
- Run tests, if applicable (`dart test` in the server package)
- Check `serverpod` MCP `tail_server_logs` and `tail_flutter_logs` for any issues.

If the user asks you to test the app:

1. Use `get_flutter_app_dtd` (`serverpod` MCP) to get the Flutter app's DTD
2. Pass the DTD to `connect_dart_tooling_daemon` (`dart` MCP) to connect to the app
3. Use `flutter_driver` (`dart` MCP) to navigate through the app

The app is launched from `projectname_flutter/lib/driver.dart`, which starts the Flutter driver extension with text entry emulation turned off so the app stays usable by hand. To let the driver type, set `enableTextEntryEmulation: true` there and `hot_restart` the app.
<!-- {{/flutterApp}} -->
<!-- {{^flutterApp}} -->
- Do `serverpod` MCP `hot_restart` if required (hot reload is done automatically)
- Run tests, if applicable (`dart test` in the server package)
- Check `serverpod` MCP `tail_server_logs` for any issues.
<!-- {{/flutterApp}} -->

IMPORTANT: After building the first version of the app, update this AGENTS.md file with information about the app we're building. KEEP the info about the MCP server and the checklist. Remove this paragraph.
