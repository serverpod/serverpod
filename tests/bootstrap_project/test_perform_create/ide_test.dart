import 'dart:io';

import 'package:bootstrap_project/src/util.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/create/ide.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:test/test.dart';

import 'util.dart';

void main() {
  final rootPath = p.join(Directory.current.path, '..', '..');
  final cliProjectPath = getServerpodCliProjectPath(rootPath: rootPath);

  setUpAll(() async {
    final pubGetProcess = await startProcess('dart', [
      'pub',
      'get',
    ], workingDirectory: cliProjectPath);
    assert(await pubGetProcess.exitCode == 0);
  });

  group(
    'Given a clean state, '
    'when calling performCreate with a context containing all supported IDEs',
    () {
      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(ides: TemplateIde.values),
      );

      test('then the created project has AGENTS.md', () {
        final agentsMd = File(p.join(project.projectRoot, 'AGENTS.md'));
        expect(agentsMd.existsSync(), isTrue);
        expect(agentsMd.readAsStringSync(), isNotEmpty);
      });

      test('then the created project has CLAUDE.md', () {
        final claudeMd = File(p.join(project.projectRoot, 'CLAUDE.md'));
        expect(claudeMd.existsSync(), isTrue);
        expect(claudeMd.readAsStringSync(), '@AGENTS.md\n');
      });

      test('then the created project has agent skills installed', () {
        expect(
          Directory(
            p.join(project.projectRoot, '.agents', 'skills'),
          ).existsSync(),
          isTrue,
        );
        expect(
          Directory(
            p.join(project.projectRoot, '.claude', 'skills'),
          ).existsSync(),
          isTrue,
        );
        expect(
          Directory(
            p.join(project.projectRoot, '.cursor', 'skills'),
          ).existsSync(),
          isTrue,
        );
        expect(
          Directory(
            p.join(project.projectRoot, '.opencode', 'skills'),
          ).existsSync(),
          isTrue,
        );
      });

      group(
        'then the created project',
        () {
          final serverDirRelative = '${project.name}_server';
          const antigravityPluginDir = '.agents/plugins/serverpod-local';
          final genericConfig =
              '''
{
  "mcpServers": {
    "serverpod": {
      "command": "serverpod",
      "args": ["mcp-server", "--server-dir", "$serverDirRelative"]
    },
    "dart": {
      "command": "dart",
      "args": ["mcp-server"]
    }
  }
}
''';

          test(
            'has Serverpod and Dart MCP servers configured for Antigravity',
            () {
              final config = File(
                p.join(
                  project.projectRoot,
                  '$antigravityPluginDir/mcp_config.json',
                ),
              );
              expect(config.existsSync(), isTrue);
              expect(
                config.readAsStringSync(),
                genericConfig.replaceAll('"dart":', '"dart-mcp-server":'),
              );
            },
          );

          test(
            'has an Antigravity plugin manifest registering the local plugin',
            () {
              final manifest = File(
                p.join(
                  project.projectRoot,
                  '$antigravityPluginDir/plugin.json',
                ),
              );
              expect(manifest.existsSync(), isTrue);
              expect(
                manifest.readAsStringSync(),
                '''{
  "name": "serverpod-local"
}
''',
              );
            },
          );

          test('has Serverpod and Dart MCP servers configured for Codex', () {
            final config = File(
              p.join(project.projectRoot, '.codex/config.toml'),
            );
            expect(config.existsSync(), isTrue);
            expect(
              config.readAsStringSync(),
              '''
[mcp_servers.serverpod]
command = "serverpod"
args = ["mcp-server", "--server-dir", "$serverDirRelative"]

[mcp_servers.dart_mcp]
command = "dart"
args = ["mcp-server", "--force-roots-fallback"]
''',
            );
          });

          test('has Serverpod and Dart MCP servers configured for Claude', () {
            final config = File(
              p.join(project.projectRoot, '.mcp.json'),
            );
            expect(config.existsSync(), isTrue);
            expect(config.readAsStringSync(), genericConfig);
          });

          test('has Serverpod and Dart MCP servers configured for Cursor', () {
            final config = File(
              p.join(project.projectRoot, '.cursor/mcp.json'),
            );
            expect(config.existsSync(), isTrue);
            expect(config.readAsStringSync(), genericConfig);
          });

          test(
            'has Serverpod and Dart MCP servers configured for OpenCode',
            () {
              final config = File(
                p.join(project.projectRoot, 'opencode.json'),
              );
              expect(config.existsSync(), isTrue);
              expect(
                config.readAsStringSync(),
                '''{
  "\$schema": "https://opencode.ai/config.json",
  "mcp": {
    "serverpod": {
      "type": "local",
      "command": ["serverpod", "mcp-server", "--server-dir", "$serverDirRelative"],
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
''',
              );
            },
          );

          test('has Serverpod and Dart MCP servers configured for VSCode', () {
            final config = File(
              p.join(project.projectRoot, '.vscode/mcp.json'),
            );
            expect(config.existsSync(), isTrue);
            expect(
              config.readAsStringSync(),
              genericConfig.replaceAll('mcpServers', 'servers'),
            );
          });
        },
      );
    },
  );
}
