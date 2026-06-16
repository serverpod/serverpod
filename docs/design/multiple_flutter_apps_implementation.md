# Implementation Plan: Multiple Flutter apps in `serverpod start`

Execution plan for the design in
[`multiple_flutter_apps.md`](multiple_flutter_apps.md). It is split into ordered
phases that can be handed to separate agents. Each phase is self-contained:
objective, exact files, concrete steps, acceptance criteria, and verification
commands.

## How to use this document

- **Read the design doc first.** This plan says *what to change*; the design doc
  ([`multiple_flutter_apps.md`](multiple_flutter_apps.md)) says *why*, and holds
  the authoritative type sketches (`FlutterAppConfig`, `TabModel`/`TabArea`/
  `PaneTab`, `FlutterAppManager`). Don't restate rationale in code comments —
  match the density and idiom of the surrounding files.
- **Phases are ordered by dependency.** Do them in sequence; each phase must
  leave the package compiling, analyzing clean, and with all tests green before
  the next starts (see *Definition of done*). A phase may be split across
  commits but should land atomically.
- **Do not break single-app behavior** until the phase that explicitly replaces
  it. Phases 1–2 are additive; the user-visible switch happens in phase 3.
- **Scope discipline.** Touch only the files listed for the phase plus their
  tests. If you find an out-of-scope issue, note it; don't fix it inline.

## Repo orientation

All code lives in the `serverpod_cli` package unless noted.

```
tools/serverpod_cli/
  lib/src/config/config.dart                      # GeneratorConfig (+ generator.yaml parsing)
  lib/src/commands/start.dart                     # orchestration, TUI wiring, _setupWatchLoop
  lib/src/commands/start/flutter_process.dart     # one `flutter run --machine` subprocess
  lib/src/commands/start/flutter_dependency_tracker.dart
  lib/src/commands/start/watch_session.dart       # reload/restart routing
  lib/src/commands/start/watch_loop.dart          # WatchLoopContext (lifecycle/dispose)
  lib/src/commands/start/mcp_server.dart          # MCP tools (flutter log history)
  lib/src/commands/start/tui/state.dart           # ServerWatchState
  lib/src/commands/start/tui/app.dart             # key handling, StartAppStateHolder
  lib/src/commands/start/tui/main_screen.dart     # layout/rendering
  lib/src/commands/start/tui/event_handler.dart   # tracked actions, log events
  test/commands/start/tui/{app,state,event_handler}_test.dart
  test/integration/generator_config/*_test.dart
templates/serverpod_templates/projectname_server_upgrade/config/generator.yaml
docs/design/multiple_flutter_apps.md              # the design
```

### Commands

Run from `tools/serverpod_cli`:

```bash
dart pub get                                       # once, or after pubspec changes
dart analyze                                        # must be clean (no warnings)
dart format --output=none --set-exit-if-changed lib test   # CI enforces formatting
dart test test/commands/start/tui/                  # TUI unit tests
dart test test/integration/generator_config/        # config tests
dart test                                           # full package suite
```

If a phase touches multiple packages, bootstrap from the repo root first:
`dart pub global activate melos && melos bootstrap`. Repo-wide lint mirrors CI:
`melos analyze --fatal-warnings --category="noTemplates"`.

## Definition of done (every phase)

1. `dart analyze` clean and `dart format` produces no diff.
2. All existing tests pass, plus the new tests the phase specifies.
3. New/changed public members have doc comments consistent with the file.
4. No dead code left behind (remove replaced fields/branches in the same phase
   that supersedes them, except where this plan explicitly defers a shim to
   phase 7).
5. The phase's acceptance criteria are demonstrably met by a test or a described
   manual check.

---

## Phase 1 — Configuration schema & model

**Depends on:** none. **Additive** — single-app behavior unchanged.

**Objective.** Read a `flutter_apps` list from `config/generator.yaml` into a new
`FlutterAppConfig` model on `GeneratorConfig`, with a synthesized default when
the key is absent.

