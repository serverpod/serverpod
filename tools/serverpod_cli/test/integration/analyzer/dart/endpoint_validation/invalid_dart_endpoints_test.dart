import 'dart:io';

import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoints_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/endpoint_validation_helpers.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

const pathToServerpod = '../../../../../../../../packages/serverpod';
var testProjectDirectory = Directory(path.joinAll([
  'test',
  'integration',
  'analyzer',
  'dart',
  'endpoint_validation',
  const Uuid().v4(),
]));

void main() {
  setUpAll(() async {
    await createTestEnvironment(testProjectDirectory, pathToServerpod);
  });

  tearDownAll(() {
    testProjectDirectory.deleteSync(recursive: true);
  });

  group('Given an endpoint file with nothing defined when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory =
        Directory(path.join(testProjectDirectory.path, const Uuid().v4()));

    late List<EndpointDefinition> endpointDefinitions;
    late EndpointsAnalyzer analyzer;
    setUpAll(() async {
      var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
      endpointFile.createSync(recursive: true);
      // Empty file
      endpointFile.writeAsStringSync('''
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then no parsing errors are reported.', () {
      expect(analyzer.getErrors(), completion(isEmpty));
    });

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then no endpoint definition are created.', () {
      expect(endpointDefinitions, isEmpty);
    });
  });

  group(
      'Given an endpoint file with incomplete endpoint class defined when analyzed',
      () {
    var collector = CodeGenerationCollector();
    var testDirectory =
        Directory(path.join(testProjectDirectory.path, const Uuid().v4()));

    late List<EndpointDefinition> endpointDefinitions;
    late EndpointsAnalyzer analyzer;
    setUpAll(() async {
      var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
      endpointFile.createSync(recursive: true);
      // Class is missing closing brackets
      endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then parsing errors are reported.', () {
      expect(analyzer.getErrors(), completion(isNotEmpty));
    });

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then endpoint definition is still created.', () {
      expect(endpointDefinitions, isNotEmpty);
    });
  });

  group(
      'Given an endpoint file with incomplete endpoint method defined when analyzed',
      () {
    var collector = CodeGenerationCollector();
    var testDirectory =
        Directory(path.join(testProjectDirectory.path, const Uuid().v4()));

    late List<EndpointDefinition> endpointDefinitions;
    late EndpointsAnalyzer analyzer;
    setUpAll(() async {
      var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
      endpointFile.createSync(recursive: true);
      // Class and method are missing closing brackets
      // Method is missing return statement
      endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then parsing errors are reported.', () {
      expect(analyzer.getErrors(), completion(isNotEmpty));
    });

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then endpoint definition is still created.', () {
      expect(endpointDefinitions, isNotEmpty);
    });

    test('then endpoint method definition is still created.', () {
      var methods = endpointDefinitions.firstOrNull?.methods;
      expect(methods, isNotEmpty);
    });
  });

  group(
      'Given an endpoint method that returns a Future with multiple defined types',
      () {
    var collector = CodeGenerationCollector();
    var testDirectory =
        Directory(path.join(testProjectDirectory.path, const Uuid().v4()));

    late List<EndpointDefinition> endpointDefinitions;
    late EndpointsAnalyzer analyzer;
    setUpAll(() async {
      var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
      endpointFile.createSync(recursive: true);
      endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String, int> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then parsing errors are reported.', () {
      expect(analyzer.getErrors(), completion(isNotEmpty));
    });

    test('then a validation errors is reported.', () {
      expect(collector.errors, hasLength(1));
    });

    test('then validation error informs that return type must be future', () {
      expect(
        collector.errors.firstOrNull?.message,
        'Future must have a type defined. E.g. Future<String>.',
      );
    });

    test('then endpoint definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });

    test('then no endpoint method definition is created.', () {
      var methods = endpointDefinitions.firstOrNull?.methods;
      expect(methods, isEmpty);
    });
  });
}
