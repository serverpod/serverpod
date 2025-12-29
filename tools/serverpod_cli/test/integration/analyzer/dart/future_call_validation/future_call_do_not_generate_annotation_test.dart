import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_calls_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/future_call_method_parameter_validator_builder.dart';
import '../../../../test_util/endpoint_validation_helpers.dart';

const pathToServerpodRoot = '../../../../../../../..';
var testProjectDirectory = Directory(
  path.joinAll([
    'test',
    'integration',
    'analyzer',
    'dart',
    'future_call_validation',
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

  group('Given future call with @doNotGenerate annotation when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );
    var testGeneratedDirectory = Directory(
      path.join(testDirectory.path, 'src', 'generated'),
    );

    late List<FutureCallDefinition> futureCallDefinitions;
    late FutureCallsAnalyzer analyzer;
    setUpAll(() async {
      var futureCallFile = File(
        path.join(testDirectory.path, 'future_call.dart'),
      );
      futureCallFile.createSync(recursive: true);
      futureCallFile.writeAsStringSync('''

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/annotations.dart';

@doNotGenerate
class ExampleFutureCall extends FutureCall {
  Future<void> hello(Session session, String name) async {
    session.log('Hello \$name');
  }
}
''');
      final parameterValidator = FutureCallMethodParameterValidatorBuilder()
          .build();

      analyzer = FutureCallsAnalyzer(
        directory: testDirectory,
        generatedDirectory: testGeneratedDirectory,
        parameterValidator: parameterValidator,
      );

      futureCallDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then no future call definition is created.', () {
      expect(futureCallDefinitions, isEmpty);
    });
  });

  group('Given future call with a random annotation when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );
    var testGeneratedDirectory = Directory(
      path.join(testDirectory.path, 'src', 'generated'),
    );

    late List<FutureCallDefinition> futureCallDefinitions;
    late FutureCallsAnalyzer analyzer;
    setUpAll(() async {
      var futureCallFile = File(
        path.join(testDirectory.path, 'future_call.dart'),
      );
      futureCallFile.createSync(recursive: true);
      futureCallFile.writeAsStringSync('''

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/annotations.dart';

const myAnnotation = 'myAnnotation';

@myAnnotation
class ExampleFutureCall extends FutureCall {
  Future<void> hello(Session session, String name) async {
    session.log('Hello \$name');
  }
}
''');
      final parameterValidator = FutureCallMethodParameterValidatorBuilder()
          .build();

      analyzer = FutureCallsAnalyzer(
        directory: testDirectory,
        generatedDirectory: testGeneratedDirectory,
        parameterValidator: parameterValidator,
      );

      futureCallDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then future call definition is created.', () {
      expect(futureCallDefinitions, hasLength(1));
    });
  });

  group(
    'Given two future calls in the same file where one has `@doNotGenerate` annotation when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );
      var testGeneratedDirectory = Directory(
        path.join(testDirectory.path, 'src', 'generated'),
      );

      late List<FutureCallDefinition> futureCallDefinitions;
      late FutureCallsAnalyzer analyzer;
      setUpAll(() async {
        var futureCallFile = File(
          path.join(testDirectory.path, 'future_call.dart'),
        );
        futureCallFile.createSync(recursive: true);
        futureCallFile.writeAsStringSync('''

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/annotations.dart';

@doNotGenerate
class FirstExampleFutureCall extends FutureCall {
  Future<void> hello(Session session, String name) async {
    session.log('Hello \$name');
  }
}

class SecondExampleFutureCall extends FutureCall {
  Future<void> hello(Session session, String name) async {
    session.log('Hello \$name');
  }
}
''');
        final parameterValidator = FutureCallMethodParameterValidatorBuilder()
            .build();

        analyzer = FutureCallsAnalyzer(
          directory: testDirectory,
          generatedDirectory: testGeneratedDirectory,
          parameterValidator: parameterValidator,
        );

        futureCallDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test(
        'then future call definition is created for the non-marked future call.',
        () {
          expect(futureCallDefinitions, hasLength(1));
          expect(futureCallDefinitions.firstOrNull?.name, 'secondExample');
        },
      );
    },
  );
}
