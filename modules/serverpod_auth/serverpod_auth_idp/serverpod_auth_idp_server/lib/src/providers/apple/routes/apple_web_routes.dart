import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../../../common/web/hmac_payload.dart';
import '../../../common/web/web_auth_helpers.dart';
import '../business/apple_idp.dart';

/// Completes an Apple HTML `form_post` login.
typedef AppleWebLoginFn =
    Future<void> Function(
      Session session, {
      required String identityToken,
      required String authorizationCode,
      required bool isNativeApplePlatformSignIn,
      String? firstName,
      String? lastName,
    });

/// Apple authorize endpoint for HTML Sign in with Apple.
final appleWebAuthorizeUrl = Uri.https(
  'appleid.apple.com',
  '/auth/authorize',
);

/// Scopes requested by HTML Apple sign-in.
const appleWebScopes = ['name', 'email'];

/// Registers GET `/auth/apple` and POST `/auth/apple/web/callback`.
void addAppleWebRoutes({
  required final WebServer webServer,
  required final WebAuthFlowConfig config,
  required final AppleIdp appleIdp,
  final AppleWebLoginFn? loginOverride,
}) {
  final callbackPath = '${config.pathPrefix}/apple/web/callback';
  webServer.addRoute(
    AppleWebStartRoute(
      config: config,
      appleIdp: appleIdp,
      callbackPath: callbackPath,
    ),
    '${config.pathPrefix}/apple',
  );
  webServer.addRoute(
    AppleWebCallbackRoute(
      config: config,
      appleIdp: appleIdp,
      loginOverride: loginOverride,
    ),
    callbackPath,
  );
}

/// GET start of HTML Apple Sign in. State lives in the HMAC'd `state` query
/// parameter Apple echoes on `form_post` — not a Lax OAuth cookie.
final class AppleWebStartRoute extends Route {
  /// Shared HTML auth config.
  final WebAuthFlowConfig config;

  /// Apple IDP (for `serviceIdentifier`).
  final AppleIdp appleIdp;

  /// Path passed to [publicWebOrigin] for `redirect_uri`.
  final String callbackPath;

  /// Creates an [AppleWebStartRoute].
  AppleWebStartRoute({
    required this.config,
    required this.appleIdp,
    required this.callbackPath,
  }) : super(methods: {Method.get});

  @override
  Future<Result> handleCall(
    final Session session,
    final Request request,
  ) async {
    final returnTo = safeReturnTo(
      request.url.queryParameters['return_to'],
      fallback: config.loginSuccessPath,
    );
    final nonce = generateSecureRandomString(16);
    final state = encodeHmacPayload(
      {
        'nonce': nonce,
        'return_to': returnTo,
        'provider': 'apple',
      },
      config.hmacPepper,
    );

    final redirectUri = publicWebOrigin(config.webServer, callbackPath);
    final query = <String, String>{
      'client_id': appleIdp.config.serviceIdentifier,
      'redirect_uri': redirectUri.toString(),
      'response_type': 'code id_token',
      'response_mode': 'form_post',
      'state': state,
      'nonce': nonce,
      'scope': appleWebScopes.join(' '),
    };

    return Response.found(
      appleWebAuthorizeUrl.replace(queryParameters: query),
      headers: authPageHeaders(),
    );
  }
}

/// POST callback for HTML Apple `form_post`. Not Origin-gated and not
/// double-submit CSRF'd: Apple's origin is `https://appleid.apple.com`, and
/// SameSite=Lax cookies are not sent.
final class AppleWebCallbackRoute extends Route {
  /// Shared HTML auth config.
  final WebAuthFlowConfig config;

  /// Apple IDP used when [loginOverride] is null.
  final AppleIdp appleIdp;

  /// Test double for [AppleIdp.login].
  final AppleWebLoginFn? loginOverride;

  /// Creates an [AppleWebCallbackRoute].
  AppleWebCallbackRoute({
    required this.config,
    required this.appleIdp,
    this.loginOverride,
  }) : super(methods: {Method.post});

  @override
  Future<Result> handleCall(
    final Session session,
    final Request request,
  ) async {
    final fields = await readFormFields(request);
    final code = fields['code'];
    final error = fields['error'];
    if ((code == null || code.isEmpty) && error != null && error.isNotEmpty) {
      return authSeeOther(config.loginPath);
    }

    final payload = fields['state'] == null
        ? null
        : decodeHmacPayload(fields['state']!, config.hmacPepper);
    if (payload == null || payload['provider'] != 'apple') {
      return authForbidden();
    }

    final returnTo = trySafeReturnTo(payload['return_to'] as String?);
    if (returnTo == null) {
      return authForbidden();
    }

    final identityToken = fields['id_token'];
    if (code == null ||
        code.isEmpty ||
        identityToken == null ||
        identityToken.isEmpty) {
      return authForbidden();
    }

    final names = _appleUserNames(fields['user']);
    try {
      final login = loginOverride ?? _defaultLogin;
      await login(
        session,
        identityToken: identityToken,
        authorizationCode: code,
        isNativeApplePlatformSignIn: false,
        firstName: names.firstName,
        lastName: names.lastName,
      );
    } on Exception {
      return authSeeOther(config.loginPath);
    }

    return authSeeOther(returnTo);
  }

  Future<void> _defaultLogin(
    final Session session, {
    required final String identityToken,
    required final String authorizationCode,
    required final bool isNativeApplePlatformSignIn,
    final String? firstName,
    final String? lastName,
  }) {
    return appleIdp.login(
      session,
      identityToken: identityToken,
      authorizationCode: authorizationCode,
      isNativeApplePlatformSignIn: isNativeApplePlatformSignIn,
      firstName: firstName,
      lastName: lastName,
    );
  }
}

({String? firstName, String? lastName}) _appleUserNames(
  final String? userJson,
) {
  if (userJson == null || userJson.isEmpty) {
    return (firstName: null, lastName: null);
  }
  try {
    final decoded = jsonDecode(userJson);
    if (decoded is! Map) {
      return (firstName: null, lastName: null);
    }
    final name = decoded['name'];
    if (name is! Map) {
      return (firstName: null, lastName: null);
    }
    return (
      firstName: name['firstName'] as String?,
      lastName: name['lastName'] as String?,
    );
  } on FormatException {
    return (firstName: null, lastName: null);
  }
}
