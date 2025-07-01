import 'dart:io';
import 'package:serverpod_shared/src/environment_variables.dart';
import 'package:yaml/yaml.dart';

const _userDefinedPasswordPrefix = 'SERVERPOD_PASSWORD_';

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
  ///
  /// Passwords are be loaded in the following order:
  /// 1. Shared passwords from the config map
  /// 2. Run mode specific passwords from the config map
  /// 3. Serverpod password environment variables
  /// 4. Custom passwords from the SERVERPOD_PASSWORD_ prefix environment variable (e.g. SERVERPOD_PASSWORD_myApiKey=secret becomes a password with key 'myApiKey')
  Map<String, String> loadPasswordsFromMap(
    Map passwordConfig, {
    Map<String, String> environment = const {},
  }) {
    var sharedPasswords = _extractPasswords(passwordConfig, 'shared');
    var runModePasswords = _extractPasswords(passwordConfig, runMode);

    var envPasswords = ServerpodPassword.values.fold<Map<String, String>>(
      {},
      (collection, password) {
        var envPassword = environment[password.envVariable];
        if (envPassword is! String) return collection;

        return {...collection, password.configKey: envPassword};
      },
    );

    final userDefinedEnvPasswords =
        _findUserDefinedPasswordsFromEnv(environment);

    envPasswords.addAll(userDefinedEnvPasswords);

    return {
      ...sharedPasswords,
      ...runModePasswords,
      ...envPasswords,
    };
  }

  Map<String, String> _findUserDefinedPasswordsFromEnv(
    Map<String, String> environment,
  ) {
    final userDefinedEnvPasswords = environment.entries.where(
      (entry) {
        if (!entry.key.startsWith(_userDefinedPasswordPrefix)) return false;
        return entry.key.length > _userDefinedPasswordPrefix.length;
      },
    ).map(
      (entry) => MapEntry(
        entry.key.substring(_userDefinedPasswordPrefix.length),
        entry.value,
      ),
    );

    return Map.fromEntries(userDefinedEnvPasswords);
  }

  Map<String, String> _extractPasswords(Map data, String key) {
    var extracted = data[key];
    if (extracted is! Map) return {};

    var invalidPasswordKeys = extracted.entries
        .where(
          (entry) => entry.key is! String || entry.value is! String,
        )
        .map((entry) => entry.key);

    if (invalidPasswordKeys.isNotEmpty) {
      throw StateError(
        'Invalid password entries in $key: ${invalidPasswordKeys.join(', ')}',
      );
    }

    return extracted.cast<String, String>();
  }

  /// Load all passwords for the current run mode, or null if passwords fail
  /// to load.
  Map<String, String> loadPasswords([
    String passwordsFilePath = 'config/passwords.yaml',
  ]) {
    Map<String, Map> data;
    try {
      var passwordYaml = File(passwordsFilePath).readAsStringSync();
      data = (loadYaml(passwordYaml) as Map).cast<String, Map>();
    } catch (e) {
      data = {};
    }

    return loadPasswordsFromMap(data, environment: Platform.environment);
  }

  /// Merge custom passwords with the existing password collection.
  /// Custom passwords are loaded from the environment variables.
  /// Throws an [ArgumentError] if the custom password configuration contains reserved keywords
  Map<String, String> mergePasswords(
    List<({String envName, String alias})> config,
    Map<String, String> passwords, {
    Map<String, String> environment = const {},
  }) {
    var containsReservedPasswords = ServerpodPassword.values.any(
      (password) => config.any(
        (entry) => (entry.envName == password.envVariable ||
            entry.alias == password.configKey),
      ),
    );

    if (containsReservedPasswords) {
      throw ArgumentError(
        'Custom password configuration contains Serverpod reserved passwords',
      );
    }

    return config.fold(
      passwords,
      (collection, entry) {
        var envPassword = environment[entry.envName];
        if (envPassword is! String) return collection;

        return {...collection, entry.alias: envPassword};
      },
    );
  }
}
