import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';

import 'test_helpers/empty_endpoints.dart';

void main() {
  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  group('Given a Serverpod with a start hook, when the pod is started, ', () {
    late Serverpod pod;
    late List<Serverpod> calls;

    setUp(() async {
      calls = [];
      pod = Serverpod(
        [],
        internal.Protocol(),
        EmptyEndpoints(),
        config: ServerpodConfig(apiServer: portZeroConfig),
      );
      pod.experimental.registerStartHook(calls.add);
      await pod.start(runInGuardedZone: false);
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('then the hook is invoked once with the pod.', () {
      expect(calls, [pod]);
    });
  });

  group(
    'Given a started Serverpod with a start hook, '
    'when the server is re-injected into a router as on hot reload, ',
    () {
      late Serverpod pod;
      late int calls;

      setUp(() async {
        calls = 0;
        pod = Serverpod(
          [],
          internal.Protocol(),
          EmptyEndpoints(),
          config: ServerpodConfig(apiServer: portZeroConfig),
        );
        pod.experimental.registerStartHook((_) => calls++);
        await pod.start(runInGuardedZone: false);

        pod.server.injectIn(RelicRouter());
      });

      tearDown(() async {
        await pod.shutdown(exitProcess: false);
      });

      test('then the hook is invoked again.', () {
        expect(calls, 2);
      });
    },
  );
  group(
    'Given a Serverpod with the same start hook registered twice, '
    'when the pod is started, ',
    () {
      late Serverpod pod;
      late int calls;

      setUp(() async {
        calls = 0;
        pod = Serverpod(
          [],
          internal.Protocol(),
          EmptyEndpoints(),
          config: ServerpodConfig(apiServer: portZeroConfig),
        );
        void hook(Serverpod _) => calls++;
        pod.experimental.registerStartHook(hook);
        pod.experimental.registerStartHook(hook);
        await pod.start(runInGuardedZone: false);
      });

      tearDown(() async {
        await pod.shutdown(exitProcess: false);
      });

      test('then the hook is invoked once.', () {
        expect(calls, 1);
      });
    },
  );

  group(
    'Given a Serverpod with a start hook that was unregistered, '
    'when the pod is started, ',
    () {
      late Serverpod pod;
      late int calls;

      setUp(() async {
        calls = 0;
        pod = Serverpod(
          [],
          internal.Protocol(),
          EmptyEndpoints(),
          config: ServerpodConfig(apiServer: portZeroConfig),
        );
        void hook(Serverpod _) => calls++;
        pod.experimental.registerStartHook(hook);
        pod.experimental.unregisterStartHook(hook);
        await pod.start(runInGuardedZone: false);
      });

      tearDown(() async {
        await pod.shutdown(exitProcess: false);
      });

      test('then the hook is not invoked.', () {
        expect(calls, 0);
      });
    },
  );
}
