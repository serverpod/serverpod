import 'dart:io';

import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoints_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/endpoint_validation_helpers.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

const pathToServerpodRoot = '../../../../../../../..';
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
    await createTestEnvironment(testProjectDirectory, pathToServerpodRoot);
  });

  tearDownAll(() {
    testProjectDirectory.deleteSync(recursive: true);
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

    test('then validation error for invalid Dart syntax is reported.', () {
      expect(collector.errors, hasLength(1));
      expect(
        collector.errors.firstOrNull?.message,
        contains(
          'Endpoint analysis skipped due to invalid Dart syntax. Please '
          'review and correct the syntax errors.',
        ),
      );
    });

    test('then endpoint definition is not created.', () {
      expect(endpointDefinitions, isEmpty);
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

    test('then validation error for invalid Dart syntax is reported.', () {
      expect(collector.errors, hasLength(1));
      expect(
        collector.errors.firstOrNull?.message,
        contains(
          'Endpoint analysis skipped due to invalid Dart syntax. Please '
          'review and correct the syntax errors.',
        ),
      );
    });

    test('then endpoint definition is not created.', () {
      expect(endpointDefinitions, isEmpty);
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

    test('then validation error for invalid Dart syntax is reported.', () {
      expect(collector.errors, hasLength(1));
      expect(
        collector.errors.firstOrNull?.message,
        contains(
          'Endpoint analysis skipped due to invalid Dart syntax. Please '
          'review and correct the syntax errors.',
        ),
      );
    });

    test('then endpoint definition is not created.', () {
      expect(endpointDefinitions, isEmpty);
    });
  });

  group('Given a valid and an invalid endpoint file when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory =
        Directory(path.join(testProjectDirectory.path, const Uuid().v4()));

    late List<EndpointDefinition> endpointDefinitions;
    late EndpointsAnalyzer analyzer;
    setUpAll(() async {
      var firstEndpointFile =
          File(path.join(testDirectory.path, 'invalid_endpoint.dart'));
      firstEndpointFile.createSync(recursive: true);
      firstEndpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpointInvalid extends Endpoint {
  Future<String> hello(Session session, String name) async {
''');
      var secondEndpointFile =
          File(path.join(testDirectory.path, 'valid_endpoint.dart'));
      secondEndpointFile.createSync(recursive: true);
      secondEndpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleEndpointValid extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then validation error for invalid Dart syntax is reported.', () {
      expect(collector.errors, hasLength(1));
      expect(
        collector.errors.firstOrNull?.message,
        contains(
          'Endpoint analysis skipped due to invalid Dart syntax. Please '
          'review and correct the syntax errors.',
        ),
      );
    });

    test('then one endpoint definitions is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });
  });
}
