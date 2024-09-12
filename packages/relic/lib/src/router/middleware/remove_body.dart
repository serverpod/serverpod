part of '../router.dart';

/// Middleware to remove body from request.
final _removeBody = createMiddleware(responseHandler: (r) {
  if (r.headers.contentLength != null) {
    r = r.copyWith(
      headers: r.headers.copyWith(
        contentLength: '0',
      ),
    );
  }
  return r.copyWith(
    body: Body.fromData(
      Uint8List.fromList(<int>[]),
    ),
  );
});