**Design ref.** *Configuration schema*, *Config model*.

**Files.**
- `lib/src/config/config.dart`
- `test/integration/generator_config/` (new `flutter_apps_config_test.dart`)

**Steps.**
1. Add a `FlutterAppConfig` class (in `config.dart` or a sibling
   `lib/src/config/flutter_app_config.dart` if cleaner) with: `String id`,
   `String name`, `List<String> relativePathParts`, and derived
   `List<String> pathParts` (resolved against `serverPackageDirectoryPathParts`)
   and `bool hasPackage` (directory exists and contains `pubspec.yaml`). Derive
   `id` as a stable slug from `name` (fallback to the last path segment);
   guarantee uniqueness across the list.
2. Add `final List<FlutterAppConfig> flutterApps;` to `GeneratorConfig`; thread
   it through the constructor (`GeneratorConfig({...})`, currently ~line 75).
3. In `GeneratorConfig.load` (the `flutter_apps` parsing point sits next to the
   existing `client_package_path` handling, ~line 403–409): parse
   `generatorConfig['flutter_apps']` as a list of maps `{name, path}` in order.
   When the key is absent, synthesize a single entry
   `FlutterAppConfig(name: <project>, path: ../<project>_flutter)` **only if**
   that directory has a `pubspec.yaml`; otherwise an empty list. Validate shape
   and produce a clear error on a malformed entry (missing `path`).
4. **Keep a temporary shim:** leave `flutterPackagePathParts` and
   `hasFlutterPackage` in place but reimplement them in terms of
   `flutterApps.first` / `flutterApps.isNotEmpty` so existing callers keep
   compiling. Mark them `@Deprecated('Use flutterApps')`. They are removed in
   phase 7.
5. Remove the now-unused hardcoded `relativeFlutterPackagePathParts` local
   (~line 409) and constructor param **only if** the shim no longer needs it;
   otherwise keep until phase 7. Prefer minimal churn here.

**Acceptance criteria.**
- A `generator.yaml` with two `flutter_apps` entries yields two
  `FlutterAppConfig`s in order.
- Absent key with an existing `../<project>_flutter` yields exactly one entry;
  absent key with no sibling yields an empty list.
- `hasFlutterPackage`/`flutterPackagePathParts` still return the same values as
  before for the single-app case.

**Verify.** `dart test test/integration/generator_config/` and `dart analyze`.

---

## Phase 2 — `TabModel` abstraction (pure)

**Depends on:** none (can run in parallel with phase 1). **Additive** — new
files only; nothing wired yet.

**Objective.** Land the areas-based tab model as standalone, fully unit-tested
code.

**Design ref.** *TUI: the areas-based tab model* (authoritative type sketch).

**Files.**
- `lib/src/commands/start/tui/tab_model.dart` (new)
- `test/commands/start/tui/tab_model_test.dart` (new)

**Steps.**
1. Implement `PaneTab` (abstract: `areaId`, `label`, `lines`,
   `scrollController`), `ServerLogTab` (pinned `kMainArea`), `AppLogTab` (pinned
   `kAppsArea`; fields `appId`, `ready`, `url`, `startupStage`), `TabArea`
   (`id`, `flex`, `tabs`, `selectedIndex`, `selected`), and `TabModel`
   (`areas`, `focusedAreaIndex`, plus `addTab`, `removeTab`, `focusTab`,
   `focusArea`, `cycleTabInFocusedArea`, `selectInFocusedArea`, `focusedArea`,
   `focusedTab`, `areaOf`). Use `BoundedQueueList`/`ScrollController` from
   `serverpod_tui`/`nocterm` to match the existing TUI imports.
2. Define `const kMainArea = 'main';` and `const kAppsArea = 'apps';`.
3. Make every mutator total and self-correcting: `removeTab` clamps the owning
   area's `selectedIndex`; `cycleTabInFocusedArea`/`selectInFocusedArea` no-op on
   empty/out-of-range; `focusArea` wraps over `areas`. No method should ever
   leave an index pointing past its list.

