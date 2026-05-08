enum TemplateIde {
  antigravity(
    filePath: '.gemini/antigravity/mcp_config.json',
    config: _genericConfig,
    replacements: [
      IdeConfigReplacement(from: '"dart":', to: '"dart-mcp-server":'),
    ],
  ),
  codex(filePath: '.codex/config.toml', config: _codexConfig),
  cursor(filePath: '.cursor/mcp.json', config: _genericConfig),
  claude(filePath: '.mcp.json', config: _genericConfig),
  openCode(filePath: '.opencode/opencode.json', config: _openCodeConfig),
  vscode(
    filePath: '.vscode/mcp.json',
    config: _genericConfig,
    replacements: [
      IdeConfigReplacement(from: '"mcpServers":', to: '"servers":'),
    ],
  )
  ;

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
  final List<IdeConfigReplacement> replacements;
}

/// A replacement to be applied to the IDE config content.
class IdeConfigReplacement {
  const IdeConfigReplacement({required this.from, required this.to});

  final String from;
  final String to;
}

/// Generic MCP server config for IDEs.
const _genericConfig = '''{
  "mcpServers": {
    "serverpod": {
      "command": "serverpod",
      "args": ["mcp"]
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
      "command": ["serverpod","mcp"],
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
args = ["mcp"]

[mcp_servers.dart_mcp]
command = "dart"
args = ["mcp-server", "--force-roots-fallback"]
''';
