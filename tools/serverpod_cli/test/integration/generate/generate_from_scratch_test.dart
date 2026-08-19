import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/analyzers.dart';
import 'package:serverpod_shared/process_io.dart';
import 'package:test/test.dart';

import '../../test_util/builders/generator_config_builder.dart';
import '../../test_util/endpoint_validation_helpers.dart';
import '../../test_util/file_system_entity_helpers.dart';

Future<(Directory, Directory)> _buildProject() async {
  final projectDir = Directory.systemTemp.createTempSync('cli_test_');
  final generatedDir = Directory(
    p.join(projectDir.path, 'lib', 'src', 'generated'),
  );
  await createTestEnvironment(projectDir, sdkConstraint: '^3.10.3');

  return (projectDir, generatedDir);
}

void main() {
  group(
    'Given a spy model and a future call referencing it with no generated files',
    () {
      late Directory projectDir;
      late Directory generatedDir;
      late GeneratorConfig config;
      late Analyzers analyzers;

      tearDownAll(() => projectDir.deleteBestEffort(recursive: true));

      setUpAll(() async {
        (projectDir, generatedDir) = await _buildProject();

        var modelFile = File(
          path.join(
            projectDir.path,
            'lib',
            'src',
            'protocol',
            'my_model.spy.yaml',
          ),
        );
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
class: MyModel
fields:
  name: String
  count: int
''');

        // Future call that uses MyModel as a parameter type.
        // The import references the generated protocol.dart barrel file,
        // which does not exist yet before the first generate.
        var futureCallFile = File(
          path.join(
            projectDir.path,
            'lib',
            'src',
            'my_future_call.dart',
          ),
        );
        futureCallFile.createSync(recursive: true);
        futureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';
import 'package:test_server/src/generated/protocol.dart';

class MyFutureCall extends FutureCall {
  Future<void> process(Session session, MyModel model) async {}
}
''');

        config = buildTestServerConfig(projectDir);
        analyzers = await Analyzers.create(config);
      });

      group(
        'when generating',
        () {
          late GenerateResult result;

          tearDown(() => generatedDir.deleteBestEffort(recursive: true));
          setUp(() async {
            result = await analyzers.performGenerate(
              config: config,
            );
          });

          test(
            'then generation succeeds on first run.',
            () {
              expect(result.success, isTrue);
            },
          );

          test('then model files are generated.', () {
            expect(
              result.generatedFiles.any((f) => f.contains('my_model')),
              isTrue,
            );
          });

          test('then future calls file is generated.', () {
            expect(
              result.generatedFiles.any((f) => f.contains('future_calls')),
              isTrue,
            );
          });
        },
      );
    },
  );

  group(
    'Given a future call and an endpoint importing the generated future calls file with no generated files',
    () {
      late Directory projectDir;
      late Directory generatedDir;
      late GeneratorConfig config;
      late Analyzers analyzers;

      tearDownAll(() => projectDir.deleteBestEffort(recursive: true));

      setUpAll(() async {
        (projectDir, generatedDir) = await _buildProject();

        var modelFile = File(
          path.join(
            projectDir.path,
            'lib',
            'src',
            'protocol',
            'greeting.spy.yaml',
          ),
        );
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
class: Greeting
fields:
  message: String
''');

        var futureCallFile = File(
          path.join(
            projectDir.path,
            'lib',
            'src',
            'greeting_call.dart',
          ),
        );
        futureCallFile.createSync(recursive: true);
        futureCallFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';
import 'package:test_server/src/generated/protocol.dart';

class GreetingCall extends FutureCall {
  Future<void> send(Session session, Greeting greeting) async {}
}
''');

        // Endpoint that imports the generated future calls file to schedule
        // a future call. With no generated files on disk, the future calls
        // file is written before endpoint analysis so the import resolves.
        var endpointFile = File(
          path.join(
            projectDir.path,
            'lib',
            'src',
            'endpoints',
            'greeting_endpoint.dart',
          ),
        );
        endpointFile.createSync(recursive: true);
        endpointFile.writeAsStringSync('''
import 'package:serverpod/serverpod.dart';
import 'package:test_server/src/generated/future_calls.dart';
import 'package:test_server/src/generated/protocol.dart';

class GreetingEndpoint extends Endpoint {
  Future<void> scheduleGreeting(Session session, Greeting greeting) async {
    await session.serverpod.futureCalls
        .callWithDelay(const Duration(seconds: 1))
        .greetingCall
        .send(greeting);
  }
}
''');

        config = buildTestServerConfig(projectDir);
        analyzers = await Analyzers.create(config);
      });

      group('when generating', () {
        late GenerateResult result;

        tearDown(() => generatedDir.deleteBestEffort(recursive: true));
        setUp(() async {
          result = await analyzers.performGenerate(
            config: config,
          );
        });

        test('then generation succeeds on first run.', () {
          expect(result.success, isTrue);
        });

        test('then future calls file is generated.', () {
          expect(
            result.generatedFiles.any((f) => f.contains('future_calls')),
            isTrue,
          );
        });

        test('then endpoint file is generated.', () {
          expect(
            result.generatedFiles.any((f) => f.contains('endpoints')),
            isTrue,
          );
        });
      });
    },
  );

  group('Given a model and endpoints using it with no generated files,', () {
    late Directory projectDir;
    late Directory generatedDir;
    late Directory generatedClientDir;
    late GeneratorConfig config;
    late Analyzers analyzers;

    tearDownAll(() => projectDir.deleteBestEffort(recursive: true));
    tearDown(() async {
      await generatedDir.deleteBestEffort(recursive: true);
      await generatedClientDir.deleteBestEffort(recursive: true);
    });

    setUpAll(() async {
      (projectDir, generatedDir) = await _buildProject();
      await _createClientPackage(projectDir);
      generatedClientDir = Directory(
        path.join(projectDir.path, 'test_client', 'lib', 'src', 'protocol'),
      );

      File(
          path.join(
            projectDir.path,
            'lib',
            'src',
            'protocol',
            'item.spy.yaml',
          ),
        )
        ..createSync(recursive: true)
        ..writeAsStringSync('''
class: Item
fields:
  name: String
''');

      // Endpoint that imports protocol.dart and uses the generated model.
      // With no generated files on disk, a temporary protocol.dart (model
      // exports and a stub Protocol class) is written before analysis so the
      // import resolves.
      File(
          path.join(
            projectDir.path,
            'lib',
            'src',
            'endpoints',
            'item_endpoint.dart',
          ),
        )
        ..createSync(recursive: true)
        ..writeAsStringSync('''
import 'package:serverpod/serverpod.dart';
import 'package:test_server/src/generated/protocol.dart';

class ItemEndpoint extends Endpoint {
  Future<Item> getItem(Session session, String name) async {
    return Item(name: name);
  }
}
''');

      File(
          path.join(
            projectDir.path,
            'lib',
            'src',
            'endpoints',
            'client_item_endpoint.dart',
          ),
        )
        ..createSync(recursive: true)
        ..writeAsStringSync('''
import 'package:serverpod/serverpod.dart';
import 'package:test_client/test_client.dart';

class ClientItemEndpoint extends Endpoint {
  Future<Item> getItem(Session session, String name) async {
    return Item(name: name);
  }
}
''');

      config = buildTestServerConfig(projectDir);
      analyzers = await Analyzers.create(config);
    });

    group('when generating,', () {
      late GenerateResult result;

      setUp(() async {
        result = await analyzers.performGenerate(config: config);
      });

      test('then generation succeeds on first run.', () {
        expect(result.success, isTrue);
      });

      test('then endpoint files are generated.', () {
        expect(
          result.generatedFiles.any((f) => f.contains('endpoints')),
          isTrue,
        );
      });

      test('then model files are generated.', () {
        expect(
          result.generatedFiles.any((f) => f.contains('item')),
          isTrue,
        );
      });

      test('then generated Dart is format-clean.', () async {
        final formatResult = await Process.run(
          dartExecutablePath,
          [
            'format',
            '--output=none',
            '--set-exit-if-changed',
            generatedDir.path,
            generatedClientDir.path,
          ],
          workingDirectory: projectDir.path,
        );

        expect(
          formatResult.exitCode,
          0,
          reason: '${formatResult.stdout}\n${formatResult.stderr}',
        );
      });
    });
  });

  group(
    'Given not yet generated protocol and database models targeting server and client packages with different formatter configurations,',
    () {
      late Directory projectDir;
      late Directory generatedDir;
      late Directory generatedClientDir;
      late Directory generatedClientMigrationsDir;
      late GeneratorConfig config;
      late Analyzers analyzers;

      tearDownAll(() => projectDir.deleteBestEffort(recursive: true));
      tearDown(() async {
        await generatedDir.deleteBestEffort(recursive: true);
        await generatedClientDir.deleteBestEffort(recursive: true);
        await generatedClientMigrationsDir.deleteBestEffort(recursive: true);
      });

      setUpAll(() async {
        (projectDir, generatedDir) = await _buildProject();
        await _createClientPackage(projectDir);
        generatedClientDir = Directory(
          path.join(projectDir.path, 'test_client', 'lib', 'src', 'protocol'),
        );
        generatedClientMigrationsDir = Directory(
          path.join(projectDir.path, 'test_client', 'lib', 'migrations'),
        );

        File(path.join(projectDir.path, 'analysis_options.yaml'))
          ..createSync(recursive: true)
          ..writeAsStringSync('''
formatter:
  page_width: 80
  trailing_commas: preserve
''');
        File(
            path.join(
              projectDir.path,
              'test_client',
              'analysis_options.yaml',
            ),
          )
          ..createSync(recursive: true)
          ..writeAsStringSync('''
formatter:
  page_width: 120
  trailing_commas: automate
''');
        File(
            path.join(
              generatedClientMigrationsDir.path,
              'analysis_options.yaml',
            ),
          )
          ..createSync(recursive: true)
          ..writeAsStringSync('''
formatter:
  page_width: 60
''');
        File(
            path.join(
              projectDir.path,
              'lib',
              'src',
              'protocol',
              'item.spy.yaml',
            ),
          )
          ..createSync(recursive: true)
          ..writeAsStringSync('''
class: Item
fields:
  name: String
''');
        File(
            path.join(
              projectDir.path,
              'lib',
              'src',
              'protocol',
              'database_item.spy.yaml',
            ),
          )
          ..createSync(recursive: true)
          ..writeAsStringSync('''
class: DatabaseItem
table: database_item
database: all
fields:
  name: String
''');

        config = buildTestServerConfig(projectDir);
        analyzers = await Analyzers.create(config);
      });

      group('when generating,', () {
        setUp(() async {
          await analyzers.performGenerate(config: config);
        });

        test(
          'then server model code uses the server page width.',
          () async {
            final generatedModel = await File(
              path.join(generatedDir.path, 'item.dart'),
            ).readAsString();

            expect(
              generatedModel,
              contains('''
abstract class Item
    implements _is.SerializableModel, _is.ProtocolSerialization {'''),
            );
          },
        );

        test(
          'then client model code uses the client page width.',
          () async {
            final generatedClientModel = await File(
              path.join(generatedClientDir.path, 'item.dart'),
            ).readAsString();

            expect(
              generatedClientModel,
              contains(
                'abstract class Item implements '
                '_isc.SerializableModel, _isc.ProtocolSerialization {',
              ),
            );
          },
        );

        test(
          'then generated client migration Dart is format-clean.',
          () async {
            final formatResult = await Process.run(
              dartExecutablePath,
              [
                'format',
                '--output=none',
                '--set-exit-if-changed',
                generatedClientMigrationsDir.path,
              ],
              workingDirectory: projectDir.path,
            );

            expect(
              formatResult.exitCode,
              0,
              reason: '${formatResult.stdout}\n${formatResult.stderr}',
            );
          },
        );
      });
    },
  );

  group(
    'Given a not yet generated enum in a package preserving trailing commas,',
    () {
      late Directory projectDir;
      late Directory generatedDir;
      late String generatedEnumPath;
      late GeneratorConfig config;
      late Analyzers analyzers;

      tearDownAll(() => projectDir.deleteBestEffort(recursive: true));
      tearDown(() => generatedDir.deleteBestEffort(recursive: true));

      setUpAll(() async {
        (projectDir, generatedDir) = await _buildProject();
        File(path.join(projectDir.path, 'analysis_options.yaml'))
          ..createSync(recursive: true)
          ..writeAsStringSync('''
formatter:
  page_width: 80
  trailing_commas: preserve
''');
        File(
            path.join(
              projectDir.path,
              'lib',
              'src',
              'protocol',
              'chat_role.spy.yaml',
            ),
          )
          ..createSync(recursive: true)
          ..writeAsStringSync('''
enum: ChatRole
serialized: byName
values:
  - user
  - assistant
  - system
''');
        generatedEnumPath = path.join(generatedDir.path, 'chat_role.dart');
        config = buildTestServerConfig(projectDir);
        analyzers = await Analyzers.create(config);
      });

      group('when generating,', () {
        setUp(() async {
          await analyzers.performGenerate(config: config);
        });

        test('then the trailing comma is preserved.', () async {
          final generatedEnum = await File(generatedEnumPath).readAsString();

          expect(generatedEnum, contains('  assistant,\n  system,\n  ;'));
        });

        test('then the generated enum is format-clean.', () async {
          final formatResult = await Process.run(
            dartExecutablePath,
            [
              'format',
              '--output=none',
              '--set-exit-if-changed',
              generatedEnumPath,
            ],
            workingDirectory: projectDir.path,
          );

          expect(
            formatResult.exitCode,
            0,
            reason: '${formatResult.stdout}\n${formatResult.stderr}',
          );
        });
      });
    },
  );

  group(
    'Given a model that is removed from disk when analyzers are updated incrementally',
    () {
      late Directory projectDir;
      late GeneratorConfig config;
      late Analyzers analyzers;
      late String modelPath;

      tearDownAll(() => projectDir.deleteBestEffort(recursive: true));

      setUpAll(() async {
        (projectDir, _) = await _buildProject();
        config = buildTestServerConfig(projectDir);
        analyzers = await Analyzers.createAndUpdate(config);

        modelPath = p.join(
          projectDir.path,
          'lib',
          'src',
          'models',
          'removed_model.spy.yaml',
        );
        File(modelPath)
          ..createSync(recursive: true)
          ..writeAsStringSync('''
class: RemovedModel
fields:
  name: String
''');

        await analyzers.update(
          config: config,
          affectedPaths: {modelPath},
        );
        await analyzers.performGenerate(config: config);
      });

      test(
        'when the model is deleted '
        'then it is no longer included in generated files',
        () async {
          File(modelPath).deleteSync();

          await analyzers.update(
            config: config,
            affectedPaths: {p.absolute(modelPath)},
            requirements: GenerationRequirements.full,
          );

          final result = await analyzers.performGenerate(
            config: config,
            requirements: GenerationRequirements.full,
            affectedPaths: {p.absolute(modelPath)},
          );

          expect(result.success, isTrue);
          expect(
            result.generatedFiles.any((f) => f.contains('removed_model')),
            isFalse,
          );
        },
      );
    },
  );

  group(
    'Given server and client imports of a shared model with no generated files,',
    () {
      late Directory projectDir;
      late GeneratorConfig config;
      late Analyzers analyzers;

      tearDownAll(() => projectDir.deleteBestEffort(recursive: true));

      setUpAll(() async {
        (projectDir, _) = await _buildProject();
        await _createSharedPackage(projectDir);
        await _createClientPackage(projectDir, dependsOnSharedPackage: true);

        for (final package in ['test_server', 'test_client']) {
          File(
              path.join(
                projectDir.path,
                'lib',
                'src',
                'endpoints',
                '${package}_shared_model_endpoint.dart',
              ),
            )
            ..createSync(recursive: true)
            ..writeAsStringSync('''
import 'package:serverpod/serverpod.dart';
import '${package == 'test_server' ? 'package:test_shared/test_shared.dart' : 'package:test_client/test_client.dart'}';

class ${package == 'test_server' ? 'Server' : 'Client'}SharedModelEndpoint extends Endpoint {
  Future<SharedModel> getItem(Session session, SharedModel item) async {
    return item;
  }
}
''');
        }

        config = buildTestServerConfig(
          projectDir,
          sharedModelsSourcePathsParts: {
            'test_shared': ['test_shared'],
          },
        );
        analyzers = await Analyzers.create(config);
      });

      test(
        'when generating, '
        'then generation succeeds on first run.',
        () async {
          final result = await analyzers.performGenerate(config: config);

          expect(result.success, isTrue);
        },
      );
    },
  );

  group(
    'Given a not yet generated shared model package with page width 120,',
    () {
      late Directory projectDir;
      late Directory generatedSharedDir;
      late GeneratorConfig config;
      late Analyzers analyzers;

      tearDownAll(() => projectDir.deleteBestEffort(recursive: true));
      tearDown(() => generatedSharedDir.deleteBestEffort(recursive: true));

      setUpAll(() async {
        (projectDir, _) = await _buildProject();
        await _createSharedPackage(projectDir);
        await File(
          path.join(projectDir.path, 'test_shared', 'analysis_options.yaml'),
        ).writeAsString('''
formatter:
  page_width: 120
  trailing_commas: automate
''');
        generatedSharedDir = Directory(
          path.join(projectDir.path, 'test_shared', 'lib', 'src', 'generated'),
        );
        config = buildTestServerConfig(
          projectDir,
          sharedModelsSourcePathsParts: {
            'test_shared': ['test_shared'],
          },
        );
        analyzers = await Analyzers.create(config);
      });

      test(
        'when generating, '
        'then shared model code uses the shared package page width.',
        () async {
          await analyzers.performGenerate(config: config);
          final generatedSharedModel = await File(
            path.join(generatedSharedDir.path, 'shared_model.dart'),
          ).readAsString();

          expect(
            generatedSharedModel,
            contains(
              'abstract class SharedModel implements '
              '_iss.SerializableModel, _iss.ProtocolSerialization {',
            ),
          );
        },
      );
    },
  );
}

