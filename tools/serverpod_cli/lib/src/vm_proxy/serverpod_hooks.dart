import 'dart:async';

import 'package:serverpod_cli/src/vm_proxy/interceptor.dart';

/// Builds an [RpcInterceptor] that short-circuits VM-service `reloadSources`
/// requests by running [reload] (typically `WatchSession.forceReload`) and
/// answering the caller with a synthetic `ReloadReport`. All other frames
/// are forwarded.
///
/// Routing reload through here means the IDE's reload button hits the FES
/// pipeline (codegen + hooks + compile + reload) instead of the VM's
/// built-in `reloadSources`, which can crash kernel_service when the
/// isolate was booted from a precompiled dill.
RpcInterceptor reloadSourcesInterceptor(Future<void> Function() reload) {
  return (message, direction) async {
    if (direction != Direction.clientToServer) return const Forward();
    if (message['method'] != 'reloadSources') return const Forward();
    final id = message['id'];
    if (id == null) return const Forward();

    try {
      await reload();
      return Respond({
        'jsonrpc': '2.0',
        'id': id,
        'result': {'type': 'ReloadReport', 'success': true},
      });
    } catch (e) {
      return Respond({
        'jsonrpc': '2.0',
        'id': id,
        'result': {'type': 'ReloadReport', 'success': false},
        'error': {
          'code': -32000,
          'message': 'serverpod reload failed',
          'data': e.toString(),
        },
      });
    }
  };
}
