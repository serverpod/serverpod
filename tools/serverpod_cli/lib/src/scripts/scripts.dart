import 'dart:collection';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import '../util/pubspec_plus.dart';
import '../util/server_directory_finder.dart';
import 'script.dart';

/// The key used in pubspec.yaml to define scripts.
const _scriptsPath = ['serverpod', 'scripts'];

extension on YamlMap {
  YamlNode? findNode(Iterable<Object?> path) {
    final self = this;
    YamlMap next = self;
    YamlNode? node;
    for (final segment in path) {
      node = next.nodes[segment];
      if (node is YamlMap) {
        next = node;
      } else if (node == null) {
        return null; // not found
      } else {
        throw ScriptsParseException('Invalid node', node.span);
      }
    }
    return node;
  }
}

/// Exception thrown when there's an error parsing scripts from pubspec.yaml.
class ScriptsParseException extends YamlException {
  ScriptsParseException(super.message, [super.span]);
}

/// A collection of scripts parsed from the `serverpod_scripts` section
/// of pubspec.yaml.
class Scripts extends UnmodifiableMapBase<String, Script> {
  final Map<String, Script> _scripts;

  const Scripts._(this._scripts);

  /// Creates a [Scripts] instance from a YAML map.
  ///
  /// The [yaml] parameter should be the value of the `serverpod/scripts` node
  /// from pubspec.yaml.
  ///
  /// Throws [ScriptsParseException] if the YAML structure is invalid.
  factory Scripts._fromYaml(YamlMap scriptsNode) {
    final scripts = <String, Script>{};

    for (final entry in scriptsNode.nodes.entries) {
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
  factory Scripts.fromPubspecFile(File pubspecFile) =>
      Scripts.fromPubspec(PubspecPlus.fromFile(pubspecFile));

  /// Loads scripts from [pubspecPlus]
  ///
  /// Returns an empty [Scripts] if the file doesn't exist or doesn't contain
  /// a `serverpod_scripts` section.
  ///
  /// Throws [ScriptsParseException] if the scripts section is malformed.
  factory Scripts.fromPubspec(PubspecPlus pubspecPlus) {
    final scriptsNode = pubspecPlus.yaml.findNode(_scriptsPath);

    if (scriptsNode == null) {
      return const Scripts._({});
    }

    if (scriptsNode is! YamlMap) {
      throw ScriptsParseException(
        '$_scriptsPath must be a map of script names to commands',
        scriptsNode.span,
      );
    }

    return Scripts._fromYaml(scriptsNode);
  }

  /// Finds the pubspec.yaml file for the Serverpod server project.
  ///
  /// Uses [ServerDirectoryFinder] to locate the server directory,
  /// which handles walking up directories, sibling patterns, and
  /// repository boundary detection.
  ///
  /// Returns null if no server directory is found.
  static Future<File?> findPubspecFile(
    Directory directory, {
    bool interactive = true,
  }) async {
    final serverDir = await ServerDirectoryFinder.findOrPrompt(
      startDir: directory,
      interactive: interactive,
    );
    final pubspecFile = File(p.join(serverDir.path, 'pubspec.yaml'));
    return pubspecFile.existsSync() ? pubspecFile : null;
  }

  @override
  Script? operator [](Object? key) => _scripts[key];

  @override
  Iterable<String> get keys => _scripts.keys;
}
