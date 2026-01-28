import 'package:serverpod/serverpod.dart';

/// Base class for identity providers.
abstract class Idp {
  /// Returns true if the user has an account with this identity provider.
  Future<bool> hasAccount(final Session session);
}
