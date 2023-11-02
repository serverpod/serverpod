import 'dart:io';

import 'package:path/path.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
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
    serializeEnumValuesAsStrings: true,
  );
}

final serverRootDir = Directory(join(
  'test',
  'util',
  'test_assets',
  'protocol_helper',
  'has_serverpod_server_project',
  'test_server',
));

final config = createGeneratorConfig(split(serverRootDir.path));

void main() {
  group('Test path extraction.', () {
    test(
        'Given a protocol path directly inside the protocol folder, then the parts list is empty.',
        () {
      var protocolFile = File(join(
        'test',
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

      var pathParts = ProtocolHelper.extractPathFromProtocolRoot(
        config,
        protocolFile.uri,
      );

      expect(pathParts, []);
    });

    test(
        'Given a protocol with a nested path inside the protocol folder, then the parts list contains the nested path.',
        () {
      var protocolFile = File(join(
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

      var pathParts = ProtocolHelper.extractPathFromProtocolRoot(
        config,
        protocolFile.uri,
      );

      expect(pathParts, ['nested', 'folder']);
    });

    group('Test yaml protocol loader.', () {
      test(
          'Given a serverpod project with protocol files, then the converted protocol path has the file uri set.',
          () async {
        var protocols =
            await ProtocolHelper.loadProjectYamlProtocolsFromDisk(config);

        expect(protocols.first.yamlSourceUri.path,
            'test/util/test_assets/protocol_helper/has_serverpod_server_project/test_server/lib/src/protocol/test.yaml');
      });

      test(
          'Given a serverpod project with protocol files, then the converted protocol yaml string has been set.',
          () async {
        var protocols =
            await ProtocolHelper.loadProjectYamlProtocolsFromDisk(config);

        expect(protocols.first.yaml.replaceAll('\r', ''), '''
class: Test
fields:
  name: String
''');
      });
    });
  });
}
