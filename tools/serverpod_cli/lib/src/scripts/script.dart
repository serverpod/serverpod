/// Represents a script defined in the `serverpod_scripts` section of
/// pubspec.yaml.
class Script {
  /// The name of the script (the key in the YAML map).
  final String name;

  /// The command to execute.
  final String command;

  const Script({
    required this.name,
    required this.command,
  });

  @override
  String toString() => 'Script(name: $name, command: $command)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Script &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          command == other.command;

  @override
  int get hashCode => name.hashCode ^ command.hashCode;
}
