import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/open_api/open_api_definition.dart';
import 'package:test/test.dart';

void main() {
  group('Validate on ItemSchemaObject: ', () {
    test('When typeDefinition is CustomClass [Example]', () {
      ItemSchemaObject object = ItemSchemaObject(
        TypeDefinition(
          className: 'Example',
          nullable: false,
        ),
      );

      expect(
        {
          'type': 'object',
          '\$ref': '#/components/schemas/Example',
        },
        object.toJson(),
      );
    });

    test('When typeDefinition is int', () {
      ItemSchemaObject object = ItemSchemaObject(
        TypeDefinition(
          className: 'int',
          nullable: false,
          url: 'dart:core',
        ),
      );

      expect(
        {
          'type': 'integer',
        },
        object.toJson(),
      );
    });

    test('When typeDefinition is String', () {
      ItemSchemaObject object = ItemSchemaObject(
        TypeDefinition(
          className: 'String',
          nullable: false,
          url: 'dart:core',
        ),
      );

      expect(
        {
          'type': 'string',
        },
        object.toJson(),
      );
    });

    test('When typeDefinition is double', () {
      ItemSchemaObject object = ItemSchemaObject(
        TypeDefinition(
          className: 'double',
          nullable: false,
          url: 'dart:core',
        ),
      );

      expect(
        {
          'type': 'number',
        },
        object.toJson(),
      );
    });

    test('When typeDefinition is Map', () {
      ItemSchemaObject object = ItemSchemaObject(
        TypeDefinition(
          className: 'Map',
          nullable: false,
          url: 'dart:core',
        ),
      );

      expect(
        {
          'type': 'object',
        },
        object.toJson(),
      );
    });

    test(
        'When typeDefinition is CustomClass [Example] and additionalProperties is true',
        () {
      ItemSchemaObject object = ItemSchemaObject(
        TypeDefinition(
          className: 'Example',
          nullable: false,
        ),
        additionalProperties: true,
      );

      expect(
        {
          '\$ref': '#/components/schemas/Example',
        },
        object.toJson(),
      );
    });
  });
}
