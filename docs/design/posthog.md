# Design: CLI lifecycle analytics (PostHog)

This document describes six rich analytics events for the Serverpod CLI. The goal is to understand how developers use Serverpod (project creation choices, code generation patterns, migration cadence, and dev-session setup) without collecting raw project identifiers, paths, or user-generated names.

Related: [GitHub issue #1274](https://github.com/serverpod/serverpod/issues/1274) (generate debouncing).

## Motivation

The CLI already sends a coarse event per invocation (command name plus masked flags). That tells us *which* commands run, but not *how* projects evolve: template choices, protocol complexity, migration frequency, or typical `start` configurations.

These six lifecycle events add structured, privacy-safe properties at meaningful command boundaries. They complement — and do not replace — the existing per-command events from `BetterCommandRunner`.

## Implementation status

**Implemented** in `tools/serverpod_cli/lib/src/analytics/`. PostHog dashboards (step 8) are still manual follow-up work.

- `PostHogAnalytics` and `MixPanelAnalytics` are wired in `tools/serverpod_cli/bin/serverpod_cli.dart` via `CompoundAnalytics`.
- `BetterCommandRunner` emits one event per invocation (command name, or `help` / `invalid`) with masked `full_command` and `flag_*` / `option_*` properties. Those coarse events continue to both backends unchanged.
- Opt-out is available globally via `--no-analytics`.
- User identity uses a UUID persisted at `~/.serverpod/uuid` (`ResourceManager.uniqueUserId`), sent as PostHog `distinct_id` for all events.
- `PostHogAnalytics` already attaches `$lib`, `$lib_version`, `platform`, `dart_version`, and `is_ci` to every event.
- Delivery is **best-effort**: events are flushed on exit but capped by PostHog's request timeout. A slow or offline connection drops a few events rather than delaying the CLI — acceptable for trend analytics.

## Architecture

```
Command handler (create / generate / …)
        │
        ▼
cliAnalytics.captureX(...)          ← no enabled flag; the singleton knows
        │  1. read/update <gitCommonDir>/serverpod/metadata.json
        │  2. build allowlisted payload (AnalyticsPayloadBuilder)
        │  3. analytics.track(...)   ← cli.* events only
        ▼
PostHogAnalytics

(BetterCommandRunner coarse events still go to CompoundAnalytics → PostHog + MixPanel)
```

### Backend split

| Event type | MixPanel | PostHog |
|---|---|---|
| Coarse command events (`generate`, `start`, `help`, …) | yes (unchanged) | yes (unchanged) |
| Rich lifecycle events (`cli.*`) | **no** | **yes** |

Implemented by holding a dedicated `PostHogAnalytics` reference for `CliAnalytics` (alongside the existing `CompoundAnalytics` used by `BetterCommandRunner`). `cli.*` events are **not** routed through `CompoundAnalytics`.

### What stays the same

- Keep `PostHogAnalytics` from `cli_tools`; do **not** add a second PostHog client or SDK.
- Keep the machine-level UUID (`~/.serverpod/uuid`) as PostHog `distinct_id`. Do **not** hash project paths into identity fields — paths must never leave the machine.
- Keep generic command events from `BetterCommandRunner.runCommand`. Rich events use the `cli.*` namespace to avoid collisions.

### Keeping commands clean

Analytics must stay out of command signatures. Two rules make that possible:

- **No `enabled` parameter.** `cliAnalytics` is a process-wide singleton that starts disabled (`CliAnalytics.disabled()`, a no-op sink) and is switched on exactly once, in `ServerpodCommandRunner.runCommand` — the first point at which `BetterCommandRunner` has resolved `--no-analytics`. Every capture method no-ops while disabled, so call sites never branch and helper functions never thread a flag through.
- **No `timing` parameter.** `analyzeAndGenerate` already knows whether a run is `incremental`; one-shot versus watch-mode reporting is derived from it rather than passed down.

Hooks are placed at the lowest shared layer that still has the data, so one hook covers every entry point:

| Hook | Covers |
|---|---|
| `analyzeAndGenerate` (`generate.dart`) | `serverpod generate`, `generate --watch`, and the internal generation inside `serverpod start` |
| `createMigrationAction` | `create-migration`, the start TUI's Migrate action, the `create_migration` MCP tool |
| `createRepairMigrationAction` | `create-repair-migration`, the start TUI's repair action, the `create_repair_migration` MCP tool |
| `performCreate` | `create` and `quickstart`, TUI and non-TUI paths alike |

The result is that no command file gains a parameter: `create.dart` and `quickstart.dart` add one named argument (`analyticsMethod`), `start.dart` adds one fire-and-forget call, and the migration commands are untouched.

### Vocabularies come from the code, not from copies

Every closed vocabulary that mirrors something the CLI already defines is **derived from that definition**, never re-typed:

| Vocabulary | Source |
|---|---|
| `template` | `ServerpodTemplateType.values` |
| `ides` | `TemplateIde.values` |
| `docker_mode` | `DockerStartMode.values` |
| `command_invocations` keys | the command runner's own `commands` map (gated on write), plus a kebab-case shape check on read |
| `index_<type>` feature tags | the index type as written in the model, which `validateIndexType` has already rejected if unsupported |

A hand-maintained copy silently stops matching the moment a template, IDE, command or index type is renamed — and a mismatch does not fail loudly, it drops the whole event in `capture`'s catch block. Deriving from the definition that already exists makes that failure mode impossible. `command_invocations_test.dart` asserts every registered command name matches the analytics pattern.

### New code

| Component | Location | Role |
|---|---|---|
| `CliAnalytics` | `…/analytics/cli_analytics.dart` | Metadata I/O, counter updates, PostHog dispatch for `cli.*` |
| `ProjectMetadata` | `…/analytics/project_metadata.dart` | JSON schema for the metadata file |
| `ProjectMetadataStore` | `…/analytics/project_metadata_store.dart` | Atomic read/write, `checkout_id` / date resolution |
| `AnalyticsPayloadBuilder` | `…/analytics/payload_builder.dart` | Runtime allowlist; strips or rejects unsafe strings |
| `ProtocolFeatureAnalyzer` | `…/analytics/protocol_feature_analyzer.dart` | Derives `features`, `feature_counts`, `counts`, and `serverpod_modules` |
| `ServerConfigFeatures` | `…/analytics/server_config_features.dart` | Capability tags read from `config/development.yaml` |
| `FlutterAppMetrics` | `…/analytics/session_metrics.dart` | Companion Flutter app shape for `cli.session_start` |
| `GenerateTracker` | `…/analytics/generate_tracker.dart` | In-memory debounce for watch-mode bursts |
| `MigrationMetrics` | `…/analytics/migration_metrics.dart` | Scans server and client `migrations/` directories |

### Project identity

Two anonymous identifiers, with distinct scopes:

| Id | Scope | Derivation |
|---|---|---|
| `project_id` | **Durable**, shared by every clone/checkout/CI of the same repo | `UUIDv5(Namespace.url, <normalized remote URL>)` |
| `checkout_id` | **Per clone**, shared across that clone's worktrees | Random UUID v4, persisted in metadata |

**`project_id` (durable).** Derived deterministically from the first git remote URL (prefer `origin`). The raw URL is **normalized then hashed with UUIDv5** — it is never stored or sent. Normalization makes SSH and HTTPS forms of the same repo collapse to one id: strip scheme, strip `user[:pass]@` credentials, rewrite `git@host:org/repo` → `host/org/repo`, lowercase, drop a trailing `.git` and trailing slashes. Sent to PostHog as the `project` group, so funnels aggregate one logical project across all developers without sending any URL or name.

**`checkout_id` (per clone).** Random v4 minted once per clone. Distinguishes individual working copies under the same `project_id` (e.g. each developer, each CI runner). Sent as a `checkout_id` property.

**Fallback (no git remote / not a repo):** `project_id` falls back to `checkout_id` (the random v4). A project with no remote is simply its own single anonymous unit.

### Local metadata file

Stored per clone, **centralized so all git worktrees of a clone share one file**:

- In a git checkout: `<gitCommonDir>/serverpod/metadata.json` (the shared `.git` common dir — resolved by reading `.git`/`commondir`, never spawning `git`). Worktrees resolve to the same common dir, so the leaves never each keep their own copy. This location is inherently never committed.
- Outside a repo: `<serverDir>/.dart_tool/serverpod/metadata.json` (gitignored, same tree as `generation.stamp`).

```json
{
  "checkout_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "project_created_at": "2026-05-20T14:32:00.000Z",
  "generate_call_count": 47,
  "command_invocations": {
    "generate": 47,
    "create-migration": 3,
    "create-repair-migration": 1,
    "start": 12
  }
}
```

| Field | Purpose |
|---|---|
| `checkout_id` | Random UUID v4, generated once per clone on first metadata write. Never derived from path, name, or repo identity. (`project_id` is *not* stored — it is recomputed from the remote each send.) |
| `project_created_at` | ISO-8601 UTC; see resolution rules below |
| `generate_call_count` | Monotonic counter for `cli.generate` |
| `command_invocations` | Per-command histogram for `cli.session_start` |

**Write rules:**

- Created on the first tracked command inside a project.
- Updated atomically (write temp file, rename) after each tracked command.
- Contains UUIDs, timestamps, and integers only — no paths, package names, or user-chosen identifiers.
- Counters are **best-effort**: in-process writes are serialized, but two concurrent CLI processes (or two monorepo packages sharing one common dir) are last-writer-wins and may undercount. Treat them as trend signal, not exact totals.
- `cli.project_created` stamps `project_created_at` but **preserves** an existing `checkout_id` and counters. The file is keyed by clone, not by project, so scaffolding a project inside an existing checkout (a monorepo, or `create --force`) must not reset the history already accumulated there.

`command_invocations` is incremented in `ServerpodCommandRunner.runCommand` for every executed subcommand that the runner has registered (including commands that do not emit rich events).

> **Watch mode:** `generate_call_count` increments once per *emitted* `cli.generate` event, so under watch-mode debouncing `num_generate_calls` counts coalesced events, not individual incremental runs.

#### `project_created_at` resolution

1. **Set explicitly** on successful `cli.project_created` (written to metadata when the scaffold finishes).
2. **Already in metadata** — use stored value.
3. **Fallback for older projects** — derive from the creation timestamp (`FileStat.changed`, UTC) of a stable scaffold file:
   - Primary: `<serverDir>/config/generator.yaml`
   - Fallback: `<serverDir>/pubspec.yaml` if generator config is missing

Do not use git history, `.dart_tool/` artifacts (regenerated), or migration directories (appear later). Once inferred, persist the value in metadata so later reads are stable.

## Privacy

`AnalyticsPayloadBuilder` enforces a runtime allowlist:

- **Allowed:** integers, doubles, booleans, enums (serialized by name), the anonymous UUIDs (`project_id`, `checkout_id`), and lists of canonical tag strings from fixed vocabularies (`features`, `serverpod_modules`, `ides`, `flutter_device_categories`).
- **Rejected:** free-form strings (class names, paths, package names, migration tags, device names beyond a coarse category), nested maps with dynamic keys, and any property not declared for an event.

Feature and module tags come from closed sets maintained in code. Raw `EndpointDefinition.name`, model class names, custom module nicknames, Flutter device ids, and migration directory names are never emitted.

The git **remote URL is never sent** — only its irreversible UUIDv5 derivative (`project_id`). The URL is read locally to compute the hash and immediately discarded. PostHog receives only allowlisted payloads. The `serverDir` argument to `CliAnalytics` is used locally for metadata lookup and must never appear in event properties.

`ServerConfigFeatures` reads `config/development.yaml` directly rather than through `ServerpodConfig.load`, which also loads `config/passwords.yaml`. Only the presence of a handful of sections is inspected; no value from either file is read into a payload.

## Shared event properties

Attached automatically by `PostHogAnalytics` — do **not** duplicate in event schemas below:

| Property | Source |
|---|---|
| `$lib` | `'serverpod_cli'` |
| `$lib_version` | CLI template version |
| `platform` | OS string |
| `dart_version` | `Platform.version` |
| `is_ci` | `ci.isCI` |

`CliAnalytics` additionally stamps every `cli.*` payload with:

| Property | Source |
|---|---|
| `schema_version` | `int` analytics schema version, **independent of the CLI version**. Bumped only when a `cli.*` event shape changes (property added/removed/retyped), so dashboards can distinguish "absent because old CLI" from "absent because removed". Currently `1`. |
| `checkout_id` | per-clone UUID (see [Project identity](#project-identity)) |

Rich events include `$groups: { "project": "<project_id>" }` (the durable remote-derived id) so project-scoped funnels work across checkouts without sending directory paths or URLs.

---

## 1. `cli.project_created`

**When:** After a successful project scaffold — all files written, before success logs / start instructions.

**Do not emit** on dry-run (`performCreate(dryRun: true)`) or failed creates.

| Property | Type | Source |
|---|---|---|
| `method` | `String` | `"create"` or `"quickstart"` |
| `template` | `String` | `ServerpodTemplateType.name`: `fullstack`, `server`, or `module` |
| `with_flutter` | `bool` | `TemplateContext.flutterApp` |
| `with_docker` | `bool` | `TemplateContext.docker` (`postgres \|\| redis`) |
| `with_auth` | `bool` | `TemplateContext.auth && postgres` |
| `with_database` | `bool` | `TemplateContext.database` |
| `database_dialect` | `String` | `postgres`, `sqlite`, or `none` |
| `with_redis` | `bool` | `TemplateContext.redis` |
| `with_website` | `bool` | `TemplateContext.website` |
| `with_webapp` | `bool` | `TemplateContext.webapp` |
| `ides` | `List<String>` | configured `TemplateIde` names |
| `force` | `bool` | `--force` flag |

`database_dialect`, `with_redis`, `with_website`, `with_webapp` and `ides` exist because `serverpod create` now exposes these as flags for non-interactive creation; a single `with_database` boolean loses which dialect and which optional services a project opted into.

**Side effect:** write `project_created_at` (`DateTime.now().toUtc()`) to `metadata.json`, preserving any existing `checkout_id` and counters.

**Hook point:** the success exit of `performCreate`, which both `CreateCommand` and `QuickstartCommand` share (TUI and non-TUI). Callers opt in by passing `analyticsMethod`.

---

## 2. `cli.generate`

**When:** After a generation attempt completes (success or failure). One-shot: once per CLI process. Watch mode: debounced (see below).

Also emitted from internal generation inside `serverpod start --watch` (via shared `analyzeAndGenerate`), not only from the standalone `generate` command.

| Property | Type | Source |
|---|---|---|
| `features` | `List<String>` | `ProtocolFeatureAnalyzer` — protocol/config capability tags |
| `feature_counts` | `Map<String, int>` | How many times each countable tag in `features` occurs |
| `serverpod_modules` | `List<String>` | Official Serverpod modules detected in the project (see below) |
| `counts` | `Map<String, int>` | See counts table |
| `num_generate_calls` | `int` | `metadata.json` → `generate_call_count` (incremented before send) |
| `project_age_days` | `int` | days since resolved `project_created_at` |
| `is_watch_mode` | `bool` | `generate --watch`, or implicit watch inside `start --watch` |
| `generation_succeeded` | `bool` | pipeline result |
| `oneshot_duration_ms` | `int?` | wall time for a one-shot run (`is_watch_mode == false`); omit otherwise |
| `incremental_avg_duration_ms` | `int?` | mean wall time per incremental run in a watch burst (`is_watch_mode == true`); omit otherwise |
| `incremental_run_count` | `int?` | number of incremental runs coalesced into this event (watch mode only); omit otherwise |

`GenerateResult` carries the run's `ProtocolDefinition` so the hook can snapshot it without re-analyzing. It is `null` for models-only incremental runs, which report nothing.

### `serverpod_modules`

Lists which **official Serverpod modules** are present, matching `ModuleConfig.name` (the server package name minus `_server`) against a fixed allowlist: `serverpod_auth`, `serverpod_auth_bridge`, `serverpod_auth_core`, `serverpod_auth_idp`, `serverpod_auth_migration`, `serverpod_chat`.

Custom or third-party modules are counted in `counts.module_count` but omitted from `serverpod_modules`.

### `counts` keys

| Key | Source |
|---|---|
| `model_count` | model classes (excludes enums and exceptions, which have their own key) |
| `table_model_count` | of those, how many are table-backed |
| `shared_model_count` | of those, how many come from a shared package |
| `shared_table_model_count` | shared models that are also table-backed |
| `endpoint_count` | non-abstract endpoints in `protocolDefinition.endpoints` |
| `endpoint_method_count` | methods across those endpoints |
| `enum_count` | models that are enum definitions |
| `exception_count` | models that are exception definitions |
| `relation_count` | model fields with a `RelationDefinition` |
| `index_count` | parsed indexes, including indexes created by `unique` and `unique(per=…)` |
| `future_call_count` | `protocolDefinition.futureCalls.length` |
| `module_count` | `GeneratorConfig.modulesDependent.length` (all modules, including custom) |

`counts` answers "how big is this project"; `feature_counts` answers "how heavily is each feature used". A project with one sealed model and one built entirely on sealed hierarchies both report `sealed_model` in `features`, so presence alone cannot distinguish a trial from a commitment.

### `ProtocolFeatureAnalyzer`

Input: `ProtocolDefinition`, `GeneratorConfig`, and the server's `config/development.yaml`.

Output: sorted list of canonical capability tags from a closed vocabulary:

| Group | Tags |
|---|---|
| Database / server config | `postgres`, `sqlite`, `postgres_embedded`, `redis`, `web_server`, `insights_server`, `future_calls_disabled` |
| Endpoints | `future_call`, `streaming_endpoint`, `endpoint_inheritance` |
| Models | `sealed_model`, `model_inheritance`, `immutable_model`, `server_only_model`, `shared_model`, `shared_table_model`, `table_model`, `client_database`, `unmanaged_migration` |
| Exceptions | `exception_model`, `sealed_exception`, `exception_inheritance` |
| Enums | `enhanced_enum` |
| Fields | `server_only_field`, `tail_field`, `vector_field`, `geography_field` |
| Relations | `list_relation`, `object_relation`, `foreign_relation` |
| Indexes | `unique_field`, `unique_index`, `unique_per_index`, `index_<type>` |

Exception tags are separate from the model ones: `sealed`/`extends` became available on exceptions later than on models, so merging them would hide which of the two is actually being adopted.

Configuration tags are presence-only and never appear in `feature_counts`; everything derived from models, endpoints and fields is counted.

`unique_field` identifies the one-column `unique` field shorthand from its
generated btree index shape and automatic index name. `unique_index` counts all
unique indexes, including explicit indexes and both unique shorthands.

No endpoint, model, or module **names** appear in `features` — only capability tags.

`postgres_embedded` is detected from a `database:` section with a `dataPath:` in `config/development.yaml`, which is the same signal `serverpod start` uses to decide whether to autostart Docker. It is deliberately *not* inferred from a `serverpod_embedded_postgres` pubspec dependency, which the templates add unconditionally and which therefore says nothing about whether a project actually runs an embedded database.

### Watch-mode debounce

`GenerateTracker` keeps an in-memory burst per absolute server directory.

On each filesystem-triggered generation (`generate --watch`, or `start --watch` → `analyzeAndGenerate`):

1. Increment pending call count and merge the latest feature / module snapshot.
2. Reset a timer (default **30 s**, configurable constant).
3. When the timer fires, emit one `cli.generate` with accumulated metadata updates, latest `features` / `serverpod_modules` / `counts`, `incremental_run_count`, and `incremental_avg_duration_ms` (sum of per-run durations in the burst ÷ run count). The burst is reset *before* the send so runs arriving mid-flight start a fresh burst rather than being double counted.

Any burst still pending is flushed from `_preExit`. Watch sessions are almost always ended mid-burst, so without that the last — and usually longest — run of every session would be lost.

One-shot `serverpod generate` bypasses debounce: it emits immediately with `oneshot_duration_ms` set to the run's wall time. The two duration properties are mutually exclusive so PostHog aggregates stay comparable within each mode.

---

## 3. `cli.migration_created`

**When:** A new migration is written to disk.

**Do not emit** for `CreateMigrationNoChanges`, `CreateMigrationAborted`, or failed runs.

| Property | Type | Source |
|---|---|---|
| `server_migration_created` | `bool` | `true` when a server-side migration directory was written in this command |
| `client_migration_created` | `bool` | `true` when a client-side migration artifact was written in this command |
| `server_migration_count` | `int` | subdirectories under `<serverDir>/migrations/` after write |
| `client_migration_count` | `int` | subdirectories under `<clientDir>/lib/migrations/` after write |
| `days_since_first_migration` | `int` | days from earliest **server** migration version timestamp |
| `average_interval_days` | `double?` | `(days_since_first) / (server_migration_count - 1)` when `server_migration_count >= 2`, else omit |
| `is_repair_migration` | `bool` | `true` for repair migrations, else `false` |

At least one of `server_migration_created` / `client_migration_created` is `true` on every emitted event. `createMigrationAction` only returns a bare `CreateMigrationCreated` when the project has no client-side tables, so an unwrapped outcome is always the server side; the client side only ever appears inside a `CreateMigrationServerClientCreated`.

Migration version timestamps are parsed from directory names (Serverpod's `YYYYMMDDHHMMSS…` prefix). Server counts scan `<serverDir>/migrations/`; client counts scan `<clientDir>/lib/migrations/` (via `GeneratorConfig.clientPackagePathParts`). No migration names, tags, or SQL content are sent.

**Hook points:** inside `createMigrationAction` and `createRepairMigrationAction`. Hooking the shared actions rather than the commands is what makes the start TUI's Migrate action and the `create_migration` / `create_repair_migration` MCP tools count too — an increasingly large share of migrations now that `serverpod start` is the default flow and agents drive the MCP tools.

---

## 4. `cli.session_start`

**When:** At the beginning of a dev session, after `GeneratorConfig` is loaded and start options are known — before spawning server / Flutter / Docker.

Covers `serverpod start` (including `--watch` / `--no-watch`). Does **not** cover arbitrary `serverpod run <script>` scripts unless they invoke the start command internally.

| Property | Type | Source |
|---|---|---|
| `watch_mode` | `bool` | `StartOption.watch` (default `true`) |
| `tui_enabled` | `bool` | `StartOption.tui` and an attached terminal |
| `flutter_enabled` | `bool` | `StartOption.flutter` |
| `flutter_app_count` | `int` | companion apps under `serverpod: flutter_apps:` |
| `flutter_auto_launch_count` | `int` | of those, how many set `auto_launch: true` |
| `flutter_device_categories` | `List<String>` | coarse buckets across the configured apps: `web`, `mobile`, `desktop`, `headless`, `default`, `other` |
| `flutter_device_platforms` | `List<String>` | canonical targets: `ios`, `ipad`, `android`, `macos`, `windows`, `linux`, `chrome`, `edge`, `web-server`, `default`, `other` |
| `docker_mode` | `String` | `on`, `off`, or `auto` |
| `docker_compose_present` | `bool` | any Compose file name `start` itself resolves exists in the server dir |
| `num_tool_calls` | `int` | sum of `command_invocations` values in metadata |
| `command_invocations` | `Map<String, int>` | copy of metadata histogram |

`--flutter-*` flags were removed; companion apps are now configured in the server pubspec and a project can declare several. A single `flutter_device_category` no longer describes a session, so the event reports the shape of the configuration instead.

The category alone cannot answer "which targets do people build for" — `mobile` covers both iOS and Android. `flutter_device_platforms` carries that split. Both are buckets: the raw `device:` id is user-controlled and never sent.

This event reports what a project **configures**. What it **runs** is [`cli.flutter_launch`](#5-cliflutter_launch): a target declared once in a pubspec and never launched must not weigh as much as one started every session.

`docker_mode` is a tri-state because `StartOption.docker` has no default: unset means `start` decides from the project setup. Reading it with `Configuration.value` throws `StateError`, which — inside the event's catch block — silently drops every session event.

Do **not** spawn a `docker compose ps` probe just for analytics — it adds a subprocess to every `serverpod start`. Whether Compose services were already running is inferable from `docker_mode` + `docker_compose_present` plus the existing startup logs, so it is intentionally omitted.

Do **not** probe `localhost:8090` — that port is the default Flutter **web** port, not Redis or Postgres.

Session duration is derived in PostHog from event timestamps. Do not send a separate start-time property.

**Hook point:** `StartCommand.runWithConfig` after config load, before `_runWithTui` / watch session setup (`start.dart`), fired unawaited so it never delays startup.

---

## 5. `cli.flutter_launch`

**When:** A companion Flutter app process actually starts, from `FlutterAppManager.launch`.

Covers auto-launch at session start, on-demand launches from the start TUI, the `spawn_flutter_app` MCP tool, and relaunches — they all go through that one method. Development run mode only.

| Property | Type | Source |
|---|---|---|
| `device_category` | `String` | same buckets as `flutter_device_categories` |
| `device_platform` | `String` | same buckets as `flutter_device_platforms` |
| `is_relaunch` | `bool` | `true` when replacing a running instance rather than starting cold |

Pairing this with `cli.session_start` separates intent from use: `session_start` gives configured targets per project, `flutter_launch` gives actual launches per target.

---

## 6. `cli.project_upgraded`

**When:** `serverpod create .` is run inside an existing project, which upgrades it in place rather than scaffolding a new one (`_performUpgrade`).

| Property | Type | Source |
|---|---|---|
| `template` … `ides` | | the same block as `cli.project_created` |
| `created_default_migration` | `bool` | whether the upgrade also generated a default migration |
| `project_age_days` | `int?` | days since `project_created_at`; omitted when metadata is unavailable |

A separate event rather than a `method` value on `cli.project_created`, because that event stamps `project_created_at`. Reusing it would reset the project's age on every upgrade and destroy the very signal that makes this one interesting — how old the projects being upgraded are.

**Hook point:** the success exit of `_performUpgrade`, gated on the caller having passed `analyticsMethod` so programmatic and dry-run uses stay silent.

---

## Known gaps

- **Monorepos share one metadata file.** The file is keyed by git common dir so worktrees converge, which means several Serverpod packages in one repo share `checkout_id`, `generate_call_count`, and `command_invocations`. Per-project counters would need a per-package key, at the cost of worktrees each keeping their own copy.
- **Fast commands may not record their invocation.** `recordCommandInvocation` is fired unawaited, so a command that exits immediately (`version`) can exit before the metadata write lands. Counters are trend signal, not exact totals.
- **Models-only incremental runs are not counted.** They carry no `ProtocolDefinition`, so `incremental_run_count` slightly undercounts bursts made up purely of model edits.
- **MCP tools are only tracked where they share a hook.** The migration tools are covered because the hook sits in the shared action, and `spawn_flutter_app` is covered by `cli.flutter_launch`. The remaining tools (`tail_flutter_logs`, `get_flutter_app_dtd`, …) are not — that would need a per-tool event.

## Testing

Feature detection is tested **through the real commands**, not against hand-built
definitions. A snapshot assembled from builders only proves the analyzer agrees
with the test's own idea of a protocol; running the real pipeline proves it
agrees with what the model parser actually produces — and catches the wiring
between them.

Integration (real command, real project on disk):

- `integration/analytics/generate_feature_analytics_test.dart` — writes a project that exercises every protocol/config tag except SQLite and future calls, then runs `performOneShotGenerate` and asserts the emitted payload, occurrence counts, project totals, and privacy boundary.
- `integration/analytics/generate_future_call_analytics_test.dart` — runs real generation over a Dart future call and asserts its tag and count.
- `integration/analytics/generate_sqlite_analytics_test.dart` — runs real generation with the SQLite dialect and asserts the database tag.
- `integration/analytics/generate_staleness_analytics_test.dart` — asserts that a staleness skip sends no second event.
- `integration/analytics/migration_analytics_test.dart` — runs `createMigrationAction` against real projects for the server-only, server+client, and no-changes cases. Because the hook lives in the action, this covers the CLI command, the start TUI's Migrate action and the `create_migration` MCP tool at once.

Unit (no generated data to drive):

- `payload_builder_test.dart` — allowlist enforcement: rejects raw strings, accepts pattern-checked index tags.
- `project_metadata_store_test.dart` — metadata round-trip, date fallback from `config/generator.yaml` stat, and that scaffolding inside an existing checkout preserves its counters.
- `project_identity_test.dart` — remote URL normalization, worktree common-dir resolution, durable id stability.
- `module_allowlist_test.dart` — official-module naming; pure config mapping.
- `command_invocations_test.dart` — every registered command name matches the analytics command pattern.
- `generate_tracker_test.dart` — timer coalescing and burst reset between flushes.
- `migration_metrics_test.dart` — outcome-to-flag mapping.
- `project_analytics_test.dart` — project creation/upgrade payload shapes, that an upgrade does not restamp the project age, and the disabled project-event path.
- `session_analytics_test.dart` — session/launch payload shapes, command invocation counts, and the disabled session-event path.
- `session_metrics_test.dart` — every Flutter device category and platform tag.

`performCreate` is not integration-tested: it shells out to `pub get`, `flutter
create` and a nested generate, so a real run needs Flutter plus network access
and takes minutes. Its payload shape is covered by unit tests instead.
