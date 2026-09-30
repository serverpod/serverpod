#!/usr/bin/env python3
"""Executable SQLite dialect experiments using Python's system SQLite.

Each probe uses an independent in-memory database. JSON includes executed SQL,
observations, SQLite version, and compile options; failed assertions exit nonzero.
This is a research harness, not a proposed ORM implementation.
"""

import json
import sqlite3


observations = []


class RecordedConnection:
    """Record bound calls and outcomes for replay through the Dart driver."""

    def __init__(self):
        self.connection = sqlite3.connect(":memory:", isolation_level=None)
        self.events = []

    def execute(self, sql, params=()):
        event = {"sql": sql, "parameters": params}
        self.events.append(event)

        try:
            result = self.connection.execute(sql, params).fetchall()
        except sqlite3.DatabaseError as error:
            event["error"] = str(error)
            raise

        event["rows"] = list(result)

        class CapturedCursor:
            def fetchall(self):
                return result

        return CapturedCursor()

    def create_function(self, name, argument_count, function):
        self.events.append({"function": name, "argument_count": argument_count})
        self.connection.create_function(name, argument_count, function)

    def close(self):
        self.connection.close()


def probe(name, action):
    db = RecordedConnection()
    db.execute("PRAGMA foreign_keys = ON")

    try:
        result = action(db)
        observations.append({"name": name, "events": db.events, "result": result})
    finally:
        db.close()


def rows(db, sql, params=()):
    return db.execute(sql, params).fetchall()


def rejected(db, sql, expected):
    try:
        rows(db, sql)
    except sqlite3.DatabaseError as error:
        assert expected in str(error), (sql, str(error))
        return {"rejected_sql": sql, "error": str(error)}

    raise AssertionError(f"Expected SQLite to reject: {sql}")


def grammar(db):
    db.execute("CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT DEFAULT 'db')")
    return [
        rejected(db, "INSERT INTO t(v) VALUES(DEFAULT) RETURNING *", "DEFAULT"),
        rejected(db, "UPDATE t SET v=DEFAULT RETURNING *", "DEFAULT"),
        rejected(db, "WITH x AS (INSERT INTO t DEFAULT VALUES RETURNING *) SELECT * FROM x", "INSERT"),
        rejected(db, "INSERT INTO t DEFAULT VALUES ON CONFLICT DO NOTHING RETURNING *", "ON"),
        rejected(db, "INSERT INTO t(v) VALUES(default(v)) RETURNING *", "default"),
    ]


def omitted_columns(db):
    db.execute("CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT DEFAULT 'db', token BLOB DEFAULT(randomblob(16)))")
    result = rows(db, "INSERT INTO t(id) VALUES(NULL),(50),(NULL) RETURNING id,v,length(token),hex(token)")
    assert [r[:3] for r in result] == [(1, "db", 16), (50, "db", 16), (51, "db", 16)]
    assert len({r[3] for r in result}) == 3
    return result


def expression_substitution(db):
    calls = []

    def next_value():
        calls.append(len(calls) + 1)
        return calls[-1]

    db.create_function("next_value", 0, next_value)
    db.execute("CREATE TABLE t(id INTEGER PRIMARY KEY, v INTEGER DEFAULT(next_value()))")
    default_sql = rows(db, "SELECT dflt_value FROM pragma_table_xinfo('t') WHERE name='v'")[0][0]
    result = rows(db, f"INSERT INTO t(v) VALUES(({default_sql})),(?),(NULL),(({default_sql})) RETURNING *", (99,))
    assert result == [(1, 1), (2, 99), (3, None), (4, 2)]
    assert calls == [1, 2]

    result_case = rows(db, f"INSERT INTO t(v) VALUES(CASE WHEN ? THEN ({default_sql}) ELSE ? END),(CASE WHEN ? THEN ({default_sql}) ELSE ? END) RETURNING v", (0, 77, 1, None))
    assert result_case == [(77,), (3,)]
    return {"schema_expression": default_sql, "values": result, "case_values": result_case, "calls": calls}


