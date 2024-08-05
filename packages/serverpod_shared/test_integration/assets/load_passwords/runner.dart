import 'dart:io';
import 'package:serverpod_shared/serverpod_shared.dart';

void main() {
  var passwords = PasswordManager(runMode: 'development').loadPasswords();

  stdout.write(passwords.toString());
}
