import 'package:serverpod/serverpod.dart';

import '../../../common/web/csrf.dart';
import '../../../common/web/pages/login_page.dart';
import '../../../common/web/web_auth_helpers.dart';
import '../../../generated/protocol.dart'
    show EmailAccountLoginException, EmailAccountLoginExceptionReason;
import '../business/email_idp.dart';

/// GET/POST `/auth/login` hub and POST `/auth/logout`.
final class LoginRoute extends Route {
  /// Shared HTML auth config.
  final WebAuthFlowConfig config;

  /// Email IDP, or null when email is not configured.
  final EmailIdp? emailIdp;

  /// Whether to render a Google button.
  final bool showGoogle;

  /// Whether to render a GitHub button.
  final bool showGitHub;

  /// Whether to render a Microsoft button.
  final bool showMicrosoft;

  /// Whether to render an Apple button.
  final bool showApple;

  /// Creates a [LoginRoute].
  LoginRoute({
    required this.config,
    required this.emailIdp,
    required this.showGoogle,
    required this.showGitHub,
    this.showMicrosoft = false,
    this.showApple = false,
  }) : super(methods: {Method.get, Method.post});

  @override
  Future<Result> handleCall(
    final Session session,
    final Request request,
  ) async {
    if (request.method == Method.get) {
      return _get(session, request);
    }
    if (emailIdp == null) {
      return Response.notFound(headers: authPageHeaders());
    }
    return _post(session, request, emailIdp!);
  }

  Result _get(final Session session, final Request request) {
    final csrfToken = generateCsrfToken();
    setCsrfCookie(session, config.authCookie, token: csrfToken);
    final returnTo = safeReturnTo(
      request.url.queryParameters['return_to'],
      fallback: config.loginSuccessPath,
    );
    return authHtmlOk(
      renderLoginPage(
        config: config,
        csrfToken: csrfToken,
        returnTo: returnTo,
        showEmail: emailIdp != null,
        showGoogle: showGoogle,
        showGitHub: showGitHub,
        showMicrosoft: showMicrosoft,
        showApple: showApple,
        signedIn: session.authenticated != null,
      ),
    );
  }

  Future<Result> _post(
    final Session session,
    final Request request,
    final EmailIdp emailIdp,
  ) async {
    final fields = await readFormFields(request);
    if (!verifyCsrfDoubleSubmit(
      request: request,
      authCookie: config.authCookie,
      formToken: fields['csrf'],
    )) {
      return authForbidden();
    }
    if (!originAllowedForAuthForm(request, config.allowedOrigins)) {
      return authForbidden();
    }

    final returnTo = safeReturnTo(
      fields['return_to'],
      fallback: config.loginSuccessPath,
    );

    await signOutBeforeHtmlLogin(session);

    final email = fields['email'] ?? '';
    final password = fields['password'] ?? '';
    try {
      await emailIdp.login(session, email: email, password: password);
    } on EmailAccountLoginException catch (e) {
      return _loginError(
        session,
        returnTo: returnTo,
        message: _emailErrorMessage(e),
      );
    } on Exception {
      return _loginError(
        session,
        returnTo: returnTo,
        message: 'Sign-in failed.',
      );
    }

    return authSeeOther(returnTo);
  }

  Result _loginError(
    final Session session, {
    required final String returnTo,
    required final String message,
  }) {
    final csrfToken = generateCsrfToken();
    setCsrfCookie(session, config.authCookie, token: csrfToken);
    return authHtmlOk(
      renderLoginPage(
        config: config,
        csrfToken: csrfToken,
        returnTo: returnTo,
        showEmail: true,
        showGoogle: showGoogle,
        showGitHub: showGitHub,
        showMicrosoft: showMicrosoft,
        showApple: showApple,
        errorMessage: message,
      ),
    );
  }

  String _emailErrorMessage(final EmailAccountLoginException exception) {
    return switch (exception.reason) {
      EmailAccountLoginExceptionReason.tooManyAttempts =>
        'Too many attempts. Try again later.',
      EmailAccountLoginExceptionReason.invalidCredentials ||
      EmailAccountLoginExceptionReason.unknown => 'Invalid email or password.',
    };
  }
}

/// POST `/auth/logout`.
final class LogoutRoute extends Route {
  /// Shared HTML auth config.
  final WebAuthFlowConfig config;

  /// Creates a [LogoutRoute].
  LogoutRoute({required this.config}) : super(methods: {Method.post});

  @override
  Future<Result> handleCall(
    final Session session,
    final Request request,
  ) async {
    final fields = await readFormFields(request);
    if (!verifyCsrfDoubleSubmit(
      request: request,
      authCookie: config.authCookie,
      formToken: fields['csrf'],
    )) {
      return authForbidden();
    }
    if (!originAllowedForAuthForm(request, config.allowedOrigins)) {
      return authForbidden();
    }

    await signOutCurrentDevice(session);
    return authSeeOther(config.loginPath);
  }
}
