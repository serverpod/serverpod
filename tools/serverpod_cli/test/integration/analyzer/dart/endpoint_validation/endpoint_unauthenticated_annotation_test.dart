import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoints_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

import '../../../../test_util/endpoint_validation_helpers.dart';

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

  group('Given an endpoint class annotated with @unauthenticated when analyzed',
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
import 'package:serverpod_shared/annotations.dart';

@unauthenticated
class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then the endpoint class definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });

    test('then the endpoint class also has @unauthenticated annotation.', () {
      var endpoint = endpointDefinitions.first;
      expect(endpoint.annotations, hasLength(1));
      expect(endpoint.annotations.first.name, 'unauthenticated');
    });
  });

  group(
      'Given an endpoint method annotated with @unauthenticated when analyzed',
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
import 'package:serverpod_shared/annotations.dart';

class ExampleEndpoint extends Endpoint {
  @unauthenticated
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }

  Future<String> authenticated(Session session, String name) async {
    return 'Hello authenticated \$name';
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then the endpoint class definition is created.', () {
      expect(endpointDefinitions, hasLength(1));
    });

    test('then the annotated method also has @unauthenticated annotation.', () {
      var endpoint = endpointDefinitions.first;
      var helloMethod = endpoint.methods.firstWhere((m) => m.name == 'hello');
      expect(helloMethod.annotations, hasLength(1));
      expect(helloMethod.annotations.first.name, 'unauthenticated');
    });

    test('then non-annotated method has no @unauthenticated annotation.', () {
      var endpoint = endpointDefinitions.first;
      var authenticatedMethod =
          endpoint.methods.firstWhere((m) => m.name == 'authenticated');
      expect(authenticatedMethod.annotations, isEmpty);
    });
  });
}
