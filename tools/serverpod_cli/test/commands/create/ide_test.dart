import 'package:serverpod_cli/src/create/ide.dart';
import 'package:test/test.dart';

void main() {
  group('Given the Antigravity IDE,', () {
    const ide = TemplateIde.antigravity;

    test(
      'when reading its file path, '
      'then the MCP config lives directly in the .agents folder',
      () {
        expect(ide.filePath, '.agents/mcp_config.json');
      },
    );

    test(
      'when rendering its config, '
      'then the server dir is embedded in the serverpod command',
      () {
        final config = ide.effectiveConfig(serverDirRelative: 'my_app_server');

        expect(
          config,
          contains('"exec serverpod mcp-server --server-dir my_app_server"'),
        );
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

  group('Given every IDE,', () {
    test(
      'when rendering all of its files, '
      'then no unrendered server dir slot remains',
      () {
        for (final ide in TemplateIde.values) {
          expect(
            ide.effectiveConfig(serverDirRelative: 'my_app_server'),
            isNot(contains('{serverDirRelative}')),
            reason: ide.name,
          );
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
