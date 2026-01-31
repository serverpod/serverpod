import 'dart:collection';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:yaml/yaml.dart';

/// Exception thrown when there's an error parsing a script from YAML.
class ScriptParseException extends YamlException {
  ScriptParseException(super.message, [super.span]);
}

@Deprecated('Use ScriptParseException instead')
typedef ScriptsParseException = ScriptParseException;

/// Exception thrown when a script does not support the current platform.
class UnsupportedPlatformException implements Exception {
  final String scriptName;
  final String platform;

  UnsupportedPlatformException(this.scriptName, this.platform);

  @override
  String toString() => 'Script "$scriptName" is not available on $platform';
}

/// Represents a script defined in the `serverpod/scripts` section of
/// pubspec.yaml.
///
/// Scripts can be defined as either a simple string command or with
/// platform-specific commands:
///
/// ```yaml
/// serverpod:
///   scripts:
///     simple: echo hello
///     platform_specific:
///       windows: echo hello from windows
///       posix: echo hello from posix
/// ```
class Script {
  /// The name of the script (the key in the YAML map).
  final String name;

  /// The commands to execute per platform group
  final Map<PlatformGroup, String> commands;

  const Script._(
    this.name,
    this.commands,
  );

  Script({required String name, required String command})
    : this._(name, ConstantMap(keys: PlatformGroup.values, value: command));

  Script.platformSpecific({
    required String name,
    String? windowsCommand,
    String? posixCommand,
  }) : this._(name, {
         PlatformGroup.windows: ?windowsCommand,
         PlatformGroup.posix: ?posixCommand,
       });

  /// Creates a [Script] from a YAML node.
  ///
  /// The [name] is the script name (key in the YAML map).
  /// The [valueNode] is the value node which can be either:
  /// - A string (simple command for all platforms)
  /// - A map with `windows` and/or `posix` keys (platform-specific commands)
  ///
  /// Throws [ScriptParseException] if the YAML structure is invalid.
  factory Script.fromYaml({
    required String name,
    required YamlNode valueNode,
  }) {
    final value = valueNode.value;

    if (value is String) {
      return Script(name: name, command: value);
    }

    if (value is YamlMap) {
      return Script._fromPlatformMap(name: name, mapNode: valueNode as YamlMap);
    }

    throw ScriptParseException(
      'Script "$name" must be a string command or a map with '
      '"windows" and/or "posix" keys, got ${value.runtimeType}',
      valueNode.span,
    );
  }

  factory Script._fromPlatformMap({
    required String name,
    required YamlMap mapNode,
  }) {
    final commands = <PlatformGroup, String>{};
    for (final entry in mapNode.nodes.entries) {
      final keyNode = entry.key as YamlNode;
      final key = keyNode.value;
      final commandNode = entry.value;
      final command = commandNode.value;

      if (key is! String) {
        throw ScriptParseException(
          'Platform key must be a string, got ${key.runtimeType}',
          keyNode.span,
        );
      }

      if (command is! String) {
        throw ScriptParseException(
          'Command for platform "$key" must be a string, '
          'got ${command.runtimeType}',
          commandNode.span,
        );
      }

      final platform = PlatformGroup.tryParse(key);
      if (platform == null) {
        throw ScriptParseException(
          'Unknown platform "$key". Valid platforms are: ${PlatformGroup.values._format()}',
          keyNode.span,
        );
      }

      commands[platform] = command;
    }

    if (commands.isEmpty) {
      throw ScriptParseException(
        'Script "$name" must specify at least one platform command '
        '(${PlatformGroup.values._format()})',
        mapNode.span,
      );
    }

    return Script._(name, commands);
  }

  /// Returns the command for the current platform.
  ///
  /// Throws [UnsupportedPlatformException] if no command is defined for the
  /// current platform.
  String get command =>
      commands[PlatformGroup.current] ??
      (throw UnsupportedPlatformException(name, PlatformGroup.current.name));

  /// Returns true if this script has a command for the current platform.
  bool get supportsCurrentPlatform => commands[PlatformGroup.current] != null;

  @override
  String toString() {
    final commandsString = switch (commands) {
      ConstantMap cm => 'command: ${cm.value}',
      _ => commands._format(),
    };
    return 'Script(name: $name, $commandsString)';
  }

  static const _mapEquality = MapEquality<PlatformGroup, String>();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Script &&
          name == other.name &&
          _mapEquality.equals(commands, other.commands);

  @override
  int get hashCode => Object.hash(name, _mapEquality.hash(commands));
}

enum PlatformGroup {
  windows,
  posix;

  static PlatformGroup get current {
    if (Platform.isWindows) return PlatformGroup.windows;
    if (Platform.isLinux || Platform.isMacOS) return PlatformGroup.posix;
    throw UnsupportedError(Platform.operatingSystem);
  }

  static final _nameMap = PlatformGroup.values.asNameMap();
  static PlatformGroup? tryParse(String s) => _nameMap[s];

  @override
  String toString() => name;
}

extension<T> on Iterable<T> {
  String _format() {
    return switch (length) {
      0 => '',
      1 => first.toString(),
      2 => '$first or $last',
      _ => '${take(length - 1).join(', ')}, or $last', // Oxford comma
    };
  }
}

extension<K, V> on Map<K, V> {
  String _format() => entries.map((e) => '${e.key}: ${e.value}').join(', ');
}

class ConstantMap<K extends Enum, V> extends UnmodifiableMapBase<K, V> {
  final V value;

  const ConstantMap({required this.value, required this.keys});

  @override
  final Iterable<K> keys;

  @override
  V operator [](covariant K? _) => value;
}
