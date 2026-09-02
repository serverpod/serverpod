import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/apple.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart';

const allowedOrigin = 'http://localhost:9999';
const authCookieName = WebAuthCookieConfig.defaultName;

final portZero = ServerConfig(
  port: 0,
  publicScheme: 'http',
  publicHost: 'localhost',
  publicPort: 0,
);

GoogleClientSecret googleSecret({
  final List<String> redirectUris = const [
    'http://localhost:8082/auth/google/callback',
  ],
}) {
  return GoogleClientSecret.fromJson({
    'web': {
      'client_id': 'test-google-client-id',
      'client_secret': 'test-google-secret',
      'redirect_uris': redirectUris,
    },
  });
}

const appleTestConfig = AppleIdpConfig(
  serviceIdentifier: 'test.apple.service',
  bundleIdentifier: 'test.bundle',
  redirectUri: 'https://example.com/flutter-apple',
  teamId: 'TESTTEAM',
  keyId: 'TESTKEYID',
  key: 'test-key',
  webRedirectUri: 'https://example.com/app',
);

Serverpod createWebAuthPod({
  final WebAuthCookieConfig? authCookie = const WebAuthCookieConfig(
    secure: false,
  ),
  final List<String>? allowedOrigins = const [allowedOrigin],
  final ServerConfig? webServer,
  final List<String> args = const ['-m', 'test'],
  final Directory? serverDirectory,
}) {
  return Serverpod(
    args,
    Protocol(),
    Endpoints(),
    config: ServerpodConfig(
      apiServer: portZero,
      webServer:
          webServer ??
          ServerConfig(
            port: 0,
            publicScheme: 'http',
            publicHost: 'localhost',
            publicPort: 8082,
          ),
      authCookie: authCookie,
      allowedOrigins: allowedOrigins,
    ),
    serverDirectory: serverDirectory,
  );
}

void initSasAuth(
  final Serverpod pod, {
  final List<IdentityProviderBuilder> identityProviderBuilders = const [],
}) {
  pod.initializeAuthServices(
    tokenManagerBuilders: [
      ServerSideSessionsConfig(
        sessionKeyHashPepper: 'test-pepper',
      ),
    ],
    identityProviderBuilders: identityProviderBuilders,
  );
}

final class WhoAmIRoute extends Route {
  @override
  Future<Result> handleCall(
    final Session session,
    final Request request,
  ) async {
    return Response.ok(
      body: Body.fromString(
        session.authenticated?.userIdentifier ?? 'anonymous',
      ),
    );
  }
}

String? setCookieValue(final http.Response response, final String name) {
  final header = response.headers['set-cookie'];
  if (header == null) return null;
  String? lastNonEmpty;
  for (final match in RegExp(
    '(?:^|,\\s*)${RegExp.escape(name)}=([^;,]*)',
  ).allMatches(header)) {
    final value = match.group(1);
    if (value != null && value.isNotEmpty) lastNonEmpty = value;
  }
  return lastNonEmpty;
}

bool setCookieCleared(final http.Response response, final String name) {
  final header = response.headers['set-cookie'];
  if (header == null) return false;
  return RegExp(
    '(?:^|,\\s*)${RegExp.escape(name)}=[^;]*;[^,]*(?:Max-Age|max-age)=0',
    caseSensitive: false,
  ).hasMatch(header);
}

Future<http.Response> send(
  final http.Client client,
  final Uri base,
  final String method,
  final String path, {
  final Map<String, String>? headers,
  final String? body,
  final String? cookie,
  final String? origin,
}) async {
  final request = http.Request(method, base.replace(path: path))
    ..followRedirects = false;
  if (headers != null) request.headers.addAll(headers);
  if (cookie != null) request.headers['cookie'] = cookie;
  if (origin != null) request.headers['origin'] = origin;
  if (body != null) {
    request.headers['content-type'] = 'application/x-www-form-urlencoded';
    request.body = body;
  }
  final streamed = await client.send(request);
  return http.Response.fromStream(streamed);
}

String formBody(final Map<String, String> fields) {
  return fields.entries
      .map(
        (final e) =>
            '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}',
      )
      .join('&');
}
