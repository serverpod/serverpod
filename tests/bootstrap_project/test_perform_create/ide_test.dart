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
          'test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}';

      setUpAll(() async {
        setupForPerformCreateTest();

        final context = TemplateContext(ides: TemplateIde.values);

        await performCreate(
          projectName,
          ServerpodTemplateType.server,
          false,
          interactive: false,
          context: context,
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
          Directory(p.join(projectName, '.opencode', 'skills')).existsSync(),
          isTrue,
        );
      });

      group(
        'then the created project has Serverpod and Dart MCP servers configured',
        () {
          final genericConfig = '''
{
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

          test('for Antigravity', () {
            final config = File(
              p.join(projectName, '.gemini/antigravity/mcp_config.json'),
            );
            expect(config.existsSync(), isTrue);
            expect(
              config.readAsStringSync(),
              genericConfig.replaceAll('"dart":', '"dart-mcp-server":'),
            );
          });

          test('for Codex', () {
            final config = File(p.join(projectName, '.codex/config.toml'));
            expect(config.existsSync(), isTrue);
            expect(
              config.readAsStringSync(),
              '''
[mcp_servers.serverpod]
command = "serverpod"
args = ["mcp"]

[mcp_servers.dart_mcp]
command = "dart"
args = ["mcp-server", "--force-roots-fallback"]
''',
            );
          });

          test('for Claude', () {
            final config = File(p.join(projectName, '.mcp.json'));
            expect(config.existsSync(), isTrue);
            expect(config.readAsStringSync(), genericConfig);
          });

          test('for Cursor', () {
            final config = File(p.join(projectName, '.cursor/mcp.json'));
            expect(config.existsSync(), isTrue);
            expect(config.readAsStringSync(), genericConfig);
          });

          test('for OpenCode', () {
            final config = File(p.join(projectName, '.opencode/opencode.json'));
            expect(config.existsSync(), isTrue);
            expect(
              config.readAsStringSync(),
              '''{
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
''',
            );
          });

          test('for VSCode', () {
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
