import 'package:clock/clock.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';

/// The [JwtAuthKeyProvider] keeps track of and manages the signed-in state of
/// the user for JWT-based authentication.
class JwtAuthKeyProvider extends MutexRefresherClientAuthKeyProvider {
  /// Creates a new [JwtAuthKeyProvider].
  JwtAuthKeyProvider({
    /// The function to get the authentication info of the user.
    required Future<AuthSuccess?> Function() getAuthInfo,

    /// The callback to save the refreshed authentication info of the user.
    required Future<void> Function(AuthSuccess authSuccess) onRefreshAuthInfo,

    /// The endpoint to use for refreshing the token.
    required EndpointRefreshJwtTokens refreshEndpoint,

    /// Tolerance to add to the token expiration time before refreshing.
    Duration refreshJwtTokenBefore = const Duration(seconds: 30),
  }) : super(
         _JwtAuthKeyProviderDelegate(
           getAuthInfo: getAuthInfo,
           onRefreshAuthInfo: onRefreshAuthInfo,
           refreshEndpoint: refreshEndpoint,
           refreshJwtTokenBefore: refreshJwtTokenBefore,
         ),
       );
}

class _JwtAuthKeyProviderDelegate implements RefresherClientAuthKeyProvider {
  final Future<AuthSuccess?> Function() getAuthInfo;
  final Future<void> Function(AuthSuccess authSuccess) onRefreshAuthInfo;
  final EndpointRefreshJwtTokens refreshEndpoint;
  final Duration refreshJwtTokenBefore;

  _JwtAuthKeyProviderDelegate({
    required this.getAuthInfo,
    required this.onRefreshAuthInfo,
    required this.refreshEndpoint,
    required this.refreshJwtTokenBefore,
  });

  @override
  Future<String?> get authHeaderValue async {
    final currentAuth = await getAuthInfo();
    if (currentAuth == null) return null;
    return wrapAsBearerAuthHeaderValue(currentAuth.token);
  }

  /// Only performs a refresh if the token has a valid expiration time and is
  /// about to expire within the configured tolerance. Otherwise, returns skipped.
  @override
  Future<RefreshAuthKeyResult> refreshAuthKey({bool force = false}) async {
    final currentAuthInfo = await getAuthInfo();
    final currentExpiresAt = currentAuthInfo?.tokenExpiresAt;
    final refreshToken = currentAuthInfo?.refreshToken;

    if (!force && currentExpiresAt?.isExpiring(refreshJwtTokenBefore) != true ||
        refreshToken == null) {
      return RefreshAuthKeyResult.skipped;
    }

    try {
      final authSuccess = await refreshEndpoint.refreshAccessToken(
        refreshToken: refreshToken,
      );
      await onRefreshAuthInfo(authSuccess);
      return RefreshAuthKeyResult.success;
    } catch (e) {
      if (e is RefreshTokenMalformedException ||
          e is RefreshTokenNotFoundException ||
          e is RefreshTokenExpiredException ||
          e is RefreshTokenInvalidSecretException) {
        return RefreshAuthKeyResult.failedUnauthorized;
      }
      return RefreshAuthKeyResult.failedOther;
    }
  }
}

extension on DateTime {
  // Check if the token is about to expire, within the given before duration.
  bool isExpiring(Duration before) =>
      clock.now().toUtc().add(before).isAfter(this);
}
