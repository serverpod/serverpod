import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

import '../business/anonymous_idp.dart';

/// Base endpoint for anonymous authentication.
///
/// Subclass this in your own application to expose an endpoint for anonymous sign-in.
abstract class AnonymousIdpBaseEndpoint extends Endpoint {
  /// Accessor for the configured Anonymous Idp instance.
  /// By default this uses the global instance configured in
  /// [AuthServices].
  ///
  /// If you want to use a different instance, override this getter.
  AnonymousIdp get anonymousIdp => AuthServices.instance.anonymousIdp;

  /// Signs in a user anonymously and returns a new session.
  Future<AuthSuccess> signIn(final Session session) =>
      anonymousIdp.signIn(session);
}
