import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/src/common/business/idp.dart';

/// Idp-agnostic authentication endpoints to learn general information about a
/// given user account.
class IdpEndpoint extends Endpoint {
  /// Returns the `method` value for each connected [Idp] subclass if the
  /// current session is authenticated and if the user has an account connected
  /// to the [Idp].
  Future<Set<IdentityProvider>> idpAccounts(final Session session) async {
    if (session.authenticated == null) {
      return const <IdentityProvider>{};
    }

    final List<Future<IdentityProvider?>> hasAccountFutures = [];
    for (final provider in AuthServices.instance.identityProviders) {
      if (provider is! Idp) {
        session.log(
          'Cannot check accounts for provider $provider because it does '
          'not subclass Idp from pkg:serverpod_auth_idp_server',
        );
        continue;
      }

      // Add a future which, upon resolving to the existance of an account with
      // that Idp, results in the Idp's `method` value, or null if no account
      // exists.
      hasAccountFutures.add(
        () async {
          final nameMap = IdentityProvider.values.asNameMap();
          return await provider.hasAccount(session)
              ? nameMap[provider.getMethod()]
              : null;
        }(),
      );
    }

    final accountResults = await Future.wait(hasAccountFutures);
    return accountResults
        .where((final result) => result != null)
        .cast<IdentityProvider>()
        .toSet();
  }
}
