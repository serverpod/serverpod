import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/analyzers.dart';
import 'package:serverpod_cli/src/util/file_ex.dart';
import 'package:test/test.dart';

import '../../test_util/builders/generator_config_builder.dart';
import '../../test_util/endpoint_validation_helpers.dart';

/// Creates a [GeneratorConfig] for a test project at [projectDir].
GeneratorConfig _buildTestConfig(Directory projectDir) {
  return GeneratorConfigBuilder()
      .withName('test')
      .withServerPackageDirectoryPathParts([projectDir.path])
      .withRelativeDartClientPackagePathParts(['test_client'])
      .withModules([
        ModuleConfig(
          type: PackageType.server,
          name: 'test',
          nickname: 'test',
          migrationVersions: [],
          serverPackageDirectoryPathParts: [projectDir.path],
        ),
      ])
      .build();
}

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

        config = _buildTestConfig(projectDir);
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

  group('Given a model and an endpoint using it with no generated files', () {
    late Directory projectDir;
    late Directory generatedDir;
    late GeneratorConfig config;
    late Analyzers analyzers;

    tearDownAll(() => projectDir.deleteIfExists(recursive: true));
    tearDown(() => generatedDir.deleteIfExists(recursive: true));

    setUpAll(() async {
      (projectDir, generatedDir) = await _buildProject();

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
      // exports only) is written before analysis so the import resolves.
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

      config = _buildTestConfig(projectDir);
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
}
