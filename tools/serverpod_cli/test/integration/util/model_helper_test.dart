import 'dart:io';

import 'package:path/path.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:test/test.dart';

GeneratorConfig createGeneratorConfig([
  List<String> serverPackageDirectoryPathParts = const [],
]) {
  return GeneratorConfig(
    name: 'test',
    type: PackageType.server,
    serverPackage: 'test_server',
    dartClientPackage: 'test_client',
    dartClientDependsOnServiceClient: true,
    serverPackageDirectoryPathParts: serverPackageDirectoryPathParts,
    relativeDartClientPackagePathParts: [],
    modules: [],
    extraClasses: [],
    enabledFeatures: [],
  );
}

void main() {
  group('Test path extraction - extractPathFromConfig.', () {
    var serverRootDir = Directory(join(
      'test',
      'integration'
          'util',
      'test_assets',
      'protocol_helper',
      'has_serverpod_server_project',
      'test_server',
    ));

    test(
        'Given a model path directly inside the protocol folder, then the parts list is empty.',
        () {
      var modelFile = File(join(
        'test',
        'integration'
            'util',
        'test_assets',
        'protocol_helper',
        'has_serverpod_server_project',
        'test_server',
        'lib',
        'src',
        'protocol',
        'test.yaml',
      ));

      var config = createGeneratorConfig(split(serverRootDir.path));

      var pathParts = ModelHelper.extractPathFromConfig(
        config,
        modelFile.uri,
      );

      expect(pathParts, []);
    });

    test(
        'Given a model with a nested path inside the protocol folder, then the parts list contains the nested path.',
        () {
      var modelFile = File(join(
        'test',
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
      ));

      var config = createGeneratorConfig(split(serverRootDir.path));

      var pathParts = ModelHelper.extractPathFromConfig(
        config,
        modelFile.uri,
      );

      expect(pathParts, ['nested', 'folder']);
    });

    test(
        'Given a model with a nested path inside the model folder, then the parts list contains the nested path.',
        () {
      var modelFile = File(join(
        'test',
        'util',
        'test_assets',
        'protocol_helper',
        'has_serverpod_server_project',
        'test_server',
        'lib',
        'src',
        'model',
        'nested',
        'folder',
        'test.yaml',
      ));

      var config = createGeneratorConfig(split(serverRootDir.path));

      var pathParts = ModelHelper.extractPathFromConfig(
        config,
        modelFile.uri,
      );

      expect(pathParts, ['nested', 'folder']);
    });
  });
  group('Test path extraction - extractPathFromModelRoot.', () {
    test(
        'Given a model path directly inside the model folder, then the parts list is empty.',
        () {
      var modelFile = File(join(
        'test',
        'integration'
            'util',
        'test_assets',
        'protocol_helper',
        'has_serverpod_server_project',
        'test_server',
        'lib',
        'src',
        'protocol',
        'test.yaml',
      ));

      var rootPath = [
        'test',
        'integration'
            'util',
        'test_assets',
        'protocol_helper',
        'has_serverpod_server_project',
        'test_server',
        'lib',
        'src',
        'protocol',
      ];

      var pathParts = ModelHelper.extractPathFromModelRoot(
        rootPath,
        modelFile.uri,
      );

      expect(pathParts, []);
    });

    test(
        'Given a model with a nested path inside the model folder, then the parts list contains the nested path.',
        () {
      var modelFile = File(join(
        'test',
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
      ));

      var rootPath = [
        'test',
        'util',
        'test_assets',
        'protocol_helper',
        'has_serverpod_server_project',
        'test_server',
        'lib',
        'src',
        'protocol'
      ];

      var pathParts = ModelHelper.extractPathFromModelRoot(
        rootPath,
        modelFile.uri,
      );

      expect(pathParts, ['nested', 'folder']);
    });
  });

  group('Test yaml model loader.', () {
    var serverRootDir = Directory(join(
      'test',
      'integration',
      'util',
      'test_assets',
      'protocol_helper',
      'has_serverpod_server_project',
      'test_server',
    ));

    var config = createGeneratorConfig(split(serverRootDir.path));

    test(
        'Given a serverpod project with model files, then the converted model path has the file uri set.',
        () async {
      var models = await ModelHelper.loadProjectYamlModelsFromDisk(config);

      var paths = models.map((e) => e.yamlSourceUri.path).toList();

      expect(
        paths.first,
        contains(
            'test/integration/util/test_assets/protocol_helper/has_serverpod_server_project/test_server/lib/src/models/example.spy.yaml'),
      );

      expect(
        paths.last,
        contains(
            'test/integration/util/test_assets/protocol_helper/has_serverpod_server_project/test_server/lib/src/protocol/test.spy.yaml'),
      );
    });

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
    });
  });

  test(
      'Given a serverpod project without a protocol or model folder then the converted model path list is empty.',
      () async {
    var serverRootDir = Directory(join(
      'test',
      'integration',
      'util',
      'test_assets',
      'protocol_helper',
      'empty_serverpod_server_project',
      'test_server',
    ));

    var config = createGeneratorConfig(split(serverRootDir.path));

    var models = await ModelHelper.loadProjectYamlModelsFromDisk(config);

    var paths = models.map((e) => e.yamlSourceUri.path).toList();

    expect(paths, isEmpty);
  });

  test(
      'Given a serverpod project without a protocol or model folder then the converted model path list is empty.',
      () async {
    var serverRootDir = Directory(join(
      'test',
      'integration',
      'util',
      'test_assets',
      'protocol_helper',
      'protocol_serverpod_server_project',
      'test_server',
    ));

    var config = createGeneratorConfig(split(serverRootDir.path));

    var models = await ModelHelper.loadProjectYamlModelsFromDisk(config);

    var paths = models.map((e) => e.yamlSourceUri.path).toList();

    expect(
      paths.first,
      contains(
          'test/integration/util/test_assets/protocol_helper/protocol_serverpod_server_project/test_server/lib/src/protocol/test.spy.yaml'),
    );
  });
}
