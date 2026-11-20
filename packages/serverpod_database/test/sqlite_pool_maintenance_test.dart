import 'dart:async';
import 'dart:io';

import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/sqlite/sqlite_pool_manager.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  late Directory directory;
  late SqlitePoolManager pool;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('sqlite_maintenance_');
    pool = SqlitePoolManager(
      _SerializationManager(),
      SqliteDatabaseConfig(
        filePath: '${directory.path}/db',
        maxConnectionCount: 2,
      ),
      optimizationInterval: const Duration(milliseconds: 20),
    );
  });

  tearDown(() async {
    await pool.stop();
    await directory.delete(recursive: true);
  });

  group('Given reader connections with outdated planner statistics, ', () {
    const query =
        'EXPLAIN QUERY PLAN '
        'SELECT id FROM items WHERE a=1 AND b=5000';
    late List<String> initialPlans;

    setUp(() async {
      final db = await pool.database;
      initialPlans = [];
      await db.withAllConnections((writer, readers) async {
        await writer.execute(
          'CREATE TABLE items(id INTEGER PRIMARY KEY, a INTEGER, b INTEGER)',
        );
        await writer.execute(
          'WITH RECURSIVE n(i) AS '
          '(VALUES(1) UNION ALL SELECT i+1 FROM n WHERE i<10000) '
          'INSERT INTO items SELECT i, 1, i FROM n',
        );
        await writer.execute('CREATE INDEX idx_b ON items(b)');
        await writer.execute('CREATE INDEX idx_a ON items(a)');
        for (final reader in readers) {
          initialPlans.add(
            (await reader.getAll(query)).single['detail'] as String,
          );
        }
      });
    });

    group('when periodic planner maintenance runs, ', () {
      late bool refreshed;
      late List<List<Object?>> writableSchema;
      late List<List<Object?>> rowCounts;

      setUp(() async {
        final db = await pool.database;
        final deadline = DateTime.now().add(const Duration(seconds: 10));
        refreshed = false;
        while (!refreshed && DateTime.now().isBefore(deadline)) {
          await Future<void>.delayed(const Duration(milliseconds: 20));
          refreshed = await db.withAllConnections((writer, readers) async {
            for (final reader in readers) {
              final plan =
                  (await reader.getAll(query)).single['detail'] as String;
              if (!plan.contains('idx_b')) return false;
            }
            return true;
          });
        }
        writableSchema = [];
        rowCounts = [];
        await db.withAllConnections((writer, readers) async {
          for (final reader in readers) {
            writableSchema.add(
              (await reader.getAll(
                'PRAGMA writable_schema',
              )).single.values.toList(),
            );
            rowCounts.add(
              (await reader.getAll(
                'SELECT count(*) FROM items',
              )).single.values.toList(),
            );
          }
        });
      });

      test(
        'then every reader switches from outdated to refreshed statistics.',
        () {
          expect(initialPlans, isNotEmpty);
          for (final plan in initialPlans) {
            expect(plan, contains('idx_a'));
          }
          expect(refreshed, isTrue);
        },
      );

      test('then schema writes remain disabled on every reader.', () {
        for (final values in writableSchema) {
          expect(values, [0]);
        }
      });

      test('then all stored rows are retained.', () {
        for (final values in rowCounts) {
          expect(values, [10000]);
        }
      });
    });
  });

  group('Given busy readers during periodic maintenance, ', () {
    late Database database;
    late Completer<void> releaseReaders;
    late Future<List<void>> busyReaders;

    setUp(() async {
      final driver = await pool.database;
      final session = _Session(() => database);
      database = DatabaseConstructor.create(
        session: session,
        poolManager: pool,
      );
      await database.unsafeExecute('CREATE TABLE items(value INTEGER)');
      final readersEntered = Completer<void>();
      releaseReaders = Completer<void>();
      var readerCount = 0;
      busyReaders = Future.wait([
        for (var i = 0; i < driver.maxReaders; i++)
          driver.readLock((reader) async {
            if (++readerCount == driver.maxReaders) readersEntered.complete();
            await releaseReaders.future;
          }),
      ]);
      addTearDown(() async {
        if (!releaseReaders.isCompleted) releaseReaders.complete();
        await busyReaders;
      });
      await readersEntered.future;
    });

    group('when a write transaction reads outside its snapshot, ', () {
      Object? failure;
      late DatabaseResult values;

      setUp(() async {
        failure = null;
        Future<DatabaseResult>? independentRead;
        try {
          await database.transaction((tx) async {
            await database.unsafeExecute(
              'INSERT INTO items VALUES (1)',
              transaction: tx,
            );
            // Enqueue maintenance while the writer and all readers are busy.
            await Future<void>.delayed(const Duration(milliseconds: 80));
            independentRead = database.unsafeQuery(
              'SELECT count(*) FROM items',
            );
            await Future<void>.delayed(const Duration(milliseconds: 20));
            releaseReaders.complete();
            // Release the writer on timeout so a regression can still clean up.
            await independentRead!.timeout(const Duration(seconds: 2));
          });
        } catch (error) {
          failure = error;
        } finally {
          if (!releaseReaders.isCompleted) releaseReaders.complete();
          await busyReaders;
          await independentRead;
        }
        await database.unsafeExecute('INSERT INTO items VALUES (2)');
        values = await database.unsafeQuery(
          'SELECT value FROM items ORDER BY value',
        );
      });

      test('then the read completes without deadlocking.', () {
        expect(failure, isNull);
      });

      test('then subsequent writes complete.', () {
        expect(values.map((row) => row.single), [1, 2]);
      });
    });
  });

  group('Given startup maintenance is still pending, ', () {
    setUp(() {
      pool.start();
    });

    group('when stopping and restarting the pool, ', () {
      Object? stoppedAccessFailure;
      late bool connected;

      setUp(() async {
        stoppedAccessFailure = null;
        await pool.stop();
        try {
          await pool.database;
        } catch (error) {
          stoppedAccessFailure = error;
        }
        pool.start();
        connected = await pool.testConnection();
      });

      test('then the stopped database is inaccessible.', () {
        expect(stoppedAccessFailure, isStateError);
      });

      test('then the restarted database is usable.', () {
        expect(connected, isTrue);
      });
    });
  });

  group('Given periodic maintenance is waiting behind a write lock, ', () {
    late Completer<void> release;
    late Future<void> write;

    setUp(() async {
      final db = await pool.database;
      final entered = Completer<void>();
      release = Completer<void>();
      write = db.writeLock((writer) async {
        entered.complete();
        await release.future;
      });
      addTearDown(() async {
        if (!release.isCompleted) release.complete();
        await write;
      });
      await entered.future;
      await Future<void>.delayed(const Duration(milliseconds: 80));
    });

    group('when stopping the pool and releasing the lock, ', () {
      Object? restartFailure;
      Object? stoppedAccessFailure;
      late bool closed;

      setUp(() async {
        restartFailure = null;
        stoppedAccessFailure = null;
        final db = await pool.database;
        final stopped = pool.stop();
        try {
          pool.start();
        } catch (error) {
          restartFailure = error;
        }
        release.complete();
        await write;
        await stopped.timeout(const Duration(seconds: 10));
        await Future<void>.delayed(const Duration(milliseconds: 80));
        closed = db.closed;
        try {
          await pool.database;
        } catch (error) {
          stoppedAccessFailure = error;
        }
      });

      test('then restarting during shutdown is rejected.', () {
        expect(restartFailure, isStateError);
      });

      test(
        'then shutdown waits for maintenance and leaves the database closed.',
        () {
          expect(closed, isTrue);
          expect(stoppedAccessFailure, isStateError);
        },
      );
    });
  });
}

class _Session implements DatabaseSession {
  _Session(this._database);
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

class _SerializationManager extends DatabaseSerializationManager {
  @override
  String getModuleName() => 'test';

  @override
  Table? getTableForType(Type t) => null;

  @override
  List<TableDefinition> getTargetTableDefinitions() => [];
}
