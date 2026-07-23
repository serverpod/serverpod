import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/analyzers.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

import '../../test_util/builders/generator_config_builder.dart';
import '../../test_util/endpoint_validation_helpers.dart';

Future<(Directory, Directory)> _buildProject() async {
  final projectDir = Directory.systemTemp.createTempSync('cli_test_');
  final generatedDir = Directory(
    p.join(projectDir.path, 'lib', 'src', 'generated'),
  );
  await createTestEnvironment(projectDir);

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

      tearDownAll(() => projectDir.deleteIfExists(recursive: true));

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

          tearDown(() => generatedDir.deleteIfExists(recursive: true));
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

  group('Given a model and endpoints using it with no generated files', () {
    late Directory projectDir;
    late Directory generatedDir;
    late Directory generatedClientDir;
    late GeneratorConfig config;
    late Analyzers analyzers;

    tearDownAll(() => projectDir.deleteIfExists(recursive: true));
    tearDown(() {
      generatedDir.deleteIfExists(recursive: true);
      generatedClientDir.deleteIfExists(recursive: true);
    });

    setUpAll(() async {
      (projectDir, generatedDir) = await _buildProject();
      await _createClientPackage(projectDir);
      generatedClientDir = Directory(
        path.join(projectDir.path, 'test_client', 'lib', 'src', 'protocol'),
      );

      var modelFile = File(
        path.join(
          projectDir.path,
          'lib',
          'src',
          'protocol',
          'item.spy.yaml',
        ),
      );
      modelFile.createSync(recursive: true);
      modelFile.writeAsStringSync('''
class: Item
fields:
  name: String
''');

      // Endpoint that imports protocol.dart and uses the generated model.
      // With no generated files on disk, a temporary protocol.dart (model
      // exports and a stub Protocol class) is written before analysis so the
      // import resolves.
      var endpointFile = File(
        path.join(
          projectDir.path,
          'lib',
          'src',
          'endpoints',
          'item_endpoint.dart',
        ),
      );
      endpointFile.createSync(recursive: true);
      endpointFile.writeAsStringSync('''
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

    group('when generating', () {
      late GenerateResult result;

      tearDown(() => generatedDir.deleteIfExists(recursive: true));
      setUp(() async {
        result = await analyzers.performGenerate(
          config: config,
        );
      });

      test('then generation succeeds on first run.', () {
        expect(result.success, isTrue);
      });

      test('then endpoint file is generated.', () {
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
    });
  });

  group(
    'Given a model that is removed from disk when analyzers are updated incrementally',
    () {
      late Directory projectDir;
      late GeneratorConfig config;
      late Analyzers analyzers;
      late String modelPath;

      tearDownAll(() => projectDir.deleteIfExists(recursive: true));

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
    'Given server and client imports of a shared model with no generated files',
    () {
      late Directory projectDir;
      late GeneratorConfig config;
      late Analyzers analyzers;

      tearDownAll(() => projectDir.deleteIfExists(recursive: true));

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
  sdk: '>=3.0.0 <4.0.0'

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
  sdk: '>=3.0.0 <4.0.0'

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
