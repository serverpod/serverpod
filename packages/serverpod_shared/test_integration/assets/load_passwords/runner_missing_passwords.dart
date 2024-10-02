import 'dart:io';
import 'package:serverpod_shared/serverpod_shared.dart';

void main() {
  var passwords = PasswordManager(runMode: 'development').loadPasswords(
    './config/missing_passwords.yaml',
  );

  stdout.write(passwords.toString());
}
