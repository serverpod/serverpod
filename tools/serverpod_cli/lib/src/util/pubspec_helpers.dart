import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

Pubspec parsePubspec(File pubspecFile) {
  try {
    var yamlContent = pubspecFile.readAsStringSync();
    var pubspec = Pubspec.parse(yamlContent);
    return pubspec;
  } catch (e) {
    throw Exception(
      'Error while parsing pubspec file: ${pubspecFile.path}: $e',
    );
  }
}

List<File> findPubspecsFiles(
  Directory dir, {
  List<String> ignorePaths = const [],
}) {
  var pubspecFiles = <File>[];
  for (var file in dir.listSync(recursive: true, followLinks: false)) {
    if (shouldBeIgnored(file.path, ignorePaths)) continue;

    if (file is File && p.basename(file.path) == 'pubspec.yaml') {
      pubspecFiles.add(file);
    }
  }

  return pubspecFiles;
}

bool shouldBeIgnored(String filePath, List<String> ignorePaths) {
  for (var ignorePath in ignorePaths) {
    // Add separator for file system to exclude partial matches.
    var ignorePathAsFolder = ignorePath + p.separator;

    if (filePath.contains(ignorePathAsFolder)) {
      return true;
    }
  }

  return false;
}

sealed class DependencySource {
  Object? get value;

  static DependencySourceVersion version(VersionConstraint version) =>
      DependencySourceVersion(version);
  static DependencySourcePath path(String path) => DependencySourcePath(path);
}

class DependencySourceVersion extends DependencySource {
  final VersionConstraint version;
  DependencySourceVersion(this.version);

  @override
  Object? get value => version.toString();
}

class DependencySourcePath extends DependencySource {
  final String path;
  DependencySourcePath(this.path);

  @override
  Object? get value => {'path': path};
}

enum DependencyType {
  normal('dependencies'),
  override('dependency_overrides');

  final String keyword;
  const DependencyType(this.keyword);
}

typedef DependencyUpdate = ({
  String name,
  DependencySource source,
  DependencyType type,
});

class _EmptyNode implements YamlNode {
  _EmptyNode();

  @override
  YamlNode? get value => null;

  @override
  SourceSpan get span => wrapAsYamlNode(null).span;
}

String addDependencyToPubspec(
  String pubspecContents, {
  required List<DependencyUpdate> additions,
}) {
  final editor = YamlEditor(pubspecContents);

  for (final (:name, :source, :type) in additions) {
    final currentKey = editor.parseAt(
      [type.keyword],
      orElse: () => _EmptyNode(),
    );

    if (currentKey is _EmptyNode) {
      editor.update([type.keyword], {name: source.value});
    } else {
      editor.update([type.keyword, name], source.value);
    }
  }

  return editor.toString();
}
