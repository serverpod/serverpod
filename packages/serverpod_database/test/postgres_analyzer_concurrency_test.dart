import 'dart:async';

import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/adapters/postgres/postgres_analyzer.dart';
import 'package:test/test.dart';

void main() {
  test('bounds pending metadata work for a large schema', () async {
    final probe = _Probe(List.generate(480, (i) => ('public', 'table_$i')));
    final result = probe.analyzer.getTableDefinitions();
    addTearDown(() async {
      probe.releaseAll();
      await result;
    });
    await _turn();

    expect(probe.startedTables, hasLength(3));
    expect(probe.pendingQueries, 9);
    probe.releaseAll();
    expect(await result, hasLength(480));
    expect(probe.maximumPendingQueries, lessThanOrEqualTo(9));
  });

  test(
    'keeps catalog order and schema names when tables finish out of order',
    () async {
      final tables = [('second', 'same'), ('public', 'z'), ('first', 'same')];
      final probe = _Probe(tables);
      final result = probe.analyzer.getTableDefinitions();
      addTearDown(probe.releaseAll);
      await _turn();
      for (final table in tables.reversed) {
        probe.release(table);
        await _turn();
      }
      final definitions = await result;
      expect(definitions.map((t) => (t.schema, t.name)), orderedEquals(tables));
      expect(definitions.every((t) => t.columns.single.name == 'id'), isTrue);
      expect(
        definitions.map((t) => t.foreignKeys.single.referenceTableSchema),
        tables.map((t) => t.$1),
      );
      expect(
        definitions.map((t) => t.indexes.single.indexName),
        tables.map((t) => '${t.$1}_${t.$2}_pk'),
      );
      expect(probe.calls.where((c) => c.endsWith(':columns')), hasLength(3));
      expect(
        probe.calls.where((c) => c.endsWith(':foreignKeys')),
        hasLength(3),
      );
      expect(probe.calls.where((c) => c.endsWith(':indexes')), hasLength(3));
    },
  );

  test('handles an empty schema without starting metadata queries', () async {
    final probe = _Probe([]);
    expect(await probe.analyzer.getTableDefinitions(), isEmpty);
    expect(probe.calls, isEmpty);
  });

  for (final size in [1, 2, 4, 7]) {
    test('returns all definitions for $size tables', () async {
      final tables = List.generate(size, (i) => ('public', 't$i'));
      final probe = _Probe(tables)..releaseAll();
      final definitions = await probe.analyzer.getTableDefinitions();
      expect(definitions.map((t) => t.name), tables.map((t) => t.$2));
      expect(probe.calls, hasLength(size * 3));
    });
  }

  test(
    'observes sibling metadata failures without unhandled async errors',
    () async {
      final unhandled = <Object>[];
      final finished = Completer<void>();
      unawaited(
        runZonedGuarded(() async {
          try {
            final probe = _Probe([
              ('public', 'broken'),
              ('other', 'broken'),
            ], failAll: true)..releaseAll();
            await expectLater(
              probe.analyzer.getTableDefinitions(),
              throwsA(isA<StateError>()),
            );
            await _turn();
            finished.complete();
          } catch (error, stack) {
            finished.completeError(error, stack);
          }
        }, (error, _) => unhandled.add(error)),
      );
      await finished.future;
      expect(unhandled, isEmpty);
    },
  );

  test('waits for already-started metadata before reporting failure', () async {
    final probe = _Probe([('public', 'broken')]);
    final result = probe.analyzer.getTableDefinitions();
    Object? failure;
    var completed = false;
    final observed = result.then<void>(
      (_) {
        completed = true;
      },
      onError: (Object error) {
        failure = error;
        completed = true;
      },
    );
    addTearDown(() async {
      probe.releaseAll();
      await observed;
    });
    await _turn();
    probe.failColumns(('public', 'broken'));
    await _turn();
    expect(completed, isFalse);
    probe.releaseAll();
    await observed;
    expect(failure, isA<StateError>());
    expect(probe.pendingQueries, 0);
  });
}

