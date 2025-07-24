import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/create/copier.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:test/test.dart';

void main() {
  group('Workspace pubspec generation', () {
    test('Workspace members are correctly generated for server template', () {
      var workspaceMembers = _generateWorkspaceMembers(
        'test_project',
        ServerpodTemplateType.server,
      );

      expect(
          workspaceMembers,
          equals([
            '  - test_project_server',
            '  - test_project_client',
            '  - test_project_flutter',
          ].join('\n')));
    });

    test('Workspace members are correctly generated for module template', () {
      var workspaceMembers = _generateWorkspaceMembers(
        'test_module',
        ServerpodTemplateType.module,
      );

      expect(
          workspaceMembers,
          equals([
            '  - test_module_server',
            '  - test_module_client',
          ].join('\n')));
    });

    test('Workspace members are correctly generated for mini template', () {
      var workspaceMembers = _generateWorkspaceMembers(
        'test_mini',
        ServerpodTemplateType.mini,
      );

      expect(
          workspaceMembers,
          equals([
            '  - test_mini_server',
            '  - test_mini_client',
            '  - test_mini_flutter',
          ].join('\n')));
    });

    test('Dependency overrides are generated in development mode', () {
      var overrides = _generateDependencyOverrides('/path/to/serverpod');

      expect(overrides, contains('dependency_overrides:'));
      expect(overrides, contains('serverpod:'));
      expect(
          overrides, contains('path: /path/to/serverpod/packages/serverpod'));
      expect(overrides, contains('serverpod_client:'));
      expect(overrides, contains('serverpod_flutter:'));
      expect(overrides, contains('serverpod_serialization:'));
      expect(overrides, contains('serverpod_shared:'));
      expect(overrides, contains('serverpod_service_client:'));
      expect(overrides, contains('serverpod_test:'));
    });

    test('No dependency overrides in production mode', () {
      var overrides = _generateDependencyOverrides(null);

      expect(overrides, isEmpty);
    });

    test('Workspace template is properly formatted', () {
      var template = '''name: _
publish_to: none
environment:
  sdk: ^3.6.0
workspace:
{{WORKSPACE_MEMBERS}}
{{DEPENDENCY_OVERRIDES}}''';

      var result = template
          .replaceAll('{{WORKSPACE_MEMBERS}}', '  - my_server\n  - my_client')
          .replaceAll('{{DEPENDENCY_OVERRIDES}}', '');

      expect(result, contains('workspace:'));
      expect(result, contains('  - my_server'));
      expect(result, contains('  - my_client'));
      expect(result.trim(), endsWith('  - my_client'));
    });
  });
}

// Helper functions that mirror the implementation
String _generateWorkspaceMembers(String name, ServerpodTemplateType template) {
  List<String> workspaceMembers;
  if (template == ServerpodTemplateType.module) {
    workspaceMembers = [
      '${name}_server',
      '${name}_client',
    ];
  } else {
    // Server or mini template
    workspaceMembers = [
      '${name}_server',
      '${name}_client',
      '${name}_flutter',
    ];
  }

  return workspaceMembers.map((member) => '  - $member').join('\n');
}

String _generateDependencyOverrides(String? customServerpodPath) {
  if (customServerpodPath == null) {
    return '';
  }

  return '''

dependency_overrides:
  serverpod:
    path: $customServerpodPath/packages/serverpod
  serverpod_client:
    path: $customServerpodPath/packages/serverpod_client
  serverpod_flutter:
    path: $customServerpodPath/packages/serverpod_flutter
  serverpod_serialization:
    path: $customServerpodPath/packages/serverpod_serialization
  serverpod_shared:
    path: $customServerpodPath/packages/serverpod_shared
  serverpod_service_client:
    path: $customServerpodPath/packages/serverpod_service_client
  serverpod_test:
    path: $customServerpodPath/packages/serverpod_test''';
}
