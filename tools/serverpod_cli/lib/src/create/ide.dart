import 'package:serverpod_cli/src/create/copier.dart';

enum TemplateIde {
  antigravity(
    filePath: '.gemini/antigravity/mcp_config.json',
    config: _genericConfig,
    replacements: [
      Replacement(slotName: '"dart":', replacement: '"dart-mcp-server":'),
    ],
  ),
  codex(filePath: '.codex/config.toml', config: _codexConfig),
  cursor(filePath: '.cursor/mcp.json', config: _genericConfig),
  claude(filePath: '.mcp.json', config: _genericConfig),
  openCode(filePath: 'opencode.json', config: _openCodeConfig),
  vscode(
    filePath: '.vscode/mcp.json',
    config: _genericConfig,
    replacements: [
      Replacement(slotName: '"mcpServers":', replacement: '"servers":'),
    ],
  );

  const TemplateIde({
    required this.filePath,
    required this.config,
    this.replacements = const [],
  });

  /// Path where the config file for the IDE should be created,
  /// relative to the project root.
  final String filePath;

  /// The config content to be written to the IDE config file.
  final String config;

  /// Optional replacements to be applied to the config content before writing.
  final List<Replacement> replacements;
}

extension TemplateIdeExtension on TemplateIde {
  // Pinning the bridge to this project's server dir avoids walking up from cwd
  // at startup and disambiguates workspaces that contain multiple server
  // projects sharing one agent config.
  String effectiveConfig({required String serverDirRelative}) {
    String result = config.replaceAll(
      _serverDirRelativeSlot,
      serverDirRelative,
    );
    for (final replacement in replacements) {
      result = result.replaceAll(replacement.slotName, replacement.replacement);
    }
    return result;
  }
}

const _serverDirRelativeSlot = '{serverDirRelative}';

/// Generic MCP server config for IDEs.
const _genericConfig = '''{
  "mcpServers": {
    "serverpod": {
      "command": "serverpod",
      "args": ["mcp-server", "--server-dir", "{serverDirRelative}"]
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
      "command": ["serverpod", "mcp-server", "--server-dir", "{serverDirRelative}"],
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
args = ["mcp-server", "--server-dir", "{serverDirRelative}"]

[mcp_servers.dart_mcp]
command = "dart"
args = ["mcp-server", "--force-roots-fallback"]
''';
