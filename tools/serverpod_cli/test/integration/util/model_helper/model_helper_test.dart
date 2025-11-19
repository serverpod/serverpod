import 'dart:io';

import 'package:path/path.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:test/test.dart';

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
}
