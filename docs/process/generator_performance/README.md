# Investigating code generator performance

Use these tools to measure how long `serverpod generate` takes to analyze and
generate a project, and to evaluate changes to the generator in
`serverpod_cli`. The comparison runner executes the same workload with the CLI
of a chosen Git revision and with the CLI of the current working tree, both as
one-shot generations and as continuous generations with `--watch`.

## Compare revisions

Run from the repository root with the workspace dependencies resolved. Build
native assets once by running the CLI:

```sh
dart run tools/serverpod_cli/bin/serverpod_cli.dart version
```

Choose a baseline before the generator change you want to measure. For
uncommitted changes, compare against `HEAD`:

```sh
dart run docs/process/generator_performance/compare.dart \
  --baseline=HEAD > /tmp/generator-comparison.md
```

For committed changes, pass an earlier commit, tag, or branch name to
`--baseline`. The argument is required. Any revision can be the baseline, as
long as its CLI compiles with the current Dart SDK and can generate a project
created by the working tree's CLI.

Stop other tests and benchmarks during measurement. Use `--quick` for a smoke
check with 50 files per fixture instead of 1,000:

```sh
dart run docs/process/generator_performance/compare.dart \
  --baseline=HEAD --quick > /tmp/generator-smoke.md
```

Use full runs for performance comparisons. Quick runs check that the harness
compiles, executes, and verifies its fixtures. On an 8-core laptop a full run
takes about 19 minutes and a quick run about 7 minutes. About 3 minutes of
a full run are the outcome checks between measurements. The slower revision
dominates a full run, so it takes longer against a baseline that generates
slowly. Most of a quick run is CLI startup, which analyzes the project every
time.

[compare.dart](compare.dart) archives the complete baseline revision from Git
into a temporary directory, resolves its dependencies there with `dart pub get`
and builds its native assets. It then compiles the CLI of each revision to a
kernel file from that revision's own sources, dependencies, and native assets,
with the same Dart SDK. The revisions therefore do not have to compile against
each other's packages: either one may add, remove, or upgrade dependencies and
workspace packages. The runner leaves the checkout and workspace package map
unchanged and removes its temporary sources, kernels, and projects afterwards.
Pass `--keep` to inspect them.

When the baseline revision has no `pubspec.lock` of its own, which is the case
while the lock file is not committed, its resolution starts from the working
tree's lock file. Dependencies that both revisions share then resolve to the
same versions wherever the baseline's constraints allow it. A baseline that
brings its own lock file keeps it. The report lists the external dependencies that still
differ. A difference in such a dependency is part of what is compared.

The runner requires `git`, `tar`, and, for the working tree,
`.dart_tool/native_assets.yaml`. If the working tree's package configuration or
native assets are elsewhere, pass
`--package-config=/absolute/path/package_config.json` and
`--native-assets=/absolute/path/native_assets.yaml`. Resolving the baseline
needs its dependencies in the pub cache or network access.

Both revisions measure copies of one project, created with
`serverpod create --template server` by the candidate CLI. The project depends
on the working tree's Serverpod packages for both revisions, so only the CLI
differs.

### Run in CI

The runner exits with a non-zero code when a revision does not compile, a
generation fails or times out, the measurement set is incomplete, or the
candidate does not behave as a scenario expects. Publish the
Markdown it prints to stdout as the job's result; progress goes to stderr.

Fetch enough history for the baseline revision to exist locally. The runner
compares any two revisions. When they do not differ in `tools/serverpod_cli`,
the report says so, and differences in it come from the CLI's dependencies or
from noise.

| Option | Default | Effect |
| --- | --- | --- |
| `--scale=<n>` | 1000 (50 with `--quick`) | Files added at once, and future calls, endpoints and models in the large project. At least 2, which the edits need: a future call with and one without parameters, and a model another one depends on |
| `--repeats=<n>` | 1 | Times the whole workload runs for each revision, including building the large project |
| `--edit-samples=<n>` | 1 | Times each edit is repeated in one watch session |

