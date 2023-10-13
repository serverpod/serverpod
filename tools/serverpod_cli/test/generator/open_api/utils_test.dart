import 'package:recase/recase.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';
import 'package:test/test.dart';

void main() {
  group('Test Utils: ', () {
    test('When convert queryForm to query-form and path to path', () {
      expect('path', 'path'.paramCase);
      expect('query-form', 'queryForm'.paramCase);
    });
    test('When convert subDirs to path', () {
      List<String> subDirs = [
        'api',
        'v1',
      ];
      expect('/api/v1', getExtraPath(subDirs));
    });
  });
  group('Test SchemaObjectType ', () {
    test('When convert [TypeDefinition] to [SchemaObjectType]', () {
      expect(
          'string',
          TypeDefinition(className: 'String', nullable: false)
              .toSchemaObjectType
              .name);
      expect(
          'integer',
          TypeDefinition(className: 'int', nullable: false)
              .toSchemaObjectType
              .name);
      expect(
          'boolean',
          TypeDefinition(className: 'bool', nullable: false)
              .toSchemaObjectType
              .name);
      expect(
          'number',
          TypeDefinition(className: 'double', nullable: false)
              .toSchemaObjectType
              .name);
      expect(
          'array',
          TypeDefinition(className: 'List', nullable: false)
              .toSchemaObjectType
              .name);
      expect(
          'object',
          TypeDefinition(className: 'Map', nullable: false)
              .toSchemaObjectType
              .name);
      expect(
          'other',
          TypeDefinition(className: 'Example', nullable: false)
              .toSchemaObjectType
              .name);
      expect(
          'other',
          TypeDefinition(className: 'dynamic', nullable: false)
              .toSchemaObjectType
              .name);
    });
  });
}
