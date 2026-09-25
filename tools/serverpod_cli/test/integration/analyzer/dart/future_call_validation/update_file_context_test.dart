import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/endpoint_validation_helpers.dart';
import '../../../../test_util/file_system_entity_helpers.dart';

final config = GeneratorConfigBuilder().build();

late Directory testProjectDirectory;

void main() {
  setUpAll(() async {
    testProjectDirectory = Directory.systemTemp.createTempSync('cli_test_');
    await createTestEnvironment(testProjectDirectory);
  });

  tearDownAll(() async {
    await testProjectDirectory.deleteWithRetry(recursive: true);
  });

  group(
    'Given a tracked and analyzed directory with a persistently invalid dart future call file',
    () {
      late Directory trackedDirectory;

      late FutureCallsAnalyzer analyzer;
      setUpAll(() async {
        trackedDirectory = Directory(
          path.join(testProjectDirectory.path, const Uuid().v4()),
        );
        var futureCallFile = File(
          path.join(trackedDirectory.path, 'future_call.dart'),
        );
        futureCallFile.createSync(recursive: true);
        // Class is missing closing brackets
        futureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleFutureCall extends FutureCall {
  Future<void> hello(Session session, String name) async {
    session.log('Hello \$name');
  }
''');
        analyzer = FutureCallsAnalyzer(directory: trackedDirectory);
        await analyzer.analyze(
          collector: CodeGenerationCollector(),
          analyzedModels: StatefulAnalyzer(config, []).validateAll(),
        );
      });

      test(
        'when the file context is updated with an unrelated non-future-call file while the error persists '
        'then false is returned.',
        () async {
          // Regression: a persistent error must not turn every unrelated change
          // into a regeneration, or watch mode loops forever (each generation
          // touches generated files, whose events regenerate again).
          var unrelatedFile = File(
            path.join(trackedDirectory.path, 'helper.dart'),
          );
          unrelatedFile.createSync(recursive: true);
          unrelatedFile.writeAsStringSync('''
class HelperClass {}
''');

          await expectLater(
            analyzer.updateFileContexts({unrelatedFile.path}),
            completion(false),
          );
        },
      );
    },
  );

  group(
    'Given a tracked and analyzed directory with an invalid dart future call file',
    () {
      late Directory trackedDirectory;

      late File futureCallFile;
      late FutureCallsAnalyzer analyzer;
      setUpAll(() async {
        trackedDirectory = Directory(
          path.join(testProjectDirectory.path, const Uuid().v4()),
        );
        futureCallFile = File(
          path.join(trackedDirectory.path, 'future_call.dart'),
        );
        futureCallFile.createSync(recursive: true);
        // Class is missing closing brackets
        futureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleFutureCall extends FutureCall {
  Future<void> hello(Session session, String name) async {
    session.log('Hello \$name');
  }
''');
        analyzer = FutureCallsAnalyzer(directory: trackedDirectory);
        await analyzer.analyze(
          collector: CodeGenerationCollector(),
          analyzedModels: StatefulAnalyzer(config, []).validateAll(),
        );
      });

      test(
        'when the file context is updated with a fix for the invalid future call file '
        'then true is returned.',
        () async {
          futureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleFutureCall extends FutureCall {
  Future<void> hello(Session session, String name) async {
    session.log('Hello \$name');
  }
}
''');

          await expectLater(
            analyzer.updateFileContexts({futureCallFile.path}),
            completion(true),
          );
        },
      );
    },
  );

  group(
    'Given a tracked directory with a valid future call file analyzed before any models were provided',
    () {
      late Directory trackedDirectory;

      late File futureCallFile;
      late FutureCallsAnalyzer analyzer;
      setUpAll(() async {
        trackedDirectory = Directory(
          path.join(testProjectDirectory.path, const Uuid().v4()),
        );
        futureCallFile = File(
          path.join(trackedDirectory.path, 'future_call.dart'),
        );
        futureCallFile.createSync(recursive: true);
        futureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleFutureCall extends FutureCall {
  Future<void> hello(Session session, String name) async {
    session.log('Hello \$name');
  }
}
''');
        analyzer = FutureCallsAnalyzer(directory: trackedDirectory);
        // Analyzed without models: the file is cached as pending full
        // analysis (hadErrors), the state a fresh up-to-date watch session
        // starts in before any generation has run.
        await analyzer.analyze(collector: CodeGenerationCollector());
      });

      test(
        'when the file context is updated with an unrelated non-future-call file '
        'then false is returned.',
        () async {
          // Regression: the pending-analysis state is indistinguishable from an
          // error and used to mark every unrelated change as needing
          // generation.
          var unrelatedFile = File(
            path.join(trackedDirectory.path, 'helper.dart'),
          );
          unrelatedFile.createSync(recursive: true);
          unrelatedFile.writeAsStringSync('''
class HelperClass {}
''');

          await expectLater(
            analyzer.updateFileContexts({unrelatedFile.path}),
            completion(false),
          );
        },
      );

      test(
        'when the file context is updated with the future call file itself '
        'then true is returned.',
        () async {
          await expectLater(
            analyzer.updateFileContexts({futureCallFile.path}),
            completion(true),
          );
        },
      );
    },
  );

  group(
    'Given an analyzed future call file cached under its real-cased path',
    () {
      var trackedDirectory = Directory(
        path.join(testProjectDirectory.path, const Uuid().v4()),
      );

      late File futureCallFile;
      late FutureCallsAnalyzer analyzer;
      setUpAll(() async {
        futureCallFile = File(
          path.join(trackedDirectory.path, 'future_call.dart'),
        );
        futureCallFile.createSync(recursive: true);
        futureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleFutureCall extends FutureCall {
  Future<void> hello(Session session, String name) async {
    session.log('Hello \$name');
  }
}
''');
        analyzer = FutureCallsAnalyzer(directory: trackedDirectory);
        await analyzer.analyze(
          collector: CodeGenerationCollector(),
          analyzedModels: StatefulAnalyzer(config, []).validateAll(),
        );
      });

      test(
        'when the file context is updated with the same file under a '
        'differently cased path '
        'then it is re-analyzed as the same future call file.',
        () async {
          // The file watcher canonicalizes paths, which lowercases them on
          // Windows. The analyzer must not treat that as a second file.
          futureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleFutureCall extends FutureCall {
  Future<void> hello(Session session, String name) async {
    session.log('Hello \$name');
  }

  Future<void> goodbye(Session session, String name) async {
    session.log('Goodbye \$name');
  }
}
''');
          var changedPath = path.canonicalize(futureCallFile.path);
          await expectLater(
            analyzer.updateFileContexts({changedPath}),
            completion(true),
          );

          var collector = CodeGenerationCollector();
          var definitions = await analyzer.analyze(
            collector: collector,
            changedFiles: {changedPath},
          );

          expect(collector.errors, isEmpty);
          expect(definitions, hasLength(1));
          expect(definitions.single.filePath, futureCallFile.path);
          expect(
            definitions.single.methods.map((m) => m.name),
            containsAll(['hello', 'goodbye']),
          );
        },
      );
    },
  );
}
