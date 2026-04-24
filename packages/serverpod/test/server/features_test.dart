import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:serverpod/src/server/features.dart';
import 'package:test/test.dart';

void main() {
  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  final databaseConfig = DatabaseConfig(
    host: 'localhost',
    port: 5432,
    name: 'test',
    user: 'test',
    password: 'test',
  );

  group(
    'Given Serverpod initialized in test run mode with database enabled',
    () {
      late Serverpod pod;

      setUp(() {
        pod = Serverpod(
          [],
          internal.Protocol(),
          _EmptyEndpoints(),
          config: ServerpodConfig(
            runMode: ServerpodRunMode.test,
            apiServer: portZeroConfig,
            database: databaseConfig,
          ),
        );
      });

      tearDown(() async {
        await pod.shutdown(exitProcess: false);
      });

      test(
        'when checking persistRuntimeSettings '
        'then it returns false.',
        () {
          expect(Features.persistRuntimeSettings, isFalse);
        },
      );
    },
  );

  group(
    'Given Serverpod initialized in production run mode with database enabled',
    () {
      late Serverpod pod;

      setUp(() {
        pod = Serverpod(
          [],
          internal.Protocol(),
          _EmptyEndpoints(),
          config: ServerpodConfig(
            runMode: ServerpodRunMode.production,
            apiServer: portZeroConfig,
            database: databaseConfig,
          ),
        );
      });

      tearDown(() async {
        await pod.shutdown(exitProcess: false);
      });

      test(
        'when checking persistRuntimeSettings '
        'then it returns true.',
        () {
          expect(Features.persistRuntimeSettings, isTrue);
        },
      );
    },
  );

  group(
    'Given Serverpod initialized in development run mode with database enabled',
    () {
      late Serverpod pod;

      setUp(() {
        pod = Serverpod(
          [],
          internal.Protocol(),
          _EmptyEndpoints(),
          config: ServerpodConfig(
            runMode: ServerpodRunMode.development,
            apiServer: portZeroConfig,
            database: databaseConfig,
          ),
        );
      });

      tearDown(() async {
        await pod.shutdown(exitProcess: false);
      });

      test(
        'when checking persistRuntimeSettings '
        'then it returns true.',
        () {
          expect(Features.persistRuntimeSettings, isTrue);
        },
      );
    },
  );

  group('Given Serverpod initialized without database', () {
    late Serverpod pod;

    setUp(() {
      pod = Serverpod(
        [],
        internal.Protocol(),
        _EmptyEndpoints(),
        config: ServerpodConfig(
          apiServer: portZeroConfig,
        ),
      );
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when checking persistRuntimeSettings '
      'then it returns false.',
      () {
        expect(Features.persistRuntimeSettings, isFalse);
      },
    );
  });
}

class _EmptyEndpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {}
}
