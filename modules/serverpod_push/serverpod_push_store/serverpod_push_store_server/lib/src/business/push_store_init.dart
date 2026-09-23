import 'package:serverpod/serverpod.dart';
import 'package:serverpod_push_core_server/serverpod_push_core_server.dart';
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'push_dispatcher.dart';
import 'push_store.dart';
import 'push_store_config.dart';

/// Extension to initialize the push store and dispatcher.
extension PushStoreInit on Serverpod {
  /// Validates provider send timeouts against [config.claimTimeout], then
  /// starts the dispatcher on monolith pods.
  Future<void> initializePushStore({
    final PushStoreConfig config = const PushStoreConfig(),
  }) async {
    for (final provider in PushService.instance.providers) {
      if (provider.sendTimeout * 2 >= config.claimTimeout) {
        throw StateError(
          'Provider "${provider.provider}" has sendTimeout '
          '${provider.sendTimeout}, which is not safely below claimTimeout '
          '${config.claimTimeout}.',
        );
      }
    }

    PushStore.set(config: config);

    if (this.config.role != ServerpodRole.monolith) {
      log.warning(
        'serverpod_push: role is ${this.config.role.name}; deliveries will be '
        'enqueued but not dispatched. A monolith instance must run to drain them.',
      );
      return;
    }

    final dispatcher = PushDispatcher(serverpod: this, config: config);
    PushStore.instance.dispatcher = dispatcher;
    await dispatcher.start();

    experimental.shutdownTasks.addTask('serverpod_push_dispatcher', () async {
      await dispatcher.stopAndReleaseClaims();
    });
  }
}
