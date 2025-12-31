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

  group(
    'Given a future call that extends another future call when analyzed',
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

class BaseFutureCall extends FutureCall {
  Future<void> hello(Session session, String name) async {
    session.log('Hello \$name');
  }
}

class SubclassFutureCall extends BaseFutureCall {
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
        'then both base and subclass future call definitions are created.',
        () {
          expect(
            futureCallDefinitions.map((e) => e.className).toSet(),
            {'BaseFutureCall', 'SubclassFutureCall'},
          );
        },
      );

      late var subclassFutureCall = futureCallDefinitions.firstWhere(
        (e) => e.className == 'SubclassFutureCall',
      );

      test('then subclass future call has both base and new methods.', () {
        expect(
          subclassFutureCall.methods.map((m) => m.name).toSet(),
          {'hello', 'bye'},
        );
      });
    },
  );

  group(
    'Given a future call that extends another future call and overrides a method when analyzed',
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

class BaseFutureCall extends FutureCall {
  Future<void> hello(Session session, String name) async {
    session.log('Hello \$name');
  }
}

class SubclassFutureCall extends BaseFutureCall {
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

      late var subclassFutureCall = futureCallDefinitions.firstWhere(
        (e) => e.className == 'SubclassFutureCall',
      );

      test('then subclass future call has overridden method.', () {
        expect(
          subclassFutureCall.methods.map((m) => m.name).toSet(),
          {'hello'},
        );
      });
    },
  );

  group(
    'Given abstract > concrete > abstract subclass > concrete subclass'
    'future calls hierarchy when analyzed',
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

abstract class AbstractFutureCall extends FutureCall {
  Future<void> hello(Session session, String name);
}

class ConcreteFutureCall extends AbstractFutureCall {
  @override
  Future<void> hello(Session session, String name) async {
    session.log('Hello \$name');
  }

  Future<void> greet(Session session, String name) async {
    session.log('Greetings from \$name');
  }
}

abstract class AbstractSubclassFutureCall extends ConcreteFutureCall {
  Future<void> bye(Session session, String name);
}

class ConcreteSubclassFutureCall extends AbstractSubclassFutureCall {
  @override
  Future<void> bye(Session session, String name) async {
    session.log('Bye \$name');
  }

  Future<void> wave(Session session, String name) async {
    session.log('Waving at \$name');
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

      late var abstractFutureCall = futureCallDefinitions.firstWhere(
        (e) => e.className == 'AbstractFutureCall',
      );

      late var abstractSubclassFutureCall = futureCallDefinitions.firstWhere(
        (e) => e.className == 'AbstractSubclassFutureCall',
      );

      test(
        'then all abstract future call definitions are created.',
        () {
          expect(
            futureCallDefinitions.map((e) => e.className).toSet(),
            containsAll({
              'AbstractFutureCall',
              'AbstractSubclassFutureCall',
            }),
          );

          expect(abstractFutureCall.isAbstract, isTrue);
          expect(abstractSubclassFutureCall.isAbstract, isTrue);
        },
      );

      late var concreteFutureCall = futureCallDefinitions.firstWhere(
        (e) => e.className == 'ConcreteFutureCall',
      );

      late var concreteSubclassFutureCall = futureCallDefinitions.firstWhere(
        (e) => e.className == 'ConcreteSubclassFutureCall',
      );

      test(
        'then all concrete future call definitions are created.',
        () {
          expect(
            futureCallDefinitions.map((e) => e.className).toSet(),
            containsAll({
              'ConcreteFutureCall',
              'ConcreteSubclassFutureCall',
            }),
          );

          expect(concreteFutureCall.isAbstract, isFalse);
          expect(concreteSubclassFutureCall.isAbstract, isFalse);
        },
      );

      test(
        'then concrete future call has inherited and new methods',
        () {
          expect(
            concreteFutureCall.methods.map((m) => m.name).toSet(),
            {'hello', 'greet'},
          );
        },
      );

      test(
        'then abstract subclass future call has inherited and new methods',
        () {
          expect(
            abstractSubclassFutureCall.methods.map((m) => m.name).toSet(),
            {'hello', 'greet', 'bye'},
          );
        },
      );

      test(
        'then concrete subclass future call has inherited and new methods',
        () {
          expect(
            concreteSubclassFutureCall.methods.map((m) => m.name).toSet(),
            {'hello', 'bye', 'greet', 'wave'},
          );
        },
      );
    },
  );
}
