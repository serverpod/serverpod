import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/analyzers.dart';
import 'package:serverpod_cli/src/generator/generation_staleness.dart';
import 'package:test/test.dart';

import '../../test_util/builders/generator_config_builder.dart';
import '../../test_util/endpoint_validation_helpers.dart';
import '../../test_util/file_system_entity_helpers.dart';

void main() {
  group(
    'Given a generated project without model files,',
    () {
      late Directory projectDir;
      late GeneratorConfig config;
      late Analyzers analyzers;
      late File futureCallFile;
      late File parameterModelFile;

      setUp(() async {
        projectDir = Directory.systemTemp.createTempSync('cli_test_');
        addTearDown(() => projectDir.deleteWithRetry(recursive: true));
        await createTestEnvironment(projectDir);

        config = buildTestServerConfig(projectDir);
        analyzers = await Analyzers.createAndUpdate(config);
        final initialResult = await analyzers.performGenerate(config: config);
        await writeGenerationStamp(
          config,
          generatedFiles: initialResult.generatedFiles,
        );

        futureCallFile = File(
          p.join(
            projectDir.path,
            'lib',
            'src',
            'future_calls',
            'reminder_future_call.dart',
          ),
        );
        parameterModelFile = File(
          p.join(
            projectDir.path,
            'lib',
            'src',
            'generated',
            'future_calls_generated_models',
            'reminder_future_call_remind_model.dart',
          ),
        );
      });

      test(
        'when the analyzers are updated with a new helper dart file, '
        'then they require no generation.',
        () async {
          final helperFile = File(
            p.join(projectDir.path, 'lib', 'src', 'helper.dart'),
          );
          helperFile.createSync(recursive: true);
          helperFile.writeAsStringSync('''
/// Helper for a class that extends FutureCall or extends Endpoint.
class Helper {}
''');

          final requirements = await analyzers.update(
            config: config,
            affectedPaths: {helperFile.path},
          );

          expect(requirements.generateModels, isFalse);
          expect(requirements.generateProtocol, isFalse);
          expect(requirements.generateFutureCallModels, isFalse);
        },
      );

      test(
        'when the analyzers are updated with a new endpoint dart file, '
        'then they require protocol generation only.',
        () async {
          final endpointFile = File(
            p.join(projectDir.path, 'lib', 'src', 'endpoints', 'greeting.dart'),
          );
          endpointFile.createSync(recursive: true);
          endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class GreetingEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async => 'Hello \$name';
}
''');

          final requirements = await analyzers.update(
            config: config,
            affectedPaths: {endpointFile.path},
          );

          expect(requirements.generateModels, isFalse);
          expect(requirements.generateProtocol, isTrue);
          expect(requirements.generateFutureCallModels, isFalse);
        },
      );

      group(
        'when a future call with parameters is added and the analyzers are updated,',
        () {
          late GenerationRequirements requirements;
          late GenerateResult result;

          setUp(() async {
            futureCallFile.createSync(recursive: true);
            futureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ReminderFutureCall extends FutureCall {
  Future<void> remind(Session session, String name) async {}
}
''');

            requirements = await analyzers.update(
              config: config,
              affectedPaths: {futureCallFile.path},
            );
          });

          test(
            'then the analyzers require future call model and protocol generation.',
            () {
              expect(requirements.generateModels, isFalse);
              expect(requirements.generateProtocol, isTrue);
              expect(requirements.generateFutureCallModels, isTrue);
            },
          );

          group('when incremental generation runs,', () {
            setUp(() async {
              result = await analyzers.performGenerate(
                config: config,
                requirements: requirements,
                affectedPaths: {futureCallFile.path},
              );
            });

            test('then the parameter model file is generated.', () {
              expect(result.success, isTrue);
              expect(parameterModelFile.existsSync(), isTrue);
              expect(result.generatedFiles, contains(parameterModelFile.path));
            });

            test(
              'when a full generation runs, '
              'then it writes the same parameter model file.',
              () async {
                final incrementalContent = parameterModelFile
                    .readAsStringSync();
                parameterModelFile.deleteSync();

                await analyzers.performGenerate(config: config);

                expect(
                  parameterModelFile.readAsStringSync(),
                  incrementalContent,
                );
              },
            );

            test(
              'when the parameters are removed from the future call and incremental generation runs again, '
              'then the parameter model file is removed.',
              () async {
                futureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

class ReminderFutureCall extends FutureCall {
  Future<void> remind(Session session) async {}
}
''');

                final requirements = await analyzers.update(
                  config: config,
                  affectedPaths: {futureCallFile.path},
                );
                final result = await analyzers.performGenerate(
                  config: config,
                  requirements: requirements,
                  affectedPaths: {futureCallFile.path},
                );

                expect(result.success, isTrue);
                expect(parameterModelFile.existsSync(), isFalse);
              },
            );
          });
        },
      );
    },
  );

  group(
    'Given a generated project with a YAML model,',
    () {
      late Directory projectDir;
      late GeneratorConfig config;
      late Analyzers analyzers;
      late File generatedYamlModelFile;
      late File parameterModelFile;

      setUp(() async {
        projectDir = Directory.systemTemp.createTempSync('cli_test_');
        addTearDown(() => projectDir.deleteWithRetry(recursive: true));
        await createTestEnvironment(projectDir);

        File(p.join(projectDir.path, 'lib', 'src', 'models', 'item.spy.yaml'))
          ..createSync(recursive: true)
          ..writeAsStringSync('''
class: Item
fields:
  name: String
''');

        config = buildTestServerConfig(projectDir);
        analyzers = await Analyzers.createAndUpdate(config);
        final initialResult = await analyzers.performGenerate(config: config);
        await writeGenerationStamp(
          config,
          generatedFiles: initialResult.generatedFiles,
        );

        generatedYamlModelFile = File(
          p.join(projectDir.path, 'lib', 'src', 'generated', 'item.dart'),
        );
        parameterModelFile = File(
          p.join(
            projectDir.path,
            'lib',
            'src',
            'generated',
            'future_calls_generated_models',
            'reminder_future_call_remind_model.dart',
          ),
        );
      });

      group(
        'when a future call with YAML model parameters is added and analyzers are updated,',
        () {
          late GenerationRequirements requirements;
          late GenerateResult result;
          late File futureCallFile;

          setUp(() async {
            futureCallFile = File(
              p.join(
                projectDir.path,
                'lib',
                'src',
                'future_calls',
                'reminder_future_call.dart',
              ),
            );
            futureCallFile.createSync(recursive: true);
            futureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class ReminderFutureCall extends FutureCall {
  Future<void> remind(
    Session session,
    Item item,
    List<Item> items,
    Item? optionalItem,
  ) async {}
}
''');

            requirements = await analyzers.update(
              config: config,
              affectedPaths: {futureCallFile.path},
            );
          });

          test('then the analyzers require future call model generation.', () {
            expect(requirements.generateFutureCallModels, isTrue);
          });

          test('then the analyzers do not require YAML model generation.', () {
            expect(requirements.generateModels, isFalse);
          });

          group(
            'when incremental generation runs,',
            () {
              setUp(() async {
                result = await analyzers.performGenerate(
                  config: config,
                  requirements: requirements,
                  affectedPaths: {futureCallFile.path},
                );
              });

              test('then the parameter model file is generated.', () {
                expect(result.success, isTrue);
                expect(parameterModelFile.existsSync(), isTrue);
              });

              test('then the generated file of the YAML model is kept.', () {
                expect(generatedYamlModelFile.existsSync(), isTrue);
                expect(
                  result.generatedFiles,
                  contains(generatedYamlModelFile.path),
                );
              });

              test(
                'when a full generation runs, '
                'then it writes the same parameter model file.',
                () async {
                  final incrementalContent = parameterModelFile
                      .readAsStringSync();
                  parameterModelFile.deleteSync();

                  await analyzers.performGenerate(config: config);

                  expect(
                    parameterModelFile.readAsStringSync(),
                    incrementalContent,
                  );
                },
              );
            },
          );
        },
      );
    },
  );
}
