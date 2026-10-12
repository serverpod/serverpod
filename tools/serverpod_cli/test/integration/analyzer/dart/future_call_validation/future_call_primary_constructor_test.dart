import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_calls_analyzer.dart';
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
    await createTestEnvironment(
      testProjectDirectory,
      sdkConstraint: '^3.13.0',
    );
  });

  tearDownAll(() async {
    await testProjectDirectory.deleteWithRetry(recursive: true);
  });

  group(
    'Given a future call class declared with an empty primary constructor,'
    'when analyzed,',
    () {
      var collector = CodeGenerationCollector();
      late List<FutureCallDefinition> futureCallDefinitions;

      setUpAll(() async {
        var testDirectory = Directory(
          path.join(testProjectDirectory.path, const Uuid().v4()),
        );
        var futureCallFile = File(
          path.join(testDirectory.path, 'future_call.dart'),
        );
        futureCallFile.createSync(recursive: true);
        futureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ExampleFutureCall() extends FutureCall {
  Future<void> hello(Session session, String name) async {
     session.log('Hello \$name');
  }
}
''');

        var analyzer = FutureCallsAnalyzer(directory: testDirectory);
        futureCallDefinitions = await analyzer.analyze(
          collector: collector,
          analyzedModels: StatefulAnalyzer(config, []).validateAll(),
        );
      });

      test('then no validation errors are reported.', () {
        expect(collector.errors, isEmpty);
      });

      test('then future call definition is created with its method.', () {
        expect(futureCallDefinitions, hasLength(1));
        expect(futureCallDefinitions.firstOrNull?.name, 'example');
        expect(
          futureCallDefinitions.firstOrNull?.methods.map((m) => m.name),
          ['hello'],
        );
      });
    },
  );
}
