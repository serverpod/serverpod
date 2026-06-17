# Design: Multiple Flutter apps in `serverpod start`

This document describes connecting `serverpod start` to more than one companion
Flutter app at once. Each app is discoverable from a user-populated list in
`config/generator.yaml`, gets its own logs tab, and is launched on demand from a
`Ctrl+R` picker. It also introduces an **areas-based tab model** that replaces
the ad-hoc tab handling in the TUI, so the layout can grow more panes without
re-plumbing.

> This extends the base TUI described in [`tui.md`](tui.md) and reuses the
> Flutter process / hot-reload machinery from [`hot_reload.md`](hot_reload.md).
> Where the two disagree on layout and key bindings, this document is
> authoritative for the multi-app case; the Flutter daemon protocol, VM-service
> attach, and reload/restart semantics are unchanged.

## Current state

`serverpod start` runs at most **one** companion Flutter app, and the assumption
is baked in at every layer:

- **Config** — `GeneratorConfig` hardcodes the Flutter package path to the
  sibling `../<project>_flutter` and never reads it from `generator.yaml`
  (`tools/serverpod_cli/lib/src/config/config.dart`,
  `_relativeFlutterPackagePathParts`, `flutterPackagePathParts`,
  `hasFlutterPackage`). `client_package_path` *is* configurable; the Flutter
  path is not.
- **Orchestration** — `tools/serverpod_cli/lib/src/commands/start.dart` holds a
  single `FlutterProcess? flutterProcess`, a `spawnFlutterAppIfNeeded()` closure,
  one `VmServiceProxy` plus one `flutter-vm-service-info.json` for IDE attach,
  one `FlutterDependencyTracker`, and a single `flutterAppRestartAction`.
- **Reload routing** — `WatchSession` reloads/restarts the one
  `_flutterProcess` on file changes
  (`tools/serverpod_cli/lib/src/commands/start/watch_session.dart`).
- **TUI state** — `ServerWatchState` uses a raw `selectedTab` int (`0` = server,
  `1` = Flutter), one `rawFlutterLines` buffer, and flat `flutterReady` /
  `flutterUrl` / `flutterStartupStage` / `showFlutterOutput` /
  `flutterRestartAvailable` fields
  (`tools/serverpod_cli/lib/src/commands/start/tui/state.dart`).
- **TUI input** — `Ctrl+R` drives the single app; `digit1`/`digit2` are
  hardcoded to tab indices; `_cycleTab` recomputes `tabCount` ad hoc;
  `_normalizeSelectedTab` patches invalid selections
  (`tools/serverpod_cli/lib/src/commands/start/tui/app.dart`).
- **Rendering** — a two-column "side-by-side" layout gated on terminal width,
  with `['Server logs', 'Flutter logs']` tabs
  (`tools/serverpod_cli/lib/src/commands/start/tui/main_screen.dart`).

The Flutter integration is still pre-1.0 (never left beta), so there are **no
backwards-compatibility constraints** — files, flags, and on-disk artifacts can
be renamed freely.

## Overview

> **Update:** the config moved out of `generator.yaml` into the server
> `pubspec.yaml` under the `serverpod:` section (alongside `serverpod:
> scripts:`), keyed by app alias rather than a list. The rest of this document
> predates that move; treat the layout, runtime, and TUI design as
> authoritative and the config *location/shape* as superseded by the block
> below.

A project declares its apps in the server `pubspec.yaml` under `serverpod:`:

```yaml
serverpod:
  flutter_apps:
    Admin:
      path: ../apps/admin
    Portal:
      path: ../apps/portal
```

- It is a **map of alias → properties** (currently just `path`) so per-app
  options can be added later without a schema break (e.g. a per-app `device:`).
  The alias is the app's display name.
- When the key is **absent**, a single default entry is synthesized from the
  sibling `../<project>_flutter` (only if that directory exists). Existing
  projects therefore behave exactly as before.
- The pubspec template ships a commented example, so new projects discover it.

The TUI layout is **always two-pane** (whenever ≥1 app is configured): the left
pane is the server log, fixed; the right pane is a tab strip with one tab per
**launched** app, each carrying its own breadcrumb.

