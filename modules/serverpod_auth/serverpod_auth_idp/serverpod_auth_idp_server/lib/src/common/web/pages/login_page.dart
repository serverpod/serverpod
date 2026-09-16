import 'dart:convert';

import '../web_auth_helpers.dart';

const _htmlEscape = HtmlEscape(HtmlEscapeMode.element);
const _attrEscape = HtmlEscape(HtmlEscapeMode.attribute);

/// Renders the HTML login hub.
String renderLoginPage({
  required final WebAuthFlowConfig config,
  required final String csrfToken,
  required final String returnTo,
  required final bool showEmail,
  required final bool showGoogle,
  required final bool showGitHub,
  final bool showMicrosoft = false,
  final bool showApple = false,
  final bool signedIn = false,
  final String? errorMessage,
}) {
  final returnToAttr = _attrEscape.convert(returnTo);
  final csrfAttr = _attrEscape.convert(csrfToken);
  final loginAction = _attrEscape.convert(config.loginPath);
  final logoutAction = _attrEscape.convert(config.logoutPath);
  final oauthQuery = Uri(queryParameters: {'return_to': returnTo}).query;

  final buffer = StringBuffer()
    ..writeln('<!DOCTYPE html>')
    ..writeln('<html lang="en">')
    ..writeln('<head>')
    ..writeln('<meta charset="utf-8">')
    ..writeln(
      '<meta name="viewport" content="width=device-width, initial-scale=1">',
    )
    ..writeln('<title>Sign in</title>')
    ..writeln('</head>')
    ..writeln('<body>')
    ..writeln('<h1>Sign in</h1>');

  if (errorMessage != null && errorMessage.isNotEmpty) {
    buffer.writeln(
      '<p role="alert">${_htmlEscape.convert(errorMessage)}</p>',
    );
  }

  if (signedIn) {
    buffer
      ..writeln('<p>You are signed in.</p>')
      ..writeln(
        '<form method="post" action="$logoutAction">'
        '<input type="hidden" name="csrf" value="$csrfAttr">'
        '<button type="submit">Sign out</button>'
        '</form>',
      );
  }

  if (showEmail) {
    buffer
      ..writeln('<form method="post" action="$loginAction">')
      ..writeln(
        '<input type="hidden" name="csrf" value="$csrfAttr">',
      )
      ..writeln(
        '<input type="hidden" name="return_to" value="$returnToAttr">',
      )
      ..writeln(
        '<label>Email <input type="email" name="email" required></label>',
      )
      ..writeln(
        '<label>Password <input type="password" name="password" required></label>',
      )
      ..writeln('<button type="submit">Sign in with email</button>')
      ..writeln('</form>')
      ..writeln(
        '<p>Registration, email verification, and password reset are not '
        'available on this page.</p>',
      );
  }

  if (showGoogle) {
    final href = _attrEscape.convert('${config.pathPrefix}/google?$oauthQuery');
    buffer.writeln('<p><a href="$href">Continue with Google</a></p>');
  }
  if (showGitHub) {
    final href = _attrEscape.convert('${config.pathPrefix}/github?$oauthQuery');
    buffer.writeln('<p><a href="$href">Continue with GitHub</a></p>');
  }
  if (showMicrosoft) {
    final href = _attrEscape.convert(
      '${config.pathPrefix}/microsoft?$oauthQuery',
    );
    buffer.writeln('<p><a href="$href">Continue with Microsoft</a></p>');
  }
  if (showApple) {
    final href = _attrEscape.convert('${config.pathPrefix}/apple?$oauthQuery');
    buffer.writeln('<p><a href="$href">Continue with Apple</a></p>');
  }

  if (!showEmail &&
      !showGoogle &&
      !showGitHub &&
      !showMicrosoft &&
      !showApple) {
    buffer.writeln('<p>No sign-in methods are configured.</p>');
  }

  buffer
    ..writeln('</body>')
    ..writeln('</html>');
  return buffer.toString();
}
