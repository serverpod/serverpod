import 'package:serverpod/serverpod.dart';

class _LegacyEndpointDispatch extends EndpointDispatch {
  @override
  void initializeEndpoints(final Server server) {}
}

const _nameMapping = {
  'legacyEmail': 'email',
  'legacyStatus': 'status',
  'legacyUser': 'user',
  'legacyAdmin': 'admin',
  'legacyGoogle': 'google',
  'legacyApple': 'apple',
  'legacyFirebase': 'firebase',
};

/// Registers the bridge's legacy proxy endpoints under the `serverpod_auth`
/// module namespace so old clients can reach them at the expected paths.
void enableLegacyClientSupport(final Serverpod pod) {
  final bridgeModule = pod.server.endpoints.modules['serverpod_auth_bridge'];
  if (bridgeModule == null) {
    throw StateError(
      'Bridge module "serverpod_auth_bridge" is not registered. '
      'Make sure the bridge module is included in your server endpoints.',
    );
  }

  final legacyDispatch = _LegacyEndpointDispatch();
  for (final entry in _nameMapping.entries) {
    final connector = bridgeModule.connectors[entry.key];
    if (connector != null) {
      connector.endpoint.initialize(pod.server, entry.value, 'serverpod_auth');
      legacyDispatch.connectors[entry.value] = connector;
    }
  }

  pod.server.endpoints.modules['serverpod_auth'] = legacyDispatch;
}
