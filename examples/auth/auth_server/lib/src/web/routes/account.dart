import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

/// Signed-in account page with a CSRF logout form.
class AccountRoute extends Route {
  @override
  Future<Result> handleCall(
    Session session,
    Request request,
  ) async {
    final authCookie = session.serverpod.config.authCookie!;
    final csrfToken = generateCsrfToken();
    setCsrfCookie(session, authCookie, token: csrfToken);
    final user = session.authenticated?.userIdentifier ?? 'unknown';
    final html =
        '''
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Account</title>
</head>
<body>
<h1>Account</h1>
<p>Signed in as ${HtmlEscape(HtmlEscapeMode.element).convert(user)}</p>
<form method="post" action="/auth/logout">
<input type="hidden" name="csrf" value="${HtmlEscape(HtmlEscapeMode.attribute).convert(csrfToken)}">
<button type="submit">Sign out</button>
</form>
</body>
</html>
''';
    return Response.ok(
      body: Body.fromString(html, mimeType: MimeType.html),
      headers: Headers.build((mh) {
        mh.cacheControl = CacheControlHeader(noStore: true);
      }),
    );
  }
}
