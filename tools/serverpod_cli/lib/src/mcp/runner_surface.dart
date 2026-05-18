/// MCP tools and resources exposed by `serverpod start --watch`.
library;

import 'package:dart_mcp/server.dart';

final Tool applyMigrationsTool = Tool(
  name: 'apply_migrations',
  description:
      'Apply pending database migrations. The server restarts with '
      '`--apply-migrations`. Call after `create_migration` (or '
      '`serverpod create-migration`) has written the migration files.',
  inputSchema: Schema.object(),
);

final Tool createMigrationTool = Tool(
  name: 'create_migration',
  description:
      'Create a new database migration from the current model definitions. '
      'Writes the migration files to disk; does not restart the server or '
      'apply the migration. Follow up with `apply_migrations` to run it '
      'against the database.',
  inputSchema: Schema.object(
    properties: {
      'tag': Schema.string(
        description: 'Optional tag appended to the migration version name.',
      ),
      'force': Schema.bool(
        description:
            'Create the migration even if warnings are present (data may '
            'be destroyed).',
      ),
    },
  ),
);

final Tool hotReloadTool = Tool(
  name: 'hot_reload',
  description:
      'Recompile the server kernel and hot-reload the running isolate. '
      'Falls back to a full restart if reload is not possible.',
  inputSchema: Schema.object(),
);

final Tool tailLogsTool = Tool(
  name: 'tail_logs',
  description:
      'Return recent log entries from the running watch session '
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
      'across hot reloads; changes on restart (apply_migrations, crash '
      'recovery). Subscribe to be notified when the URI changes.',
  mimeType: 'application/json',
);

final List<Tool> runnerStaticTools = [
  applyMigrationsTool,
  createMigrationTool,
  hotReloadTool,
  tailLogsTool,
];

final List<Resource> runnerStaticResources = [vmServiceResource];
