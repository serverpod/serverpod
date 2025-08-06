import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/serverpod_auth_bridge_server.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';

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
