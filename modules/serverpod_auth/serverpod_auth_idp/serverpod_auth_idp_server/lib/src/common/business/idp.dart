import 'package:serverpod/serverpod.dart';

/// Base class for identity providers.
abstract class Idp {
  /// The method used when authenticating with the identity provider.
  static String get method => throw UnimplementedError();

  /// Returns true if the user has an account with this identity provider.
  Future<bool> hasAccount(final Session session);
}
