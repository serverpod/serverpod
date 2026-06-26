import 'package:serverpod_cli/src/create/copier.dart';

enum TemplateIde {
  antigravity(
    filePath: '$_antigravityPluginDir/mcp_config.json',
    config: _genericConfig,
    replacements: [
      // The Antigravity ecosystem names the Dart MCP server "dart-mcp-server",
      // so reuse key to avoid duplicates.
      Replacement(slotName: '"dart":', replacement: '"dart-mcp-server":'),
    ],
    // Antigravity discovers project-local MCP config through its plugin system.
    additionalFiles: {
      '$_antigravityPluginDir/plugin.json': _antigravityPluginManifest,
    },
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
  )
  ;

  const TemplateIde({
    required this.filePath,
    required this.config,
    this.replacements = const [],
    this.additionalFiles = const {},
  });

  /// Path where the config file for the IDE should be created,
  /// relative to the project root.
  final String filePath;

  /// The config content to be written to the IDE config file.
  final String config;

  /// Optional replacements to be applied to the config content before writing.
  final List<Replacement> replacements;

  /// Additional files to write alongside [filePath], keyed by their project-root-relative path.
  /// Content goes through the same [TemplateIdeExtension.render] pipeline as [config].
  final Map<String, String> additionalFiles;
}

extension TemplateIdeExtension on TemplateIde {
  // Pinning the bridge to this project's server dir avoids walking up from cwd
  // at startup and disambiguates workspaces that contain multiple server
  // projects sharing one agent config.
  String effectiveConfig({required String serverDirRelative}) =>
      render(config, serverDirRelative: serverDirRelative);

  /// Renders [content] with the server dir slot and this IDE's [replacements].
  String render(String content, {required String serverDirRelative}) {
    String result = content.replaceAll(
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

/// Folder holding the generated Antigravity plugin. The folder name and the
/// manifest "name" must match for Antigravity to index the plugin!
const _antigravityPluginDir = '.agents/plugins/$_antigravityPluginName';
const _antigravityPluginName = 'serverpod-local';

/// Marker that registers the generated folder as an Antigravity plugin so its
/// sibling mcp_config.json is ingested.
const _antigravityPluginManifest =
    '''{
  "name": "$_antigravityPluginName"
}
''';

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
