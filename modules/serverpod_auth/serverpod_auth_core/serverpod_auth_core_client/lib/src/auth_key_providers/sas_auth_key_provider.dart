import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';

/// The [SasAuthKeyProvider] keeps track of and manages the signed-in state of
/// the user for SAS (Serverpod Auth Session) keys based authentication.
class SasAuthKeyProvider implements ClientAuthKeyProvider {
  /// The function to get the authentication info of the user.
  final Future<AuthSuccess?> Function() getAuthInfo;

  /// Creates a new [SasAuthKeyProvider].
  SasAuthKeyProvider({
    required this.getAuthInfo,
  });

  @override
  Future<String?> get authHeaderValue async {
    final currentAuth = await getAuthInfo();
    if (currentAuth == null) return null;
    return wrapAsBearerAuthHeaderValue(currentAuth.token);
  }
}
