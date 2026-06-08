import 'dart:io';
import 'package:serverpod_shared/serverpod_shared.dart';

void main() {
  // [missing] is a directory without a config/passwords.yaml file.
  var passwords = PasswordManager(runMode: 'development').loadPasswords(
    serverDir: 'missing',
  );

  stdout.write(passwords.toString());
}
