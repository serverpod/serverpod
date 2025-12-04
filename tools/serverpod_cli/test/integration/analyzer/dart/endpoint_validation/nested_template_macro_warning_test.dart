import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoints_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

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
    'Given an endpoint with nested template in class documentation when analyzed',
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

/// {@template outer.template}
/// Outer content line 1
/// {@template inner.template}
/// Inner content
/// {@endtemplate}
/// Outer content line 2
/// {@endtemplate}
class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then a warning is reported.', () {
        expect(collector.errors, hasLength(1));
        var error = collector.errors.first;
        expect(error, isA<SourceSpanSeverityException>());
        var severityError = error as SourceSpanSeverityException;
        expect(severityError.severity, SourceSpanSeverity.warning);
      });

      test(
        'then warning message contains file path and nested template information.',
        () {
          var error = collector.errors.first;
          expect(
            error.message,
            'Error extracting templates from ${path.join(testDirectory.absolute.path, 'endpoint.dart')}: '
            'Nested template found: "outer.template" in line: "/// {@template inner.template}". '
            'Please remove the nested template, as it is not supported.',
          );
        },
      );

      test(
        'then endpoint definition is still created despite the warning.',
        () {
          expect(endpointDefinitions, hasLength(1));
          expect(endpointDefinitions.first.name, 'example');
        },
      );
    },
  );

  group(
    'Given an endpoint with nested template in method documentation when analyzed',
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

class ExampleEndpoint extends Endpoint {
  /// {@template method.template}
  /// Method content line 1
  /// {@template nested.method.template}
  /// Nested method content
  /// {@endtemplate}
  /// Method content line 2
  /// {@endtemplate}
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then a warning is reported.', () {
        expect(collector.errors, hasLength(1));
        var error = collector.errors.first;
        expect(error, isA<SourceSpanSeverityException>());
        var severityError = error as SourceSpanSeverityException;
        expect(severityError.severity, SourceSpanSeverity.warning);
      });

      test('then warning message contains nested template information.', () {
        var error = collector.errors.first;
        expect(
          error.message,
          'Error extracting templates from ${path.join(testDirectory.absolute.path, 'endpoint.dart')}: '
          'Nested template found: "method.template" in line: "/// {@template nested.method.template}". '
          'Please remove the nested template, as it is not supported.',
        );
      });

      test(
        'then endpoint definition is still created despite the warning.',
        () {
          expect(endpointDefinitions, hasLength(1));
          expect(endpointDefinitions.first.name, 'example');
        },
      );
    },
  );

  group('Given an endpoint with nested macro in template when analyzed', () {
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

/// {@template example.template}
/// Some content
/// {@macro inner.template}
/// More content
/// {@endtemplate}
class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');
      analyzer = EndpointsAnalyzer(testDirectory);
      endpointDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then a warning is reported.', () {
      expect(collector.errors, hasLength(1));
      var error = collector.errors.first;
      expect(error, isA<SourceSpanSeverityException>());
      var severityError = error as SourceSpanSeverityException;
      expect(severityError.severity, SourceSpanSeverity.warning);
    });

    test('then warning message contains nested macro information.', () {
      var error = collector.errors.first;
      expect(
        error.message,
        'Error extracting templates from ${path.join(testDirectory.absolute.path, 'endpoint.dart')}: '
        'Nested or unresolved macro reference found in template: "example.template". '
        'Please remove this incorrect reference.',
      );
    });

    test('then endpoint definition is still created despite the warning.', () {
      expect(endpointDefinitions, hasLength(1));
      expect(endpointDefinitions.first.name, 'example');
    });
  });

  group(
    'Given an endpoint with both nested template and nested macro when analyzed',
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

/// {@template class.template}
/// Class content
/// {@template nested.class.template}
/// Nested content
/// {@endtemplate}
/// {@endtemplate}
class ExampleEndpoint extends Endpoint {
  /// {@template method.template}
  /// Method content
  /// {@macro inner.macro}
  /// More method content
  /// {@endtemplate}
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');
        analyzer = EndpointsAnalyzer(testDirectory);
        endpointDefinitions = await analyzer.analyze(collector: collector);
      });

      test(
        'then two warnings are reported.',
        () {
          expect(collector.errors, hasLength(2));
          for (var error in collector.errors) {
            expect(error, isA<SourceSpanSeverityException>());
            var severityError = error as SourceSpanSeverityException;
            expect(severityError.severity, SourceSpanSeverity.warning);
          }
        },
      );

      test(
        'then one warning is for nested template and one is for nested macro.',
        () {
          var messages = collector.errors.map((e) => e.message).toList();
          expect(
            messages.any(
              (m) => m.contains(
                'Nested template found: "class.template" in line: "/// {@template nested.class.template}". '
                'Please remove the nested template, as it is not supported.',
              ),
            ),
            isTrue,
          );
          expect(
            messages.any(
              (m) => m.contains(
                'Nested or unresolved macro reference found in template: "method.template". '
                'Please remove this incorrect reference.',
              ),
            ),
            isTrue,
          );
        },
      );

      test(
        'then endpoint definition is still created despite the warnings.',
        () {
          expect(endpointDefinitions, hasLength(1));
          expect(endpointDefinitions.first.name, 'example');
        },
      );
    },
  );
}
