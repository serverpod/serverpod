import 'package:serverpod/serverpod.dart';

/// Base class for identity providers.
abstract class Idp {
  /// Returns identifying name for this identity provider. This should be the
  /// same value as the static `method` property on the class.
  String getMethod();

  /// Returns true if the user has an account with this identity provider.
  Future<bool> hasAccount(final Session session);
}
