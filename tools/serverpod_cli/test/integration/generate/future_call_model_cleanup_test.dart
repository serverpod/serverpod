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
    'Given a project with a YAML model, a shared model and two future calls with parameters, generated with its stamp written,',
    () {
      late Directory projectDir;
      late GeneratorConfig config;
      late Analyzers analyzers;
      late File reminderFile;
      late File digestFile;
      late String generatedDir;

      const reminderSource = '''
import 'package:serverpod/serverpod.dart';

class ReminderFutureCall extends FutureCall {
  Future<void> remind(Session session, String name) async {}
}
''';
      const digestSource = '''
import 'package:serverpod/serverpod.dart';

class DigestFutureCall extends FutureCall {
  Future<void> send(Session session, int count) async {}

  Future<void> resend(Session session, String reason) async {}
}
''';

      File parameterModel(String name) => File(
        p.join(generatedDir, 'future_calls_generated_models', '$name.dart'),
      );

      /// Whether the generation stamp lists a generated file named [name].
      bool stampLists(String name) => readGenerationStamp(
        config,
      ).any((file) => p.basename(file) == '$name.dart');

      String generatedFutureCalls() =>
          File(p.join(generatedDir, 'future_calls.dart')).readAsStringSync();

      /// Generates for [changed] the way a watched change does, which also
      /// rewrites the generation stamp.
      Future<GenerateResult> generateIncrementally(File changed) =>
          analyzeAndGenerate(
            config: config,
            analyzers: analyzers,
            affectedPaths: {changed.path},
            incremental: true,
          );

      /// The generated files that no change to a future call may remove.
      void expectUnrelatedModelsToExist() {
        expect(File(p.join(generatedDir, 'item.dart')).existsSync(), isTrue);
        expect(
          File(
            p.join(
              projectDir.path,
              'test_shared',
              'lib',
              'src',
              'generated',
              'shared_model.dart',
            ),
          ).existsSync(),
          isTrue,
        );
      }

      setUp(() async {
        projectDir = Directory.systemTemp.createTempSync('cli_test_');
        addTearDown(() => projectDir.deleteWithRetry(recursive: true));
        await createTestEnvironment(projectDir);
        generatedDir = p.join(projectDir.path, 'lib', 'src', 'generated');

        File(p.join(projectDir.path, 'lib', 'src', 'models', 'item.spy.yaml'))
          ..createSync(recursive: true)
          ..writeAsStringSync('''
class: Item
fields:
  name: String
''');
        File(p.join(projectDir.path, 'test_shared', 'pubspec.yaml'))
          ..createSync(recursive: true)
          ..writeAsStringSync('''
name: test_shared

environment:
  sdk: '^3.12.2'
''');
        File(
            p.join(
              projectDir.path,
              'test_shared',
              'lib',
              'src',
              'models',
              'shared_model.spy.yaml',
            ),
          )
          ..createSync(recursive: true)
          ..writeAsStringSync('''
class: SharedModel
fields:
  name: String
''');

        final futureCallsDir = p.join(
          projectDir.path,
          'lib',
          'src',
          'future_calls',
        );
        reminderFile = File(p.join(futureCallsDir, 'reminder_future_call.dart'))
          ..createSync(recursive: true)
          ..writeAsStringSync(reminderSource);
        digestFile = File(p.join(futureCallsDir, 'digest_future_call.dart'))
          ..createSync(recursive: true)
          ..writeAsStringSync(digestSource);

        config = buildTestServerConfig(
          projectDir,
          sharedModelsSourcePathsParts: {
            'test_shared': ['test_shared'],
          },
        );
        analyzers = await Analyzers.createAndUpdate(config);
        final sources = await enumerateSourceFiles(config);
        await analyzeAndGenerate(
          config: config,
          analyzers: analyzers,
          affectedPaths: sources.keys.toSet(),
          incremental: false,
          verifyStaleness: false,
          sourceStats: sources,
        );
      });

      test('then the stamp lists the parameter model of every method.', () {
        expect(stampLists('reminder_future_call_remind_model'), isTrue);
        expect(stampLists('digest_future_call_send_model'), isTrue);
        expect(stampLists('digest_future_call_resend_model'), isTrue);
      });

      group(
        'when a future call method is renamed and incremental generation runs',
        () {
          late GenerateResult result;

          setUp(() async {
            reminderFile.writeAsStringSync(
              reminderSource.replaceFirst('remind(', 'notify('),
            );
            result = await generateIncrementally(reminderFile);
          });

          test('then the parameter model of the old name is removed.', () {
            expect(result.success, isTrue);
            expect(
              parameterModel('reminder_future_call_remind_model').existsSync(),
              isFalse,
            );
            expect(stampLists('reminder_future_call_remind_model'), isFalse);
          });

          test('then the parameter model of the new name is generated.', () {
            expect(
              parameterModel('reminder_future_call_notify_model').existsSync(),
              isTrue,
            );
            expect(stampLists('reminder_future_call_notify_model'), isTrue);
          });

          test(
            'then the parameter models of the other future call, the YAML model and the shared model are kept.',
            () {
              expect(
                parameterModel('digest_future_call_send_model').existsSync(),
                isTrue,
              );
              expect(
                parameterModel('digest_future_call_resend_model').existsSync(),
                isTrue,
              );
              expectUnrelatedModelsToExist();
            },
          );
        },
      );

      group(
        'when one of the future call files is deleted and incremental generation runs',
        () {
          late GenerateResult result;

          setUp(() async {
            reminderFile.deleteSync();
            result = await generateIncrementally(reminderFile);
          });

          test('then its parameter model is removed.', () {
            expect(result.success, isTrue);
            expect(
              parameterModel('reminder_future_call_remind_model').existsSync(),
              isFalse,
            );
            expect(stampLists('reminder_future_call_remind_model'), isFalse);
          });

          test('then the future call is no longer generated.', () {
            expect(
              generatedFutureCalls(),
              isNot(contains('ReminderFutureCall')),
            );
          });

          test(
            'then the other future call with its parameter models, the YAML model and the shared model are kept.',
            () {
              expect(generatedFutureCalls(), contains('DigestFutureCall'));
              expect(
                parameterModel('digest_future_call_send_model').existsSync(),
                isTrue,
              );
              expect(
                parameterModel('digest_future_call_resend_model').existsSync(),
                isTrue,
              );
              expect(stampLists('digest_future_call_send_model'), isTrue);
              expectUnrelatedModelsToExist();
            },
          );

          test(
            'when the file is recreated and incremental generation runs again,'
            'then its parameter model is generated again.',
            () async {
              reminderFile.writeAsStringSync(reminderSource);

              final result = await generateIncrementally(reminderFile);

              expect(result.success, isTrue);
              expect(
                parameterModel(
                  'reminder_future_call_remind_model',
                ).existsSync(),
                isTrue,
              );
              expect(stampLists('reminder_future_call_remind_model'), isTrue);
              expect(generatedFutureCalls(), contains('ReminderFutureCall'));
            },
          );
        },
      );

      test(
        'when one of two methods of a future call is deleted and incremental generation runs,'
        'then only the parameter model of that method is removed.',
        () async {
          digestFile.writeAsStringSync(
            digestSource.replaceFirst(
              '\n  Future<void> resend(Session session, String reason) async {}\n',
              '',
            ),
          );

          final result = await generateIncrementally(digestFile);

          expect(result.success, isTrue);
          expect(
            parameterModel('digest_future_call_resend_model').existsSync(),
            isFalse,
          );
          expect(stampLists('digest_future_call_resend_model'), isFalse);
          expect(
            parameterModel('digest_future_call_send_model').existsSync(),
            isTrue,
          );
          expect(
            parameterModel('reminder_future_call_remind_model').existsSync(),
            isTrue,
          );
          expectUnrelatedModelsToExist();
        },
      );

      test(
        'when the parameters are removed from a future call method and incremental generation runs,'
        'then its parameter model is removed.',
        () async {
          reminderFile.writeAsStringSync(
            reminderSource.replaceFirst(', String name', ''),
          );

          final result = await generateIncrementally(reminderFile);

          expect(result.success, isTrue);
          expect(
            parameterModel('reminder_future_call_remind_model').existsSync(),
            isFalse,
          );
          expect(stampLists('reminder_future_call_remind_model'), isFalse);
          expect(generatedFutureCalls(), contains('ReminderFutureCall'));
          expectUnrelatedModelsToExist();
        },
      );
    },
  );
}
