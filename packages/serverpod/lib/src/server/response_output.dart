import 'package:relic/relic.dart';

/// Returns [response] with the given response [headers] and [cookies] applied.
///
/// Returns [response] unchanged when both are empty (the common case, so
/// endpoints that set nothing are unaffected). Values set here take precedence;
/// the server merges its default response headers afterwards for anything not
/// set here. Cookies are encoded with relic's [SetCookieHeader] codec and
/// appended to any `Set-Cookie` already on [response].
Response applyResponseOutput(
  Response response, {
  required Map<String, String> headers,
  required List<SetCookieHeader> cookies,
}) {
  if (headers.isEmpty && cookies.isEmpty) return response;

  return response.copyWith(
    headers: response.headers.transform((mh) {
      for (var entry in headers.entries) {
        mh[entry.key] = [entry.value];
      }
      if (cookies.isNotEmpty) {
        var existing = mh[Headers.setCookieHeader] ?? const <String>[];
        mh[Headers.setCookieHeader] = [
          ...existing,
          ...cookies.expand(SetCookieHeader.codec.encode),
        ];
      }
    }),
  );
}
