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

  group('Given Serverpod initialized with a config override callback', () {
    late Serverpod pod;
    const overriddenId = 'from-callback';

    setUp(() {
      pod = Serverpod(
        [],
        internal.Protocol(),
        _EmptyEndpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig,
          webServer: portZeroConfig,
        ),
        configOverride: (config) => config.copyWith(serverId: overriddenId),
      );
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when reading server id from the pod '
      'then it matches the overridden value.',
      () {
        expect(pod.config.serverId, equals(overriddenId));
        expect(pod.serverId, equals(overriddenId));
      },
    );
  });

  group('Given Serverpod initialized without config override', () {
    late Serverpod pod;
    const originalId = 'unchanged';

    setUp(() {
      pod = Serverpod(
        [],
        internal.Protocol(),
        _EmptyEndpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig,
          webServer: portZeroConfig,
          serverId: originalId,
        ),
      );
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when reading server id from the pod '
      'then it matches the original server id.',
      () {
        expect(pod.config.serverId, equals(originalId));
        expect(pod.serverId, equals(originalId));
      },
    );
  });
}

class _EmptyEndpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {}
}
