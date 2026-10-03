/// Which legacy `serverpod_auth` endpoints the bridge serves, and how.
///
/// Kept out of the package's public surface: this is the routing table behind
/// `enableLegacyClientSupport`, not something applications configure directly.
library;

/// The endpoint namespace of the legacy `serverpod_auth` module.
const _legacyEndpointPrefix = 'serverpod_auth.';

/// The legacy endpoints the bridge serves, and what serves them.
///
/// Everything else under [_legacyEndpointPrefix] is refused, derived from this
/// table so a legacy endpoint nobody thought of is not quietly served. On a
/// migrated deployment the rest of the legacy surface answers out of tables
/// the new stack no longer reads: the provider sign-ins hand out legacy
/// session keys, and `admin` marks a `serverpod_user_info` row that no longer
/// blocks anyone.
///
/// `admin` is refused rather than forwarded to the bridge's `legacyAdmin`
/// endpoint, which answers only for users already migrated and reports the
/// auth user's id as the `userIdentifier`.
const _legacyToBridgeEndpoint = <String, ForwardToBridge>{
  'serverpod_auth.email': ForwardToBridge('serverpod_auth_bridge.legacyEmail'),
  'serverpod_auth.status': ForwardToBridge(
    'serverpod_auth_bridge.legacyStatus',
  ),
  'serverpod_auth.user': ForwardToBridge('serverpod_auth_bridge.legacyUser'),
};

/// What legacy client support does with a request for a legacy endpoint.
sealed class LegacyEndpointDisposition {
  const LegacyEndpointDisposition();
}

/// A decision to rewrite the request onto [bridgeEndpoint].
final class ForwardToBridge extends LegacyEndpointDisposition {
  /// The bridge endpoint serving this legacy endpoint.
  final String bridgeEndpoint;

  /// Forwards to [bridgeEndpoint].
  const ForwardToBridge(this.bridgeEndpoint);
}

/// A decision to refuse the request, as if the endpoint were not mounted.
final class BlockLegacyEndpoint extends LegacyEndpointDisposition {
  /// Blocks the request.
  const BlockLegacyEndpoint();
}

/// A decision to pass the request through, unchanged.
final class PassThrough extends LegacyEndpointDisposition {
  /// Passes the request on unchanged.
  const PassThrough();
}

/// Decides what happens to a request addressed to [endpoint].
LegacyEndpointDisposition dispositionFor(
  final String endpoint, {
  required final bool blockUnbridgedAuthEndpoints,
}) {
  final forwarded = _legacyToBridgeEndpoint[endpoint];
  if (forwarded != null) return forwarded;

  if (blockUnbridgedAuthEndpoints &&
      endpoint.startsWith(_legacyEndpointPrefix)) {
    return const BlockLegacyEndpoint();
  }

  return const PassThrough();
}
