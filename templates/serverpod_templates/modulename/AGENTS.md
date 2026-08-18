# Serverpod module

This is a newly created Serverpod module: a reusable package with server code (`modulename_server`) and client code (`modulename_client`) that other Serverpod projects add as a dependency. A module is not a runnable server, so there is no `serverpod start` and no `serverpod` MCP here.
<!-- {{#skills}} -->

Serverpod agent skills are installed in this project. They cover models, migrations, the database ORM, endpoints, streams, authentication, testing and modules — read the skill that matches the task before writing Serverpod code, starting with `serverpod-overview`.
<!-- {{/skills}} -->

Working loop, run from `modulename_server`:

- Add models (`.spy.yaml`) and endpoints under `lib/src/`.
- `serverpod generate` after every change to a model or an endpoint.
<!-- {{#database}} -->
- `serverpod create-migration` after changing a model with a `table` (add `--force` for destructive changes). The migration ships with the module and is applied by the projects that depend on it.
<!-- {{/database}} -->
- `dart analyze` and `dart format`.
- `dart test` to run the tests. They use `withServerpod` from the generated test tools together with `config/test.yaml`.<!-- {{#postgres}} --> No Docker is needed: `config/test.yaml` sets `database.dataPath`, so Serverpod starts and manages the test database (an embedded PostgreSQL) itself.<!-- {{/postgres}} --><!-- {{#sqlite}} --> No database server is needed: `config/test.yaml` points at a SQLite file.<!-- {{/sqlite}} -->

<!-- {{#database}} -->
Prefix table names with the module name (for example `modulename_orders`) so they cannot collide with the tables of the projects that use this module.

<!-- {{/database}} -->
NEVER edit generated code. `modulename_server/lib/src/generated/`<!-- {{#database}} -->, the `migrations/` directory<!-- {{/database}} --> and the whole `modulename_client` package are rewritten by the code generator. Change the models, the endpoints or `lib/modulename_server.dart` instead.

Projects that depend on this module reference its types as `module:modulename:MyType`, where `modulename` is the `nickname` in `config/generator.yaml`.

IMPORTANT: After building the first version of the module, update this AGENTS.md file with information about what the module does. KEEP the working loop and the note about generated code. Remove this paragraph.
