import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/open_api/open_api_definition.dart';
import 'package:test/test.dart';

void main() {
  group('Validate RequestSchemaObject :', () {
    test('requestBody is Example', () {
      RequestSchemaObject contentSchemaObject = RequestSchemaObject(
        typeDefinition: TypeDefinition(
          className: 'Example',
          nullable: false,
        ),
      );
      expect(
        {
          '\$ref': '#/components/schemas/Example',
        },
        contentSchemaObject.toJson(),
      );
    });

    test('requestBody is Map<String,dynamic>', () {
      RequestSchemaObject contentSchemaObject = RequestSchemaObject(
        typeDefinition: TypeDefinition(
          className: 'Map',
          nullable: false,
          generics: [
            TypeDefinition(
              className: 'String',
              nullable: false,
            ),
            TypeDefinition(
              className: 'dynamic',
              nullable: false,
            ),
          ],
        ),
      );
      expect(
        {
          'type': 'object',
          'additionalProperties': {
            'type': 'object',
          }
        },
        contentSchemaObject.toJson(),
      );
    });

    test('requestBody is List<int>', () {
      RequestSchemaObject contentSchemaObject = RequestSchemaObject(
        typeDefinition: TypeDefinition(
          className: 'List',
          nullable: false,
          generics: [
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
          }
        },
        contentSchemaObject.toJson(),
      );
    });

    test('requestBody is List<String>', () {
      RequestSchemaObject contentSchemaObject = RequestSchemaObject(
        typeDefinition: TypeDefinition(
          className: 'List',
          nullable: false,
          generics: [
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
          }
        },
        contentSchemaObject.toJson(),
      );
    });

    test('requestBody is List<Map>', () {
      RequestSchemaObject contentSchemaObject = RequestSchemaObject(
        typeDefinition: TypeDefinition(
          className: 'List',
          nullable: false,
          generics: [
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
          }
        },
        contentSchemaObject.toJson(),
      );
    });

    test('requestBody is List<Example>', () {
      RequestSchemaObject contentSchemaObject = RequestSchemaObject(
        typeDefinition: TypeDefinition(
          className: 'List',
          nullable: false,
          generics: [
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
          }
        },
        contentSchemaObject.toJson(),
      );
    });
  });
}
