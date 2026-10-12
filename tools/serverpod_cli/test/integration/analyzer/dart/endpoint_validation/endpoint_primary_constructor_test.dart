import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoints_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import '../../../../test_util/endpoint_validation_helpers.dart';
import '../../../../test_util/file_system_entity_helpers.dart';

var testProjectDirectory = Directory.systemTemp.createTempSync('cli_test_');

void main() {
  setUpAll(() async {
    await createTestEnvironment(
      testProjectDirectory,
      sdkConstraint: '^3.13.0',
    );
  });

  tearDownAll(() async {
    await testProjectDirectory.deleteWithRetry(recursive: true);
  });

  group(
    'Given an endpoint class declared with an empty primary constructor,'
    'when analyzed,',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint() extends Endpoint {
  Future<String> hello(Session session) async => 'hi';
}
''');
        var analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then endpoint definition is created with its method.', () {
        expect(endpointDefinitions, hasLength(1));
        expect(endpointDefinitions.firstOrNull?.className, 'ExampleEndpoint');
        expect(
          endpointDefinitions.firstOrNull?.methods.map((m) => m.name),
          ['hello'],
        );
      });
    },
  );

  group(
    'Given an endpoint class declared with a primary constructor that declares a field,'
    'when analyzed,',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint({final String greeting = 'hi'}) extends Endpoint {
  Future<String> hello(Session session) async => greeting;
}
''');
        var analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then endpoint definition is created with its method.', () {
        expect(endpointDefinitions, hasLength(1));
        expect(
          endpointDefinitions.firstOrNull?.methods.map((m) => m.name),
          ['hello'],
        );
      });
    },
  );
}
