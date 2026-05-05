---
name: serverpod-create
description: Serverpod Create — Create Serverpod projects and modules. Use when creating new projects/modules, or upgrading mini projects to full Serverpod.
---

# Serverpod Create

Creating Serverpod projects and modules is done with the `serverpod create` command.

## Prerequisites

- **Dart** installed (`dart --version` should be 3.10.3+).
- **Flutter** installed (`flutter --version` should be 3.38.4+).
- **Docker** installed (`docker --version`).
- **Serverpod CLI** installed (`dart install serverpod_cli`).

## Using the `serverpod create` command

When invoked by the user, the `serverpod create` command will present options on a TUI to tweak the resources of the project/module. For programmatic usage, the command can be invoked with the `--no-interactive` flag.

```bash
serverpod create <project_name> --no-interactive            # Full project (server, client, Flutter)
serverpod create --mini <project_name> --no-interactive     # Minimal project without database
serverpod create --template module <name> --no-interactive  # Module (server + client)
```

Project name must be lowercase with underscores (valid Dart package name).

After creating the project, fetch dependencies: `dart pub get` from project root (workspace).

If creating a Serverpod module, refer to the [Serverpod Modules](../serverpod-modules/SKILL.md) skill for more details.

## Project structure

Considering a project named `my_project`, the structure will be:

```directory
my_project/
├── my_project_server/
│   ├── lib/                # Endpoints, models, business logic
│   ├── src/generated/      # Generated code (do not edit)
│   ├── config/             # development.yaml, production.yaml, passwords.yaml
│   ├── bin/main.dart       # Entry point
│   └── docker-compose.yaml # Local PostgreSQL and Redis (if enabled)
├── my_project_client/      # Generated client
│   ├── src/protocol/       # Generated protocol (do not edit)
└── my_project_flutter/     # Flutter app (only for projects, not modules)
```

NEVER edit the generated code, as it will be overwritten by the next generation.

## Upgrading a mini server directory to full Serverpod

Any project created with the `--mini` flag can be upgraded to a full Serverpod project by running `serverpod create .` with the default/server template (without the `--mini` flag). Always ensure that the working tree is clean before upgrading.
