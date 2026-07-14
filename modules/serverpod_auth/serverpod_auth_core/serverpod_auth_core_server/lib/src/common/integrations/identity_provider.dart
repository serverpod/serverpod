import 'package:serverpod/serverpod.dart';

/// Contract implemented by all identity providers.
abstract class IdentityProvider {
  /// The stable method identifier used when issuing authentication tokens.
  ///
  /// This value must be unique among registered identity providers and must not
  /// change after tokens have been issued with it.
  String get method;

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
