import 'dart:io';

import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/util/pubspec_helpers.dart';
import 'package:yaml/yaml.dart';

class ServerpodPackagesVersionCheckWarnings {
  static const incompatibleVersion =
      'The package version does not match the version of the Serverpod\'s '
      'CLI. This may cause errors or unexpected behavior.';
  static String approximateVersion(Version cliVersion) =>
      'The package is defined with a version range (for example '
      '"^$cliVersion"). This can cause a mismatch with Serverpod\'s CLI '
      'version. It\'s preferred to use "$cliVersion" over "^$cliVersion" for '
      'the Serverpod packages.';
}

List<SourceSpanSeverityException> performServerpodPackagesAndCliVersionCheck(
  Version cliVersion,
  Directory directory,
) {
  List<SourceSpanSeverityException> accumulatedWarnings = [];

  var pubspecFiles = findPubspecsFiles(
    directory,
    ignorePaths: ['vendor', 'serverpod'],
  );
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
      // TODO: Log to debug output
      // Failed to open or parse pubspec file
    }
  }

  return accumulatedWarnings;
}

List<SourceSpanSeverityException> _validateServerpodPackagesVersion(
  Version version,
  Pubspec pubspec,
  YamlMap yamlPubspec,
) {
  List<SourceSpanSeverityException> warnings = [];

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

List<SourceSpanSeverityException> _validatePackageCompatibilities(
  List<MapEntry<String, HostedDependency>> serverpodPackages,
  Version cliVersion,
  YamlMap packagesYaml,
) {
  List<SourceSpanSeverityException> packageWarnings = [];

  for (var element in serverpodPackages) {
    var packageName = element.key;
    var package = element.value;
    var packageYamlNode = packagesYaml.nodes[packageName];

    if (packageYamlNode == null) {
      throw SourceSpanSeverityException(
          'Could not find package "$packageName" in pubspec file.',
          packagesYaml.span,
          severity: SourceSpanSeverity.warning);
    }

    var packageVersion = package.version;
    if (!packageVersion.allowsAny(cliVersion)) {
      packageWarnings.add(SourceSpanSeverityException(
          ServerpodPackagesVersionCheckWarnings.incompatibleVersion,
          packageYamlNode.span,
          severity: SourceSpanSeverity.warning));
    }

    if (packageVersion is! Version) {
      packageWarnings.add(SourceSpanSeverityException(
          ServerpodPackagesVersionCheckWarnings.approximateVersion(cliVersion),
          packageYamlNode.span,
          severity: SourceSpanSeverity.warning));
    }
  }

  return packageWarnings;
}
