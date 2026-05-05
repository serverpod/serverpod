---
name: serverpod-cli
description: Serverpod CLI — serverpod create, generate, and other commands. Use when generating code, or creating projects/modules.
---

# Serverpod CLI

Install: `dart install serverpod_cli`.
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

For migration commands, refer to the [migration workflow](../serverpod-migrations/SKILL.md).

## serverpod run

`serverpod run <script>` runs scripts declared in `pubspec.yaml` under `serverpod/scripts`.

## Workflow

1. **New project:** `serverpod create my_app` → `serverpod start` → run Flutter app.
2. **After endpoint/model changes:** With **`serverpod start`**, generation/reload is automatic; otherwise run `serverpod generate`.
3. **After table/index changes:** follow the [migration workflow](../serverpod-migrations/SKILL.md).

Use `serverpod --help` and `serverpod <command> --help` for all flags.
