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
  name: 'tail_logs',
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
  hotReloadTool,
  hotRestartTool,
  tailLogsTool,
];

final List<Resource> runnerStaticResources = [vmServiceResource];
