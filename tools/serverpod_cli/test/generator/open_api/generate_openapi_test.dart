import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';
import 'package:serverpod_cli/src/generator/open_api/open_api_generator.dart';
import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/endpoint_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/enum_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/method_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/serializable_entity_field_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/type_definition_builder.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  var intType = TypeDefinitionBuilder().withClassName('int').build();
  var intNullableType =
      TypeDefinitionBuilder().withClassName('int').withNullable(true).build();

  var stringType = TypeDefinitionBuilder().withClassName('String').build();
  var stringNullableType = TypeDefinitionBuilder()
      .withClassName('String')
      .withNullable(true)
      .build();

  var doubleType = TypeDefinitionBuilder().withClassName('double').build();
  var doubleNullableType = TypeDefinitionBuilder()
      .withClassName('double')
      .withNullable(true)
      .build();

  var bigIntType = TypeDefinitionBuilder().withClassName('BigInt').build();
  var bigIntNullableType = TypeDefinitionBuilder()
      .withClassName('BigInt')
      .withNullable(true)
      .build();

  var boolType = TypeDefinitionBuilder().withClassName('bool').build();
  var boolNullableType =
      TypeDefinitionBuilder().withClassName('bool').withNullable(true).build();
  var dynamicType = TypeDefinitionBuilder().withClassName('dynamic').build();
  var exampleType = TypeDefinitionBuilder().withClassName('Example').build();
  var exampleTypeNullable = TypeDefinitionBuilder()
      .withClassName('Example')
      .withNullable(true)
      .build();
  var listBuilder = TypeDefinitionBuilder().withClassName('List');
  var mapBuilder = TypeDefinitionBuilder().withClassName('Map');

  var futureBuilder = TypeDefinitionBuilder().withClassName('Future');

  var nameField =
      FieldDefinitionBuilder().withName('name').withType(stringType).build();
  var boolField =
      FieldDefinitionBuilder().withName('isTrue').withType(boolType).build();
  var nullableIntField = FieldDefinitionBuilder()
      .withName('amount')
      .withType(intNullableType)
      .build();
  var nullableStringField = FieldDefinitionBuilder()
      .withName('findName')
      .withType(stringNullableType)
      .build();
  var nullableDoubleField = FieldDefinitionBuilder()
      .withName('funding')
      .withType(doubleNullableType)
      .build();
  var nullableBoolField = FieldDefinitionBuilder()
      .withName('isTrue')
      .withType(boolNullableType)
      .build();

  var nullableBigIntField = FieldDefinitionBuilder()
      .withName('totalDebt')
      .withType(bigIntNullableType)
      .build();
  var bigIntField = FieldDefinitionBuilder()
      .withName('accountBalance')
      .withType(bigIntType)
      .build();
  var exampleField = FieldDefinitionBuilder()
      .withName('example')
      .withType(exampleType)
      .build();
  var secretField = FieldDefinitionBuilder()
      .withName('name')
      .withScope(
        EntityFieldScopeDefinition.serverOnly,
      )
      .withType(stringType)
      .build();
  var exampleClass = ClassDefinitionBuilder()
      .withClassName('Example')
      .withField(nameField)
      .build();
  var serverOnlyEntity = ClassDefinitionBuilder()
      .withClassName('ServerOnlyClass')
      .withField(nameField)
      .withServerOnly(true)
      .build();
  var classWithServerOnlyField = ClassDefinitionBuilder()
      .withClassName('ServerOnlyFieldClass')
      .withField(secretField)
      .build();

  var classWithNullableField = ClassDefinitionBuilder()
      .withClassName('ClassWithNullableField')
      .withFields([
    bigIntField,
    boolField,
    nullableBigIntField,
    nullableBoolField,
    nullableDoubleField,
    nullableStringField,
    exampleField,
    nullableIntField,
  ]).build();

  var enumEntity = EnumDefinitionBuilder().withClassName('TestEnum').build();
  var helloMethod = MethodDefinitionBuilder()
      .withMethodName('hello')
      .withDocumentation('/// Hello')
      .withParameter(
        ParameterDefinition(name: 'name', type: stringType, required: true),
      )
      .withReturnType(futureBuilder.withGenerics([stringType]).build())
      .build();
  var nullableReturnTypeMethod = MethodDefinitionBuilder()
      .withMethodName('nullable')
      .withDocumentation('/// return nullable type.')
      .withParameter(
        ParameterDefinition(name: 'foo', type: stringType, required: true),
      )
      .withReturnType(futureBuilder.withGenerics([exampleTypeNullable]).build())
      .build();

  var fooMethod = MethodDefinitionBuilder()
      .withMethodName('foo')
      .withDocumentation('/// Bar')
      .withNamedParameter(
        ParameterDefinition(name: 'id', type: intType, required: true),
      )
      .withNamedParameter(
        ParameterDefinition(name: 'name', type: stringType, required: true),
      )
      .withNamedParameter(
        ParameterDefinition(
          name: 'amount',
          type: doubleType,
          required: true,
        ),
      )
      .withNamedParameter(
        ParameterDefinition(
            name: 'items',
            type: listBuilder.withGenerics([stringType]).build(),
            required: true),
      )
      .withReturnType(
        mapBuilder.withGenerics(
          [
            dynamicType,
          ],
        ).build(),
      )
      .build();

  var exampleEndpoint = EndpointDefinitionBuilder()
      .withDocumentation('/// The Example endpoint.')
      .withMethod(helloMethod)
      .withMethod(nullableReturnTypeMethod)
      .withMethod(fooMethod)
      .withSubDirParts(['v1']).build();

  var exampleProtocolDefinition = ProtocolDefinition(
    endpoints: [exampleEndpoint],
    entities: [
      exampleClass,
      serverOnlyEntity,
      classWithServerOnlyField,
      enumEntity,
      classWithNullableField,
    ],
  );

  const exampleProjectName = 'example_project';
  var generatorConfig = GeneratorConfigBuilder()
      .withName(exampleProjectName)
      .withOpenAPIDocumentVersion('2.0.0')
      .build();
  const openAPIgenerator = OpenAPIGenerator();

  var expectedFilePath = path.join('generated', 'openapi', 'openapi.json');

  var codeMap = openAPIgenerator.generateOpenAPISchema(
    protocolDefinition: exampleProtocolDefinition,
    config: generatorConfig,
  );

  group(
    'Given a ProtocolDefinition when generating openAPI schema',
    () {
      test('then openapi file is created.', () {
        expect(
          codeMap,
          contains(
            expectedFilePath,
          ),
          reason: 'Expected openapi file to be present, found none.',
        );
      });
      Map openAPISchema =
          loadYamlDocument(codeMap[expectedFilePath]!).contents as Map;
      test(
        'then the schema contains all required keys.',
        () {
          expect(openAPISchema.containsKey('openapi'), isTrue);
          expect(openAPISchema.containsKey('info'), isTrue);
          expect(openAPISchema.containsKey('servers'), isTrue);
          expect(openAPISchema.containsKey('paths'), isTrue);
          expect(openAPISchema.containsKey('components'), isTrue);
          expect(openAPISchema.containsKey('tags'), isTrue);
        },
      );

      test(
        'then openAPI version is 3.0.0.',
        () {
          expect(
            openAPISchema['openapi'],
            equals('3.0.0'),
          );
        },
      );
      test(
        'then info values are correctly set.',
        () {
          expect(
            openAPISchema['info'],
            {'title': 'ServerPod Endpoint - OpenAPI', 'version': '2.0.0'},
          );
        },
      );

      test(
        'then servers values are correctly set.',
        () {
          expect(
            openAPISchema['servers'],
            [
              {
                'url': 'http://localhost:8080',
                'description': 'Development Server'
              },
            ],
          );
        },
      );

      test(
        'then tags values are correctly set.',
        () {
          expect(
            openAPISchema['tags'],
            [
              {'name': 'example', 'description': 'The Example endpoint.'}
            ],
          );
        },
      );

      test(
        'then the paths contains /v1/Example/hello.',
        () {
          expect(
            openAPISchema['paths'],
            contains('/v1/Example/hello'),
          );
        },
      );
      test(
        'then the paths contains /v1/Example/nullable.',
        () {
          expect(
            openAPISchema['paths'],
            contains('/v1/Example/nullable'),
          );
        },
      );
      test(
        'then the paths contains /v1/Example/foo.',
        () {
          expect(
            openAPISchema['paths'],
            contains('/v1/Example/foo'),
          );
        },
      );
      var paths = openAPISchema['paths'];
      test(
        'then the the paths /v1/Example/hello contains post.',
        () {
          expect(
            paths['/v1/Example/hello'].containsKey('post'),
            isTrue,
          );
        },
      );
      test(
        'then the the paths /v1/Example/nullable contains post.',
        () {
          expect(
            paths['/v1/Example/hello'].containsKey('post'),
            isTrue,
          );
        },
      );
      test(
        'then the the paths /v1/Example/foo contains post.',
        () {
          expect(
            paths['/v1/Example/foo'].containsKey('post'),
            isTrue,
          );
        },
      );

      Map postForHelloMethod = paths['/v1/Example/hello']['post'];

      group(
        'then the post operation is generated for hello method',
        () {
          test(
            'with correct operationId.',
            () {
              expect(
                postForHelloMethod['operationId'],
                equals('helloExample'),
              );
            },
          );
          test(
            'with tags list that contain Example tag.',
            () {
              expect(
                postForHelloMethod['tags'],
                equals(['Example']),
              );
            },
          );
          test(
            'with the Hello description.',
            () {
              expect(
                postForHelloMethod['description'],
                equals('Hello'),
              );
            },
          );

          test(
            'with valid requestBody.',
            () {
              expect(
                postForHelloMethod.containsKey('requestBody'),
                isTrue,
              );
              expect(
                postForHelloMethod['requestBody'],
                {
                  'content': {
                    'application/json': {
                      'schema': {
                        'type': 'object',
                        'properties': {
                          'name': {'type': 'string'},
                        },
                      },
                    },
                  },
                  'required': true
                },
              );
            },
          );

          test(
            'with valid responses.',
            () {
              expect(
                postForHelloMethod.containsKey('responses'),
                isTrue,
              );
              expect(
                postForHelloMethod['responses'],
                {
                  '200': {
                    'description': 'Success',
                    'content': {
                      'application/json': {
                        'schema': {'type': 'string'}
                      }
                    }
                  },
                  '400': {
                    'description':
                        'Bad request (the query passed to the server was incorrect).'
                  },
                  '403': {
                    'description':
                        "Forbidden (the caller is trying to call a restricted endpoint, but doesn't have the correct credentials/scope)."
                  },
                  '500': {'description': 'Internal server error.'}
                },
              );
            },
          );
        },
      );
      Map postForNullableMethod = paths['/v1/Example/nullable']['post'];
      group(
        'then the post operation is generated for nullable method',
        () {
          test(
            'with correct operationId.',
            () {
              expect(
                postForNullableMethod['operationId'],
                equals('nullableExample'),
              );
            },
          );
          test(
            'with tags list that contain Example tag.',
            () {
              expect(
                postForNullableMethod['tags'],
                equals(['Example']),
              );
            },
          );
          test(
            'with the Hello description.',
            () {
              expect(
                postForNullableMethod['description'],
                equals('return nullable type.'),
              );
            },
          );

          test(
            'with valid requestBody.',
            () {
              expect(
                postForNullableMethod.containsKey('requestBody'),
                isTrue,
              );
              expect(
                postForNullableMethod['requestBody'],
                {
                  'content': {
                    'application/json': {
                      'schema': {
                        'type': 'object',
                        'properties': {
                          'foo': {'type': 'string'},
                        },
                      },
                    },
                  },
                  'required': true
                },
              );
            },
          );

          test(
            'with valid responses.',
            () {
              expect(
                postForNullableMethod.containsKey('responses'),
                isTrue,
              );
              expect(
                postForNullableMethod['responses'],
                {
                  '200': {
                    'description': 'Success',
                    'content': {
                      'application/json': {
                        'schema': {
                          'oneOf': [
                            {'\$ref': '#/components/schemas/Example'}
                          ],
                          'nullable': true
                        }
                      }
                    }
                  },
                  '400': {
                    'description':
                        'Bad request (the query passed to the server was incorrect).'
                  },
                  '403': {
                    'description':
                        "Forbidden (the caller is trying to call a restricted endpoint, but doesn't have the correct credentials/scope)."
                  },
                  '500': {'description': 'Internal server error.'}
                },
              );
            },
          );
        },
      );

      Map postForFooMethodMethod = paths['/v1/Example/foo']['post'];
      group(
        'then the post operation is generated for foo method',
        () {
          test(
            'with correct operationId.',
            () {
              expect(
                postForFooMethodMethod['operationId'],
                equals('fooExample'),
              );
            },
          );
          test(
            'with tags list that contain Example tag.',
            () {
              expect(
                postForFooMethodMethod['tags'],
                equals(['Example']),
              );
            },
          );
          test(
            'with the description.',
            () {
              expect(
                postForFooMethodMethod['description'],
                equals('Bar'),
              );
            },
          );

          test(
            'with valid requestBody.',
            () {
              expect(
                postForFooMethodMethod.containsKey('requestBody'),
                isTrue,
              );
              expect(
                postForFooMethodMethod['requestBody'],
                {
                  'content': {
                    'application/json': {
                      'schema': {
                        'type': 'object',
                        'properties': {
                          'id': {'type': 'integer'},
                          'name': {'type': 'string'},
                          'amount': {'type': 'number'},
                          'items': {
                            'type': 'array',
                            'items': {'type': 'string'}
                          }
                        }
                      },
                    },
                  },
                  'required': true
                },
              );
            },
          );

          test(
            'with valid responses.',
            () {
              expect(
                postForFooMethodMethod.containsKey('responses'),
                isTrue,
              );
              expect(
                postForFooMethodMethod['responses'],
                {
                  '200': {
                    'description': 'Success',
                    'content': {
                      'application/json': {
                        'schema': {
                          'type': 'object',
                          'additionalProperties': {
                            '\$ref': '#/components/schemas/AnyValue'
                          }
                        }
                      }
                    }
                  },
                  '400': {
                    'description':
                        'Bad request (the query passed to the server was incorrect).'
                  },
                  '403': {
                    'description':
                        "Forbidden (the caller is trying to call a restricted endpoint, but doesn't have the correct credentials/scope)."
                  },
                  '500': {'description': 'Internal server error.'}
                },
              );
            },
          );
        },
      );

      group(
        'then the components is generated',
        () {
          Map components = openAPISchema['components'];
          test('with all required keys.', () {
            expect(components.containsKey('schemas'), isTrue);
            expect(components.containsKey('securitySchemes'), isTrue);
          });
          Map schemas = components['schemas'];
          test('without ServerOnly schema.', () {
            expect(schemas.containsKey('ServerOnlyClass'), isFalse);
          });
          test(
            'with all excepted schemas count.',
            () {
              expect(
                schemas.length,
                equals(5),
              );
            },
          );

          test(
            'with ServerOnlyField class without secret field.',
            () {
              expect(schemas.containsKey('ServerOnlyFieldClass'), isTrue);
              Map classProperties =
                  schemas['ServerOnlyFieldClass']['properties'];
              expect(classProperties.containsKey('secret'), isFalse);
            },
          );

          test('with Example schema.', () {
            expect(schemas.containsKey('Example'), isTrue);
            expect(
              schemas['Example'],
              {
                'type': 'object',
                'properties': {
                  'name': {
                    'type': 'string',
                  }
                }
              },
            );
          });

          test('with TestEnum schema.', () {
            expect(schemas.containsKey('TestEnum'), isTrue);
            expect(
              schemas['TestEnum'],
              {
                'type': 'string',
                'enum': [
                  'A',
                  'B',
                  'C',
                ]
              },
            );
          });
          test('with AnyValue schema.', () {
            expect(schemas.containsKey('AnyValue'), isTrue);
            expect(
              schemas['AnyValue'],
              {},
            );
          });
          test('with ClassWithNullableField schema.', () {
            expect(schemas.containsKey('ClassWithNullableField'), isTrue);
            expect(schemas['ClassWithNullableField'], {
              'type': 'object',
              'properties': {
                'accountBalance': {'type': 'number'},
                'isTrue': {'type': 'boolean', 'nullable': true},
                'totalDebt': {'type': 'number', 'nullable': true},
                'funding': {'type': 'number', 'nullable': true},
                'findName': {'type': 'string', 'nullable': true},
                'example': {'\$ref': '#/components/schemas/Example'},
                'amount': {'type': 'integer', 'nullable': true}
              }
            });
          });

          test('with valid securitySchemes', () {
            Map securitySchemes = components['securitySchemes'];
            expect(securitySchemes.containsKey('serverpodAuth'), isTrue);
            expect(
              securitySchemes,
              {
                'serverpodAuth': {
                  'type': 'apiKey',
                  'name': 'api_key',
                  'in': 'header'
                }
              },
            );
          });
        },
      );
    },
  );
}
