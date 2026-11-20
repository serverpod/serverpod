import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
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
  group('Given a database that does not match the target state,', () {
    late Directory tempDir;
    late Serverpod pod;
    late shared.TestLogWriter logWriter;

    // The SQLite database is empty, so the integrity verification fails.
    Serverpod createPod({
      ServerpodRole role = ServerpodRole.monolith,
      bool applyMigrations = false,
    }) {
      return Serverpod(
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

    test(
      'when starting Serverpod, '
      'then the server starts instead of exiting.',
      () async {
        pod = createPod();

        await expectLater(pod.start(), completes);
      },
    );

    test(
      'when starting Serverpod, '
      'then the mismatch is logged as a warning.',
      () async {
        pod = createPod();

        await pod.start();
        await shared.log.flush();

        expect(
          logWriter.entries.where(
            (e) =>
                e.level == shared.LogLevel.warning &&
                e.message.contains('does not match the target database'),
          ),
          isNotEmpty,
        );
      },
    );

    test(
      'when starting the maintenance role applying migrations, '
      'then it exits with code 1.',
      () async {
        pod = createPod(
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
