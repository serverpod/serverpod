import 'dart:io';

import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/sqlite/sqlite_pool_manager.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  late Directory directory;
  late SqlitePoolManager pool;
  late _LoggingSession session;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('sqlite_query_logging_');
    pool = SqlitePoolManager(
      _SerializationManager(),
      SqliteDatabaseConfig(filePath: '${directory.path}/test.db'),
    );
    session = _LoggingSession(pool);
  });

  tearDown(() async {
    await pool.stop();
    await directory.delete(recursive: true);
  });

  group('Given 256 rows with the same insert columns, ', () {
    late List<_Item> inputs;

    setUp(() async {
      await session.db.unsafeExecute(
        'CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT NOT NULL) STRICT',
      );
      inputs = [
        for (var id = 1; id <= 256; id++) _Item(id: id, name: "item '$id'"),
      ];
    });

    group('when inserting the batch with returned rows, ', () {
      late List<_QueryLog> logs;
      late List<(int?, String)> returned;
      late List<Map<String, dynamic>> stored;

      setUp(() async {
        final rows = await session.db.insert(inputs);
        returned = rows.map((row) => (row.id, row.name)).toList();
        logs = session.insertLogs;
        stored = (await session.db.unsafeQuery(
          'SELECT id, name FROM items ORDER BY id',
        )).map((row) => row.toColumnMap()).toList();
      });

      test(
        'then the log contains one SQL shape and the total returned rows.',
        () {
          expect(logs, [
            (
              query:
                  'INSERT INTO "items" ("id", "name") VALUES (?, ?) RETURNING *',
              rows: 256,
              error: null,
            ),
          ]);
        },
      );

      test('then every input is returned and persisted in order.', () {
        expect(returned, [
          for (var id = 1; id <= 256; id++) (id, "item '$id'"),
        ]);
        expect(stored, [
          for (var id = 1; id <= 256; id++) {'id': id, 'name': "item '$id'"},
        ]);
      });
    });
  });

  group('Given inserts with interleaved generated and explicit IDs, ', () {
    late List<_Item> inputs;

    setUp(() async {
      await session.db.unsafeExecute(
        'CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT NOT NULL) STRICT',
      );
      inputs = [
        _Item(name: 'first'),
        _Item(id: 10, name: 'second'),
        _Item(name: 'third'),
      ];
    });

    group('when inserting the batch with returned rows, ', () {
      late List<_QueryLog> logs;
      late List<(int?, String)> returned;

      setUp(() async {
        final rows = await session.db.insert(inputs);
        returned = rows.map((row) => (row.id, row.name)).toList();
        logs = session.insertLogs;
      });

      test('then the log retains every SQL shape in execution order.', () {
        expect(logs, [
          (
            query:
                'INSERT INTO "items" ("name") VALUES (?) RETURNING *;\n'
                'INSERT INTO "items" ("id", "name") VALUES (?, ?) RETURNING *;\n'
                'INSERT INTO "items" ("name") VALUES (?) RETURNING *',
            rows: 3,
            error: null,
          ),
        ]);
      });

      test(
        'then all inputs execute in order despite their different shapes.',
        () {
          expect(returned, [(1, 'first'), (10, 'second'), (11, 'third')]);
        },
      );
    });
  });

  group('Given a returning insert batch with duplicate primary keys, ', () {
    late List<_Item> inputs;

    setUp(() async {
      await session.db.unsafeExecute(
        'CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT NOT NULL) STRICT',
      );
      inputs = [_Item(id: 1, name: 'first'), _Item(id: 1, name: 'duplicate')];
    });

    group('when the batch fails, ', () {
      late List<_QueryLog> logs;
      late Object? failure;
      late int count;

      setUp(() async {
        failure = null;
        try {
          await session.db.insert(inputs);
        } catch (error) {
          failure = error;
        }
        logs = session.insertLogs;
        count =
            (await session.db.unsafeQuery(
                  'SELECT count(*) FROM items',
                )).single.single
                as int;
      });

      test('then the error log contains the SQL shape once.', () {
        expect(failure, isA<DatabaseQueryException>());
        expect(logs, hasLength(1));
        expect(
          logs.single.query,
          'INSERT INTO "items" ("id", "name") VALUES (?, ?) RETURNING *',
        );
        expect(logs.single.rows, isNull);
        expect(logs.single.error, failure.toString());
      });

      test('then the failed batch leaves no persisted rows.', () {
        expect(failure, isA<DatabaseQueryException>());
        expect(count, 0);
      });
    });
  });
}

typedef _QueryLog = ({String query, int? rows, String? error});

class _LoggingSession implements DatabaseSession {
  _LoggingSession(SqlitePoolManager pool) {
    db = DatabaseConstructor.create(session: this, poolManager: pool);
  }

  final _logs = <_QueryLog>[];

  List<_QueryLog> get insertLogs => _logs
      .where((entry) => entry.query.startsWith('INSERT INTO "items"'))
      .toList();

  @override
  late final Database db;

  @override
  Transaction? get transaction => null;

  @override
  LogWarningFunction? get logWarning => null;

  @override
  LogQueryFunction get logQuery =>
      ({
        required query,
        required duration,
        required numRowsAffected,
        required error,
        required stackTrace,
      }) {
        _logs.add((query: query, rows: numRowsAffected, error: error));
      };
}

class _Item implements TableRow<int?> {
  _Item({this.id, required this.name});

  @override
  final int? id;

  final String name;

  @override
  Table<int?> get table => _ItemTable();

  @override
  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class _ItemTable extends Table<int?> {
  _ItemTable() : super(tableName: 'items');

  late final name = ColumnString('name', this);

  @override
  List<Column> get columns => [id, name];
}

class _SerializationManager extends DatabaseSerializationManager {
  @override
  String getModuleName() => 'test';

  @override
  Table? getTableForType(Type t) => t == _Item ? _ItemTable() : null;

  @override
  List<TableDefinition> getTargetTableDefinitions() => [];

  @override
  T deserialize<T>(dynamic data, [Type? t]) {
    if ((t ?? T) == _Item) {
      final json = data as Map<String, dynamic>;
      return _Item(id: json['id'] as int?, name: json['name'] as String) as T;
    }

    return super.deserialize<T>(data, t);
  }
}
