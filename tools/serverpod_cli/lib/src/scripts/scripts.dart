import 'dart:collection';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import '../util/pubspec_plus.dart';
import '../util/server_directory_finder.dart';
import 'script.dart';

/// The key used in pubspec.yaml to define scripts.
const String _scriptsKey = 'serverpod_scripts';

/// Exception thrown when there's an error parsing scripts from pubspec.yaml.
class ScriptsParseException extends YamlException {
  ScriptsParseException(super.message, [super.span]);
}

/// A collection of scripts parsed from the `serverpod_scripts` section
/// of pubspec.yaml.
class Scripts extends UnmodifiableMapBase<String, Script> {
  final Map<String, Script> _scripts;

  Scripts._(this._scripts);

  /// Creates a [Scripts] instance from a YAML map.
  ///
  /// The [yaml] parameter should be the value of the `serverpod_scripts` key
  /// from pubspec.yaml, or null if not present.
  ///
  /// Throws [ScriptsParseException] if the YAML structure is invalid.
  factory Scripts.fromYaml(YamlMap? yaml) {
    if (yaml == null) {
      return Scripts._({});
    }

    final scripts = <String, Script>{};
    for (final entry in yaml.nodes.entries) {
      final keyNode = entry.key as YamlNode;
      final valueNode = entry.value;
      final name = keyNode.value;
      final value = valueNode.value;

      if (name is! String) {
        throw ScriptsParseException(
          'Script name must be a string, got ${name.runtimeType}',
          keyNode.span,
        );
      }

      if (value is! String) {
        throw ScriptsParseException(
          'Script "$name" must have a string command, got ${value.runtimeType}',
          valueNode.span,
        );
      }

      scripts[name] = Script(name: name, command: value);
    }

    return Scripts._(scripts);
  }

  /// Loads scripts from a pubspec.yaml file using [PubspecPlus] for better
  /// error messages with source spans.
  ///
  /// Returns an empty [Scripts] if the file doesn't exist or doesn't contain
  /// a `serverpod_scripts` section.
  ///
  /// Throws [ScriptsParseException] if the scripts section is malformed.
  factory Scripts.fromPubspecFile(File pubspecFile) {
    if (!pubspecFile.existsSync()) {
      return Scripts._({});
    }

    final pubspecPlus = PubspecPlus.fromFile(pubspecFile);
    return Scripts.fromPubspec(pubspecPlus);
  }

  /// Loads scripts from [pubspecPlus]
  ///
  /// Returns an empty [Scripts] if the file doesn't exist or doesn't contain
  /// a `serverpod_scripts` section.
  ///
  /// Throws [ScriptsParseException] if the scripts section is malformed.
  factory Scripts.fromPubspec(PubspecPlus pubspecPlus) {
    final scriptsYaml = pubspecPlus.yaml[_scriptsKey];

    if (scriptsYaml == null) {
      return Scripts._({});
    }

    if (scriptsYaml is! YamlMap) {
      final scriptsNode = pubspecPlus.yaml.nodes[_scriptsKey];
      throw ScriptsParseException(
        '$_scriptsKey must be a map of script names to commands',
        scriptsNode?.span,
      );
    }

    return Scripts.fromYaml(scriptsYaml);
  }

  /// Finds the pubspec.yaml file for the Serverpod server project.
  ///
  /// Uses [ServerDirectoryFinder] to locate the server directory,
  /// which handles walking up directories, sibling patterns, and
  /// repository boundary detection.
  ///
  /// Returns null if no server directory is found.
  static File? findPubspecFile(Directory directory) {
    final serverDir = ServerDirectoryFinder.search(directory);
    if (serverDir == null) return null;
    return File(p.join(serverDir.path, 'pubspec.yaml'));
  }

  @override
  Script? operator [](Object? key) => _scripts[key];

  @override
  Iterable<String> get keys => _scripts.keys;
}
