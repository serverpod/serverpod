import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/open_api/open_api_definition.dart';
import 'package:test/test.dart';

void main() {
  group('Validate ParameterSchemaObject:', () {
    test('when parameter is String', () {
      ParameterSchemaObject object = ParameterSchemaObject(
        TypeDefinition(className: 'String', nullable: false),
      );
      expect({'type': 'string'}, object.toJson());
    });
    test('when parameter is integer', () {
      ParameterSchemaObject object = ParameterSchemaObject(
        TypeDefinition(className: 'int', nullable: false),
      );
      expect({'type': 'integer'}, object.toJson());
    });

    test('when parameter is double', () {
      ParameterSchemaObject object = ParameterSchemaObject(
        TypeDefinition(className: 'double', nullable: false),
      );
      expect({'type': 'number'}, object.toJson());
    });

    test('when parameter is List<int>', () {
      ParameterSchemaObject object = ParameterSchemaObject(
        TypeDefinition(className: 'List', nullable: false, generics: [
          TypeDefinition(className: 'int', nullable: false),
        ]),
      );
      expect({
        'type': 'array',
        'items': {
          'type': 'integer',
        }
      }, object.toJson());
    });

    test('when parameter is List<String>', () {
      ParameterSchemaObject object = ParameterSchemaObject(
        TypeDefinition(className: 'List', nullable: false, generics: [
          TypeDefinition(className: 'String', nullable: false),
        ]),
      );
      expect({
        'type': 'array',
        'items': {
          'type': 'string',
        }
      }, object.toJson());
    });

    test('when parameter is List<double>', () {
      ParameterSchemaObject object = ParameterSchemaObject(
        TypeDefinition(className: 'List', nullable: false, generics: [
          TypeDefinition(className: 'double', nullable: false),
        ]),
      );
      expect({
        'type': 'array',
        'items': {
          'type': 'number',
        }
      }, object.toJson());
    });

    test('when parameter is enum', () {
      ParameterSchemaObject object = ParameterSchemaObject(
        TypeDefinition(
            className: 'enum', nullable: false, generics: [], isEnum: true),
      );
      expect({'type': 'string', 'enum': {}}, object.toJson());
    });
  });
}
