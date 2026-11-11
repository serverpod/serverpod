import 'dart:io';

import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/sqlite/sqlite_pool_manager.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  late Directory directory;
  late SqlitePoolManager pool;
  late Database db;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('table_argument_');
    pool = SqlitePoolManager(
      _SerializationManager(),
      SqliteDatabaseConfig(filePath: '${directory.path}/test.db'),
    );
    db = _Session(pool).db;
  });

  tearDown(() async {
    await pool.stop();
    await directory.delete(recursive: true);
  });

  test(
    'Given a stored item, '
    'when finding items with the items table passed, '
    'then the item is returned.',
    () async {
      await db.unsafeExecute(
        'CREATE TABLE items (id INTEGER PRIMARY KEY, name TEXT NOT NULL) STRICT',
      );
      await db.insertRow(_Item(name: 'first'));

      final items = await db.find<_Item>(table: _ItemTable());

      expect(items.map((item) => item.name), ['first']);
    },
  );

  final operations =
      <({String name, Object? Function(Database db, Table table) run})>[
        (name: 'find', run: (db, table) => db.find<_Item>(table: table)),
        (
          name: 'findRow',
          run: (db, table) => db.findFirstRow<_Item>(table: table),
        ),
        (
          name: 'findById',
          run: (db, table) => db.findById<_Item>(1, table: table),
        ),
        (
          name: 'updateById',
          run: (db, table) => db.updateById<_Item>(
            1,
            table: table,
            columnValues: [ColumnValue(_ItemTable().name, 'renamed')],
          ),
        ),
        (
          name: 'updateWhere',
          run: (db, table) => db.updateWhere<_Item>(
            table: table,
            columnValues: [ColumnValue(_ItemTable().name, 'renamed')],
            where: Constant.bool(true),
          ),
        ),
        (
          name: 'deleteWhere',
          run: (db, table) =>
              db.deleteWhere<_Item>(table: table, where: Constant.bool(true)),
        ),
        (name: 'count', run: (db, table) => db.count<_Item>(table: table)),
        (name: 'watch', run: (db, table) => db.watch<_Item>(table: table)),
      ];

  for (final operation in operations) {
    test(
      'Given the table of another type, '
      'when passing it to ${operation.name} for items, '
      'then an assertion names the table and the type.',
      () {
        final others = Table<int?>(tableName: 'others');

        expect(
          () => operation.run(db, others),
          throwsA(
            isA<AssertionError>().having(
              (error) => error.message,
              'message',
              'The table "others" passed to ${operation.name}<_Item> is not '
                  'the table of _Item.',
            ),
          ),
        );
      },
    );
  }
}

class _Session implements DatabaseSession {
  _Session(SqlitePoolManager pool) {
    db = DatabaseConstructor.create(session: this, poolManager: pool);
  }

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
      }) {};
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
