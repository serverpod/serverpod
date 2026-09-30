// Research harness: real sqlite3/sqlite_async execution, not an ORM change.
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:sqlite3/common.dart' show CommonPreparedStatement;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite_async/sqlite_async.dart';

import 'dialect_probe.dart' show runDialectChecks;

void require(bool condition, String description) {
  if (!condition) throw StateError(description);
}

typedef BoundStatement = ({String sql, List<Object?> parameters});

// Capture only sendable arguments; never a session, transaction, or ORM model.
Future<List<List<List<Object?>>>> executeOrdered(
  SqliteWriteContext tx,
  List<BoundStatement> statements,
) {
  return tx.computeWithDatabase((db) async {
    final prepared = <String, CommonPreparedStatement>{};
    final results = <List<List<Object?>>>[];

    try {
      for (final statement in statements) {
        final query = prepared.putIfAbsent(
          statement.sql,
          () => db.prepare(statement.sql, checkNoTail: true),
        );
        results.add(query.select(statement.parameters).rows);
      }
      return results;
    } finally {
      for (final query in prepared.values) {
        query.close();
      }
    }
  });
}

Future<Map<String, Object?>> verifyOrdered(SqliteDatabase db) async {
  await db.execute('''
CREATE TABLE proof(
  id INTEGER PRIMARY KEY,
  k TEXT UNIQUE,
  v TEXT DEFAULT 'db',
  payload BLOB
)''');
  await db.execute('''
CREATE TRIGGER proof_after AFTER INSERT ON proof BEGIN
  UPDATE proof SET v='after' WHERE id=NEW.id;
END''');

  final parameterSets = <BoundStatement>[
    (
      sql:
          'INSERT INTO proof(k,payload) VALUES(?,?) RETURNING id,k,v,hex(payload)',
      parameters: [
        'a',
        Uint8List.fromList([0, 255]),
      ],
    ),
    (
      sql:
          'INSERT INTO proof(k,v) VALUES(?,?) '
          'ON CONFLICT DO NOTHING RETURNING id,k,v,hex(payload)',
      parameters: ['a', 'skip'],
    ),
    (
      sql: 'INSERT INTO proof(k,v) VALUES(?,?) RETURNING id,k,v,hex(payload)',
      parameters: ['b', null],
    ),
    (
      sql: 'UPDATE proof SET v=? WHERE id=? RETURNING id,k,v,hex(payload)',
      parameters: ['first', 2],
    ),
    (
      sql: 'UPDATE proof SET v=? WHERE id=? RETURNING id,k,v,hex(payload)',
      parameters: ['second', 2],
    ),
    (
      sql: 'UPDATE proof SET v=? WHERE id=? RETURNING id,k,v,hex(payload)',
      parameters: ['missing', 99],
    ),
  ];

  final results = await db.writeTransaction(
    (tx) => executeOrdered(tx, parameterSets),
  );
  final expected = [
    [
      [1, 'a', 'db', '00FF'],
    ],
    [],
    [
      [2, 'b', null, ''],
    ],
    [
      [2, 'b', 'first', ''],
    ],
    [
      [2, 'b', 'second', ''],
    ],
    [],
  ];
  require(jsonEncode(results) == jsonEncode(expected), 'Per-input snapshots');

  await db.writeTransaction((tx) async {
    await tx.execute("INSERT INTO proof(k) VALUES('outer')");
    await tx.execute('SAVEPOINT proof_batch');
    var rejected = false;

    try {
      await executeOrdered(tx, [
        (sql: 'INSERT INTO proof(k) VALUES(?) RETURNING id', parameters: ['c']),
        (sql: 'INSERT INTO proof(k) VALUES(?) RETURNING id', parameters: ['a']),
      ]);
    } on SqliteException {
      rejected = true;
      await tx.execute('ROLLBACK TO proof_batch');
    } finally {
      await tx.execute('RELEASE proof_batch');
    }

    require(rejected, 'Constraint error crosses worker boundary');
    final kept = await tx.getAll('SELECT k FROM proof ORDER BY id');
    require(
      jsonEncode(kept.rows) ==
          jsonEncode([
            ['a'],
            ['b'],
            ['outer'],
          ]),
      'Savepoint preserves caller write and undoes partial batch',
    );
  });

  final upsert = await db.writeTransaction((tx) async {
    return executeOrdered(tx, [
      (
        sql:
            'INSERT INTO proof(k,v) VALUES(?,?) '
            'ON CONFLICT(k) DO UPDATE SET v=excluded.v RETURNING id,v',
        parameters: ['a', 'first'],
      ),
      (
        sql:
            'INSERT INTO proof(k,v) VALUES(?,?) '
            'ON CONFLICT(k) DO UPDATE SET v=excluded.v RETURNING id,v',
        parameters: ['a', 'second'],
      ),
    ]);
  });
  require(
    jsonEncode(upsert) ==
        jsonEncode([
          [
            [1, 'first'],
          ],
          [
            [1, 'second'],
          ],
        ]),
    'Repeated upsert target remains visible for adapter rejection',
  );

  await db.execute(
    'CREATE TABLE typed(id INTEGER PRIMARY KEY, payload BLOB, data BLOB)',
  );
  final typed = await db.writeTransaction(
    (tx) => executeOrdered(tx, [
      (
        sql:
            'INSERT INTO typed VALUES(?,?,jsonb(?)) '
            'RETURNING id,payload,json(data)',
        parameters: [
          9007199254740993,
          Uint8List.fromList([0, 255]),
          '{"quoted":"a\'b"}',
        ],
      ),
    ]),
  );
  require(typed.single.single[0] == 9007199254740993, 'Exact native integer');
  require(
    jsonEncode((typed.single.single[1] as Uint8List).toList()) == '[0,255]',
    'BLOB return crosses worker boundary',
  );
  require(typed.single.single[2] == '{"quoted":"a\'b"}', 'JSONB round trip');

  return {
    'per_input_results': results,
    'savepoint_rollback': 'passed',
    'repeated_upsert_target': upsert,
    'native_int64_blob_jsonb': 'passed',
  };
}