## Read the results

The report has one table for continuous generation and one for one-shot
generation. Each operation has three metrics:

- **Analysis** and **Generation** are the times the CLI prints for
  `Analyzing changes` and `Generating code`. The CLI prints whole milliseconds
  below 100 ms and tenths of a second from there on. A file watcher can report
  one change as several events; the times of every cycle a change triggers are
  added up.
- **Wall clock** is measured by the runner. For watch it runs from applying the
  change until the last cycle it triggered has finished, and includes file
  watcher latency. For one-shot it covers the whole process, including CLI
  startup.

The CLI prints nothing when a watch cycle is over. The last thing a cycle that
generated code does is write the generation stamp, after its `Generating code`
line, so the runner treats the change of that file as the end of the cycle. A
cycle that generated nothing ends with its analysis line. If a revision writes
no stamp within 15 seconds, the runner falls back to the last progress line and
says so at the top of the report.

The first run of a watch session is not over with its analysis line either:
the CLI then checks whether the generated code is up to date. The runner waits
for the message that says so, or for a generation and its stamp. A revision
that prints neither within 15 seconds is measured up to its analysis line,
which the report also states.

A file watcher can report one change as several events. The runner considers a
step finished when the output and the stamp have been quiet for 300 ms, which
cannot rule out an event that arrives later than that, or a second cycle whose
stamp takes longer than that to write.

`none` in the generation row means the CLI analyzed the change and decided that
nothing needed generating. `none` in the analysis row means the CLI did not
analyze the changes as a step of its own; compare such runs by wall clock. A
one-shot run on an up-to-date project has neither.
Ratios are baseline over candidate, so values above
1.00x mean the candidate is faster. The CLI prints whole milliseconds, so a
median of 0 ms is a time below one millisecond. It counts as 1 ms in a ratio:
900 ms against 0 ms is 900x.

The report also records revision identities, differing dependencies, kernel
hashes, working-tree state, fixture sizes, the SDK version, and all samples.
Compiler dependency files verify which source revision each kernel contains.
Kernel hashes are checked after execution. Every operation has a number of
samples it must reach for both revisions, given the options. Any other count,
or a source change during measurement, causes the run to fail.

After every measured run the runner checks the outcome, outside of the timing:

- The generation stamp is well formed and every file it lists exists.
- The generated code registers every endpoint and future call of the fixture
  with its methods, on the server and in the client, and every model and
  parameter model has its fields. This includes the model and the endpoint a
  newly created project comes with, and the members that edits added.
- After files were added, after the large project was generated, and after its
  edits, the generated server and client code is analyzed with `dart analyze`
  together with code that uses all of it: it creates every model with all of
  its fields, calls every endpoint method through the client, and schedules
  every future call through its dispatcher. Generated code that does not
  compile, or that lacks a member the fixture declares, fails this check.
- A watch change to a plain Dart file, and the first run on an up-to-date
  project, generated nothing.
- A one-shot run on an up-to-date project reported it as up to date.

The first two checks read the generated files as text and depend on how the
generator lays them out. A revision that formats its output differently can
fail them without being wrong; the analysis does not have that weakness.

Runs that did not behave as expected are listed at the top of the report. A
baseline that fails such a check is still reported, since comparing against a
revision with a known defect can be the point of the comparison. A candidate
that fails one makes the runner exit with a non-zero code.

Compare revisions within one invocation and retain the full report. Do not
combine measurements from different machines. With the defaults, almost every
operation has one sample per revision. Pass `--edit-samples` for more samples
of the watch edits and unchanged saves, or `--repeats` for more of every
operation, and inspect the samples before drawing conclusions from small
differences. The
revision that runs first alternates between scenarios, but the host is not
isolated and the summaries are descriptive, not statistical confidence tests.

## Workloads

[workload.dart](workload.dart) defines the fixtures, applies the changes, and
drives the CLI.

