import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/src/common/business/idp.dart';

/// Idp-agnostic authentication endpoints to learn general information about a
/// given user account.
class IdpEndpoint extends Endpoint {
  /// Returns the `method` value for each connected [Idp] subclass if the
  /// current session is authenticated and if the user has an account connected
  /// to the [Idp].
  Future<Set<String>> idpAccounts(final Session session) async {
    if (session.authenticated == null) {
      return const <String>{};
    }

    final accounts = <String>{};
    final List<Future<String?>> hasAccountFutures = [];
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
          return await provider.hasAccount(session)
              ? provider.getMethod()
              : null;
        }(),
      );
    }

    final accountResults = await Future.wait(hasAccountFutures);
    for (final result in accountResults) {
      if (result != null) {
        accounts.add(result);
      }
    }

    return accounts;
  }
}