def default_text_is_not_executable_data(db):
    db.execute("CREATE TABLE t(v TEXT DEFAULT 'actual')")
    result = rows(db, "INSERT INTO t(v) SELECT dflt_value FROM pragma_table_xinfo('t') WHERE name='v' RETURNING v")
    assert result == [("'actual'",)]
    return result


def scalar_subquery_evaluation(db):
    calls = []

    def next_value():
        calls.append(len(calls) + 1)
        return calls[-1]

    db.create_function("next_value", 0, next_value)
    db.execute("CREATE TABLE t(v INTEGER)")
    direct = rows(db, "WITH input(x) AS (VALUES(1),(2),(3)) INSERT INTO t SELECT next_value() FROM input RETURNING v")
    assert direct == [(1,), (2,), (3,)]
    scalar = rows(db, "WITH input(x) AS (VALUES(1),(2),(3)) INSERT INTO t SELECT (SELECT next_value()) FROM input RETURNING v")
    assert scalar == [(4,), (4,), (4,)]
    return {"direct_expression": direct, "uncorrelated_subquery": scalar}


def null_and_replace(db):
    db.execute("CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT DEFAULT 'db', required TEXT NOT NULL DEFAULT 'required')")
    explicit = rows(db, "INSERT INTO t(v) VALUES(NULL) RETURNING v,required")
    replaced = rows(db, "INSERT OR REPLACE INTO t(v,required) VALUES(NULL,NULL) RETURNING v,required")
    assert explicit == replaced == [(None, "required")]
    return {"explicit_null": explicit, "replace_cannot_default_nullable_column": replaced}


def upsert_defaults(db):
    db.execute("CREATE TABLE t(id INTEGER PRIMARY KEY, k TEXT UNIQUE, v TEXT DEFAULT 'db')")
    db.execute("INSERT INTO t(k,v) VALUES('a','old')")
    result = rows(db, "INSERT INTO t(k) VALUES('a'),('b') ON CONFLICT(k) DO UPDATE SET v=excluded.v RETURNING id,k,v")
    assert result == [(1, "a", "db"), (2, "b", "db")]
    return result


def upsert_duplicate_and_skip(db):
    db.execute("CREATE TABLE t(id INTEGER PRIMARY KEY, k TEXT UNIQUE, v INTEGER)")
    db.execute("INSERT INTO t(k,v) VALUES('a',0)")
    result = rows(db, "INSERT INTO t(k,v) VALUES('a',1),('a',2),('b',3) ON CONFLICT(k) DO UPDATE SET v=excluded.v RETURNING id,k,v")
    assert result == [(1, "a", 1), (1, "a", 2), (2, "b", 3)]
    skipped = rows(db, "INSERT INTO t(k,v) VALUES('a',4),('a',5) ON CONFLICT(k) DO UPDATE SET v=excluded.v WHERE excluded.v<5 RETURNING id,k,v")
    assert skipped == [(1, "a", 4)]
    return {"duplicate_target_is_allowed_by_sqlite": result, "only_actual_changes_return": skipped}


def update_from(db):
    db.execute("CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT)")
    db.execute("INSERT INTO t VALUES(1,'old'),(2,'old'),(3,'old')")
    result = rows(db, "WITH input(ord,id,v) AS (VALUES(0,3,'c'),(1,1,'a'),(2,2,NULL)) UPDATE t SET v=input.v FROM input WHERE t.id=input.id RETURNING id,v")
    assert sorted(result) == [(1, "a"), (2, None), (3, "c")]
    assert [r[0] for r in result] != [3, 1, 2]
    error = rejected(db, "WITH input(ord,id,v) AS (VALUES(0,1,'a')) UPDATE t SET v=input.v FROM input WHERE t.id=input.id RETURNING input.ord,t.id", "input.ord")
    return {"input_ids": [3, 1, 2], "returned": result, "source_ordinal": error}