| Operation | Mode | Fixture | Area measured |
| --- | --- | --- | --- |
| First run on a clean project | Both | Newly created project with its generated code and generation stamp removed | Startup, full analysis and generation of a small project from sources alone |
| Add plain Dart files | Both | 1,000 files without endpoints or future calls, added to a clean project at once | Analysis of changes that need no generation |
| Add future calls | Both | 1,000 future calls added to a clean project at once | Future call analysis, parameter models and protocol generation |
| Add endpoints | Both | 1,000 endpoints added to a clean project at once | Endpoint analysis and protocol generation |
| Add YAML models | Both | 1,000 models added to a clean project at once | Model analysis and model generation |
| Generate the large project from scratch | One-shot | 1,000 future calls, 1,000 endpoints and 1,000 YAML models, without generated code | One-shot generation of a large project |
| Run on the up-to-date large project | One-shot | The generated large project, unchanged | The check that finds nothing to do |
| First run on the up-to-date large project | Watch | The generated large project, unchanged | Startup and analysis when nothing needs generating |
| Edit a future call without parameters | Watch | One file of the large project | Incremental protocol generation |
| Edit a future call with parameters | Watch | One file of the large project | Incremental protocol generation with a new parameter model |
| Edit an endpoint | Watch | One file of the large project | Incremental protocol generation |
| Edit a YAML model | Watch | One file of the large project, which an endpoint, a future call and another model depend on | Incremental model generation |
| Edit a plain Dart file | Watch | One file of the large project | Analysis of a change that needs no generation |
| Save an unchanged plain Dart file after a real change | Watch | A file of the large project, written again with identical content after another file changed | Analysis of a save without edits when the CLI has to examine the file again |
| Save an unchanged plain Dart file again | Watch | The same file, written once more with identical content | A save without edits that the CLI can recognize as such |
| Regenerate the large project after an edit | One-shot | One edited future call with parameters in the large project | One-shot generation of a large project that was generated before |

The clean project is a copy of a project created with `serverpod create`.
Creating a project also generates its code, so the copy has its generated
server and client code and its generation stamp removed. The first run then
generates from sources alone, and neither revision starts from code the other
one wrote.

Half of the future calls take parameters besides the session and half do not.
Every model has a field of the previous model's type, so the models form one
chain of dependencies. In the large project, every endpoint takes and returns
the model with its own index, and every future call with parameters takes it.
Where future calls and endpoints are added to a clean project, which has no
such models, they use primitive types.

Every edit adds a member with a new name and keeps the members that earlier
edits added, so the generated code has to grow.

For continuous generation, the runner starts `serverpod generate --watch` on
the project, waits for its first run, and then applies the change. The files of
an adding operation are written outside of `lib` and moved in with one rename,
so the watcher sees them arrive together. All edits to the large project run in
one watch session. The CLI only announces that it is listening for changes at
debug level, so the runner rewrites a plain Dart probe file until a change to
it is analyzed before it measures anything.

The edits share one watch session and run in the order of the table, so an
edit can pay for what the one before it invalidated. The plain Dart edit
follows the model edit, and its analysis includes resolving the endpoints and
future calls again against the regenerated model.

The unchanged saves follow the edits in the same watch session. A real change
makes the CLI forget what it knew about files that declare no endpoint or
future call, so each sample starts with an unmeasured edit to one plain Dart
file. Another plain Dart file is then written twice with the content it already
has: the first save has to be examined again, the second one does not.

For one-shot generation, the runner generates the clean project, applies the
change, and runs `serverpod generate` again. One-shot generation analyzes and
generates the whole project whatever changed, so the five edits are only
measured individually with `--watch`. For one-shot, the large project is
generated from scratch, run again unchanged, and regenerated after a single
edit.

Each revision builds and generates its own large project, once for every
repeat.

The fixtures have many files and one chain of model dependencies. They have no
database tables, relations, or inheritance, so the results do not show how
those affect generation.

When extending the workload, keep its inputs and verification identical between
revisions. Verify each run, and include cases that could become slower as well
as those expected to improve.
