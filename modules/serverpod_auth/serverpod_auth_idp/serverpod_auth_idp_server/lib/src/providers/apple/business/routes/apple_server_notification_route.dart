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
/// To be mounted as a `GET` handler under the URL configured in Apple's
/// developer portal, for example:
///
/// ```dart
///  pod.webServer.addRoute(
///    appleIdp.webAuthenticationCallbackRoute(),
///    '/auth/apple/callback',
/// );
/// ```
/// {@endtemplate}
final class AppleWebAuthenticationCallbackRoute extends _SignInWithAppleRoute {
  /// Create a new route to handle Apple Idp authentication callbacks for web and
  /// other foreign platforms (Android, etc.).
  AppleWebAuthenticationCallbackRoute({required final AppleIdpUtils utils})
    : super(utils, methods: {Method.get});

  @override
  FutureOr<Result> handleCall(final Session session, final Request request) {
    return Response.internalServerError();
  }
}
