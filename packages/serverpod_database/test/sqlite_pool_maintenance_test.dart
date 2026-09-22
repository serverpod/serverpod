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
        preparedStatementCacheSize: 100,
      ),
      optimizationInterval: const Duration(milliseconds: 20),
    );
  });

  tearDown(() async {
    await pool.stop();
    await directory.delete(recursive: true);
  });

  test(
    'Given cached reader plans for newly indexed data, '
    'when periodic planner maintenance runs, '
    'then every reader uses refreshed statistics with schema writes disabled.',
    () async {
      final db = await pool.database;
      const query =
          'EXPLAIN QUERY PLAN '
          'SELECT id FROM items WHERE a=1 AND b=5000';
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
          expect(
            (await reader.getAll(query)).single['detail'],
            contains('idx_a'),
          );
        }
      });

      final deadline = DateTime.now().add(const Duration(seconds: 10));
      var refreshed = false;
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

      expect(refreshed, isTrue);
      await db.withAllConnections((writer, readers) async {
        for (final reader in readers) {
          expect(
            (await reader.getAll('PRAGMA writable_schema')).single.values,
            [0],
          );
          expect(
            (await reader.getAll('SELECT count(*) FROM items')).single.values,
            [10000],
          );
        }
      });
    },
  );

  test(
    'Given busy readers and a write transaction during periodic maintenance, '
    'when the transaction reads outside its snapshot, '
    'then the read and subsequent writes complete without deadlocking.',
    () async {
      final driver = await pool.database;
      late Database database;
      final session = _Session(() => database);
      database = DatabaseConstructor.create(
        session: session,
        poolManager: pool,
      );
      await database.unsafeExecute('CREATE TABLE items(value INTEGER)');
      final readersEntered = Completer<void>();
      final releaseReaders = Completer<void>();
      var readerCount = 0;
      final busyReaders = Future.wait([
        for (var i = 0; i < driver.maxReaders; i++)
          driver.readLock((reader) async {
            if (++readerCount == driver.maxReaders) readersEntered.complete();
            await releaseReaders.future;
          }),
      ]);
      await readersEntered.future;
      Object? failure;
      Future<DatabaseResult>? independentRead;

      try {
        await database.transaction((tx) async {
          await database.unsafeExecute(
            'INSERT INTO items VALUES (1)',
            transaction: tx,
          );
          // Let the timer enqueue maintenance while the writer and all readers
          // are busy, then request the adapter's out-of-transaction read.
          await Future<void>.delayed(const Duration(milliseconds: 80));
          independentRead = database.unsafeQuery('SELECT count(*) FROM items');
          await Future<void>.delayed(const Duration(milliseconds: 20));
          releaseReaders.complete();
          // A regression times out inside the transaction, releasing its
          // writer so the test can clean up rather than hanging the process.
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

      expect(failure, isNull);
      final values = await database.unsafeQuery(
        'SELECT value FROM items ORDER BY value',
      );
      expect(values.map((row) => row.single), [1, 2]);
    },
  );

  test(
    'Given startup maintenance is still pending, '
    'when stopping the pool and then starting it again, '
    'then the stopped handles close and the restarted database is usable.',
    () async {
      pool.start();

      await pool.stop();
      await expectLater(pool.database, throwsStateError);
      pool.start();

      expect(await pool.testConnection(), isTrue);
    },
  );

  test(
    'Given periodic maintenance is waiting behind a write lock, '
    'when stopping the pool and releasing the lock, '
    'then shutdown waits for maintenance and leaves the database closed.',
    () async {
      final db = await pool.database;
      final entered = Completer<void>();
      final release = Completer<void>();
      final write = db.writeLock((writer) async {
        entered.complete();
        await release.future;
      });
      await entered.future;
      await Future<void>.delayed(const Duration(milliseconds: 80));

      final stopped = pool.stop();
      expect(pool.start, throwsStateError);
      release.complete();
      await write;
      await stopped.timeout(const Duration(seconds: 10));
      await Future<void>.delayed(const Duration(milliseconds: 80));

      expect(db.closed, isTrue);
      await expectLater(pool.database, throwsStateError);
    },
  );
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
