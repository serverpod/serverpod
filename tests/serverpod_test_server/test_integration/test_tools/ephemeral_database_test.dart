import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test/serverpod_test.dart'
    show EphemeralTestDatabase, TestDatabaseManager;
import 'package:serverpod_test_server/src/generated/endpoints.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  group(
    'Given a PostgreSQL database seeded with SimpleData(111) with ephemeralDatabase disabled and rollbacks disabled,',
    () {
      // withServerpod resolves config during test registration, before setUpAll.
      final projectDatabaseName = TestDatabaseManager.generateDatabaseName();
      EphemeralTestDatabase? projectDatabase;

      setUpAll(() async {
        projectDatabase = await EphemeralTestDatabase.create(
          runMode: 'test',
          databaseName: projectDatabaseName,
          serverDirectory: Directory.current,
        );
        await _withDatabase(projectDatabaseName, (session) async {
          await applyMigrationsAndVerify(
            session: session,
            projectDirectory: Directory.current,
            runMode: 'test',
            applyRepairMigration: false,
            applyMigrations: true,
          );
          await SimpleData.db.insertRow(session, SimpleData(num: 111));
        });
      });

      // Reconnect after withServerpod shuts down, before dropping the fixture.
      tearDownAll(() async {
        try {
          await _withDatabase(projectDatabaseName, (session) async {
            final rows = await SimpleData.db.find(
              session,
              orderBy: (table) => table.num,
            );

            expect(rows.map((row) => row.num), [111, 222]);
          });
        } finally {
          await projectDatabase?.drop();
        }
      });

      withServerpod(
        'when an endpoint writes SimpleData(222),',
        ephemeralDatabase: false,
        rollbackDatabase: RollbackDatabase.disabled,
        configOverride: (config) => config.copyWith(
          database: (config.database! as PostgresDatabaseConfig).withName(
            projectDatabaseName,
          ),
        ),
        (sessionBuilder, endpoints) {
          late String activeDatabaseName;
          late List<SimpleData> rows;

          setUpAll(() async {
            final database = await sessionBuilder.build().db.unsafeQuery(
              'SELECT current_database();',
            );
            activeDatabaseName = database.single[0] as String;
            await endpoints.testTools.createSimpleData(sessionBuilder, 222);
            rows = await endpoints.testTools.getAllSimpleData(sessionBuilder);
          });

          test(
            'then it uses the seeded database and preserves both rows after shutdown.',
            () {
              expect(activeDatabaseName, projectDatabaseName);
              expect(rows.map((row) => row.num), unorderedEquals([111, 222]));
            },
          );
        },
      );
    },
  );

  group(
    'Given a PostgreSQL database seeded with SimpleData(111) with ephemeralDatabase omitted and rollbacks disabled,',
    () {
      // withServerpod resolves config during test registration, before setUpAll.
      final projectDatabaseName = TestDatabaseManager.generateDatabaseName();
      EphemeralTestDatabase? projectDatabase;
      late String activeDatabaseName;

      setUpAll(() async {
        projectDatabase = await EphemeralTestDatabase.create(
          runMode: 'test',
          databaseName: projectDatabaseName,
          serverDirectory: Directory.current,
        );
        await _withDatabase(projectDatabaseName, (session) async {
          await applyMigrationsAndVerify(
            session: session,
            projectDirectory: Directory.current,
            runMode: 'test',
            applyRepairMigration: false,
            applyMigrations: true,
          );
          await SimpleData.db.insertRow(session, SimpleData(num: 111));
        });
      });

      // Reconnect after withServerpod shuts down, before dropping the fixture.
      tearDownAll(() async {
        try {
          await _withDatabase(projectDatabaseName, (session) async {
            final rows = await SimpleData.db.find(session);
            final databases = await session.db.unsafeQuery(
              'SELECT datname FROM pg_database WHERE datname = @databaseName;',
              parameters: QueryParameters.named({
                'databaseName': activeDatabaseName,
              }),
            );

            expect(rows.map((row) => row.num), [111]);
            expect(databases, isEmpty);
          });
        } finally {
          await projectDatabase?.drop();
        }
      });

      withServerpod(
        'when an endpoint writes SimpleData(222),',
        rollbackDatabase: RollbackDatabase.disabled,
        configOverride: (config) => config.copyWith(
          database: (config.database! as PostgresDatabaseConfig).withName(
            projectDatabaseName,
          ),
        ),
        (sessionBuilder, endpoints) {
          late List<SimpleData> rowsBeforeWrite;
          late List<SimpleData> rowsAfterWrite;

          setUpAll(() async {
            final database = await sessionBuilder.build().db.unsafeQuery(
              'SELECT current_database();',
            );
            activeDatabaseName = database.single[0] as String;
            rowsBeforeWrite = await endpoints.testTools.getAllSimpleData(
              sessionBuilder,
            );
            await endpoints.testTools.createSimpleData(sessionBuilder, 222);
            rowsAfterWrite = await endpoints.testTools.getAllSimpleData(
              sessionBuilder,
            );
          });

          test(
            'then the default database starts empty and is dropped after shutdown without changing the seed.',
            () {
              expect(activeDatabaseName, isNot(projectDatabaseName));
              expect(rowsBeforeWrite, isEmpty);
              expect(rowsAfterWrite.map((row) => row.num), [222]);
            },
          );
        },
      );
    },
  );
}

Future<T> _withDatabase<T>(
  String databaseName,
  Future<T> Function(Session session) action,
) async {
  final server = Serverpod(
    ['--mode', 'test'],
    Protocol(),
    Endpoints(),
    configOverride: (config) => config.copyWith(
      database: (config.database! as PostgresDatabaseConfig).withName(
        databaseName,
      ),
    ),
  );

  try {
    return await server.withSession(action, enableLogging: false);
  } finally {
    await server.shutdown(exitProcess: false);
  }
}
