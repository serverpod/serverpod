import 'package:serverpod/serverpod.dart';

/// Secrets used for phone authentication.
abstract class PhoneSecrets {
  /// The salt used for hashing legacy passwords.
  static String get legacySalt =>
      Serverpod.instance.getPassword('phone_password_salt') ??
      'serverpod password salt';

  /// The pepper used for hashing passwords.
  static String? get pepper =>
      Serverpod.instance.getPassword('phonePasswordPepper');
}
