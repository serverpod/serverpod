import 'dart:io';

import 'package:bootstrap_project/src/util.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/ide.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

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
      final projectName =
          'temp_test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';

      setUpAll(() async {
        setupForPerformCreateTest();

        await performCreate(
          projectName,
          false,
          interactive: false,
          context: TemplateContext(ides: TemplateIde.values),
        );
      });

      tearDownAll(() {
        final dir = Directory(projectName);
        try {
          dir.delete(recursive: true);
        } on FileSystemException {
          // Gone.
        }
      });

      test('then the created project has AGENTS.md', () {
        final agentsMd = File(p.join(projectName, 'AGENTS.md'));
        expect(agentsMd.existsSync(), isTrue);
        expect(agentsMd.readAsStringSync(), isNotEmpty);
      });

      test('then the created project has CLAUDE.md', () {
        final claudeMd = File(p.join(projectName, 'CLAUDE.md'));
        expect(claudeMd.existsSync(), isTrue);
        expect(claudeMd.readAsStringSync(), '@AGENTS.md\n');
      });

      test('then the created project has agent skills installed', () {
        expect(
          Directory(p.join(projectName, '.agents', 'skills')).existsSync(),
          isTrue,
        );
        expect(
          Directory(p.join(projectName, '.claude', 'skills')).existsSync(),
          isTrue,
        );
        expect(
          Directory(p.join(projectName, '.cursor', 'skills')).existsSync(),
          isTrue,
        );
        expect(
          Directory(p.join(projectName, '.opencode', 'skills')).existsSync(),
          isTrue,
        );
      });

      group(
        'then the created project',
        () {
          final serverDirRelative = '${projectName}_server';
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
                p.join(projectName, '.gemini/antigravity/mcp_config.json'),
              );
              expect(config.existsSync(), isTrue);
              expect(
                config.readAsStringSync(),
                genericConfig.replaceAll('"dart":', '"dart-mcp-server":'),
              );
            },
          );

          test('has Serverpod and Dart MCP servers configured for Codex', () {
            final config = File(p.join(projectName, '.codex/config.toml'));
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
            final config = File(p.join(projectName, '.mcp.json'));
            expect(config.existsSync(), isTrue);
            expect(config.readAsStringSync(), genericConfig);
          });

          test('has Serverpod and Dart MCP servers configured for Cursor', () {
            final config = File(p.join(projectName, '.cursor/mcp.json'));
            expect(config.existsSync(), isTrue);
            expect(config.readAsStringSync(), genericConfig);
          });

          test(
            'has Serverpod and Dart MCP servers configured for OpenCode',
            () {
              final config = File(
                p.join(projectName, '.opencode/opencode.json'),
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
            final config = File(p.join(projectName, '.vscode/mcp.json'));
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
