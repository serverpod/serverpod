/// MCP tools and resources exposed by `serverpod start`.
library;

import 'package:dart_mcp/server.dart';

final Tool applyMigrationsTool = Tool(
  name: 'apply_migrations',
  description:
      'Apply pending database migrations without restarting the server. '
      'Call after creating a migration.',
  inputSchema: Schema.object(),
);

final Tool createMigrationTool = Tool(
  name: 'create_migration',
  description:
      'Create a new database migration from the current model definitions. '
      'Only writes the migration files to disk, without applying to the '
      'database. Follow up with `apply_migrations` to apply the changes.',
  inputSchema: Schema.object(
    properties: {
      'tag': Schema.string(
        description: 'Optional tag appended to the migration version name.',
      ),
      'force': Schema.bool(
        description:
            'Create the migration even if warnings are present (data may '
            'be destroyed). Required for destructive migrations.',
      ),
    },
  ),
);

final Tool createRepairMigrationTool = Tool(
  name: 'create_repair_migration',
  description:
      'Create a repair migration that brings the live database in line '
      'with the target migration version (default: latest). Connects to '
      'the running server to read the live schema, diffs it against the '
      'target, and writes a `.sql` repair file. Use when a migration was '
      'partially applied or the database drifted out of sync. Does not '
      'apply the migration; follow up with `apply_migrations`.',
  inputSchema: Schema.object(
    properties: {
      'tag': Schema.string(
        description:
            'Optional tag appended to the repair migration version name.',
      ),
      'force': Schema.bool(
        description:
            'Create the repair migration even when warnings are present '
            'or when no schema drift is detected (data may be destroyed).',
      ),
      'version': Schema.string(
        description:
            'Optional target migration version to repair against. '
            'Defaults to the latest migration version.',
      ),
    },
  ),
);

final Tool hotReloadTool = Tool(
  name: 'hot_reload',
  description:
      'Hot-reload the running server isolate, preserving in-memory state. '
      'Falls back to a restart if reload is not possible. In `--watch` '
      'mode the runner auto-reloads on file changes, so this is mainly '
      'useful with `--no-watch`.',
  inputSchema: Schema.object(),
);

final Tool hotRestartTool = Tool(
  name: 'hot_restart',
  description:
      'Restart the running server process, dropping all in-memory state. '
      'Use when reload would not suffice (e.g. `main()` changes) or to '
      'recover a stuck isolate.',
  inputSchema: Schema.object(),
);

final Tool tailLogsTool = Tool(
  name: 'tail_server_logs',
  description:
      'Return recent log entries from the running server '
      '(structured log entries plus completed operations). Newest last.',
  inputSchema: Schema.object(
    properties: {
      'limit': Schema.int(
        description: 'Max entries to return (default 200, max 10000).',
        minimum: 1,
        maximum: 10000,
      ),
    },
  ),
);

/// Shared [`appId`] parameter description for Flutter MCP tools.
const _flutterAppIdDescription =
    'Which Flutter app to target. The id is the map key on the server pubspec '
    'under `serverpod: flutter_apps:`. Ids are case-sensitive; pass the key '
    'exactly as written. Optional when only one app is configured. When '
    'multiple apps are configured and no `appId` is provided, the tool '
    'returns an error listing available ids.';

final Tool tailFlutterLogsTool = Tool(
  name: 'tail_flutter_logs',
  description:
      'Return recent raw stdout/stderr lines for a Flutter app started from '
      '`serverpod start`, newest last.',
  inputSchema: Schema.object(
    properties: {
      'limit': Schema.int(
        description: 'Max lines to return (default 200, max 10000).',
        minimum: 1,
        maximum: 10000,
      ),
      'appId': Schema.string(
        description: _flutterAppIdDescription,
      ),
    },
  ),
);

final Tool spawnFlutterAppTool = Tool(
  name: 'spawn_flutter_app',
  description:
      'Start a Flutter app configured under `serverpod: flutter_apps:` in the '
      'server pubspec.yaml. No-op if the app is already running.',
  inputSchema: Schema.object(
    properties: {
      'appId': Schema.string(
        description: _flutterAppIdDescription,
      ),
    },
  ),
);

final Tool getFlutterAppDtdTool = Tool(
  name: 'get_flutter_app_dtd',
  description:
      'Return the Dart Tooling Daemon (DTD) URI for Flutter apps started from '
      '`serverpod start`. The JSON object is keyed by app id — the same ids '
      'used as keys under `serverpod: flutter_apps:` in the server pubspec. '
      'Apps that have not been launched are absent from the map; apps that '
      'have not published their DTD yet map to null; apps that have published '
      'their DTD map to their DTD URI.',
  inputSchema: Schema.object(),
);

final Resource vmServiceResource = Resource(
  uri: 'serverpod://vm-service',
  name: 'VM service',
  description:
      'Dart VM service HTTP URI for the running server isolate. Stable '
      'across hot reloads; changes on restart (e.g. `hot_restart` or '
      'crash recovery). Subscribe to be notified when the URI changes.',
  mimeType: 'application/json',
);

final List<Tool> runnerStaticTools = [
  applyMigrationsTool,
  createMigrationTool,
  createRepairMigrationTool,
  hotReloadTool,
  hotRestartTool,
  tailLogsTool,
  tailFlutterLogsTool,
  spawnFlutterAppTool,
  getFlutterAppDtdTool,
];

final List<Resource> runnerStaticResources = [vmServiceResource];
