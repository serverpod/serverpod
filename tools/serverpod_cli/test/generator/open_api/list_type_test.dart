import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';
import 'package:test/test.dart';

void main() {
  group('Serialize List TypeDefinition', () {
    test('When TypeDefinition is List', () {
      TypeDefinition type = TypeDefinition(className: 'List', nullable: false);
      expect(
        {
          'type': 'array',
          'items': {'\$ref': '#/components/schemas/AnyValue'}
        },
        listToJson(type),
      );
    });
    test('When TypeDefinition is List<Example>', () {
      TypeDefinition type = TypeDefinition(
        className: 'List',
        nullable: false,
        generics: [
          TypeDefinition(
            className: 'Example',
            nullable: false,
          ),
        ],
      );
      expect(
        {
          'type': 'array',
          'items': {
            '\$ref': '#/components/schemas/Example',
          }
        },
        listToJson(type),
      );
    });

    test('When TypeDefinition is List<String>', () {
      TypeDefinition type = TypeDefinition(
        className: 'List',
        nullable: false,
        generics: [
          TypeDefinition(
            className: 'String',
            nullable: false,
          ),
        ],
      );
      expect(
        {
          'type': 'array',
          'items': {
            'type': 'string',
          }
        },
        listToJson(type),
      );
    });

    test('When TypeDefinition is List<int>', () {
      TypeDefinition type = TypeDefinition(
        className: 'List',
        nullable: false,
        generics: [
          TypeDefinition(
            className: 'int',
            nullable: false,
          ),
        ],
      );
      expect(
        {
          'type': 'array',
          'items': {
            'type': 'integer',
          }
        },
        listToJson(type),
      );
    });

    test('When TypeDefinition is List<double>', () {
      TypeDefinition type = TypeDefinition(
        className: 'List',
        nullable: false,
        generics: [
          TypeDefinition(
            className: 'double',
            nullable: false,
          ),
        ],
      );
      expect(
        {
          'type': 'array',
          'items': {
            'type': 'number',
          }
        },
        listToJson(type),
      );
    });

    test('When TypeDefinition is List<BigInt>', () {
      TypeDefinition type = TypeDefinition(
        className: 'List',
        nullable: false,
        generics: [
          TypeDefinition(
            className: 'BigInt',
            nullable: false,
          ),
        ],
      );
      expect(
        {
          'type': 'array',
          'items': {
            'type': 'number',
          }
        },
        listToJson(type),
      );
    });

    test('When TypeDefinition is List<boolean>', () {
      TypeDefinition type = TypeDefinition(
        className: 'List',
        nullable: false,
        generics: [
          TypeDefinition(
            className: 'bool',
            nullable: false,
          ),
        ],
      );
      expect(
        {
          'type': 'array',
          'items': {
            'type': 'boolean',
          }
        },
        listToJson(type),
      );
    });

    test('When TypeDefinition is List<List<String>>', () {
      TypeDefinition type = TypeDefinition(
        className: 'List',
        nullable: false,
        generics: [
          TypeDefinition(className: 'List', nullable: false, generics: [
            TypeDefinition(className: 'String', nullable: false),
          ]),
        ],
      );
      expect(
        {
          'type': 'array',
          'items': {
            'type': 'array',
            'items': {
              'type': 'string',
            }
          }
        },
        listToJson(type),
      );
    });
    test('When TypeDefinition is List<Map<String,String>', () {
      TypeDefinition type = TypeDefinition(
        className: 'List',
        nullable: false,
        generics: [
          TypeDefinition(
            className: 'Map',
            nullable: false,
            generics: [
              TypeDefinition(
                className: 'String',
                nullable: false,
              ),
              TypeDefinition(
                className: 'String',
                nullable: false,
              ),
            ],
          )
        ],
      );

      expect(
        {
          'type': 'array',
          'items': {
            'type': 'object',
            'additionalProperties': {
              'type': 'string',
            }
          }
        },
        listToJson(type),
      );
    });
  });
}
