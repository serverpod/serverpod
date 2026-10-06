// Invoked by ../compare.dart with the same fixture and SDK for both revisions.
import 'dart:io';
import 'dart:isolate';

import 'package:serverpod_cli/src/database/dialects/sqlite.dart';
import 'package:serverpod_database/serverpod_database.dart' hide Protocol;
import 'package:serverpod_database/src/adapters/sqlite/sqlite_migration_runner.dart';
import 'package:serverpod_test_sqlite_client/serverpod_test_sqlite_client.dart';
import 'package:sqlite3/sqlite3.dart' as native;

void require(bool condition, String message) {
  if (!condition) throw StateError(message);
}

Future<void> main(List<String> arguments) async {
  final quick = arguments.contains('--quick');
  final count = quick ? 100 : 1000;
  final largeCount = quick ? 500 : 10000;
  final plannerCount = quick ? 1000 : 100000;
  final warmups = quick ? 1 : 10;
  final samples = quick ? 3 : 7;
  final directory = await Directory.systemTemp.createTemp(
    'sqlite_orm_benchmark_',
  );
  final session = await Client('http://localhost:8080/').createSession(
    '${directory.path}/database',
  );

  Future<void> measure<T>(
    String name,
    Future<T> Function() operation, {
    Future<void> Function()? setup,
    required Future<void> Function(T) verify,
    Future<void> Function()? cleanup,
  }) async {
    final timings = <double>[];

    for (var iteration = -warmups; iteration < samples; iteration++) {
      await setup?.call();
      try {
        final watch = Stopwatch()..start();
        final result = await operation();
        watch.stop();

        // Validate every sample after timing, including every persisted value.
        await verify(result);
        if (iteration >= 0) timings.add(watch.elapsedMicroseconds / 1000);
      } finally {
        await cleanup?.call();
      }
    }

    stdout.writeln('RESULT\t$name\t${timings.join('\t')}');
    stderr.writeln('Measured $name');
  }

  Future<void> seedSimple(int size) => session.db.unsafeExecute('''
DELETE FROM simple_data;
WITH RECURSIVE n(i) AS (
  VALUES(1) UNION ALL SELECT i+1 FROM n WHERE i<$size
) INSERT INTO simple_data(id,num) SELECT i,-i FROM n;
''');

  Future<void> verifySimple(
    List<SimpleData> returned, {
    required bool returnsRows,
  }) async {
    final expected = List.generate(count, (i) => (i + 1, i));
    final actual = returned.map((row) => (row.id, row.num)).toList();
    require(
      returnsRows ? actual.toString() == expected.toString() : actual.isEmpty,
      'Wrong returned rows: $actual',
    );
    final stored = await SimpleData.db.find(session, orderBy: (t) => t.id);
    require(
      stored.map((r) => (r.id, r.num)).toList().toString() ==
          expected.toString(),
      'Wrong persisted rows',
    );
  }

  final inputs = List.generate(count, (i) => SimpleData(id: i + 1, num: i));
  final wideText = List.filled(4096, 'x').join();
  final wideList = List.generate(100, (i) => i);

  String hostLoad() {
    final file = File('/proc/loadavg');
    return file.existsSync() ? file.readAsStringSync().trim() : 'unavailable';
  }

  try {
    stdout.writeln('ENV\tprocessors\t${Platform.numberOfProcessors}');
    stdout.writeln('ENV\tload_start\t${hostLoad()}');
    stdout.writeln('ENV\tdart\t${Platform.version.replaceAll('\n', ' ')}');
    stdout.writeln(
      'ENV\tsqlite\t${(await session.db.unsafeQuery('SELECT sqlite_version()')).single.single}',
    );
    stdout.writeln(
      'ENV\tsqlite_source_id\t${(await session.db.unsafeQuery('SELECT sqlite_source_id()')).single.single}',
    );
    stdout.writeln(
      'ENV\tjournal_mode\t${(await session.db.unsafeQuery('PRAGMA journal_mode')).single.single}',
    );
    stdout.writeln(
      'ENV\tsynchronous\t${(await session.db.unsafeQuery('PRAGMA synchronous')).single.single}',
    );
    stdout.writeln(
      'ENV\tadapter\t${await Isolate.resolvePackageUri(Uri.parse('package:serverpod_database/src/adapters/sqlite/database_connection.dart'))}',
    );
    stdout.writeln(
      'ENV\tfixture\trows=$count, includes=$largeCount, planner=$plannerCount, warmups=$warmups, samples=$samples',
    );

    await measure(
      'insert_returning_$count',
      () => SimpleData.db.insert(session, inputs),
      setup: () => session.db.unsafeExecute('DELETE FROM simple_data'),
      verify: (r) => verifySimple(r, returnsRows: true),
    );
    await measure(
      'update_returning_$count',
      () => SimpleData.db.update(session, inputs),
      setup: () => seedSimple(count),
      verify: (r) => verifySimple(r, returnsRows: true),
    );
    await measure(
      'upsert_returning_$count',
      () =>
          SimpleData.db.upsert(session, inputs, conflictColumns: (t) => [t.id]),
      setup: () => seedSimple(count),
      verify: (r) => verifySimple(r, returnsRows: true),
    );
    await measure(
      'insert_no_return_$count',
      () => SimpleData.db.insert(session, inputs, noReturn: true),
      setup: () => session.db.unsafeExecute('DELETE FROM simple_data'),
      verify: (r) => verifySimple(r, returnsRows: false),
    );
    await measure(
      'update_no_return_$count',
      () => SimpleData.db.update(session, inputs, noReturn: true),
      setup: () => seedSimple(count),
      verify: (r) => verifySimple(r, returnsRows: false),
    );
    await measure(
      'upsert_no_return_$count',
      () => SimpleData.db.upsert(
        session,
        inputs,
        conflictColumns: (t) => [t.id],
        noReturn: true,
      ),
      setup: () => seedSimple(count),
      verify: (r) => verifySimple(r, returnsRows: false),
    );

    final wide = List.generate(
      count,
      (i) => Types(id: i + 1, aString: wideText, aList: wideList),
    );
    await measure(
      'upsert_wide_no_return_$count',
      () => Types.db.upsert(
        session,
        wide,
        conflictColumns: (t) => [t.id],
        noReturn: true,
      ),
      setup: () async {
        await session.db.unsafeExecute('DELETE FROM types');
        // Exercise conflict updates for every timed row, not warmup-only inserts.
        await Types.db.insert(
          session,
          List.generate(
            count,
            (i) => Types(id: i + 1, aString: 'old', aList: [-1]),
          ),
          noReturn: true,
        );
      },
      verify: (returned) async {
        require(returned.isEmpty, 'noReturn returned models');
        final stored = await Types.db.find(session, orderBy: (t) => t.id);
        require(stored.length == count, 'Wrong wide row count');
        for (var i = 0; i < count; i++) {
          require(
            stored[i].id == i + 1 &&
                stored[i].aString == wideText &&
                stored[i].aList.toString() == wideList.toString(),
            'Wrong wide row $i',
          );
        }
      },
    );

    await measure(
      'find_by_id_$count',
      () async {
        final returned = <SimpleData>[];
        for (var i = 1; i <= count; i++) {
          returned.add((await SimpleData.db.findById(session, i))!);
        }
        return returned;
      },
      setup: () => seedSimple(count),
      verify: (returned) async {
        require(returned.length == count, 'Wrong read count');
        for (var i = 0; i < count; i++) {
          require(
            returned[i].id == i + 1 && returned[i].num == -i - 1,
            'Wrong read $i',
          );
        }
      },
    );

    await measure(
      'update_where_no_return_$largeCount',
      () => SimpleData.db.updateWhere(
        session,
        columnValues: (t) => [t.num(7)],
        where: (t) => t.id > 0,
        orderBy: (t) => t.id,
        limit: largeCount,
        noReturn: true,
      ),
      setup: () => seedSimple(largeCount),
      verify: (returned) async {
        require(returned.isEmpty, 'updateWhere returned rows');
        final stored = await SimpleData.db.find(session, orderBy: (t) => t.id);
        require(stored.length == largeCount, 'Wrong updateWhere count');
        for (var i = 0; i < largeCount; i++) {
          require(
            stored[i].id == i + 1 && stored[i].num == 7,
            'Wrong updateWhere row $i',
          );
        }
      },
    );

    await session.db.unsafeExecute('''
INSERT INTO city(id,name) VALUES(1,'City');
INSERT INTO organization(id,name,"cityId") VALUES(1,'Organization',1);
WITH RECURSIVE n(i) AS (
  VALUES(1) UNION ALL SELECT i+1 FROM n WHERE i<$largeCount
) INSERT INTO person(id,name,"organizationId","_cityCitizensCityId")
  SELECT i,'Person ' || i,1,1 FROM n;
''');
    await measure(
      'include_children_$largeCount',
      () => City.db.findById(
        session,
        1,
        include: City.include(
          citizens: Person.includeList(orderBy: (t) => t.id),
        ),
      ),
      verify: (city) async {
        require(city?.citizens?.length == largeCount, 'Wrong child count');
        for (var i = 0; i < largeCount; i++) {
          require(
            city!.citizens![i].id == i + 1 &&
                city.citizens![i].name == 'Person ${i + 1}',
            'Wrong included child $i',
          );
        }
      },
    );
    await measure(
      'nested_includes_$largeCount',
      () => Person.db.find(
        session,
        orderBy: (t) => t.id,
        include: Person.include(
          organization: Organization.include(city: City.include()),
        ),
      ),
      verify: (people) async {
        require(people.length == largeCount, 'Wrong parent count');
        for (var i = 0; i < largeCount; i++) {
          require(
            people[i].id == i + 1 &&
                people[i].name == 'Person ${i + 1}' &&
                people[i].organization?.id == 1 &&
                people[i].organization?.name == 'Organization' &&
                people[i].organization?.city?.id == 1 &&
                people[i].organization?.city?.name == 'City',
            'Wrong nested include $i',
          );
        }
      },
    );

    final parentCount = largeCount ~/ 2;
    await session.db.unsafeExecute('''
WITH RECURSIVE n(i) AS (
  VALUES(2) UNION ALL SELECT i+1 FROM n WHERE i<$parentCount
) INSERT INTO city(id,name) SELECT i,'City ' || i FROM n;
UPDATE person SET "_cityCitizensCityId" = 1 + ((id - 1) % $parentCount);
''');
    await measure(
      'include_list_parents_$parentCount',
      () => City.db.find(
        session,
        orderBy: (t) => t.id,
        include: City.include(
          citizens: Person.includeList(orderBy: (t) => t.id),
        ),
      ),
      verify: (cities) async {
        require(cities.length == parentCount, 'Wrong list-parent count');
        for (var i = 0; i < parentCount; i++) {
          final city = cities[i];
          final citizens = city.citizens!;
          require(city.id == i + 1, 'Wrong list parent $i');
          require(citizens.length == 2, 'Wrong children for parent $i');
          for (var child = 0; child < 2; child++) {
            final expectedId = i + 1 + child * parentCount;
            require(
              citizens[child].id == expectedId &&
                  citizens[child].name == 'Person $expectedId',
              'Wrong child $child for parent $i',
            );
          }
        }
      },
    );

    final migrationSql = addLiteralColumnSql();
    const migrationRunner = SqliteDatabaseMigrationRunner(
      runMode: 'production',
    );
    await measure(
      'add_literal_default_$plannerCount',
      () => migrationRunner.runMigrations(
        session,
        (tx) => session.db.unsafeExecute(migrationSql, transaction: tx),
      ),
      setup: () => session.db.unsafeExecute('''
DROP TABLE IF EXISTS benchmark_migration;
CREATE TABLE benchmark_migration(id INTEGER PRIMARY KEY AUTOINCREMENT) STRICT;
WITH RECURSIVE n(i) AS (
  VALUES(1) UNION ALL SELECT i+1 FROM n WHERE i<$plannerCount
) INSERT INTO benchmark_migration SELECT i FROM n;
'''),
      verify: (_) async {
        final row = (await session.db.unsafeQuery(
          'SELECT count(*),sum(enabled),min(id),max(id) FROM benchmark_migration',
        )).single;
        require(
          row.toList().toString() ==
              [plannerCount, 0, 1, plannerCount].toString(),
          'Migration lost rows or defaults',
        );
      },
    );

    ClientDatabaseSession? planner;
    final plannerPath = '${directory.path}/planner.db';
    void prepareUnanalyzedDatabase() {
      final db = native.sqlite3.open(plannerPath);
      try {
        db.execute(
          'DROP TABLE IF EXISTS planner; CREATE TABLE planner(id INTEGER PRIMARY KEY, a INTEGER, b INTEGER)',
        );
        db.execute(
          'WITH RECURSIVE n(i) AS (VALUES(1) UNION ALL SELECT i+1 FROM n WHERE i<$plannerCount) INSERT INTO planner SELECT i,1,i FROM n',
        );
        db.execute(
          'CREATE INDEX planner_b ON planner(b); CREATE INDEX planner_a ON planner(a)',
        );
        final hasStatisticsTable = db
            .select(
              "SELECT 1 FROM sqlite_schema WHERE name='sqlite_stat1'",
            )
            .isNotEmpty;
        require(
          !hasStatisticsTable ||
              db
                  .select(
                    "SELECT 1 FROM sqlite_stat1 WHERE tbl='planner'",
                  )
                  .isEmpty,
          'Startup fixture must not already have planner statistics',
        );
      } finally {
        db.close();
      }
    }

    Future<void> seedPlanner() async {
      // Lookup timing excludes startup; the populated open/close workload
      // below measures that startup maintenance separately.
      prepareUnanalyzedDatabase();
      planner = await ClientDatabaseSession.open(
        plannerPath,
        Protocol(),
        runMigrations: false,
      );
    }

    await measure(
      'planner_lookups_100_of_$plannerCount',
      () async {
        final results = <int>[];
        for (var i = 0; i < 100; i++) {
          final id = 1 + (i * 997) % plannerCount;
          final row = (await planner!.db.unsafeQuery(
            'SELECT id FROM planner WHERE a=1 AND b=$id',
          )).single;
          results.add(row.single as int);
        }
        return results;
      },
      setup: seedPlanner,
      verify: (results) async {
        for (var i = 0; i < 100; i++) {
          require(
            results[i] == 1 + (i * 997) % plannerCount,
            'Wrong planner result $i',
          );
        }
      },
      cleanup: () async {
        await planner?.close();
        planner = null;
      },
    );

    await measure(
      'open_close_unanalyzed_$plannerCount',
      () async {
        final opened = await ClientDatabaseSession.open(
          plannerPath,
          Protocol(),
          runMigrations: false,
        );
        await opened.close();
      },
      setup: () async => prepareUnanalyzedDatabase(),
      verify: (_) async {
        final db = native.sqlite3.open(plannerPath);
        try {
          require(
            db.select('SELECT count(*) FROM planner').single.values.single ==
                plannerCount,
            'Startup lost rows',
          );
          require(
            db.select('SELECT 1 FROM planner WHERE a != 1 OR b != id').isEmpty,
            'Startup changed stored values',
          );
        } finally {
          db.close();
        }
      },
    );

    final openPath = '${directory.path}/open.db';
    await measure('open_close_empty', () async {
      final opened = await ClientDatabaseSession.open(
        openPath,
        Protocol(),
        runMigrations: false,
      );
      await opened.close();
    }, verify: (_) async {});
    stdout.writeln('ENV\tload_end\t${hostLoad()}');
  } finally {
    await session.close();
    await directory.delete(recursive: true);
  }
}

String addLiteralColumnSql() {
  final column = ColumnDefinition(
    name: 'enabled',
    columnType: ColumnType.boolean,
    isNullable: false,
    columnDefault: defaultBooleanFalse,
  );
  final table = TableDefinition(
    name: 'benchmark_migration',
    schema: 'main',
    columns: [
      ColumnDefinition(
        name: 'id',
        columnType: ColumnType.integer,
        isNullable: false,
        columnDefault: defaultIntSerial,
      ),
      column,
    ],
    foreignKeys: [],
    indexes: [],
  );

  return TableMigration(
    name: table.name,
    schema: 'main',
    addColumns: [column],
    deleteColumns: [],
    modifyColumns: [],
    addIndexes: [],
    deleteIndexes: [],
    addForeignKeys: [],
    deleteForeignKeys: [],
    warnings: [],
  ).toSql(
    DatabaseDefinition(
      moduleName: 'benchmark',
      tables: [table],
      installedModules: [],
      migrationApiVersion: 1,
    ),
  );
}
