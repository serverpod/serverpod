import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/open_api/open_api_definition.dart';
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

    /// Just to check. we will validate more in [ContentSchemaObject]
    test(
      'Validate Content Object',
      () {
        ContentObject contentObject = ContentObject(
          contentTypes: [
            ContentType.applicationJson,
          ],
          schemaObject: ContentSchemaObject(
            returnType: TypeDefinition(
              className: 'Future',
              nullable: false,
              generics: [
                TypeDefinition(
                  className: 'String',
                  nullable: false,
                ),
              ],
            ),
          ),
        );

        expect({
          'application/json': {
            'schema': {'type': 'string'}
          },
        }, contentObject.toJson());
      },
    );

    test('Validate OperationObject', () {
      var responses = ResponseObject(
        responseType: ContentObject(
          contentTypes: [ContentType.applicationJson],
          schemaObject: ContentSchemaObject(
            returnType: TypeDefinition(
              className: 'Future',
              nullable: false,
              generics: [
                TypeDefinition(
                  className: 'int',
                  nullable: false,
                ),
              ],
            ),
          ),
        ),
      );

      var authParam = ParameterObject(
        name: 'api_key',
        inField: ParameterLocation.header,
        requiredField: true,
        allowEmptyValue: false,
        schema: ParameterSchemaObject(
          TypeDefinition(className: 'String', nullable: false),
        ),
      );
      var petIdParam = ParameterObject(
        name: 'petId',
        inField: ParameterLocation.path,
        requiredField: true,
        allowEmptyValue: false,
        schema: ParameterSchemaObject(
          TypeDefinition(className: 'int', nullable: false),
        ),
      );
      OperationObject object = OperationObject(
        responses: responses,
        security: SecurityRequirementObject(),
        parameters: [authParam, petIdParam],
        tags: ['pet'],
        operationId: 'getPetById',
      );

      expect({
        'tags': ['pet'],
        'operationId': 'getPetById',
        'parameters': [
          {
            'name': 'api_key',
            'in': 'header',
            'required': true,
            'schema': {'type': 'string'}
          },
          {
            'name': 'petId',
            'in': 'path',
            'required': true,
            'schema': {'type': 'integer'}
          }
        ],
        'responses': {
          '200': {
            'description': 'Success',
            'content': {
              'application/json': {
                'schema': {
                  'type': 'integer',
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
        }
      }, object.toJson());
    });
  });
}
