import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/serverpod_auth_bridge_server.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';

/// Endpoint for Google-based authentication, which automatically imports legacy
/// accounts.
class GoogleAccountBackwardsCompatibilityTestEndpoint
    extends GoogleIDPBaseEndpoint {
  @override
  Future<AuthSuccess> login(
    final Session session, {
    required final String idToken,
    required final String? accessToken,
  }) async {
    await AuthBackwardsCompatibility.importGoogleAccount(
      session,
      idToken: idToken,
      accessToken: accessToken,
    );

    return super.login(session, idToken: idToken, accessToken: accessToken);
  }
}
