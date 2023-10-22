import 'dart:convert';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/generator/open_api/open_api_objects.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import 'test_data_factory.dart';

void main() {
  var expectedFilePath = path.join('generated', 'openapi', 'openapi.json');

  var codeMap = openAPIgenerator.generateOpenAPISchema(
    protocolDefinition: exampleProtocolDefinition,
    config: generatorConfig,
  );
  Map<String, dynamic> openAPISchema = jsonDecode(
    jsonEncode(
      extractYamlContent(codeMap[expectedFilePath]!),
    ),
  );
  group('Given a single Endpoint and Entity when generating openapi schema',
      () {
    test('then openapi file is created', () {
      expect(
        codeMap,
        contains(
          expectedFilePath,
        ),
        reason: 'Expected openapi file to be present, found none.',
      );
    });
  });
  group(
    'Given an Example endpoint with hello method and path v1 when generating openAPI schema',
    () {
      test(
        'then the schema contains  all required keys.',
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
      Map<String, dynamic> post = paths['/v1/Example/hello']['post'];

      group(
        'then the post operation is generated',
        () {
          test(
            'with correct operationId.',
            () {
              expect(
                post['operationId'],
                equals('helloExample'),
              );
            },
          );
          test(
            'with tags list that contain Example tag.',
            () {
              expect(
                post['tags'],
                equals(['Example']),
              );
            },
          );
          test(
            'with the Hello description.',
            () {
              expect(
                post['description'],
                equals('Hello'),
              );
            },
          );

          test(
            'with valid requestBody.',
            () {
              expect(
                post.containsKey('requestBody'),
                isTrue,
              );
              expect(
                post['requestBody'],
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
                post.containsKey('responses'),
                isTrue,
              );
              expect(
                post['responses'],
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

      group(
        'then the components is generated',
        () {
          Map<String, dynamic> components = openAPISchema['components'];
          test('with all required keys.', () {
            expect(components.containsKey('schemas'), isTrue);
            expect(components.containsKey('securitySchemes'), isTrue);
          });

          test(
            'with valid schemas data.',
            () {
              Map<String, dynamic> schemas = components['schemas'];
              expect(
                schemas,
                {
                  'Example': {
                    'type': 'object',
                    'properties': {
                      'name': {
                        'type': 'string',
                      }
                    }
                  }
                },
              );
            },
          );

          test('with valid securitySchemes', () {
            Map<String, dynamic> securitySchemes =
                components['securitySchemes'];
            expect(securitySchemes.containsKey('serverpodAuth'), isTrue);
            expect(
              securitySchemes,
              serverpodAuth.toJson(),
            );
          });
        },
      );
    },
  );
}

YamlMap extractYamlContent(String fileContent) {
  YamlDocument document = loadYamlDocument(fileContent);
  return document.contents as YamlMap;
}
