import 'dart:io';
import 'package:yaml/yaml.dart';

class PasswordManager {
  String passwordFile;
  String runMode;

  PasswordManager({
    required this.passwordFile,
    required this.runMode,
  });

  Map<String,String>? loadPasswords() {
    try {
      var passwords = <String, String>{};

      var passwordYaml = File('config/passwords.yaml').readAsStringSync();
      var data = (loadYaml(passwordYaml) as Map).cast<String, Map>();
      var sharedPasswords = data['shared']?.cast<String,String>();
      var runModePasswords = data[runMode]?.cast<String,String>();

      if (sharedPasswords != null)
        passwords.addAll(sharedPasswords);
      if (runModePasswords != null)
        passwords.addAll(runModePasswords);

      return passwords;
    }
    catch(e) {
      return null;
    }
  }
}