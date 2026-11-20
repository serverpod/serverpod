# Investigating SQLite performance

Use these tools to measure SQLite workloads and evaluate changes to Serverpod's
database layer. The comparison runner executes the same workload against a
chosen Git revision and the current working tree. The accompanying probes help
explore SQL semantics and driver execution strategies.

## Compare revisions

Run from the repository root with the workspace dependencies resolved. Build
native assets once by running a native database test or the small ORM workload:

```sh
dart run docs/process/sqlite_performance/returning_writes/orm_benchmark.dart --quick
```

Choose a baseline before the database change you want to measure. For
uncommitted changes, compare against `HEAD`:

```sh
dart run docs/process/sqlite_performance/compare.dart \
  --baseline=HEAD > /tmp/sqlite-comparison.md
```

For committed changes, pass an earlier commit, tag, or branch name to
`--baseline`. The argument is required. The runner requires a source or
dependency-constraint difference in `serverpod_database`; changes to tests or
documentation alone are not compared.

Stop other tests and benchmarks during measurement. Use `--quick` for a smoke
check with smaller fixtures and one baseline/candidate pair:

```sh
dart run docs/process/sqlite_performance/compare.dart \
  --baseline=HEAD --quick > /tmp/sqlite-smoke.md
```

Use full runs for performance comparisons. Quick runs check that the harness
compiles, executes, and verifies its fixtures.

[compare.dart](compare.dart) archives changed workspace packages from Git into
a temporary directory and creates separate package configurations. Both
revisions use the same resolved external dependencies, Dart SDK, SQLite native
assets, and workload. Both must compile with those inputs. The runner leaves
the checkout and workspace package map unchanged and removes its temporary
source archives and kernels afterwards.

The runner requires `git`, `tar`, and `.dart_tool/native_assets.yaml`. If the
package configuration or native assets are elsewhere, pass
`--package-config=/absolute/path/package_config.json` and
`--native-assets=/absolute/path/native_assets.yaml`.

## Read the results

Full runs alternate baseline and candidate in ABBA + BAAB order. Each process
performs ten warmups and seven measured samples per operation, giving 28 samples
per revision. Execution uses warmed kernel JIT with `dart.vm.product=true`.
Setup and verification are outside timing; transaction execution, result
transfer, and ORM hydration are inside it. Opening and closing databases are
measured separately.

The report records aggregate and per-process medians, all samples, ratios,
pairwise candidate win shares, and median pairwise timing differences. It also
records revision identities, source and kernel hashes, working-tree state,
fixture sizes, SDK and SQLite versions, database settings, and host load.
Compiler dependency files verify which source revision each kernel contains;
kernel hashes are checked before execution. Incomplete output, mismatched
runtime settings, or source changes during measurement cause the run to fail.

Compare revisions within one invocation and retain the full report. Do not
combine measurements from different machines or add gains from separate changes.
Inspect per-process results and repeat noisy comparisons, keeping regressions
visible alongside improvements. Range overlap alone does not establish that two
implementations perform equally.

Pairwise candidate wins compare every candidate sample with every baseline
sample, counting ties as half a win. Median pairwise change is the median of
candidate minus baseline differences; positive values indicate slower execution.
These are descriptive summaries, not statistical confidence tests: samples
share processes and host conditions, and the host is not isolated.

The workloads measure native SQLite. Measure browser performance separately
when changing browser execution paths.

## Workloads

[orm_benchmark.dart](returning_writes/orm_benchmark.dart) uses generated client
models, the SQLite adapter and driver, and temporary disk databases. Every
sample verifies returned results and persisted values after timing. Updates
start from different values so the measured operation must change data.

| Workload | Full-run fixture | Area measured |
| --- | --- | --- |
| Insert, update, upsert with returned models | 1,000 rows each | Write execution, result transfer, and model hydration |
| Insert, update, upsert without returned models | 1,000 rows each | Write execution without returned models |
| Wide upsert without returned models | 1,000 existing rows, 4 KB text and a 100-element list | Serialization and write costs for larger payloads |
| Find by ID | 1,000 separate reads | Query execution and result handling |
| Update where without returned models | 10,000 rows selected with ordering and limit | Filtered and paginated updates |
| Include children | One parent with 10,000 children | Loading and grouping included rows |
| Nested includes | 10,000 people including their organization and its city | Nested relation loading and result normalization |
| Many parents with included lists | 5,000 cities, each with two people | Loading lists for many parent rows |
| Add a literal-default column | 100,000 existing rows | Generated migration through the production runner, including transaction and maintenance costs |
| Planner lookups | 100 queries over 100,000 rows with competing indexes | Query planning after database startup |
| Empty database open/close | Default connection pool | Startup and shutdown costs |
| Unanalyzed populated database open/close | 100,000 rows and two indexes | Startup and shutdown costs without existing statistics |

Insert timings use explicit integer IDs. Use the dialect probes and ORM tests
to check generated-ID behavior separately.

The planner fixture has `a=1` for every row and distinct `b` values, with separate
indexes. Each sample recreates the table without statistics, opens it through
the adapter, and then times queries. This deliberately skewed case helps explore
planner behavior; it does not represent every data distribution. The separate
open/close workloads account for startup costs. The populated startup fixture
checks that statistics are absent before timing and that stored rows remain
unchanged afterwards.

When extending a workload, keep its inputs and verification identical between
revisions. Put setup and cleanup outside the measured operation, verify each
sample, and include cases that could become slower as well as those expected
to improve.

## Explore SQL and driver behavior

Run the probes with the workspace's resolved SQLite build:

```sh
dart run docs/process/sqlite_performance/returning_writes/dialect_probe.dart
dart run docs/process/sqlite_performance/returning_writes/driver_probe.dart \
  > /tmp/sqlite-driver-comparison.md
dart run docs/process/sqlite_performance/returning_writes/builder_probe.dart
```

[dialect_probe.dart](returning_writes/dialect_probe.dart) checks defaults,
explicit NULL, conflicts, generated IDs, immediate foreign keys, trigger
snapshots, input ordering, and savepoint rollback directly against SQLite.
Use these checks when evaluating alternative SQL shapes.

[driver_probe.dart](returning_writes/driver_probe.dart) adds typed-value and
ordered-result checks. It compares individually awaited statements, ordered
worker chunks, and set-based chunks, rotating method order with three warmups
and seven samples. Each sample verifies 1,000 returned rows and their keys and
values. It excludes ORM serialization and hydration. The set-based fixtures
have no triggers or duplicate inputs, so their timings alone do not establish
that a strategy preserves general ORM behavior.

[builder_probe.dart](returning_writes/builder_probe.dart) checks the generic SQL
builder's inline-DEFAULT syntax against SQLite and compares it with omitting a
defaulted column. Its assertions characterize the builder and dialect behavior;
revisit them when intentionally changing that contract.

SQLite references: [INSERT syntax](https://www.sqlite.org/lang_insert.html),
[default rules](https://www.sqlite.org/lang_createtable.html#the_default_clause),
[UPDATE FROM](https://www.sqlite.org/lang_update.html#update_from), and
[RETURNING limitations](https://www.sqlite.org/lang_returning.html#limitations_and_caveats).
