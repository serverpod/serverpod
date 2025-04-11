import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

class PubspecDependency {
  final Version version;
  final String name;

  PubspecDependency({required this.version, required this.name});
}

class PubspecDependencyBuilder {
  String _name = 'dependency_name';
  Version _version = Version.parse('1.0.0');

  PubspecDependencyBuilder withName(String name) {
    _name = name;
    return this;
  }

  PubspecDependencyBuilder withVersion(Version version) {
    _version = version;
    return this;
  }

  PubspecDependency build() {
    return PubspecDependency(
      name: _name,
      version: _version,
    );
  }
}

class PubspecBuilder {
  String _name = 'package_name';
  Version _version = Version.parse('1.0.0');
  String _description = 'A sample package';
  Version _sdk = Version.parse('3.6.0');

  List<PubspecDependency> _dependencies = [];
  List<PubspecDependency> _devDependencies = [];

  PubspecBuilder withName(String name) {
    _name = name;
    return this;
  }

  PubspecBuilder withVersion(Version version) {
    _version = version;
    return this;
  }

  PubspecBuilder withDescription(String description) {
    _description = description;
    return this;
  }

  PubspecBuilder withSdk(Version sdk) {
    _sdk = sdk;
    return this;
  }

  PubspecBuilder addDependency(PubspecDependency dependency) {
    _dependencies.add(dependency);
    return this;
  }

  PubspecBuilder withDependencies(List<PubspecDependency> dependencies) {
    _dependencies = dependencies;
    return this;
  }

  PubspecBuilder addDevDependency(PubspecDependency dependency) {
    _devDependencies.add(dependency);
    return this;
  }

  PubspecBuilder withDevDependencies(List<PubspecDependency> devDependencies) {
    _devDependencies = devDependencies;
    return this;
  }

  Pubspec build() {
    return Pubspec(
      _name,
      version: _version,
      description: _description,
      environment: {
        'sdk': _sdk,
      },
      dependencies: {
        for (var dep in _dependencies)
          dep.name: HostedDependency(version: dep.version),
      },
      devDependencies: {
        for (var dep in _devDependencies)
          dep.name: HostedDependency(version: dep.version),
      },
    );
  }

  static String serialize(Pubspec pubspec) {
    var output = StringBuffer();
    output.writeln('name: ${pubspec.name}');
    output.writeln('version: ${pubspec.version}');
    output.writeln('description: ${pubspec.description}');

    output.writeln();
    output.writeln('environment:');

    for (var entry in pubspec.environment.entries) {
      output.writeln('  ${entry.key}: ${entry.value}');
    }
    output.writeln();
    output.writeln('dependencies:');
    output.write(_serializeDependencies(pubspec.dependencies));

    output.writeln();
    output.writeln('dev_dependencies:');
    output.write(_serializeDependencies(pubspec.devDependencies));
    return output.toString();
  }

  static StringBuffer _serializeDependencies(
    Map<String, Dependency> dependencies,
  ) {
    var output = StringBuffer();
    for (var entry in dependencies.entries) {
      var dependency = entry.value;
      if (dependency is! HostedDependency) {
        throw StateError(
          'Only serialization for HostedDependency is supported, but got ${dependency.runtimeType}',
        );
      }
      output.writeln('  ${entry.key}: ${dependency.version}');
    }

    return output;
  }
}
