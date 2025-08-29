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
  /// Refreshes the authentication key. If the refresh is successful, should
  /// return true to retry requests that failed due to authentication errors.
  /// Be sure to annotate the refresh endpoint with @unauthenticatedClientCall
  /// to avoid a deadlock on the [authHeaderValue] getter on refresh call.
  Future<bool> refreshAuthKey();
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
  Future<bool>? _pendingRefresh;

  @override
  Future<String?> get authHeaderValue async {
    await refreshAuthKey();
    return _delegate.authHeaderValue;
  }

  /// Refreshes the authentication key with locking to prevent concurrent calls.
  @override
  Future<bool> refreshAuthKey() async {
    final pendingRefresh = _pendingRefresh;
    if (pendingRefresh != null) return pendingRefresh;

    final refreshFuture = _delegate.refreshAuthKey();
    _pendingRefresh = refreshFuture;

    try {
      return await refreshFuture;
    } finally {
      if (identical(_pendingRefresh, refreshFuture)) {
        _pendingRefresh = null;
      }
    }
  }
}