**Acceptance criteria (encode as tests).**
- `addTab` routes a tab to the area named by its `areaId`; unknown `areaId`
  throws.
- Two areas hold **independent** `selectedIndex` values simultaneously.
- `focusTab` sets both `focusedAreaIndex` and that area's `selectedIndex`.
- Removing the selected tab clamps without throwing; removing the last tab in an
  area leaves `selected == null`.
- `selectInFocusedArea` and `cycleTabInFocusedArea` act only within the focused
  area.

**Verify.** `dart test test/commands/start/tui/tab_model_test.dart`.

---

## Phase 3 — Adopt `TabModel` in the TUI (single app, always two-pane)

**Depends on:** phase 2. **This is the user-visible refactor.** Backend is still
single-app.

**Objective.** Replace `selectedTab` and the flat Flutter fields with a
`TabModel` of two areas (`main` + `apps`), render the always two-pane layout, and
route input/scroll through the model — driving the one existing Flutter app as a
single `AppLogTab`.

**Design ref.** *TUI state*, *Rendering*, *Input / key bindings* (the
panel-closed rows of the key table).

**Files.**
- `lib/src/commands/start/tui/state.dart`
- `lib/src/commands/start/tui/app.dart`
- `lib/src/commands/start/tui/main_screen.dart`
- `lib/src/commands/start.dart` (the TUI wiring block, ~lines 1100–1232, where
  `flutterStartupStage`/`flutterUrl`/`flutterReady`/`showFlutterOutput`/raw
  flutter sinks are currently set)
- Tests: `test/commands/start/tui/{state,app}_test.dart`

**Steps.**
1. **state.dart:** remove `selectedTab`, `rawFlutterLines`, `showFlutterOutput`,
   `flutterReady`, `flutterUrl`, `flutterStartupStage`,
   `flutterRestartAvailable`, `useSideBySideLayout`, `sideBySideMinWidth`, and
   the fixed Flutter scroll controllers. Add `final TabModel tabs` (constructed
   with `[TabArea(id: kMainArea), TabArea(id: kAppsArea)]` and a `ServerLogTab`
   pre-added to `main`); `bool canLaunchApps`. Update `clearLogs()` to clear the
   server buffer plus every app tab's `lines`. (Defer `launchableApps` /
   `showLaunchPanel` to phase 6 or add now unused — your call, but keep phase 3
   green.)
2. **app.dart:** delete `_normalizeSelectedTab`, `_cycleTab`, and the hardcoded
   `digit1`/`digit2` cases. Bind `←/→ → tabs.focusArea(±1)`,
   `Tab/Shift+Tab → tabs.cycleTabInFocusedArea(±1)`,
   `digit n → tabs.selectInFocusedArea(n-1)`. Route the scroll handler to
   `tabs.focusedTab?.scrollController` (falling back to the server controller
   when `main` is focused). Keep `Ctrl+R` driving the single app's
   restart/launch (unchanged semantics in this phase). Remove the four fixed
   scroll controllers from `ServerpodWatchAppState`; controllers now live on the
   `PaneTab`s.
3. **main_screen.dart:** delete the width-gated side-by-side branch. Build the
   top region as a `Row` over `state.tabs.areas` separated by `VerticalDivider`,
   sized by `area.flex`. Per area render `[tab strip iff tabs.length >= 2]
   [selected tab content][app breadcrumb]`. Generalize `_buildFlutterStatusLine`
   to take an `AppLogTab`. Empty `apps` area → `"No app running · Ctrl+R to
   launch"` placeholder. Highlight the focused area. A project with **no**
   configured apps → single full-width server pane (no `apps` area rendered).
   Update `_helpBindings` and the button bar (`Ctrl+R Launch app…`).
