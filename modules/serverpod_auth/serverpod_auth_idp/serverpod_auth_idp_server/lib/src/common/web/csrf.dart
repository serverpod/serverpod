import 'package:serverpod/serverpod.dart';

import 'hmac_payload.dart';

/// Cookie name for the double-submit CSRF token, derived from [authCookie].
String csrfCookieName(final WebAuthCookieConfig authCookie) =>
    '${authCookie.name}_csrf';

/// A new high-entropy CSRF token.
String generateCsrfToken() => generateSecureRandomString(32);

/// Queues a CSRF cookie on [session], copying Domain / Path / Secure from
/// [authCookie]. SameSite is always Lax: this cookie is for same-origin forms.
void setCsrfCookie(
  final Session session,
  final WebAuthCookieConfig authCookie, {
  required final String token,
}) {
  session.setResponseCookie(
    csrfSetCookie(
      authCookie,
      token,
      maxAge: const Duration(hours: 8).inSeconds,
    ),
  );
}

/// Builds the CSRF `Set-Cookie` for [authCookie].
SetCookie csrfSetCookie(
  final WebAuthCookieConfig authCookie,
  final String value, {
  required final int maxAge,
}) {
  final domain = authCookie.domain;
  return SetCookie(
    name: csrfCookieName(authCookie),
    value: value,
    httpOnly: true,
    secure: authCookie.secure,
    sameSite: SameSite.lax,
    path: authCookie.path,
    domain: domain == null ? null : Host.parse(domain),
    maxAge: maxAge,
  );
}

/// Reads the CSRF cookie from [request], failing closed on duplicates.
String? readCsrfCookie(
  final Request request,
  final WebAuthCookieConfig authCookie,
) {
  return request.getCookieValue(csrfCookieName(authCookie));
}

/// Verifies the double-submit CSRF cookie against the form field.
///
/// Returns false (caller should 403) when the cookie or field is missing,
/// duplicated, or the values do not match.
bool verifyCsrfDoubleSubmit({
  required final Request request,
  required final WebAuthCookieConfig authCookie,
  required final String? formToken,
}) {
  if (formToken == null || formToken.isEmpty) return false;
  final cookieToken = readCsrfCookie(request, authCookie);
  if (cookieToken == null || cookieToken.isEmpty) return false;
  return timingSafeEquals(cookieToken, formToken);
}