```
┌─ serverpod start ───────────────────────────────────────────────┐
│  (main area)           │ (apps area)  Admin │ Customer │ Kiosk   │
│                        │ Customer │ http://localhost:8082        │
│ 12:00 [I] Server ready │ 12:00 [I] Flutter: ready                │
│ 12:00 [I] Insights …   │ 12:00 [I] Restarted in 412ms            │
│  no strip (1 tab)      │  strip shown (≥2 tabs), focused          │
├──────────────────────────────────────────────────────────────────┤
│ R Hot reload  Ctrl+R Launch app…  M Migration  …  Q Quit          │
└──────────────────────────────────────────────────────────────────┘
```

`Ctrl+R` opens a right-docked **launch panel** listing every configured app, when
more than one exists:

```
┌─ serverpod start ───────────────────────────────────────────────┐
│  (main area)           │ Admin │ Customer │   ┌─ Launch app ───┐ │
│                        │ Admin │ http://…      │ 1  Admin    ●  │ │
│ 12:00 [I] Server ready │ 12:00 [I] Flutter:…   │ 2  Customer ●  │ │
│ 12:00 [I] Insights …   │ 12:00 [I] Restarted…  │ 3  Kiosk    ○  │ │
│                        │                       │ 1–3 / click    │ │
│                        │                       │ Esc to close   │ │
│                        │                       └────────────────┘ │
├──────────────────────────────────────────────────────────────────┤
│ R Hot reload  Ctrl+R Launch app…  M Migration  …  Q Quit          │
└──────────────────────────────────────────────────────────────────┘
```

