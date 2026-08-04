import 'package:test_descriptor/test_descriptor.dart' as d;

/// Builds a minimal on-disk Serverpod project (server and client package)
/// that [GeneratorConfig.load] accepts without running `dart pub get`.
class ProjectDirectoryBuilder {
  String _projectName = 'my_project';
  String _generatorYaml = 'type: server';
  List<d.Descriptor> _modelDirContents = [];

  ProjectDirectoryBuilder withProjectName(String projectName) {
    _projectName = projectName;
    return this;
  }

  ProjectDirectoryBuilder withGeneratorYaml(String generatorYaml) {
    _generatorYaml = generatorYaml;
    return this;
  }

  /// Contents of the server package's lib/src/models directory.
  ProjectDirectoryBuilder withModelDirContents(List<d.Descriptor> contents) {
    _modelDirContents = contents;
    return this;
  }

  /// Returns a descriptor rooted at 'project', holding
  /// `project/<name>_server` and `project/<name>_client`.
  d.DirectoryDescriptor build() {
    var serverDir = d.dir('${_projectName}_server', [
      d.file('pubspec.yaml', '''
name: ${_projectName}_server
dependencies:
  serverpod: ^2.0.0
'''),
      d.dir('lib', [
        d.dir('src', [
          d.dir('protocol', []),
          d.dir('models', _modelDirContents),
        ]),
      ]),
      d.dir('.dart_tool', [
        d.file('package_config.json', '''
{
  "configVersion": 2,
  "packages": [
    {
      "name": "${_projectName}_server",
      "rootUri": "../",
      "packageUri": "lib/"
    },
    {
      "name": "serverpod",
      "rootUri": "../.pub-cache/hosted/pub.dev/serverpod-2.0.0",
      "packageUri": "lib/"
    }
  ]
}
'''),
      ]),
      d.dir('config', [
        d.file('generator.yaml', _generatorYaml),
      ]),
    ]);

    var clientDir = d.dir('${_projectName}_client', [
      d.file('pubspec.yaml', '''
name: ${_projectName}_client
dependencies:
  serverpod_client: ^2.0.0
'''),
      d.dir('lib', [
        d.dir('src', [
          d.dir('protocol', []),
        ]),
      ]),
    ]);

    return d.dir('project', [serverDir, clientDir]);
  }
}
