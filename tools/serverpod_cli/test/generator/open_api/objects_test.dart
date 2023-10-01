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

    test('Validate Content Object with object [Pet]  ', () {
      ContentObject object = ContentObject(
        contentTypes: [ContentType.applicationJson],
        schemaObject: SchemaObject(
          schemaName: 'Pet',
          type: SchemaObjectType.object,
        ),
      );
      expect(
        {
          'application/json': {
            'schema': {
              '\$ref': '#/components/schemas/Pet',
            }
          }
        },
        object.toJson(),
      );
    });

    test('Validate Content Object with array of [Pet]', () {
      ContentObject object = ContentObject(
        contentTypes: [ContentType.applicationJson],
        schemaObject: SchemaObject(
          schemaName: 'Pet',
          type: SchemaObjectType.array,
        ),
      );
      expect(
        {
          'application/json': {
            'schema': {
              'type': 'array',
              'items': {
                '\$ref': '#/components/schemas/Pet',
              }
            }
          }
        },
        object.toJson(),
      );
    });
  });
}
