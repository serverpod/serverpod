import 'package:serverpod/serverpod.dart';

/// Relic middleware that requires `session.authenticated` for the wrapped
/// routes.
///
/// When [redirectTo] is null, unauthenticated requests receive `401`.
/// Otherwise they receive `303 See Other` to [redirectTo] with a `return_to`
/// query of the current path and query (after [safeReturnTo]).
///
/// [redirectTo] must itself be a safe same-origin relative path; invalid
/// values throw at construction. This is Relic middleware and is unrelated
/// to [Endpoint.requireLogin].
///
/// Do not mount at `/`: that would wrap `/auth/*` login routes and the
/// `/livez` `/readyz` `/startupz` health probes.
Middleware requireLogin({String? redirectTo}) {
  final String? safeRedirectTo;
  if (redirectTo != null) {
    final validated = trySafeReturnTo(redirectTo);
    if (validated == null) {
      throw ArgumentError.value(
        redirectTo,
        'redirectTo',
        'Must be a safe same-origin relative path.',
      );
    }
    safeRedirectTo = validated;
  } else {
    safeRedirectTo = null;
  }

  return (Handler next) {
    return (Request req) async {
      final session = await req.session;
      if (session.authenticated != null) {
        return next(req);
      }

      if (safeRedirectTo == null) {
        return Response.unauthorized();
      }

      final current = _pathAndQuery(req);
      final returnTo = safeReturnTo(current);
      return Response.seeOther(
        Uri.parse(withReturnToQuery(safeRedirectTo, returnTo)),
      );
    };
  };
}

String _pathAndQuery(Request req) {
  final path = req.url.path;
  if (!req.url.hasQuery) return path;
  return '$path?${req.url.query}';
}
