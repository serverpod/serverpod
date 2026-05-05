---
name: serverpod-cli
description: Serverpod CLI — serverpod create, generate, create-migration, and other commands. Use when generating code, creating migrations, or creating projects/modules.
---

# Serverpod CLI

Install: `dart pub global activate serverpod_cli`.
Run: from project root or server package directory.

## serverpod create

```bash
serverpod create <project_name> --no-interactive            # Full project (server, client, Flutter)
serverpod create --mini <project_name> --no-interactive     # Minimal project without database
serverpod create --template module <name> --no-interactive  # Module (server + client)
```

Project name: valid Dart package name (lowercase, underscores).

To upgrade a mini server directory to full Serverpod, run `serverpod create .` with the default/server template without the `--mini` flag.

## serverpod generate

Regenerate client and server code from endpoints and `.spy.yaml` models.

```bash
serverpod generate
```

Run after adding or changing endpoints, stream methods, future calls, or models. Do not edit generated files.

In workspace/melos setups, run `serverpod generate -d <server-package>` pointing to the server package.

## serverpod create-migration

Generate a database migration from model changes.

```bash
serverpod create-migration
```

Options: `--force` (override no-changes/data-loss checks), `--tag "v1-0-0"` (name tag).

Apply: `dart run bin/main.dart --apply-migrations` (or `--role maintenance --apply-migrations` for scripted runs).

## serverpod create-repair-migration

Repair when DB was modified outside migrations. Compares live DB to migration system.

```bash
serverpod create-repair-migration
```

Options: `--mode production`, `--version <migration-name>`, `--force`, `--tag`.

Apply: `dart run bin/main.dart --apply-repair-migration`. Repair runs before normal migrations.

## serverpod run

`serverpod run <script>` runs scripts declared in `pubspec.yaml` under `serverpod/scripts`.

## Workflow

1. **New project:** `serverpod create my_app` → start DB → run server with `--apply-migrations` → run Flutter app
2. **After endpoint/model changes:** `serverpod generate`
3. **After table/index changes:** `serverpod create-migration` → run server with `--apply-migrations`

Use `serverpod --help` and `serverpod <command> --help` for all flags.
