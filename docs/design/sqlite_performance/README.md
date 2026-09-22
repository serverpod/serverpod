# SQLite execution performance

Measured while implementing `perf/sqlite-execution`, based on
`5410f872fd8ada1908524a8c915ae16588058567` (September 2026).
The incremental table records each change when it was implemented. Review
subsequently changed cache defaults and maintenance locking; final measurements
are recorded separately below. Gains must not be added together.

## Measurements

Native Dart 3.12.2 on Linux/WSL2, warmed JIT with `-Ddart.vm.product=true`,
SQLite through the resolved `sqlite_async` 0.14.5 driver, temporary disk databases,
WAL and the driver's default synchronous setting. Seven measured samples follow
three or five warmups; setup is outside timing. The main measurements ran
without test suites in parallel. The host was not otherwise isolated, so small
differences are inconclusive. Times are milliseconds per workload, not per row.

| Change | Workload | Before | After | Interpretation |
| --- | --- | ---: | ---: | --- |
| Linear relation grouping | Include 10,000 children of one parent, ordered by ID | 187.386 | 45.471 | 4.12x faster |
| Keep update selection in SQL | Update 10,000 rows with `noReturn` | 36.693 | 3.908 | 9.39x faster |
| Batch bound writes | Insert 1,000 rows with `noReturn` | 141.078 | 3.564 | 39.58x faster |
| Batch bound writes | Update 1,000 rows with `noReturn` | 114.164 | 2.724 | 41.91x faster |
| Normalize results once | Find 10,000 parents with nested includes | 303.453 | 301.433 | No clear timing gain |
| Return only upsert IDs | Upsert 1,000 rows, each with 4 KB text and a 100-element list, `noReturn` | 690.548 | 464.851 | 1.49x faster |
| Cache and bind returning writes | Insert 1,000 rows with returned models | 150.011 | 142.317 | Small, inconclusive |
| Cache and bind returning writes | Update 1,000 rows with returned models | 139.936 | 127.133 | Small, inconclusive |
| Skip parsing generated SQL | Find 1,000 rows individually by ID | 239.837 | 146.248 | 1.64x faster |
| Add literal-default columns directly | Add boolean default to a table containing 100,000 rows | 40.575 | 7.193 | 5.64x faster |
| Maintain planner statistics | 100 lookups on 100,000 rows with competing indexes | 595.190 | 39.444 | 15.09x faster for this deliberately skewed fixture |

The initial cache before/after read comparison regressed (171.409 to 209.823 ms).
A follow-up alternating same-process experiment used cache sizes 0, 100, 100, 0,
with five warmups and eleven samples per configuration. The medians for 1,000
parameterized adapter reads were 163.283, 133.744, 134.085, and 143.217 ms.
This supports a modest cache benefit, but the spread does not justify a precise
percentage claim. Review found that the driver caches complete SQL text,
including large literals still used by some ORM operations. Caching is therefore
**disabled by default** in the final implementation. It remains available as an
explicit `preparedStatementCacheSize` option; the bound counts statements, not
bytes. Parameterized inserts and updates remain enabled independently.

The planner fixture has `a=1` for every row and a distinct `b` per row, indexed
separately. Before maintenance, SQLite chose the `a` index; afterwards, it chose
`b`. This demonstrates a fix for missing statistics, not a universal query gain.
Timing excludes opening the database and therefore excludes startup maintenance
cost. A separate five-reader empty-database open/close comparison measured
22.811 ms before maintenance versus 30.003 ms afterwards (five warmups, eleven
samples). The final maintenance design below replaces the exclusive pool lock,
which review found could deadlock under contention. The reader regression
verifies cached plans refresh; busy readers use a best-effort timed lease.

## Final defaults after review

Re-measured at `594c9f9ab`, with statement caching disabled and bounded analysis
using the writer followed by individual reader refreshes:

| Workload | Final median (ms) |
| --- | ---: |
| Insert 1,000 rows, `noReturn` | 3.460 |
| Update 1,000 rows, `noReturn` | 2.873 |
| Upsert 1,000 wide rows, `noReturn` | 242.902 |
| Find 1,000 rows individually by ID | 177.685 |
| 100 lookups on the skewed 100,000-row fixture | 43.183 |

