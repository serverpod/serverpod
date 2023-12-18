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
  );
}

void main() {
  group('Test path extraction.', () {
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

      var config = createGeneratorConfig(split(serverRootDir.path));

      var pathParts = ModelHelper.extractPathFromModelRoot(
        config,
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

      var config = createGeneratorConfig(split(serverRootDir.path));

      var pathParts = ModelHelper.extractPathFromModelRoot(
        config,
        modelFile.uri,
      );

      expect(pathParts, ['nested', 'folder']);
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
          paths,
          contains(
              'test/integration/util/test_assets/protocol_helper/has_serverpod_server_project/test_server/lib/src/protocol/test.spy.yaml'),
        );

        expect(
          paths,
          contains(
              'test/integration/util/test_assets/protocol_helper/has_serverpod_server_project/test_server/lib/src/model/example.spy.yaml'),
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
  });
}