Future<void> _turn() => Future<void>.delayed(Duration.zero);

typedef _Table = (String, String);

/// Controls metadata completion while running the real getTableDefinitions().
class _Probe {
  _Probe(this.tables, {this.failAll = false});

  final List<_Table> tables;
  final bool failAll;
  late final analyzer = _Analyzer(this);
  final calls = <String>[];
  final startedTables = <_Table>{};
  final _gates = <String, Completer<void>>{};
  var pendingQueries = 0;
  var maximumPendingQueries = 0;
  var _released = false;

  String _key(_Table table, String kind) => '${table.$1}.${table.$2}:$kind';

  Future<void> query(_Table table, String kind) async {
    final key = _key(table, kind);
    calls.add(key);
    startedTables.add(table);
    pendingQueries++;
    if (pendingQueries > maximumPendingQueries) {
      maximumPendingQueries = pendingQueries;
    }
    try {
      if (!_released) {
        await (_gates[key] ??= Completer<void>()).future;
      }
      // Separate async failures model independently completing DB requests.
      await _turn();
      if (failAll) throw StateError('metadata failed: $kind');
    } finally {
      pendingQueries--;
    }
  }

  void release(_Table table) {
    for (final kind in ['columns', 'foreignKeys', 'indexes']) {
      final gate = _gates[_key(table, kind)];
      if (gate != null && !gate.isCompleted) gate.complete();
    }
  }

  void failColumns(_Table table) {
    _gates[_key(table, 'columns')]!.completeError(StateError('columns failed'));
  }

  void releaseAll() {
    _released = true;
    for (final gate in _gates.values) {
      if (!gate.isCompleted) gate.complete();
    }
  }
}

class _Analyzer extends PostgresDatabaseAnalyzer {
  _Analyzer(this.probe) : super(database: _CatalogDatabase(probe.tables));
  final _Probe probe;

  @override
  Future<List<ColumnDefinition>> getColumnDefinitions({
    required String schemaName,
    required String tableName,
  }) async {
    await probe.query((schemaName, tableName), 'columns');
    return [
      ColumnDefinition(
        name: 'id',
        columnType: ColumnType.integer,
        isNullable: false,
      ),
    ];
  }

  @override
  Future<List<ForeignKeyDefinition>> getForeignKeyDefinitions({
    required String schemaName,
    required String tableName,
  }) async {
    await probe.query((schemaName, tableName), 'foreignKeys');
    return [
      ForeignKeyDefinition(
        constraintName: '${schemaName}_${tableName}_fk',
        columns: ['id'],
        referenceTable: 'parent',
        referenceTableSchema: schemaName,
        referenceColumns: ['id'],
      ),
    ];
  }

  @override
  Future<List<IndexDefinition>> getIndexDefinitions({
    required String schemaName,
    required String tableName,
  }) async {
    await probe.query((schemaName, tableName), 'indexes');
    return [
      IndexDefinition(
        indexName: '${schemaName}_${tableName}_pk',
        elements: [],
        type: 'btree',
        isUnique: true,
        isPrimary: true,
      ),
    ];
  }
}

class _CatalogDatabase implements Database {
  _CatalogDatabase(this.tables);
  final List<_Table> tables;

  @override
  Future<DatabaseResult> unsafeQuery(
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
    QueryParameters? parameters,
  }) async => _Rows(tables);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Rows extends DatabaseResult {
  _Rows(List<_Table> tables)
    : super([
        for (final t in tables) _Row([t.$1, t.$2]),
      ]);
  @override
  int get affectedRowCount => 0;
  @override
  DatabaseResultSchema get schema => throw UnimplementedError();
}

class _Row extends DatabaseResultRow {
  _Row(super.values);
  @override
  Map<String, dynamic> toColumnMap() => throw UnimplementedError();
}
