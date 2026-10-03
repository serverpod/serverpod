import 'package:test_descriptor/test_descriptor.dart' as d;

/// Builds a minimal on-disk Serverpod project (server and client package)
/// that [GeneratorConfig.load] accepts without running `dart pub get`.
class ProjectDirectoryBuilder {
  String _projectName = 'my_project';
  String _generatorYaml = 'type: server';
  List<d.Descriptor> _modelDirContents = [];
  final Map<String, List<d.Descriptor>> _modules = {};

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

  /// Adds a Serverpod module dependency named `<moduleName>_server` with
  /// [modelDirContents] in its lib/src/models directory. The module is
  /// placed next to the server package and gets the default nickname (the
  /// module name).
  ProjectDirectoryBuilder withModule(
    String moduleName, {
    List<d.Descriptor> modelDirContents = const [],
  }) {
    _modules[moduleName] = modelDirContents;
    return this;
  }

  String get _serverPubspecDependencies => [
    '  serverpod: ^2.0.0',
    for (var module in _modules.keys) '  ${module}_server: ^1.0.0',
  ].join('\n');

  String get _packageConfigEntries => [
    '''
    {
      "name": "${_projectName}_server",
      "rootUri": "../",
      "packageUri": "lib/"
    }''',
    '''
    {
      "name": "serverpod",
      "rootUri": "../.pub-cache/hosted/pub.dev/serverpod-2.0.0",
      "packageUri": "lib/"
    }''',
    for (var module in _modules.keys)
      '''
    {
      "name": "${module}_server",
      "rootUri": "../../${module}_server",
      "packageUri": "lib/"
    }''',
  ].join(',\n');

  /// Returns a descriptor rooted at 'project', holding
  /// `project/<name>_server`, `project/<name>_client` and one
  /// `project/<module>_server` directory per added module.
  d.DirectoryDescriptor build() {
    var serverDir = d.dir('${_projectName}_server', [
      d.file('pubspec.yaml', '''
name: ${_projectName}_server
dependencies:
$_serverPubspecDependencies
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
$_packageConfigEntries
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

    var moduleDirs = _modules.entries.map((entry) {
      var modulePackageName = '${entry.key}_server';
      return d.dir(modulePackageName, [
        d.file('pubspec.yaml', '''
name: $modulePackageName
'''),
        d.dir('config', [
          d.file('generator.yaml', 'type: module\n'),
        ]),
        d.dir('lib', [
          d.dir('src', [
            d.dir('protocol', []),
            d.dir('models', entry.value),
          ]),
        ]),
      ]);
    });

    return d.dir('project', [serverDir, clientDir, ...moduleDirs]);
  }
}
