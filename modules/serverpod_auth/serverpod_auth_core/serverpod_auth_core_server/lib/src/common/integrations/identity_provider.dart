import 'package:serverpod/serverpod.dart';

/// Contract implemented by all identity providers.
abstract class IdentityProvider {
  /// Merges this provider's data from one auth user into another.
  ///
  /// Providers without data that needs to be retained during an account merge
  /// should implement this as an explicit no-op. Providers that cannot merge
  /// safely should throw, which causes the account merge transaction to roll
  /// back.
  Future<void> mergeAuthUsers(
    final Session session, {
    required final UuidValue userToKeepId,
    required final UuidValue userToRemoveId,
    required final Transaction transaction,
  });
}