Future<void> _createClientPackage(
  Directory projectDir, {
  bool dependsOnSharedPackage = false,
}) async {
  final pathToServerpodRoot = await resolveServerpodRoot();
  final clientDir = Directory(path.join(projectDir.path, 'test_client'));
  final sharedDependency = dependsOnSharedPackage
      ? '''
  test_shared:
    path: ../test_shared
'''
      : '';

  File(path.join(clientDir.path, 'pubspec.yaml'))
    ..createSync(recursive: true)
    ..writeAsStringSync('''
name: test_client

environment:
  sdk: '^3.10.3'

dependencies:
  serverpod_client:
    path: $pathToServerpodRoot/packages/serverpod_client
$sharedDependency
''');

  File(
      path.join(clientDir.path, 'lib', 'test_client.dart'),
    )
    ..createSync(recursive: true)
    ..writeAsStringSync('''
export 'src/protocol/protocol.dart';
${dependsOnSharedPackage ? "export 'package:test_shared/test_shared.dart';" : ''}
''');

  final serverPubspec = File(path.join(projectDir.path, 'pubspec.yaml'));
  serverPubspec.writeAsStringSync(
    serverPubspec.readAsStringSync().replaceFirst(
      'dependencies:\n',
      'dependencies:\n'
          '  test_client:\n'
          '    path: test_client\n'
          '${dependsOnSharedPackage ? '  test_shared:\n    path: test_shared\n' : ''}',
    ),
  );

  final serverPubGet = await Process.run(
    'dart',
    ['pub', 'get'],
    workingDirectory: projectDir.absolute.path,
  );
  assert(
    serverPubGet.exitCode == 0,
    'Failed to add the test client dependency: ${serverPubGet.stderr}',
  );
}

Future<void> _createSharedPackage(Directory projectDir) async {
  final pathToServerpodRoot = await resolveServerpodRoot();
  final sharedDir = Directory(path.join(projectDir.path, 'test_shared'));

  File(path.join(sharedDir.path, 'pubspec.yaml'))
    ..createSync(recursive: true)
    ..writeAsStringSync('''
name: test_shared

environment:
  sdk: '^3.10.3'

dependencies:
  serverpod_serialization:
    path: $pathToServerpodRoot/packages/serverpod_serialization
''');

  File(path.join(sharedDir.path, 'lib', 'test_shared.dart'))
    ..createSync(recursive: true)
    ..writeAsStringSync("export 'src/generated/protocol.dart';\n");

  File(
      path.join(
        sharedDir.path,
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
}
