import 'package:relic/relic.dart';

/// Returns [response] with the given response [headers] and [cookies] applied.
///
/// Returns [response] unchanged when both are empty (the common case, so
/// endpoints that set nothing are unaffected). Values set here take precedence;
/// the server merges its default response headers afterwards for anything not
/// set here. Each [SetCookie] is appended to any `Set-Cookie` already on
/// [response] via relic's [SetCookieHeader] collection.
Response applyResponseOutput(
  Response response, {
  required Map<String, String> headers,
  required List<SetCookie> cookies,
}) {
  if (headers.isEmpty && cookies.isEmpty) return response;

  return response.copyWith(
    headers: response.headers.transform((mh) {
      for (var entry in headers.entries) {
        mh[entry.key] = [entry.value];
      }
      if (cookies.isNotEmpty) {
        mh.setCookie = (mh.setCookie ?? const SetCookieHeader.empty()).addAll(
          cookies,
        );
      }
    }),
  );
}
