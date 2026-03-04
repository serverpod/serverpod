import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../apple_idp_utils.dart';

sealed class _SignInWithAppleRoute extends Route {
  final AppleIdpUtils _utils;

  _SignInWithAppleRoute(this._utils, {super.methods});
}

/// {@template apple_idp.revokedNotificationRoute}
/// Route for handling revoking sessions based on server-to-server
/// notifications coming from Apple.
///
/// To be mounted as a `POST` handler under the URL configured in Apple's
/// developer portal, for example:
///
/// ```dart
///  pod.webServer.addRoute(
///    appleIdp.revokedNotificationRoute(),
///    '/hooks/apple-notification',
/// );
/// ```
///
/// If the notification is of type [AppleServerNotificationConsentRevoked] or
/// [AppleServerNotificationAccountDelete], all sessions based on the Apple
/// authentication for that account will be revoked.
/// {@endtemplate}
final class AppleRevokedNotificationRoute extends _SignInWithAppleRoute {
  /// Creates a new route to handle Apple Idp revoked notifications.
  AppleRevokedNotificationRoute({required final AppleIdpUtils utils})
    : super(utils, methods: {Method.post});

  @override
  Future<Result> handleCall(
    final Session session,
    final Request req,
  ) => _utils.serverNotificationHandler(session, req);
}

/// {@template apple_idp.webAuthenticationCallbackRoute}
/// Route for handling callbacks during authentication with [AppleIdp] on
/// foreign platforms such as Web, Android, etc, as opposed to iOS and macOS.
///
/// To be mounted as a `POST` handler under the URL configured in Apple's
/// developer portal, for example:
///
/// ```dart
///  pod.webServer.addRoute(
///    appleIdp.webAuthenticationCallbackRoute(),
///    '/auth/apple/callback',
/// );
/// ```
///
/// For Android clients, this route will redirect to the app using an Android
/// intent URI with the `signinwithapple` scheme. This requires the
/// `androidPackageIdentifier` to be configured in [AppleIdpConfig].
///
/// For Web clients, this route redirects to the configured `webRedirectUri`
/// while forwarding the callback parameters in the query string. This requires
/// `webRedirectUri` to be configured in [AppleIdpConfig].
/// {@endtemplate}
final class AppleWebAuthenticationCallbackRoute extends _SignInWithAppleRoute {
  final String? _androidPackageIdentifier;
  final String? _webRedirectUri;

  /// Route handling Apple Idp authentication callbacks for web and
  /// other foreign platforms (Android, etc.).
  ///
  /// The [androidPackageIdentifier] is the Android package identifier for the
  /// app, required for Apple Sign In to work on Android.
  ///
  /// The [webRedirectUri] is the browser URL to redirect to after receiving
  /// Apple's web callback, required for Apple Sign In to work on web when
  /// this server route is used as Apple's callback endpoint.
  AppleWebAuthenticationCallbackRoute({
    required final AppleIdpUtils utils,
    final String? androidPackageIdentifier,
    final String? webRedirectUri,
  }) : _androidPackageIdentifier = androidPackageIdentifier,
       _webRedirectUri = webRedirectUri,
       super(utils, methods: {Method.post});

  @override
  Future<Result> handleCall(
    final Session session,
    final Request request,
  ) async {
    return _isUserAgentAndroid(request.headers)
        ? _handleAndroidRedirection(request)
        : _handleWebRedirection(request);
  }

  Future<Result> _handleAndroidRedirection(final Request request) async {
    if (_androidPackageIdentifier == null) {
      return Response.internalServerError(
        body: Body.fromString(
          'Parameter androidPackageIdentifier must be set for '
          'Apple Sign In to work on Android.',
        ),
      );
    }

    final queryString = await _convertRequestBodyToQueryString(request);

    final intentUri =
        'intent://callback$queryString#Intent;'
        'package=$_androidPackageIdentifier;scheme=signinwithapple;end';

    final headers = Headers.build((final h) {
      h['Location'] = [intentUri];
    });

    // 307 Temporary Redirect preserves the original POST method, unlike 302
    // which may change it to GET. This is required because Apple sends the
    // authentication callback as a POST request.
    // See: https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status/307
    return Response(
      307,
      headers: headers,
      body: Body.empty(),
    );
  }

  Future<Result> _handleWebRedirection(final Request request) async {
    if (_webRedirectUri == null) {
      return Response.internalServerError(
        body: Body.fromString(
          'Parameter webRedirectUri must be set for Apple Sign In to work on '
          'Web when using the server callback route.',
        ),
      );
    }

    final queryString = await _convertRequestBodyToQueryString(request);

    final headers = Headers.build((final h) {
      h['Location'] = ['$_webRedirectUri$queryString'];
    });

    // 303 See Other converts the callback POST into a GET, allowing the
    // browser to follow the redirect while preserving callback parameters
    // in the query string.
    // See: https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status/303
    return Response(
      303,
      headers: headers,
      body: Body.empty(),
    );
  }

  bool _isUserAgentAndroid(final Headers headers) {
    final userAgent = headers.userAgent ?? '';
    return userAgent.toLowerCase().contains('android');
  }

  Future<String> _convertRequestBodyToQueryString(final Request request) async {
    final body = await request.readAsString();
    if (body.isEmpty) return '';

    final params = Uri.splitQueryString(body);
    final query = params.entries
        .map(
          (final e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');

    return '?$query';
  }
}
