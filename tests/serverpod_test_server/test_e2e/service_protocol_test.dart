import 'package:serverpod_service_client/serverpod_service_client.dart'
    as service;
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:test/test.dart';

import 'config.dart';

Future<void> setupTestData(Client client) async {
  await client.basicDatabaseLegacy.deleteAllSimpleTestData();
  await client.basicDatabaseLegacy.createSimpleTestData(100);
}

void main() {
  var client = Client(serverUrl);
  var serviceClient = service.Client(
    serviceServerUrl,
    authenticationKeyManager: ServiceKeyManager('0', 'password'),
  );

  group('Health metrics', () {
    test('Fetch health metrics', () async {
      // Fetch something far back, there should be no data.
      var result = await serviceClient.insights.getHealthData(
        DateTime(1976, 09, 10),
        DateTime(1980, 04, 02),
      );

      expect(result.metrics.length, equals(0));
    });
  });

  group('Logging', () {
    test('Set runtime settings', () async {
      // Log everything
      var settings = service.RuntimeSettings(
        logSettings: service.LogSettings(
          logAllSessions: true,
          logSlowSessions: true,
          logFailedSessions: false,
          logStreamingSessionsContinuously: true,
          logAllQueries: true,
          logSlowQueries: true,
          logFailedQueries: true,
          slowSessionDuration: 1.0,
          slowQueryDuration: 1.0,
          logLevel: service.LogLevel.debug,
        ),
        logMalformedCalls: true,
        logServiceCalls: false,
        logSettingsOverrides: [],
      );

      await serviceClient.insights.setRuntimeSettings(settings);

      await Future.delayed(const Duration(seconds: 1));

      settings = await serviceClient.insights.getRuntimeSettings();
      expect(settings.logSettings.logFailedSessions, equals(false));

      settings.logSettings.logFailedSessions = true;
      await serviceClient.insights.setRuntimeSettings(settings);
      settings = await serviceClient.insights.getRuntimeSettings();
      expect(settings.logSettings.logFailedSessions, equals(true));
    });

    test('Clear logs', () async {
      // Start by clearing logs
      await serviceClient.insights.clearAllLogs();

      // Make sure there is at least 10 log entries
      for (var i = 0; i < 10; i += 1) {
        await client.logging.logInfo('Log test $i');
      }

      var logResult = await serviceClient.insights.getSessionLog(10, null);
      expect(logResult.sessionLog.length, equals(10));

      await serviceClient.insights.clearAllLogs();

      logResult = await serviceClient.insights.getSessionLog(10, null);
      expect(logResult.sessionLog.length, equals(0));
    });

    test('Log entry', () async {
      await client.logging.logInfo('test');

      var logResult = await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));

      expect(logResult.sessionLog[0].logs.length, equals(1));
      expect(logResult.sessionLog[0].logs[0].message, equals('test'));
    });

    test('All log levels', () async {
      await client.logging.logDebugAndInfoAndError('debug', 'info', 'error');

      // Writing of logs may still be going on after the call has returned,
      // wait a second to make sure the log has been flushed to the database
      await Future.delayed(const Duration(seconds: 1));

      var logResult = await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));

      logResult.sessionLog[0].logs.sort((a, b) => a.order - b.order);

      expect(logResult.sessionLog[0].logs.length, equals(3));
      expect(logResult.sessionLog[0].logs[0].message, equals('debug'));
      expect(logResult.sessionLog[0].logs[1].message, equals('info'));
      expect(logResult.sessionLog[0].logs[2].message, equals('error'));
    });

    test('Long log message', () async {
      await client.logging.logInfo(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.');
    });

    test('Error log level', () async {
      // Set log level to error
      var settings = service.RuntimeSettings(
        logSettings: service.LogSettings(
          logAllSessions: true,
          logSlowSessions: true,
          logFailedSessions: true,
          logStreamingSessionsContinuously: true,
          logAllQueries: true,
          logSlowQueries: true,
          logFailedQueries: true,
          slowSessionDuration: 1.0,
          slowQueryDuration: 1.0,
          logLevel: service.LogLevel.error,
        ),
        logSettingsOverrides: [],
        logMalformedCalls: true,
        logServiceCalls: false,
      );
      await serviceClient.insights.setRuntimeSettings(settings);

      await client.logging.logDebugAndInfoAndError('debug', 'info', 'error');

      // Writing of logs may still be going on after the call has returned,
      // wait a second to make sure the log has been flushed to the database
      await Future.delayed(const Duration(seconds: 1));

      var logResult = await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));

      // Debug and info logs should be ignored
      expect(logResult.sessionLog[0].logs.length, equals(1));
      expect(logResult.sessionLog[0].logs[0].message, equals('error'));
    });

    test('Query log', () async {
      await client.logging.twoQueries();

      // Writing of logs may still be going on after the call has returned,
      // wait a second to make sure the log has been flushed to the database
      await Future.delayed(const Duration(seconds: 1));

      var logResult = await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));

      expect(logResult.sessionLog[0].queries.length, equals(2));
    });

    test('Transaction query log', () async {
      await setupTestData(client);
      await client.transactionsDatabase.updateInsertDelete(50, 500, 0);
      await Future.delayed(const Duration(seconds: 1));

      var logResult = await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));

      expect(logResult.sessionLog[0].queries.length, equals(4));
    });

    test('Disabled logging', () async {
      await client.logging.logInfo('test');
      await Future.delayed(const Duration(seconds: 1));

      var logResult = await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));
      expect(
          logResult.sessionLog[0].sessionLogEntry.endpoint, equals('logging'));
      expect(logResult.sessionLog[0].sessionLogEntry.method, equals('logInfo'));

      await client.logging.logInfo('test');
      await Future.delayed(const Duration(seconds: 1));
      await client.loggingDisabled.logInfo('test');
      await Future.delayed(const Duration(seconds: 1));

      logResult = await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));
      expect(
          logResult.sessionLog[0].sessionLogEntry.endpoint, equals('logging'));
      expect(logResult.sessionLog[0].sessionLogEntry.method, equals('logInfo'));
    });

    test('Future call logging', () async {
      // Set log level to info
      var settings = service.RuntimeSettings(
        logSettings: service.LogSettings(
          logAllSessions: true,
          logSlowSessions: true,
          logFailedSessions: true,
          logStreamingSessionsContinuously: true,
          logAllQueries: true,
          logSlowQueries: true,
          logFailedQueries: true,
          slowSessionDuration: 1.0,
          slowQueryDuration: 1.0,
          logLevel: service.LogLevel.info,
        ),
        logMalformedCalls: true,
        logServiceCalls: false,
        logSettingsOverrides: [],
      );
      await serviceClient.insights.setRuntimeSettings(settings);

      await client.futureCalls.makeFutureCall(SimpleData(num: 42));

      // Make sure that the future call has been executed
      // The check for future calls is made very 5 s and future call is set for
      // 1 s. Largest possible delay should be 6 s.
      await Future.delayed(const Duration(seconds: 6));

      var logResult = await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));

      expect(logResult.sessionLog[0].logs.length, equals(1));
      expect(logResult.sessionLog[0].logs[0].message, equals('42'));
      expect(
          logResult.sessionLog[0].sessionLogEntry.method, equals('testCall'));
    });

    test('Slow call logging', () async {
      await client.failedCalls.slowCall();

      var logResult = await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));
      expect(logResult.sessionLog[0].sessionLogEntry.slow, equals(true));
    });

    test('Exception logging', () async {
      await client.failedCalls.caughtException();
      await Future.delayed(const Duration(seconds: 1));

      var logResult = await serviceClient.insights.getSessionLog(1, null);

      logResult.sessionLog[0].logs.sort((a, b) => a.order - b.order);

      expect(logResult.sessionLog.length, equals(1));
      expect(logResult.sessionLog[0].logs.length, equals(3));
      expect(logResult.sessionLog[0].logs[0].error, isNotNull);
      expect(logResult.sessionLog[0].logs[0].stackTrace, isNotNull);
      expect(logResult.sessionLog[0].logs[2].error, isNull);
      expect(logResult.sessionLog[0].logs[2].stackTrace, isNull);
    });

    test('Logging in stream', () async {
      // Set log level to info
      var settings = service.RuntimeSettings(
        logSettings: service.LogSettings(
          logAllSessions: true,
          logSlowSessions: true,
          logFailedSessions: true,
          logStreamingSessionsContinuously: true,
          logAllQueries: true,
          logSlowQueries: true,
          logFailedQueries: true,
          slowSessionDuration: 1.0,
          slowQueryDuration: 1.0,
          logLevel: service.LogLevel.info,
        ),
        logMalformedCalls: true,
        logServiceCalls: false,
        logSettingsOverrides: [],
      );
      await serviceClient.insights.setRuntimeSettings(settings);

      await client.openStreamingConnection(
        disconnectOnLostInternetConnection: false,
      );

      for (var i = 0; i < 5; i += 1) {
        await client.streamingLogging.sendStreamMessage(SimpleData(num: 42));
      }

      await client.streamingLogging.sendStreamMessage(SimpleData(num: -1));

      for (var i = 0; i < 5; i += 1) {
        await client.streamingLogging.sendStreamMessage(SimpleData(num: 42));
      }

      // This test failed some times due to some kind of race condition.
      // Idealy we would not use a hard coded delay here.
      // Ticket: https://github.com/serverpod/serverpod/issues/773
      await Future.delayed(const Duration(seconds: 5));

      var logResult = await serviceClient.insights.getSessionLog(1, null);
      expect(logResult.sessionLog.length, equals(1));
      expect(logResult.sessionLog[0].sessionLogEntry.isOpen, equals(true));
      // We should have logged one entry when opening the stream and 11 when
      // sending messages.
      expect(logResult.sessionLog[0].logs.length, equals(12));

      // Expect 11 messages to have been sent
      expect(logResult.sessionLog[0].messages.length, equals(11));
      logResult.sessionLog[0].messages.sort((a, b) => a.order - b.order);

      // Expect us to find an exception in the 6th logged message
      expect(logResult.sessionLog[0].messages[5].error, isNotNull);
    });
  });

  group('Database', () {
    group('target definition', () {
      test('sanity checks', () async {
        var definition =
            await serviceClient.insights.getTargetDatabaseDefinition();

        expect(definition.tables.map((e) => e.name),
            contains('object_field_scopes'));
        var table = definition.tables
            .firstWhere((e) => e.name == 'object_field_scopes');
        expect(table.schema, 'public');
        expect(table.tableSpace, null);
        expect(table.columns, hasLength(3));
        expect(table.columns.first.name, 'id');
        expect(table.columns.first.isNullable, false);
        expect(table.managed, true);
        expect(table.foreignKeys, hasLength(0));
        expect(table.indexes, hasLength(1));

        expect(definition.tables.every((t) => t.indexes.isNotEmpty), true);
      });
      test('contains selected tables', () async {
        var definition =
            await serviceClient.insights.getTargetDatabaseDefinition();

        const expectedTables = [
          'object_field_scopes',
          'object_with_bytedata',
          'object_with_duration',
          'object_with_enum',
          'object_with_object',
          'serverpod_user_info', // Part of the auth module
          'serverpod_future_call', // From serverpod
        ];

        for (var expectedTable in expectedTables) {
          expect(
              definition.tables.where((table) => table.name == expectedTable),
              hasLength(1));
        }
      });
      test('columns only contains database fields', () async {
        var definition =
            await serviceClient.insights.getTargetDatabaseDefinition();

        var columns = definition.tables
            .firstWhere((table) => table.name == 'object_field_scopes')
            .columns
            .map((c) => c.name)
            .toList();
        expect(columns, hasLength(3));
        expect(columns, containsAll(['id', 'normal', 'database']));
      });

      test('foreign keys', () async {
        var definition =
            await serviceClient.insights.getTargetDatabaseDefinition();

        var table = definition.tables
            .firstWhere((table) => table.name == 'object_with_parent');

        expect(table.foreignKeys, hasLength(1));
        expect(
            table.foreignKeys.first.constraintName, 'object_with_parent_fk_0');
        expect(table.foreignKeys.first.referenceTable, 'object_field_scopes');
        expect(table.foreignKeys.first.onUpdate,
            service.ForeignKeyAction.noAction);
        expect(
            table.foreignKeys.first.onDelete, service.ForeignKeyAction.cascade);
        expect(table.foreignKeys.first.matchType, isNull);
        expect(table.foreignKeys.first.columns, hasLength(1));
        expect(table.foreignKeys.first.columns.first, 'other');
        expect(table.foreignKeys.first.referenceColumns, hasLength(1));
        expect(table.foreignKeys.first.referenceColumns.first, 'id');
      });

      test('indexes', () async {
        var definition =
            await serviceClient.insights.getTargetDatabaseDefinition();

        var table = definition.tables
            .firstWhere((table) => table.name == 'object_with_index');

        expect(table.indexes, hasLength(2));
        expect(table.indexes[0].indexName, 'object_with_index_pkey');
        expect(table.indexes[0].isPrimary, true);
        expect(table.indexes[0].isUnique, true);
        expect(table.indexes[0].predicate, isNull);
        expect(table.indexes[0].tableSpace, isNull);
        expect(table.indexes[0].type, 'btree');
        expect(table.indexes[0].elements, hasLength(1));
        expect(table.indexes[0].elements.first.type,
            service.IndexElementDefinitionType.column);
        expect(table.indexes[0].elements.first.definition, 'id');

        expect(table.indexes[1].indexName, 'object_with_index_test_index');
        expect(table.indexes[1].isPrimary, false);
        expect(table.indexes[1].isUnique, false);
        expect(table.indexes[1].predicate, isNull);
        expect(table.indexes[1].tableSpace, isNull);
        expect(table.indexes[1].type, 'brin');
        expect(table.indexes[1].elements, hasLength(2));
        expect(table.indexes[1].elements[0].type,
            service.IndexElementDefinitionType.column);
        expect(table.indexes[1].elements[0].definition, 'indexed');
        expect(table.indexes[1].elements[1].type,
            service.IndexElementDefinitionType.column);
        expect(table.indexes[1].elements[1].definition, 'indexed2');
      });

      test('validate dart types', () async {
        var definition =
            await serviceClient.insights.getTargetDatabaseDefinition();

        var columns = definition.tables
            .firstWhere((table) => table.name == 'object_with_object')
            .columns
            .map((c) => c.dartType)
            .toList();

        expect(columns, hasLength(7));
        expect(
            columns,
            containsAll([
              'int?',
              'protocol:SimpleData',
              'protocol:SimpleData?',
              'List<protocol:SimpleData>',
              'List<protocol:SimpleData>?',
              'List<protocol:SimpleData?>',
              'List<protocol:SimpleData?>?',
            ]));

        var columnsWithScopes = definition.tables
            .firstWhere((table) => table.name == 'object_field_scopes')
            .columns
            .map((c) => c.dartType)
            .toList();

        expect(columnsWithScopes, hasLength(3));
        expect(columnsWithScopes, containsAll(['int?', 'String', 'String?']));
      });
    });

    group('live definition', () {
      test('matches target', () async {
        var target = await serviceClient.insights.getTargetDatabaseDefinition();
        var live = await serviceClient.insights.getLiveDatabaseDefinition();

        live.matchesTarget(target);
      });
    });
  });
}