def duplicate_updates(db):
    db.execute("CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT)")
    db.execute("INSERT INTO t VALUES(1,'old')")
    sequential = rows(db, "UPDATE t SET v='first' WHERE id=1 RETURNING *")
    sequential += rows(db, "UPDATE t SET v='second' WHERE id=1 RETURNING *")
    batched = rows(db, "WITH input(id,v) AS (VALUES(1,'first'),(1,'second')) UPDATE t SET v=input.v FROM input WHERE t.id=input.id RETURNING *")
    assert sequential == [(1, "first"), (1, "second")]
    assert len(batched) == 1
    return {"sequential": sequential, "update_from": batched}


def update_order_constraints(db):
    db.execute("CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT UNIQUE)")
    db.execute("INSERT INTO t VALUES(1,'a'),(2,'b')")
    rows(db, "UPDATE t SET v='c' WHERE id=2 RETURNING *")
    rows(db, "UPDATE t SET v='b' WHERE id=1 RETURNING *")
    sequential = rows(db, "SELECT * FROM t ORDER BY id")
    db.execute("DELETE FROM t")
    db.execute("INSERT INTO t VALUES(1,'a'),(2,'b')")
    error = rejected(db, "WITH input(id,v) AS (VALUES(2,'c'),(1,'b')) UPDATE t SET v=input.v FROM input WHERE t.id=input.id RETURNING *", "UNIQUE constraint")
    return {"sequential_success": sequential, "update_from_failure": error}


def source_ordinal(db):
    db.execute("CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT)")
    error = rejected(db, "WITH input(ord,v) AS (VALUES(0,'same'),(1,'same')) INSERT INTO t(v) SELECT v FROM input RETURNING id,input.ord", "input.ord")
    single = rows(db, "INSERT INTO t(v) VALUES(?) RETURNING ?,id,v", ("same", 7))
    assert single == [(7, 1, "same")]
    return {"multi_row_source_ordinal": error, "single_row_bound_ordinal": single}


def trigger_images(db):
    db.execute("CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT)")
    db.execute("CREATE TRIGGER after_insert AFTER INSERT ON t BEGIN UPDATE t SET v='after' WHERE id=NEW.id; END")
    returned = rows(db, "INSERT INTO t(v) VALUES('before') RETURNING *")
    selected = rows(db, "SELECT * FROM t")
    assert returned == [(1, "before")]
    assert selected == [(1, "after")]
    return {"returning": returned, "later_select": selected}


def ignored_rows_and_generated_ids(db):
    db.execute("CREATE TABLE t(id INTEGER PRIMARY KEY AUTOINCREMENT, k TEXT UNIQUE)")
    result = rows(db, "INSERT INTO t(k) VALUES('a'),('a'),('b') ON CONFLICT DO NOTHING RETURNING *")
    assert result == [(1, "a"), (3, "b")]
    return {"returned": result, "last_insert_rowid": rows(db, "SELECT last_insert_rowid()")}


def regrouping_shapes(db):
    db.execute("CREATE TABLE t(id INTEGER PRIMARY KEY, k TEXT UNIQUE, v TEXT DEFAULT 'db')")
    sql_default = "INSERT INTO t(k) VALUES(?) ON CONFLICT DO NOTHING RETURNING *"
    sql_explicit = "INSERT INTO t(k,v) VALUES(?,?) ON CONFLICT DO NOTHING RETURNING *"
    ordered = rows(db, sql_default, ("a",))
    ordered += rows(db, sql_explicit, ("b", "explicit"))
    ordered += rows(db, sql_default, ("b",))
    db.execute("DELETE FROM t")
    regrouped = rows(db, sql_default, ("a",))
    regrouped += rows(db, sql_default, ("b",))
    regrouped += rows(db, sql_explicit, ("b", "explicit"))
    assert ordered == [(1, "a", "db"), (2, "b", "explicit")]
    assert regrouped == [(1, "a", "db"), (2, "b", "db")]
    return {"original_order": ordered, "regrouped_by_shape": regrouped}


def immediate_foreign_key_boundary(db):
    db.execute("CREATE TABLE t(id INTEGER PRIMARY KEY, parent INTEGER REFERENCES t(id))")
    error = rejected(db, "INSERT INTO t VALUES(2,1) RETURNING *", "FOREIGN KEY constraint")
    together = rows(db, "INSERT INTO t VALUES(2,1),(1,NULL) RETURNING *")
    assert together == [(2, 1), (1, None)]
    return {"individual_statement": error, "multi_row_statement": together}


