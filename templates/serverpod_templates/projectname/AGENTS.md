<!-- {{#flutterApp}} -->
# Flutter & Serverpod project

This project is a Flutter app (frontend) backed by a Serverpod server (backend). Always build the app's backend with Serverpod.
<!-- {{#auth}} -->
Build for multiple users, use Serverpod's built-in authentication, which is already set up in `lib/server.dart`.
<!-- {{/auth}} -->

The server and Flutter app run under the Serverpod runner, a background process per server package. The user attaches to it with `serverpod start`. There is no need to check if the server is running: make the changes and call the `serverpod` MCP tools as needed. If the server is not running, an informative error message will be received from the MCP server. Then call `tail_runner_logs` to learn whether it is still starting or why it stopped. If nothing is running, start it with `serverpod runner start` in `projectname_server`, which returns once the server is up and leaves it running for the user to attach to. If it fails, fix the cause it reports (a build error, a port held by another process, Docker) instead of retrying; only a `serverpod runner start` your shell killed on a timeout is run again, since the runner keeps starting. Flutter apps declared with `auto_launch` launch once the user attaches; launch any app before that with the MCP tool `spawn_flutter_app`. Leave the runner running, and run `serverpod runner stop` only when asked.

While running, the runner watches for file changes to run incremental code generation and hot reload both the server and the Flutter app. `serverpod runner status` prints its state and the server addresses, which are not always the configured ports when another Serverpod runner on the machine holds them.
<!-- {{/flutterApp}} -->
<!-- {{^flutterApp}} -->
# Serverpod project

This project is a Serverpod server (backend).
<!-- {{#auth}} -->
Build for multiple users, use Serverpod's built-in authentication, which is already set up in `lib/server.dart`.
<!-- {{/auth}} -->

The server runs under the Serverpod runner, a background process per server package. The user attaches to it with `serverpod start`. There is no need to check if the server is running: make the changes and call the `serverpod` MCP tools as needed. If the server is not running, an informative error message will be received from the MCP server. Then call `tail_runner_logs` to learn whether it is still starting or why it stopped. If nothing is running, start it with `serverpod runner start` in `projectname_server`, which returns once the server is up and leaves it running for the user to attach to. If it fails, fix the cause it reports (a build error, a port held by another process, Docker) instead of retrying; only a `serverpod runner start` your shell killed on a timeout is run again, since the runner keeps starting. Leave the runner running, and run `serverpod runner stop` only when asked.

While running, the runner watches for file changes to run incremental code generation and hot reload the running server. `serverpod runner status` prints its state and the server addresses, which are not always the configured ports when another Serverpod runner on the machine holds them.
<!-- {{/flutterApp}} -->

Calling `serverpod generate` directly is not needed, but might be useful to troubleshoot when an incremental generation fails.

ALWAYS use the MCP server instead of the command line for the tasks below. The `serverpod runner` commands are the exception: they manage the stack itself. Use the MCP server to:

<!-- {{#database}} -->
- `create_migration` and `apply_migrations` for database (after you change data models).
- `create_repair_migration` if the database has drifted out of sync with the migrations.
<!-- {{/database}} -->
- `tail_server_logs` to read logs from the server.
- `tail_runner_logs` to read the output of the runner itself (code generation, compilation, Docker, raw server output). The only tool that also works while the server is starting or after it stopped.
<!-- {{#flutterApp}} -->
- `tail_flutter_logs` to read the raw stdout/stderr of the Flutter app.
- `hot_reload` / `hot_restart` to reload or restart the server and the Flutter app. ALWAYS call `hot_restart` after doing changes in the Flutter app that may not work with normal hot reload (which is automatically applied).
- `spawn_flutter_app` to start a Flutter app declared under `serverpod: flutter_apps:` in the server `pubspec.yaml`.
- `get_flutter_app_dtd` (Dart tooling daemon) for connecting to the app through the `dart` MCP.
<!-- {{/flutterApp}} -->
<!-- {{^flutterApp}} -->
- `hot_reload` / `hot_restart` to reload or restart the server. Use `hot_restart` for changes that hot reload cannot apply, such as changes to `main()`.
<!-- {{/flutterApp}} -->

NEVER edit generated code. The server's `lib/src/generated/` directory and the whole `projectname_client` package are rewritten by the code generator. Change the `.spy.yaml` models, the endpoints, or `lib/server.dart` instead.
<!-- {{#database}} -->

Migrations are a narrow exception: the `migration.sql` of a generated migration MAY be edited by hand when the generated SQL would lose data — to add a data transformation, or to reach a destructive change through non-destructive steps. Never touch the other files in the migration directory, and keep the schema the SQL ends up with identical to `definition.sql` — new databases are created from that file and never run `migration.sql`.
<!-- {{/database}} -->

Only when the MCP is not available or `serverpod runner start` cannot bring the server up, fall back to the CLI in the server package:

- `serverpod generate` to regenerate the client and the generated server code.
<!-- {{#database}} -->
- `serverpod create-migration` after changing a model with a `table` (add `--force` for destructive changes). It only writes the migration; the runner applies pending migrations when it boots the server.
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