An additional open/close comparison with caching disabled on both sides measured
25.433 ms without maintenance and 27.703 ms with final maintenance. The sample
ranges overlap (20.574–36.615 and 24.678–35.119 ms), so this does not establish a
precise startup overhead. The clear batching gains remain with caching disabled.
The final upsert result includes later parser-bypass changes as well as the
narrower returned projection; it is not attributable to one change alone.

Raw medians and sample ranges are retained in [measurements.json](measurements.json).
The scratch harnesses and full test logs for this run are in
`/tmp/serverpod-sqlite-perf/`; they are local artifacts, not repository fixtures.
A representative invocation was:

```sh
dart --packages=.dart_tool/package_config.json -Ddart.vm.product=true \
  /tmp/serverpod-sqlite-perf/implementation/bulk.dart batch upsert
```

## Preserved behavior

- Batch only consecutive identical SQL shapes, retaining input/trigger order and
  generated-ID behavior. All chunks share one transaction or savepoint.
- Bind data values, including binary views, JSON, UUIDs, and SQL punctuation.
- Preserve upsert duplicate-target errors and `updateWhere` skips; UUID IDs are
  compared by value.
- Raw SQL retains parsing and script atomicity. Generated SQL uses the driver's
  single-statement API, with reads routed to reader connections.
- Literal defaults use `ADD COLUMN`; expressions and constraint changes retain
  the table rebuild path.
- Planner maintenance runs at startup, daily, and within schema migrations.
  Analysis is bounded with mask `0x10012`. The writer is released before
  best-effort reader refreshes through individual one-second leases. Refresh
  uses `writable_schema=RESET`, which disables schema writes and reloads cached
  schema state. Shutdown cancels the timer and waits for pending maintenance;
  restarting during shutdown is rejected.

SQLite documents [planner maintenance](https://www.sqlite.org/lang_analyze.html)
and the [RESET behavior](https://www.sqlite.org/pragma.html#pragma_writable_schema).
Statistics can change query plans; their benefit depends on the data.

## Validation

Completed validation:

- Database package: 871 tests passed, including embedded PostgreSQL checks.
- SQLite client suite: 590 passed, one existing skip.
- Full SQLite server integration suite: 1,439 passed, one existing skip.
- CLI database migration and SQL-generation suite: 767 passed.
- Database configuration tests: 50 passed.
- Chrome affected CRUD, rollback, pagination, and list-include suites: 55 passed.
- Static analysis and formatting passed for the changed code.
- Added regressions cover batch rollback, typed values and quoting, generated
  IDs, duplicate upserts, pagination, cached schema changes, literal defaults,
  planner refresh, and pool shutdown/restart.

Browser validation exposed a nested-lock issue in the driver's web
`withAllConnections` implementation. Maintenance now uses the normal write lock
when there are no reader connections. All 55 browser checks passed after that
fix. After the review corrections, the 871 database-package tests, 590 client
tests, and all 55 browser checks passed again; the eight maintenance/migration
regressions include the new native deadlock case.

## Adversarial review

Opus xhigh reviewed the implementation through Orca orchestration. The first
pass reported two significant open findings, both addressed:

- **Native maintenance deadlock:** exclusive pool access could wait behind a
  transaction whose independent read then waited behind maintenance. Commit
  `594c9f9ab` uses separate writer and reader leases. The new adapter regression
  fails with a two-second timeout against `0f4f48841` and passes after the fix.
- **Literal retention by the statement cache:** the review's 100 × 1 MiB blob
  update reproduction reported 540 MiB RSS growth with cache size 100 versus
  57 MiB with caching disabled. Commit `3b3f06a07` restores the default to zero
  and documents the opt-in memory trade-off.

The follow-up Opus xhigh review of `594c9f9ab` reported **no remaining significant
findings**. The reviewer independently reproduced completion with the revised
locking pattern (413 ms) and ran the four pool-maintenance tests successfully.
Orca run `run_748f2cacf2c8` records both accepted reviews (dispatches
`ctx_a7aa66d8f815` and `ctx_ad6380b718e2`).

Remaining trade-offs: opting into caching can retain large literal SQL values,
and shutdown can wait for active maintenance, including up to one second per
reader lease attempt. Both are documented rather than hidden by the timing
results.