def ordered_batch_and_savepoint(db):
    db.execute("CREATE TABLE t(id INTEGER PRIMARY KEY, k TEXT UNIQUE, v TEXT DEFAULT 'db')")
    db.execute("BEGIN")
    db.execute("INSERT INTO t(k) VALUES('outer')")
    db.execute("SAVEPOINT batch")
    result_sets = []

    try:
        result_sets.append(rows(db, "INSERT INTO t(k) VALUES(?) RETURNING *", ("a",)))
        result_sets.append(rows(db, "INSERT INTO t(k,v) VALUES(?,?) ON CONFLICT DO NOTHING RETURNING *", ("a", "skip")))
        result_sets.append(rows(db, "INSERT INTO t(k,v) VALUES(?,?) RETURNING *", ("b", None)))
        result_sets.append(rows(db, "INSERT INTO t(k) VALUES(?) RETURNING *", ("b",)))
        raise AssertionError("Expected duplicate key failure")
    except sqlite3.IntegrityError:
        db.execute("ROLLBACK TO batch")
        db.execute("RELEASE batch")

    remaining = rows(db, "SELECT * FROM t")
    db.execute("COMMIT")
    assert result_sets == [[(2, "a", "db")], [], [(3, "b", None)]]
    assert remaining == [(1, "outer", "db")]
    return {"per_input_results_before_failure": result_sets, "after_rollback": remaining}


def expression_defaults_on_update(db):
    db.execute("CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT DEFAULT 'db')")
    db.execute("INSERT INTO t VALUES(1,'old'),(2,'old')")
    default_sql = rows(db, "SELECT dflt_value FROM pragma_table_xinfo('t') WHERE name='v'")[0][0]
    result = rows(db, f"WITH input(id,use_default,v) AS (VALUES(1,1,NULL),(2,0,NULL)) UPDATE t SET v=CASE WHEN input.use_default THEN ({default_sql}) ELSE input.v END FROM input WHERE t.id=input.id RETURNING *")
    assert sorted(result) == [(1, "db"), (2, None)]
    return result


def uuid_primary_key(db):
    db.execute("CREATE TABLE t(id BLOB PRIMARY KEY NOT NULL DEFAULT(randomblob(16)), v TEXT)")
    result = rows(db, "INSERT INTO t(v) VALUES('a'),('b') RETURNING length(id),hex(id),v")
    assert [r[0] for r in result] == [16, 16]
    assert result[0][1] != result[1][1]
    error = rejected(db, "INSERT INTO t(id,v) VALUES(NULL,'c') RETURNING *", "NOT NULL constraint")
    return {"generated_blob_ids": result, "null_is_not_default": error}


def trigger_returning(db):
    db.execute("CREATE TABLE t(id INTEGER PRIMARY KEY)")
    db.execute("CREATE VIEW input AS SELECT id FROM t")
    return rejected(db, "CREATE TRIGGER input_insert INSTEAD OF INSERT ON input BEGIN INSERT INTO t VALUES(NEW.id) RETURNING *; END", "RETURNING")


def known_key_correlation(db):
    db.execute("CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT)")
    db.execute("INSERT INTO t VALUES(1,'old'),(2,'old'),(3,'old')")
    result = rows(db, "WITH input(ord,id,v) AS MATERIALIZED (VALUES(0,3,'c'),(1,1,'a'),(2,2,'b')) UPDATE t SET v=input.v FROM input WHERE t.id=input.id RETURNING (SELECT ord FROM input WHERE input.id=t.id),id,v")
    assert sorted(result) == [(0, 3, "c"), (1, 1, "a"), (2, 2, "b")]
    inserted = rows(db, "WITH input(ord,id,v) AS MATERIALIZED (VALUES(0,9,'z'),(1,8,'y')) INSERT INTO t(id,v) SELECT id,v FROM input RETURNING (SELECT ord FROM input WHERE input.id=t.id),id,v")
    assert sorted(inserted) == [(0, 9, "z"), (1, 8, "y")]
    return {"correlated_update": result, "correlated_insert": inserted}


