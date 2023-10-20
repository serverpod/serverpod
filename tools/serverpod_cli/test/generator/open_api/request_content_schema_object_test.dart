import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';
import 'package:test/test.dart';

void main() {
  group('Validate RequestContentSchemaObject Serialization: ', () {
    test('When request param is  (int id,String name)', () {
      OpenAPIRequestContentSchema object = OpenAPIRequestContentSchema(
        params: [
          ParameterDefinition(
              name: 'id',
              type: TypeDefinition(
                className: 'int',
                nullable: false,
                url: 'dart:core',
              ),
              required: true),
          ParameterDefinition(
              name: 'name',
              type: TypeDefinition(
                className: 'String',
                nullable: false,
                url: 'dart:core',
              ),
              required: true),
        ],
      );

      expect(
        {
          'type': 'object',
          'properties': {
            'id': {
              'type': 'integer',
            },
            'name': {
              'type': 'string',
            }
          }
        },
        object.toJson(),
      );
    });
    test('When request param is  (Example example)', () {
      OpenAPIRequestContentSchema object = OpenAPIRequestContentSchema(
        params: [
          ParameterDefinition(
              name: 'example',
              type: TypeDefinition(
                className: 'Example',
                nullable: false,
                url: 'some:path',
              ),
              required: true),
        ],
      );

      expect(
        {
          'type': 'object',
          'properties': {
            'example': {
              '\$ref': '#/components/schemas/Example',
            }
          }
        },
        object.toJson(),
      );
    });
    test('When request param is  (int id,Example example)', () {
      OpenAPIRequestContentSchema object = OpenAPIRequestContentSchema(
        params: [
          ParameterDefinition(
              name: 'id',
              type: TypeDefinition(
                className: 'int',
                nullable: false,
                url: 'dart:core',
              ),
              required: true),
          ParameterDefinition(
              name: 'example',
              type: TypeDefinition(
                className: 'Example',
                nullable: false,
                url: 'some:path',
              ),
              required: true),
        ],
      );

      expect(
        {
          'type': 'object',
          'properties': {
            'id': {
              'type': 'integer',
            },
            'example': {
              '\$ref': '#/components/schemas/Example',
            }
          }
        },
        object.toJson(),
      );
    });

    test('When request param is  (int id,List<Example> examples)', () {
      OpenAPIRequestContentSchema object = OpenAPIRequestContentSchema(
        params: [
          ParameterDefinition(
              name: 'id',
              type: TypeDefinition(
                className: 'int',
                nullable: false,
                url: 'dart:core',
              ),
              required: true),
          ParameterDefinition(
              name: 'examples',
              type: TypeDefinition(
                className: 'List',
                nullable: false,
                url: 'dart:core',
                generics: [
                  TypeDefinition(
                    className: 'Example',
                    nullable: false,
                    url: 'some:path',
                  ),
                ],
              ),
              required: true),
        ],
      );

      expect(
        {
          'type': 'object',
          'properties': {
            'id': {
              'type': 'integer',
            },
            'examples': {
              'type': 'array',
              'items': {
                '\$ref': '#/components/schemas/Example',
              }
            }
          }
        },
        object.toJson(),
      );
    });

    test('When request param is  (int id,Map<String,dynamic> map)', () {
      OpenAPIRequestContentSchema object = OpenAPIRequestContentSchema(
        params: [
          ParameterDefinition(
              name: 'id',
              type: TypeDefinition(
                className: 'int',
                nullable: false,
                url: 'dart:core',
              ),
              required: true),
          ParameterDefinition(
              name: 'map',
              type: TypeDefinition(
                  className: 'Map',
                  nullable: false,
                  url: 'dart:core',
                  generics: [
                    TypeDefinition(
                      className: 'String',
                      nullable: false,
                      url: 'dart:core',
                    ),
                    TypeDefinition(
                      className: 'dynamic',
                      nullable: false,
                      url: 'dart:core',
                    ),
                  ]),
              required: true),
        ],
      );

      expect(
        {
          'type': 'object',
          'properties': {
            'id': {
              'type': 'integer',
            },
            'map': {
              'type': 'object',
              'additionalProperties': {'\$ref': '#/components/schemas/AnyValue'}
            }
          }
        },
        object.toJson(),
      );
    });
  });
}
