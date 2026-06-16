# Design: CLI lifecycle analytics (PostHog)

This document describes four rich analytics events for the Serverpod CLI. The goal is to understand how developers use Serverpod (project creation choices, code generation patterns, migration cadence, and dev-session setup) without collecting project identifiers, paths, or user-generated names.

Related: [GitHub issue #1274](https://github.com/serverpod/serverpod/issues/1274) (generate debouncing).

## Motivation

The CLI already sends a coarse event per invocation (command name plus masked flags). That tells us *which* commands run, but not *how* projects evolve: template choices, protocol complexity, migration frequency, or typical `start` configurations.

These four lifecycle events add structured, privacy-safe properties at meaningful command boundaries. They complement — and do not replace — the existing per-command events from `BetterCommandRunner`.

## Implementation status

**Implemented** in `tools/serverpod_cli/lib/src/analytics/`. PostHog dashboards (step 8) are still manual follow-up work.

- `PostHogAnalytics` and `MixPanelAnalytics` are wired in `tools/serverpod_cli/bin/serverpod_cli.dart` via `CompoundAnalytics`.
- `BetterCommandRunner` emits one event per invocation (command name, or `help` / `invalid`) with masked `full_command` and `flag_*` / `option_*` properties. Those coarse events continue to both backends unchanged.
- Opt-out is available globally via `--no-analytics`.
- User identity uses a UUID persisted at `~/.serverpod/uuid` (`ResourceManager.uniqueUserId`), sent as PostHog `distinct_id` for all events.
- `PostHogAnalytics` already attaches `$lib`, `$lib_version`, `platform`, `dart_version`, and `is_ci` to every event.

## Architecture

```
Command handler (create / generate / …)
        │
        ▼
CliAnalytics.capture(event, serverDir, properties)
        │  1. read/update .dart_tool/serverpod/metadata.json
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

Implement by holding a dedicated `PostHogAnalytics` reference for `CliAnalytics` (alongside the existing `CompoundAnalytics` used by `BetterCommandRunner`). Do **not** route `cli.*` events through `CompoundAnalytics`.

### What stays the same

- Keep `PostHogAnalytics` from `cli_tools`; do **not** add a second PostHog client or SDK.
- Keep the machine-level UUID (`~/.serverpod/uuid`) as PostHog `distinct_id`. Do **not** hash project paths into identity fields — paths must never leave the machine.
- Keep generic command events from `BetterCommandRunner.runCommand`. Rich events use the `cli.*` namespace to avoid collisions.

### New code (proposed)

| Component | Location (proposed) | Role |
|---|---|---|
| `CliAnalytics` | `tools/serverpod_cli/lib/src/analytics/cli_analytics.dart` | Metadata I/O, counter updates, PostHog dispatch for `cli.*` |
| `ProjectMetadata` | `…/analytics/project_metadata.dart` | JSON schema for `.dart_tool/serverpod/metadata.json` |
| `ProjectMetadataStore` | `…/analytics/project_metadata_store.dart` | Atomic read/write, `project_id` / date resolution |
| `AnalyticsPayloadBuilder` | `…/analytics/payload_builder.dart` | Runtime allowlist; strips or rejects unsafe strings |
| `ProtocolFeatureAnalyzer` | `…/analytics/protocol_feature_analyzer.dart` | Derives `features`, `counts`, and `serverpod_modules` |
| `GenerateTracker` | `…/analytics/generate_tracker.dart` | In-memory debounce for watch-mode bursts |
| `MigrationMetrics` | `…/analytics/migration_metrics.dart` | Scans server `migrations/` directory |

Rich events are gated by `serverpodRunner.analyticsEnabled()` (`--no-analytics`).

### Local metadata file

Path: `<serverDir>/.dart_tool/serverpod/metadata.json` (same directory tree as `generation.stamp` and MCP sockets).

```json
{
  "project_id": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
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
| `project_id` | Random UUID v4, generated once per project on first metadata write. Used locally and sent to PostHog as an anonymous project correlation key (`$groups.project` or equivalent). Never derived from path, name, or repo identity. |
| `project_created_at` | ISO-8601 UTC; see resolution rules below |
| `generate_call_count` | Monotonic counter for `cli.generate` |
| `command_invocations` | Per-command histogram for `cli.session_start` |

**Write rules:**

- Created on the first tracked command inside a project.
- Updated atomically (write temp file, rename) after each tracked command.
- Contains UUIDs, timestamps, and integers only — no paths, package names, or user-chosen identifiers.

`command_invocations` is incremented in `ServerpodCommandRunner.runCommand` for every executed subcommand (including commands that do not emit rich events).

#### `project_created_at` resolution

1. **Set explicitly** on successful `cli.project_created` (written to metadata when the scaffold finishes).
2. **Already in metadata** — use stored value.
3. **Fallback for older projects** — derive from the creation timestamp (`FileStat.changed`, UTC) of a stable scaffold file:
   - Primary: `<serverDir>/config/generator.yaml`
   - Fallback: `<serverDir>/pubspec.yaml` if generator config is missing

Do not use git history, `.dart_tool/` artifacts (regenerated), or migration directories (appear later). Once inferred, persist the value in metadata so later reads are stable.

## Privacy

`AnalyticsPayloadBuilder` enforces a runtime allowlist:

- **Allowed:** integers, doubles, booleans, enums (serialized by name), UUIDs from metadata (`project_id`), and lists of canonical tag strings from fixed vocabularies (`features`, `serverpod_modules`).
- **Rejected:** free-form strings (class names, paths, package names, migration tags, device names beyond a coarse category), nested maps with dynamic keys, and any property not declared for an event.

Feature and module tags must come from closed sets maintained in code. Never emit raw `EndpointDefinition.name`, model class names, custom module nicknames, or migration directory names.

PostHog receives only allowlisted payloads. The `serverDir` argument to `CliAnalytics` is used locally for metadata lookup and must never appear in event properties.

## Shared event properties

Attached automatically by `PostHogAnalytics` — do **not** duplicate in event schemas below:

| Property | Source |
|---|---|
| `$lib` | `'serverpod_cli'` |
| `$lib_version` | CLI template version |
| `platform` | OS string |
| `dart_version` | `Platform.version` |
| `is_ci` | `ci.isCI` |

Rich events should include `$groups: { "project": "<project_id>" }` (or PostHog's current group syntax) so project-scoped funnels work without sending directory paths.

---

## 1. `cli.project_created`

**When:** After a successful project scaffold — all files written, before success logs / start instructions.

**Do not emit** on dry-run (`performCreate(dryRun: true)`) or failed creates.

| Property | Type | Source |
|---|---|---|
| `method` | `String` | `"create"` or `"quickstart"` |
| `template` | `String` | `ServerpodTemplateType.name`: `mini`, `server`, or `module` |
| `with_flutter` | `bool` | `true` only for `server` template (see `_createProjectDirectories`) |
| `with_docker` | `bool` | `TemplateContext.docker` (`postgres \|\| redis`) |
| `with_auth` | `bool` | `TemplateContext.auth && postgres` |
| `with_database` | `bool` | `TemplateContext.database` |
| `force` | `bool` | `--force` flag |

**Side effect:** write `project_id` (if new) and `project_created_at` (`DateTime.now().toUtc()`) to `metadata.json` in the new project's server directory.

**Hook points:**

- `CreateCommand`: after `performCreate` returns a non-null path (both TUI and non-TUI paths).
- `QuickstartCommand`: after `performCreate` returns a non-null path.

Centralize in `performCreate` success exit so all paths share one call.

---

## 2. `cli.generate`

**When:** After a generation attempt completes (success or failure). One-shot: once per CLI process. Watch mode: debounced (see below).

Also emitted from internal generation inside `serverpod start --watch` (via shared `analyzeAndGenerate`), not only from the standalone `generate` command.

| Property | Type | Source |
|---|---|---|
| `features` | `List<String>` | `ProtocolFeatureAnalyzer` — protocol/config capability tags |
| `serverpod_modules` | `List<String>` | Official Serverpod modules detected in the project (see below) |
| `counts` | `Map<String, int>` | See counts table |
| `num_generate_calls` | `int` | `metadata.json` → `generate_call_count` (incremented before send) |
| `project_age_days` | `int` | days since resolved `project_created_at` |
| `is_watch_mode` | `bool` | `generate --watch`, or implicit watch inside `start --watch` |
| `generation_succeeded` | `bool` | pipeline result |
| `oneshot_duration_ms` | `int?` | wall time for a one-shot run (`is_watch_mode == false`); omit otherwise |
| `incremental_avg_duration_ms` | `int?` | mean wall time per incremental run in a watch burst (`is_watch_mode == true`); omit otherwise |
| `incremental_run_count` | `int?` | number of incremental runs coalesced into this event (watch mode only); omit otherwise |

### `serverpod_modules`

List which **official Serverpod modules** are present, using canonical identifiers from a fixed allowlist maintained in code (e.g. `serverpod_auth`, `serverpod_auth_core`, `serverpod_auth_idp`, `serverpod_chat`).

Detection sources (union):

- Entries under `modules:` in `config/generator.yaml` (match by module `name` against allowlist).
- Transitive `*_server` / `serverpod` dependencies from `GeneratorConfig.modules` / `loadModuleConfigs`.

Emit only allowlisted module ids. Custom or third-party modules are counted in `counts.module_count` but omitted from `serverpod_modules`.

### `counts` keys

| Key | Source |
|---|---|
| `model_count` | `protocolDefinition.models.length` |
| `endpoint_count` | non-abstract endpoints in `protocolDefinition.endpoints` |
| `enum_count` | models that are enum definitions |
| `relation_count` | model fields with a `RelationDefinition` |
| `future_call_count` | `protocolDefinition.futureCalls.length` |
| `module_count` | `GeneratorConfig.modulesDependent.length` (all modules, including custom) |

### `ProtocolFeatureAnalyzer`

Input: `ProtocolDefinition`, `GeneratorConfig`, and enabled `ServerpodFeature` / experimental flags.

Output: sorted list of canonical capability tags, e.g.:

- Config: `postgres`, `postgres_embedded`, `sqlite`, `redis`, `future_calls` (feature flag), …
- Protocol: `streaming_endpoint`, `login_required_endpoint`, `sealed_model`, `list_relation`, `object_relation`, …

No endpoint, model, or module **names** in `features` — only capability tags from a fixed vocabulary (separate from `serverpod_modules`).

### Watch-mode debounce

Maintain an in-memory `GenerateTracker` keyed by absolute server directory path.

On each filesystem-triggered generation (`generate --watch`, or `start --watch` → `analyzeAndGenerate`):

1. Increment pending call count and merge the latest feature / module snapshot.
2. Reset a timer (default **30 s**, configurable constant).
3. When the timer fires, emit one `cli.generate` with accumulated metadata updates, latest `features` / `serverpod_modules` / `counts`, `incremental_run_count`, and `incremental_avg_duration_ms` (sum of per-run durations in the burst ÷ run count).

This collapses save bursts into one analytics entry while preserving per-run timing signal via the average.

One-shot `serverpod generate` bypasses debounce: emit immediately with `oneshot_duration_ms` set to the full command wall time. Do **not** send incremental timing fields on one-shot events, or vice versa — the two duration properties are mutually exclusive so PostHog aggregates stay comparable within each mode.

**Hook points:**

- `performOneShotGenerate` in `generate.dart` (wrap timing + result).
- `analyzeAndGenerate` in `generate.dart` when `skipStalenessCheck == true` (watch paths) — delegate to `GenerateTracker`.
- Ensure `ProtocolDefinition` is available post-analysis in `Analyzers.performGenerate` (pass snapshot out or analyze in hook).

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
| `is_repair_migration` | `bool` | `true` for `create-repair-migration`, else `false` |

At least one of `server_migration_created` / `client_migration_created` is `true` on every emitted event. Typical combinations:

| Outcome | `server_migration_created` | `client_migration_created` |
|---|---|---|
| Server-only `CreateMigrationCreated` | `true` | `false` |
| Client-only migration | `false` | `true` |
| `CreateMigrationServerClientCreated` (both written) | `true` | `true` |
| Repair migration | `true` | `false` |

Migration version timestamps are parsed from directory names (Serverpod's `YYYYMMDDHHMMSS…` prefix). Server counts scan `<serverDir>/migrations/`; client counts scan `<clientDir>/lib/migrations/` (via `GeneratorConfig.clientPackagePathParts`). No migration names, tags, or SQL content are sent.

`days_since_first_migration` and `average_interval_days` remain server-scoped for now (repair migrations and schema cadence are server-driven). Client count is included for adoption tracking only.

**Hook points:**

- `CreateMigrationCommand.runWithConfig`: map `CreateMigrationOutcome` to flags + metrics.
- `CreateRepairMigrationCommand.runWithConfig`: on successful repair write.
- Optional later: MCP `create_migration` / `create_repair_migration` tools in `start --watch` (same helper).

---

## 4. `cli.session_start`

**When:** At the beginning of a dev session, after `GeneratorConfig` is loaded and start options are known — before spawning server / Flutter / Docker.

Covers `serverpod start` (including `--watch` / `--no-watch`). Does **not** cover arbitrary `serverpod run <script>` scripts unless they invoke the start command internally.

| Property | Type | Source |
|---|---|---|
| `watch_mode` | `bool` | `StartOption.watch` (default `true`) |
| `tui_enabled` | `bool` | `StartOption.tui` |
| `flutter_enabled` | `bool` | `StartOption.flutter` |
| `flutter_device_category` | `String?` | coarse bucket from `--flutter-device` (e.g. `chrome`, `web-server`, `mobile`, `desktop`, `headless`) |
| `docker_flag` | `bool` | user passed `--docker` |
| `docker_compose_present` | `bool` | `docker-compose.yaml` exists in server dir |
| `num_tool_calls` | `int` | sum of `command_invocations` values in metadata |
| `command_invocations` | `Map<String, int>` | copy of metadata histogram |

Do **not** spawn a `docker compose ps` probe just for analytics — it adds a
subprocess to every `serverpod start`. Whether Compose services were already
running is inferable from `docker_flag` + `docker_compose_present` plus the
existing startup logs, so it is intentionally omitted.

Do **not** probe `localhost:8090` — that port is the default Flutter **web** port, not Redis or Postgres.

Session duration is derived in PostHog from event timestamps. Do not send a separate start-time property.

**Hook point:** `StartCommand.runWithConfig` after config load, before `_runStartSession` / watch session setup (`start.dart`).

---

## Implementation order

1. **`ProjectMetadataStore` + command counter hook** — `metadata.json` read/write (`project_id`, date resolution); increment `command_invocations` from `ServerpodCommandRunner.runCommand`.
2. **`CliAnalytics` + dedicated `PostHogAnalytics` ref** — ensure `cli.*` events never reach MixPanel.
3. **`AnalyticsPayloadBuilder` + tests** — allowlist enforcement before any PostHog send.
4. **`cli.project_created`** — smallest payload; validates end-to-end pipeline.
5. **`cli.generate`** — `ProtocolFeatureAnalyzer` (features + `serverpod_modules`), timing, and `GenerateTracker` debounce.
6. **`cli.migration_created`** — `MigrationMetrics` + server/client flag mapping.
7. **`cli.session_start`** — start-option snapshot + Docker compose probe.
8. **PostHog dashboards** — funnels and trends using the schemas above; validate property types in live events before building charts.

## Testing

- Unit tests for `AnalyticsPayloadBuilder` (rejects raw strings, accepts allowlisted shapes).
- Unit tests for `ProjectMetadataStore` (`project_id` generation, date fallback from `config/generator.yaml` stat).
- Unit tests for `ProtocolFeatureAnalyzer` and `serverpod_modules` allowlist matching.
- Unit tests for `GenerateTracker` timer coalescing (fake async).
- Unit tests for `MigrationMetrics` and server/client flag outcome mapping.
- Integration tests: `cli.*` events hit PostHog mock only (not MixPanel mock); coarse command events still hit both; `--no-analytics` disables rich events.
