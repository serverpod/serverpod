import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/open_api/open_api_definition.dart';
import 'package:test/test.dart';

void main() {
  group('Validate on ContentSchemaObject', () {
    test('returnType is Future<Example>', () {
      ContentSchemaObject contentSchemaObject = ContentSchemaObject(
        returnType: TypeDefinition(
          className: 'Future',
          nullable: false,
          generics: [
            TypeDefinition(
              className: 'Example',
              nullable: false,
            ),
          ],
        ),
      );
      expect({
        'type': 'object',
        '\$ref': '#/components/schemas/Example',
      }, contentSchemaObject.toJson());
    });

    test('returnType is Future<Map<String,String>>', () {
      ContentSchemaObject contentSchemaObject = ContentSchemaObject(
        returnType: TypeDefinition(
          className: 'Future',
          nullable: false,
          generics: [
            TypeDefinition(
              className: 'Map',
              nullable: false,
            ),
            TypeDefinition(
              className: 'String',
              nullable: false,
            ),
            TypeDefinition(
              className: 'String',
              nullable: false,
            ),
          ],
        ),
      );
      expect(
        {
          'type': 'object',
          'additionalProperties': {
            'type': 'string',
          },
        },
        contentSchemaObject.toJson(),
      );
    });

    test('returnType is Future<Map<String,Example>>', () {
      ContentSchemaObject contentSchemaObject = ContentSchemaObject(
        returnType: TypeDefinition(
          className: 'Future',
          nullable: false,
          generics: [
            TypeDefinition(
              className: 'Map',
              nullable: false,
            ),
            TypeDefinition(
              className: 'String',
              nullable: false,
            ),
            TypeDefinition(
              className: 'Example',
              nullable: false,
            ),
          ],
        ),
      );
      expect(
        {
          'type': 'object',
          'additionalProperties': {
            '\$ref': '#/components/schemas/Example',
          },
        },
        contentSchemaObject.toJson(),
      );
    });

    test('returnType is Future<List<Example>>', () {
      ContentSchemaObject contentSchemaObject = ContentSchemaObject(
        returnType: TypeDefinition(
          className: 'Future',
          nullable: false,
          generics: [
            TypeDefinition(
              className: 'List',
              nullable: false,
            ),
            TypeDefinition(
              className: 'Example',
              nullable: false,
            ),
          ],
        ),
      );
      expect(
        {
          'type': 'array',
          'items': {
            'type': 'object',
            '\$ref': '#/components/schemas/Example',
          },
        },
        contentSchemaObject.toJson(),
      );
    });

    test('returnType is Future<List<int>>', () {
      ContentSchemaObject contentSchemaObject = ContentSchemaObject(
        returnType: TypeDefinition(
          className: 'Future',
          nullable: false,
          generics: [
            TypeDefinition(
              className: 'List',
              nullable: false,
            ),
            TypeDefinition(
              className: 'int',
              nullable: false,
            ),
          ],
        ),
      );
      expect(
        {
          'type': 'array',
          'items': {
            'type': 'integer',
          },
        },
        contentSchemaObject.toJson(),
      );
    });

    test('returnType is Future<List<String>>', () {
      ContentSchemaObject contentSchemaObject = ContentSchemaObject(
        returnType: TypeDefinition(
          className: 'Future',
          nullable: false,
          generics: [
            TypeDefinition(
              className: 'List',
              nullable: false,
            ),
            TypeDefinition(
              className: 'String',
              nullable: false,
            ),
          ],
        ),
      );
      expect(
        {
          'type': 'array',
          'items': {
            'type': 'string',
          },
        },
        contentSchemaObject.toJson(),
      );
    });

    test('returnType is Future<List<double>>', () {
      ContentSchemaObject contentSchemaObject = ContentSchemaObject(
        returnType: TypeDefinition(
          className: 'Future',
          nullable: false,
          generics: [
            TypeDefinition(
              className: 'List',
              nullable: false,
            ),
            TypeDefinition(
              className: 'double',
              nullable: false,
            ),
          ],
        ),
      );
      expect(
        {
          'type': 'array',
          'items': {
            'type': 'number',
          },
        },
        contentSchemaObject.toJson(),
      );
    });

    test('returnType is Future<List<Map>>', () {
      ContentSchemaObject contentSchemaObject = ContentSchemaObject(
        returnType: TypeDefinition(
          className: 'Future',
          nullable: false,
          generics: [
            TypeDefinition(
              className: 'List',
              nullable: false,
            ),
            TypeDefinition(
              className: 'Map',
              nullable: false,
            ),
          ],
        ),
      );
      expect(
        {
          'type': 'array',
          'items': {
            'type': 'object',
          },
        },
        contentSchemaObject.toJson(),
      );
    });
  });
}
