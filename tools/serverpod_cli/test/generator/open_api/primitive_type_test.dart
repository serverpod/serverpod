import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';
import 'package:test/test.dart';

void main() {
  group('Serializes TypeDefinition: ', () {
    test('When TypeDefinition is int?', () {
      TypeDefinition type = TypeDefinition(className: 'int', nullable: true);
      expect(
        {'type': 'integer', 'nullable': true},
        dartPrimitiveDataTypeToJson(type),
      );
    });

    test('When TypeDefinition is int', () {
      TypeDefinition type = TypeDefinition(className: 'int', nullable: false);
      expect(
        {
          'type': 'integer',
        },
        dartPrimitiveDataTypeToJson(type),
      );
    });

    test('When TypeDefinition is String?', () {
      TypeDefinition type = TypeDefinition(className: 'String', nullable: true);
      expect(
        {'type': 'string', 'nullable': true},
        dartPrimitiveDataTypeToJson(type),
      );
    });
    test('When TypeDefinition is String', () {
      TypeDefinition type =
          TypeDefinition(className: 'String', nullable: false);
      expect(
        {
          'type': 'string',
        },
        dartPrimitiveDataTypeToJson(type),
      );
    });

    test('When TypeDefinition is double?', () {
      TypeDefinition type = TypeDefinition(className: 'double', nullable: true);
      expect(
        {'type': 'number', 'nullable': true},
        dartPrimitiveDataTypeToJson(type),
      );
    });
    test('When TypeDefinition is double', () {
      TypeDefinition type =
          TypeDefinition(className: 'double', nullable: false);
      expect(
        {
          'type': 'number',
        },
        dartPrimitiveDataTypeToJson(type),
      );
    });

    test('When TypeDefinition is BigInt?', () {
      TypeDefinition type = TypeDefinition(className: 'BigInt', nullable: true);
      expect(
        {'type': 'number', 'nullable': true},
        dartPrimitiveDataTypeToJson(type),
      );
    });
    test('When TypeDefinition is BigInt', () {
      TypeDefinition type =
          TypeDefinition(className: 'BigInt', nullable: false);
      expect(
        {
          'type': 'number',
        },
        dartPrimitiveDataTypeToJson(type),
      );
    });

    test('When TypeDefinition is bool?', () {
      TypeDefinition type = TypeDefinition(className: 'bool', nullable: true);
      expect(
        {'type': 'boolean', 'nullable': true},
        dartPrimitiveDataTypeToJson(type),
      );
    });
    test('When TypeDefinition is bool?', () {
      TypeDefinition type = TypeDefinition(className: 'bool', nullable: false);
      expect(
        {
          'type': 'boolean',
        },
        dartPrimitiveDataTypeToJson(type),
      );
    });
  });
}
