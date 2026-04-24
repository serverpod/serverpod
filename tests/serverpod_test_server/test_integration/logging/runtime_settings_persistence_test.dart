import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/endpoints.dart' as e;
import 'package:serverpod_test_server/src/generated/protocol.dart' as p;
import 'package:serverpod_test_server/test_util/builders/runtime_settings_builder.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Given a server started in test run mode',
    () {
      late Serverpod server;
      late Session session;

      setUp(() async {
        server = Serverpod(
          ['-m', ServerpodRunMode.test],
          p.Protocol(),
          e.Endpoints(),
          config: ServerpodConfig(
            runMode: ServerpodRunMode.test,
            apiServer: ServerConfig(
              port: 8080,
              publicScheme: 'http',
              publicHost: 'localhost',
              publicPort: 8080,
            ),
            database: DatabaseConfig(
              host: 'postgres',
              port: 5432,
              user: 'postgres',
              password: 'password',
              name: 'serverpod_test',
            ),
          ),
        );

        await server.start();
        session = await server.createSession(enableLogging: false);

        await server.clearRuntimeSettings(session);
      });

      tearDown(() async {
        await session.close();
        await server.shutdown(exitProcess: false);
      });

      test(
        'when server starts then the runtime settings table remains empty.',
        () async {
          final count = await server.countRuntimeSettingsRows(session);
          expect(count, equals(0));
        },
      );

      test(
        'when updateRuntimeSettings is called then the runtime settings table remains empty.',
        () async {
          var settings = RuntimeSettingsBuilder()
              .withLogMalformedCalls(false)
              .build();

          await server.updateRuntimeSettings(settings);

          final count = await server.countRuntimeSettingsRows(session);
          expect(count, equals(0));
        },
      );

      test(
        'when updateRuntimeSettings is called then the in-memory settings are updated.',
        () async {
          var settings = RuntimeSettingsBuilder()
              .withLogMalformedCalls(false)
              .build();

          await server.updateRuntimeSettings(settings);

          expect(server.runtimeSettings.logMalformedCalls, isFalse);
        },
      );
    },
  );
}

extension on Serverpod {
  Future<int> countRuntimeSettingsRows(Session session) async {
    return RuntimeSettings.db.count(session);
  }

  Future<void> clearRuntimeSettings(Session session) async {
    await RuntimeSettings.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
  }
}
