import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  // withServerpod resolves config during test registration, before setUpAll.
  final databaseDirectory = Directory(
    p.join(Directory.systemTemp.path, 'sp_ephemeral_flag_${const Uuid().v4()}'),
  );

  setUpAll(() async {
    await databaseDirectory.create(recursive: true);
  });

  tearDownAll(() async {
    if (databaseDirectory.existsSync()) {
      await databaseDirectory.delete(recursive: true);
    }
  });

  group(
    'Given a SQLite database seeded with SimpleData(111) with ephemeralDatabase disabled and rollbacks disabled,',
    () {
      final projectDatabasePath = p.join(
        databaseDirectory.path,
        'opt_out',
        'project.db',
      );

      setUpAll(() async {
        await _seedDatabase(projectDatabasePath, SimpleData(num: 111));
      });

      // The enclosing teardown runs after withServerpod shuts down.
      tearDownAll(() async {
        expect(File(projectDatabasePath).existsSync(), isTrue);
        expect(await _readNumbers(projectDatabasePath), [111, 222]);
        expect(_databaseFiles(projectDatabasePath), {projectDatabasePath});
      });

      withServerpod(
        'when an endpoint writes SimpleData(222),',
        ephemeralDatabase: false,
        rollbackDatabase: RollbackDatabase.disabled,
        configOverride: (config) => config.copyWith(
          database: SqliteDatabaseConfig(filePath: projectDatabasePath),
        ),
        (sessionBuilder, endpoints) {
          late String activeDatabasePath;
          late List<SimpleData> rows;

          setUpAll(() async {
            activeDatabasePath = await _currentDatabasePath(
              sessionBuilder.build(),
            );
            await endpoints.testTools.createSimpleData(sessionBuilder, 222);
            rows = await endpoints.testTools.getAllSimpleData(sessionBuilder);
          });

          test(
            'then it uses the seeded database and preserves both rows after shutdown.',
            () {
              expect(activeDatabasePath, p.normalize(projectDatabasePath));
              expect(rows.map((row) => row.num), unorderedEquals([111, 222]));
            },
          );
        },
      );
    },
  );

  group(
    'Given a SQLite database seeded with SimpleData(111) with ephemeralDatabase omitted and rollbacks disabled,',
    () {
      final projectDatabasePath = p.join(
        databaseDirectory.path,
        'default',
        'project.db',
      );

      setUpAll(() async {
        await _seedDatabase(projectDatabasePath, SimpleData(num: 111));
      });

      tearDownAll(() async {
        expect(File(projectDatabasePath).existsSync(), isTrue);
        expect(await _readNumbers(projectDatabasePath), [111]);
        expect(_databaseFiles(projectDatabasePath), {projectDatabasePath});
      });

      withServerpod(
        'when an endpoint writes SimpleData(222),',
        rollbackDatabase: RollbackDatabase.disabled,
        configOverride: (config) => config.copyWith(
          database: SqliteDatabaseConfig(filePath: projectDatabasePath),
        ),
        (sessionBuilder, endpoints) {
          late String activeDatabasePath;
          late List<SimpleData> rowsBeforeWrite;
          late List<SimpleData> rowsAfterWrite;

          setUpAll(() async {
            activeDatabasePath = await _currentDatabasePath(
              sessionBuilder.build(),
            );
            rowsBeforeWrite = await endpoints.testTools.getAllSimpleData(
              sessionBuilder,
            );
            await endpoints.testTools.createSimpleData(sessionBuilder, 222);
            rowsAfterWrite = await endpoints.testTools.getAllSimpleData(
              sessionBuilder,
            );
          });

          test(
            'then the default database starts empty and is removed after shutdown without changing the seed.',
            () {
              expect(
                activeDatabasePath,
                isNot(p.normalize(projectDatabasePath)),
              );
              expect(
                p.dirname(activeDatabasePath),
                p.dirname(projectDatabasePath),
              );
              expect(File(activeDatabasePath).existsSync(), isTrue);
              expect(rowsBeforeWrite, isEmpty);
              expect(rowsAfterWrite.map((row) => row.num), [222]);
            },
          );
        },
      );
    },
  );
}

Future<void> _seedDatabase(String path, SimpleData seed) async {
  await File(path).parent.create(recursive: true);
  final session = await ClientDatabaseSession.open(path, Protocol());

  try {
    await applyMigrationsAndVerify(
      session: session,
      projectDirectory: Directory.current,
      runMode: 'test',
      applyRepairMigration: false,
      applyMigrations: true,
    );
    await SimpleData.db.insertRow(session, seed);
  } finally {
    await session.close();
  }
}

Future<List<int>> _readNumbers(String path) async {
  final session = await ClientDatabaseSession.open(path, Protocol());

  try {
    final rows = await SimpleData.db.find(
      session,
      orderBy: (table) => table.num,
    );
    return rows.map((row) => row.num).toList();
  } finally {
    await session.close();
  }
}

Set<String> _databaseFiles(String projectDatabasePath) {
  return File(
    projectDatabasePath,
  ).parent.listSync().whereType<File>().map((file) => file.path).toSet();
}

Future<String> _currentDatabasePath(Session session) async {
  final rows = await session.db.unsafeQuery('PRAGMA database_list;');
  final main = rows
      .map((row) => row.toColumnMap())
      .firstWhere((column) => column['name'] == 'main');
  return p.normalize(main['file']! as String);
}
