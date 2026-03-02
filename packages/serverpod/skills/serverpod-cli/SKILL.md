---
name: serverpod-cli
description: Serverpod CLI — serverpod create, generate, create-migration, and other commands. Use when generating code, creating migrations, or creating projects/modules.
---

# Serverpod CLI

Install: `dart pub global activate serverpod_cli`.
Run: from project root or server package directory.

## serverpod create

```bash
serverpod create <project_name>          # Full project (server, client, Flutter)
serverpod create --template module <name> # Module (server + client)
```

Project name: valid Dart package name (lowercase, underscores).

## serverpod generate

Regenerate client and server code from endpoints and `.spy.yaml` models.

```bash
serverpod generate
```

Run after adding or changing endpoints or models. Do not edit generated files.

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

## Workflow

1. **New project:** `serverpod create my_app` → start DB → run server with `--apply-migrations` → run Flutter app
2. **After endpoint/model changes:** `serverpod generate`
3. **After table/index changes:** `serverpod create-migration` → run server with `--apply-migrations`

Use `serverpod --help` and `serverpod <command> --help` for all flags. In workspace/melos setups, run `serverpod generate` from root or with `-d` pointing to the server package.
