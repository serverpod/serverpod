import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_calls_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/analysis_helpers.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/endpoint_validation_helpers.dart';
import '../../../../test_util/file_system_entity_helpers.dart';

final config = GeneratorConfigBuilder().build();
late Directory testProjectDirectory;
late AnalysisContextCollection collection;

void main() {
  setUpAll(() async {
    testProjectDirectory = Directory.systemTemp.createTempSync('cli_test_');
    await createTestEnvironment(testProjectDirectory);
    collection = createAnalysisContextCollection(testProjectDirectory);
  });

  tearDownAll(() async {
    await collection.dispose();
    await testProjectDirectory.deleteWithRetry(recursive: true);
  });

  group('Given abstract future call class, when analyzed,', () {
    var collector = CodeGenerationCollector();
    late Directory testDirectory;

    late List<FutureCallDefinition> futureCallDefinitions;
    late FutureCallsAnalyzer analyzer;

    setUpAll(() async {
      testDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );
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

      analyzer = FutureCallsAnalyzer(
        directory: testDirectory,
        collection: collection,
      );
      futureCallDefinitions = await analyzer.analyze(
        collector: collector,
        analyzedModels: StatefulAnalyzer(config, []).validateAll(),
      );
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
    'Given a concrete future call that extends an abstract base future call, '
    'when analyzed,',
    () {
      var collector = CodeGenerationCollector();
      late Directory testDirectory;

      late List<FutureCallDefinition> futureCallDefinitions;
      late FutureCallsAnalyzer analyzer;

      setUpAll(() async {
        testDirectory = Directory(
          path.join(testProjectDirectory.path, const Uuid().v4()),
        );
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

        analyzer = FutureCallsAnalyzer(
          directory: testDirectory,
          collection: collection,
        );
        futureCallDefinitions = await analyzer.analyze(
          collector: collector,
          analyzedModels: StatefulAnalyzer(config, []).validateAll(),
        );
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
    'Given a concrete future call that extends an abstract base future call and overrides a method, '
    'when analyzed,',
    () {
      var collector = CodeGenerationCollector();
      late Directory testDirectory;

      late List<FutureCallDefinition> futureCallDefinitions;
      late FutureCallsAnalyzer analyzer;

      setUpAll(() async {
        testDirectory = Directory(
          path.join(testProjectDirectory.path, const Uuid().v4()),
        );
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

        analyzer = FutureCallsAnalyzer(
          directory: testDirectory,
          collection: collection,
        );
        futureCallDefinitions = await analyzer.analyze(
          collector: collector,
          analyzedModels: StatefulAnalyzer(config, []).validateAll(),
        );
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
