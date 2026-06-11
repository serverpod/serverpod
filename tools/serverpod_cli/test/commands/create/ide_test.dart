import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/create/ide.dart';
import 'package:test/test.dart';

void main() {
  group('Given the Antigravity IDE', () {
    const ide = TemplateIde.antigravity;

    group('when reading its file layout', () {
      test('then the MCP config lives in the .agents plugin folder', () {
        expect(
          ide.filePath,
          '.agents/plugins/serverpod-local/mcp_config.json',
        );
      });

      test('then the plugin manifest is a sibling of the MCP config', () {
        expect(
          ide.additionalFiles.keys.map(p.dirname),
          everyElement(p.dirname(ide.filePath)),
        );
      });

      test('then the manifest name matches the plugin folder name', () {
        final manifestPath = ide.additionalFiles.keys.single;
        final manifest =
            jsonDecode(ide.additionalFiles[manifestPath]!)
                as Map<String, dynamic>;

        expect(manifest['name'], p.basename(p.dirname(manifestPath)));
      });
    });

    group('when rendering its config', () {
      final config = ide.effectiveConfig(serverDirRelative: 'my_app_server');

      test('then the server dir is embedded in the serverpod entry', () {
        expect(config, contains('"--server-dir", "my_app_server"'));
      });

      test('then the dart entry is renamed to dart-mcp-server', () {
        expect(config, contains('"dart-mcp-server":'));
        expect(config, isNot(contains('"dart":')));
      });
    });

    test(
      'when rendering a companion file that uses slots '
      'then the server dir slot and replacements are applied',
      () {
        final rendered = ide.render(
          '"dart": "{serverDirRelative}"',
          serverDirRelative: 'my_app_server',
        );

        expect(rendered, '"dart-mcp-server": "my_app_server"');
      },
    );
  });

  group('Given the VS Code IDE', () {
    test(
      'when rendering its config '
      'then the mcpServers key is replaced with servers',
      () {
        final config = TemplateIde.vscode.effectiveConfig(
          serverDirRelative: 'my_app_server',
        );

        expect(config, contains('"servers":'));
        expect(config, isNot(contains('"mcpServers":')));
      },
    );
  });

  group('Given every IDE', () {
    test(
      'when rendering all of its files '
      'then no unrendered server dir slot remains',
      () {
        for (final ide in TemplateIde.values) {
          final renderedFiles = [
            ide.effectiveConfig(serverDirRelative: 'my_app_server'),
            for (final content in ide.additionalFiles.values)
              ide.render(content, serverDirRelative: 'my_app_server'),
          ];

          for (final content in renderedFiles) {
            expect(
              content,
              isNot(contains('{serverDirRelative}')),
              reason: ide.name,
            );
          }
        }
      },
    );
  });
}
