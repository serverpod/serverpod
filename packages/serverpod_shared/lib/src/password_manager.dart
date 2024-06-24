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

  /// Load all passwords for the current run mode from the supplied [Map],
  /// or null if passwords fail to load.
  Map<String, String> loadPasswordsFromMap(
    Map passwordConfig,
    Map<String, String> environment,
  ) {
    var sharedPasswords = _extractPasswords(passwordConfig, 'shared');
    var runModePasswords = _extractPasswords(passwordConfig, runMode);

    return {
      ...sharedPasswords,
      ...runModePasswords,
    };
  }

  Map<String, String> _extractPasswords(Map data, String key) {
    var extracted = data[key];
    if (extracted is! Map) return {};

    if (extracted.entries.any(
      (entry) => entry.value is! String || entry.key is! String,
    )) {
      return {};
    }

    return extracted.cast<String, String>();
  }

  /// Load all passwords for the current run mode, or null if passwords fail
  /// to load.
  Map<String, String>? loadPasswords() {
    try {
      var passwordYaml = File('config/passwords.yaml').readAsStringSync();
      var data = (loadYaml(passwordYaml) as Map).cast<String, Map>();

      return loadPasswordsFromMap(data, Platform.environment);
    } catch (e) {
      return null;
    }
  }
}