4. **start.dart wiring:** replace writes to the removed flat fields with
   creation/updates of a single `AppLogTab` for the one Flutter app: on
   progress/ready, update that tab's `startupStage`/`url`/`ready`; route the
   flutter stdout/stderr sinks into that tab's `lines`. `canLaunchApps` =
   dev-mode AND `config.flutterApps.isNotEmpty`.
5. Add the narrow-terminal fallback: below a width threshold, stack the areas
   vertically (still iterating `tabs.areas`); same model, no separate widgets.

**Acceptance criteria.**
- With one Flutter app the TUI shows server-left + one app-tab-right, always
  side-by-side; `←/→` move focus between panes; scroll acts on the focused pane.
- `Ctrl+R` still launches/restarts the single app; the breadcrumb shows inside
  the app tab.
- No-Flutter project renders a single full-width server pane and `Ctrl+R` is
  inert.
- Existing `app_test`/`state_test` cases are updated to the new model and pass.

**Verify.** `dart test test/commands/start/tui/` and `dart analyze`. Manual:
`dart run bin/serverpod_cli.dart start` (or the activated `serverpod start`) in a
scratch project with a Flutter app; confirm layout and key bindings.

---

## Phase 4 — `FlutterAppManager` (multi-process backend)

**Depends on:** phases 1, 3.

**Objective.** Replace the single `flutterProcess` + `spawnFlutterAppIfNeeded`
closure with a manager that owns one process slot per configured app, each with
its own VM-service proxy/info file, dependency tracker, and TUI tab/sinks.
Auto-launch the first app only.

**Design ref.** *Runtime: `FlutterAppManager`*.

**Files.**
- `lib/src/commands/start/flutter_app_manager.dart` (new)
- `lib/src/commands/start.dart` (spawn block ~595–744; `_setupWatchLoop`
  Flutter params ~397–410; Flutter info-file/proxy setup ~420 & ~556; TUI wiring
  ~1100–1232)
- Tests: `test/commands/start/flutter_app_manager_test.dart` (new); reuse the
  existing `flutter_shims` fakes under `test/commands/start/flutter_shims/`.

**Steps.**
1. Implement `FlutterAppManager` per the design sketch: `launch(appId)`,
   `restart(appId)`, `isRunning(appId)`, `processFor(appId)`, `apps`,
   `runningAppIds`, `stopAll()`. Internally keep a map `appId -> _AppRuntime`
   holding its `FlutterProcess`, `VmServiceProxy`, info-file path, dependency
   tracker, and the `AppLogTab` (or a callback to create/focus it).
2. Per app, bind a `VmServiceProxy` eagerly at session start and write
   `flutter-vm-service-info-<appId>.json` (drop the single legacy filename).
   Reuse `_bindFlutterProxy`'s logic, parameterized per app.
3. Move the existing spawn body (progress reporting, `launched`,
   `connectToVmService`, `onFlutterStart`) into `launch`, keyed per app. Route
   each app's stdout/stderr into its own `AppLogTab.lines`. On launch, create or
   focus the app's tab via `state.tabs.addTab`/`focusTab`.
4. Per app, set up a `FlutterDependencyTracker` using the existing setup logic
   (currently a single block at ~685–714), iterated over `config.flutterApps`.
5. `--flutter` (default true) auto-launches `config.flutterApps.first` only.
   `--no-flutter` launches none. Keep `--flutter-device`/`--flutter-option`
   global for now (per-app device is an open question, out of scope).
6. Update `start.dart` to construct the manager and pass it where the single
   process/restart action used to go. Replace `flutterProcessProvider` /
   `flutterAppRestartAction` wiring (see phase 5 for `WatchSession`).

**Acceptance criteria.**
- Two configured apps can each be launched and run concurrently, each with its
  own proxy/info file and its own tab buffer.
- Auto-launch starts only the first app.
- `stopAll()` tears down every running app and removes its info file.
- Manager unit tests pass using the flutter shim fakes.

**Verify.** `dart test test/commands/start/flutter_app_manager_test.dart` and
`dart analyze`.

---

## Phase 5 — Watch integration (per-app reload routing)

