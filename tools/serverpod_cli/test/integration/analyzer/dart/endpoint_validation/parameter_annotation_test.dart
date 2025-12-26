import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoints_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

import '../../../../test_util/endpoint_validation_helpers.dart';

var pathToServerpodRoot = Directory('../..').absolute.path;
var testProjectDirectory = Directory.systemTemp.createTempSync('cli_test_');

void main() {
  setUpAll(() async {
    await createTestEnvironment(testProjectDirectory, pathToServerpodRoot);
  });

  tearDownAll(() {
    testProjectDirectory.deleteSync(recursive: true);
  });

  group(
    'Given endpoint method with @deprecated parameter annotation when analyzed',
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

class TestEndpoint extends Endpoint {
  Future<String> testMethod(Session session, @deprecated String param) async {
    return param;
  }
}
''');

        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test(
        'then parameter has deprecated annotation.',
        () {
          var endpoint = endpointDefinitions.firstWhere(
            (e) => e.className == 'TestEndpoint',
          );
          
          var method = endpoint.methods.first;
          var parameter = method.parameters.first;

          expect(parameter.annotations, hasLength(1));
          expect(parameter.annotations.first.name, 'deprecated');
        },
      );
    },
  );

  group(
    'Given endpoint method with @Deprecated parameter annotation when analyzed',
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

class TestEndpoint extends Endpoint {
  Future<String> testMethod(Session session, @Deprecated('param is deprecated') String param) async {
    return param;
  }
}
''');

        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test(
        'then parameter has Deprecated annotation with message.',
        () {
          var endpoint = endpointDefinitions.firstWhere(
            (e) => e.className == 'TestEndpoint',
          );
          
          var method = endpoint.methods.first;
          var parameter = method.parameters.first;

          expect(parameter.annotations, hasLength(1));
          expect(parameter.annotations.first.name, 'Deprecated');
          expect(parameter.annotations.first.arguments, isNotNull);
          expect(parameter.annotations.first.arguments!.first, contains('param is deprecated'));
        },
      );
    },
  );
}
