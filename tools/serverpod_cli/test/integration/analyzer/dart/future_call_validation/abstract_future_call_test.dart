import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_method_parameter_validator.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_calls_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
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

  group('Given abstract future call class when analyzed', () {
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

abstract class ExampleFutureCall extends FutureCall {
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

    test('then no validation errors are reported.', () {
      expect(collector.errors, isEmpty);
    });

    test('then abstract future call definition is created.', () {
      expect(futureCallDefinitions, hasLength(1));
      expect(futureCallDefinitions.first.className, 'ExampleFutureCall');
      expect(futureCallDefinitions.first.isAbstract, isTrue);
    });
  });

  group(
    'Given a concrete future call that extends an abstract base future call when analyzed',
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

abstract class BaseFutureCall extends FutureCall {
  Future<void> hello(Session session, String name) async {
    session.log('Hello \$name');
  }
}

class ConcreteFutureCall extends BaseFutureCall {
  Future<void> bye(Session session, String name) async {
    session.log('Bye \$name');
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

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test(
        'then both abstract and concrete future call definitions are created.',
        () {
          expect(
            futureCallDefinitions.map((e) => e.className).toSet(),
            {'BaseFutureCall', 'ConcreteFutureCall'},
          );
        },
      );

      late var concreteFutureCall = futureCallDefinitions.firstWhere(
        (e) => e.className == 'ConcreteFutureCall',
      );

      test('then concrete future call is not abstract.', () {
        expect(concreteFutureCall.isAbstract, isFalse);
      });

      test('then concrete future call has both base and concrete methods.', () {
        expect(
          concreteFutureCall.methods.map((m) => m.name).toSet(),
          {'hello', 'bye'},
        );
      });
    },
  );

  group(
    'Given a concrete future call that extends an abstract base future call and overrides a method when analyzed',
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

abstract class BaseFutureCall extends FutureCall {
  Future<void> hello(Session session, String name);
}

class ConcreteFutureCall extends BaseFutureCall {
  @override
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

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      late var concreteFutureCall = futureCallDefinitions.firstWhere(
        (e) => e.className == 'ConcreteFutureCall',
      );

      test('then concrete future call has overridden method.', () {
        expect(
          concreteFutureCall.methods.map((m) => m.name).toSet(),
          {'hello'},
        );
      });
    },
  );
}
