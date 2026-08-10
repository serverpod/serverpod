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

    /// Returns the lock serializing refreshes across browser tabs. Required
    /// in cookie mode, where concurrent tab refreshes of the shared refresh
    /// cookie would trip the server's reuse revocation.
    CrossTabLock? Function()? getCrossTabRefreshLock,

    /// Optional function to invalidate the cached authentication info before
    /// refreshing the token.
    Future<void> Function()? invalidateCachedAuthInfo,

    /// Tolerance to add to the token expiration time before refreshing.
    Duration refreshJwtTokenBefore = const Duration(seconds: 30),
  }) : super(
         _JwtAuthKeyProviderDelegate(
           usesCookieAuth: usesCookieAuth ?? () => false,
           headerDelegate: _HeaderJwtRefreshDelegate(
             getAuthInfo: getAuthInfo,
             onRefreshAuthInfo: onRefreshAuthInfo,
             refreshEndpoint: refreshEndpoint,
             refreshJwtTokenBefore: refreshJwtTokenBefore,
             invalidateCachedAuthInfo: invalidateCachedAuthInfo,
           ),
           cookieDelegate: _CookieJwtRefreshDelegate(
             getAuthInfo: getAuthInfo,
             onRefreshAuthInfo: onRefreshAuthInfo,
             refreshEndpoint: refreshEndpoint,
             refreshJwtTokenBefore: refreshJwtTokenBefore,
             getCrossTabRefreshLock: getCrossTabRefreshLock ?? () => null,
           ),
         ),
       );
}

/// Dispatches to the header or cookie delegate. The mode is re-read per call
/// because the provider instance is cached across sign-ins by the session
/// manager, while both delegates live for the provider's lifetime so the
/// cookie delegate's latch state survives between calls.
class _JwtAuthKeyProviderDelegate implements RefresherClientAuthKeyProvider {
  final bool Function() usesCookieAuth;
  final _HeaderJwtRefreshDelegate headerDelegate;
  final _CookieJwtRefreshDelegate cookieDelegate;

  _JwtAuthKeyProviderDelegate({
    required this.usesCookieAuth,
    required this.headerDelegate,
    required this.cookieDelegate,
  });

  _JwtRefreshDelegate get _current =>
      usesCookieAuth() ? cookieDelegate : headerDelegate;

  @override
  Future<String?> get authHeaderValue => _current.authHeaderValue;

  @override
  Future<RefreshAuthKeyResult> refreshAuthKey({bool force = false}) =>
      _current.refreshAuthKey(force: force);
}

abstract class _JwtRefreshDelegate implements RefresherClientAuthKeyProvider {
  final Future<AuthSuccess?> Function() getAuthInfo;
  final Future<void> Function(AuthSuccess authSuccess) onRefreshAuthInfo;
  final EndpointRefreshJwtTokens refreshEndpoint;
  final Duration refreshJwtTokenBefore;

  _JwtRefreshDelegate({
    required this.getAuthInfo,
    required this.onRefreshAuthInfo,
    required this.refreshEndpoint,
    required this.refreshJwtTokenBefore,
  });

  @override
  Future<String?> get authHeaderValue async {
    final currentAuth = await getAuthInfo();
    if (currentAuth == null) return null;
    if (currentAuth.token.isEmpty) return null;
    return wrapAsBearerAuthHeaderValue(currentAuth.token);
  }

  Future<RefreshAuthKeyResult> _refresh({required String? refreshToken}) async {
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

class _HeaderJwtRefreshDelegate extends _JwtRefreshDelegate {
  final Future<void> Function()? invalidateCachedAuthInfo;

  _HeaderJwtRefreshDelegate({
    required super.getAuthInfo,
    required super.onRefreshAuthInfo,
    required super.refreshEndpoint,
    required super.refreshJwtTokenBefore,
    required this.invalidateCachedAuthInfo,
  });

  /// Only performs a refresh if the token has a valid expiration time and is
  /// about to expire within the configured tolerance. Otherwise, returns skipped.
  @override
  Future<RefreshAuthKeyResult> refreshAuthKey({bool force = false}) async {
    await invalidateCachedAuthInfo?.call();
    final currentAuthInfo = await getAuthInfo();
    final currentExpiresAt = currentAuthInfo?.tokenExpiresAt;
    final refreshToken = currentAuthInfo?.refreshToken;

    if ((!force &&
            currentExpiresAt?.isExpiring(refreshJwtTokenBefore) != true) ||
        refreshToken == null) {
      return RefreshAuthKeyResult.skipped;
    }
    return _refresh(refreshToken: refreshToken);
  }
}

class _CookieJwtRefreshDelegate extends _JwtRefreshDelegate {
  final CrossTabLock? Function() getCrossTabRefreshLock;

  bool _refreshUnauthorized = false;
  AuthSuccess? _unauthorizedAuthInfo;

  _CookieJwtRefreshDelegate({
    required super.getAuthInfo,
    required super.onRefreshAuthInfo,
    required super.refreshEndpoint,
    required super.refreshJwtTokenBefore,
    required this.getCrossTabRefreshLock,
  });

  @override
  Future<RefreshAuthKeyResult> refreshAuthKey({bool force = false}) async {
    // The persisted copy is token-blanked and the browser jar holds the
    // (shared) refresh cookie, so unlike header mode there is no cached auth
    // info to invalidate; reloading from storage would only discard the
    // in-memory access token and force a needless rotation.
    final currentAuthInfo = await getAuthInfo();
    final currentToken = currentAuthInfo?.token;
    final shouldRefresh =
        force ||
        currentToken == null ||
        currentToken.isEmpty ||
        currentAuthInfo?.tokenExpiresAt?.isExpiring(refreshJwtTokenBefore) ==
            true;
    if (!shouldRefresh) return RefreshAuthKeyResult.skipped;

    // A rejected refresh cookie stays rejected until the auth state
    // changes (a sign-in or successful refresh replaces the auth info
    // instance), so repeat the failure without a server round-trip per
    // call. A forced refresh and transient failures are not suppressed.
    if (!force &&
        _refreshUnauthorized &&
        identical(currentAuthInfo, _unauthorizedAuthInfo)) {
      return RefreshAuthKeyResult.failedUnauthorized;
    }

    // The refresh cookie is shared between tabs and its secret is
    // single-use, so an uncoordinated concurrent refresh from another tab
    // would be treated as credential reuse and revoke the session.
    final crossTabLock = getCrossTabRefreshLock();
    if (crossTabLock == null) {
      throw StateError(
        'Cookie-based JWT auth requires cross-tab refresh coordination, '
        'but the platform does not support it (the browser is missing the '
        'Web Locks API).',
      );
    }
    final result = await crossTabLock.synchronize(
      () => _refresh(refreshToken: null),
    );
    if (result == RefreshAuthKeyResult.failedUnauthorized) {
      _refreshUnauthorized = true;
      _unauthorizedAuthInfo = currentAuthInfo;
    } else if (result == RefreshAuthKeyResult.success) {
      _refreshUnauthorized = false;
      _unauthorizedAuthInfo = null;
    }
    return result;
  }
}

extension on DateTime {
  // Check if the token is about to expire, within the given before duration.
  bool isExpiring(Duration before) =>
      clock.now().toUtc().add(before).isAfter(this);
}
