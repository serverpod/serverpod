import 'package:serverpod/serverpod.dart';

import 'legacy_endpoint_disposition.dart';

/// Enables request-level forwarding from selected legacy `serverpod_auth`
/// endpoints to the bridge's `serverpod_auth_bridge.legacy*` endpoints.
extension LegacyClientSupport on Serverpod {
  /// Enables support for legacy `serverpod_auth` email and user/session routes.
  ///
  /// The legacy `email`, `status` and `user` endpoints are forwarded to their
  /// bridge equivalents, so existing clients keep working against the new
  /// stack. Every other legacy `serverpod_auth` endpoint is left to the
  /// legacy module, so a deployment still signing users in through the legacy
  /// Apple, Firebase or Google endpoints keeps working while it migrates.
  ///
  /// Pass `blockUnbridgedAuthEndpoints: true` once nothing needs those, and
  /// they are refused as if they were never mounted. Serving them on a fully
  /// migrated deployment is a loose end worth closing: the sign-ins hand out
  /// legacy session keys the new stack knows nothing about, and `admin` acts
  /// on rows it no longer reads.
  void enableLegacyClientSupport({
    final bool blockUnbridgedAuthEndpoints = false,
  }) {
    server.addMiddleware((final next) {
      return (final request) {
        final pathSegments = request.url.pathSegments;
        if (pathSegments.isEmpty) {
          return next(request);
        }

        final disposition = dispositionFor(
          pathSegments.first,
          blockUnbridgedAuthEndpoints: blockUnbridgedAuthEndpoints,
        );

        switch (disposition) {
          case PassThrough():
            return next(request);

          case BlockLegacyEndpoint():
            return Response.notFound();

          case ForwardToBridge(:final bridgeEndpoint):
            final forwardedRequest = request.copyWith(
              url: request.url.replace(
                pathSegments: [bridgeEndpoint, ...pathSegments.skip(1)],
              ),
            );

            return request.forwardTo(forwardedRequest);
        }
      };
    });
  }
}
