import 'dart:async';

import 'package:serverpod/serverpod.dart';

/// {@template flutter_web_auth2_callback_route}
/// Route that serves the [flutter_web_auth_2](https://pub.dev/packages/flutter_web_auth_2)
/// callback page for the OAuth2 PKCE web sign-in flow.
///
/// This route is **provider-agnostic** — register it once and share it across
/// all OAuth2 PKCE-based identity providers (Google, GitHub, Microsoft, etc.).
///
/// ## Same-origin requirement
///
/// This route **must** be served from the same host and port as your Flutter
/// web application. The callback page uses `window.postMessage` to deliver
/// the OAuth result back to the Flutter app. Browsers enforce that
/// `postMessage` with a specific `targetOrigin` is only delivered when the
/// receiving window has the same origin (scheme + host + port).
///
/// Use the [host] parameter to restrict this route to the exact host that
/// serves your Flutter web app, preventing it from responding to requests
/// aimed at other virtual hosts.
///
/// ## When to use
///
/// Use this route when Serverpod is serving your Flutter web app directly.
/// Register the route once and set its full URL as the `redirectUri` when
/// initializing any OAuth2 PKCE provider in the Flutter app:
///
/// ```dart
/// // server.dart
/// pod.webServer.addRoute(
///   FlutterWebAuth2CallbackRoute(),
///   '/auth/callback',
/// );
///
/// // Flutter app
/// await client.auth.initializeGoogleSignIn(
///   redirectUri: 'https://example.com/auth/callback',
/// );
/// await client.auth.initializeGitHubSignIn(
///   redirectUri: 'https://example.com/auth/callback',
/// );
/// ```
///
/// ## When NOT to use
///
/// If your Flutter web app is hosted separately from Serverpod (for example,
/// on a CDN at `app.example.com` while Serverpod runs on `api.example.com`),
/// the `postMessage` call from the callback page will be blocked by the
/// browser because the origins differ. In that case, place the `auth.html`
/// file provided by `flutter_web_auth_2` in your Flutter app's `web/`
/// directory and use its URL as the `redirectUri`.
/// {@endtemplate}
final class FlutterWebAuth2CallbackRoute extends Route {
  /// Creates a [FlutterWebAuth2CallbackRoute].
  ///
  /// The optional [host] restricts this route to requests whose `Host` header
  /// matches the given value. Defaults to `null`, which matches any host.
  ///
  /// Set [host] to the domain that serves your Flutter web app to ensure the
  /// callback is only reachable from the correct origin.
  FlutterWebAuth2CallbackRoute({super.host}) : super(methods: {Method.get});

  @override
  FutureOr<Result> handleCall(final Session session, final Request request) {
    return Response.ok(
      body: Body.fromString(_callbackHtml, mimeType: MimeType.html),
      headers: Headers.build(
        (final mh) => mh.cacheControl = CacheControlHeader(noStore: true),
      ),
    );
  }

  static const _callbackHtml = '''<!DOCTYPE html>
<title>Authentication complete</title>
<p>Authentication is complete. If this does not happen automatically, please close the window.</p>
<script>
  function postAuthenticationMessage() {
    const message = {
      'flutter-web-auth-2': window.location.href
    };

    if (window.opener) {
      window.opener.postMessage(message, window.location.origin);
      window.close();
    } else if (window.parent && window.parent !== window) {
      window.parent.postMessage(message, window.location.origin);
    } else {
      localStorage.setItem('flutter-web-auth-2', window.location.href);
      window.close();
    }
  }

  postAuthenticationMessage();
</script>''';
}
