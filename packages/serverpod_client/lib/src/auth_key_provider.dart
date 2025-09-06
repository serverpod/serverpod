// Export utilities to create authentication headers.
export 'package:serverpod_serialization/src/auth_encoding.dart'
    show wrapAsBasicAuthHeaderValue, wrapAsBearerAuthHeaderValue;

/// Provides the authentication key for the client.
abstract interface class ClientAuthKeyProvider {
  /// A valid authentication header value. Should be used for all requests.
  Future<String?> get authHeaderValue;
}

/// Provides the authentication key for the client, with a method to refresh it.
abstract interface class RefresherClientAuthKeyProvider
    implements ClientAuthKeyProvider {
  /// Refreshes the authentication key and returns the result of the operation.
  /// If the refresh is successful, should return [RefreshAuthKeyResult.success]
  /// to retry requests that failed due to authentication errors. Be sure to
  /// annotate the refresh endpoint with @unauthenticatedClientCall to avoid a
  /// deadlock on the [authHeaderValue] getter on a refresh call.
  Future<RefreshAuthKeyResult> refreshAuthKey();
}

/// Represents the result of an authentication key refresh operation.
enum RefreshAuthKeyResult {
  /// Refresh was skipped because the key is not expiring.
  skipped,

  /// Refresh was successful and a new key was obtained.
  success,

  /// Refresh failed due to invalid refresh credentials (such as expired token).
  failedUnauthorized,

  /// Refresh failed due to other reasons (network, server error, etc.).
  failedOther,
}

/// A [RefresherClientAuthKeyProvider] decorator that adds a mutex lock to
/// prevent concurrent refresh calls. Actual auth header getter and refresh
/// logic is delegated to the [_delegate] provider.
class MutexRefresherClientAuthKeyProvider
    implements RefresherClientAuthKeyProvider {
  final RefresherClientAuthKeyProvider _delegate;

  /// Creates a new [MutexRefresherClientAuthKeyProvider].
  MutexRefresherClientAuthKeyProvider(this._delegate);

  /// Shared future that serves as a lock to prevent concurrent refresh calls.
  Future<RefreshAuthKeyResult>? _pendingRefresh;

  @override
  Future<String?> get authHeaderValue async {
    await refreshAuthKey();
    return _delegate.authHeaderValue;
  }

  /// Refreshes the authentication key with locking to prevent concurrent calls.
  @override
  Future<RefreshAuthKeyResult> refreshAuthKey() async {
    final pendingRefresh = _pendingRefresh;
    if (pendingRefresh != null) return pendingRefresh;

    final refreshFuture = _refreshAuthKey();
    _pendingRefresh = refreshFuture;

    try {
      return await refreshFuture;
    } finally {
      if (identical(_pendingRefresh, refreshFuture)) {
        _pendingRefresh = null;
      }
    }
  }

  String? _lastAuthHeaderValue;
  RefreshAuthKeyResult? _lastRefreshResult;

  /// Actual refresh operation that is protected by the mutex lock. Will not
  /// perform a refresh if the last refresh failed due to invalid credentials
  /// and the auth header value has not changed. This prevents further request
  /// failures due to invalid credentials when refresh credential is already
  /// proven invalid.
  Future<RefreshAuthKeyResult> _refreshAuthKey() async {
    final currentAuthHeaderValue = await _delegate.authHeaderValue;
    if (_lastAuthHeaderValue != null &&
        _lastAuthHeaderValue == currentAuthHeaderValue &&
        _lastRefreshResult == RefreshAuthKeyResult.failedUnauthorized) {
      return RefreshAuthKeyResult.failedUnauthorized;
    }

    final result = await _delegate.refreshAuthKey();
    _lastAuthHeaderValue = await _delegate.authHeaderValue;
    _lastRefreshResult = result;
    return result;
  }
}
