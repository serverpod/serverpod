import 'package:serverpod_cli/src/create/copier.dart';

enum TemplateIde {
  antigravity(
    filePath: '.agents/mcp_config.json',
    config: _antigravityConfig,
    moduleConfig: _antigravityModuleConfig,
  ),
  codex(
    filePath: '.codex/config.toml',
    config: _codexConfig,
    moduleConfig: _codexModuleConfig,
  ),
  cursor(
    filePath: '.cursor/mcp.json',
    config: _genericConfig,
    moduleConfig: _genericModuleConfig,
  ),
  claude(
    filePath: '.mcp.json',
    config: _genericConfig,
    moduleConfig: _genericModuleConfig,
  ),
  openCode(
    filePath: 'opencode.json',
    config: _openCodeConfig,
    moduleConfig: _openCodeModuleConfig,
  ),
  vscode(
    filePath: '.vscode/mcp.json',
    config: _genericConfig,
    moduleConfig: _genericModuleConfig,
    replacements: [
      Replacement(slotName: '"mcpServers":', replacement: '"servers":'),
    ],
  ),
  ;

  const TemplateIde({
    required this.filePath,
    required this.config,
    required this.moduleConfig,
    this.replacements = const [],
  });

  /// Path where the config file for the IDE should be created,
  /// relative to the project root.
  final String filePath;

  /// The config content to be written to the IDE config file.
  final String config;

  /// The config content for module projects, which have no runnable server and
  /// therefore no Serverpod MCP server to talk to.
  final String moduleConfig;

  /// Optional replacements to be applied to the config content before writing.
  final List<Replacement> replacements;
}

extension TemplateIdeExtension on TemplateIde {
  // Pinning the bridge to this project's server dir avoids walking up from cwd
  // at startup and disambiguates workspaces that contain multiple server
  // projects sharing one agent config.
  String effectiveConfig({
    required String serverDirRelative,
    bool isModule = false,
  }) {
    String result = (isModule ? moduleConfig : config).replaceAll(
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

/// Generic MCP server config for IDEs in a module project. A module is not a
/// runnable server, so the Serverpod MCP server would have nothing to connect
/// to and every one of its tools would error.
const _genericModuleConfig = '''{
  "mcpServers": {
    "dart": {
      "command": "dart",
      "args": ["mcp-server"]
    }
  }
}
''';

/// MCP server config for Antigravity. The GUI app does not inherit the user's
/// shell PATH, so commands are resolved through a login shell.
const _antigravityConfig = '''{
  "mcpServers": {
    "serverpod": {
      "command": "/bin/zsh",
      "args": [
        "-l",
        "-c",
        "exec serverpod mcp-server --server-dir {serverDirRelative}"
      ],
      "cwd": "."
    },
    "dart-mcp-server": {
      "command": "/bin/zsh",
      "args": [
        "-l",
        "-c",
        "exec dart mcp-server"
      ],
      "cwd": "."
    }
  }
}
''';

/// MCP server config for Antigravity in a module project.
const _antigravityModuleConfig = '''{
  "mcpServers": {
    "dart-mcp-server": {
      "command": "/bin/zsh",
      "args": [
        "-l",
        "-c",
        "exec dart mcp-server"
      ],
      "cwd": "."
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

/// MCP server config for OpenCode in a module project.
const _openCodeModuleConfig = '''{
  "\$schema": "https://opencode.ai/config.json",
  "mcp": {
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

/// MCP server config for Codex in a module project.
const _codexModuleConfig = '''[mcp_servers.dart_mcp]
command = "dart"
args = ["mcp-server", "--force-roots-fallback"]
''';
