import 'package:serverpod/serverpod.dart';

const _legacyToBridgeEndpoint = <String, String>{
  'serverpod_auth.email': 'serverpod_auth_bridge.legacyEmail',
  'serverpod_auth.status': 'serverpod_auth_bridge.legacyStatus',
  'serverpod_auth.user': 'serverpod_auth_bridge.legacyUser',
};

/// Enables request-level forwarding from selected legacy `serverpod_auth.*`
/// endpoints to the bridge's `serverpod_auth_bridge.legacy*` endpoints.
extension LegacyClientSupport on Serverpod {
  /// Enables support for legacy `serverpod_auth` email and user/session routes.
  void enableLegacyClientSupport() {
    server.addMiddleware((final next) {
      return (final request) {
        final pathSegments = request.url.pathSegments;
        if (pathSegments.isEmpty) {
          return next(request);
        }

        final legacyEndpoint = pathSegments.first;
        final forwardedEndpoint = _legacyToBridgeEndpoint[legacyEndpoint];
        if (forwardedEndpoint == null) {
          return next(request);
        }

        final forwardedRequest = request.copyWith(
          url: request.url.replace(
            pathSegments: [forwardedEndpoint, ...pathSegments.skip(1)],
          ),
        );

        return request.forwardTo(forwardedRequest);
      };
    });
  }
}
