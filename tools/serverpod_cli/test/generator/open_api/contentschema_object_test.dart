import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';
import 'package:test/test.dart';

void main() {
  group('Validate on ContentSchemaObject', () {
    test('When returnType is Future<Example>', () {
      ContentSchemaObject contentSchemaObject = ContentSchemaObject(
        returnType: TypeDefinition(
          className: 'Future',
          url: 'dart:core',
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

    test('When returnType is Future<Map<String,String>>', () {
      ContentSchemaObject contentSchemaObject = ContentSchemaObject(
        returnType: TypeDefinition(
          className: 'Future',
          nullable: false,
          url: 'dart:core',
          generics: [
            TypeDefinition(
              className: 'Map',
              nullable: false,
              url: 'dart:core',
            ),
            TypeDefinition(
              className: 'String',
              nullable: false,
              url: 'dart:core',
            ),
            TypeDefinition(
              className: 'String',
              nullable: false,
              url: 'dart:core',
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

    test('When returnType is Future<Map<String,Example>>', () {
      ContentSchemaObject contentSchemaObject = ContentSchemaObject(
        returnType: TypeDefinition(
          className: 'Future',
          nullable: false,
          url: 'dart:core',
          generics: [
            TypeDefinition(
              className: 'Map',
              nullable: false,
              url: 'dart:core',
            ),
            TypeDefinition(
              className: 'String',
              nullable: false,
              url: 'dart:core',
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

    test('When returnType is Future<List<Example>>', () {
      ContentSchemaObject contentSchemaObject = ContentSchemaObject(
        returnType: TypeDefinition(
          className: 'Future',
          nullable: false,
          generics: [
            TypeDefinition(
              className: 'List',
              nullable: false,
              url: 'dart:core',
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

    test('When returnType is Future<List<int>>', () {
      ContentSchemaObject contentSchemaObject = ContentSchemaObject(
        returnType: TypeDefinition(
          className: 'Future',
          nullable: false,
          generics: [
            TypeDefinition(
              className: 'List',
              nullable: false,
              url: 'dart:core',
            ),
            TypeDefinition(
              className: 'int',
              nullable: false,
              url: 'dart:core',
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

    test('When returnType is Future<List<String>>', () {
      ContentSchemaObject contentSchemaObject = ContentSchemaObject(
        returnType: TypeDefinition(
          className: 'Future',
          nullable: false,
          generics: [
            TypeDefinition(
              className: 'List',
              nullable: false,
              url: 'dart:core',
            ),
            TypeDefinition(
              className: 'String',
              nullable: false,
              url: 'dart:core',
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

    test('When returnType is Future<List<double>>', () {
      ContentSchemaObject contentSchemaObject = ContentSchemaObject(
        returnType: TypeDefinition(
          className: 'Future',
          nullable: false,
          generics: [
            TypeDefinition(
              className: 'List',
              nullable: false,
              url: 'dart:core',
            ),
            TypeDefinition(
              className: 'double',
              nullable: false,
              url: 'dart:core',
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

    test('When returnType is Future<List<Map>>', () {
      ContentSchemaObject contentSchemaObject = ContentSchemaObject(
        returnType: TypeDefinition(
          className: 'Future',
          nullable: false,
          url: 'dart:core',
          generics: [
            TypeDefinition(
              className: 'List',
              nullable: false,
              url: 'dart:core',
            ),
            TypeDefinition(
              className: 'Map',
              nullable: false,
              url: 'dart:core',
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
