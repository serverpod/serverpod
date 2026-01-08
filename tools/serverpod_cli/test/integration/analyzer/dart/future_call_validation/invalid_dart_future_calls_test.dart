import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_method_parameter_validator.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_calls_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
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

  group(
    'Given a future call file with incomplete future call class defined when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<FutureCallDefinition> futureCallDefinitions;
      late FutureCallsAnalyzer analyzer;
      setUpAll(() async {
        var futureCallFile = File(
          path.join(testDirectory.path, 'future_call.dart'),
        );
        futureCallFile.createSync(recursive: true);
        // Class is missing closing brackets
        futureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleFutureCall extends FutureCall {


''');
        final parameterValidator = FutureCallMethodParameterValidator(
          modelAnalyzer: StatefulAnalyzer(GeneratorConfigBuilder().build(), []),
        );

        analyzer = FutureCallsAnalyzer(
          directory: testDirectory,
          parameterValidator: parameterValidator,
        );

        futureCallDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then validation error for invalid Dart syntax is reported.', () {
        expect(collector.errors, hasLength(1));
        expect(
          collector.errors.firstOrNull?.message,
          contains(
            'FutureCall analysis skipped due to invalid Dart syntax. Please '
            'review and correct the syntax errors.',
          ),
        );
      });

      test('then future call definition is not created.', () {
        expect(futureCallDefinitions, isEmpty);
      });
    },
  );

  group(
    'Given a future call file with incomplete future call method defined when analyzed',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<FutureCallDefinition> futureCallDefinitions;
      late FutureCallsAnalyzer analyzer;

      setUpAll(() async {
        var futureCallFile = File(
          path.join(testDirectory.path, 'future_call.dart'),
        );
        futureCallFile.createSync(recursive: true);
        // Class and method are missing closing brackets
        futureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleFutureCall extends FutureCall {
  Future<void> hello(Session session, String name) async {
''');
        final parameterValidator = FutureCallMethodParameterValidator(
          modelAnalyzer: StatefulAnalyzer(GeneratorConfigBuilder().build(), []),
        );

        analyzer = FutureCallsAnalyzer(
          directory: testDirectory,
          parameterValidator: parameterValidator,
        );

        futureCallDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then validation error for invalid Dart syntax is reported.', () {
        expect(collector.errors, hasLength(1));
        expect(
          collector.errors.firstOrNull?.message,
          contains(
            'FutureCall analysis skipped due to invalid Dart syntax. Please '
            'review and correct the syntax errors.',
          ),
        );
      });

      test('then future call definition is not created.', () {
        expect(futureCallDefinitions, isEmpty);
      });
    },
  );

  group(
    'Given a future call method that returns a Future with multiple defined types',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
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

class ExampleFutureCall extends FutureCall {
  Future<String, int> hello(Session session, String name) async {
    return 'Hello \$name';
  }
}
''');
        final parameterValidator = FutureCallMethodParameterValidator(
          modelAnalyzer: StatefulAnalyzer(GeneratorConfigBuilder().build(), []),
        );

        analyzer = FutureCallsAnalyzer(
          directory: testDirectory,
          parameterValidator: parameterValidator,
        );

        futureCallDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then validation error for invalid Dart syntax is reported.', () {
        expect(collector.errors, hasLength(1));
        expect(
          collector.errors.firstOrNull?.message,
          contains(
            'FutureCall analysis skipped due to invalid Dart syntax. Please '
            'review and correct the syntax errors.',
          ),
        );
      });

      test('then future call definition is not created.', () {
        expect(futureCallDefinitions, isEmpty);
      });
    },
  );

  group('Given a valid and an invalid future call file when analyzed', () {
    var collector = CodeGenerationCollector();
    var testDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );

    late List<FutureCallDefinition> futureCallDefinitions;
    late FutureCallsAnalyzer analyzer;
    setUpAll(() async {
      var firstfutureCallFile = File(
        path.join(testDirectory.path, 'invalid_future_call.dart'),
      );
      firstfutureCallFile.createSync(recursive: true);
      firstfutureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleFutureCallInvalid extends FutureCall {
  Future<void> hello(Session session, String name) async {
''');
      var secondfutureCallFile = File(
        path.join(testDirectory.path, 'valid_future_call.dart'),
      );
      secondfutureCallFile.createSync(recursive: true);
      secondfutureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleFutureCallValid extends FutureCall {
  Future<void> hello(Session session, String name) async {
    session.log('Hello \$name');
  }
}
''');
      final parameterValidator = FutureCallMethodParameterValidator(
        modelAnalyzer: StatefulAnalyzer(GeneratorConfigBuilder().build(), []),
      );

      analyzer = FutureCallsAnalyzer(
        directory: testDirectory,
        parameterValidator: parameterValidator,
      );

      futureCallDefinitions = await analyzer.analyze(collector: collector);
    });

    test('then validation error for invalid Dart syntax is reported.', () {
      expect(collector.errors, hasLength(1));
      expect(
        collector.errors.firstOrNull?.message,
        contains(
          'FutureCall analysis skipped due to invalid Dart syntax. Please '
          'review and correct the syntax errors.',
        ),
      );
    });

    test('then one future call definitions is created.', () {
      expect(futureCallDefinitions, hasLength(1));
    });
  });

  group('Given an invalid dart file without an future call definition', () {
    var collector = CodeGenerationCollector();
    var testDirectory = Directory(
      path.join(testProjectDirectory.path, const Uuid().v4()),
    );

    late FutureCallsAnalyzer analyzer;
    setUpAll(() async {
      var invalidDartFile = File(
        path.join(testDirectory.path, 'my_class.dart'),
      );
      invalidDartFile.createSync(recursive: true);
      // Class is missing closing brackets
      invalidDartFile.writeAsStringSync('''
class InvalidClass {


''');
      final parameterValidator = FutureCallMethodParameterValidator(
        modelAnalyzer: StatefulAnalyzer(GeneratorConfigBuilder().build(), []),
      );

      analyzer = FutureCallsAnalyzer(
        directory: testDirectory,
        parameterValidator: parameterValidator,
      );

      await analyzer.analyze(collector: collector);
    });

    test('then no validation error for invalid Dart syntax is reported.', () {
      expect(collector.errors, isEmpty);
    });
  });

  group(
    'Given an invalid dart file without an future call definition and a valid future call definition file',
    () {
      var collector = CodeGenerationCollector();
      var testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late List<FutureCallDefinition> futureCallDefinitions;
      late FutureCallsAnalyzer analyzer;
      setUpAll(() async {
        var invalidDartFile = File(
          path.join(testDirectory.path, 'my_class.dart'),
        );
        invalidDartFile.createSync(recursive: true);
        // Class is missing closing brackets
        invalidDartFile.writeAsStringSync('''
class InvalidClass {


''');
        var secondfutureCallFile = File(
          path.join(testDirectory.path, 'valid_future_call.dart'),
        );
        secondfutureCallFile.createSync(recursive: true);
        secondfutureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleFutureCallValid extends FutureCall {
  Future<void> hello(Session session, String name) async {
    session.log('Hello \$name');
  }
}
''');
        final parameterValidator = FutureCallMethodParameterValidator(
          modelAnalyzer: StatefulAnalyzer(GeneratorConfigBuilder().build(), []),
        );

        analyzer = FutureCallsAnalyzer(
          directory: testDirectory,
          parameterValidator: parameterValidator,
        );

        futureCallDefinitions = await analyzer.analyze(collector: collector);
      });

      test('then no validation error for invalid Dart syntax is reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then one future call definitions is created.', () {
        expect(futureCallDefinitions, hasLength(1));
      });
    },
  );
}
