# SQLite execution performance

This branch reduces ORM/driver overhead while preserving individual SQLite write
semantics. The branch baseline is `c763c4d773c36c2dc76403d86b4edecf763a42ca`.
Performance evidence is executable Dart, not checked-in timing snapshots from
another machine. Run both revisions together before using numbers in a PR.

## Reproduce the comparison

Use one Dart SDK for both revisions and resolve the workspace dependencies.
Build native assets once, for example by running a native database test or the
small ORM harness:

```sh
dart run docs/design/sqlite_performance/returning_writes/orm_benchmark.dart --quick
```

Then run the comparison from the repository root with other tests and
benchmarks stopped:

```sh
dart run docs/design/sqlite_performance/compare.dart > /tmp/sqlite-comparison.md
```

[compare.dart](compare.dart) compiles the same workload against the baseline
and current working tree. It archives changed workspace packages from Git into
a temporary directory and uses separate package configurations. Both revisions
use the same resolved external dependencies, Dart SDK, SQLite native assets,
and fixtures. It does not switch branches or change the workspace package map.
Temporary source archives and kernels are removed after the run.

Compiler-generated dependency files must identify each revision's actual adapter,
pool, migration runner, and SQL generator sources, with no files from the other
revision's archived packages. Kernel content hashes are checked before every run
to reject switched or modified kernels. Runtime package URIs are supplementary
metadata, not evidence of which sources were compiled.

The runner uses the active SDK's kernel compiler to attach the same native-asset
mapping to both kernels. It requires `git`, `tar`, and the generated
`.dart_tool/native_assets.yaml`. If resolution or assets live elsewhere, pass
`--package-config=/absolute/path/package_config.json` and
`--native-assets=/absolute/path/native_assets.yaml`. The configuration files are
build inputs, not recorded benchmark results.

Full runs counterbalance baseline/candidate/candidate/baseline with
candidate/baseline/baseline/candidate (ABBA + BAAB), so both revisions occupy
the outer and inner process positions. Each process performs ten warmups and
seven measured samples for each operation, giving 28 samples per revision.
The report includes aggregate and per-process medians, ratios, every sample,
pairwise candidate win shares, median pairwise timing differences,
revision identities, working-tree status, fixture sizes, Dart/SQLite versions,
journal mode, synchronous mode, archived packages, compiler input counts, and
hashes of the workload, kernels, tracked diff, and untracked Dart sources.
Execution uses warmed kernel JIT with `dart.vm.product=true`. Processor count
and Linux load averages before/after each process are recorded; the host is not
isolated. Setup and verification are outside timing;
transaction execution, result transfer, and ORM hydration are inside it.
The runner rejects incomplete output, differing runtime settings, and tracked
source changes during measurement, including untracked Dart files.

`--quick` uses smaller fixtures and one baseline/candidate pair to verify the
harness. Its output is marked as a smoke check, not performance evidence.
To isolate the later ordered-batch changes from the earlier optimizations:

```sh
dart run docs/design/sqlite_performance/compare.dart \
  --baseline=28af18dc6 > /tmp/sqlite-ordered-batch-comparison.md
```

Compare revisions within one invocation. Do not combine measurements across
machines or add gains from separate changes. The report retains all samples,
including outliers. Pairwise candidate wins compare every candidate sample with
every baseline sample, counting ties as half a win. Median pairwise change is the
median of candidate minus baseline differences (Hodges–Lehmann shift); positive
values indicate slower execution. Range overlap alone does not establish
neutrality or inconclusiveness: one outlier can obscure a consistent slowdown.
These summaries are descriptive, not statistical confidence tests, because
samples share processes and host conditions. Investigate persistent regressions
and repeat noisy comparisons. These fixtures measure native SQLite; browser
behavioral tests do not establish browser speedups.

## Operations measured

[orm_benchmark.dart](returning_writes/orm_benchmark.dart) uses the real generated
client models, SQLite adapter, driver, and temporary disk databases. Every
sample checks returned results and persisted values after timing. Updates start
from different values so the measured operation must change data. The insert
fixtures use explicit integer IDs; generated-ID semantics are checked by the
dialect and ORM regression tests, not measured by these insert timings.

| Workload | Fixture | Change exercised |
| --- | --- | --- |
| Insert, update, upsert with returned models | 1,000 rows each | Bound ordered execution and model/result handling |
| Insert, update, upsert without returned models | 1,000 rows each | Driver batching and reduced returned projections |
| Wide upsert without returned models | 1,000 existing rows, 4 KB text and 100-element list | Avoid returning wide data; bind conflict updates |
| Find by ID | 1,000 separate reads | Generated-SQL parser bypass |
| Update where without returned models | 10,000 rows selected with ordering and limit | Keep selection inside SQLite |
| Include children | One parent with 10,000 children | Linear relation grouping |
| Nested includes | 10,000 people including their organization and its city | Result normalization; a control with no presumed gain |
| Many parents with included lists | 5,000 cities, each with two people | Reuse normalized parent rows when collecting IDs for included lists |
| Add a literal-default column | 100,000 existing rows | Generated migration through the production runner, including transaction and maintenance overhead |
| Planner lookups | 100 queries over 100,000 rows with competing indexes | Startup statistics maintenance |
| Empty database open/close | Default connection pool | Cost of startup/shutdown maintenance |
| Unanalyzed populated database open/close | 100,000 rows and two indexes, no statistics before each sample | Cost of initial analysis and reader refresh on real data |

The planner fixture has `a=1` for every row and distinct `b` values, with separate
indexes. Each sample recreates the table without statistics, then opens it
through the adapter before timing queries. The baseline and candidate therefore
exercise their own startup behavior. This measures a deliberately skewed case;
it is not a universal query improvement. The separate empty and populated
open/close workloads measure startup overhead; neither is folded into the
lookup-only time. The populated fixture verifies the absence of statistics
before timing and checks that all stored rows remain unchanged afterwards.

