# Testing

How each test suite in this repository runs, what it provides for itself, and
the knobs that change its behavior. The short version: most suites are
zero-setup `dart test` from their package directory; the exceptions are listed
last.

One-time prerequisite: resolve the workspace with [Melos](https://melos.invertase.dev)
(`dart pub global activate melos`, then `melos bootstrap` from the repo root -
re-run it after dependency changes). `melos run test` runs all the host
(no-Docker) suites in one go, and each group also has its own script -
`melos run test_unit`, `test_bootstrap`, `test_integration_server`,
`test_integration_modules`, `test_integration_sqlite_server` (see
`melos.yaml`). The sections below are for running suites directly with
`dart test`.

## tests/serverpod_test_server

### test_integration (the main suite)

```sh
cd tests/serverpod_test_server
dart test test_integration
```

Zero setup. The run-mode configs carry an embedded PostgreSQL `dataPath`, so
the first suite launches a per-workspace postmaster
(`.serverpod/test/pgdata`); every suite file provisions its own database on
it, servers bind ephemeral ports, and the package-wide 120s test timeout
covers cold provisioning. The postmaster outlives the run so re-runs start
warm.

Variants:

| Scenario                    | What to do                                                               |
| --------------------------- | ------------------------------------------------------------------------ |
| Loaded machine              | Add `-x timing` - excludes the tests asserting wall-clock upper bounds.  |
| Include the redis suites    | Run a Redis with password `password`; map `redis` to it in `/etc/hosts`. |
| Second run in the same tree | Set `SERVERPOD_DATABASE_DATA_PATH` to a unique path (pid-derived works). |
| External database           | `SERVERPOD_DATABASE_DATA_PATH=''` - empty selects the config's own host. |
| Full CI-equivalent flow     | `melos run test_integration_server` - pre-warm + the tagged second pass. |

Different workspaces/checkouts already isolate from each other; the data
path override is only needed for two runs in one tree.

### test_e2e (client battery against one live server)

Three contracts: **serial**, **fresh database**, **no redis**. Two ways to
honor them:

```sh
# Canonical: builds a server bundle, wipes pgdata, boots, runs file-by-file.
util/run_tests_e2e_host vm        # from the repo root
```

```sh
# Manual / iterating on single files. One-time: map the docker-era hostname.
#   echo '127.0.0.1 serverpod_test_server' | sudo tee -a /etc/hosts
cd tests/serverpod_test_server
rm -rf .serverpod/test/pgdata
dart run bin/main.dart -m production --apply-migrations &
dart test test_e2e -P e2e         # preset: concurrency 1 + redis excluded
```

Fresh database matters: runtime settings persist across runs and skew the
service-protocol logging assertions. The server bundle (rather than
`dart run`) matters for full runs: `dart test`'s native-asset rebuilds can
crash a `dart run` server mid-suite.

### test (unit) and test_e2e_migrations

`dart test test` runs plainly. The migrations e2e flow runs via
`util/run_tests_migrations_e2e`, which resets the embedded database and
builds the server bundle itself.

## Other packages

- **tests/bootstrap_project** - `dart test` from the package directory. Runs
  suites serially, compiles the in-repo CLI once per run (lock-elected within
  a run, serialized per checkout across runs). Needs Docker Desktop for the
  Dockerfile/compose tests; nested test runs of generated Flutter workspaces
  skip themselves under version managers whose `dart pub` cannot resolve the
  Flutter SDK (e.g. puro).
- **tests/serverpod_cli_e2e_test, tools/serverpod_cli, packages/*** - plain
  `dart test`, no setup. `serverpod_embedded_postgres`'s integration tests
  spawn real postmasters; `SERVERPOD_PG_SOURCE=download|build|auto` and
  `SERVERPOD_PG_BUNDLE_REPO` select where its binaries come from, and
  `SERVERPOD_PG_LOG_STDERR=1` mirrors postmaster logs for debugging.
- **Module servers** (`serverpod_auth_test`, `serverpod_test_module`,
  `serverpod_test_nonvector`, sqlite) - still env-dependent: run via
  `melos run test_integration_modules` / `test_integration_sqlite_server`,
  which set `SERVERPOD_DATABASE_DATA_PATH`. (Extending the config-default
  treatment to these is a known follow-up.)
- **Dockerized Flutter integration** - `util/run_tests_flutter_integration`:
  self-contained compose stack with its own postgres + redis (its environment
  opts out of embedded PostgreSQL).
- **Everything** - `melos run test`.

## Design notes

Concurrent runs are a supported scenario (human + agent on one machine):
databases isolate per workspace by default and per run by env override,
stable ports are pid-derived (`stableTestPort`), CLI builds serialize per
checkout via an inter-process lock, and redis is opt-in per suite. What
cannot be promised under load is wall-clock upper bounds - those tests carry
the `timing` tag so heavy-load runs can exclude them explicitly.
