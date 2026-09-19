import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/sqlite/sqlite_pool_manager.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;
  late SqlitePoolManager poolManager;
  late Database database;
  late DatabaseSession session;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('database_watch_test_');

    poolManager = SqlitePoolManager(
      _TestSerializationManager(),
      SqliteDatabaseConfig(filePath: p.join(tempDir.path, 'test.db')),
    )..start();
    await poolManager.started;

    session = _TestSession(() => database);
    database = DatabaseConstructor.create(
      session: session,
      poolManager: poolManager,
    );
  });

  tearDown(() async {
    await poolManager.stop();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Given a SQLite table with an existing row, ', () {
    setUp(() async {
      await database.unsafeExecute(
        'CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT NOT NULL);',
      );
      await database.unsafeExecute(
        "INSERT INTO items (name) VALUES ('alpha');",
      );
    });

    group('when watching a select query, ', () {
      late StreamIterator<DatabaseResult> iterator;

      setUp(() {
        iterator = StreamIterator(
          database.unsafeWatch('SELECT name FROM items ORDER BY id;'),
        );
      });

      tearDown(() async {
        await iterator.cancel();
      });

      test('then the stream emits the current rows immediately.', () async {
        expect(await iterator.moveNext(), isTrue);
        expect(
          iterator.current.map((row) => row.toColumnMap()).toList(),
          [
            {'name': 'alpha'},
          ],
        );
      });
    });

    group(
      'when watching a select query with triggerOnTables set to the queried table, ',
      () {
        late StreamIterator<DatabaseResult> iterator;

        setUp(() {
          iterator = StreamIterator(
            database.unsafeWatch(
              'SELECT name FROM items ORDER BY id;',
              throttle: const Duration(milliseconds: 10),
              triggerOnTables: const ['items'],
            ),
          );
        });

        tearDown(() async {
          await iterator.cancel();
        });

        test('then the stream emits the current rows immediately.', () async {
          expect(await iterator.moveNext(), isTrue);
          expect(
            iterator.current.map((row) => row.toColumnMap()).toList(),
            [
              {'name': 'alpha'},
            ],
          );
        });
      },
    );
  });

  group('Given a SQLite table with rows named alpha and beta, ', () {
    setUp(() async {
      await database.unsafeExecute(
        'CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT NOT NULL);',
      );
      await database.unsafeExecute(
        "INSERT INTO items (name) VALUES ('alpha');",
      );
      await database.unsafeExecute(
        "INSERT INTO items (name) VALUES ('beta');",
      );
    });

    group(
      'when watching a select query with a filter using positional QueryParameters, ',
      () {
        late StreamIterator<DatabaseResult> iterator;

        setUp(() {
          iterator = StreamIterator(
            database.unsafeWatch(
              r'SELECT name FROM items WHERE name = $1;',
              parameters: QueryParameters.positional(['beta']),
            ),
          );
        });

        tearDown(() async {
          await iterator.cancel();
        });

        test('then the stream emits only the matching rows.', () async {
          expect(await iterator.moveNext(), isTrue);
          expect(
            iterator.current.map((row) => row.toColumnMap()).toList(),
            [
              {'name': 'beta'},
            ],
          );
        });
      },
    );

    group(
      'when watching a select query with a filter using named QueryParameters, ',
      () {
        late StreamIterator<DatabaseResult> iterator;

        setUp(() {
          iterator = StreamIterator(
            database.unsafeWatch(
              'SELECT name FROM items WHERE name = @name;',
              parameters: QueryParameters.named({'name': 'alpha'}),
            ),
          );
        });

        tearDown(() async {
          await iterator.cancel();
        });

        test('then the stream emits only the matching rows.', () async {
          expect(await iterator.moveNext(), isTrue);
          expect(
            iterator.current.map((row) => row.toColumnMap()).toList(),
            [
              {'name': 'alpha'},
            ],
          );
        });
      },
    );
  });

  group(
    'Given an active watch subscription on a SQLite table with an existing row, ',
    () {
      late StreamIterator<DatabaseResult> iterator;

      setUp(() async {
        await database.unsafeExecute(
          'CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT NOT NULL);',
        );
        await database.unsafeExecute(
          "INSERT INTO items (name) VALUES ('alpha');",
        );

        iterator = StreamIterator(
          database.unsafeWatch(
            'SELECT name FROM items ORDER BY id;',
            throttle: const Duration(milliseconds: 10),
          ),
        );
        await iterator.moveNext();
      });

      tearDown(() async {
        await iterator.cancel();
      });

      group('when a new row is inserted, ', () {
        setUp(() async {
          await database.unsafeExecute(
            "INSERT INTO items (name) VALUES ('beta');",
          );
        });

        test('then the stream emits the updated result.', () async {
          expect(
            await iterator.moveNext().timeout(const Duration(seconds: 2)),
            isTrue,
          );
          expect(
            iterator.current.map((row) => row.toColumnMap()).toList(),
            [
              {'name': 'alpha'},
              {'name': 'beta'},
            ],
          );
        });
      });
    },
  );

  group(
    'Given an active watch subscription with triggerOnTables set to the queried table, ',
    () {
      late StreamIterator<DatabaseResult> iterator;

      setUp(() async {
        await database.unsafeExecute(
          'CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT NOT NULL);',
        );
        await database.unsafeExecute(
          "INSERT INTO items (name) VALUES ('alpha');",
        );

        iterator = StreamIterator(
          database.unsafeWatch(
            'SELECT name FROM items ORDER BY id;',
            throttle: const Duration(milliseconds: 10),
            triggerOnTables: const ['items'],
          ),
        );
        await iterator.moveNext();
      });

      tearDown(() async {
        await iterator.cancel();
      });

      group('when a new row is inserted, ', () {
        setUp(() async {
          await database.unsafeExecute(
            "INSERT INTO items (name) VALUES ('gamma');",
          );
        });

        test('then the stream emits the updated result.', () async {
          expect(
            await iterator.moveNext().timeout(const Duration(seconds: 2)),
            isTrue,
          );
          expect(
            iterator.current.map((row) => row.toColumnMap()).toList(),
            [
              {'name': 'alpha'},
              {'name': 'gamma'},
            ],
          );
        });
      });
    },
  );

  group(
    'Given an active watch subscription with triggerOnTables set to the queried table and an unrelated table, ',
    () {
      late List<List<Map<String, dynamic>>> emissions;
      late StreamSubscription<DatabaseResult> subscription;

      setUp(() async {
        await database.unsafeExecute(
          'CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT NOT NULL);',
        );
        await database.unsafeExecute(
          "INSERT INTO items (name) VALUES ('alpha');",
        );
        await database.unsafeExecute(
          'CREATE TABLE other (id INTEGER PRIMARY KEY);',
        );

        emissions = [];
        subscription = database
            .unsafeWatch(
              'SELECT name FROM items ORDER BY id;',
              throttle: const Duration(milliseconds: 10),
              triggerOnTables: const ['items'],
            )
            .listen(
              (result) => emissions.add(
                result.map((row) => row.toColumnMap()).toList(),
              ),
            );
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });

      tearDown(() async {
        await subscription.cancel();
      });

      group('when a row is inserted into the unrelated table, ', () {
        setUp(() async {
          await database.unsafeExecute('INSERT INTO other DEFAULT VALUES;');
          await Future<void>.delayed(const Duration(milliseconds: 400));
        });

        test('then the stream does not emit again.', () {
          expect(emissions, [
            [
              {'name': 'alpha'},
            ],
          ]);
        });
      });
    },
  );
}

class _TestSerializationManager extends DatabaseSerializationManager {
  @override
  String getModuleName() => 'test';

  @override
  Table? getTableForType(Type t) => null;

  @override
  List<TableDefinition> getTargetTableDefinitions() => [];
}

class _TestSession implements DatabaseSession {
  _TestSession(this._database);

  final Database Function() _database;

  @override
  Database get db => _database();

  @override
  Transaction? get transaction => null;

  @override
  LogQueryFunction? get logQuery => null;

  @override
  LogWarningFunction? get logWarning => null;
}
