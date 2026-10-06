import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:serverpod/src/server/serverpod.dart';
import 'package:serverpod_shared/log.dart' as shared;
import 'package:serverpod_shared/serverpod_shared.dart' show ServerpodRole;
import 'package:test/test.dart';

import 'test_helpers/empty_endpoints.dart';

final _portZeroConfig = ServerConfig(
  port: 0,
  publicScheme: 'http',
  publicHost: 'localhost',
  publicPort: 0,
);

void main() {
  late Directory tempDir;
  late Serverpod pod;
  late shared.TestLogWriter logWriter;

  // Only the runtime settings table exists, so the rest of the target
  // database is missing and the integrity verification fails, while loading
  // the runtime settings during startup still succeeds.
  Future<Serverpod> createPod({
    ServerpodRole role = ServerpodRole.monolith,
    bool applyMigrations = false,
  }) async {
    final pod = Serverpod(
      [],
      internal.Protocol(),
      EmptyEndpoints(),
      config: ServerpodConfig(
        apiServer: _portZeroConfig,
        webServer: _portZeroConfig,
        database: SqliteDatabaseConfig(
          filePath: p.join(tempDir.path, 'test.db'),
        ),
        role: role,
        applyMigrations: applyMigrations,
        healthCheckInterval: Duration.zero,
        futureCall: const FutureCallConfig(enabled: false),
      ),
      serverDirectory: tempDir,
    );

    await pod.internalSession.db.unsafeExecute('''
      CREATE TABLE "serverpod_runtime_settings" (
        "id" integer PRIMARY KEY AUTOINCREMENT,
        "logSettings" text NOT NULL,
        "logSettingsOverrides" text NOT NULL,
        "logServiceCalls" integer NOT NULL,
        "logMalformedCalls" integer NOT NULL
      )
    ''');

    return pod;
  }

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('db_integrity_failure_');
    logWriter = shared.TestLogWriter();
    shared.logWriter.add(logWriter);
  });

  tearDown(() async {
    shared.logWriter.remove(logWriter);
    await pod.shutdown(exitProcess: false);
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Given a database that does not match the target state', () {
    test(
      'when starting Serverpod, '
      'then the server starts instead of exiting.',
      () async {
        pod = await createPod();

        await expectLater(pod.start(runInGuardedZone: false), completes);
      },
    );

    test(
      'when starting Serverpod, '
      'then the failure is logged as an error.',
      () async {
        pod = await createPod();

        await pod.start(runInGuardedZone: false);
        await shared.log.flush();

        expect(
          logWriter.entries.where(
            (e) =>
                e.level == shared.LogLevel.error &&
                e.message.contains('Failed to apply database migrations'),
          ),
          isNotEmpty,
        );
      },
    );

    test(
      'when starting the maintenance role applying migrations, '
      'then it exits with code 1.',
      () async {
        pod = await createPod(
          role: ServerpodRole.maintenance,
          applyMigrations: true,
        );

        await expectLater(
          pod.start(runInGuardedZone: false),
          throwsA(
            isA<ExitException>().having((e) => e.exitCode, 'exitCode', 1),
          ),
        );
      },
    );
  });
}
