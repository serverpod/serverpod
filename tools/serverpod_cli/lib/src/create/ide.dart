import 'package:serverpod_cli/src/create/copier.dart';

enum TemplateIde {
  // Antigravity reads MCP servers from config file in the user's home directory
  // and has no per-project config.
  // See https://github.com/serverpod/serverpod/issues/5220.
  antigravity(
    displayName: 'Antigravity',
    globalConfigPath: '~/.gemini/config/mcp_config.json',
    config: _genericConfig,
    replacements: [
      Replacement(slotName: '"dart":', replacement: '"dart-mcp-server":'),
    ],
  ),
  codex(
    displayName: 'Codex',
    filePath: '.codex/config.toml',
    config: _codexConfig,
  ),
  cursor(
    displayName: 'Cursor',
    filePath: '.cursor/mcp.json',
    config: _genericConfig,
  ),
  claude(
    displayName: 'Claude',
    filePath: '.mcp.json',
    config: _genericConfig,
  ),
  openCode(
    displayName: 'OpenCode',
    filePath: 'opencode.json',
    config: _openCodeConfig,
  ),
  vscode(
    displayName: 'VS Code',
    filePath: '.vscode/mcp.json',
    config: _genericConfig,
    replacements: [
      Replacement(slotName: '"mcpServers":', replacement: '"servers":'),
    ],
  )
  ;

  const TemplateIde({
    required this.displayName,
    required this.config,
    this.filePath,
    this.globalConfigPath,
    this.replacements = const [],
  }) : assert(
         filePath != null || globalConfigPath != null,
         'An IDE must have either a project-local filePath or a '
         'globalConfigPath.',
       );

  /// Human-readable name of the IDE, used in setup instructions.
  final String displayName;

  /// Path where the config file for the IDE should be created,
  /// relative to the project root. Null for IDEs that only support a global
  /// config (see [globalConfigPath]).
  final String? filePath;

  /// Path of the IDE's global MCP config file in the user's home directory,
  /// for IDEs that don't support per-project config. When set, no project file
  /// is written and the CLI prints setup instructions instead.
  final String? globalConfigPath;

  /// The config content to be written to the IDE config file.
  final String config;

  /// Optional replacements to be applied to the config content before writing.
  final List<Replacement> replacements;

  /// Whether this IDE only supports a global config file and therefore needs
  /// manual setup rather than a generated project-local file.
  bool get usesGlobalConfig => globalConfigPath != null && filePath == null;
}

extension TemplateIdeExtension on TemplateIde {
  // Pinning the bridge to this project's server dir avoids walking up from cwd
  // at startup and disambiguates workspaces that contain multiple server
  // projects sharing one agent config. Project-local configs use a path
  // relative to the project root; global configs use an absolute path.
  String effectiveConfig({required String serverDir}) {
    String result = config.replaceAll(_serverDirSlot, serverDir);
    for (final replacement in replacements) {
      result = result.replaceAll(replacement.slotName, replacement.replacement);
    }
    return result;
  }
}

const _serverDirSlot = '{serverDir}';

/// Generic MCP server config for IDEs.
const _genericConfig = '''{
  "mcpServers": {
    "serverpod": {
      "command": "serverpod",
      "args": ["mcp-server", "--server-dir", "{serverDir}"]
    },
    "dart": {
      "command": "dart",
      "args": ["mcp-server"]
    }
  }
}
''';

/// MCP server config for OpenCode.
const _openCodeConfig = '''{
  "\$schema": "https://opencode.ai/config.json",
  "mcp": {
    "serverpod": {
      "type": "local",
      "command": ["serverpod", "mcp-server", "--server-dir", "{serverDir}"],
      "enabled": true
    },
    "dart-mcp-server": {
      "type": "local",
      "command": [
        "dart",
        "mcp-server"
      ],
      "enabled": true,
      "environment": {}
    }
  }
}
''';

/// MCP server config for Codex.
const _codexConfig = '''[mcp_servers.serverpod]
command = "serverpod"
args = ["mcp-server", "--server-dir", "{serverDir}"]

[mcp_servers.dart_mcp]
command = "dart"
args = ["mcp-server", "--force-roots-fallback"]
''';
