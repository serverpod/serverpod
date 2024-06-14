import 'dart:io';
import 'package:yaml/yaml.dart';

/// Keeps track of passwords used by the server. Passwords are loaded from
/// the config/passwords.yaml file.
class PasswordManager {
  /// The run mode the passwords are loaded from.
  String runMode;

  /// Creates a new [PasswordManager] for the specified runMode. Typically,
  /// this is automatically created by the [Serverpod].
  PasswordManager({
    required this.runMode,
  });

  /// Load all passwords for the current run mode, or null if passwords fail
  /// to load.
  Map<String, String>? loadPasswords() {
    try {
      var passwords = <String, String>{};

      var passwordYaml = File('config/passwords.yaml').readAsStringSync();
      var data = (loadYaml(passwordYaml) as Map).cast<String, Map>();
      var sharedPasswords = data['shared']?.cast<String, String>();
      var runModePasswords = data[runMode]?.cast<String, String>();

      if (sharedPasswords != null) passwords.addAll(sharedPasswords);
      if (runModePasswords != null) passwords.addAll(runModePasswords);

      return passwords;
    } catch (e) {
      return null;
    }
  }
}
