---
name: serverpod-overview
description: Serverpod overview — what it is, project structure, installation, creating and running a project. Use when the user asks about Serverpod in general, project setup, installation, serverpod create, or running a Serverpod server.
---

# Serverpod Overview

Serverpod is an open-source backend framework for Flutter written in Dart. A Serverpod project consists of three packages: a server, a generated client, and a Flutter app. The server exposes typed endpoints that the client calls via RPC. Models are defined in YAML and generate Dart classes for both server and client. The server uses PostgreSQL for persistence and includes an ORM, caching, real-time streaming, file uploads, scheduling, logging, and a built-in web server (Relic).

## Prerequisites

- **Flutter** installed (`flutter doctor`)
- **Docker** (for local PostgreSQL via project's `docker-compose.yaml`)

## Installation

```bash
dart pub global activate serverpod_cli
serverpod  # verify
```

## Creating a project

```bash
serverpod create my_project
```

Project name must be lowercase with underscores (valid Dart package name). Creates:

- `my_project_server/` — server code
- `my_project_client/` — generated client (do not edit)
- `my_project_flutter/` — Flutter app

Then fetch dependencies: `dart pub get` from project root.

## Project structure

```directory
my_project/
├── my_project_server/
│   ├── lib/                # Endpoints, models, business logic
│   ├── config/             # development.yaml, production.yaml, passwords.yaml
│   ├── bin/main.dart       # Entry point
│   └── docker-compose.yaml # Local PostgreSQL
├── my_project_client/      # Generated client (do not edit)
└── my_project_flutter/     # Flutter app
```

Run `serverpod generate` after adding or changing endpoints or models.

## Running the project

1. **Start the database:** From the server directory: `docker compose up` (detached: `-d`; stop: `docker compose down`).
2. **Start the server:** `cd my_project_server && dart run bin/main.dart --apply-migrations`. Subsequent runs (no schema changes): `dart run bin/main.dart`. API: `http://localhost:8080`, web server: `http://localhost:8082`.
3. **Run the Flutter app:** `cd my_project_flutter && flutter run -d chrome`. For Android emulator, the app uses `10.0.2.2`; for a device on the network, set `publicHost` in `config/development.yaml` to the machine's IP.

## Serverpod Mini

Lightweight setup without PostgreSQL: `serverpod create myminipod --mini`. Includes remote method calls, models, streaming, logging, and caching — no database ORM, scheduling, Insights, file uploads, health checks, or Relic web server. Start with `dart run bin/main.dart` (no Docker). Upgrade to full Serverpod later with `serverpod create .` from the server directory.
