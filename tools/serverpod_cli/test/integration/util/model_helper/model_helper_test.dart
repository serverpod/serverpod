import 'dart:io';

import 'package:path/path.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import '../../../test_util/builders/generator_config_builder.dart';

void main() {
  group('Test path extraction - extractPathFromConfig.', () {
    var serverRootDir = Directory(
      join(
        'test',
        'integration',
        'util',
        'test_assets',
        'protocol_helper',
        'has_serverpod_server_project',
        'test_server',
      ),
    );

    test(
      'Given a model path directly inside the protocol folder, then the parts list is empty.',
      () {
        var modelFile = File(
          join(
            'test',
            'integration',
            'util',
            'test_assets',
            'protocol_helper',
            'has_serverpod_server_project',
            'test_server',
            'lib',
            'src',
            'protocol',
            'test.yaml',
          ),
        );

        var config = GeneratorConfigBuilder()
            .withServerPackageDirectoryPathParts(split(serverRootDir.path))
            .build();

        var pathParts = ModelHelper.extractPathFromConfig(
          config,
          modelFile.uri,
        );

        expect(pathParts, []);
      },
    );

    test(
      'Given a model with a nested path inside the protocol folder, then the parts list contains the nested path.',
      () {
        var modelFile = File(
          join(
            'test',
            'integration',
            'util',
            'test_assets',
            'protocol_helper',
            'has_serverpod_server_project',
            'test_server',
            'lib',
            'src',
            'protocol',
            'nested',
            'folder',
            'test.yaml',
          ),
        );

        var config = GeneratorConfigBuilder()
            .withServerPackageDirectoryPathParts(split(serverRootDir.path))
            .build();

        var pathParts = ModelHelper.extractPathFromConfig(
          config,
          modelFile.uri,
        );

        expect(pathParts, ['nested', 'folder']);
      },
    );

    test(
      'Given a model with a nested path inside the model folder, then the parts list contains the nested path.',
      () {
        var modelFile = File(
          join(
            'test',
            'integration',
            'util',
            'test_assets',
            'protocol_helper',
            'has_serverpod_server_project',
            'test_server',
            'lib',
            'src',
            'models',
            'nested',
            'folder',
            'test.yaml',
          ),
        );

        var config = GeneratorConfigBuilder()
            .withServerPackageDirectoryPathParts(split(serverRootDir.path))
            .build();

        var pathParts = ModelHelper.extractPathFromConfig(
          config,
          modelFile.uri,
        );

        expect(pathParts, ['nested', 'folder']);
      },
    );

    test(
      'Given a model with a path outside of the lib folder, then parts list contains all the path parts',
      () {
        var filePathParts = [
          'test',
          'integration',
          'util',
          'test_assets',
          'protocol_helper',
          'has_serverpod_server_project',
          'test_server',
        ];
        var modelFile = File(joinAll(filePathParts));

        var config = GeneratorConfigBuilder()
            .withServerPackageDirectoryPathParts(split(serverRootDir.path))
            .build();

        var pathParts = ModelHelper.extractPathFromConfig(
          config,
          modelFile.uri,
        );

        expect(pathParts, filePathParts);
      },
    );
  });

  group('Test yaml model loader.', () {
    var serverRootDir = Directory(
      join(
        'test',
        'integration',
        'util',
        'test_assets',
        'protocol_helper',
        'has_serverpod_server_project',
        'test_server',
      ),
    );

    var config = GeneratorConfigBuilder()
        .withServerPackageDirectoryPathParts(split(serverRootDir.path))
        .withModules([])
        .build();

    test(
      'Given a serverpod project with model files then the converted model path has the file uri set.',
      () async {
        var models = await ModelHelper.loadProjectYamlModelsFromDisk(config);

        var paths = models.map((e) => e.yamlSourceUri.path).toList();

        expect(
          paths.first,
          contains(
            'test/integration/util/test_assets/protocol_helper/has_serverpod_server_project/test_server/lib/src/models/example.spy.yaml',
          ),
        );

        expect(
          paths.last,
          contains(
            'test/integration/util/test_assets/protocol_helper/has_serverpod_server_project/test_server/lib/src/protocol/test.spy.yaml',
          ),
        );
      },
    );

    test(
      'Given a serverpod project with model files then the converted model path has the subDirPathParts set to empty arrays.',
      () async {
        var models = await ModelHelper.loadProjectYamlModelsFromDisk(config);

        var rootPathParts = models.map((e) => e.subDirPathParts);

        expect(rootPathParts.first, []);

        expect(rootPathParts.last, []);
      },
    );

    test(
      'Given a serverpod project with model files in a nested folder then the converted model path has the subDirPathParts set to the nested folder inside the models directory.',
      () async {
        var serverRootDir = Directory(
          join(
            'test',
            'integration',
            'util',
            'test_assets',
            'protocol_helper',
            'nested_directory_server_project',
            'test_server',
          ),
        );

        var config = GeneratorConfigBuilder()
            .withServerPackageDirectoryPathParts(split(serverRootDir.path))
            .withModules([])
            .build();

        var models = await ModelHelper.loadProjectYamlModelsFromDisk(config);

        var rootPathParts = models.map((e) => e.subDirPathParts);

        expect(rootPathParts.first, ['nested', 'folder']);
      },
    );

    test(
      'Given a serverpod project with model files, then the converted model yaml string has been set.',
      () async {
        var models = await ModelHelper.loadProjectYamlModelsFromDisk(config);

        expect(models.last.yaml.replaceAll('\r', ''), '''
class: Test
fields:
  name: String
''');

        expect(models.first.yaml.replaceAll('\r', ''), '''
class: Example
fields:
  name: String
''');
      },
    );
  });

  test(
    'Given a serverpod project without a protocol or model folder then the converted model path list is empty.',
    () async {
      var serverRootDir = Directory(
        join(
          'test',
          'integration',
          'util',
          'test_assets',
          'protocol_helper',
          'empty_serverpod_server_project',
          'test_server',
        ),
      );

      var config = GeneratorConfigBuilder()
          .withServerPackageDirectoryPathParts(split(serverRootDir.path))
          .withModules([])
          .build();

      var models = await ModelHelper.loadProjectYamlModelsFromDisk(config);

      var paths = models.map((e) => e.yamlSourceUri.path).toList();

      expect(paths, isEmpty);
    },
  );

  test(
    'Given a serverpod project without a protocol or model folder then the converted model path list is empty.',
    () async {
      var serverRootDir = Directory(
        join(
          'test',
          'integration',
          'util',
          'test_assets',
          'protocol_helper',
          'protocol_serverpod_server_project',
          'test_server',
        ),
      );

      var config = GeneratorConfigBuilder()
          .withServerPackageDirectoryPathParts(split(serverRootDir.path))
          .withModules([])
          .build();

      var models = await ModelHelper.loadProjectYamlModelsFromDisk(config);

      var paths = models.map((e) => e.yamlSourceUri.path).toList();

      expect(
        paths.first,
        contains(
          'test/integration/util/test_assets/protocol_helper/protocol_serverpod_server_project/test_server/lib/src/protocol/test.spy.yaml',
        ),
      );
    },
  );

  group('Test createModelSourceForPath.', () {
    var serverRootDir = Directory(
      join(
        'test',
        'integration',
        'util',
        'test_assets',
        'protocol_helper',
        'has_serverpod_server_project',
        'test_server',
      ),
    );

    test(
      'Given a path under the server lib directory, then createModelSourceForPath returns a server model source with default module alias and isSharedModel false.',
      () {
        var path = join(
          serverRootDir.path,
          'lib',
          'src',
          'protocol',
          'nested',
          'folder',
          'test.yaml',
        );

        var config = GeneratorConfigBuilder()
            .withServerPackageDirectoryPathParts(split(serverRootDir.path))
            .withModules([])
            .build();

        var source = ModelHelper.createModelSourceForPath(
          config,
          path,
          '''
class: Test
fields:
  name: String''',
        );

        expect(source.moduleAlias, defaultModuleAlias);
        expect(source.isSharedModel, false);
        expect(source.sharedPackageName, isNull);
        expect(source.subDirPathParts, ['nested', 'folder']);
      },
    );

    group(
      'Given a path under a shared package lib directory',
      () {
        late Directory testDirectory;
        late Directory testProject;

        setUp(() {
          testDirectory = Directory(
            join(Directory.current.path, const Uuid().v4()),
          );
          testDirectory.createSync(recursive: true);

          testProject = Directory(
            join(testDirectory.path, const Uuid().v4()),
          );
          testProject.createSync(recursive: true);

          Directory(
            join(
              testProject.path,
              'packages',
              'my_shared',
              'lib',
              'src',
              'models',
            ),
          ).createSync(recursive: true);
        });

        tearDown(() {
          testDirectory.deleteSync(recursive: true);
        });

        test(
          'then createModelSourceForPath returns a shared model source with the package alias and isSharedModel true.',
          () {
            var config = GeneratorConfigBuilder()
                .withServerPackageDirectoryPathParts(split(testProject.path))
                .withSharedModelsSourcePathsParts({
                  'my_shared': ['packages', 'my_shared'],
                })
                .withModules([])
                .build();

            var path = join(
              testProject.path,
              'packages',
              'my_shared',
              'lib',
              'src',
              'models',
              'foo.yaml',
            );

            var source = ModelHelper.createModelSourceForPath(
              config,
              path,
              '''
class: Foo
fields:
  id: int''',
            );

            expect(source.moduleAlias, 'my_shared');
            expect(source.isSharedModel, true);
            expect(source.sharedPackageName, 'my_shared');
            expect(source.subDirPathParts, []);
          },
        );
      },
    );

    group(
      'Given a path in a nested directory under a shared package lib',
      () {
        late Directory testDirectory;
        late Directory testProject;

        setUp(() {
          testDirectory = Directory(
            join(Directory.current.path, const Uuid().v4()),
          );
          testDirectory.createSync(recursive: true);

          testProject = Directory(
            join(testDirectory.path, const Uuid().v4()),
          );
          testProject.createSync(recursive: true);

          Directory(
            join(
              testProject.path,
              'packages',
              'shared',
              'lib',
              'src',
              'models',
              'feature_a',
            ),
          ).createSync(recursive: true);
        });

        tearDown(() {
          testDirectory.deleteSync(recursive: true);
        });

        test(
          'then the subDirPathParts are relative to the model root.',
          () {
            var config = GeneratorConfigBuilder()
                .withServerPackageDirectoryPathParts(split(testProject.path))
                .withSharedModelsSourcePathsParts({
                  'shared': ['packages', 'shared'],
                })
                .withModules([])
                .build();

            var path = join(
              testProject.path,
              'packages',
              'shared',
              'lib',
              'src',
              'models',
              'feature_a',
              'bar.yaml',
            );

            var source = ModelHelper.createModelSourceForPath(
              config,
              path,
              '''
class: Bar
fields:
  x: int''',
            );

            expect(source.moduleAlias, 'shared');
            expect(source.isSharedModel, true);
            expect(source.subDirPathParts, ['feature_a']);
          },
        );
      },
    );
  });

  group(
    'Given a serverpod project with server and shared package model files',
    () {
      late Directory testDirectory;
      late Directory testProject;
      late List<ModelSource> models;

      setUpAll(() {
        testDirectory = Directory(
          join(Directory.current.path, const Uuid().v4()),
        );
        testDirectory.createSync(recursive: true);
      });

      setUp(() async {
        testProject = Directory(
          join(testDirectory.path, const Uuid().v4()),
        );
        testProject.createSync(recursive: true);

        var serverModelsDir = Directory(
          join(
            testProject.path,
            'lib',
            'src',
            'models',
          ),
        );
        serverModelsDir.createSync(recursive: true);
        File(join(serverModelsDir.path, 'server_model.yaml')).writeAsStringSync(
          '''
class: ServerModel
fields:
  name: String
''',
        );

        var sharedModelsDir = Directory(
          join(
            testProject.path,
            'packages',
            'shared',
            'lib',
            'src',
            'models',
          ),
        );
        sharedModelsDir.createSync(recursive: true);
        File(join(sharedModelsDir.path, 'shared_model.yaml')).writeAsStringSync(
          '''
class: SharedModel
fields:
  id: int
''',
        );

        var config = GeneratorConfigBuilder()
            .withServerPackageDirectoryPathParts(split(testProject.path))
            .withSharedModelsSourcePathsParts({
              'shared': ['packages', 'shared'],
            })
            .withModules([])
            .build();

        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      tearDown(() {
        testProject.deleteSync(recursive: true);
      });

      tearDownAll(() {
        testDirectory.deleteSync(recursive: true);
      });

      test('then the loaded list contains the two models.', () {
        expect(models.length, 2);
      });

      test(
        'then the server model has isSharedModel false and default module alias.',
        () {
          var serverModel = models.where((m) => !m.isSharedModel).singleOrNull;
          expect(serverModel, isNotNull);
          expect(serverModel!.isSharedModel, false);
          expect(serverModel.sharedPackageName, isNull);
          expect(serverModel.moduleAlias, defaultModuleAlias);
          expect(serverModel.yaml, contains('ServerModel'));
        },
      );

      test(
        'then the shared package model has isSharedModel true and sharedPackageName set.',
        () {
          var sharedModel = models.where((m) => m.isSharedModel).singleOrNull;
          expect(sharedModel, isNotNull);
          expect(sharedModel!.isSharedModel, true);
          expect(sharedModel.sharedPackageName, 'shared');
          expect(sharedModel.moduleAlias, 'shared');
          expect(sharedModel.subDirPathParts, []);
          expect(sharedModel.yaml, contains('SharedModel'));
        },
      );
    },
  );
}
