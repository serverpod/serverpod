# Design: CLI lifecycle telemetry (PostHog)

This document describes four rich analytics events for the Serverpod CLI, layered on top of the existing `cli_tools` analytics pipeline. The goal is to understand how developers use Serverpod (project creation choices, code generation patterns, migration cadence, and dev-session setup) without collecting project identifiers, paths, or user-generated names.

Related: [GitHub issue #1274](https://github.com/serverpod/serverpod/issues/1274) (generate debouncing).

## Motivation

The CLI already sends a coarse event per invocation (command name plus masked flags). That tells us *which* commands run, but not *how* projects evolve: template choices, protocol complexity, migration frequency, or typical `start` configurations.

These four lifecycle events add structured, privacy-safe properties at meaningful command boundaries. They complement — and do not replace — the existing per-command events from `BetterCommandRunner`.

## Implementation status

**Not implemented.** The plumbing below is a design target. Today:

- `PostHogAnalytics` and `MixPanelAnalytics` are wired in `tools/serverpod_cli/bin/serverpod_cli.dart` via `CompoundAnalytics`.
- `BetterCommandRunner` emits one event per invocation (command name, or `help` / `invalid`) with masked `full_command` and `flag_*` / `option_*` properties.
- Opt-out is available globally via `--no-analytics`.
- User identity uses a UUID persisted at `~/.serverpod/uuid` (`ResourceManager.uniqueUserId`), sent as PostHog `distinct_id`.
- `PostHogAnalytics` already attaches `$lib`, `$lib_version`, `platform`, `dart_version`, and `is_ci` to every event.

## Architecture

```
Command handler (create / generate / …)
        │
        ▼
CliTelemetry.capture(event, serverDir, properties)
        │  1. read/update .dart_tool/serverpod/telemetry.json
        │  2. build allowlisted payload (TelemetryPayloadBuilder)
        │  3. serverpodRunner.sendAnalyticsEvent(...)
        ▼
CompoundAnalytics → PostHogAnalytics (+ MixPanelAnalytics)
```

### What stays the same

- Keep `PostHogAnalytics` from `cli_tools`; do **not** add a second PostHog client or SDK.
- Keep the existing UUID-based `distinct_id`. Do **not** hash project paths into `$device_id` — project paths must never leave the machine.
- Keep generic command events (`generate`, `start`, …) from `BetterCommandRunner.runCommand`. Rich events use the `cli.*` namespace to avoid collisions.

### New code (proposed)

| Component | Location (proposed) | Role |
|---|---|---|
| `CliTelemetry` | `tools/serverpod_cli/lib/src/telemetry/cli_telemetry.dart` | Metadata I/O, counter updates, dispatches events |
| `TelemetryMetadata` | `…/telemetry/metadata.dart` | JSON schema for `.dart_tool/serverpod/telemetry.json` |
| `TelemetryPayloadBuilder` | `…/telemetry/payload_builder.dart` | Runtime allowlist; strips or rejects unsafe strings |
| `ProtocolFeatureAnalyzer` | `…/telemetry/protocol_feature_analyzer.dart` | Derives `features` + `counts` from `ProtocolDefinition` / `GeneratorConfig` |
| `GenerateTracker` | `…/telemetry/generate_tracker.dart` | In-memory debounce for watch-mode bursts |
| `MigrationMetrics` | `…/telemetry/migration_metrics.dart` | Scans server `migrations/` directory |

Commands reach telemetry via `serverpodRunner.sendAnalyticsEvent`, gated by `serverpodRunner.analyticsEnabled()`.

### Local metadata file

Path: `<serverDir>/.dart_tool/serverpod/telemetry.json` (same directory tree as `generation.stamp` and MCP sockets).

```json
{
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

- Created on first tracked command inside a project (not on `serverpod create`, which runs before the project exists).
- Updated atomically (write temp file, rename) after each tracked command.
- Contains timestamps and integers only — no paths, names, or package identifiers.
- `command_invocations` is incremented in `ServerpodCommandRunner.runCommand` for every executed subcommand (including commands that do not emit rich events), so `cli.session_start` can report cumulative usage.

`project_created_at` for existing projects without metadata: set to the timestamp of the first metadata write (typically first `generate`), not backfilled from git or filesystem.

## Privacy

`TelemetryPayloadBuilder` enforces a runtime allowlist:

- **Allowed:** integers, doubles, booleans, enums (serialized by name), and lists of canonical feature tag strings from a fixed vocabulary.
- **Rejected:** free-form strings (class names, paths, package names, migration tags, device names beyond a coarse category), nested maps with dynamic keys, and any property not declared for an event.

Feature tags must come from a closed set maintained in code (e.g. `auth`, `redis`, `streaming_endpoint`, `future_call`, `object_relation`). Never emit raw `EndpointDefinition.name`, model class names, or migration directory names.

PostHog receives only allowlisted payloads. The `projectPath` / `serverDir` argument to `CliTelemetry` is used locally for metadata lookup and must never appear in event properties.

## Shared event properties

These are attached automatically by `PostHogAnalytics` and should **not** be duplicated in event schemas below:

| Property | Source |
|---|---|
| `$lib` | `'serverpod_cli'` |
| `$lib_version` | CLI template version |
| `platform` | OS string |
| `dart_version` | `Platform.version` |
| `is_ci` | `ci.isCI` |

Rich events may add `$process_person_profile: false` when we want strictly anonymous session profiles (optional; UUID distinct_id already avoids email/name collection).

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

**Hook points:**

- `CreateCommand`: after `performCreate` returns a non-null path (both TUI and non-TUI paths).
- `QuickstartCommand`: after `performCreate` returns a non-null path.

Implementation note: centralize in `performCreate` success exit so TUI and non-TUI paths share one call.

---

## 2. `cli.generate`

**When:** After a generation attempt completes (success or failure). One-shot: once per CLI process. Watch mode: debounced (see below).

Also emitted from internal generation inside `serverpod start --watch` (via shared `analyzeAndGenerate`), not only from the standalone `generate` command.

| Property | Type | Source |
|---|---|---|
| `features` | `List<String>` | `ProtocolFeatureAnalyzer` (see below) |
| `counts` | `Map<String, int>` | See counts table |
| `num_generate_calls` | `int` | `telemetry.json` → `generate_call_count` (incremented before send) |
| `project_age_days` | `int` | days since `project_created_at` in metadata |
| `is_watch_mode` | `bool` | `generate --watch`, or implicit watch inside `start --watch` |
| `generation_succeeded` | `bool` | pipeline result |
| `duration_ms` | `int` | wall time for the tracked generation unit |

### `counts` keys

| Key | Source |
|---|---|
| `model_count` | `protocolDefinition.models.length` |
| `endpoint_count` | non-abstract endpoints in `protocolDefinition.endpoints` |
| `enum_count` | models that are enum definitions |
| `relation_count` | model fields with a `RelationDefinition` |
| `future_call_count` | `protocolDefinition.futureCalls.length` |
| `module_count` | `GeneratorConfig.modules.length` |

### `ProtocolFeatureAnalyzer`

Input: `ProtocolDefinition`, `GeneratorConfig`, and enabled `ServerpodFeature` / experimental flags.

Output: sorted list of canonical tags, e.g.:

- Config: `postgres`, `sqlite`, `redis`, `future_calls` (feature flag), …
- Protocol: `streaming_endpoint`, `login_required_endpoint`, `sealed_model`, `list_relation`, `object_relation`, …

No endpoint, model, or module **names** — only capability tags from a fixed vocabulary.

### Watch-mode debounce

Maintain an in-memory `GenerateTracker` keyed by absolute server directory path.

On each filesystem-triggered generation (`generate --watch`, or `start --watch` → `analyzeAndGenerate`):

1. Increment pending call count and merge the latest feature snapshot.
2. Reset a timer (default **30 s**, configurable constant).
3. When the timer fires, emit one `cli.generate` with accumulated `num_generate_calls` delta applied to metadata, latest `features` / `counts`, and total debounced `duration_ms`.

This collapses save bursts into one telemetry entry ([#1274](https://github.com/serverpod/serverpod/issues/1274)).

One-shot `serverpod generate` bypasses debounce: emit immediately.

**Hook points:**

- `performOneShotGenerate` in `generate.dart` (wrap timing + result).
- `analyzeAndGenerate` in `generate.dart` when `skipStalenessCheck == true` (watch paths) — delegate to `GenerateTracker`.
- Ensure `ProtocolDefinition` is available post-analysis in `Analyzers.performGenerate` (pass snapshot out or analyze in hook).

---

## 3. `cli.migration_created`

**When:** A new migration directory is written to disk.

**Do not emit** for `CreateMigrationNoChanges`, `CreateMigrationAborted`, or failed runs.

| Property | Type | Source |
|---|---|---|
| `migration_count` | `int` | subdirectories under `<serverDir>/migrations/` after write |
| `days_since_first_migration` | `int` | days from earliest migration version timestamp |
| `average_interval_days` | `double?` | `(days_since_first) / (migration_count - 1)` when `migration_count >= 2`, else omit |
| `is_repair_migration` | `bool` | `true` for `create-repair-migration`, else `false` |
| `had_client_migration` | `bool` | `true` when `CreateMigrationServerClientCreated` wrote a client artifact |

Migration version timestamps are parsed from directory names (Serverpod's `YYYYMMDDHHMMSS…` prefix). No migration names, tags, or SQL content are sent.

**Hook points:**

- `CreateMigrationCommand.runWithConfig`: on `CreateMigrationCreated` / successful leaf of `CreateMigrationServerClientCreated`.
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
| `flutter_device_category` | `String?` | coarse bucket from `--flutter-device`, not raw device id (e.g. `chrome`, `web-server`, `mobile`, `desktop`, `headless`) |
| `docker_flag` | `bool` | user passed `--docker` |
| `docker_compose_present` | `bool` | `docker-compose.yaml` exists in server dir |
| `docker_services_running` | `bool` | `docker compose ps --status running` returned containers (same probe as `_ensureDockerServices`) |
| `num_tool_calls` | `int` | sum of `command_invocations` values in metadata |
| `command_invocations` | `Map<String, int>` | copy of metadata histogram |

Do **not** probe `localhost:8090` — that port is the default Flutter **web** port, not Redis or Postgres.

Session duration is derived in PostHog from event timestamps (`cli.session_start` vs later events or session end if added later). Do not send `session_start_time` as a separate property.

**Hook point:** `StartCommand.runWithConfig` after config load, before `_runStartSession` / watch session setup (`start.dart`).

---

## Implementation order

1. **Metadata + command counter hook** — `telemetry.json` read/write; increment `command_invocations` from `ServerpodCommandRunner.runCommand`.
2. **`TelemetryPayloadBuilder` + tests** — allowlist enforcement before any network send.
3. **`cli.project_created`** — smallest payload; validates end-to-end pipeline.
4. **`cli.generate`** — `ProtocolFeatureAnalyzer`, timing, and `GenerateTracker` debounce.
5. **`cli.migration_created`** — `MigrationMetrics` directory scan.
6. **`cli.session_start`** — start-option snapshot + Docker compose probe.
7. **PostHog dashboards** — funnels and trends using the schemas above; validate property types in PostHog live events before building charts.

## Testing

- Unit tests for `TelemetryPayloadBuilder` (rejects raw strings, accepts allowlisted shapes).
- Unit tests for `ProtocolFeatureAnalyzer` with fixture `ProtocolDefinition` instances.
- Unit tests for `GenerateTracker` timer coalescing (fake async).
- Unit tests for `MigrationMetrics` with temp migration directories.
- Integration tests with `MockAnalytics`: verify hook points fire expected `cli.*` events and respect `--no-analytics`.