extension on service.DatabaseDefinition {
  void matchesTarget(service.DatabaseDefinition target) {
    // The length should be one more as the live definition contains the
    // migrations table.
    expect(tables, hasLength(target.tables.length + 1));
    expect(tables.map((e) => e.name),
        containsAll(target.tables.map((e) => e.name)));

    for (var table in tables) {
      if (table.name == 'serverpod_migrations') {
        continue;
      }
      table.matchesDefinition(
          target.tables.firstWhere((e) => e.name == table.name));
    }
  }
}

extension on service.TableDefinition {
  void matchesDefinition(service.TableDefinition definition) {
    expect(name, definition.name);
    expect(schema, definition.schema);

    if (definition.managed ?? false) {
      expect(tableSpace, definition.tableSpace);

      expect(columns, hasLength(definition.columns.length));
      expect(columns.map((e) => e.name),
          containsAll(definition.columns.map((e) => e.name)));
      for (var column in columns) {
        column.matchesDefinition(
            definition.columns.firstWhere((e) => e.name == column.name));
      }

      expect(columns, hasLength(definition.columns.length));
      expect(columns.map((e) => e.name),
          containsAll(definition.columns.map((e) => e.name)));
      for (var column in columns) {
        column.matchesDefinition(
            definition.columns.firstWhere((e) => e.name == column.name));
      }

      expect(foreignKeys, hasLength(definition.foreignKeys.length));
      expect(foreignKeys.map((e) => e.constraintName),
          containsAll(definition.foreignKeys.map((e) => e.constraintName)));
      for (var foreignKey in foreignKeys) {
        foreignKey.matchesDefinition(definition.foreignKeys
            .firstWhere((e) => e.constraintName == foreignKey.constraintName));
      }

      expect(indexes, hasLength(definition.indexes.length));
      // Converting to lower case, since Serverpod does not quote index names in the generated SQL.
      expect(
        indexes.map((e) => e.indexName.toLowerCase()),
        containsAll(definition.indexes.map((e) => e.indexName.toLowerCase())),
      );
      for (var index in indexes) {
        // Converting to lower case, since Serverpod does not quote index names in the generated SQL.
        index.matchesDefinition(definition.indexes.firstWhere(
            (e) => e.indexName.toLowerCase() == index.indexName.toLowerCase()));
      }
    }
  }
}