Future<Map<String, Object?>> measure(SqliteDatabase db) async {
  const count = 1000;
  const chunkSize = 256;
  const warmups = 3;
  const samples = 7;
  final output = <String, Object?>{};

  for (final operation in ['insert', 'mixed_insert', 'update', 'upsert']) {
    final baseSql = switch (operation) {
      'insert' ||
      'mixed_insert' => 'INSERT INTO bench(k,v) VALUES(?,?) RETURNING id,k,v',
      'update' => 'UPDATE bench SET v=? WHERE id=? RETURNING id,k,v',
      _ =>
        'INSERT INTO bench(k,v) VALUES(?,?) '
            'ON CONFLICT(k) DO UPDATE SET v=excluded.v RETURNING id,k,v',
    };
    final statements = List<BoundStatement>.generate(count, (i) {
      if (operation == 'mixed_insert' && i.isEven) {
        return (
          sql: 'INSERT INTO bench(k) VALUES(?) RETURNING id,k,v',
          parameters: ['k$i'],
        );
      }

      return (
        sql: baseSql,
        parameters: operation == 'update' ? ['v$i', i + 1] : ['k$i', 'v$i'],
      );
    });
    final timings = <String, List<double>>{
      'await_each': [],
      'ordered_worker_chunks': [],
      'set_based_chunks': [],
    };

    for (var iteration = 0; iteration < warmups + samples; iteration++) {
      final methods = timings.keys.toList();
      // Rotate method order to reduce warmup / host drift bias.
      final rotated = [
        ...methods.skip(iteration % methods.length),
        ...methods.take(iteration % methods.length),
      ];

      for (final method in rotated) {
        await db.execute('DROP TABLE IF EXISTS bench');
        await db.execute(
          'CREATE TABLE bench('
          'id INTEGER PRIMARY KEY, k TEXT UNIQUE, v TEXT DEFAULT \'db\')',
        );

        if (operation == 'update' || operation == 'upsert') {
          await db.writeTransaction(
            (tx) => tx.executeBatch(
              'INSERT INTO bench(k,v) VALUES(?,?)',
              List.generate(count, (i) => ['k$i', 'old']),
            ),
          );
        }

        final watch = Stopwatch()..start();
        final returned = await db.writeTransaction((tx) async {
          final result = <List<Object?>>[];

          if (method == 'await_each') {
            for (final statement in statements) {
              result.addAll(
                (await tx.execute(
                  statement.sql,
                  statement.parameters,
                )).rows,
              );
            }
          } else {
            for (var start = 0; start < count; start += chunkSize) {
              final end = min(start + chunkSize, count);

              if (method == 'ordered_worker_chunks') {
                final batch = await executeOrdered(
                  tx,
                  statements.sublist(start, end),
                );
                result.addAll(batch.expand((rows) => rows));
              } else {
                final parameters = <Object?>[];
                final values = <String>[];

                for (var i = start; i < end; i++) {
                  if (operation == 'update') {
                    values.add('(?,?)');
                    parameters.addAll([i + 1, 'v$i']);
                  } else if (operation == 'mixed_insert' && i.isEven) {
                    values.add("(?,'db')");
                    parameters.add('k$i');
                  } else {
                    values.add('(?,?)');
                    parameters.addAll(['k$i', 'v$i']);
                  }
                }

                final sql = operation == 'update'
                    ? 'WITH input(id,v) AS (VALUES ${values.join(',')}) '
                          'UPDATE bench SET v=input.v FROM input '
                          'WHERE bench.id=input.id RETURNING id,k,v'
                    : 'INSERT INTO bench(k,v) VALUES ${values.join(',')} '
                          '${operation == 'upsert' ? 'ON CONFLICT(k) DO UPDATE SET v=excluded.v ' : ''}'
                          'RETURNING id,k,v';
                result.addAll((await tx.execute(sql, parameters)).rows);
              }
            }
          }

          return result;
        });
        watch.stop();

        require(returned.length == count, '$operation/$method return count');
        final byKey = {for (final row in returned) row[1]: row};
        require(byKey.length == count, '$operation/$method distinct keys');

        for (var i = 0; i < count; i++) {
          require(
            byKey['k$i']?[2] ==
                (operation == 'mixed_insert' && i.isEven ? 'db' : 'v$i'),
            '$operation/$method value at $i',
          );
        }

        if (iteration >= warmups) {
          timings[method]!.add(watch.elapsedMicroseconds / 1000);
        }
      }
    }

    output[operation] = {
      for (final entry in timings.entries)
        entry.key: {
          'samples_ms': entry.value,
          'median_ms': (entry.value.toList()..sort())[samples ~/ 2],
        },
    };
    stderr.writeln('Measured $operation');
  }

  return {
    'rows': count,
    'chunk_size': chunkSize,
    'warmups': warmups,
    'samples': samples,
    'workloads': output,
  };
}

