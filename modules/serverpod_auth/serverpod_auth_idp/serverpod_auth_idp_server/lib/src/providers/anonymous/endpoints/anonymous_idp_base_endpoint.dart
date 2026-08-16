import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';

import '../business/anonymous_idp.dart';

/// Base endpoint for anonymous accounts.
abstract class AnonymousIdpBaseEndpoint extends Endpoint {
  /// Accessor for the configured Anonymous Idp instance.
  /// By default this uses the global instance configured in
  /// [AuthServices].
  ///
  /// If you want to use a different instance, override this getter.
  AnonymousIdp get anonymousIdp => AuthServices.instance.anonymousIdp;

  /// {@template anonymous_account_base_endpoint.login}
  /// Creates a new anonymous account and returns its session.
  ///
  /// Invokes the [AnonymousIdp.beforeAnonymousAccount] callback if configured,
  /// which may prevent account creation if the endpoint is protected.
  /// {@endtemplate}
  Future<AuthSuccess> login(
    final Session session, {
    final String? token,
  }) async {
    return anonymousIdp.login(session, token: token);
  }
}
