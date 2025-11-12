import 'package:package_config/package_config.dart';
import 'package:path/path.dart' as p;
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import 'generator_config_file_builder.dart';
import 'package_config_builder.dart';
import 'pubspec_builder.dart';

class ModuleProject {
  final String name;
  final Pubspec pubspec;
  final bool includeGeneratorConfig;

  ModuleProject({
    required this.name,
    required this.pubspec,
    this.includeGeneratorConfig = true,
  });
}

class ModuleProjectBuilder {
  String _name;
  Pubspec _pubspec;
  bool _includeGeneratorConfig;

  ModuleProjectBuilder()
    : _pubspec = PubspecBuilder().build(),
      _name = 'example_module',
      _includeGeneratorConfig = true;

  ModuleProjectBuilder withName(String name) {
    _name = name;
    return this;
  }

  ModuleProjectBuilder withPubspecDependencies(List<String> dependencies) {
    var pubspec = PubspecBuilder()
        .withName(_name)
        .withDependencies(
          dependencies
              .map(
                (dependency) =>
                    PubspecDependencyBuilder().withName(dependency).build(),
              )
              .toList(),
        )
        .build();

    _pubspec = pubspec;
    return this;
  }

  ModuleProjectBuilder withIncludeGeneratorConfig(bool include) {
    _includeGeneratorConfig = include;
    return this;
  }

  ModuleProject build() {
    return ModuleProject(
      name: _name,
      pubspec: _pubspec,
      includeGeneratorConfig: _includeGeneratorConfig,
    );
  }
}

/// Context object for the constructed project dependency structure.
class ProjectDependencyContext {
  final PackageConfig packageConfig;
  final Pubspec projectPubspec;

  ProjectDependencyContext({
    required this.packageConfig,
    required this.projectPubspec,
  });
}

/// A factory class to create a project dependency structure for testing.
class ProjectDependencyStructureFactory {
  static const String _monoRepoDir = 'mono_repo';

  String _projectName = 'example_server';
  final List<String> _projectDependencies = [];
  List<ModuleProject> _moduleProjects = [];
  final List<String> _packageConfigPackages = [];

  /// Sets the name of the project.
  ProjectDependencyStructureFactory withProjectName(String name) {
    _projectName = name;
    return this;
  }

  /// Adds a dependency to the project.
  ProjectDependencyStructureFactory addProjectDependency(String moduleName) {
    _projectDependencies.add(moduleName);
    return this;
  }

  /// Adds a module project to the factory.
  ///
  /// This will create a directory for the module project with the given
  /// configuration.
  ProjectDependencyStructureFactory addModuleProject(ModuleProject module) {
    _moduleProjects.add(module);
    return this;
  }

  /// Sets the module projects for the factory.
  ///
  /// This will create directories for each module project with the given
  /// configuration.
  ProjectDependencyStructureFactory withModuleProjects(
    List<ModuleProject> modules,
  ) {
    _moduleProjects = List.from(modules);
    return this;
  }

  /// Adds a package to the package config (normally created when running
  /// `pub get`).
  ProjectDependencyStructureFactory addPackageToPackageConfig(
    String packageName,
  ) {
    _packageConfigPackages.add(packageName);
    return this;
  }

  /// Constructs the project dependency structure.
  Future<ProjectDependencyContext> construct() async {
    var projectPubspec = PubspecBuilder()
        .withName(_projectName)
        .withDependencies(
          _projectDependencies
              .map(
                (dependency) =>
                    PubspecDependencyBuilder().withName(dependency).build(),
              )
              .toList(),
        )
        .build();

    List<d.DirectoryDescriptor> moduleDirectories = [];
    for (var module in _moduleProjects) {
      var moduleDir = d.dir(module.name, [
        d.file('pubspec.yaml', PubspecBuilder.serialize(module.pubspec)),
        if (module.includeGeneratorConfig)
          d.dir('config', [
            d.file(
              'generator.yaml',
              GeneratorConfigFileBuilder().withType(PackageType.module).build(),
            ),
          ]),
      ]);

      moduleDirectories.add(moduleDir);
    }

    await d.dir(_monoRepoDir, moduleDirectories).create();

    var packageConfig = PackageConfigBuilder().withPackages([
      ..._packageConfigPackages.map(
        (packageName) => PackageBuilder()
            .withName(packageName)
            .withRoot(
              Uri.directory(p.joinAll([d.sandbox, _monoRepoDir, packageName])),
            )
            .build(),
      ),
    ]).build();

    return ProjectDependencyContext(
      packageConfig: packageConfig,
      projectPubspec: projectPubspec,
    );
  }
}
