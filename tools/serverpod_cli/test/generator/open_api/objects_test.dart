import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/generator/open_api/open_api_definition.dart';
import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';

import 'package:test/test.dart';

void main() {
  group('Validation of JSON Serialization for All OpenAPI Objects: ', () {
    var security = {
      OpenAPISecurityRequirement(
        name: 'serverpodAuth',
        securitySchemes: HttpSecurityScheme(
          scheme: 'bearer',
          bearerFormat: 'JWT',
        ),
      ),
    };
    OpenAPILicense licenseObject = OpenAPILicense(
      name: 'Apache 2.0',
      url: Uri.parse('http://www.apache.org/licenses/LICENSE-2.0.html'),
    );
    OpenAPIContact contactObject = OpenAPIContact(
      name: 'Ye Lin Aung',
      url: Uri.https('serverpod.dev'),
      email: 'example@email.com',
    );
    OpenAPIServer serverObject = OpenAPIServer(
      url: Uri.http('localhost:8080'),
      description: 'Development Server',
    );
    OpenAPIConfig infoObject = OpenAPIConfig(
      title: 'Swagger Petstore - OpenAPI 3.0',
      version: '1.0.1',
      termsOfService: Uri.parse('http://swagger.io/terms/'),
      description: 'This is a sample Pet Store Server based on the OpenAPI 3.0',
    );
    OpenAPITag tagObject = OpenAPITag(
      name: 'pet',
      description: 'Everything about your Pets',
    );
    OpenAPIContent contentObject = OpenAPIContent(
      responseType: TypeDefinition(
        className: 'Future',
        nullable: false,
        generics: [
          TypeDefinition(
            className: 'String',
            nullable: false,
          ),
        ],
      ),
    );
    OpenAPIContent contentObjectRequest = OpenAPIContent(
      requestContentSchemaObject: OpenAPIRequestContentSchema(
        params: [
          ParameterDefinition(
              name: 'age',
              type: TypeDefinition(className: 'int', nullable: false),
              required: true),
        ],
      ),
    );
    OpenAPIExternalDocumentation object = OpenAPIExternalDocumentation(
      url: Uri.http('swagger.io'),
      description: 'Find out more',
    );
    OperationObject post = OperationObject(
      security: security,
      parameters: [],
      tags: ['pet'],
      operationId: 'getPetById',
      requestBody: OpenAPIRequestBody(
        parameterList: [
          ParameterDefinition(
              name: 'id',
              type: TypeDefinition(className: 'int', nullable: false),
              required: true),
        ],
      ),
      responses: OpenAPIResponse(
        responseType: TypeDefinition(
          className: 'Pet',
          nullable: true,
        ),
      ),
    );
    OpenAPIPathItem pathItemObject = OpenAPIPathItem(
      summary: 'Summary',
      description: 'Description',
      postOperation: post,
    );
    OpenAPIPaths pathsObject = OpenAPIPaths(
      pathName: '/api/v1/',
      path: pathItemObject,
    );
    OpenAPIComponents componentsObject = OpenAPIComponents(securitySchemes: {
      serverpodAuth
    }, schemas: {
      OpenAPIComponentSchema(
        ClassDefinition(
            fileName: 'example.dart',
            sourceFileName: '',
            className: 'Example',
            fields: [
              SerializableEntityFieldDefinition(
                  name: 'name',
                  type: TypeDefinition(className: 'String', nullable: false),
                  scope: EntityFieldScopeDefinition.all,
                  shouldPersist: true)
            ],
            serverOnly: true,
            isException: false),
      )
    });
    test(
      'Validate Info Object',
      () {
        expect(
          {
            'title': 'Swagger Petstore - OpenAPI 3.0',
            'termsOfService': 'http://swagger.io/terms/',
            'version': '1.0.1',
            'description':
                'This is a sample Pet Store Server based on the OpenAPI 3.0'
          },
          infoObject.toJson(),
        );
      },
    );

    test('Validate License Object', () {
      expect(
        {
          'name': 'Apache 2.0',
          'url': 'http://www.apache.org/licenses/LICENSE-2.0.html'
        },
        licenseObject.toJson(),
      );
    });

    test('Validate Contact Object', () {
      expect(
        {
          'name': 'Ye Lin Aung',
          'url': 'https://serverpod.dev',
          'email': 'example@email.com',
        },
        contactObject.toJson(),
      );
    });

    test('Validate ServerObject with null variables', () {
      expect(
        {
          'url': 'http://localhost:8080',
          'description': 'Development Server',
        },
        serverObject.toJson(),
      );
    });

    test('Validate TagObject', () {
      expect({
        'name': 'pet',
        'description': 'Everything about your Pets',
      }, tagObject.toJson());
    });

    test('Validate ExternalDocumentation Object', () {
      expect({'description': 'Find out more', 'url': 'http://swagger.io'},
          object.toJson());
    });

    test(
      'Validate Content Object With Response',
      () {
        expect({
          'application/json': {
            'schema': {'type': 'string'}
          },
        }, contentObject.toJson());
      },
    );
    test(
      'Validate Content Object with Request',
      () {
        expect({
          'application/json': {
            'schema': {
              'type': 'object',
              'properties': {
                'age': {'type': 'integer'}
              },
            },
          },
        }, contentObjectRequest.toJson());
      },
    );

    test('Validate OperationObject', () {
      expect({
        'tags': ['pet'],
        'operationId': 'getPetById',
        'requestBody': {
          'content': {
            'application/json': {
              'schema': {
                'type': 'object',
                'properties': {
                  'id': {'type': 'integer'}
                }
              }
            }
          },
          'required': true
        },
        'responses': {
          '200': {
            'description': 'Success',
            'content': {
              'application/json': {
                'schema': {
                  '\$ref': '#/components/schemas/Pet',
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
        'security': [
          {'serverpodAuth': []}
        ],
      }, post.toJson());
    });

    test('Validate PathItemObject', () {
      expect({
        'summary': 'Summary',
        'description': 'Description',
        'post': {
          'tags': ['pet'],
          'operationId': 'getPetById',
          'requestBody': {
            'content': {
              'application/json': {
                'schema': {
                  'type': 'object',
                  'properties': {
                    'id': {'type': 'integer'}
                  }
                }
              }
            },
            'required': true
          },
          'responses': {
            '200': {
              'description': 'Success',
              'content': {
                'application/json': {
                  'schema': {
                    '\$ref': '#/components/schemas/Pet',
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
          'security': [
            {'serverpodAuth': []}
          ],
        },
      }, pathItemObject.toJson());
    });

    test('Validate ServerObject', () {
      expect(
        {
          'url': 'http://localhost:8080',
          'description': 'Development Server',
        },
        serverObject.toJson(),
      );
    });
    test('Validate PathsObject', () {
      expect({
        '/api/v1/': {
          'summary': 'Summary',
          'description': 'Description',
          'post': {
            'tags': ['pet'],
            'operationId': 'getPetById',
            'requestBody': {
              'content': {
                'application/json': {
                  'schema': {
                    'type': 'object',
                    'properties': {
                      'id': {'type': 'integer'}
                    }
                  }
                }
              },
              'required': true
            },
            'responses': {
              '200': {
                'description': 'Success',
                'content': {
                  'application/json': {
                    'schema': {
                      '\$ref': '#/components/schemas/Pet',
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
            'security': [
              {'serverpodAuth': []}
            ],
          },
        },
      }, pathsObject.toJson());
    });
    test('Validate ComponentObject', () {
      expect(
        {
          'schemas': {
            'Example': {
              'type': 'object',
              'properties': {
                'name': {'type': 'string'}
              }
            }
          },
          'securitySchemes': {
            'serverpodAuth': {
              'type': 'http',
              'scheme': 'bearer',
              'bearerFormat': 'JWT'
            }
          }
        },
        componentsObject.toJson(),
      );
    });
    test('Validate OpenApi', () {
      var openApi = OpenAPIDefinition(
          info: infoObject,
          servers: {serverObject},
          tags: {tagObject},
          paths: {pathsObject},
          components: componentsObject);
      expect(
        {
          'openapi': '3.0.0',
          'info': {
            'title': 'Swagger Petstore - OpenAPI 3.0',
            'version': '1.0.1',
            'description':
                'This is a sample Pet Store Server based on the OpenAPI 3.0',
            'termsOfService': 'http://swagger.io/terms/'
          },
          'servers': [
            {
              'url': 'http://localhost:8080',
              'description': 'Development Server'
            }
          ],
          'tags': [
            {'name': 'pet', 'description': 'Everything about your Pets'}
          ],
          'paths': {
            '/api/v1/': {
              'summary': 'Summary',
              'description': 'Description',
              'post': {
                'operationId': 'getPetById',
                'tags': ['pet'],
                'requestBody': {
                  'content': {
                    'application/json': {
                      'schema': {
                        'type': 'object',
                        'properties': {
                          'id': {'type': 'integer'}
                        }
                      }
                    }
                  },
                  'required': true
                },
                'security': [
                  {'serverpodAuth': []}
                ],
                'responses': {
                  '200': {
                    'description': 'Success',
                    'content': {
                      'application/json': {
                        'schema': {'\$ref': '#/components/schemas/Pet'}
                      }
                    }
                  },
                  '400': {
                    'description':
                        'Bad request (the query passed to the server was incorrect).'
                  },
                  '403': {
                    'description':
                        'Forbidden (the caller is trying to call a restricted endpoint, but doesn\'t have the correct credentials/scope).'
                  },
                  '500': {'description': 'Internal server error.'}
                }
              }
            }
          },
          'components': {
            'schemas': {
              'Example': {
                'type': 'object',
                'properties': {
                  'name': {'type': 'string'}
                }
              }
            },
            'securitySchemes': {
              'serverpodAuth': {
                'type': 'http',
                'scheme': 'bearer',
                'bearerFormat': 'JWT'
              }
            }
          }
        },
        openApi.toJson(),
      );
    });
  });
}
