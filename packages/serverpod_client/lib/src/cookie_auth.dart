part of 'serverpod_client_shared.dart';

/// The cookie-auth capability of a [ServerpodClientRequestDelegate].
///
/// Only mixed in by transports that can carry an `HttpOnly` auth cookie, which
/// today means the browser delegate; the dart:io transport has no cookie jar
/// and does not implement it. Client code tests for the capability with `is`
/// rather than the base delegate carrying web-only members.
mixin CookieAuthTransport on ServerpodClientRequestDelegate {
  /// Whether this transport instance can carry an `HttpOnly` auth cookie.
  /// A cookie-capable transport can still refuse at runtime, e.g. when a
  /// custom http client cannot be switched to credentialed requests.
  bool get supportsCookieAuth;

  /// Whether requests should use browser-managed cookie auth transport.
  bool cookieAuth = false;

  /// The browser-visible base path of the server, declared to the server on
  /// cookie-auth requests (via [webBasePathHeaderName]) so it can scope the
  /// refresh cookie `Path` correctly behind a prefix-stripping reverse proxy.
  /// Derived from the client's host; `/` when the server is at the root.
  String cookieAuthBasePath = '/';

  /// The name of the lock serializing authentication refreshes, declared by
  /// the client from its host. Carries no secrets.
  String authRefreshCrossTabLockName = 'serverpod-auth-refresh';

  /// A lock serializing authentication refreshes against this server across
  /// browser tabs, or null when the platform has no cross-tab coordination.
  CrossTabLock? get authRefreshCrossTabLock;

  /// The cookie-auth request headers for a call with the given [authenticated]
  /// intent: the [webAuthModeHeaderName] marker and the declared base path,
  /// or empty when [cookieAuth] is disabled.
  Map<String, String> webAuthHeaders({required bool authenticated}) => {
    if (cookieAuth)
      webAuthModeHeaderName: authenticated
          ? webAuthModeCookie
          : webAuthModeCookieTransport,
    if (cookieAuth) webBasePathHeaderName: cookieAuthBasePath,
  };
}

/// Browser-managed cookie auth transport for a [ServerpodClientShared].
///
/// Cookie auth is only supported by browser clients, so it is offered as an
/// extension rather than as part of the client's base interface.
extension ServerpodClientCookieAuth on ServerpodClientShared {
  /// Whether the client should use browser-managed cookie auth transport.
  ///
  /// Set this immediately after constructing the client, before making any
  /// calls. Cookie auth is only supported by browser clients.
  bool get cookieAuth {
    var delegate = _requestDelegate;
    return delegate is CookieAuthTransport && delegate.cookieAuth;
  }

  set cookieAuth(bool value) {
    var delegate = _requestDelegate;
    if (value &&
        (delegate is! CookieAuthTransport || !delegate.supportsCookieAuth)) {
      throw UnsupportedError(
        'Cookie-based web auth is only supported by browser clients. '
        'The dart:io client cannot store or resend HttpOnly cookies, and a '
        'custom httpClientOverride must be a BrowserClient so credentialed '
        'requests can be enabled on it. '
        'Set cookieAuth only on web clients, immediately after constructing '
        'the client and before making any calls.',
      );
    }
    if (delegate is CookieAuthTransport) delegate.cookieAuth = value;
  }

  /// A lock serializing authentication refreshes against this server across
  /// browser tabs, or null when the platform has no cross-tab coordination.
  /// The lock name is derived from the host origin and base path and carries
  /// no secrets.
  CrossTabLock? get authRefreshCrossTabLock {
    var delegate = _requestDelegate;
    return delegate is CookieAuthTransport
        ? delegate.authRefreshCrossTabLock
        : null;
  }
}

/// The path component of [host] without a trailing slash (`/` at the root),
/// i.e. the browser-visible base path under which the server's endpoints live.
String _basePathOf(String host) {
  var path = Uri.parse(host).path.replaceFirst(RegExp(r'/+$'), '');
  return path.isEmpty ? '/' : path;
}
