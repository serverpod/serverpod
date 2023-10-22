import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';
import 'package:test/test.dart';

import 'test_data_factory.dart';

void main() {
  test(
      'Given (int id and string name) when converting OpenAPIRequestContentSchema to json then the type is set to object and properties contains id(integer) and name(string).',
      () {
    OpenAPIRequestContentSchema object = OpenAPIRequestContentSchema(
      params: [
        ParameterDefinition(name: 'id', type: intType, required: true),
        ParameterDefinition(name: 'name', type: stringType, required: true),
      ],
    );

    expect(
      object.toJson(),
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
    );
  });
  test(
      'Given (Example example) when converting OpenAPIRequestContentSchema to json then the type is set to object and properties contains example which references Example.',
      () {
    OpenAPIRequestContentSchema object = OpenAPIRequestContentSchema(
      params: [
        ParameterDefinition(name: 'example', type: exampleType, required: true),
      ],
    );

    expect(
      object.toJson(),
      {
        'type': 'object',
        'properties': {
          'example': {
            '\$ref': '#/components/schemas/Example',
          }
        }
      },
    );
  });
  test(
      'Given (int id,Example example) when converting OpenAPIRequestContentSchema to json then the type is set to object and properties contains  id(integer) and example which references Example.',
      () {
    OpenAPIRequestContentSchema object = OpenAPIRequestContentSchema(
      params: [
        ParameterDefinition(name: 'id', type: intType, required: true),
        ParameterDefinition(name: 'example', type: exampleType, required: true),
      ],
    );

    expect(
      object.toJson(),
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
    );
  });

  test(
      'Given (int id,List<Example> examples) when converting OpenAPIRequestContentSchema to json then the type is set to object and properties contains  id (integer) and examples (array) which references Example',
      () {
    OpenAPIRequestContentSchema object = OpenAPIRequestContentSchema(
      params: [
        ParameterDefinition(name: 'id', type: intType, required: true),
        ParameterDefinition(
            name: 'examples',
            type: listBuilder.withGenerics([exampleType]).build(),
            required: true),
      ],
    );

    expect(
      object.toJson(),
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
    );
  });

  test(
      'Given  (int id,Map<String,dynamic> map) when converting OpenAPIRequestContentSchema to json then the type is set to object and properties contains  id (integer) and map with additionalProperties which references AnyValue.',
      () {
    OpenAPIRequestContentSchema object = OpenAPIRequestContentSchema(
      params: [
        ParameterDefinition(name: 'id', type: intType, required: true),
        ParameterDefinition(
            name: 'map',
            type: mapBuilder.withGenerics([stringType, dynamicType]).build(),
            required: true),
      ],
    );

    expect(
      object.toJson(),
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
    );
  });
}