**Depends on:** phase 4.

**Objective.** Make `WatchSession` reload/restart the correct app(s) on file
changes, watch every app's sources, and dispose all per-app resources.

**Design ref.** *Watch integration*.

**Files.**
- `lib/src/commands/start/watch_session.dart`
- `lib/src/commands/start/watch_loop.dart` (`WatchLoopContext`)
- `lib/src/commands/start.dart` (watched-path list ~804)
- Tests: `test/commands/start/watch_session_test.dart`

**Steps.**
1. Replace the single `flutterProcessProvider`/`isFlutterAppRunning`/
   `flutterAppRestartAction` (~108–176) with the `FlutterAppManager` (or a
   narrow interface over it).
2. In `_reloadOrRestartFlutterApp` / `_reloadFlutter` / `_restartFlutter`
   (~311–327, 620–648), **attribute changed paths to the owning app** by
   prefix-matching each app's `lib` directory, and act only on affected
   **running** apps. If attribution is ambiguous, fall back to all running apps
   (preserves single-app behavior).
3. Expand the watched-path list in `start.dart` (~804) to include every app's
   `lib` plus each tracker's `dartToolDir` (iterate `config.flutterApps`).
4. `WatchLoopContext.dispose` (`watch_loop.dart` ~59–71): close and delete
   **all** per-app proxies and info files (was a single `flutterProxy` +
   `flutterVmServiceInfoFile`).

**Acceptance criteria.**
- Editing app A's `lib` reloads only app A; app B is untouched.
- A native-dependency change for an app triggers a full relaunch of that app
  only.
- Dispose removes every per-app info file and closes every proxy.

**Verify.** `dart test test/commands/start/watch_session_test.dart` and
`dart analyze`.

---

## Phase 6 — Launch panel (input + render + wiring)

**Depends on:** phases 3, 4.

**Objective.** Add the `Ctrl+R` launch picker for >1 app: a right-docked panel
listing configured apps with running state; digits `1`–`N` (≤9) or click launch
(if stopped) / focus (if running), open the tab, close the panel.

**Design ref.** *Overview* (panel mockup), *Rendering* (`_buildLaunchPanel`),
*Input / key bindings* (panel-open rows).

**Files.**
- `lib/src/commands/start/tui/state.dart` (`launchableApps`, `showLaunchPanel`)
- `lib/src/commands/start/tui/app.dart` (panel branch, `onLaunchApp`)
- `lib/src/commands/start/tui/main_screen.dart` (`_buildLaunchPanel`)
- `lib/src/commands/start.dart` (wire `onLaunchApp` to the manager)
- Tests: `test/commands/start/tui/app_test.dart`

**Steps.**
1. **state.dart:** add `List<FlutterAppConfig> launchableApps` (populated from
   `config.flutterApps`) and `bool showLaunchPanel`.
2. **app.dart:** `Ctrl+R` → 0 apps inert; exactly 1 app launch/restart/focus
   directly (phase-3 behavior); >1 toggle `showLaunchPanel`. Add a panel-mode
   branch (mirroring the help/raw-log branches) that absorbs keys: `Esc`/`Ctrl+R`
   close; `digit 1..N` (cap 9) → `onLaunchApp(index)` then close. Add
   `onLaunchApp(int)` to the `StartAppStateHolder` callback plumbing.
3. **main_screen.dart:** `_buildLaunchPanel` renders a right-docked overlay in
   the `Stack` (sibling of `HelpOverlay`) listing `launchableApps` as
   `N  <name>  ●/○` (running indicator from the manager), rows clickable, hint
   `1–N / click · Esc`. Show it only when `state.showLaunchPanel`.
4. **start.dart:** wire `onLaunchApp(i)` to: if app `i` is running →
   `state.tabs.focusApp(...)`; else `manager.launch(appId)` (which creates +
   focuses the tab). Close the panel afterward.

**Acceptance criteria.**
- `Ctrl+R` with >1 app opens the panel; `1`–`N`/click launches a stopped app or
  focuses a running one and closes the panel; `Esc` closes it.
