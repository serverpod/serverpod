import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_backwards_compatibility_server/serverpod_auth_backwards_compatibility_server.dart';
import 'package:serverpod_auth_email_server/serverpod_auth_email_server.dart';
import 'package:serverpod_auth_google_server/serverpod_auth_google_server.dart';

/// Endpoint for Google-based authentication, which automatically imports legacy
/// accounts.
class GoogleAccountBackwardsCompatibilityTestEndpoint
    extends GoogleAccountBaseEndpoint {
  @override
  Future<AuthSuccess> authenticate(
    final Session session, {
    required final String idToken,
  }) async {
    await AuthBackwardsCompatibility.importGoogleAccount(
      session,
      idToken: idToken,
    );

    return super.authenticate(session, idToken: idToken);
  }
}
