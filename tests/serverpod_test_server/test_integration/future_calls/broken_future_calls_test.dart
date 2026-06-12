import 'dart:async';
import 'dart:io';

import 'package:serverpod/protocol.dart' show FutureCallEntry;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/simple_data.dart';
import 'package:serverpod_test_server/test_util/logging_utils.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:serverpod/src/server/serverpod.dart';
import 'package:serverpod/src/server/command_line_args.dart';
import 'package:serverpod_shared/src/password_manager.dart';

class _SimpleFutureCall extends FutureCall<SimpleData> {
  @override
  Future<void> invoke(Session session, SimpleData? object) async {}
}

void main() {
  group(
    'Given a Serverpod server instance with default config'
    'and valid registered future calls in the database',
    () {
      late Serverpod server;
      late Session session;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 2;

      setUp(() async {
        server = IntegrationTestServer.create();
        session = await server.createSession(enableLogging: false);
        await LoggingUtil.clearAllLogs(session);

        for (int i = 0; i < futureCallsCount; i++) {
          final name = 'TestCall$i';
          final data = SimpleData(num: 1);

          var entry = FutureCallEntry(
            name: name,
            serializedObject: data.toString(),
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          server.registerFutureCall(_SimpleFutureCall(), name);
          entry = await FutureCallEntry.db.insertRow(session, entry);
          futureCallEntries.add(entry);
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
        await server.shutdown(exitProcess: false);
      });

      test(
        'when starting Serverpod, then no errors are logged',
        () async {
          await server.start();
          await server.internalLoggingSession.close();

          final logs = await LoggingUtil.findAllLogs(session);
          final logMessages =
              logs.lastOrNull?.logs.map((e) => e.message).toList() ?? [];

          expect(
            logMessages.where((message) => message.contains(r'TestCall\d')),
            isEmpty,
          );
        },
      );
    },
  );

  group(
    'Given a Serverpod server instance with default config and at least 1000'
    'future calls in the database containing unregistered and broken future calls',
    () {
      late Serverpod server;
      late Session session;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 1000;

      setUp(() async {
        server = IntegrationTestServer.create();
        session = await server.createSession(enableLogging: false);
        await LoggingUtil.clearAllLogs(session);

        for (int i = 0; i < futureCallsCount; i++) {
          final name = 'TestCall$i';
          final data = SimpleData(num: i);

          var entry = FutureCallEntry(
            name: name,
            serializedObject: i == 1 ? '{}' : data.toString(),
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          if (i != 0) server.registerFutureCall(_SimpleFutureCall(), name);
          entry = await FutureCallEntry.db.insertRow(session, entry);
          futureCallEntries.add(entry);
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
        await server.shutdown(exitProcess: false);
      });

      group('when starting Serverpod', () {
        setUp(() async {
          await server.start();
        });

        test(
          'then unregistered and broken future calls are not logged',
          () async {
            await server.internalLoggingSession.close();

            final logs = await LoggingUtil.findAllLogs(session);
            final logMessages =
                logs.lastOrNull?.logs.map((e) => e.message).toList() ?? [];

            expect(
              logMessages.where((message) => message.contains(r'TestCall\d')),
              isEmpty,
            );
          },
        );

        test(
          'then unregistered and broken future calls are not deleted from the database',
          () async {
            final entries = await FutureCallEntry.db.find(session);
            expect(entries, hasLength(futureCallsCount));
          },
        );

        test(
          'then a warning is logged about skipping the check for broken future calls',
          () async {
            await server.internalLoggingSession.close();
            final logs = await LoggingUtil.findAllLogs(session);
            final logEntry = logs.last.logs.first;

            expect(
              logEntry.message,
              matches(
                'Skipping automatic check for broken future calls due to high number of future calls in the database. '
                'Enable FutureCallConfig.checkBrokenCalls to always perform the check, regardless of the number of future calls. '
                'Optionally enable FutureCallConfig.deleteBrokenCalls to automatically delete broken future calls.',
              ),
            );
          },
        );
      });
    },
  );

  group(
    'Given a Serverpod server instance with default config and less than 1000'
    'future calls in the database containing unregistered and broken future calls',
    () {
      late Serverpod server;
      late Session session;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 999;

      setUp(() async {
        server = IntegrationTestServer.create();
        session = await server.createSession(enableLogging: false);
        await LoggingUtil.clearAllLogs(session);

        for (int i = 0; i < futureCallsCount; i++) {
          final data = SimpleData(num: i);

          final name = 'TestCall$i';
          var entry = FutureCallEntry(
            name: name,
            serializedObject: i == 1 ? '{}' : data.toString(),
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          if (i != 0) server.registerFutureCall(_SimpleFutureCall(), name);
          entry = await FutureCallEntry.db.insertRow(session, entry);
          futureCallEntries.add(entry);
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
        await server.shutdown(exitProcess: false);
      });

      group('when starting Serverpod', () {
        setUp(() async {
          await server.start();
        });

        test(
          'then unregistered future calls are logged',
          () async {
            await server.internalLoggingSession.close();
            final logs = await LoggingUtil.findAllLogs(session);
            final logEntry = logs.last.logs.first;

            expect(
              logEntry.message,
              matches(
                r'Unregistered future call: \{.*\"name\":\s*\"TestCall0\".*\}\n.*',
              ),
            );
          },
        );

        test(
          'then broken future calls are logged',
          () async {
            await server.internalLoggingSession.close();
            final logs = await LoggingUtil.findAllLogs(session);
            final logEntry = logs.last.logs.first;

            expect(
              logEntry.message,
              matches(
                r'.*Future call failed deserialization. Error: .* Entry: \{.*\"name\":\s*\"TestCall1\".*\}\n',
              ),
            );
          },
        );

        test(
          'then unregistered and broken future calls are not deleted from the database',
          () async {
            final entries = await FutureCallEntry.db.find(session);
            expect(entries, hasLength(futureCallsCount));
          },
        );
      });
    },
  );

  group(
    'Given a Serverpod server instance with checkBrokenCalls enabled'
    'in future call config and database contains unregistered broken future calls',
    () {
      late Serverpod server;
      late Session session;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 4;

      setUp(() async {
        server = IntegrationTestServer.create(
          config: _ServerpodConfigExtension.loadConfig().copyWith(
            futureCall: FutureCallConfig(checkBrokenCalls: true),
          ),
        );
        session = await server.createSession(enableLogging: false);
        await LoggingUtil.clearAllLogs(session);

        for (int i = 0; i < futureCallsCount; i++) {
          final name = 'TestCall$i';
          final data = SimpleData(num: i);

          var entry = FutureCallEntry(
            name: name,
            serializedObject: i >= 2 ? '{}' : data.toString(),
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          if (i >= 2) server.registerFutureCall(_SimpleFutureCall(), name);
          entry = await FutureCallEntry.db.insertRow(session, entry);
          futureCallEntries.add(entry);
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
        await server.shutdown(exitProcess: false);
      });

      group('when starting Serverpod', () {
        setUp(() async {
          await server.start();
        });

        test(
          'then unregistered future calls are logged',
          () async {
            await server.internalLoggingSession.close();
            final logs = await LoggingUtil.findAllLogs(session);
            final logEntry = logs.last.logs.first;

            expect(logEntry.logLevel, LogLevel.warning);
            expect(
              logEntry.message,
              matches(
                r'Unregistered future call: \{.*\"name\":\s*\"TestCall0\".*\}\n'
                r'Unregistered future call: \{.*\"name\":\s*\"TestCall1\".*\}\n.*',
              ),
            );
          },
        );

        test(
          'then broken future calls are logged',
          () async {
            await server.internalLoggingSession.close();
            final logs = await LoggingUtil.findAllLogs(session);
            final logEntry = logs.last.logs.first;

            expect(logEntry.logLevel, LogLevel.warning);
            expect(
              logEntry.message,
              matches(
                r'.*Future call failed deserialization. Error: .* Entry: \{.*\"name\":\s*\"TestCall2\".*\}\n'
                r'Future call failed deserialization. Error: .* Entry: \{.*\"name\":\s*\"TestCall3\".*\}\n',
              ),
            );
          },
        );
      });
    },
  );

  group(
    'Given a Serverpod server instance with checkBrokenCalls disabled'
    'in future call config and database contains unregistered and broken future calls',
    () {
      late Serverpod server;
      late Session session;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 4;

      setUp(() async {
        server = IntegrationTestServer.create(
          config: _ServerpodConfigExtension.loadConfig().copyWith(
            futureCall: FutureCallConfig(checkBrokenCalls: false),
          ),
        );
        session = await server.createSession(enableLogging: false);
        await LoggingUtil.clearAllLogs(session);

        for (int i = 0; i < futureCallsCount; i++) {
          final name = 'TestCall$i';
          final data = SimpleData(num: i);

          var entry = FutureCallEntry(
            name: name,
            serializedObject: i >= 2 ? '{}' : data.toString(),
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          if (i >= 2) server.registerFutureCall(_SimpleFutureCall(), name);
          entry = await FutureCallEntry.db.insertRow(session, entry);
          futureCallEntries.add(entry);
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
        await server.shutdown(exitProcess: false);
      });

      test(
        'when starting Serverpod, then unregistered and broken future calls are not logged',
        () async {
          await server.start();
          await server.internalLoggingSession.close();

          final logs = await LoggingUtil.findAllLogs(session);
          final logMessages =
              logs.lastOrNull?.logs.map((e) => e.message).toList() ?? [];

          expect(
            logMessages.where((message) => message.contains(r'TestCall\d')),
            isEmpty,
          );
        },
      );
    },
  );

  group(
    'Given a Serverpod server instance with deleteBrokenCalls disabled'
    'in future call config and database contains unregistered and broken future calls',
    () {
      late Serverpod server;
      late Session session;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 4;

      setUp(() async {
        server = IntegrationTestServer.create(
          config: _ServerpodConfigExtension.loadConfig().copyWith(
            futureCall: FutureCallConfig(deleteBrokenCalls: false),
          ),
        );
        session = await server.createSession(enableLogging: false);
        await LoggingUtil.clearAllLogs(session);

        for (int i = 0; i < futureCallsCount; i++) {
          final name = 'TestCall$i';
          final data = SimpleData(num: i);

          var entry = FutureCallEntry(
            name: name,
            serializedObject: i >= 2 ? '{}' : data.toString(),
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          if (i >= 2) server.registerFutureCall(_SimpleFutureCall(), name);
          entry = await FutureCallEntry.db.insertRow(session, entry);
          futureCallEntries.add(entry);
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
        await server.shutdown(exitProcess: false);
      });

      test(
        'when starting Serverpod, then unregistered and broken future calls are not deleted from the database',
        () async {
          await server.start();
          final entries = await FutureCallEntry.db.find(session);
          expect(entries, hasLength(futureCallsCount));
        },
      );
    },
  );

  group(
    'Given a Serverpod server instance with deleteBrokenCalls enabled'
    'in future call config and database contains unregistered future calls',
    () {
      late Serverpod server;
      late Session session;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 3;

      setUp(() async {
        server = IntegrationTestServer.create(
          config: _ServerpodConfigExtension.loadConfig().copyWith(
            futureCall: FutureCallConfig(deleteBrokenCalls: true),
          ),
        );
        session = await server.createSession(enableLogging: false);
        await LoggingUtil.clearAllLogs(session);

        for (int i = 0; i < futureCallsCount; i++) {
          final name = 'TestCall$i';
          final data = SimpleData(num: i);

          var entry = FutureCallEntry(
            name: name,
            serializedObject: data.toString(),
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          if (i == 2) server.registerFutureCall(_SimpleFutureCall(), name);
          entry = await FutureCallEntry.db.insertRow(session, entry);
          futureCallEntries.add(entry);
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
        await server.shutdown(exitProcess: false);
      });

      test(
        'when starting Serverpod, then unregistered future calls are deleted from the database',
        () async {
          var entries = await FutureCallEntry.db.find(session);
          var entryNames = entries.map((e) => e.name).toList();

          expect(
            entryNames,
            containsAll(['TestCall0', 'TestCall1', 'TestCall2']),
          );

          await server.start();

          entries = await FutureCallEntry.db.find(session);
          entryNames = entries.map((e) => e.name).toList();

          expect(entryNames, containsAll(['TestCall2']));
        },
      );
    },
  );

  group(
    'Given a Serverpod server instance with deleteBrokenCalls enabled'
    'in future call config and broken future calls',
    () {
      late Serverpod server;
      late Session session;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 3;

      setUp(() async {
        server = IntegrationTestServer.create(
          config: _ServerpodConfigExtension.loadConfig().copyWith(
            futureCall: FutureCallConfig(deleteBrokenCalls: true),
          ),
        );
        session = await server.createSession(enableLogging: false);
        await LoggingUtil.clearAllLogs(session);

        for (int i = 0; i < futureCallsCount; i++) {
          final name = 'TestCall$i';
          final data = SimpleData(num: i);

          var entry = FutureCallEntry(
            name: name,
            serializedObject: i == 2 ? data.toString() : '{}',
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          server.registerFutureCall(_SimpleFutureCall(), name);
          entry = await FutureCallEntry.db.insertRow(session, entry);
          futureCallEntries.add(entry);
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
        await server.shutdown(exitProcess: false);
      });

      test(
        'when starting Serverpod, then broken future calls are deleted from the database',
        () async {
          var entries = await FutureCallEntry.db.find(session);
          var entryNames = entries.map((e) => e.name).toList();

          expect(
            entryNames,
            containsAll(['TestCall0', 'TestCall1', 'TestCall2']),
          );

          await server.start();

          entries = await FutureCallEntry.db.find(session);
          entryNames = entries.map((e) => e.name).toList();

          expect(entryNames, containsAll(['TestCall2']));
        },
      );
    },
  );
}

extension _ServerpodConfigExtension on ServerpodConfig {
  static ServerpodConfig loadConfig() {
    final runMode =
        Platform.environment['INTEGRATION_TEST_SERVERPOD_MODE'] ?? 'production';

    return ServerpodConfig.load(
      runMode,
      'default',
      PasswordManager(runMode: runMode).loadPasswords(),
      commandLineArgs: CommandLineArgs([
        '-m',
        runMode,
      ]).toMap(),
    );
  }
}