def staged_defaults(db):
    db.execute("CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT DEFAULT 'db')")
    db.execute("INSERT INTO t VALUES(1,'existing')")
    db.execute("CREATE TEMP TABLE stage(ord INTEGER, id INTEGER PRIMARY KEY, v TEXT DEFAULT 'db')")
    staged = rows(db, "INSERT INTO stage(ord) VALUES(0),(1) RETURNING *")
    assert staged == [(0, 1, "db"), (1, 2, "db")]
    error = rejected(db, "INSERT INTO t(id,v) SELECT id,v FROM stage RETURNING *", "UNIQUE constraint")
    generated = rows(db, "INSERT INTO t(v) SELECT v FROM stage ORDER BY ord RETURNING *")
    assert generated == [(2, "db"), (3, "db")]
    return {"staged_defaults": staged, "copy_ids_fails": error, "regenerated_ids_lose_ordinal": generated}


def ignore_is_broader_than_do_nothing(db):
    db.execute("CREATE TABLE t(id INTEGER PRIMARY KEY, v TEXT NOT NULL DEFAULT 'db', n INTEGER CHECK(n>0))")
    error = rejected(db, "INSERT INTO t(n) VALUES(-1) ON CONFLICT DO NOTHING RETURNING *", "CHECK constraint")
    ignored = rows(db, "INSERT OR IGNORE INTO t(n) VALUES(-1) RETURNING *")
    assert ignored == []
    return {"do_nothing_preserves_check_error": error, "or_ignore_swallows_check_error": ignored}


probe("Inline DEFAULT and writable CTEs are rejected", grammar)
probe("Multi-row omission invokes per-row defaults and mixed integer IDs", omitted_columns)
probe("Schema default SQL can be inlined with explicit null preserved", expression_substitution)
probe("Reading dflt_value returns text rather than evaluating SQL", default_text_is_not_executable_data)
probe("A scalar subquery can collapse per-row default evaluation", scalar_subquery_evaluation)
probe("NULL and REPLACE do not mean DEFAULT for nullable columns", null_and_replace)
probe("Omitted upsert columns are available through excluded", upsert_defaults)
probe("SQLite allows repeated upsert targets and reports only affected rows", upsert_duplicate_and_skip)
probe("UPDATE FROM works but does not return input order or source ordinal", update_from)
probe("UPDATE FROM collapses duplicate targets", duplicate_updates)
probe("UPDATE FROM changes uniqueness-sensitive update order", update_order_constraints)
probe("INSERT RETURNING cannot directly reference source ordinal", source_ordinal)
probe("Post-write SELECT differs from RETURNING with AFTER triggers", trigger_images)
probe("Skipped conflicts create holes in generated IDs", ignored_rows_and_generated_ids)
probe("Global grouping by column shape changes conflict winners", regrouping_shapes)
probe("Multi-row inserts change immediate self foreign key boundaries", immediate_foreign_key_boundary)
probe("Ordered result sets retain skipped inputs and savepoint rollback", ordered_batch_and_savepoint)
probe("UPDATE FROM can use schema expressions for explicit reset-to-default", expression_defaults_on_update)
probe("BLOB primary key defaults differ from INTEGER PRIMARY KEY", uuid_primary_key)
probe("Triggers cannot collect RETURNING results directly", trigger_returning)
probe("Known unique keys allow correlation through a materialized input CTE", known_key_correlation)
probe("Staging defaults does not solve destination generated ID correlation", staged_defaults)
probe("INSERT OR IGNORE is broader than ON CONFLICT DO NOTHING", ignore_is_broader_than_do_nothing)

with sqlite3.connect(":memory:") as metadata_db:
    metadata = {
        "sqlite_version": sqlite3.sqlite_version,
        "sqlite_source_id": rows(metadata_db, "SELECT sqlite_source_id()")[0][0],
        "compile_options": [r[0] for r in rows(metadata_db, "PRAGMA compile_options")],
    }

print(json.dumps({"metadata": metadata, "passed": len(observations), "probes": observations}, indent=2))
