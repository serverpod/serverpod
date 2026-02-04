import 'dart:io';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/builders/runtime_settings_builder.dart';
import 'package:serverpod_test_server/test_util/logging_utils.dart';
import 'package:serverpod_test_server/test_util/mock_stdout.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() {
  late Serverpod server;
  late Session session;

  group(
    'Given log cleanup is configured with only retention period for a database with both old and recent log entries',
    () {
      const numOldEntries = 50;
      const numRecentEntries = 3;

      setUp(() async {
        (server, session) = await createTestServer(
          SessionLogConfig(
            persistentEnabled: true,
            consoleEnabled: false,
            cleanupInterval: const Duration(seconds: 1),
            retentionPeriod: const Duration(days: 1),
            retentionCount: null,
          ),
        );

        final now = DateTime.now();
        final oldTime = now.subtract(const Duration(days: 2));
        final recentTime = now.subtract(const Duration(hours: 12));

        final oldEntries = List.generate(
          numOldEntries,
          (i) => SessionLogEntry(
            serverId: 'test_server',
            time: oldTime.add(Duration(minutes: i)),
            touched: oldTime.add(Duration(minutes: i)),
            endpoint: 'test',
          ),
        );

        final recentEntries = List.generate(
          numRecentEntries,
          (i) => SessionLogEntry(
            serverId: 'test_server',
            time: recentTime.add(Duration(minutes: i)),
            touched: recentTime.add(Duration(minutes: i)),
            endpoint: 'test',
          ),
        );

        await SessionLogEntry.db.insert(session, oldEntries);
        await SessionLogEntry.db.insert(session, recentEntries);
      });

      group('when cleanup is triggered', () {
        late MockStdout record;

        setUp(() async {
          record = MockStdout();

          await IOOverrides.runZoned(
            () async {
              final testSession = await server.createSession(
                enableLogging: true,
              );
              testSession.log('Trigger cleanup');
              await testSession.close();
            },
            stdout: () => record,
          );
        });

        test(
          'then only entries newer than the cleanup interval should be kept.',
          () async {
            final allLogs = await SessionLogEntry.db.find(session);

            // We can't match the exact number of entries since the cleanup
            // triggers a delete query that can be logged if it runs faster
            // than the close log call. So it is possible to have up to 2 extra
            // entries: the one that triggered the cleanup and the delete query.
            expect(allLogs.length, lessThanOrEqualTo(numRecentEntries + 2));
          },
        );

        test(
          'then a message is printed to stdout with the number of entries deleted.',
          () async {
            expect(
              record.output,
              matches(
                r'.*Cleaned up \d+ log entries from "serverpod_session_log" older than 24:00:00\.000000\..*',
              ),
            );
          },
        );
      });
    },
  );

  group(
    'Given log cleanup is configured with only retention count for a database with more entries than the retention count',
    () {
      const numEntries = 50;
      const retentionCount = 10;

      setUp(() async {
        (server, session) = await createTestServer(
          SessionLogConfig(
            persistentEnabled: true,
            consoleEnabled: false,
            cleanupInterval: const Duration(seconds: 1),
            retentionPeriod: null,
            retentionCount: retentionCount,
          ),
        );

        final now = DateTime.now();
        final recentTime = now.subtract(const Duration(hours: 12));

        final entries = List.generate(
          numEntries,
          (i) => SessionLogEntry(
            serverId: 'test_server',
            time: recentTime.add(Duration(minutes: i)),
            touched: recentTime.add(Duration(minutes: i)),
            endpoint: 'test',
          ),
        );

        await SessionLogEntry.db.insert(session, entries);
      });

      group('when cleanup is triggered', () {
        late MockStdout record;

        setUp(() async {
          record = MockStdout();

          await IOOverrides.runZoned(
            () async {
              final testSession = await server.createSession(
                enableLogging: true,
              );
              testSession.log('Trigger cleanup');
              await testSession.close();
            },
            stdout: () => record,
          );
        });

        test(
          'then the retention count number of entries should be kept.',
          () async {
            final allLogs = await SessionLogEntry.db.find(session);

            // We can't match the exact number of entries since the cleanup
            // triggers a delete query that can be logged if it runs faster
            // than the close log call. So it is possible to have up to 2 extra
            // entries: the one that triggered the cleanup and the delete query.
            expect(allLogs.length, lessThanOrEqualTo(retentionCount + 2));
          },
        );

        test(
          'then a message is printed to stdout with the number of entries deleted.',
          () async {
            expect(
              record.output,
              matches(
                r'.*Cleaned up \d+ log entries from "serverpod_session_log" exceeding the retention count of \d+\..*',
              ),
            );
          },
        );
      });
    },
  );

  group(
    'Given log cleanup is configured with both retention period and retention count for a database with more recent entries than the retention count',
    () {
      const numRecentEntries = 50;
      const retentionCount = 10;

      setUp(() async {
        (server, session) = await createTestServer(
          SessionLogConfig(
            persistentEnabled: true,
            consoleEnabled: false,
            cleanupInterval: const Duration(seconds: 1),
            retentionPeriod: const Duration(days: 1),
            retentionCount: retentionCount,
          ),
        );

        final now = DateTime.now();
        final recentTime = now.subtract(const Duration(hours: 12));

        final recentEntries = List.generate(
          numRecentEntries,
          (i) => SessionLogEntry(
            serverId: 'test_server',
            time: recentTime.add(Duration(minutes: i)),
            touched: recentTime.add(Duration(minutes: i)),
            endpoint: 'test',
          ),
        );

        await SessionLogEntry.db.insert(session, recentEntries);
      });

      group('when cleanup is triggered', () {
        setUp(() async {
          final testSession = await server.createSession(enableLogging: true);
          testSession.log('Trigger cleanup');
          await testSession.close();
        });

        test(
          'then the retention count number of entries should be kept.',
          () async {
            final allLogs = await SessionLogEntry.db.find(session);

            // We can't match the exact number of entries since the cleanup
            // triggers a delete query that can be logged if it runs faster
            // than the close log call. So it is possible to have up to 3 extra
            // entries: the one that triggered the cleanup and 2 delete queries.
            expect(allLogs.length, lessThanOrEqualTo(retentionCount + 3));
          },
        );
      });
    },
  );

  group(
    'Given log cleanup is configured with both retention period and retention count for a database with more entries than the retention count but less recent entries than the retention count',
    () {
      const numOldEntries = 50;
      const numRecentEntries = 3;
      const retentionCount = 10;

      setUp(() async {
        (server, session) = await createTestServer(
          SessionLogConfig(
            persistentEnabled: true,
            consoleEnabled: false,
            cleanupInterval: const Duration(seconds: 1),
            retentionPeriod: const Duration(days: 1),
            retentionCount: retentionCount,
          ),
        );

        final now = DateTime.now();
        final oldTime = now.subtract(const Duration(days: 2));
        final recentTime = now.subtract(const Duration(hours: 12));

        final oldEntries = List.generate(
          numOldEntries,
          (i) => SessionLogEntry(
            serverId: 'test_server',
            time: oldTime.add(Duration(minutes: i)),
            touched: oldTime.add(Duration(minutes: i)),
            endpoint: 'test',
          ),
        );

        final recentEntries = List.generate(
          numRecentEntries,
          (i) => SessionLogEntry(
            serverId: 'test_server',
            time: recentTime.add(Duration(minutes: i)),
            touched: recentTime.add(Duration(minutes: i)),
            endpoint: 'test',
          ),
        );

        await SessionLogEntry.db.insert(session, oldEntries);
        await SessionLogEntry.db.insert(session, recentEntries);
      });

      group('when cleanup is triggered', () {
        setUp(() async {
          final testSession = await server.createSession(enableLogging: true);
          testSession.log('Trigger cleanup');
          await testSession.close();
        });

        test(
          'then only the recent entries should be kept.',
          () async {
            final allLogs = await SessionLogEntry.db.find(session);

            // We can't match the exact number of entries since the cleanup
            // triggers a delete query that can be logged if it runs faster
            // than the close log call. So it is possible to have up to 3 extra
            // entries: the one that triggered the cleanup and 2 delete queries.
            expect(allLogs.length, lessThanOrEqualTo(numRecentEntries + 3));
            expect(allLogs.length, lessThan(retentionCount));
          },
        );
      });
    },
  );

  group(
    'Given log cleanup is configured to a cleanup interval that has not yet passed and more entries were added after last cleanup',
    () {
      const numFirstEntries = 5;
      const numSecondEntries = 50;
      const retentionCount = 10;

      setUp(() async {
        (server, session) = await createTestServer(
          SessionLogConfig(
            persistentEnabled: true,
            consoleEnabled: false,
            cleanupInterval: const Duration(seconds: 10),
            retentionPeriod: const Duration(days: 1),
            retentionCount: retentionCount,
          ),
        );

        final now = DateTime.now();
        final recentTime = now.subtract(const Duration(hours: 12));

        final recentEntries = List.generate(
          numFirstEntries,
          (i) => SessionLogEntry(
            serverId: 'test_server',
            time: recentTime.add(Duration(minutes: i)),
            touched: recentTime.add(Duration(minutes: i)),
            endpoint: 'test',
          ),
        );

        await SessionLogEntry.db.insert(session, recentEntries);

        final record = MockStdout();

        // Trigger first cleanup
        await IOOverrides.runZoned(
          () async {
            final testSession = await server.createSession(
              enableLogging: true,
            );
            testSession.log('Trigger cleanup');
            await testSession.close();
          },
          stdout: () => record,
        );

        // Wait for first cleanup to complete
        await Future.doWhile(() async {
          await Future.delayed(const Duration(milliseconds: 100));
          return !record.output.contains('Cleaned up');
        }).timeout(const Duration(seconds: 3));

        // Add more entries
        final secondEntries = List.generate(
          numSecondEntries,
          (i) => SessionLogEntry(
            serverId: 'test_server',
            time: recentTime.add(Duration(minutes: i)),
            touched: recentTime.add(Duration(minutes: i)),
            endpoint: 'test',
          ),
        );

        await SessionLogEntry.db.insert(session, secondEntries);
      });

      group('when a log entry is added', () {
        setUp(() async {
          final testSession = await server.createSession(enableLogging: true);
          testSession.log('Do not trigger cleanup');
          await testSession.close();
        });

        test(
          'then the cleanup is not triggered and all entries are present.',
          () async {
            final allLogs = await SessionLogEntry.db.find(session);

            expect(
              allLogs.length,
              greaterThanOrEqualTo(numFirstEntries + numSecondEntries + 1),
            );
          },
        );
      });
    },
  );

  group(
    'Given log cleanup is configured with persistent logging disabled and the database has more entries than the retention count',
    () {
      const numEntries = 50;
      const retentionCount = 10;

      setUp(() async {
        (server, session) = await createTestServer(
          SessionLogConfig(
            persistentEnabled: false,
            consoleEnabled: false,
            cleanupInterval: const Duration(seconds: 1),
            retentionPeriod: const Duration(days: 1),
            retentionCount: retentionCount,
          ),
        );

        final now = DateTime.now();
        final recentTime = now.subtract(const Duration(hours: 12));

        final recentEntries = List.generate(
          numEntries,
          (i) => SessionLogEntry(
            serverId: 'test_server',
            time: recentTime.add(Duration(minutes: i)),
            touched: recentTime.add(Duration(minutes: i)),
            endpoint: 'test',
          ),
        );

        await SessionLogEntry.db.insert(session, recentEntries);
      });

      group('when a log entry is added', () {
        setUp(() async {
          final testSession = await server.createSession(enableLogging: true);
          testSession.log('Trigger cleanup');
          await testSession.close();
        });

        test(
          'then the cleanup is not triggered and all entries are present.',
          () async {
            final allLogs = await SessionLogEntry.db.find(session);

            // With persistent logging disabled, the entry that could trigger
            // cleanup is not persisted, so we expect only previous entries to
            // be present.
            expect(allLogs.length, equals(numEntries));
          },
        );
      });
    },
  );

  group(
    'Given log cleanup is configured with no cleanup interval and the database has more entries than the retention count',
    () {
      const numEntries = 50;
      const retentionCount = 10;

      setUp(() async {
        (server, session) = await createTestServer(
          SessionLogConfig(
            persistentEnabled: true,
            consoleEnabled: false,
            cleanupInterval: null,
            retentionPeriod: const Duration(days: 1),
            retentionCount: retentionCount,
          ),
        );

        final now = DateTime.now();
        final recentTime = now.subtract(const Duration(hours: 12));

        final recentEntries = List.generate(
          numEntries,
          (i) => SessionLogEntry(
            serverId: 'test_server',
            time: recentTime.add(Duration(minutes: i)),
            touched: recentTime.add(Duration(minutes: i)),
            endpoint: 'test',
          ),
        );

        await SessionLogEntry.db.insert(session, recentEntries);
      });

      group('when a log entry is added', () {
        setUp(() async {
          final testSession = await server.createSession(enableLogging: true);
          testSession.log('Trigger cleanup');
          await testSession.close();
        });

        test(
          'then the cleanup is not triggered and all entries are present.',
          () async {
            final allLogs = await SessionLogEntry.db.find(session);

            expect(allLogs.length, equals(numEntries + 1));
          },
        );
      });
    },
  );
}

Future<(Serverpod, Session)> createTestServer(
  SessionLogConfig sessionLogConfig,
) async {
  final server = IntegrationTestServer.create(
    config: ServerpodConfig(
      runMode: 'production',
      apiServer: ServerConfig(
        port: 8080,
        publicHost: 'localhost',
        publicPort: 8080,
        publicScheme: 'http',
      ),
      database: DatabaseConfig(
        host: 'postgres',
        port: 5432,
        user: 'postgres',
        password: 'password',
        name: 'serverpod_test',
      ),
      sessionLogs: sessionLogConfig,
    ),
  );

  final settings = RuntimeSettingsBuilder().build();
  await server.updateRuntimeSettings(settings);

  await server.start();
  final session = await server.createSession(enableLogging: false);
  await LoggingUtil.clearAllLogs(session);

  addTearDown(() async {
    await session.close();
    await server.shutdown(exitProcess: false);
  });

  return (server, session);
}
