import 'package:serverpod/serverpod.dart';

const _legacyEndpointPrefix = 'serverpod_auth.';
const _bridgeLegacyEndpointPrefix = 'serverpod_auth_bridge.legacy';

/// Enables request-level forwarding from legacy `serverpod_auth.*` endpoint
/// paths to the bridge's `serverpod_auth_bridge.legacy*` endpoints.
void enableLegacyClientSupport(final Serverpod pod) {
  pod.server.addMiddleware((final next) {
    return (final request) {
      final pathSegments = request.url.pathSegments;
      if (pathSegments.isEmpty) {
        return next(request);
      }

      final legacyEndpoint = pathSegments.first;
      if (!legacyEndpoint.startsWith(_legacyEndpointPrefix)) {
        return next(request);
      }

      final endpointSuffix = legacyEndpoint.substring(
        _legacyEndpointPrefix.length,
      );
      if (endpointSuffix.isEmpty) {
        return next(request);
      }

      final forwardedEndpoint =
          '$_bridgeLegacyEndpointPrefix${_capitalize(endpointSuffix)}';
      final forwardedRequest = request.copyWith(
        url: request.url.replace(
          pathSegments: [forwardedEndpoint, ...pathSegments.skip(1)],
        ),
      );

      return request.forwardTo(forwardedRequest);
    };
  });
}

String _capitalize(final String value) =>
    '${value[0].toUpperCase()}${value.substring(1)}';
