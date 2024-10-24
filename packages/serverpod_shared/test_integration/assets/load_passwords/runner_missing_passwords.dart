import 'dart:io';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:uuid/uuid.dart';

void main() {
  var missingFileName = const Uuid().v4();

  var passwords = PasswordManager(runMode: 'development').loadPasswords(
    './config/$missingFileName.yaml',
  );

  stdout.write(passwords.toString());
}