Future<void> main(List<String> args) async {
  final directory = await Directory.systemTemp.createTemp('sqlite-returning-');
  final db = SqliteDatabase(
    path: '${directory.path}/probe.db',
    options: const SqliteOptions(preparedStatementCacheSize: 0),
  );

  try {
    final metadata = {
      'dart': Platform.version,
      'sqlite': (await db.get('SELECT sqlite_version() AS v'))['v'],
      'source_id': (await db.get('SELECT sqlite_source_id() AS v'))['v'],
      'journal_mode': (await db.get('PRAGMA journal_mode')).values.single,
      'synchronous': (await db.get('PRAGMA synchronous')).values.single,
      'compile_options': (await db.getAll(
        'PRAGMA compile_options',
      )).map((row) => row.values.single).toList(),
    };
    final dialect = runDialectChecks();
    await verifyOrdered(db);

    stdout.writeln('Dart ${metadata['dart']}');
    stdout.writeln(
      'SQLite ${metadata['sqlite']}; WAL=${metadata['journal_mode']}; synchronous=${metadata['synchronous']}',
    );
    stdout.writeln(
      '$dialect dialect checks and ordered driver behavior checks passed.\n',
    );
    if (args.contains('--verify-only')) return;

    final measurements = await measure(db);
    stdout.writeln('| Workload | Method | Median ms | Samples ms |');
    stdout.writeln('| --- | --- | ---: | --- |');
    final workloads = measurements['workloads'] as Map<String, Object?>;
    for (final workload in workloads.entries) {
      for (final method in (workload.value as Map<String, Object?>).entries) {
        final stats = method.value as Map<String, Object?>;
        stdout.writeln(
          '| ${workload.key} | ${method.key} | ${stats['median_ms']} | ${stats['samples_ms']} |',
        );
      }
    }
  } finally {
    await db.close();
    await directory.delete(recursive: true);
  }
}
