import 'dart:convert';

import 'package:serverpod/serverpod.dart';

const _legacyEndpointRules = {
  'serverpod_auth.email': _LegacyForwardingRule(
    targetEndpoint: 'serverpod_auth_bridge.legacyEmail',
    connectorName: 'legacyEmail',
    supportedMethods: {'authenticate'},
  ),
  'serverpod_auth.status': _LegacyForwardingRule(
    targetEndpoint: 'serverpod_auth_bridge.legacyStatus',
    connectorName: 'legacyStatus',
    supportedMethods: {
      'isSignedIn',
      'signOutDevice',
      'signOutAllDevices',
      'getUserInfo',
      'getUserSettingsConfig',
    },
  ),
  'serverpod_auth.user': _LegacyForwardingRule(
    targetEndpoint: 'serverpod_auth_bridge.legacyUser',
    connectorName: 'legacyUser',
    supportedMethods: {
      'removeUserImage',
      'setUserImage',
      'changeUserName',
      'changeFullName',
    },
  ),
};

class _LegacyForwardingRule {
  const _LegacyForwardingRule({
    required this.targetEndpoint,
    required this.connectorName,
    required this.supportedMethods,
  });

  final String targetEndpoint;
  final String connectorName;
  final Set<String> supportedMethods;
}

/// Enables request-level forwarding from legacy `serverpod_auth.*` endpoint
/// paths to the bridge's `serverpod_auth_bridge.legacy*` endpoints.
void enableLegacyClientSupport(final Serverpod pod) {
  final bridgeModule = pod.server.endpoints.modules['serverpod_auth_bridge'];
  if (bridgeModule == null) {
    throw StateError(
      'Bridge module "serverpod_auth_bridge" is not registered. '
      'Make sure the bridge module is included in your server endpoints.',
    );
  }

  final requiredLegacyConnectors = _legacyEndpointRules.values
      .map((final rule) => rule.connectorName)
      .toSet();

  final missingConnectors =
      requiredLegacyConnectors
          .where((final name) => !bridgeModule.connectors.containsKey(name))
          .toList()
        ..sort();

  if (missingConnectors.isNotEmpty) {
    throw StateError(
      'Bridge module "serverpod_auth_bridge" is missing required legacy '
      'connectors: ${missingConnectors.join(', ')}.',
    );
  }

  pod.server.addMiddleware((final next) {
    return (final request) async {
      final pathSegments = request.url.pathSegments;
      if (pathSegments.isEmpty) {
        return next(request);
      }

      final firstSegment = pathSegments.first;
      final rule = _legacyEndpointRules[firstSegment];
      if (rule != null) {
        final (methodName, requestToForward) = await _extractMethodName(
          request,
        );

        if (methodName == null || !rule.supportedMethods.contains(methodName)) {
          final methodLabel = methodName ?? '<unknown>';
          return Response.notFound(
            body: Body.fromString(
              'Legacy auth method "$firstSegment.$methodLabel" is not supported.',
            ),
          );
        }

        final forwardedRequest = requestToForward.copyWith(
          url: request.url.replace(
            pathSegments: [rule.targetEndpoint, ...pathSegments.skip(1)],
          ),
        );
        return request.forwardTo(forwardedRequest);
      }

      // Keep unsupported legacy auth endpoints explicit to avoid accidental
      // fallthrough to a real `serverpod_auth` module if one is present.
      if (firstSegment.startsWith('serverpod_auth.')) {
        return Response.notFound(
          body: Body.fromString(
            'Legacy auth endpoint "$firstSegment" is not supported.',
          ),
        );
      }

      return next(request);
    };
  });
}

Future<(String?, Request)> _extractMethodName(final Request request) async {
  final pathSegments = request.url.pathSegments;

  if (pathSegments.length > 1) {
    return (pathSegments[1], request);
  }

  if (request.isEmpty) {
    return (null, request);
  }

  final body = await request.readAsString();
  final rebuiltRequest = request.copyWith(body: Body.fromString(body));

  try {
    final decodedBody = jsonDecode(body);
    if (decodedBody case {'method': final String methodName}) {
      return (methodName, rebuiltRequest);
    }
  } catch (_) {
    // Ignore invalid body content and let normal endpoint parsing fail if routed.
  }

  return (null, rebuiltRequest);
}
