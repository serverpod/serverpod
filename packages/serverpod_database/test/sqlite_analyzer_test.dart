import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/sqlite/sqlite_analyzer.dart';
import 'package:serverpod_database/src/adapters/sqlite/sqlite_pool_manager.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;
  late SqlitePoolManager poolManager;
  late Database database;
  late DatabaseSession session;
  late SqliteDatabaseAnalyzer analyzer;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('sqlite_analyzer_test_');

    poolManager = SqlitePoolManager(
      _TestSerializationManager(),
      SqliteDatabaseConfig(filePath: p.join(tempDir.path, 'test.db')),
    )..start();

    session = _TestSession(() => database);
    database = DatabaseConstructor.create(
      session: session,
      poolManager: poolManager,
    );
    analyzer = SqliteDatabaseAnalyzer(database: database);
  });

  tearDown(() async {
    await poolManager.stop();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group(
    'Given a SQLite table with decimal columns recorded in the metadata table,',
    () {
      setUp(() async {
        await session.db.unsafeExecute('''
          CREATE TABLE "prices" (
            "id" INTEGER PRIMARY KEY,
            "unbounded" TEXT NOT NULL,
            "amount" TEXT NOT NULL
          ) STRICT;
        ''');

        await session.db.unsafeExecute('''
          CREATE TABLE "serverpod_sqlite_schema" (
            "table_name" TEXT NOT NULL,
            "column_name" TEXT NOT NULL,
            "column_type" TEXT NOT NULL,
            "column_vector_dimension" INTEGER,
            "column_decimal_precision" INTEGER,
            "column_decimal_scale" INTEGER,
            PRIMARY KEY ("table_name", "column_name")
          );
        ''');

        await session.db.unsafeExecute('''
          INSERT INTO "serverpod_sqlite_schema" VALUES
            ('prices', 'id', 'bigint', NULL, NULL, NULL),
            ('prices', 'unbounded', 'decimal', NULL, NULL, NULL),
            ('prices', 'amount', 'decimal', NULL, 10, 2);
        ''');
      });

      test(
        'when the analyzer reads column definitions, then unbounded decimals report null precision and scale',
        () async {
          final columns = await analyzer.getColumnDefinitions(
            schemaName: 'main',
            tableName: 'prices',
          );
          final unbounded = columns.firstWhere((c) => c.name == 'unbounded');
          expect(unbounded.columnType, equals(ColumnType.decimal));
          expect(unbounded.decimalPrecision, isNull);
          expect(unbounded.decimalScale, isNull);
        },
      );

      test(
        'when the analyzer reads column definitions, then bounded decimals report precision and scale',
        () async {
          final columns = await analyzer.getColumnDefinitions(
            schemaName: 'main',
            tableName: 'prices',
          );
          final amount = columns.firstWhere((c) => c.name == 'amount');
          expect(amount.columnType, equals(ColumnType.decimal));
          expect(amount.decimalPrecision, equals(10));
          expect(amount.decimalScale, equals(2));
        },
      );
    },
  );
}

class _TestSerializationManager extends SerializationManagerServer {
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
