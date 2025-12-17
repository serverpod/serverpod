import 'dart:collection';
import 'dart:io';

import 'package:yaml/yaml.dart';

import '../util/pubspec_plus.dart';
import 'script.dart';

export 'script.dart' show ScriptParseException, UnsupportedPlatformException;

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
        throw ScriptParseException('Invalid node', node.span);
      }
    }
    return node;
  }
}

/// A collection of scripts parsed from the `serverpod/scripts` section
/// of pubspec.yaml.
class Scripts extends UnmodifiableMapBase<String, Script> {
  final Map<String, Script> _scripts;

  const Scripts._(this._scripts);

  /// Creates a [Scripts] instance from a YAML map.
  ///
  /// The [scriptsNode] parameter should be the value of the `serverpod/scripts`
  /// node from pubspec.yaml.
  ///
  /// Throws [ScriptParseException] if the YAML structure is invalid.
  factory Scripts._fromYaml(YamlMap scriptsNode) {
    final scripts = <String, Script>{};

    for (final entry in scriptsNode.nodes.entries) {
      final keyNode = entry.key as YamlNode;
      final valueNode = entry.value;
      final name = keyNode.value;

      if (name is! String) {
        throw ScriptParseException(
          'Script name must be a string, got ${name.runtimeType}',
          keyNode.span,
        );
      }

      scripts[name] = Script.fromYaml(name: name, valueNode: valueNode);
    }

    return Scripts._(scripts);
  }

  /// Loads scripts from a pubspec.yaml file using [PubspecPlus] for better
  /// error messages with source spans.
  ///
  /// Returns an empty [Scripts] if the file doesn't exist or doesn't contain
  /// a `serverpod/scripts` section.
  ///
  /// Throws [ScriptParseException] if the scripts section is malformed.
  factory Scripts.fromPubspecFile(File pubspecFile) =>
      Scripts.fromPubspec(PubspecPlus.fromFile(pubspecFile));

  /// Loads scripts from [pubspecPlus]
  ///
  /// Returns an empty [Scripts] if the file doesn't exist or doesn't contain
  /// a `serverpod/scripts` section.
  ///
  /// Throws [ScriptParseException] if the scripts section is malformed.
  factory Scripts.fromPubspec(PubspecPlus pubspecPlus) {
    final scriptsNode = pubspecPlus.yaml.findNode(_scriptsPath);

    if (scriptsNode == null) {
      return const Scripts._({});
    }

    if (scriptsNode is! YamlMap) {
      throw ScriptParseException(
        '$_scriptsPath must be a map of script names to commands',
        scriptsNode.span,
      );
    }

    return Scripts._fromYaml(scriptsNode);
  }

  @override
  Script? operator [](Object? key) => _scripts[key];

  @override
  Iterable<String> get keys => _scripts.keys;
}
