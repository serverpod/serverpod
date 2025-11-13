import 'dart:io';

import 'package:path/path.dart' as path;
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
    'Given endpoint class with @unauthenticatedClientCall annotation and child class when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;

      setUpAll(() async {
        File(path.join(testDirectory.path, 'endpoint.dart'))
          ..createSync(recursive: true)
          ..writeAsStringSync('''

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/annotations.dart';

@unauthenticatedClientCall
abstract class BaseEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}

class ChildEndpoint extends BaseEndpoint {}
''');

        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test(
        'then child endpoint inherits unauthenticatedClientCall annotation.',
        () {
          var childEndpoint = endpointDefinitions.firstWhere(
            (e) => e.className == 'ChildEndpoint',
          );

          expect(childEndpoint.annotations, hasLength(1));
          expect(
            childEndpoint.annotations.first.name,
            'unauthenticatedClientCall',
          );
        },
      );
    },
  );

  group(
    'Given endpoint class with @doNotGenerate annotation and child class when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;

      setUpAll(() async {
        File(path.join(testDirectory.path, 'endpoint.dart'))
          ..createSync(recursive: true)
          ..writeAsStringSync('''

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/annotations.dart';

@doNotGenerate
abstract class BaseEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}

class ChildEndpoint extends BaseEndpoint {}
''');

        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test(
        'then child endpoint does not inherit doNotGenerate annotation.',
        () {
          var childEndpoint = endpointDefinitions.firstWhere(
            (e) => e.className == 'ChildEndpoint',
          );

          expect(childEndpoint.annotations, hasLength(0));
        },
      );
    },
  );

  group(
    'Given child class with additional annotation different from parent annotation when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<EndpointDefinition> endpointDefinitions;
      late EndpointsAnalyzer analyzer;

      setUpAll(() async {
        File(path.join(testDirectory.path, 'endpoint.dart'))
          ..createSync(recursive: true)
          ..writeAsStringSync('''

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/annotations.dart';

@unauthenticatedClientCall
abstract class BaseEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}

@deprecated
class ChildEndpoint extends BaseEndpoint {}
''');

        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test(
        'then child class has the inherited annotation and its own annotation.',
        () {
          var childEndpoint = endpointDefinitions.firstWhere(
            (e) => e.className == 'ChildEndpoint',
          );

          expect(childEndpoint.annotations, hasLength(2));
          expect(
            childEndpoint.annotations.has('unauthenticatedClientCall'),
            isTrue,
          );
          expect(childEndpoint.annotations.has('deprecated'), isTrue);
        },
      );
    },
  );

  group('Given multi-level inheritance with annotations when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );

    late List<EndpointDefinition> endpointDefinitions;
    late EndpointsAnalyzer analyzer;

    setUpAll(() async {
      File(path.join(testDirectory.path, 'endpoint.dart'))
        ..createSync(recursive: true)
        ..writeAsStringSync('''

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/annotations.dart';

@unauthenticatedClientCall
abstract class GrandparentEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}

abstract class ParentEndpoint extends GrandparentEndpoint {}

class ChildEndpoint extends ParentEndpoint {}
''');

      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then child endpoint inherits annotation from grandparent.', () {
      var childEndpoint = endpointDefinitions.firstWhere(
        (e) => e.className == 'ChildEndpoint',
      );

      expect(childEndpoint.annotations, hasLength(1));
      expect(childEndpoint.annotations.first.name, 'unauthenticatedClientCall');
    });
  });
}
