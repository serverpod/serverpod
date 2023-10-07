import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';

import 'package:test/test.dart';

void main() {
  group('Validation of JSON Serialization for All OpenAPI Objects: ', () {
    test(
      'Validate Info Object',
      () {
        InfoObject infoObject = InfoObject(
          title: 'Swagger Petstore - OpenAPI 3.0',
          version: '1.0.1',
          termsOfService: Uri.parse('http://swagger.io/terms/'),
          description:
              'This is a sample Pet Store Server based on the OpenAPI 3.0',
        );
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
      LicenseObject licenseObject = LicenseObject(
        name: 'Apache 2.0',
        url: Uri.parse('http://www.apache.org/licenses/LICENSE-2.0.html'),
      );
      expect(
        {
          'name': 'Apache 2.0',
          'url': 'http://www.apache.org/licenses/LICENSE-2.0.html'
        },
        licenseObject.toJson(),
      );
    });

    test('Validate Contact Object', () {
      ContactObject contactObject = ContactObject(
        name: 'Ye Lin Aung',
        url: Uri.https('serverpod.dev'),
        email: 'example@email.com',
      );

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
      ServerObject serverObject = ServerObject(
        url: Uri.http('localhost:8080'),
        description: 'Development Server',
      );
      expect(
        {
          'url': 'http://localhost:8080',
          'description': 'Development Server',
        },
        serverObject.toJson(),
      );
    });

    test('Validate TagObject', () {
      TagObject tagObject = TagObject(
        name: 'pet',
        description: 'Everything about your Pets',
      );
      expect({
        'name': 'pet',
        'description': 'Everything about your Pets',
      }, tagObject.toJson());
    });

    test('Validate ExternalDocumentation Object', () {
      ExternalDocumentationObject object = ExternalDocumentationObject(
        url: Uri.http('swagger.io'),
        description: 'Find out more',
      );
      expect({'description': 'Find out more', 'url': 'http://swagger.io'},
          object.toJson());
    });

    test(
      'Validate Content Object With Response',
      () {
        ContentObject contentObject = ContentObject(
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
        ContentObject contentObject = ContentObject(
          requestContentSchemaObject: RequestContentSchemaObject(
            params: [
              ParameterDefinition(
                  name: 'age',
                  type: TypeDefinition(className: 'int', nullable: false),
                  required: true),
            ],
          ),
        );
        expect({
          'application/json': {
            'schema': {
              'type': 'object',
              'properties': {
                'age': {'type': 'integer'}
              },
            },
          },
        }, contentObject.toJson());
      },
    );

    test('Validate OperationObject', () {
      // var responses = ResponseObject(
      //   responseType: ContentObject(
      //     contentTypes: [ContentType.applicationJson],
      //     responseSchemaObject: ContentSchemaObject(
      //       returnType: TypeDefinition(
      //         className: 'Future',
      //         url: 'dart:core',
      //         nullable: false,
      //         generics: [
      //           TypeDefinition(
      //             className: 'int',
      //             nullable: false,
      //             url: 'dart:core',
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // );

      // var authParam = ParameterObject(
      //   name: 'api_key',
      //   inField: ParameterLocation.header,
      //   requiredField: true,
      //   allowEmptyValue: false,
      //   schema: ParameterSchemaObject(
      //     TypeDefinition(
      //       className: 'String',
      //       nullable: false,
      //       url: 'dart:core',
      //     ),
      //   ),
      // );
      // var petIdParam = ParameterObject(
      //   name: 'petId',
      //   inField: ParameterLocation.path,
      //   requiredField: true,
      //   allowEmptyValue: false,
      //   schema: ParameterSchemaObject(
      //     TypeDefinition(
      //       className: 'int',
      //       nullable: false,
      //       url: 'dart:core',
      //     ),
      //   ),
      // );
      // OperationObject object = OperationObject(
      //   responses: responses,
      //   security: SecurityRequirementObject(),
      //   parameters: [authParam, petIdParam],
      //   tags: ['pet'],
      //   operationId: 'getPetById',
      // );

      // expect({
      //   'tags': ['pet'],
      //   'operationId': 'getPetById',
      //   'parameters': [
      //     {
      //       'name': 'api_key',
      //       'in': 'header',
      //       'required': true,
      //       'schema': {'type': 'string'}
      //     },
      //     {
      //       'name': 'petId',
      //       'in': 'path',
      //       'required': true,
      //       'schema': {'type': 'integer'}
      //     }
      //   ],
      //   'responses': {
      //     '200': {
      //       'description': 'Success',
      //       'content': {
      //         'application/json': {
      //           'schema': {
      //             'type': 'integer',
      //           }
      //         }
      //       }
      //     },
      //     '400': {
      //       'description':
      //           'Bad request (the query passed to the server was incorrect).'
      //     },
      //     '403': {
      //       'description':
      //           "Forbidden (the caller is trying to call a restricted endpoint, but doesn't have the correct credentials/scope)."
      //     },
      //     '500': {'description': 'Internal server error '}
      //   }
      // }, object.toJson());
    });

    test('Validate PathItemObject', () {
      var security = {
        SecurityRequirementObject(
          name: 'serverpodAuth',
          securitySchemes: HttpSecurityScheme(
            scheme: 'bearer',
            bearerFormat: 'JWT',
          ),
        ),
      };
      OperationObject post = OperationObject(
        security: security,
        parameters: [],
        tags: ['pet'],
        operationId: 'getPetById',
        requestBody: RequestBodyObject(
          parameterList: [
            ParameterDefinition(
                name: 'id',
                type: TypeDefinition(className: 'int', nullable: false),
                required: true),
          ],
        ),
        responses: ResponseObject(
          responseType: TypeDefinition(
            className: 'Pet',
            nullable: true,
          ),
        ),
      );
      PathItemObject pathItemObject = PathItemObject(
        summary: 'Summary',
        description: 'Description',
        postOperation: post,
      );
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
            '500': {'description': 'Internal server error '}
          },
          'security': [
            {'serverpodAuth': []}
          ],
        },
      }, pathItemObject.toJson());
    });

    test('Validate ServerObject', () {
      ServerObject serverObject = ServerObject(
        url: Uri.https('serverpod.dev'),
        description: 'Serverpod Endpoint',
      );
      expect(
        {
          'url': 'https://serverpod.dev',
          'description': 'Serverpod Endpoint',
        },
        serverObject.toJson(),
      );
    });
  });
}
