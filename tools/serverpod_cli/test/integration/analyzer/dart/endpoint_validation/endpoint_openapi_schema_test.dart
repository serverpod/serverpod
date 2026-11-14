// The tests walk decoded JSON documents, so dynamic access is intended.
// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/generator/yaml/openapi_generator.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_class_definition_builder.dart';
import '../../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../../test_util/endpoint_validation_helpers.dart';
import '../../../../test_util/file_system_entity_helpers.dart';

var testProjectDirectory = Directory.systemTemp.createTempSync('cli_test_');

void main() {
  setUpAll(() async {
    await createTestEnvironment(testProjectDirectory);
  });

  tearDownAll(() async {
    await testProjectDirectory.deleteWithRetry(recursive: true);
  });

  group('Given endpoints returning analyzed types when building the spec', () {
    var collector = CodeGenerationCollector();
    var testDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );

    late Map<String, dynamic> spec;
    setUpAll(() async {
      File(path.join(testDirectory.path, 'endpoint.dart'))
        ..createSync(recursive: true)
        ..writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

// Stands in for the generated class of the project model.
class Greeting {}

// Declared as an extra class in generator.yaml, so it has no model definition.
class Custom {
  final int? id;
  final String name;
  final bool isHealthy;
  final double value;
  final DateTime timestamp;
  Custom(this.id, this.name, this.isHealthy, this.value, this.timestamp);
}

class ExampleEndpoint extends Endpoint {
  /// A project model.
  Future<Greeting> project(Session session) async => throw UnimplementedError();

  /// A type with no model definition in the project.
  Future<List<Custom>> external(Session session) async =>
      throw UnimplementedError();
}
''');

      var projectModel = ModelClassDefinitionBuilder()
          .withClassName('Greeting')
          .withFileName('greeting')
          .withModuleAlias('protocol')
          .withSimpleField('message', 'String')
          .withField(
            FieldDefinitionBuilder()
                .withName('author')
                .withJsonKeyOverride('by')
                .withTypeDefinition('String', true)
                .build(),
          )
          .build();

      var definitions =
          await EndpointsAnalyzer(
            testDirectory,
            extraClasses: [
              parseType(
                'package:test_server/custom.dart:Custom',
                extraClasses: null,
              ),
            ],
          ).analyze(
            collector: collector,
            models: [projectModel],
          );

      var config = GeneratorConfigBuilder()
          .withOpenApi(const OpenApiConfig(enabled: true))
          .build();
      spec = jsonDecode(
        jsonEncode(
          buildOpenApiSpec(
            ProtocolDefinition(
              endpoints: definitions,
              models: [projectModel],
              futureCalls: const [],
            ),
            config,
          ),
        ),
      );
    });

    Map<String, dynamic> responseSchema(String method) =>
        spec['paths']['/example/$method']['post']['responses']['200']['content']['application/json']['schema'];

    test('then the endpoints are analyzed without errors.', () {
      expect(collector.errors, isEmpty);
    });

    test('then the Postman CLI finds no syntax issues in the spec.', () async {
      var specFile = File(path.join(testDirectory.path, 'openapi.json'))
        ..writeAsStringSync(jsonEncode(spec));

      ProcessResult result;
      try {
        result = await Process.run(
          'postman',
          ['spec', 'lint', specFile.path, '--issueType=syntax'],
          runInShell: true,
        );
      } on ProcessException {
        markTestSkipped('The Postman CLI is not installed.');
        return;
      }
      if (result.exitCode != 0 &&
          !'${result.stdout}'.contains('No issues found')) {
        // Not installed (reported by the shell, not as an exception).
        if ('${result.stderr}'.contains('not recognized') ||
            '${result.stderr}'.contains('not found')) {
          markTestSkipped('The Postman CLI is not installed.');
          return;
        }
      }

      expect(result.stdout, contains('Type: OpenAPI 3.1'));
      expect(result.stdout, contains('No issues found'));
    });

    test('then a project model is resolved to a schema reference.', () {
      expect(responseSchema('project'), {
        r'$ref': '#/components/schemas/Greeting',
      });
      expect(spec['components']['schemas']['Greeting']['properties'], {
        'message': {'type': 'string'},
        'by': {
          'type': ['string', 'null'],
        },
      });
    });

    test(
      'then a type without a model definition is described from its Dart '
      'declaration.',
      () {
        var schema = responseSchema('external');
        expect(schema['type'], 'array');
        expect(schema['items'], {
          r'$ref': '#/components/schemas/Custom',
        });

        var metric = spec['components']['schemas']['Custom'];
        expect(metric['properties']['name'], {'type': 'string'});
        expect(metric['properties']['isHealthy'], {'type': 'boolean'});
        expect(metric['properties']['value']['type'], 'number');
        expect(metric['properties']['timestamp']['format'], 'date-time');
        expect(metric['properties']['id']['type'], ['integer', 'null']);
        expect(metric['required'], isNot(contains('id')));
        expect(metric['required'], contains('name'));
      },
    );
  });
}
