import 'package:relic/relic.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart'
    show webAuthModeHeaderName, webBasePathHeaderName;

/// The request headers cookie-auth web clients send on every call, which a
/// cross-origin preflight must allow-list or the browser blocks the request
/// before it reaches the server.
const cookieAuthRequestHeaders = [
  webAuthModeHeaderName,
  webBasePathHeaderName,
];

/// Ensures [cookieAuthRequestHeaders] are allowed by the preflight response's
/// `Access-Control-Allow-Headers` being built in [mh].
///
/// The default OPTIONS headers include them, but a custom
/// `httpOptionsResponseHeaders` override may not. Browsers treat a wildcard
/// literally on credentialed (cookie-mode) requests, so a wildcard override
/// is emulated by echoing the preflight's [requestedHeaders] together with
/// the cookie-auth ones.
void ensureCookieAuthAllowedHeaders(
  MutableHeaders mh, {
  required List<String>? requestedHeaders,
}) {
  final allow = mh.accessControlAllowHeaders;
  if (allow == null) {
    mh.accessControlAllowHeaders = AccessControlAllowHeadersHeader.headers(
      cookieAuthRequestHeaders,
    );
  } else if (allow.isWildcard) {
    mh.accessControlAllowHeaders = AccessControlAllowHeadersHeader.headers({
      ...?requestedHeaders,
      ...cookieAuthRequestHeaders,
    });
  } else {
    final missing = cookieAuthRequestHeaders.where(
      (h) => !allow.headers.contains(h),
    );
    if (missing.isNotEmpty) {
      mh.accessControlAllowHeaders = AccessControlAllowHeadersHeader.headers([
        ...allow.headers,
        ...missing,
      ]);
    }
  }
}
