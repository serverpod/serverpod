import 'dart:io';

import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';

/// Warnings for when the package version does not match the version of the
/// Serverpod's CLI.
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

/// A pubspec plus the yaml map it was read from, and a list of all augmented
/// dependencies regardless of kind.
class PubspecPlus {
  final Pubspec pubspec;
  final YamlMap yaml;

  PubspecPlus.fromFile(File file) : this.parse(file.readAsStringSync());

  PubspecPlus.parse(String yamlString)
      : pubspec = Pubspec.parse(yamlString),
        yaml = loadYaml(yamlString) as YamlMap; // safe as it is already parsed

  /// All dependencies in the pubspec, regardless of type. Augmented with name,
  /// kind, and span.
  // Only calculate once, but no need to calculate unless needed
  late List<Dep> deps = _iteratedDeps().toList();

  Iterable<Dep> _iteratedDeps() sync* {
    for (var x in [
      (
        deps: pubspec.dependencies,
        type: DepKind.normal,
        yaml: yaml['dependencies'] as YamlMap?
      ),
      (
        deps: pubspec.devDependencies,
        type: DepKind.dev,
        yaml: yaml['dev_dependencies'] as YamlMap?
      ),
      (
        deps: pubspec.dependencyOverrides,
        type: DepKind.override,
        yaml: yaml['dependency_overrides'] as YamlMap?
      ),
    ]) {
      for (var e in x.deps.entries) {
        var span = x.yaml!.nodes[e.key]!.span; // ! safe as we loop over entries
        yield Dep(e.key, e.value, x.type, span);
      }
    }
  }
}

/// A dependency can be either normal dependency, a dev dependency, or a
/// dependency override.
enum DepKind { normal, dev, override }

/// A container for a dependency that augments the dependency with its own name,
/// kind, and span in the associated pubspec.
class Dep<T extends Dependency> {
  final String name;
  final T dependency;
  final DepKind kind;
  final SourceSpan span;

  const Dep._(this.name, this.dependency, this.kind, this.span);

  factory Dep(
    String name,
    Dependency dependency,
    DepKind kind,
    SourceSpan span,
  ) {
    // trick to get the correct wrapped static type runtime
    return switch (dependency) {
      (HostedDependency dep) => Dep<HostedDependency>._(name, dep, kind, span),
      (PathDependency dep) => Dep<PathDependency>._(name, dep, kind, span),
      (GitDependency dep) => Dep<GitDependency>._(name, dep, kind, span),
      (SdkDependency dep) => Dep<SdkDependency>._(name, dep, kind, span),
    } as Dep<T>;
  }
}

typedef HostedDep = Dep<HostedDependency>; // for convenience

extension on PubspecPlus {
  Iterable<HostedDep> get serverpodDeps =>
      deps.whereType<HostedDep>().where((d) => d.name.startsWith('serverpod'));
}

List<SourceSpanSeverityException> validateServerpodPackagesVersion(
  Version version,
  PubspecPlus pubspecPlus,
) {
  return [
    for (var dep in pubspecPlus.serverpodDeps)
      ..._validatePackageCompatibilities(dep, version)
  ];
}

List<SourceSpanSeverityException> _validatePackageCompatibilities(
  HostedDep serverpodDep,
  Version cliVersion,
) {
  List<SourceSpanSeverityException> packageWarnings = [];

  var span = serverpodDep.span;
  var version = serverpodDep.dependency.version;
  if (!version.allowsAny(cliVersion)) {
    packageWarnings.add(SourceSpanSeverityException(
        ServerpodPackagesVersionCheckWarnings.incompatibleVersion, span,
        severity: SourceSpanSeverity.warning));
  }

  if (version is! Version) {
    packageWarnings.add(SourceSpanSeverityException(
        ServerpodPackagesVersionCheckWarnings.approximateVersion(cliVersion),
        span,
        severity: SourceSpanSeverity.warning));
  }

  return packageWarnings;
}