The ordered-batch comparison may show extra planning cost for uniform no-return
insert/update workloads. Keep those regressions visible alongside improvements.
Driver statement caching is disabled in the final branch; there is no public
cache option to tune for a favorable result.

## Executable dialect and driver evidence

```sh
dart run docs/design/sqlite_performance/returning_writes/dialect_probe.dart
dart run docs/design/sqlite_performance/returning_writes/driver_probe.dart \
  > /tmp/sqlite-driver-comparison.md
dart run docs/design/sqlite_performance/returning_writes/builder_probe.dart
```

[dialect_probe.dart](returning_writes/dialect_probe.dart) executes 23 independent
checks directly against the resolved SQLite build. It has no Python, system
SQLite, or recorded-output dependency. Expected behavior is asserted, including
independent volatile defaults, explicit NULL, conflicts, immediate foreign keys,
AFTER triggers, repeated targets, and savepoint rollback.

[driver_probe.dart](returning_writes/driver_probe.dart) runs those checks plus
native typed-value and ordered-result checks. It compares awaited individual
statements, ordered worker chunks, and set-based chunks in the same run, rotating
method order with three warmups and seven samples. It verifies 1,000 returned
rows and expected keys/values per sample. This is a driver experiment, excluding
ORM serialization and hydration. Its narrow set-based fixtures have no triggers
or duplicate inputs; their timing does not establish semantic equivalence for
general ORM writes.

[builder_probe.dart](returning_writes/builder_probe.dart) reproduces the generic
SQL builder's inline-DEFAULT dialect mismatch. The SQLite adapter now builds
bound upserts with omitted defaulted columns instead of executing that invalid
SQL. The probe also verifies that omission returns the actual database default.

| Alternative | Constraint established by the probes |
| --- | --- |
| Inline DEFAULT in VALUES or SET | SQLite rejects the syntax; omit defaulted columns |
| Select `pragma_table_xinfo.dflt_value` as data | Returns SQL text, not its evaluated result |
| Put volatile defaults in an uncorrelated scalar subquery | Can evaluate once for multiple rows |
| Use NULL or OR REPLACE as a generic default convention | Does not preserve nullable defaults |
| Omit upsert columns and reference `excluded` | Preserves database defaults for conflict updates |
| UPDATE FROM | Collapses duplicate targets and can change uniqueness-sensitive write order |
| Correlate by RETURNING position | Row order is unspecified; source ordinals cannot be referenced directly |
| Select rows after writing | Can return AFTER-trigger values instead of RETURNING snapshots |
| Infer contiguous generated IDs | Ignored conflicts can leave holes |
| Group all inputs by SQL shape | Can change conflict winners |
| Stage defaults and copy generated IDs | Can collide with destination IDs and lose input correlation |
| Combine individual inserts | Can change immediate foreign-key constraint boundaries |
| INSERT OR IGNORE | Suppresses errors beyond the conflicts handled by DO NOTHING |

See SQLite's [INSERT syntax](https://www.sqlite.org/lang_insert.html),
[default rules](https://www.sqlite.org/lang_createtable.html#the_default_clause),
[UPDATE FROM rules](https://www.sqlite.org/lang_update.html#update_from), and
[RETURNING limitations](https://www.sqlite.org/lang_returning.html#limitations_and_caveats).

## Implementation and preserved behavior

- Ordered plans contain at most 256 statements and approximately 1 MiB of SQL
  and bound input. One oversized input travels alone. All chunks share the
  existing transaction or savepoint.
- Native execution prepares each SQL shape once per chunk, runs statements in
  input order, collects a result slot per input, and closes every statement.
  Uniform no-return insert/update batches retain the driver's executeBatch path.
- Skipped inputs and missing updates retain empty slots. Normalization and
  non-persisted-field merging use the matching input, including after skips.
- Upserts collect affected IDs, including with noReturn, and reject duplicate
  targets across all chunks before committing. UUIDs compare by value.
- Defaults are omitted rather than replaced with NULL. The narrow all-default
  conflict-write case uses NULL for integer rowids; other IDs read their actual
  schema default once per table per operation. There is no persistent schema
  cache or hot-reload invalidation requirement.
- Raw SQL retains parsing and script atomicity. Generated statements use the
  single-statement driver path, with reads routed to readers.
- Normalized query rows are materialized only when included lists will traverse
  them again, including lists nested through object relations. Other queries
  retain lazy normalization to avoid holding another complete row collection.
- Batch query logs contain one entry per executed chunk with bound placeholders.
  Uniform no-return batches report zero returned rows. Query counts and slow-query
  timing therefore describe chunks rather than individual input rows.
- Literal-default columns use ADD COLUMN where valid. Expression defaults and
  constraint changes retain the rebuild path.
- Planner maintenance runs at startup, daily, and during schema migrations.
  Startup and periodic analysis use mask 0x10012; migrations use plain
  PRAGMA optimize. The writer is released before best-effort
  reader refresh through individual one-second leases. Shutdown waits for
  pending maintenance and rejects restarting while shutdown is in progress.
- Web uses the standard sqlite_async worker and its configured URI. Returning
  and mixed-shape writes execute sequentially in the existing transaction.
  Custom-worker acceleration belongs to a separate branch.

Focused regressions live in the SQLite client CRUD tests, SQLite server upsert
and default tests, database pool/migration tests, and CLI literal-default
migration tests. They cover typed values, generated IDs, ordered trigger
snapshots, skipped results, watch notifications, nested rollback, late failures,
UUID duplicate detection, planner refresh, and pool lifecycle. Run affected
suites for changes; historical test totals are not evidence for a new revision.
