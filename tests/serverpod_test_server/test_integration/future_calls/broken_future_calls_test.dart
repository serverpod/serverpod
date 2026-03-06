import 'dart:async';
import 'dart:io';

import 'package:serverpod/protocol.dart' show FutureCallEntry;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/future_call_manager/future_call_diagnostics_service.dart';
import 'package:serverpod_test_server/src/generated/simple_data.dart';
import 'package:serverpod_test_server/test_util/custom_matcher.dart';
import 'package:serverpod_test_server/test_util/logging_utils.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:serverpod/src/server/serverpod.dart';
import 'package:serverpod/src/server/command_line_args.dart';
import 'package:serverpod_shared/src/password_manager.dart';

import '../test_tools/serverpod_test_tools.dart';
import '../utils/future_call_manager_builder.dart';

class MockDiagnosticsService implements FutureCallDiagnosticsService {
  @override
  void submitCallException(
    Object error,
    StackTrace stackTrace, {
    required Session session,
  }) {}

  @override
  void submitFrameworkException(
    Object error,
    StackTrace stackTrace, {
    String? message,
  }) {}
}

class SimpleFutureCall extends FutureCall<SimpleData> {
  @override
  Future<void> invoke(Session session, SimpleData? object) async {}
}

void main() {
  group(
    'Given a FutureCallManager with checkBrokenCalls enabled and only valid future calls',
    () {
      late Serverpod server;
      late Session session;
      late Session logSession;
      late FutureCallManager futureCallManager;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 2;

      setUp(() async {
        server = IntegrationTestServer.create();
        await server.start();

        session = await server.createSession(enableLogging: false);
        logSession = await server.createSession();
        await LoggingUtil.clearAllLogs(session);

        futureCallManager =
            FutureCallManagerBuilder(
                  sessionProvider: (futureCallName) => session,
                  internalSession: session,
                  logSession: logSession,
                )
                .withConfig(FutureCallConfig(checkBrokenCalls: true))
                .withDiagnosticsService(MockDiagnosticsService())
                .build();

        for (int i = 0; i < futureCallsCount; i++) {
          final data = SimpleData(num: i);
          final entry = FutureCallEntry(
            id: i,
            name: 'TestCall$i',
            serializedObject: data.toString(),
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          futureCallEntries.add(entry);
          await FutureCallEntry.db.insertRow(session, entry);

          futureCallManager.registerFutureCall(
            SimpleFutureCall(),
            'TestCall$i',
          );
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
        await server.shutdown(exitProcess: false);
      });

      test('when calling start then no errors are logged', () async {
        await futureCallManager.start();
        await logSession.close();

        final logs = await LoggingUtil.findAllLogs(session);
        final logEntry = logs.last.logs.first;

        expect(
          logEntry.message,
          notMatches(
            r'Unregistered future call: \{.*\"name\":\s*\"TestCall0\".*\}\n'
            r'Unregistered future call: \{.*\"name\":\s*\"TestCall1\".*\}\n',
          ),
        );

        expect(
          logEntry.message,
          notMatches(
            r'Future call failed deserialization. Error: .* Entry: \{.*\"name\":\s*\"TestCall0\".*\}\n'
            r'Future call failed deserialization. Error: .* Entry: \{.*\"name\":\s*\"TestCall1\".*\}\n',
          ),
        );
      });
    },
  );

  group(
    'Given a FutureCallManager with checkBrokenCalls enabled and unregistered future calls',
    () {
      late Serverpod server;
      late Session session;
      late Session logSession;
      late FutureCallManager futureCallManager;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 2;

      setUp(() async {
        server = IntegrationTestServer.create();
        await server.start();

        session = await server.createSession(enableLogging: false);
        logSession = await server.createSession();
        await LoggingUtil.clearAllLogs(session);

        futureCallManager =
            FutureCallManagerBuilder(
                  sessionProvider: (futureCallName) => session,
                  internalSession: session,
                  logSession: logSession,
                )
                .withConfig(FutureCallConfig(checkBrokenCalls: true))
                .withDiagnosticsService(MockDiagnosticsService())
                .build();

        for (int i = 0; i < futureCallsCount; i++) {
          final data = SimpleData(num: i);
          final entry = FutureCallEntry(
            id: i,
            name: 'TestCall$i',
            serializedObject: data.toString(),
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          futureCallEntries.add(entry);
          await FutureCallEntry.db.insertRow(session, entry);
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
        await logSession.close();
        await server.shutdown(exitProcess: false);
      });

      test(
        'when calling start then unregistered future calls are logged',
        () async {
          await futureCallManager.start();
          await logSession.close();

          final logs = await LoggingUtil.findAllLogs(session);
          final logEntry = logs.last.logs.first;

          expect(
            logEntry.message,
            matches(
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall0\".*\}\n'
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall1\".*\}\n',
            ),
          );
        },
      );

      test(
        'when calling start then unregistered future calls are not deleted from the database',
        () async {
          await futureCallManager.start();

          final entries = await FutureCallEntry.db.find(session);
          final entryNames = entries.map((e) => e.name).toList();

          expect(entryNames, containsAll(['TestCall0', 'TestCall1']));
        },
      );
    },
  );

  withServerpod(
    'Given a FutureCallManager with deleteBrokenCalls enabled and unregistered future calls',
    (sessionBuilder, _) {
      late Session session;
      late FutureCallManager futureCallManager;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 2;

      setUp(() async {
        session = sessionBuilder.build();

        futureCallManager =
            FutureCallManagerBuilder(
                  sessionProvider: (futureCallName) => session,
                  internalSession: session,
                )
                .withConfig(FutureCallConfig(deleteBrokenCalls: true))
                .withDiagnosticsService(MockDiagnosticsService())
                .build();

        for (int i = 0; i < futureCallsCount; i++) {
          final data = SimpleData(num: i);
          final entry = FutureCallEntry(
            id: i,
            name: 'TestCall$i',
            serializedObject: data.toString(),
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          futureCallEntries.add(entry);
          await FutureCallEntry.db.insertRow(session, entry);
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
      });

      test(
        'when calling start then unregistered future calls are deleted from the database',
        () async {
          await futureCallManager.start();
          final entries = await FutureCallEntry.db.find(session);
          expect(entries, isEmpty);
        },
      );
    },
  );

  group(
    'Given a FutureCallManager with checkBrokenCalls enabled and broken future calls',
    () {
      late Serverpod server;
      late Session session;
      late Session logSession;
      late FutureCallManager futureCallManager;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 2;

      setUp(() async {
        server = IntegrationTestServer.create();
        await server.start();

        session = await server.createSession(enableLogging: false);
        logSession = await server.createSession();
        await LoggingUtil.clearAllLogs(session);

        futureCallManager =
            FutureCallManagerBuilder(
                  sessionProvider: (futureCallName) => session,
                  internalSession: session,
                  logSession: logSession,
                )
                .withConfig(FutureCallConfig(checkBrokenCalls: true))
                .withDiagnosticsService(MockDiagnosticsService())
                .build();

        for (int i = 0; i < futureCallsCount; i++) {
          final name = 'TestCall$i';
          final entry = FutureCallEntry(
            id: i,
            name: name,
            serializedObject: '{}',
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          futureCallEntries.add(entry);
          await FutureCallEntry.db.insertRow(session, entry);
          futureCallManager.registerFutureCall(SimpleFutureCall(), name);
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
        await logSession.close();
        await server.shutdown(exitProcess: false);
      });

      test(
        'when calling start then broken future calls are logged',
        () async {
          await futureCallManager.start();
          await logSession.close();

          final logs = await LoggingUtil.findAllLogs(session);
          final logEntry = logs.last.logs.first;

          expect(
            logEntry.message,
            matches(
              r'Future call failed deserialization. Error: .* Entry: \{.*\"name\":\s*\"TestCall0\".*\}\n'
              r'Future call failed deserialization. Error: .* Entry: \{.*\"name\":\s*\"TestCall1\".*\}\n',
            ),
          );
        },
      );

      test(
        'when calling start then broken future calls are not deleted from the database',
        () async {
          await futureCallManager.start();

          final entries = await FutureCallEntry.db.find(session);
          final entryNames = entries.map((e) => e.name).toList();

          expect(entryNames, containsAll(['TestCall0', 'TestCall1']));
        },
      );
    },
  );

  withServerpod(
    'Given a FutureCallManager with deleteBrokenCalls enabled and broken future calls',
    (sessionBuilder, _) {
      late Session session;
      late FutureCallManager futureCallManager;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 2;

      setUp(() async {
        session = sessionBuilder.build();

        futureCallManager =
            FutureCallManagerBuilder(
                  sessionProvider: (futureCallName) => session,
                  internalSession: session,
                )
                .withConfig(FutureCallConfig(deleteBrokenCalls: true))
                .withDiagnosticsService(MockDiagnosticsService())
                .build();

        for (int i = 0; i < futureCallsCount; i++) {
          final name = 'TestCall$i';
          final entry = FutureCallEntry(
            id: i,
            name: name,
            serializedObject: '{}',
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          futureCallEntries.add(entry);
          await FutureCallEntry.db.insertRow(session, entry);
          futureCallManager.registerFutureCall(SimpleFutureCall(), name);
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
      });

      test(
        'when calling start then broken future calls are deleted from the database',
        () async {
          await futureCallManager.start();
          final entries = await FutureCallEntry.db.find(session);
          expect(entries, isEmpty);
        },
      );
    },
  );

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

          final entry = FutureCallEntry(
            id: i,
            name: name,
            serializedObject: data.toString(),
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          server.registerFutureCall(SimpleFutureCall(), name);
          futureCallEntries.add(entry);
          await FutureCallEntry.db.insertRow(session, entry);
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
          final logEntry = logs.lastOrNull?.logs.firstOrNull;

          expect(
            logEntry?.message,
            notMatches(
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall0\".*\}\n'
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall1\".*\}\n',
            ),
          );

          expect(
            logEntry?.message,
            notMatches(
              r'Future call failed deserialization. Error: .* Entry: \{.*\"name\":\s*\"TestCall0\".*\}\n'
              r'Future call failed deserialization. Error: .* Entry: \{.*\"name\":\s*\"TestCall1\".*\}\n',
            ),
          );
        },
      );
    },
  );

  group(
    'Given a Serverpod server instance with default config and at least 1000'
    'future calls in the database with at least 1 unregistered future call',
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
          final entry = FutureCallEntry(
            id: i,
            name: name,
            serializedObject: '{}',
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          if (i != 0) server.registerFutureCall(SimpleFutureCall(), name);
          futureCallEntries.add(entry);
          await FutureCallEntry.db.insertRow(session, entry);
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
        await server.shutdown(exitProcess: false);
      });

      test(
        'when starting Serverpod, then unregistered future calls are not logged',
        () async {
          await server.start();
          await server.internalLoggingSession.close();

          final logs = await LoggingUtil.findAllLogs(session);
          final logEntry = logs.lastOrNull?.logs.firstOrNull;

          expect(
            logEntry?.message,
            notMatches(
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall0\".*\}\n',
            ),
          );
        },
      );

      test(
        'when starting Serverpod, then unregistered future calls are not deleted from the database',
        () async {
          await server.start();
          final entries = await FutureCallEntry.db.find(session);
          expect(entries, hasLength(futureCallsCount));
        },
      );
    },
  );

  group(
    'Given a Serverpod server instance with default config and less than 1000'
    'future calls in the database with at least 1 unregistered future call',
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
          final name = 'TestCall$i';
          final entry = FutureCallEntry(
            id: i,
            name: name,
            serializedObject: '{}',
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          if (i != 0) server.registerFutureCall(SimpleFutureCall(), name);
          futureCallEntries.add(entry);
          await FutureCallEntry.db.insertRow(session, entry);
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
        await server.shutdown(exitProcess: false);
      });

      test(
        'when starting Serverpod, then unregistered future calls are logged',
        () async {
          await server.start();
          await server.internalLoggingSession.close();

          final logs = await LoggingUtil.findAllLogs(session);
          final logEntry = logs.last.logs.first;

          expect(
            logEntry.message,
            matches(
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall0\".*\}\n',
            ),
          );
        },
      );

      test(
        'when starting Serverpod, then unregistered future calls are not deleted from the database',
        () async {
          await server.start();
          final entries = await FutureCallEntry.db.find(session);
          expect(entries, hasLength(futureCallsCount));
        },
      );
    },
  );

  group(
    'Given a Serverpod server instance with default config and at least 1000 registered'
    'future calls in the database with at least 1 broken future call',
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

          final entry = FutureCallEntry(
            id: i,
            name: name,
            serializedObject: i == 0 ? '{}' : data.toString(),
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          server.registerFutureCall(SimpleFutureCall(), name);
          futureCallEntries.add(entry);
          await FutureCallEntry.db.insertRow(session, entry);
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
        await server.shutdown(exitProcess: false);
      });

      test(
        'when starting Serverpod, then broken future calls are not logged',
        () async {
          await server.start();
          await server.internalLoggingSession.close();

          final logs = await LoggingUtil.findAllLogs(session);
          final logEntry = logs.lastOrNull?.logs.firstOrNull;

          expect(
            logEntry?.message,
            notMatches(
              r'Future call failed deserialization. Error: .* Entry: \{.*\"name\":\s*\"TestCall0\".*\}\n',
            ),
          );
        },
      );

      test(
        'when starting Serverpod, then broken future calls are not deleted from the database',
        () async {
          await server.start();
          final entries = await FutureCallEntry.db.find(session);
          expect(entries, hasLength(futureCallsCount));
        },
      );
    },
  );

  group(
    'Given a Serverpod server instance with default config and less than 1000'
    'registered future calls in the database with at least 1 broken future call',
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
          final name = 'TestCall$i';
          final data = SimpleData(num: i);

          final entry = FutureCallEntry(
            id: i,
            name: name,
            serializedObject: i == 0 ? '{}' : data.toString(),
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          server.registerFutureCall(SimpleFutureCall(), name);
          futureCallEntries.add(entry);
          await FutureCallEntry.db.insertRow(session, entry);
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
        await server.shutdown(exitProcess: false);
      });

      test(
        'when starting Serverpod, then broken future calls are logged',
        () async {
          await server.start();
          await server.internalLoggingSession.close();

          final logs = await LoggingUtil.findAllLogs(session);
          final logEntry = logs.last.logs.first;

          expect(
            logEntry.message,
            matches(
              r'Future call failed deserialization. Error: .* Entry: \{.*\"name\":\s*\"TestCall0\".*\}\n',
            ),
          );
        },
      );

      test(
        'when starting Serverpod, then broken future calls are not deleted from the database',
        () async {
          await server.start();
          final entries = await FutureCallEntry.db.find(session);
          expect(entries, hasLength(futureCallsCount));
        },
      );
    },
  );

  group(
    'Given a Serverpod server instance with checkBrokenCalls enabled'
    'in future call config and unregistered future calls',
    () {
      late Serverpod server;
      late Session session;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 3;

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

          final entry = FutureCallEntry(
            id: i,
            name: name,
            serializedObject: data.toString(),
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          if (i == 2) server.registerFutureCall(SimpleFutureCall(), name);
          futureCallEntries.add(entry);
          await FutureCallEntry.db.insertRow(session, entry);
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
        await server.shutdown(exitProcess: false);
      });

      test(
        'when starting Serverpod, then unregistered future calls are logged',
        () async {
          await server.start();
          await server.internalLoggingSession.close();

          final logs = await LoggingUtil.findAllLogs(session);
          final logEntry = logs.last.logs.first;

          expect(logEntry.logLevel, LogLevel.warning);
          expect(
            logEntry.message,
            matches(
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall0\".*\}\n'
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall1\".*\}\n',
            ),
          );
        },
      );
    },
  );

  group(
    'Given a Serverpod server instance with checkBrokenCalls disabled'
    'in future call config and unregistered future calls',
    () {
      late Serverpod server;
      late Session session;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 3;

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

          final entry = FutureCallEntry(
            id: i,
            name: name,
            serializedObject: data.toString(),
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          if (i == 2) server.registerFutureCall(SimpleFutureCall(), name);
          futureCallEntries.add(entry);
          await FutureCallEntry.db.insertRow(session, entry);
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
        await server.shutdown(exitProcess: false);
      });

      test(
        'when starting Serverpod, then unregistered future calls are not logged',
        () async {
          await server.start();
          await server.internalLoggingSession.close();

          final logs = await LoggingUtil.findAllLogs(session);
          final logEntry = logs.lastOrNull?.logs.firstOrNull;

          expect(
            logEntry?.message,
            notMatches(
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall0\".*\}\n'
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall1\".*\}\n',
            ),
          );
        },
      );
    },
  );

  group(
    'Given a Serverpod server instance with deleteBrokenCalls enabled'
    'in future call config and unregistered future calls',
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

          final entry = FutureCallEntry(
            id: i,
            name: name,
            serializedObject: data.toString(),
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          if (i == 2) server.registerFutureCall(SimpleFutureCall(), name);
          futureCallEntries.add(entry);
          await FutureCallEntry.db.insertRow(session, entry);
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
    'Given a Serverpod server instance with deleteBrokenCalls disabled'
    'in future call config and unregistered future calls',
    () {
      late Serverpod server;
      late Session session;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 3;

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

          final entry = FutureCallEntry(
            id: i,
            name: name,
            serializedObject: data.toString(),
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          if (i == 2) server.registerFutureCall(SimpleFutureCall(), name);
          futureCallEntries.add(entry);
          await FutureCallEntry.db.insertRow(session, entry);
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
        await server.shutdown(exitProcess: false);
      });

      test(
        'when starting Serverpod, then unregistered future calls are not deleted from the database',
        () async {
          await server.start();

          final entries = await FutureCallEntry.db.find(session);
          final entryNames = entries.map((e) => e.name).toList();

          expect(
            entryNames,
            containsAll(['TestCall0', 'TestCall1', 'TestCall2']),
          );
        },
      );
    },
  );

  group(
    'Given a Serverpod server instance with checkBrokenCalls enabled'
    'in future call config and broken future calls',
    () {
      late Serverpod server;
      late Session session;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 3;

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

          final entry = FutureCallEntry(
            id: i,
            name: name,
            serializedObject: i == 2 ? data.toString() : '{}',
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          server.registerFutureCall(SimpleFutureCall(), name);
          futureCallEntries.add(entry);
          await FutureCallEntry.db.insertRow(session, entry);
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
        await server.shutdown(exitProcess: false);
      });

      test(
        'when starting Serverpod, then broken future calls are logged',
        () async {
          await server.start();
          await server.internalLoggingSession.close();

          final logs = await LoggingUtil.findAllLogs(session);
          final logEntry = logs.last.logs.first;

          expect(logEntry.logLevel, LogLevel.warning);
          expect(
            logEntry.message,
            matches(
              r'Future call failed deserialization. Error: .* Entry: \{.*\"name\":\s*\"TestCall0\".*\}\n'
              r'Future call failed deserialization. Error: .* Entry: \{.*\"name\":\s*\"TestCall1\".*\}\n',
            ),
          );
        },
      );
    },
  );

  group(
    'Given a Serverpod server instance with checkBrokenCalls disabled'
    'in future call config and broken future calls',
    () {
      late Serverpod server;
      late Session session;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 3;

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

          final entry = FutureCallEntry(
            id: i,
            name: name,
            serializedObject: i == 2 ? data.toString() : '{}',
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          server.registerFutureCall(SimpleFutureCall(), name);
          futureCallEntries.add(entry);
          await FutureCallEntry.db.insertRow(session, entry);
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
        await server.shutdown(exitProcess: false);
      });

      test(
        'when starting Serverpod, then broken future calls are not logged',
        () async {
          await server.start();
          await server.internalLoggingSession.close();

          final logs = await LoggingUtil.findAllLogs(session);
          final logEntry = logs.lastOrNull?.logs.firstOrNull;

          expect(
            logEntry?.message,
            notMatches(
              r'Future call failed deserialization. Error: .* Entry: \{.*\"name\":\s*\"TestCall0\".*\}\n'
              r'Future call failed deserialization. Error: .* Entry: \{.*\"name\":\s*\"TestCall1\".*\}\n',
            ),
          );
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

          final entry = FutureCallEntry(
            id: i,
            name: name,
            serializedObject: i == 2 ? data.toString() : '{}',
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          server.registerFutureCall(SimpleFutureCall(), name);
          futureCallEntries.add(entry);
          await FutureCallEntry.db.insertRow(session, entry);
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

  group(
    'Given a Serverpod server instance with deleteBrokenCalls disabled'
    'in future call config and broken future calls',
    () {
      late Serverpod server;
      late Session session;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 3;

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

          final entry = FutureCallEntry(
            id: i,
            name: name,
            serializedObject: i == 2 ? data.toString() : '{}',
            time: DateTime.now().toUtc(),
            serverId: 'default',
          );

          server.registerFutureCall(SimpleFutureCall(), name);
          futureCallEntries.add(entry);
          await FutureCallEntry.db.insertRow(session, entry);
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
        await server.shutdown(exitProcess: false);
      });

      test(
        'when starting Serverpod, then broken future calls are not deleted from the database',
        () async {
          await server.start();

          final entries = await FutureCallEntry.db.find(session);
          final entryNames = entries.map((e) => e.name).toList();

          expect(
            entryNames,
            containsAll(['TestCall0', 'TestCall1', 'TestCall2']),
          );
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
