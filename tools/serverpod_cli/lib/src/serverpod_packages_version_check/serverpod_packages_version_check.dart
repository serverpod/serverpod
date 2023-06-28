import 'dart:io';

import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/util/pubspec_helpers.dart';
import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';

class ServerpodPackagesVersionCheckWarnings {
  static const incompatibleVersion =
      'Version not compatible with the running serverpod cli version. This '
      'may cause unexpected behavior. Please use the same version for both to '
      'ensure full functionality.';
  static String approximateVersion(Version cliVersion) =>
      'Package is defined with a version range (for example "^$cliVersion"). '
      'Ensure full compatibility between the serverpod cli and serverpod '
      'packages by defining a concrete package version. Prefer "$cliVersion" '
      'over "^$cliVersion".';
}

List<SourceSpanException> performServerpodPackagesAndCliVersionCheck(
  Version cliVersion,
  Directory directory,
) {
  List<SourceSpanException> accumulatedWarnings = [];

  var pubspecFiles = findPubspecsFiles(directory);
  if (pubspecFiles.isEmpty) {
    return accumulatedWarnings;
  }

  for (var pubspecFile in pubspecFiles) {
    try {
      var file = pubspecFile.readAsStringSync();
      var pubspec = Pubspec.parse(file);
      var yaml = loadYaml(file, sourceUrl: pubspecFile.uri) as YamlMap;
      var warnings =
          _validateServerpodPackagesVersion(cliVersion, pubspec, yaml);

      accumulatedWarnings.addAll(warnings);
    } catch (e) {
      throw Exception(
          'Error while parsing pubspec file: ${pubspecFile.path}: $e');
    }
  }

  return accumulatedWarnings;
}

List<SourceSpanException> _validateServerpodPackagesVersion(
  Version version,
  Pubspec pubspec,
  YamlMap yamlPubspec,
) {
  List<SourceSpanException> warnings = [];

  var serverpodDependencies =
      _getHostedServerpodDependencies(pubspec.dependencies);
  if (serverpodDependencies.isNotEmpty) {
    warnings.addAll(_validatePackageCompatibilities(
        serverpodDependencies, version, yamlPubspec['dependencies']));
  }

  var serverpodDevDependencies =
      _getHostedServerpodDependencies(pubspec.devDependencies);
  if (serverpodDevDependencies.isNotEmpty) {
    warnings.addAll(_validatePackageCompatibilities(
        serverpodDependencies, version, yamlPubspec['devDependencies']));
  }

  return warnings;
}

List<MapEntry<String, HostedDependency>> _getHostedServerpodDependencies(
  Map<String, Dependency> dependencies,
) {
  return dependencies.entries.fold([], (hostedDependencies, dependency) {
    if (!dependency.key.startsWith('serverpod') ||
        dependency.value is! HostedDependency) return hostedDependencies;

    // Cast dependencies to HostedDependency type
    return [
      ...hostedDependencies,
      MapEntry(dependency.key, dependency.value as HostedDependency)
    ];
  });
}

List<SourceSpanException> _validatePackageCompatibilities(
  List<MapEntry<String, HostedDependency>> serverpodPackages,
  Version cliVersion,
  YamlMap packagesYaml,
) {
  List<SourceSpanException> packageWarnings = [];

  for (var element in serverpodPackages) {
    var packageName = element.key;
    var package = element.value;
    var packageYamlNode = packagesYaml.nodes[packageName];

    if (packageYamlNode == null) {
      throw SourceSpanException(
          'Could not find package "$packageName" when inspecting as Yaml file',
          packagesYaml.span);
    }

    var packageVersion = package.version;
    if (!packageVersion.allowsAny(cliVersion)) {
      packageWarnings.add(SourceSpanException(
          ServerpodPackagesVersionCheckWarnings.incompatibleVersion,
          packageYamlNode.span));
    }

    if (packageVersion is! Version) {
      packageWarnings.add(SourceSpanException(
          ServerpodPackagesVersionCheckWarnings.approximateVersion(cliVersion),
          packageYamlNode.span));
    }
  }

  return packageWarnings;
}