- `Ctrl+R` with **0** apps: inert. With **1** app: launch / restart / focus it
  directly (today's behavior, no panel). With **>1**: toggle the panel.
- In the panel, `1`–`N` (`N` = app count, capped at 9) or a mouse click selects
  an app: launch it if stopped, focus its tab if already running. The tab opens
  and the panel closes. `●` running, `○` stopped.
- `Esc` or a second `Ctrl+R` closes the panel.

## Architecture

### Configuration schema

`config/generator.yaml` gains an optional `flutter_apps` key, parsed in
`GeneratorConfig.load` (`tools/serverpod_cli/lib/src/config/config.dart`)
alongside `client_package_path`:

```yaml
flutter_apps:
  - name: <display name>      # tab label + breadcrumb
    path: <relative path>     # relative to the server package directory
```

Resolution rules:

- If `flutter_apps` is present, each entry becomes a configured app in list
  order. App 0 is the default for auto-launch (see below).
- If `flutter_apps` is absent, synthesize `[{ name: <project>,
  path: ../<project>_flutter }]` — but only if that directory contains a
  `pubspec.yaml`. Otherwise the list is empty (a project with no Flutter app).
- Whether each configured directory actually exists is validated at **launch**
  time, not load time, so a typo'd path surfaces as a clear per-app error rather
  than aborting startup.

### Config model

```dart
/// One configured companion Flutter app. The map shape leaves room for
/// per-app options (e.g. `device`) without a schema break.
class FlutterAppConfig {
  final String id;                       // stable slug derived from name/path
  final String name;                     // tab label + breadcrumb
  final List<String> relativePathParts;  // relative to the server package dir

  List<String> get pathParts;            // absolute, via serverPackageDirectoryPathParts
  bool get hasPackage;                   // dir exists with a pubspec.yaml
}
```

`GeneratorConfig` gains `List<FlutterAppConfig> flutterApps`. The existing
`flutterPackagePathParts` / `hasFlutterPackage` getters are removed; their few
call sites in `start.dart` and `watch_session.dart` move to iterate
`flutterApps`.

### Runtime: `FlutterAppManager`

A new `tools/serverpod_cli/lib/src/commands/start/flutter_app_manager.dart`
replaces the single `flutterProcess` and the `spawnFlutterAppIfNeeded()` closure
in `start.dart`. It owns one slot per configured app:

```dart
class FlutterAppManager {
  // Per app: process, IDE proxy + info file, dependency tracker, log sinks.
  FlutterProcess? processFor(String appId);
  bool isRunning(String appId);
  Iterable<FlutterAppConfig> get apps;
  Iterable<String> get runningAppIds;

  Future<void> launch(String appId);   // no-op if already running
  Future<void> restart(String appId);  // stop + launch
  Future<void> stopAll();
}
```

Per-app resources:

- **VM-service proxy + info file** — each app binds its own `VmServiceProxy` and
  writes `flutter-vm-service-info-<appId>.json` so IDEs can attach to each app
  independently. (The old single `flutter-vm-service-info.json` name is dropped;
  no legacy constraint.) Proxies are bound eagerly at session start so the info
  files exist for IDE attach regardless of whether the app is launched, matching
  today's behavior.
- **Dependency tracker** — one `FlutterDependencyTracker` per app, set up by the
  same logic that currently runs once
  (`tools/serverpod_cli/lib/src/commands/start/flutter_dependency_tracker.dart`).
- **Log sinks** — each app's `stdout`/`stderr` route into its own TUI tab buffer
  (see `AppLogTab` below) instead of a shared `rawFlutterLines`.

`--flutter` (default true) auto-launches every app whose `auto_launch` property
is true (the synthesized default sibling app is flagged, preserving the
single-app behavior); when none opt in, nothing launches. The rest are launched
on demand from the panel. `--no-flutter` launches none, but the panel and
`Ctrl+R` still work.

### Watch integration

`WatchSession`
(`tools/serverpod_cli/lib/src/commands/start/watch_session.dart`) takes the
manager instead of a single-process provider. On a Flutter lib / dependency
change it **attributes the changed paths to the owning app** by prefix-matching
against each app's `lib` directory, then reloads or restarts only the affected
**running** apps; if attribution is ambiguous it falls back to reloading all
running apps (preserving single-app behavior). The watched-path list in
`start.dart` expands to include every app's `lib` plus each tracker's
`dartToolDir`. `WatchLoopContext.dispose`
(`tools/serverpod_cli/lib/src/commands/start/watch_loop.dart`) closes and deletes
**all** per-app proxies and info files.

### TUI: the areas-based tab model

The current tab handling rots as soon as tabs become dynamic: a raw `selectedTab`
int with magic values, `_normalizeSelectedTab` patching invalid states,
`_cycleTab` recomputing `tabCount`, hardcoded `digit1→0 / digit2→1`, and
`showFlutterOutput ? 2 : 1` scattered through `app.dart` and `main_screen.dart`.
It is replaced by a single owned model built around **areas**.

The key property of an always-visible multi-pane layout is that each pane shows
its **own** current tab *simultaneously* (the left pane shows the server while
the right pane shows app 2, at the same time). A single flat focus index cannot
represent that, so the model is **N areas, each with its own tab strip and
selected index, plus one focused-area pointer** for where the keyboard acts.

`tools/serverpod_cli/lib/src/commands/start/tui/tab_model.dart`:

```dart
const kMainArea = 'main';   // leftmost / primary
const kAppsArea = 'apps';   // currently the only secondary area

/// A view hosted in some area. Declares which area it is pinned to and owns
/// its content (log buffer + scroll position).
abstract class PaneTab {
  String get areaId;                       // pinned area — routes the tab on insert
  String get label;
  BoundedQueueList<String> get lines;
  ScrollController get scrollController;
}

class ServerLogTab extends PaneTab {       // areaId => kMainArea
  // structured server log view; the project's single primary tab today
}

class AppLogTab extends PaneTab {          // areaId => kAppsArea
  final String appId;
  bool ready = false;
  String? url;
  String? startupStage;                    // drives the breadcrumb
}

/// A layout region with its own tab strip. Each area remembers what it shows,
/// independent of which area currently holds keyboard focus.
class TabArea {
  final String id;
  final int flex;                          // layout weight; new areas size themselves
  final List<PaneTab> tabs = [];
  int selectedIndex = 0;
  PaneTab? get selected => tabs.isEmpty ? null : tabs[selectedIndex];
}

class TabModel {
  TabModel(this.areas);
  final List<TabArea> areas;               // ordered left→right; add an entry = new area
  int focusedAreaIndex = 0;

  TabArea get focusedArea => areas[focusedAreaIndex];
  PaneTab? get focusedTab => focusedArea.selected;
  TabArea areaOf(String areaId) => areas.firstWhere((a) => a.id == areaId);

  void addTab(PaneTab tab) => areaOf(tab.areaId).tabs.add(tab);  // pin-routed
  void removeTab(PaneTab tab);             // clamps that area's selectedIndex
  void focusTab(PaneTab tab);              // focus its area + select it
  void focusArea(int delta);               // ←/→ : move focus across areas
  void cycleTabInFocusedArea(int delta);   // Tab / Shift+Tab within the area
  void selectInFocusedArea(int index);     // digit within the focused area
}
```

Constructed declaratively, so a future area is one list entry plus tabs that pin
to it:

```dart
TabModel([
  TabArea(id: kMainArea, flex: 1),
  TabArea(id: kAppsArea, flex: 1),
  // future: TabArea(id: kInsightsArea, flex: 1),
]);
```

Why this generalizes:

- A tab joins a region purely by its `areaId` — `addTab` routes it; no layout or
  input code names "left" or "right."
- Each `TabArea.selectedIndex` is independent, so every area renders its own
  current tab at once — the correct model for an always-visible multi-pane UI.
- The server stops being special-cased: it is a `ServerLogTab` pinned to
  `kMainArea` that happens to be that area's only tab. The "fixed left, no strip"
  look becomes one rendering rule: **show an area's tab strip only when it has
  ≥2 tabs.**

### TUI state

`ServerWatchState`
(`tools/serverpod_cli/lib/src/commands/start/tui/state.dart`):

- **Remove:** `selectedTab`, `rawFlutterLines`, `showFlutterOutput`,
  `flutterReady`, `flutterUrl`, `flutterStartupStage`, `flutterRestartAvailable`,
  `useSideBySideLayout`, `sideBySideMinWidth`, and the fixed Flutter scroll
  controllers.
- **Add:** `final TabModel tabs` (built with the `main` + `apps` areas);
  `List<FlutterAppConfig> launchableApps` (all configured apps, drives the
  panel); `bool showLaunchPanel`; `bool canLaunchApps` (dev mode + non-empty
  `launchableApps`).
- `clearLogs()` clears the server buffer plus every `AppLogTab.lines` across all
  areas.

### Rendering

`main_screen.dart`:

- The top region is a `Row` built by iterating `tabs.areas` in order, separated
  by `VerticalDivider`s and sized by `area.flex`. The old width-gated
  side-by-side branch is deleted, not gated.
- Per area: `[tab strip if area.tabs.length >= 2][selected tab content][app
  breadcrumb]`. The focused area is highlighted. An empty `apps` area renders a
  `"No app running · Ctrl+R to launch"` placeholder.
- The breadcrumb (`_buildFlutterStatusLine`) takes an `AppLogTab` and renders
  `"<App> │ <url | stage>"` inside the app's tab.
- A new `_buildLaunchPanel` renders a right-docked overlay in the `Stack` (a
  sibling of `HelpOverlay`) listing `launchableApps` as `N  <name>  ●/○`,
  clickable rows, with the `1–N / click · Esc` hint.
- A project with no configured apps keeps a single full-width server pane.

*Narrow terminals:* with the width gate gone, two panes get thin on small
terminals. A minimum-width fallback stacks the areas vertically using the **same**
`TabModel` (the `main` area on top, `apps` below) so there is no separate code
path.

### Input / key bindings

`app.dart` decouples the operation from geometry so new areas need no new keys:

| Key | Panel closed | Panel open |
|-----|--------------|------------|
| `Ctrl+R` | 0 apps inert · 1 app launch/restart/focus · >1 toggle panel | close panel |
| `←` / `→` | `tabs.focusArea(±1)` (walk the area list) | — |
| `Tab` / `Shift+Tab` | `tabs.cycleTabInFocusedArea(±1)` | — |
| `1`–`9` | `tabs.selectInFocusedArea(n-1)` | launch the Nth configured app |
| `Esc` | (overlays) | close panel |

Scroll keys act on `tabs.focusedTab.scrollController`. The four fixed scroll
controllers collapse into per-`PaneTab` controllers; `_normalizeSelectedTab`,
`_cycleTab`, and the hardcoded digit cases are removed. A new `onLaunchApp(int)`
callback is added to the `StartAppStateHolder` plumbing and wired in `start.dart`
to `manager.launch` + `tabs.focusTab`.

### MCP

`mcpGetFlutterLogHistory` (`start.dart`, consumed by the MCP server in
`tools/serverpod_cli/lib/src/commands/start/mcp_server.dart`) generalizes to
per-app history keyed by `appId`.

### Templates

`serverpod create` / upgrade templates seed `flutter_apps` with the default
entry:
`templates/serverpod_templates/projectname_server_upgrade/config/generator.yaml`.
The `flutter_apps` key is documented alongside `client_package_path` in the
public docs.

## Testing

- **Config** — `flutter_apps` parsing, default synthesis, and absent-key
  backwards-compat.
- **`tab_model_test.dart`** (new) — the previously-untestable tab logic becomes
  unit-testable: pin-routing by `areaId`, **independent per-area
  `selectedIndex`**, `focusArea` / `cycleTabInFocusedArea` /
  `selectInFocusedArea`, `focusTab` jumping across areas, and clamping when the
  selected tab is removed.
- **`app_test.dart`** — `Ctrl+R` with 0/1/>1 apps; panel digit launch + focus;
  cap at 9; `Esc` closes; `Tab` cycling within the focused area; scroll routes to
  the focused pane.
- **`state_test.dart`** — per-`AppLogTab` buffer isolation; `clearLogs` clears
  all areas.
- **`watch_session`** — per-app reload routing (changed path → correct app) and
  multi-app dispose.

## Migration and backwards compatibility

- No `flutter_apps` key → synthesized default sibling app → byte-for-byte today's
  single-app behavior.
- The Flutter integration never left beta, so renamed artifacts (per-app
  `flutter-vm-service-info-<appId>.json`, removed `flutterPackagePathParts`) need
  no shims.
- `>9` configured apps: the panel lists all of them; only `1`–`9` are
  number-selectable, the rest are click-only.

## Design decisions

### Why a list of maps instead of a list of paths

`name` is needed for the tab label and breadcrumb regardless, and the map shape
lets per-app options (a `device:` per app, build flavors, extra `flutter run`
args) be added later without breaking the schema. A bare list of paths would
force a second breaking change the first time an app needs an option.

### Why the server is a pinned tab, not a hardcoded pane

Modeling the server as a `ServerLogTab` pinned to `kMainArea` — rather than a
special left-hand widget — means there is exactly one navigation/scroll/focus
code path for every pane. "Server is fixed on the left with no strip" falls out
of the generic rules (area order + "strip only when ≥2 tabs") instead of being
its own branch.

### Why areas with per-area selection instead of one flat tab index

Both panes are visible at once, so each must retain its own selected tab
independently. A flat index over `[server, app1, app2, …]` cannot express "left
shows server while right shows app 2 simultaneously." Per-area `selectedIndex`
plus a single `focusedAreaIndex` is both the correct model and the one that
scales to a third area for free.

### Why always two-pane (no width gate)

The previous layout flipped between stacked tabs and side-by-side based on
terminal width, which made the tab semantics depend on the window size. Making
the multi-area layout canonical removes that coupling; the only width-driven
behavior is the narrow-terminal fallback, which reuses the same model rather than
forking it.

### Why an explicit `auto_launch` flag instead of "first app"

Launching every configured app on `--flutter` could spin up several heavy
`flutter run` web builds at once and surprise users who only wanted one — but
silently auto-launching just the *first* app is an opaque rule. Instead each app
opts in via `auto_launch: true`, so the choice is explicit and any subset can
come up on start; the rest are a `Ctrl+R` keystroke away. The synthesized
default sibling app sets the flag, preserving the historical "one app comes up"
experience for projects that don't configure `flutter_apps`.

### Why the panel focuses a running app instead of restarting it

`Ctrl+R` / `R` already restart; making panel selection *focus* a running app
(and only launch a stopped one) avoids accidental restarts when the user just
wants to switch tabs. A restart-from-panel affordance (e.g. `Shift+digit`) can be
added later without changing the model.

## Open questions

- **Restart-from-panel** — is focus-only on a running app sufficient, or should
  the panel also offer a restart gesture (`Shift+digit`)? Deferred unless asked
  for.
- **Per-app device** — the schema reserves room for a per-app `device:`, but the
  device is currently a single global `--flutter-device`. Wiring a per-app
  device is out of scope here and tracked as a follow-up.