extension on service.ColumnDefinition {
  void matchesDefinition(service.ColumnDefinition definition) {
    expect(name, definition.name);
    expect(columnDefault, definition.columnDefault);
    expect(columnType, definition.columnType);
    expect(isNullable, definition.isNullable);
  }
}

extension on service.ForeignKeyDefinition {
  void matchesDefinition(service.ForeignKeyDefinition definition) {
    expect(constraintName, definition.constraintName);
    expect(
        matchType, definition.matchType ?? service.ForeignKeyMatchType.simple);
    expect(onUpdate, definition.onUpdate ?? service.ForeignKeyAction.noAction);
    expect(onDelete, definition.onDelete ?? service.ForeignKeyAction.noAction);
    expect(referenceTable, definition.referenceTable);
    expect(referenceTableSchema, definition.referenceTableSchema);
    expect(columns, hasLength(definition.columns.length));
    expect(columns, containsAllInOrder(definition.columns));
    expect(referenceColumns, hasLength(definition.referenceColumns.length));
    expect(referenceColumns, containsAllInOrder(definition.referenceColumns));
  }
}

extension on service.IndexDefinition {
  void matchesDefinition(service.IndexDefinition definition) {
    // Converting to lower case, since Serverpod does not quote index names in the generated SQL.
    expect(indexName.toLowerCase(), definition.indexName.toLowerCase());
    expect(tableSpace, definition.tableSpace);
    expect(isPrimary, definition.isPrimary);
    expect(isUnique, definition.isUnique);
    expect(this.predicate, definition.predicate);
    expect(type, definition.type);
    expect(elements, hasLength(definition.elements.length));
    for (var i = 0; i < elements.length; i++) {
      expect(elements[i].type, definition.elements[i].type);
      expect(elements[i].definition, definition.elements[i].definition);
    }
  }
}

class ServiceKeyManager extends AuthenticationKeyManager {
  final String name;
  final String serviceSecret;

  ServiceKeyManager(this.name, this.serviceSecret);

  @override
  Future<String> get() async {
    return 'name:$serviceSecret';
  }

  @override
  Future<void> put(String key) async {}

  @override
  Future<void> remove() async {}
}

List<List<bool>> performIteration(List<List<bool>> board) {
  return [];
}
