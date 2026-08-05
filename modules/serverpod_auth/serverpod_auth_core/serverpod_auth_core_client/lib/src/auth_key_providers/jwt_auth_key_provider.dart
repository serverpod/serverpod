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

    /// Whether refresh credentials are carried in an HttpOnly cookie.
    /// Defaults to header mode (no cookie).
    bool Function()? usesCookieAuth,

    /// Optional function to invalidate the cached authentication info before
    /// refreshing the token.
    Future<void> Function()? invalidateCachedAuthInfo,

    /// Tolerance to add to the token expiration time before refreshing.
    Duration refreshJwtTokenBefore = const Duration(seconds: 30),
  }) : super(
         _JwtAuthKeyProviderDelegate(
           getAuthInfo: getAuthInfo,
           invalidateCachedAuthInfo: invalidateCachedAuthInfo,
           onRefreshAuthInfo: onRefreshAuthInfo,
           refreshEndpoint: refreshEndpoint,
           refreshJwtTokenBefore: refreshJwtTokenBefore,
           usesCookieAuth: usesCookieAuth ?? () => false,
         ),
       );
}

class _JwtAuthKeyProviderDelegate implements RefresherClientAuthKeyProvider {
  final Future<AuthSuccess?> Function() getAuthInfo;
  final Future<void> Function()? invalidateCachedAuthInfo;
  final Future<void> Function(AuthSuccess authSuccess) onRefreshAuthInfo;
  final EndpointRefreshJwtTokens refreshEndpoint;
  final Duration refreshJwtTokenBefore;
  final bool Function() usesCookieAuth;

  _JwtAuthKeyProviderDelegate({
    required this.getAuthInfo,
    required this.invalidateCachedAuthInfo,
    required this.onRefreshAuthInfo,
    required this.refreshEndpoint,
    required this.refreshJwtTokenBefore,
    required this.usesCookieAuth,
  });

  @override
  Future<String?> get authHeaderValue async {
    final currentAuth = await getAuthInfo();
    if (currentAuth == null) return null;
    if (currentAuth.token.isEmpty) return null;
    return wrapAsBearerAuthHeaderValue(currentAuth.token);
  }

  /// Only performs a refresh if the token has a valid expiration time and is
  /// about to expire within the configured tolerance. Otherwise, returns skipped.
  @override
  Future<RefreshAuthKeyResult> refreshAuthKey({bool force = false}) async {
    final cookieAuth = usesCookieAuth();
    // In cookie mode the persisted copy is token-blanked and the browser jar
    // holds the (shared) refresh cookie, so reloading from storage would only
    // discard the in-memory access token and force a needless rotation.
    if (!cookieAuth) await invalidateCachedAuthInfo?.call();
    final currentAuthInfo = await getAuthInfo();
    final currentExpiresAt = currentAuthInfo?.tokenExpiresAt;
    final refreshToken = currentAuthInfo?.refreshToken;

    if (cookieAuth) {
      final currentToken = currentAuthInfo?.token;
      final shouldRefresh =
          force ||
          currentToken == null ||
          currentToken.isEmpty ||
          currentExpiresAt?.isExpiring(refreshJwtTokenBefore) == true;
      if (!shouldRefresh) return RefreshAuthKeyResult.skipped;
    } else {
      if ((!force &&
              currentExpiresAt?.isExpiring(refreshJwtTokenBefore) != true) ||
          refreshToken == null) {
        return RefreshAuthKeyResult.skipped;
      }
    }

    try {
      final authSuccess = await refreshEndpoint.refreshAccessToken(
        refreshToken: cookieAuth ? null : refreshToken,
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
