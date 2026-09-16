import 'dart:io';

import 'package:serverpod_database/serverpod_database.dart';
import 'package:test/test.dart';

void main() {
  group('Given isOperationalSqlState', () {
    test(
      'when the code is a listed connection or auth SQLSTATE '
      'then it is operational.',
      () {
        expect(isOperationalSqlState(PgErrorCode.connectionFailure), isTrue);
        expect(isOperationalSqlState(PgErrorCode.invalidPassword), isTrue);
        expect(
          isOperationalSqlState(PgErrorCode.invalidAuthorizationSpecification),
          isTrue,
        );
        expect(isOperationalSqlState(PgErrorCode.invalidCatalogName), isTrue);
        expect(isOperationalSqlState(PgErrorCode.cannotConnectNow), isTrue);
        expect(isOperationalSqlState(PgErrorCode.tooManyConnections), isTrue);
        expect(isOperationalSqlState(PgErrorCode.undefinedTable), isTrue);
      },
    );

    test(
      'when the code is protocolViolation 08P01 '
      'then it is not operational.',
      () {
        expect(isOperationalSqlState(PgErrorCode.protocolViolation), isFalse);
      },
    );

    test('when the code is unknown then it is not operational.', () {
      expect(isOperationalSqlState(PgErrorCode.uniqueViolation), isFalse);
      expect(isOperationalSqlState(null), isFalse);
    });
  });

  group('Given shouldIncludeConsoleStack', () {
    test(
      'when wrapping a SocketException as DatabaseConnectException '
      'then the console stack is omitted.',
      () {
        final error = wrapConnectFailure(
          const SocketException('Connection refused'),
        );
        expect(shouldIncludeConsoleStack(error), isFalse);
        expect(exceptionEventException(error), isA<SocketException>());
      },
    );

    test(
      'when the error is a MigrationVersionNotFoundException '
      'then the console stack is omitted.',
      () {
        expect(
          shouldIncludeConsoleStack(MigrationVersionNotFoundException('v1')),
          isFalse,
        );
      },
    );

    test(
      'when the error is an unknown exception '
      'then the console stack is included.',
      () {
        expect(shouldIncludeConsoleStack(const FormatException('bad')), isTrue);
        expect(
          shouldIncludeConsoleStack(StateError('unexpected')),
          isTrue,
        );
        expect(
          shouldIncludeConsoleStack(
            const SocketException('Connection refused'),
          ),
          isTrue,
        );
      },
    );
  });

  group('Given operationalDedupeKey', () {
    test(
      'when the cause class changes then the key changes.',
      () {
        final refused = wrapConnectFailure(
          const SocketException('Connection refused'),
        );
        final catalog = DatabaseConnectException(
          cause: Exception('invalid catalog'),
          sqlState: PgErrorCode.invalidCatalogName,
        );
        expect(
          operationalDedupeKey(refused),
          isNot(operationalDedupeKey(catalog)),
        );
      },
    );

    test(
      'when the same SocketException is wrapped twice then the keys match.',
      () {
        const socket = SocketException('Connection refused');
        expect(
          operationalDedupeKey(wrapConnectFailure(socket)),
          operationalDedupeKey(wrapConnectFailure(socket)),
        );
      },
    );
  });

  group('Given isUndefinedTableError', () {
    test(
      'when the message names the table then it matches that table.',
      () {
        expect(
          isUndefinedTableError(
            Exception('no such table: serverpod_migrations'),
            tableName: 'serverpod_migrations',
          ),
          isTrue,
        );
      },
    );

    test(
      'when the message names a different table then it does not match.',
      () {
        expect(
          isUndefinedTableError(
            Exception('no such table: other'),
            tableName: 'serverpod_migrations',
          ),
          isFalse,
        );
      },
    );

    test(
      'when the message is a Postgres relation-does-not-exist error '
      'then it matches that table.',
      () {
        expect(
          isUndefinedTableError(
            Exception('relation "serverpod_migrations" does not exist'),
            tableName: 'serverpod_migrations',
          ),
          isTrue,
        );
      },
    );

    test(
      'when the message is schema-qualified then it still matches that table.',
      () {
        expect(
          isUndefinedTableError(
            Exception(
              'relation "public.serverpod_migrations" does not exist',
            ),
            tableName: 'serverpod_migrations',
          ),
          isTrue,
        );
      },
    );

    test(
      'when the adapter rewrote 42P01 into a table-not-found message '
      'then it matches that table.',
      () {
        expect(
          isUndefinedTableError(
            Exception(
              'Table not found, have you applied the database migration? '
              '(relation "serverpod_migrations" does not exist)',
            ),
            tableName: 'serverpod_migrations',
          ),
          isTrue,
        );
      },
    );

    test(
      'when table-not-found names a different table then it does not match.',
      () {
        expect(
          isUndefinedTableError(
            Exception(
              'Table not found, have you applied the database migration? '
              '(relation "other" does not exist)',
            ),
            tableName: 'serverpod_migrations',
          ),
          isFalse,
        );
      },
    );
  });

  group('Given a DatabaseIntegrityCheck', () {
    test(
      'when only a user module table is missing then framework gates stay clear.',
      () {
        final check = DatabaseIntegrityCheck(
          warnings: ['Table "example" is missing.'],
          missingTables: {'example'},
        );
        expect(check.matchesTarget, isFalse);
        expect(check.frameworkTablesMissing, isFalse);
        expect(check.futureCallTableMissing, isFalse);
      },
    );

    test(
      'when serverpod_future_call is missing then only that gate is set.',
      () {
        final check = DatabaseIntegrityCheck(
          warnings: ['Table "serverpod_future_call" is missing.'],
          missingTables: {DatabaseIntegrityCheck.futureCallTable},
        );
        expect(check.futureCallTableMissing, isTrue);
        expect(check.runtimeSettingsTableMissing, isFalse);
        expect(check.frameworkTablesMissing, isTrue);
      },
    );
  });
}
