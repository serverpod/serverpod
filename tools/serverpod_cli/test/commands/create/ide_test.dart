import 'package:serverpod_cli/src/create/ide.dart';
import 'package:test/test.dart';

void main() {
  group('Given the Antigravity IDE', () {
    test('then it uses a global config instead of a project-local file', () {
      expect(TemplateIde.antigravity.usesGlobalConfig, isTrue);
      expect(TemplateIde.antigravity.filePath, isNull);
      expect(
        TemplateIde.antigravity.globalConfigPath,
        '~/.gemini/config/mcp_config.json',
      );
    });

    test('then effectiveConfig embeds the given (absolute) server dir', () {
      final config = TemplateIde.antigravity.effectiveConfig(
        serverDir: '/abs/path/my_app_server',
      );

      expect(config, contains('/abs/path/my_app_server'));
      expect(config, contains('"serverpod"'));
    });

    test('then effectiveConfig renames the dart server entry', () {
      final config = TemplateIde.antigravity.effectiveConfig(
        serverDir: '/abs/path/my_app_server',
      );

      expect(config, contains('"dart-mcp-server"'));
      expect(config, isNot(contains('"dart":')));
    });
  });

  group('Given the project-local IDEs', () {
    test('then they write a project-local file and not a global config', () {
      for (final ide in [
        TemplateIde.claude,
        TemplateIde.cursor,
        TemplateIde.vscode,
        TemplateIde.codex,
        TemplateIde.openCode,
      ]) {
        expect(ide.usesGlobalConfig, isFalse, reason: ide.name);
        expect(ide.filePath, isNotNull, reason: ide.name);
        expect(ide.globalConfigPath, isNull, reason: ide.name);
      }
    });

    test('then Claude embeds the given (relative) server dir', () {
      final config = TemplateIde.claude.effectiveConfig(
        serverDir: 'my_app_server',
      );

      expect(config, contains('"serverpod"'));
      expect(config, contains('my_app_server'));
    });

    test('then VS Code uses the "servers" key instead of "mcpServers"', () {
      final config = TemplateIde.vscode.effectiveConfig(
        serverDir: 'my_app_server',
      );

      expect(config, contains('"servers"'));
      expect(config, isNot(contains('"mcpServers"')));
    });
  });
}
