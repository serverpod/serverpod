import 'dart:io';

import 'package:yaml/yaml.dart';

/// Exception thrown when there's an error parsing a script from YAML.
class ScriptParseException extends YamlException {
  ScriptParseException(super.message, [super.span]);
}

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

  /// The command to execute on Windows, or null if not specified.
  final String? windowsCommand;

  /// The command to execute on POSIX systems (macOS, Linux), or null if not
  /// specified.
  final String? posixCommand;

  const Script({
    required this.name,
    required String command,
  }) : windowsCommand = command,
       posixCommand = command;

  const Script.platformSpecific({
    required this.name,
    this.windowsCommand,
    this.posixCommand,
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
    String? windowsCommand;
    String? posixCommand;

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

      switch (key) {
        case 'windows':
          windowsCommand = command;
        case 'posix':
          posixCommand = command;
        default:
          throw ScriptParseException(
            'Unknown platform "$key". Valid platforms are: windows, posix',
            keyNode.span,
          );
      }
    }

    if (windowsCommand == null && posixCommand == null) {
      throw ScriptParseException(
        'Script "$name" must specify at least one platform command '
        '(windows or posix)',
        mapNode.span,
      );
    }

    return Script.platformSpecific(
      name: name,
      windowsCommand: windowsCommand,
      posixCommand: posixCommand,
    );
  }

  /// Returns the command for the current platform.
  ///
  /// Throws [UnsupportedPlatformException] if no command is defined for the
  /// current platform.
  String get command {
    final cmd = Platform.isWindows ? windowsCommand : posixCommand;
    if (cmd == null) {
      final platform = Platform.isWindows ? 'Windows' : 'POSIX';
      throw UnsupportedPlatformException(name, platform);
    }
    return cmd;
  }

  /// Returns true if this script has a command for the current platform.
  bool get supportsCurrentPlatform =>
      Platform.isWindows ? windowsCommand != null : posixCommand != null;

  @override
  String toString() {
    if (windowsCommand == posixCommand) {
      return 'Script(name: $name, command: $windowsCommand)';
    }
    return 'Script(name: $name, windows: $windowsCommand, posix: $posixCommand)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Script &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          windowsCommand == other.windowsCommand &&
          posixCommand == other.posixCommand;

  @override
  int get hashCode => Object.hash(name, windowsCommand, posixCommand);
}
