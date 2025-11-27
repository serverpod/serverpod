import 'dart:io';
import 'package:pubspec_parse/pubspec_parse.dart';

import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';

import 'yaml_util.dart';

/// A pubspec plus the yaml map it was read from, and a list of all augmented
/// dependencies regardless of kind.
class PubspecPlus {
  final Pubspec pubspec;
  final YamlMap yaml;

  PubspecPlus.fromFile(File file)
    : this.parse(file.readAsStringSync(), sourceUrl: file.uri);

  PubspecPlus.parse(String yamlString, {Uri? sourceUrl})
    : pubspec = Pubspec.parse(yamlString, sourceUrl: sourceUrl),
      yaml = loadYamlMap(yamlString, sourceUrl: sourceUrl);

  /// All dependencies in the pubspec, regardless of type. Augmented with name,
  /// kind, and span.
  // Only calculate once, but no need to calculate unless needed
  late List<Dep> deps = _iteratedDeps().toList();

  Iterable<Dep> _iteratedDeps() sync* {
    for (var x in [
      (
        deps: pubspec.dependencies,
        type: DepKind.normal,
        yaml: yaml['dependencies'] as YamlMap?,
      ),
      (
        deps: pubspec.devDependencies,
        type: DepKind.dev,
        yaml: yaml['dev_dependencies'] as YamlMap?,
      ),
      (
        deps: pubspec.dependencyOverrides,
        type: DepKind.override,
        yaml: yaml['dependency_overrides'] as YamlMap?,
      ),
    ]) {
      for (var e in x.deps.entries) {
        var span =
            x.yaml?.nodes[e.key]?.span ??
            (throw StateError('Missing span for dependency ${e.key}'));
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
          (HostedDependency dep) => Dep<HostedDependency>._(
            name,
            dep,
            kind,
            span,
          ),
          (PathDependency dep) => Dep<PathDependency>._(name, dep, kind, span),
          (GitDependency dep) => Dep<GitDependency>._(name, dep, kind, span),
          (SdkDependency dep) => Dep<SdkDependency>._(name, dep, kind, span),
          // Prior to pubspec_parse 1.4.0 the Dependency class was not sealed.
          // ignore: unreachable_switch_case
          _ => throw StateError('Unknown dependency type: $dependency'),
        }
        as Dep<T>;
  }
}

// for convenience
typedef HostedDep = Dep<HostedDependency>;
typedef PathDep = Dep<PathDependency>;
typedef GitDep = Dep<GitDependency>;
typedef SdkDep = Dep<SdkDependency>;
