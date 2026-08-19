---
name: serverpod-cloud
description: Deploy a Serverpod project to Serverpod Cloud with the `scloud` CLI — first deploy, redeploys, deployment status, production logs. Use when the user wants to deploy or host their server, or to check a deployment. For local config files and run modes, use serverpod-configuration.
---

# Serverpod Cloud

Serverpod Cloud hosts Serverpod servers, driven by the `scloud` CLI. A `scloud.yaml` file in the server package directory links the local project to the Cloud project; commands find it automatically.

Deploying is outward-facing and can cost the user money: always confirm before running `scloud launch` or `scloud deploy`.

## Before the first deploy

The user runs these; do NOT run them yourself, since `scloud` installs software and the login opens a browser:

```bash
dart install serverpod_cloud_cli   # provides the `scloud` command
scloud auth login
```

`scloud` refuses to run when a newer version exists, so a command that only prints an update notice means the CLI has to be reinstalled with the same command.

## First deploy

`scloud launch` creates the Cloud project and ships its first version. It is interactive — project id, plan (`starter` or `growth`), whether to enable the managed database, and which pre-deploy hooks to add — so ask the user to run it and to report the project id it settles on.

Once the project exists, later deploys are:

```bash
scloud deploy
scloud deployment show        # follow the running deployment
scloud deployment build-log   # build output, when a deploy fails to build
```

A deploy goes Upload → Cloud build → Infra deploy → Service rollout, and traffic switches only on success, so a failed deploy leaves the previous version serving. The server is then reachable at `https://<project-id>.serverpod.space/` (web), `.api.` (API) and `.insights.` (Insights).

## What changes compared to running locally

- **The database is managed.** Cloud injects `SERVERPOD_DATABASE_*` and `SERVERPOD_PASSWORD_database` into the server. Never put Cloud credentials into `config/production.yaml` or `passwords.yaml`.
- **Migrations apply on every deploy.** The container starts with `--apply-migrations`. A migration that fails to apply fails the deploy; fix it and deploy again. See [Serverpod Migrations](../serverpod-migrations/SKILL.md).
- **Secrets are set through the CLI**, not committed: `scloud password set <name> <value>` for values read with `session.serverpod.getPassword('<name>')`, `scloud secret set <NAME> <value>` for values a dependency reads from `Platform.environment`.
- **Code generation runs as a pre-deploy hook.** `scloud launch` offers to add `serverpod generate` (and a Flutter web build) to `scloud.yaml` under `project.scripts.pre_deploy`.
- **Logs come from the CLI**: `scloud log`, `scloud log --tail`, `scloud log --since 1h`.

## Going further

`scloud help` lists every command, and each one takes `--help`. Custom domains, database backups and users, CI deploys with an access token, and `.scloudignore` are documented at https://docs.serverpod.dev/cloud.

Never run `scloud project delete`, `scloud db wipe` or `scloud db backup restore` unless the user explicitly asks for that specific operation.
