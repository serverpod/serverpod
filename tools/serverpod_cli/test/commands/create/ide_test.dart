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

      test('then every MCP server starts in the project root', () {
        expect(
          _serverStartDirs(ide, config),
          allOf(hasLength(2), everyElement('.')),
        );
      });
    });

    test(
      'when rendering the config for a module '
      'then the Dart MCP server starts in the project root',
      () {
        final config = ide.effectiveConfig(
          serverDirRelative: 'my_module_server',
          isModule: true,
        );

        expect(_serverStartDirs(ide, config), ['.']);
      },
    );

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

    test(
      'when rendering the config for a module '
      'then the Serverpod MCP server is left out',
      () {
        for (final ide in TemplateIde.values) {
          final config = ide.effectiveConfig(
            serverDirRelative: 'my_module_server',
            isModule: true,
          );

          expect(config, isNot(contains('serverpod')), reason: ide.name);
          expect(config, isNot(contains('my_module_server')), reason: ide.name);
        }
      },
    );

    test(
      'when rendering the config for a module '
      'then the Dart MCP server is still configured',
      () {
        for (final ide in TemplateIde.values) {
          final config = ide.effectiveConfig(
            serverDirRelative: 'my_module_server',
            isModule: true,
          );

          expect(config, contains('dart'), reason: ide.name);
          expect(config, contains('mcp-server'), reason: ide.name);
        }
      },
    );
  });
}

/// The folders the MCP servers of [config] start in, relative to the project
/// root, when the IDE resolves each `cwd` against the folder of the config.
Iterable<String> _serverStartDirs(TemplateIde ide, String config) {
  final servers =
      (jsonDecode(config) as Map<String, dynamic>)['mcpServers']
          as Map<String, dynamic>;
  return servers.values.map(
    (server) => p.posix.normalize(
      p.posix.join(
        p.posix.dirname(ide.filePath),
        (server as Map<String, dynamic>)['cwd'] as String,
      ),
    ),
  );
}
