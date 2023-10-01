import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/open_api/open_api_definition.dart';
import 'package:test/test.dart';

void main() {
  group('Validate on ItemSchemaObject: ', () {
    test('typeDefinition is CustomClass [Example]', () {
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

    test('typeDefinition is int', () {
      ItemSchemaObject object = ItemSchemaObject(
        TypeDefinition(
          className: 'int',
          nullable: false,
        ),
      );

      expect(
        {
          'type': 'integer',
        },
        object.toJson(),
      );
    });

    test('typeDefinition is String', () {
      ItemSchemaObject object = ItemSchemaObject(
        TypeDefinition(
          className: 'String',
          nullable: false,
        ),
      );

      expect(
        {
          'type': 'string',
        },
        object.toJson(),
      );
    });

    test('typeDefinition is double', () {
      ItemSchemaObject object = ItemSchemaObject(
        TypeDefinition(
          className: 'double',
          nullable: false,
        ),
      );

      expect(
        {
          'type': 'number',
        },
        object.toJson(),
      );
    });

    test('typeDefinition is Map', () {
      ItemSchemaObject object = ItemSchemaObject(
        TypeDefinition(
          className: 'Map',
          nullable: false,
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
        'typeDefinition is CustomClass [Example] and additionalProperties is true',
        () {
      ItemSchemaObject object = ItemSchemaObject(
        TypeDefinition(
          className: 'Example',
          nullable: false,
        ),
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
