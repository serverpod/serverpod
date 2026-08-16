import 'dart:async';

/// Direction of a JSON-RPC frame relative to the upstream VM service.
enum Direction {
  /// IDE/DevTools -> VM service.
  clientToServer,

  /// VM service -> IDE/DevTools.
  serverToClient,
}

/// What [VmServiceProxy] should do with a frame after the interceptor runs.
sealed class InterceptResult {
  const InterceptResult();
}

/// Forward the original frame bytes unchanged.
final class Forward extends InterceptResult {
  const Forward();
}

/// Forward a re-serialised replacement message in place of the original.
final class Replace extends InterceptResult {
  final Map<String, Object?> message;
  const Replace(this.message);
}

/// Short-circuit a request with a synthesized response sent back to the
/// caller. Only meaningful for [Direction.clientToServer] requests (frames
/// carrying both `method` and `id`); the proxy treats it as [Forward] for
/// notifications and server->client frames.
final class Respond extends InterceptResult {
  final Map<String, Object?> response;
  const Respond(this.response);
}

/// Drop the frame entirely. Use sparingly - dropping a request leaves the
/// caller hanging.
final class Drop extends InterceptResult {
  const Drop();
}

/// Hook called for every parsed JSON-RPC frame passing through the proxy.
typedef RpcInterceptor =
    FutureOr<InterceptResult> Function(
      Map<String, Object?> message,
      Direction direction,
    );

/// An interceptor that always forwards. Useful as a default and as a base
/// for tests.
FutureOr<InterceptResult> passthroughInterceptor(
  Map<String, Object?> message,
  Direction direction,
) => const Forward();
