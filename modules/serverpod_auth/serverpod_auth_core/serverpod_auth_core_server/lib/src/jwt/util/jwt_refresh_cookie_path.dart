import 'package:serverpod/serverpod.dart';

import '../endpoints/jwt_tokens_endpoint.dart';

/// Resolves the cookie `Path` for the JWT refresh cookie by locating the
/// concrete [RefreshJwtTokensEndpoint] registered on the server, so the
/// browser only attaches the refresh token to calls on that endpoint's route
/// (method calls POST to `/<endpoint>/<method>`).
///
/// The endpoint is abstract and named by the application, so the route cannot
/// be known statically; it is discovered from the endpoint dispatch at
/// runtime. Returns null - falling back to the configured `authCookie.path` -
/// when cookie auth is not configured, or when zero or more than one concrete
/// refresh endpoint is registered (an ambiguous route could scope the cookie
/// away from the endpoint that needs it).
///
/// The route's base is the browser-visible base path the cookie-mode client
/// declared on the request ([WebAuthCookieSession.webAuthBasePath]), which
/// stays correct behind a prefix-stripping reverse proxy the server cannot see
/// through. When absent (older client), the configured `authCookie.path` is
/// used instead, in which case it must reflect any URL prefix.
String? jwtRefreshCookiePath(final Session session) {
  final authCookie = session.serverpod.config.authCookie;
  if (authCookie == null) return null;

  final matches = session.server.endpoints.connectors.values
      .where(
        (final connector) => connector.endpoint is RefreshJwtTokensEndpoint,
      )
      .toList();
  if (matches.length != 1) return null;

  final base = session.webAuthBasePath ?? authCookie.path;
  final endpointName = matches.single.name;
  return base.endsWith('/') ? '$base$endpointName' : '$base/$endpointName';
}
