import 'dart:async';
import 'dart:io';

import 'package:serverpod/protocol.dart' show FutureCallEntry;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/future_call_manager/future_call_diagnostics_service.dart';
import 'package:serverpod_test/serverpod_test.dart';
import 'package:serverpod_test_server/src/generated/simple_data.dart';
import 'package:serverpod_test_server/test_util/builders/runtime_settings_builder.dart';
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
    'Given a FutureCallManager with default config and scheduled FutureCalls',
    () {
      late Serverpod server;
      late Session session;
      late FutureCallManager futureCallManager;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 3;

      setUp(() async {
        server = IntegrationTestServer.create();
        await server.start();

        session = await server.createSession(enableLogging: false);
        await LoggingUtil.clearAllLogs(session);

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
        await server.shutdown(exitProcess: false);
      });

      test(
        'when calling start then unregistered future calls are logged',
        () async {
          final settings = RuntimeSettingsBuilder().build();
          await server.updateRuntimeSettings(settings);

          final testSession = await server.createSession(enableLogging: true);

          futureCallManager = FutureCallManagerBuilder(
            sessionProvider: (futureCallName) => testSession,
            internalSession: testSession,
          ).withDiagnosticsService(MockDiagnosticsService()).build();

          // only register one future call
          futureCallManager.registerFutureCall(
            SimpleFutureCall(),
            'TestCall1',
          );

          await futureCallManager.start();
          await testSession.close();

          var logs = await LoggingUtil.findAllLogs(session);
          var logEntry = logs.last.logs.first;

          expect(logEntry.logLevel, LogLevel.warning);
          expect(
            logEntry.message,
            matches(
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall0\".*\}\n'
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall2\".*\}\n',
            ),
          );
        },
      );

      test(
        'when calling runScheduledFutureCalls then unregistered future calls are logged',
        () async {
          final settings = RuntimeSettingsBuilder().build();
          await server.updateRuntimeSettings(settings);

          final testSession = await server.createSession(enableLogging: true);

          futureCallManager = FutureCallManagerBuilder(
            sessionProvider: (futureCallName) => testSession,
            internalSession: testSession,
          ).withDiagnosticsService(MockDiagnosticsService()).build();

          // only register one future call
          futureCallManager.registerFutureCall(
            SimpleFutureCall(),
            'TestCall1',
          );

          await futureCallManager.runScheduledFutureCalls();
          await testSession.close();

          var logs = await LoggingUtil.findAllLogs(session);
          var logEntry = logs.last.logs.first;

          expect(logEntry.logLevel, LogLevel.warning);
          expect(
            logEntry.message,
            matches(
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall0\".*\}\n'
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall2\".*\}\n',
            ),
          );
        },
      );

      test('when calling start then broken future calls are logged', () async {
        final settings = RuntimeSettingsBuilder().build();
        await server.updateRuntimeSettings(settings);

        final testSession = await server.createSession(enableLogging: true);

        futureCallManager = FutureCallManagerBuilder(
          sessionProvider: (futureCallName) => testSession,
          internalSession: testSession,
        ).withDiagnosticsService(MockDiagnosticsService()).build();

        // register future calls
        for (int i = 0; i < futureCallsCount; i++) {
          futureCallManager.registerFutureCall(
            SimpleFutureCall(),
            'TestCall$i',
          );
        }

        // update stored future call data to fail deserialization
        await FutureCallEntry.db.updateRow(
          session,
          FutureCallEntry(
            id: 1,
            name: 'TestCall1',
            serializedObject: '{}',
            time: DateTime.now().toUtc(),
            serverId: 'default',
          ),
        );

        await futureCallManager.start();
        await testSession.close();

        var logs = await LoggingUtil.findAllLogs(session);
        var logEntry = logs.last.logs.first;

        expect(logEntry.logLevel, LogLevel.warning);
        expect(
          logEntry.message,
          matches(
            r'Future call failed deserialization. Error: .* Entry: \{.*\"name\":\s*\"TestCall1\".*\}\n',
          ),
        );
      });

      test(
        'when calling runScheduledFutureCalls then broken future calls are logged',
        () async {
          final settings = RuntimeSettingsBuilder().build();
          await server.updateRuntimeSettings(settings);

          final testSession = await server.createSession(enableLogging: true);

          futureCallManager = FutureCallManagerBuilder(
            sessionProvider: (futureCallName) => testSession,
            internalSession: testSession,
          ).withDiagnosticsService(MockDiagnosticsService()).build();

          // register future calls
          for (int i = 0; i < futureCallsCount; i++) {
            futureCallManager.registerFutureCall(
              SimpleFutureCall(),
              'TestCall$i',
            );
          }

          // update stored future call data to fail deserialization
          await FutureCallEntry.db.updateRow(
            session,
            FutureCallEntry(
              id: 1,
              name: 'TestCall1',
              serializedObject: '{}',
              time: DateTime.now().toUtc(),
              serverId: 'default',
            ),
          );

          await futureCallManager.runScheduledFutureCalls();
          await testSession.close();

          var logs = await LoggingUtil.findAllLogs(session);
          var logEntry = logs.last.logs.first;

          expect(logEntry.logLevel, LogLevel.warning);
          expect(
            logEntry.message,
            matches(
              r'Future call failed deserialization. Error: .* Entry: \{.*\"name\":\s*\"TestCall1\".*\}\n',
            ),
          );
        },
      );
    },
    tags: [defaultIntegrationTestTag],
  );

  group(
    'Given a FutureCallManager with scheduled FutureCalls and checkBrokenFutureCalls is disabled in config',
    () {
      late Serverpod server;
      late Session session;
      late FutureCallManager futureCallManager;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 3;

      setUp(() async {
        server = IntegrationTestServer.create();
        await server.start();

        session = await server.createSession(enableLogging: false);
        await LoggingUtil.clearAllLogs(session);

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
        await server.shutdown(exitProcess: false);
      });

      test(
        'when calling start then unregistered future calls are not logged',
        () async {
          final settings = RuntimeSettingsBuilder().build();
          await server.updateRuntimeSettings(settings);

          final testSession = await server.createSession(enableLogging: true);

          futureCallManager =
              FutureCallManagerBuilder(
                    sessionProvider: (futureCallName) => testSession,
                    internalSession: testSession,
                  )
                  .withConfig(FutureCallConfig(checkBrokenFutureCalls: false))
                  .withDiagnosticsService(MockDiagnosticsService())
                  .build();

          // only register one future call
          futureCallManager.registerFutureCall(
            SimpleFutureCall(),
            'TestCall1',
          );

          await futureCallManager.start();
          await testSession.close();

          final logs = await LoggingUtil.findAllLogs(session);
          final logEntry = logs.last.logs.firstOrNull;

          expect(
            logEntry?.message,
            notMatches(
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall0\".*\}\n'
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall2\".*\}\n',
            ),
          );
        },
      );

      test(
        'when calling runScheduledFutureCalls then unregistered future calls are not logged',
        () async {
          final settings = RuntimeSettingsBuilder().build();
          await server.updateRuntimeSettings(settings);

          final testSession = await server.createSession(enableLogging: true);

          futureCallManager =
              FutureCallManagerBuilder(
                    sessionProvider: (futureCallName) => testSession,
                    internalSession: testSession,
                  )
                  .withConfig(FutureCallConfig(checkBrokenFutureCalls: false))
                  .withDiagnosticsService(MockDiagnosticsService())
                  .build();

          // only register one future call
          futureCallManager.registerFutureCall(
            SimpleFutureCall(),
            'TestCall1',
          );

          await futureCallManager.runScheduledFutureCalls();
          await testSession.close();

          final logs = await LoggingUtil.findAllLogs(session);
          final logEntry = logs.last.logs.firstOrNull;

          expect(
            logEntry?.message,
            notMatches(
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall0\".*\}\n'
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall2\".*\}\n',
            ),
          );
        },
      );

      test(
        'when calling start then broken future calls are not logged',
        () async {
          final settings = RuntimeSettingsBuilder().build();
          await server.updateRuntimeSettings(settings);

          final testSession = await server.createSession(enableLogging: true);

          futureCallManager =
              FutureCallManagerBuilder(
                    sessionProvider: (futureCallName) => testSession,
                    internalSession: testSession,
                  )
                  .withConfig(FutureCallConfig(checkBrokenFutureCalls: false))
                  .withDiagnosticsService(MockDiagnosticsService())
                  .build();

          // register future calls
          for (int i = 0; i < futureCallsCount; i++) {
            futureCallManager.registerFutureCall(
              SimpleFutureCall(),
              'TestCall$i',
            );
          }

          // update stored future call data to fail deserialization
          await FutureCallEntry.db.updateRow(
            session,
            FutureCallEntry(
              id: 1,
              name: 'TestCall1',
              serializedObject: '{}',
              time: DateTime.now().toUtc(),
              serverId: 'default',
            ),
          );

          await futureCallManager.start();
          await testSession.close();

          final logs = await LoggingUtil.findAllLogs(session);
          final logEntry = logs.last.logs.firstOrNull;

          expect(
            logEntry?.message,
            notMatches(
              r'Future call failed deserialization. Error: .* Entry: \{.*\"name\":\s*\"TestCall1\".*\}\n',
            ),
          );
        },
      );

      test(
        'when calling runScheduledFutureCalls then broken future calls are not logged',
        () async {
          final settings = RuntimeSettingsBuilder().build();
          await server.updateRuntimeSettings(settings);

          final testSession = await server.createSession(enableLogging: true);

          futureCallManager =
              FutureCallManagerBuilder(
                    sessionProvider: (futureCallName) => testSession,
                    internalSession: testSession,
                  )
                  .withConfig(FutureCallConfig(checkBrokenFutureCalls: false))
                  .withDiagnosticsService(MockDiagnosticsService())
                  .build();

          // register future calls
          for (int i = 0; i < futureCallsCount; i++) {
            futureCallManager.registerFutureCall(
              SimpleFutureCall(),
              'TestCall$i',
            );
          }

          // update stored future call data to fail deserialization
          await FutureCallEntry.db.updateRow(
            session,
            FutureCallEntry(
              id: 1,
              name: 'TestCall1',
              serializedObject: '{}',
              time: DateTime.now().toUtc(),
              serverId: 'default',
            ),
          );

          await futureCallManager.runScheduledFutureCalls();
          await testSession.close();

          final logs = await LoggingUtil.findAllLogs(session);
          final logEntry = logs.last.logs.firstOrNull;

          expect(
            logEntry?.message,
            notMatches(
              r'Future call failed deserialization. Error: .* Entry: \{.*\"name\":\s*\"TestCall1\".*\}\n',
            ),
          );
        },
      );
    },
    tags: [defaultIntegrationTestTag],
  );

  withServerpod(
    'Given a FutureCallManager with scheduled FutureCalls and deleteBrokenFutureCalls enabled in config',
    (sessionBuilder, _) {
      late Session session;
      late FutureCallManager futureCallManager;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 3;

      setUp(() async {
        session = sessionBuilder.build();

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

          futureCallManager =
              FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
                  .withConfig(FutureCallConfig(deleteBrokenFutureCalls: true))
                  .withDiagnosticsService(MockDiagnosticsService())
                  .build();
        }
      });

      tearDown(() async {
        await FutureCallEntry.db.delete(session, futureCallEntries);
        await session.close();
      });

      test(
        'when calling start then unregistered future calls are deleted from the database',
        () async {
          // only register one future call
          futureCallManager.registerFutureCall(
            SimpleFutureCall(),
            'TestCall1',
          );

          await futureCallManager.start();

          final futureCallEntries = await FutureCallEntry.db.find(session);
          expect(futureCallEntries, hasLength(1));
          expect(futureCallEntries.firstOrNull?.name, 'TestCall1');
        },
      );

      test(
        'when calling start then broken future calls are deleted from the database',
        () async {
          // register future calls
          for (int i = 0; i < futureCallsCount; i++) {
            futureCallManager.registerFutureCall(
              SimpleFutureCall(),
              'TestCall$i',
            );
          }

          // update stored future call data to fail deserialization
          await FutureCallEntry.db.updateRow(
            session,
            FutureCallEntry(
              id: 1,
              name: 'TestCall1',
              serializedObject: '{}',
              time: DateTime.now().toUtc(),
              serverId: 'default',
            ),
          );

          await futureCallManager.start();

          final futureCallEntries = await FutureCallEntry.db.find(session);

          expect(futureCallEntries, hasLength(futureCallsCount - 1));
          expect(futureCallEntries.firstOrNull?.name, 'TestCall0');
          expect(futureCallEntries.lastOrNull?.name, 'TestCall2');
        },
      );
    },
  );

  group(
    'Given a Serverpod server instance with default config and less than 1000 future calls in the database',
    () {
      late Serverpod server;
      late Session session;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 3;

      setUp(() async {
        server = IntegrationTestServer.create();
        session = await server.createSession(enableLogging: false);
        await LoggingUtil.clearAllLogs(session);

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
        await server.shutdown(exitProcess: false);
      });

      test(
        'when starting Serverpod, then unregistered future calls are logged',
        () async {
          server.registerFutureCall(SimpleFutureCall(), 'TestCall1');
          await server.start();

          // close the session to flush the cached logs to database
          await server.internalLoggingSession.close();

          var logs = await LoggingUtil.findAllLogs(session);
          var logEntry = logs.last.logs.first;

          expect(logEntry.logLevel, LogLevel.warning);
          expect(
            logEntry.message,
            matches(
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall0\".*\}\n'
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall2\".*\}\n',
            ),
          );
        },
      );

      test(
        'when starting Serverpod, then broken future calls are logged',
        () async {
          // register future calls
          for (int i = 0; i < futureCallsCount; i++) {
            server.registerFutureCall(
              SimpleFutureCall(),
              'TestCall$i',
            );
          }

          // update stored future call data to fail deserialization
          await FutureCallEntry.db.updateRow(
            session,
            FutureCallEntry(
              id: 1,
              name: 'TestCall1',
              serializedObject: '{}',
              time: DateTime.now().toUtc(),
              serverId: 'default',
            ),
          );

          await server.start();
          // close the session to flush the cached logs to database
          await server.internalLoggingSession.close();

          var logs = await LoggingUtil.findAllLogs(session);
          var logEntry = logs.last.logs.first;

          expect(logEntry.logLevel, LogLevel.warning);
          expect(
            logEntry.message,
            matches(
              r'Future call failed deserialization. Error: .* Entry: \{.*\"name\":\s*\"TestCall1\".*\}\n',
            ),
          );
        },
      );
    },

    tags: [defaultIntegrationTestTag],
  );

  group(
    'Given a Serverpod server instance with checkBrokenFutureCalls enabled in future call config',
    () {
      late Serverpod server;
      late Session session;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 3;

      setUp(() async {
        server = IntegrationTestServer.create(
          config: _ServerpodConfigExtension.loadConfig().copyWith(
            futureCall: FutureCallConfig(checkBrokenFutureCalls: true),
          ),
        );
        session = await server.createSession(enableLogging: false);
        await LoggingUtil.clearAllLogs(session);

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
        await server.shutdown(exitProcess: false);
      });

      test(
        'when starting Serverpod, then unregistered future calls are logged',
        () async {
          server.registerFutureCall(SimpleFutureCall(), 'TestCall1');
          await server.start();

          // close the session to flush the cached logs to database
          await server.internalLoggingSession.close();

          var logs = await LoggingUtil.findAllLogs(session);
          var logEntry = logs.last.logs.first;

          expect(logEntry.logLevel, LogLevel.warning);
          expect(
            logEntry.message,
            matches(
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall0\".*\}\n'
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall2\".*\}\n',
            ),
          );
        },
      );

      test(
        'when starting Serverpod, then broken future calls are logged',
        () async {
          // register future calls
          for (int i = 0; i < futureCallsCount; i++) {
            server.registerFutureCall(
              SimpleFutureCall(),
              'TestCall$i',
            );
          }

          // update stored future call data to fail deserialization
          await FutureCallEntry.db.updateRow(
            session,
            FutureCallEntry(
              id: 1,
              name: 'TestCall1',
              serializedObject: '{}',
              time: DateTime.now().toUtc(),
              serverId: 'default',
            ),
          );

          await server.start();
          // close the session to flush the cached logs to database
          await server.internalLoggingSession.close();

          var logs = await LoggingUtil.findAllLogs(session);
          var logEntry = logs.last.logs.first;

          expect(logEntry.logLevel, LogLevel.warning);
          expect(
            logEntry.message,
            matches(
              r'Future call failed deserialization. Error: .* Entry: \{.*\"name\":\s*\"TestCall1\".*\}\n',
            ),
          );
        },
      );
    },
    tags: [defaultIntegrationTestTag],
  );

  group(
    'Given a Serverpod server instance with checkBrokenFutureCalls disabled in future call config',
    () {
      late Serverpod server;
      late Session session;
      List<FutureCallEntry> futureCallEntries = [];
      int futureCallsCount = 3;

      setUp(() async {
        server = IntegrationTestServer.create(
          config: _ServerpodConfigExtension.loadConfig().copyWith(
            futureCall: FutureCallConfig(checkBrokenFutureCalls: false),
          ),
        );

        session = await server.createSession(enableLogging: false);
        await LoggingUtil.clearAllLogs(session);

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
        await server.shutdown(exitProcess: false);
      });

      test(
        'when starting Serverpod, then unregistered future calls are not logged',
        () async {
          server.registerFutureCall(SimpleFutureCall(), 'TestCall1');
          await server.start();

          // close the session to flush the cached logs to database
          await server.internalLoggingSession.close();

          var logs = await LoggingUtil.findAllLogs(session);
          var logEntry = logs.lastOrNull?.logs.firstOrNull;

          expect(
            logEntry?.message,
            notMatches(
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall0\".*\}\n'
              r'Unregistered future call: \{.*\"name\":\s*\"TestCall2\".*\}\n',
            ),
          );
        },
      );

      test(
        'when starting Serverpod, then broken future calls are not logged',
        () async {
          // register future calls
          for (int i = 0; i < futureCallsCount; i++) {
            server.registerFutureCall(
              SimpleFutureCall(),
              'TestCall$i',
            );
          }

          // update stored future call data to fail deserialization
          await FutureCallEntry.db.updateRow(
            session,
            FutureCallEntry(
              id: 1,
              name: 'TestCall1',
              serializedObject: '{}',
              time: DateTime.now().toUtc(),
              serverId: 'default',
            ),
          );

          await server.start();
          // close the session to flush the cached logs to database
          await server.internalLoggingSession.close();

          var logs = await LoggingUtil.findAllLogs(session);
          var logEntry = logs.lastOrNull?.logs.firstOrNull;

          expect(
            logEntry?.message,
            notMatches(
              r'Future call failed deserialization. Error: .* Entry: \{.*\"name\":\s*\"TestCall1\".*\}\n',
            ),
          );
        },
      );
    },
    tags: [defaultIntegrationTestTag],
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
