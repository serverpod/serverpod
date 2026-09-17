import 'dart:io';

import 'package:serverpod_cli/src/create/copier.dart';

enum TemplateIde {
  antigravity(
    filePath: '.agents/mcp_config.json',
    config: _antigravityConfig,
    moduleConfig: _antigravityModuleConfig,
    windowsConfig: _antigravityWindowsConfig,
    windowsModuleConfig: _antigravityWindowsModuleConfig,
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
    this.windowsConfig,
    this.windowsModuleConfig,
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

  /// Replaces [config] when creating the project on Windows.
  final String? windowsConfig;

  /// Replaces [moduleConfig] when creating the project on Windows.
  final String? windowsModuleConfig;
}

extension TemplateIdeExtension on TemplateIde {
  // Pinning the bridge to this project's server dir avoids walking up from cwd
  // at startup and disambiguates workspaces that contain multiple server
  // projects sharing one agent config.
  String effectiveConfig({
    required String serverDirRelative,
    bool isModule = false,
    bool? isWindows,
  }) {
    final onWindows = isWindows ?? Platform.isWindows;
    final template = isModule
        ? (onWindows ? windowsModuleConfig : null) ?? moduleConfig
        : (onWindows ? windowsConfig : null) ?? config;
    String result = template.replaceAll(
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

/// Shell script that runs its first argument through the user's login shell,
/// so PATH entries from shell profiles apply even when the IDE was started
/// from the desktop. Falls back to /bin/sh when $SHELL is unset or not
/// executable, and for csh-family shells, which reject `-l -c`. Quotes are
/// escaped for embedding in a JSON string.
const _loginShellScript =
    r's=${SHELL:-/bin/sh}; [ -x \"$s\" ] || s=/bin/sh; '
    r'case $s in *csh) s=/bin/sh;; esac; exec \"$s\" -l -c \"$1\"';

/// MCP server config for Antigravity on macOS and Linux.
const _antigravityConfig =
    '''{
  "mcpServers": {
    "serverpod": {
      "command": "/bin/sh",
      "args": [
        "-c",
        "$_loginShellScript",
        "sh",
        "exec serverpod mcp-server --server-dir {serverDirRelative}"
      ],
      "cwd": "."
    },
    "dart-mcp-server": {
      "command": "/bin/sh",
      "args": [
        "-c",
        "$_loginShellScript",
        "sh",
        "exec dart mcp-server"
      ],
      "cwd": "."
    }
  }
}
''';

/// MCP server config for Antigravity on macOS and Linux in a module project.
const _antigravityModuleConfig =
    '''{
  "mcpServers": {
    "dart-mcp-server": {
      "command": "/bin/sh",
      "args": [
        "-c",
        "$_loginShellScript",
        "sh",
        "exec dart mcp-server"
      ],
      "cwd": "."
    }
  }
}
''';

/// MCP server config for Antigravity on Windows, where GUI apps inherit PATH
/// from the registry and need no shell wrapper.
const _antigravityWindowsConfig = '''{
  "mcpServers": {
    "serverpod": {
      "command": "serverpod",
      "args": ["mcp-server", "--server-dir", "{serverDirRelative}"],
      "cwd": "."
    },
    "dart-mcp-server": {
      "command": "dart",
      "args": ["mcp-server"],
      "cwd": "."
    }
  }
}
''';

/// MCP server config for Antigravity on Windows in a module project.
const _antigravityWindowsModuleConfig = '''{
  "mcpServers": {
    "dart-mcp-server": {
      "command": "dart",
      "args": ["mcp-server"],
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
