import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoints_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

import '../../../../test_util/endpoint_validation_helpers.dart';

const pathToServerpodRoot = '../../../../../../../..';
var testProjectDirectory = Directory(
  path.joinAll([
    'test',
    'integration',
    'analyzer',
    'dart',
    'endpoint_validation',
    const Uuid().v4(),
  ]),
);

void main() {
  setUpAll(() async {
    await createTestEnvironment(testProjectDirectory, pathToServerpodRoot);
  });

  tearDownAll(() {
    testProjectDirectory.deleteSync(recursive: true);
  });

  group(
    'Given an endpoint class annotated with @unauthenticatedClientCall when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;
      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/annotations.dart';

@unauthenticatedClientCall
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

      test(
        'then the endpoint class also has @unauthenticatedClientCall annotation.',
        () {
          var endpoint = endpointDefinitions.first;
          expect(endpoint.annotations, hasLength(1));
          expect(endpoint.annotations.first.name, 'unauthenticatedClientCall');
        },
      );
    },
  );

  group(
    'Given an endpoint method annotated with @unauthenticatedClientCall when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;
      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/annotations.dart';

class ExampleEndpoint extends Endpoint {
  @unauthenticatedClientCall
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

      test(
        'then the annotated method also has @unauthenticatedClientCall annotation.',
        () {
          var endpoint = endpointDefinitions.first;
          var helloMethod = endpoint.methods.firstWhere(
            (m) => m.name == 'hello',
          );
          expect(helloMethod.annotations, hasLength(1));
          expect(
            helloMethod.annotations.first.name,
            'unauthenticatedClientCall',
          );
        },
      );

      test(
        'then non-annotated method has no @unauthenticatedClientCall annotation.',
        () {
          var endpoint = endpointDefinitions.first;
          var authenticatedMethod = endpoint.methods.firstWhere(
            (m) => m.name == 'authenticated',
          );
          expect(authenticatedMethod.annotations, isEmpty);
        },
      );
    },
  );

  group(
    'Given an endpoint class annotated with @unauthenticatedClientCall and overriding requireLogin when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;
      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/annotations.dart';

@unauthenticatedClientCall
class ExampleEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then a validation info message is reported.', () {
        expect(collector.errors, hasLength(1));

        var error = collector.errors.first as SourceSpanSeverityException;
        expect(error.severity, SourceSpanSeverity.info);
        expect(
          error.message,
          'The endpoint class "ExampleEndpoint" overrides "requireLogin" '
          'getter and is annotated with @unauthenticatedClientCall. Be aware that this '
          'combination may lead to all endpoint calls failing due to client '
          'not sending a signed in user. To fix this, either remove the getter '
          'override or remove the @unauthenticatedClientCall annotation.',
        );
      });

      test('then the endpoint class definition is created.', () {
        expect(endpointDefinitions, hasLength(1));
      });
    },
  );

  group(
    'Given an endpoint class overriding requireLogin with a method annotated with @unauthenticatedClientCall when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;
      setUpAll(() async {
        var endpointFile = File(path.join(testDirectory.path, 'endpoint.dart'));
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/annotations.dart';

class ExampleEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @unauthenticatedClientCall
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

      test('then a validation info message is reported.', () {
        expect(collector.errors, hasLength(1));

        var error = collector.errors.first as SourceSpanSeverityException;
        expect(error.severity, SourceSpanSeverity.info);
        expect(
          error.message,
          'Method "hello" in endpoint class "ExampleEndpoint" is '
          'annotated with @unauthenticatedClientCall, but the class overrides the '
          '"requireLogin" getter. Be aware that this combination may lead to '
          'endpoint calls failing due to client not sending a signed in user. '
          'To fix this, either move this method to a separate endpoint class '
          'that does not override "requireLogin", remove the "requireLogin" '
          'getter override or remove the @unauthenticatedClientCall annotation.',
        );
      });

      test('then the endpoint class definition is created.', () {
        expect(endpointDefinitions, hasLength(1));
      });
    },
  );
}
