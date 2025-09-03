// Export utilities to create authentication headers.
export 'package:serverpod_serialization/src/auth_encoding.dart'
    show wrapAsBasicAuthHeaderValue, wrapAsBearerAuthHeaderValue;

/// Provides the authentication key for the client.
abstract interface class ClientAuthKeyProvider {
  /// A valid authentication header value. Should be used for all requests.
  Future<String?> get authHeaderValue;
}

/// Provides the authentication key for the client, with a method to refresh it.
abstract class RefresherClientAuthKeyProvider implements ClientAuthKeyProvider {
  /// Authentication header value getter that must be implemented. This getter
  /// must get the header value directly from the source, without any locking.
  /// The [authHeaderValue] getter will handle refreshing the key if needed,
  /// with a lock to avoid concurrent refresh attempts.
  Future<String?> get notLockedAuthHeaderValue;

  @override
  Future<String?> get authHeaderValue async {
    // TODO: In the beginning of the getter, check validity and refresh if it is
    // about to expire. Either way, before refreshing, check again if it's still
    // about to expire to avoid racing conditions when multiple endpoints try to
    // refresh and one has already refreshed. Then skip refresh and return true.

    // TODO: Use Completer to implement a lock under the future of the getter to
    // avoid multiple concurrent refresh attempts.
    return await notLockedAuthHeaderValue;
  }

  /// Refreshes the authentication key. If the refresh is successful, should
  /// return true to retry requests that failed due to authentication errors.
  /// Be aware that the refresh endpoint must be annotated with @unauthenticated
  /// to avoid a deadlock on the [authHeaderValue] getter on refresh call.
  Future<bool> refreshAuthKey();
}
