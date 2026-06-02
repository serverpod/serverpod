# Flutter & Serverpod project

This is a newly created Flutter (frontend) & Serverpod (backend) project. Always build a backend for the app using Serverpod. If it make sense, add support for multiple users (using Serverpod's built in authentication).

The user starts the server and Flutter app with `serverpod start`. NEVER start the server yourself, instead STOP and ask the user to start it. When the server is running, interact with it through the `serverpod` MCP. `serverpod start` automatically handles hot reload for both the server and the app (as soon as files change).

ALWAYS use the MCP server instead of the command line. Use the MCP server to:

- `create_migration` and `apply_migrations` for database (after you change data models).
- `tail_server_logs` to read logs from the server.
- `tail_flutter_logs` to read raw stdout/stderr from the Flutter app.
- `hot_restart` will reload the server and the Flutter app. ALWAYS call it after doing changes in the Flutter app that may not work with normal hot reload (which is automatically applied).
- Fetch the Flutter app's DTD (Dart tooling daemon) for connecting to the app through the `dart` MCP.

Checklist after doing changes:

1. `dart analyze` (`dart` MCP)
2. `dart format` (`dart` MCP)
3. `create_migration` and `apply_migrations` (only if neccessary)
4. Do `serverpod` MCP `hot_restart` if required (hot reload is done automatically). Will also hot restart Flutter app
5. Run tests, if applicable (`dart` MCP)
6. Check `serverpod` MCP `tail_server_logs` and `tail_flutter_logs` for any issues.

If the user asks you to test the app:

1. Retrieve the DTD from `serverpod` MCP
2. Use `flutter_driver` (`dart` MCP) to navigate the app

IMPORTANT: After building the first version of the app, update this AGENTS.md file with information about the app we're building. KEEP the info about the MCP server and the checklist. Remove this paragraph.
