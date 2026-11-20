// Run with the workspace's resolved sqlite3 native assets. No recorded output
// or system SQLite installation is used as the oracle.
import 'dart:convert';
import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

void require(bool condition, String message) {
  if (!condition) throw StateError(message);
}

void equal(Object? actual, Object? expected) {
  require(jsonEncode(actual) == jsonEncode(expected), '$actual != $expected');
}

List<List<Object?>> rows(
  Database db,
  String sql, [
  List<Object?> args = const [],
]) => db.select(sql, args).rows;

void rejected(Database db, String sql, String message) {
  try {
    db.select(sql);
  } on SqliteException catch (error) {
    require(error.message.contains(message), '$sql: ${error.message}');
    return;
  }
  throw StateError('Expected rejection: $sql');
}

int runDialectChecks() {
  var passed = 0;

  void probe(String name, void Function(Database) action) {
    final db = sqlite3.openInMemory();
    try {
      db.execute('PRAGMA foreign_keys=ON');
      action(db);
      passed++;
      stderr.writeln('PASS $name');
    } finally {
      db.close();
    }
  }

  probe('Inline DEFAULT and writable CTEs are rejected', (db) {
    db.execute("CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT DEFAULT 'db')");
    rejected(db, 'INSERT INTO t(v) VALUES(DEFAULT) RETURNING *', 'DEFAULT');
    rejected(db, 'UPDATE t SET v=DEFAULT RETURNING *', 'DEFAULT');
    rejected(
      db,
      'WITH x AS (INSERT INTO t DEFAULT VALUES RETURNING *) SELECT * FROM x',
      'INSERT',
    );
    rejected(
      db,
      'INSERT INTO t DEFAULT VALUES ON CONFLICT DO NOTHING RETURNING *',
      'ON',
    );
    rejected(db, 'INSERT INTO t(v) VALUES(default(v)) RETURNING *', 'default');
  });

  probe('Omitted columns evaluate defaults independently per row', (db) {
    db.execute(
      "CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT DEFAULT 'db', token BLOB DEFAULT(randomblob(16)))",
    );
    final result = rows(
      db,
      'INSERT INTO t(id) VALUES(NULL),(50),(NULL) RETURNING id,v,length(token),hex(token)',
    );
    equal(result.map((r) => r.take(3).toList()).toList(), [
      [1, 'db', 16],
      [50, 'db', 16],
      [51, 'db', 16],
    ]);
    require(
      result.map((r) => r[3]).toSet().length == 3,
      'Distinct random defaults',
    );
  });

  probe('Schema expressions preserve volatile defaults and explicit NULL', (
    db,
  ) {
    var calls = 0;
    db.createFunction(
      functionName: 'next_value',
      argumentCount: const AllowedArgumentCount(0),
      function: (_) => ++calls,
    );
    db.execute(
      'CREATE TABLE t(id INTEGER PRIMARY KEY, v INTEGER DEFAULT(next_value()))',
    );
    final expression = rows(
      db,
      "SELECT dflt_value FROM pragma_table_xinfo('t') WHERE name='v'",
    ).single.single;
    equal(
      rows(
        db,
        'INSERT INTO t(v) VALUES(($expression)),(?),(NULL),(($expression)) RETURNING *',
        [99],
      ),
      [
        [1, 1],
        [2, 99],
        [3, null],
        [4, 2],
      ],
    );
    equal(
      rows(
        db,
        'INSERT INTO t(v) VALUES(CASE WHEN ? THEN ($expression) ELSE ? END),(CASE WHEN ? THEN ($expression) ELSE ? END) RETURNING v',
        [0, 77, 1, null],
      ),
      [
        [77],
        [3],
      ],
    );
    equal(calls, 3);
  });

  probe('Selecting dflt_value inserts SQL text instead of evaluating it', (db) {
    db.execute("CREATE TABLE t(v TEXT DEFAULT 'actual')");
    equal(
      rows(
        db,
        "INSERT INTO t(v) SELECT dflt_value FROM pragma_table_xinfo('t') WHERE name='v' RETURNING v",
      ),
      [
        ["'actual'"],
      ],
    );
  });

  probe('An uncorrelated subquery collapses per-row evaluation', (db) {
    var calls = 0;
    db.createFunction(
      functionName: 'next_value',
      argumentCount: const AllowedArgumentCount(0),
      function: (_) => ++calls,
    );
    db.execute('CREATE TABLE t(v INTEGER)');
    equal(
      rows(
        db,
        'WITH input(x) AS (VALUES(1),(2),(3)) INSERT INTO t SELECT next_value() FROM input RETURNING v',
      ),
      [
        [1],
        [2],
        [3],
      ],
    );
    equal(
      rows(
        db,
        'WITH input(x) AS (VALUES(1),(2),(3)) INSERT INTO t SELECT (SELECT next_value()) FROM input RETURNING v',
      ),
      [
        [4],
        [4],
        [4],
      ],
    );
  });

  probe('NULL and REPLACE preserve NULL on nullable defaulted columns', (db) {
    db.execute(
      "CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT DEFAULT 'db', required TEXT NOT NULL DEFAULT 'required')",
    );
    equal(rows(db, 'INSERT INTO t(v) VALUES(NULL) RETURNING v,required'), [
      [null, 'required'],
    ]);
    equal(
      rows(
        db,
        'INSERT OR REPLACE INTO t(v,required) VALUES(NULL,NULL) RETURNING v,required',
      ),
      [
        [null, 'required'],
      ],
    );
  });

  probe('excluded exposes defaults for omitted upsert columns', (db) {
    db.execute(
      "CREATE TABLE t(id INTEGER PRIMARY KEY, k TEXT UNIQUE, v TEXT DEFAULT 'db'); INSERT INTO t(k,v) VALUES('a','old')",
    );
    equal(
      rows(
        db,
        "INSERT INTO t(k) VALUES('a'),('b') ON CONFLICT(k) DO UPDATE SET v=excluded.v RETURNING id,k,v",
      ),
      [
        [1, 'a', 'db'],
        [2, 'b', 'db'],
      ],
    );
  });

  probe('Repeated upsert targets return each change while predicates skip rows', (
    db,
  ) {
    db.execute(
      "CREATE TABLE t(id INTEGER PRIMARY KEY, k TEXT UNIQUE, v INTEGER); INSERT INTO t(k,v) VALUES('a',0)",
    );
    equal(
      rows(
        db,
        "INSERT INTO t(k,v) VALUES('a',1),('a',2),('b',3) ON CONFLICT(k) DO UPDATE SET v=excluded.v RETURNING id,k,v",
      ),
      [
        [1, 'a', 1],
        [1, 'a', 2],
        [2, 'b', 3],
      ],
    );
    equal(
      rows(
        db,
        "INSERT INTO t(k,v) VALUES('a',4),('a',5) ON CONFLICT(k) DO UPDATE SET v=excluded.v WHERE excluded.v<5 RETURNING id,k,v",
      ),
      [
        [1, 'a', 4],
      ],
    );
  });

  probe('UPDATE FROM cannot return a source ordinal', (db) {
    db.execute(
      "CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT); INSERT INTO t VALUES(1,'old'),(2,'old'),(3,'old')",
    );
    final result = rows(
      db,
      "WITH input(ord,id,v) AS (VALUES(0,3,'c'),(1,1,'a'),(2,2,NULL)) UPDATE t SET v=input.v FROM input WHERE t.id=input.id RETURNING id,v",
    );
    result.sort((a, b) => (a[0] as int).compareTo(b[0] as int));
    equal(result, [
      [1, 'a'],
      [2, null],
      [3, 'c'],
    ]);
    // RETURNING order is unspecified, so never assert a particular permutation.
    rejected(
      db,
      "WITH input(ord,id,v) AS (VALUES(0,1,'a')) UPDATE t SET v=input.v FROM input WHERE t.id=input.id RETURNING input.ord,t.id",
      'input.ord',
    );
  });

  probe('UPDATE FROM collapses repeated updates to the same target', (db) {
    db.execute(
      "CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT); INSERT INTO t VALUES(1,'old')",
    );
    equal(
      [
        ...rows(db, "UPDATE t SET v='first' WHERE id=1 RETURNING *"),
        ...rows(db, "UPDATE t SET v='second' WHERE id=1 RETURNING *"),
      ],
      [
        [1, 'first'],
        [1, 'second'],
      ],
    );
    require(
      rows(
            db,
            "WITH input(id,v) AS (VALUES(1,'first'),(1,'second')) UPDATE t SET v=input.v FROM input WHERE t.id=input.id RETURNING *",
          ).length ==
          1,
      'Only one update',
    );
  });

  probe('Combined updates can change uniqueness-sensitive write order', (db) {
    db.execute(
      "CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT UNIQUE); INSERT INTO t VALUES(1,'a'),(2,'b')",
    );
    db.execute("UPDATE t SET v='c' WHERE id=2; UPDATE t SET v='b' WHERE id=1");
    equal(rows(db, 'SELECT * FROM t ORDER BY id'), [
      [1, 'b'],
      [2, 'c'],
    ]);
    db.execute("DELETE FROM t; INSERT INTO t VALUES(1,'a'),(2,'b')");
    rejected(
      db,
      "WITH input(id,v) AS (VALUES(2,'c'),(1,'b')) UPDATE t SET v=input.v FROM input WHERE t.id=input.id RETURNING *",
      'UNIQUE constraint',
    );
  });

  probe('INSERT RETURNING cannot reference a source ordinal directly', (db) {
    db.execute('CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT)');
    rejected(
      db,
      "WITH input(ord,v) AS (VALUES(0,'same'),(1,'same')) INSERT INTO t(v) SELECT v FROM input RETURNING id,input.ord",
      'input.ord',
    );
    equal(
      rows(db, 'INSERT INTO t(v) VALUES(?) RETURNING ?,id,v', ['same', 7]),
      [
        [7, 1, 'same'],
      ],
    );
  });

  probe('RETURNING preserves values from before AFTER triggers', (db) {
    db.execute(
      "CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT); CREATE TRIGGER after_insert AFTER INSERT ON t BEGIN UPDATE t SET v='after' WHERE id=NEW.id; END",
    );
    equal(rows(db, "INSERT INTO t(v) VALUES('before') RETURNING *"), [
      [1, 'before'],
    ]);
    equal(rows(db, 'SELECT * FROM t'), [
      [1, 'after'],
    ]);
  });

  probe('Skipped conflicts leave holes in generated IDs', (db) {
    db.execute(
      'CREATE TABLE t(id INTEGER PRIMARY KEY AUTOINCREMENT, k TEXT UNIQUE)',
    );
    equal(
      rows(
        db,
        "INSERT INTO t(k) VALUES('a'),('a'),('b') ON CONFLICT DO NOTHING RETURNING *",
      ),
      [
        [1, 'a'],
        [3, 'b'],
      ],
    );
  });

  probe('Regrouping SQL shapes changes the winning input', (db) {
    db.execute(
      "CREATE TABLE t(id INTEGER PRIMARY KEY, k TEXT UNIQUE, v TEXT DEFAULT 'db')",
    );
    const omitted =
        'INSERT INTO t(k) VALUES(?) ON CONFLICT DO NOTHING RETURNING *';
    const supplied =
        'INSERT INTO t(k,v) VALUES(?,?) ON CONFLICT DO NOTHING RETURNING *';
    equal(
      [
        ...rows(db, omitted, ['a']),
        ...rows(db, supplied, ['b', 'explicit']),
        ...rows(db, omitted, ['b']),
      ],
      [
        [1, 'a', 'db'],
        [2, 'b', 'explicit'],
      ],
    );
    db.execute('DELETE FROM t');
    equal(
      [
        ...rows(db, omitted, ['a']),
        ...rows(db, omitted, ['b']),
        ...rows(db, supplied, ['b', 'explicit']),
      ],
      [
        [1, 'a', 'db'],
        [2, 'b', 'db'],
      ],
    );
  });

  probe('Multi-row inserts change immediate foreign-key boundaries', (db) {
    db.execute(
      'CREATE TABLE t(id INTEGER PRIMARY KEY, parent INTEGER REFERENCES t(id))',
    );
    rejected(
      db,
      'INSERT INTO t VALUES(2,1) RETURNING *',
      'FOREIGN KEY constraint',
    );
    equal(rows(db, 'INSERT INTO t VALUES(2,1),(1,NULL) RETURNING *'), [
      [2, 1],
      [1, null],
    ]);
  });

  probe('Ordered statements retain skipped slots and savepoint rollback', (db) {
    db.execute(
      "CREATE TABLE t(id INTEGER PRIMARY KEY, k TEXT UNIQUE, v TEXT DEFAULT 'db'); BEGIN; INSERT INTO t(k) VALUES('outer'); SAVEPOINT batch",
    );
    equal(
      [
        rows(db, 'INSERT INTO t(k) VALUES(?) RETURNING *', ['a']),
        rows(
          db,
          'INSERT INTO t(k,v) VALUES(?,?) ON CONFLICT DO NOTHING RETURNING *',
          ['a', 'skip'],
        ),
        rows(db, 'INSERT INTO t(k,v) VALUES(?,?) RETURNING *', ['b', null]),
      ],
      [
        [
          [2, 'a', 'db'],
        ],
        [],
        [
          [3, 'b', null],
        ],
      ],
    );
    rejected(
      db,
      "INSERT INTO t(k) VALUES('b') RETURNING *",
      'UNIQUE constraint',
    );
    db.execute('ROLLBACK TO batch; RELEASE batch; COMMIT');
    equal(rows(db, 'SELECT * FROM t'), [
      [1, 'outer', 'db'],
    ]);
  });

  probe('UPDATE FROM expressions distinguish default from NULL', (db) {
    db.execute(
      "CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT DEFAULT 'db'); INSERT INTO t VALUES(1,'old'),(2,'old')",
    );
    final expression = rows(
      db,
      "SELECT dflt_value FROM pragma_table_xinfo('t') WHERE name='v'",
    ).single.single;
    rows(
      db,
      'WITH input(id,use_default,v) AS (VALUES(1,1,NULL),(2,0,NULL)) UPDATE t SET v=CASE WHEN input.use_default THEN ($expression) ELSE input.v END FROM input WHERE t.id=input.id RETURNING *',
    );
    equal(rows(db, 'SELECT * FROM t ORDER BY id'), [
      [1, 'db'],
      [2, null],
    ]);
  });

  probe('BLOB IDs generate defaults on omission but reject explicit NULL', (
    db,
  ) {
    db.execute(
      'CREATE TABLE t(id BLOB PRIMARY KEY NOT NULL DEFAULT(randomblob(16)), v TEXT)',
    );
    final result = rows(
      db,
      "INSERT INTO t(v) VALUES('a'),('b') RETURNING length(id),hex(id),v",
    );
    equal(result.map((r) => r[0]).toList(), [16, 16]);
    require(result[0][1] != result[1][1], 'Distinct BLOB defaults');
    rejected(
      db,
      "INSERT INTO t(id,v) VALUES(NULL,'c') RETURNING *",
      'NOT NULL constraint',
    );
  });

  probe('Triggers cannot collect RETURNING', (db) {
    db.execute(
      'CREATE TABLE t(id INTEGER PRIMARY KEY); CREATE VIEW input AS SELECT id FROM t',
    );
    rejected(
      db,
      'CREATE TRIGGER input_insert INSTEAD OF INSERT ON input BEGIN INSERT INTO t VALUES(NEW.id) RETURNING *; END',
      'RETURNING',
    );
  });

  probe('Known unique keys permit correlation through materialized input', (
    db,
  ) {
    db.execute(
      "CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT); INSERT INTO t VALUES(1,'old'),(2,'old'),(3,'old')",
    );
    final updated = rows(
      db,
      "WITH input(ord,id,v) AS MATERIALIZED (VALUES(0,3,'c'),(1,1,'a'),(2,2,'b')) UPDATE t SET v=input.v FROM input WHERE t.id=input.id RETURNING (SELECT ord FROM input WHERE input.id=t.id),id,v",
    );
    updated.sort((a, b) => (a[0] as int).compareTo(b[0] as int));
    equal(updated, [
      [0, 3, 'c'],
      [1, 1, 'a'],
      [2, 2, 'b'],
    ]);
    final inserted = rows(
      db,
      "WITH input(ord,id,v) AS MATERIALIZED (VALUES(0,9,'z'),(1,8,'y')) INSERT INTO t(id,v) SELECT id,v FROM input RETURNING (SELECT ord FROM input WHERE input.id=t.id),id,v",
    );
    inserted.sort((a, b) => (a[0] as int).compareTo(b[0] as int));
    equal(inserted, [
      [0, 9, 'z'],
      [1, 8, 'y'],
    ]);
  });

  probe('Staged defaults do not solve destination-generated ID correlation', (
    db,
  ) {
    db.execute(
      "CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT DEFAULT 'db'); INSERT INTO t VALUES(1,'existing'); CREATE TEMP TABLE stage(ord INTEGER, id INTEGER PRIMARY KEY, v TEXT DEFAULT 'db')",
    );
    equal(rows(db, 'INSERT INTO stage(ord) VALUES(0),(1) RETURNING *'), [
      [0, 1, 'db'],
      [1, 2, 'db'],
    ]);
    rejected(
      db,
      'INSERT INTO t(id,v) SELECT id,v FROM stage RETURNING *',
      'UNIQUE constraint',
    );
    equal(
      rows(db, 'INSERT INTO t(v) SELECT v FROM stage ORDER BY ord RETURNING *'),
      [
        [2, 'db'],
        [3, 'db'],
      ],
    );
  });

  probe('OR IGNORE suppresses CHECK errors that DO NOTHING preserves', (db) {
    db.execute(
      "CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT NOT NULL DEFAULT 'db', n INTEGER CHECK(n>0))",
    );
    rejected(
      db,
      'INSERT INTO t(n) VALUES(-1) ON CONFLICT DO NOTHING RETURNING *',
      'CHECK constraint',
    );
    equal(rows(db, 'INSERT OR IGNORE INTO t(n) VALUES(-1) RETURNING *'), []);
  });

  return passed;
}

void main() {
  final db = sqlite3.openInMemory();
  try {
    stdout.writeln(
      'SQLite ${db.select('SELECT sqlite_version()').single.values.single}',
    );
  } finally {
    db.close();
  }
  stdout.writeln('${runDialectChecks()} dialect checks passed.');
}
