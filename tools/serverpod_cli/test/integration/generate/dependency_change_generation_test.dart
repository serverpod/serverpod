import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/analyzers.dart';
import 'package:test/test.dart';

import '../../test_util/builders/generator_config_builder.dart';
import '../../test_util/endpoint_validation_helpers.dart';
import '../../test_util/file_system_entity_helpers.dart';

void main() {
  late Directory projectDir;
  late GeneratorConfig config;
  late Analyzers analyzers;
  late String generatedDir;

  File sourceFile(List<String> path, String content) =>
      File(p.joinAll([projectDir.path, 'lib', 'src', ...path]))
        ..createSync(recursive: true)
        ..writeAsStringSync(content);

  /// Generates for [changed] the way a watched change does.
  Future<({GenerationRequirements requirements, GenerateResult result})>
  generateIncrementally(File changed) async {
    final requirements = await analyzers.update(
      config: config,
      affectedPaths: {changed.path},
    );
    final result = await analyzers.performGenerate(
      config: config,
      requirements: requirements,
      affectedPaths: {changed.path},
    );
    return (requirements: requirements, result: result);
  }

  setUp(() async {
    projectDir = Directory.systemTemp.createTempSync('cli_test_');
    addTearDown(() => projectDir.deleteWithRetry(recursive: true));
    await createTestEnvironment(projectDir);
    generatedDir = p.join(projectDir.path, 'lib', 'src', 'generated');
    config = buildTestServerConfig(projectDir);
  });

  group(
    'Given a generated project where a future call takes a parameter whose type is an alias declared in an endpoint file,',
    () {
      late File endpointFile;

      String endpointSource(String aliasedType) =>
          '''
import 'package:serverpod/serverpod.dart';

typedef Input = $aliasedType;

class GreetingEndpoint extends Endpoint {
  Future<String> hello(Session session) async => 'hi';
}
''';

      setUp(() async {
        endpointFile = sourceFile([
          'endpoints',
          'greeting.dart',
        ], endpointSource('String'));
        sourceFile(
          ['future_calls', 'reminder.dart'],
          '''
import 'package:serverpod/serverpod.dart';

import '../endpoints/greeting.dart';

class ReminderFutureCall extends FutureCall {
  Future<void> remind(Session session, Input value) async {}
}
''',
        );
        analyzers = await Analyzers.createAndUpdate(config);
        await analyzers.performGenerate(config: config);
      });

      group(
        'when the alias changes to another type and incremental generation runs for the endpoint file',
        () {
          late GenerationRequirements requirements;
          late GenerateResult result;

          setUp(() async {
            endpointFile.writeAsStringSync(endpointSource('int'));
            (:requirements, :result) = await generateIncrementally(
              endpointFile,
            );
          });

          test('then the analyzers require future call models.', () {
            expect(requirements.generateFutureCallModels, isTrue);
          });

          test('then the parameter model has the new type.', () {
            final parameterModel = File(
              p.join(
                generatedDir,
                'future_calls_generated_models',
                'reminder_future_call_remind_model.dart',
              ),
            ).readAsStringSync();

            expect(result.success, isTrue);
            expect(parameterModel, contains('int value;'));
            expect(parameterModel, isNot(contains('String value;')));
          });
        },
      );
    },
  );

  group(
    'Given a generated project where an endpoint takes a parameter whose type is an alias declared in a plain Dart file,',
    () {
      late File aliasFile;

      setUp(() async {
        aliasFile = sourceFile(['input.dart'], 'typedef Input = String;\n');
        sourceFile(
          ['endpoints', 'greeting.dart'],
          '''
import 'package:serverpod/serverpod.dart';

import '../input.dart';

class GreetingEndpoint extends Endpoint {
  Future<String> hello(Session session, Input value) async => 'hi';
}
''',
        );
        analyzers = await Analyzers.createAndUpdate(config);
        await analyzers.performGenerate(config: config);
      });

      test(
        'when the alias changes to another type and incremental generation runs for the plain Dart file,'
        'then the generated endpoint takes the new type.',
        () async {
          aliasFile.writeAsStringSync('typedef Input = int;\n');

          final (:requirements, :result) = await generateIncrementally(
            aliasFile,
          );

          expect(requirements.generateProtocol, isTrue);
          expect(result.success, isTrue);
          final endpoints = File(
            p.join(generatedDir, 'endpoints.dart'),
          ).readAsStringSync();
          expect(endpoints, contains('getType<int>()'));
          expect(endpoints, isNot(contains('getType<String>()')));
        },
      );

      test(
        'when a comment is added to the plain Dart file and the analyzers are updated with it,'
        'then they require no generation.',
        () async {
          aliasFile.writeAsStringSync(
            '// A comment.\ntypedef Input = String;\n',
          );

          final requirements = await analyzers.update(
            config: config,
            affectedPaths: {aliasFile.path},
          );

          expect(requirements.generateProtocol, isFalse);
        },
      );
    },
  );

  group(
    'Given a generated project where an endpoint method is documented with a template declared in a plain Dart file,',
    () {
      late File templateFile;

      String templateSource(String text) =>
          '''
/// {@template greeting_documentation}
/// $text
/// {@endtemplate}
class Documentation {}
''';

      /// The generated client code, which is where the documentation of
      /// endpoint methods ends up.
      String generatedClient() => projectDir
          .listSync(recursive: true)
          .whereType<File>()
          .singleWhere(
            (file) =>
                p.basename(file.path) == 'client.dart' &&
                p.split(file.path).contains('protocol'),
          )
          .readAsStringSync();

      setUp(() async {
        templateFile = sourceFile([
          'documentation.dart',
        ], templateSource('Says hello to the caller.'));
        sourceFile(
          ['endpoints', 'greeting.dart'],
          '''
import 'package:serverpod/serverpod.dart';

class GreetingEndpoint extends Endpoint {
  /// {@macro greeting_documentation}
  Future<String> hello(Session session) async => 'hi';
}
''',
        );
        analyzers = await Analyzers.createAndUpdate(config);
        await analyzers.performGenerate(config: config);
      });

      test('then the generated client has the text of the template.', () {
        expect(generatedClient(), contains('Says hello to the caller.'));
      });

      group(
        'when the text of the template changes and incremental generation runs for the plain Dart file,',
        () {
          late GenerationRequirements requirements;
          late GenerateResult result;

          setUp(() async {
            templateFile.writeAsStringSync(
              templateSource('Greets whoever calls.'),
            );
            (:requirements, :result) = await generateIncrementally(
              templateFile,
            );
          });

          test('then the analyzers require protocol generation.', () {
            expect(requirements.generateProtocol, isTrue);
          });

          test('then the generated client has the new text.', () {
            expect(result.success, isTrue);
            expect(generatedClient(), contains('Greets whoever calls.'));
            expect(
              generatedClient(),
              isNot(contains('Says hello to the caller.')),
            );
          });
        },
      );

      test(
        'when a class is added to the plain Dart file without changing the template and the analyzers are updated with it,'
        'then they require no generation.',
        () async {
          templateFile.writeAsStringSync(
            '${templateSource('Says hello to the caller.')}\nclass Other {}\n',
          );

          final requirements = await analyzers.update(
            config: config,
            affectedPaths: {templateFile.path},
          );

          expect(requirements.generateProtocol, isFalse);
        },
      );
    },
  );

  group(
    'Given a project with an endpoint method that fails validation, generated incrementally,',
    () {
      late File helperFile;
      late GenerateResult result;

      setUp(() async {
        helperFile = sourceFile(['helper.dart'], 'class Helper {}\n');
        final endpointFile = sourceFile(
          ['endpoints', 'greeting.dart'],
          '''
import 'package:serverpod/serverpod.dart';

class Unregistered {}

class GreetingEndpoint extends Endpoint {
  Future<String> hello(Session session) async => 'hi';

  Future<void> invalid(Session session, Unregistered value) async {}
}
''',
        );
        analyzers = await Analyzers.createAndUpdate(config);
        (requirements: _, :result) = await generateIncrementally(endpointFile);
      });

      test('then the generation reports the invalid method.', () {
        expect(result.success, isFalse);
      });

      test(
        'when an unrelated plain Dart file changes twice and the analyzers are updated with it each time,'
        'then they require no generation either time.',
        () async {
          // Generation validates the endpoint against the models and leaves
          // out the invalid method. That must not read as a change on every
          // later update, or generation would loop for as long as the method
          // stays invalid.
          helperFile.writeAsStringSync('class Helper {}\n// First.\n');
          final first = await analyzers.update(
            config: config,
            affectedPaths: {helperFile.path},
          );
          helperFile.writeAsStringSync('class Helper {}\n// Second.\n');
          final second = await analyzers.update(
            config: config,
            affectedPaths: {helperFile.path},
          );

          expect(first.generateProtocol, isFalse);
          expect(second.generateProtocol, isFalse);
        },
      );
    },
  );

  group(
    'Given a project generated by a forced generation with analyzers that were not updated first, where a future call takes a parameter whose type is an alias declared in an endpoint file,',
    () {
      late File endpointFile;

      String endpointSource(String aliasedType) =>
          '''
import 'package:serverpod/serverpod.dart';

typedef Input = $aliasedType;

class GreetingEndpoint extends Endpoint {
  Future<String> hello(Session session) async => 'hi';
}
''';

      setUp(() async {
        endpointFile = sourceFile([
          'endpoints',
          'greeting.dart',
        ], endpointSource('String'));
        sourceFile(
          ['future_calls', 'reminder.dart'],
          '''
import 'package:serverpod/serverpod.dart';

import '../endpoints/greeting.dart';

class ReminderFutureCall extends FutureCall {
  Future<void> remind(Session session, Input value) async {}
}
''',
        );
        // How `serverpod generate --watch --force` starts: the analyzers are
        // created without being updated, and the forced generation does not
        // update them either.
        analyzers = await Analyzers.create(config);
        await generateIfStale(
          config: config,
          createAnalyzers: () async => analyzers,
          keepPrimedWhenFresh: true,
          force: true,
        );
      });

      group(
        'when the alias changes to another type as the first change and incremental generation runs for the endpoint file,',
        () {
          late GenerateResult result;

          setUp(() async {
            endpointFile.writeAsStringSync(endpointSource('int'));
            result = await analyzeAndGenerate(
              config: config,
              analyzers: analyzers,
              affectedPaths: {endpointFile.path},
              incremental: true,
            );
          });

          test('then the parameter model has the new type.', () {
            final parameterModel = File(
              p.join(
                generatedDir,
                'future_calls_generated_models',
                'reminder_future_call_remind_model.dart',
              ),
            ).readAsStringSync();

            expect(result.success, isTrue);
            expect(parameterModel, contains('int value;'));
            expect(parameterModel, isNot(contains('String value;')));
          });
        },
      );
    },
  );

  group(
    'Given a project with an endpoint method that fails validation, generated by a forced generation with analyzers that were not updated first,',
    () {
      late File helperFile;

      setUp(() async {
        helperFile = sourceFile(['helper.dart'], 'class Helper {}\n');
        sourceFile(
          ['endpoints', 'greeting.dart'],
          '''
import 'package:serverpod/serverpod.dart';

class Unregistered {}

class GreetingEndpoint extends Endpoint {
  Future<String> hello(Session session) async => 'hi';

  Future<void> invalid(Session session, Unregistered value) async {}
}
''',
        );
        analyzers = await Analyzers.create(config);
        await generateIfStale(
          config: config,
          createAnalyzers: () async => analyzers,
          keepPrimedWhenFresh: true,
          force: true,
        );
      });

      test(
        'when an unrelated plain Dart file changes three times and the analyzers are updated with it each time, '
        'then they require no generation from the second time on.',
        () async {
          // The forced generation validates the endpoint and leaves out the
          // invalid method, while an update does not validate. The first
          // update may read that as a change. It must not keep doing so, or
          // generation would loop for as long as the method stays invalid.
          final requirements = <GenerationRequirements>[];
          for (final comment in ['First', 'Second', 'Third']) {
            helperFile.writeAsStringSync('class Helper {}\n// $comment.\n');
            requirements.add(
              await analyzers.update(
                config: config,
                affectedPaths: {helperFile.path},
              ),
            );
          }

          expect(requirements[0].generateProtocol, isTrue);
          expect(requirements[1].generateProtocol, isFalse);
          expect(requirements[2].generateProtocol, isFalse);
        },
      );
    },
  );
}