- `Ctrl+R` with exactly 1 app does **not** open a panel (direct action).
- With >9 apps, only `1`–`9` are number-selectable; the rest are click-only.

**Verify.** `dart test test/commands/start/tui/app_test.dart` and `dart analyze`.

---

## Phase 7 — Templates, docs, MCP, cleanup

**Depends on:** phases 1–6.

**Objective.** Seed the schema in templates, document it publicly, generalize MCP
log history, and remove the deprecated shims/dead code.

**Files.**
- `templates/serverpod_templates/projectname_server_upgrade/config/generator.yaml`
- The source the `create` command uses for a new project's
  `config/generator.yaml` — **trace it first**: `projectname_server` has no
  committed `config/generator.yaml`, so grep the CLI create command and consult
  [`templates.md`](templates.md) to find where the created file originates, then
  add `flutter_apps` there too.
- `lib/src/commands/start/mcp_server.dart` + `start.dart`
  (`mcpGetFlutterLogHistory` ~1174)
- Public configuration docs (where `client_package_path` is documented)
- `lib/src/config/config.dart` (remove deprecated shims)

**Steps.**
1. Add a default `flutter_apps` entry to the upgrade template and the created-
   project source:
   ```yaml
   flutter_apps:
     - name: projectname
       path: ../projectname_flutter
   ```
   Use the template's placeholder convention (`projectname` is substituted at
   create time — verify against neighboring keys).
2. Generalize `mcpGetFlutterLogHistory` to per-app history keyed by `appId`
   (update the MCP tool signature/response and its test in
   `test/commands/start/mcp_server_test.dart`).
3. Document `flutter_apps` alongside `client_package_path` in the public docs:
   the list-of-maps shape, default synthesis, and the launch UX.
4. Remove the `@Deprecated` `flutterPackagePathParts` / `hasFlutterPackage`
   shims and the leftover `relativeFlutterPackagePathParts` constructor param
   once no callers remain. Run a repo-wide grep to confirm zero references.
5. Update `CHANGELOG.md` for `serverpod_cli` (and the templates changelog if the
   template changed).

**Acceptance criteria.**
- A freshly created project's `config/generator.yaml` contains the default
  `flutter_apps` entry.
- No references to the removed config members remain
  (`grep -rn "flutterPackagePathParts\|hasFlutterPackage" tools/serverpod_cli/lib`).
- MCP returns per-app log history.

**Verify.** `dart test` (full suite) and `dart analyze`; `melos analyze
--fatal-warnings --category="noTemplates"` from the repo root.

---

## Cross-cutting checklist

- [ ] Each phase: `dart analyze` clean, `dart format` no-diff, tests green.
- [ ] No magic tab indices anywhere — all navigation goes through `TabModel`.
- [ ] Per-app artifacts (proxy, info file, tracker, tab buffer, sinks) are
      created and torn down per app; nothing is shared across apps.
- [ ] Single-app and no-Flutter projects behave correctly at every phase.
- [ ] Public + design docs updated (phase 7).

## Risks & gotchas

- **VM-service proxies are bound eagerly** for every configured app so IDE info
  files exist up front. Many apps = many bound ports; keep binding lazy-friendly
  if this proves heavy (note, don't pre-optimize).
- **Path attribution for reload** must handle nested/overlapping `lib` paths and
  monorepo layouts; when unsure, reload all running apps rather than guessing
  wrong.
- **`flutter run -d web-server`** withholds `app.debugPort` until a browser
  attaches (see `flutter_process.dart`); preserve the existing unbounded-wait
  behavior per app.
- **Created-project generator.yaml source is non-obvious** (`projectname_server`
  ships no committed `config/generator.yaml`). Resolve this in phase 7 before
  assuming a file path.
- **`dart pub global activate` caching** can hide CLI changes during manual
  testing (see CONTRIBUTING); re-activate or run via `dart run` when verifying.
