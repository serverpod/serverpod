import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';

void main() {
  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  group('Given Serverpod initialized with custom --server-id', () {
    late Serverpod pod;
    const customServerId = 'my-pod-42';

    setUp(() {
      pod = Serverpod(
        ['--server-id', customServerId],
        internal.Protocol(),
        _EmptyEndpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig,
          webServer: portZeroConfig,
        ),
      );
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when accessing all `serverId` properties '
      'then they all return the custom server id.',
      () {
        expect(pod.serverId, equals(customServerId));
        expect(pod.config.serverId, equals(customServerId));
        expect(pod.server.serverId, equals(customServerId));
      },
    );
  });

  group('Given Serverpod initialized without --server-id', () {
    late Serverpod pod;

    setUp(() {
      pod = Serverpod(
        [],
        internal.Protocol(),
        _EmptyEndpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig,
          webServer: portZeroConfig,
        ),
      );
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when accessing all `serverId` properties '
      'then they all return "default".',
      () {
        expect(pod.config.serverId, equals('default'));
        expect(pod.serverId, equals('default'));
        expect(pod.server.serverId, equals('default'));
      },
    );
  });
}

class _EmptyEndpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {}
}
