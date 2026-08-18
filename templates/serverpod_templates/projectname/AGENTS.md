<!-- {{#flutterApp}} -->
# Flutter & Serverpod project

This is a newly created Flutter (frontend) & Serverpod (backend) project. Always build a backend for the app using Serverpod. If it make sense, add support for multiple users (using Serverpod's built in authentication).

The user starts the server and Flutter app with `serverpod start`. NEVER start the server yourself, instead STOP and ask the user to start it. When the server is running, interact with it through the `serverpod` MCP. `serverpod start` automatically handles hot reload for both the server and the app (as soon as files change).
<!-- {{/flutterApp}} -->
<!-- {{^flutterApp}} -->
# Serverpod project

This is a newly created Serverpod (backend) project. If it make sense, add support for multiple users (using Serverpod's built in authentication).

The user starts the server with `serverpod start`. NEVER start the server yourself, instead STOP and ask the user to start it. When the server is running, interact with it through the `serverpod` MCP. `serverpod start` automatically handles hot reload for the server (as soon as files change).
<!-- {{/flutterApp}} -->

ALWAYS use the MCP server instead of the command line. Use the MCP server to:

- `create_migration` and `apply_migrations` for database (after you change data models).
- `create_repair_migration` if the database has drifted out of sync with the migrations.
- `tail_server_logs` to read logs from the server.
<!-- {{#flutterApp}} -->
- `tail_flutter_logs` to read raw stdout/stderr from the Flutter app.
- `hot_reload` / `hot_restart` to reload or restart the server and the Flutter app. ALWAYS call `hot_restart` after doing changes in the Flutter app that may not work with normal hot reload (which is automatically applied).
- `spawn_flutter_app` to start a Flutter app declared under `serverpod: flutter_apps:` in the server `pubspec.yaml`.
- `get_flutter_app_dtd` (Dart tooling daemon) for connecting to the app through the `dart` MCP.
<!-- {{/flutterApp}} -->
<!-- {{^flutterApp}} -->
- `hot_reload` / `hot_restart` to reload or restart the server. Use `hot_restart` for changes that hot reload cannot apply, such as changes to `main()`.
<!-- {{/flutterApp}} -->

Checklist after doing changes:

1. `dart analyze` (CLI)
2. `dart format` (CLI)
3. `create_migration` and `apply_migrations` (MCP - only if necessary)
<!-- {{#flutterApp}} -->
4. Do `serverpod` MCP `hot_restart` if required (hot reload is done automatically). Will also hot restart Flutter app
5. Run tests, if applicable (`dart` CLI)
6. Check `serverpod` MCP `tail_server_logs` and `tail_flutter_logs` for any issues.

If the user asks you to test the app:

1. Use `get_flutter_app_dtd` (`serverpod` MCP) to get the Flutter app's DTD
2. Pass the DTD to `connect_dart_tooling_daemon` (`dart` MCP) to connect to the app
3. Use `flutter_driver` (`dart` MCP) to navigate through the app
<!-- {{/flutterApp}} -->
<!-- {{^flutterApp}} -->
4. Do `serverpod` MCP `hot_restart` if required (hot reload is done automatically)
5. Run tests, if applicable (`dart` CLI)
6. Check `serverpod` MCP `tail_server_logs` for any issues.
<!-- {{/flutterApp}} -->

IMPORTANT: After building the first version of the app, update this AGENTS.md file with information about the app we're building. KEEP the info about the MCP server and the checklist. Remove this paragraph.
