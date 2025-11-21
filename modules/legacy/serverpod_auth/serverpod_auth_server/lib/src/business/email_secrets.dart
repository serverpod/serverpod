import 'package:serverpod/serverpod.dart';

/// Secrets used for email authentication.
abstract class EmailSecrets {
  /// The salt used for hashing legacy passwords.
  static String get legacySalt =>
      Serverpod.instance.getPassword('email_password_salt') ??
      'serverpod password salt';

  /// The pepper used for hashing passwords.
  static String? get pepper =>
      Serverpod.instance.getPassword('emailPasswordPepper');
}
