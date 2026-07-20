import 'package:nocterm/nocterm.dart';
import 'package:serverpod_cli/src/commands/start/tui/inspectable_scroll_controller.dart';
import 'package:serverpod_tui/serverpod_tui.dart';

/// Identifier for the primary (server log) area.
const kMainArea = 'main';

/// Identifier for the companion Flutter apps area.
const kAppsArea = 'apps';

/// A view hosted in some area. Declares which area it is pinned to and owns
/// its scroll position.
abstract class PaneTab {
  /// The area this tab is pinned to; routes the tab on insert.
  String get areaId;

  /// Tab label shown in the strip when an area has multiple tabs.
  String get label;

  /// Scroll position for this tab's content.
  ScrollController get scrollController;
}

/// Structured server log view pinned to [kMainArea].
class ServerLogTab implements PaneTab {
  /// Creates a [ServerLogTab].
  ServerLogTab({InspectableScrollController? scrollController})
    : scrollController = scrollController ?? InspectableScrollController();

  @override
  String get areaId => kMainArea;

  @override
  String get label => 'Server logs';

  @override
  final InspectableScrollController scrollController;
}

/// Flutter app log view pinned to [kAppsArea].
class AppLogTab implements PaneTab {
  /// Creates an [AppLogTab].
  AppLogTab({
    required this.appId,
    required this.label,
    BoundedQueueList<String>? lines,
    BoundedQueueList<Object>? logHistory,
    InspectableScrollController? scrollController,
    this.ready = false,
    this.stopped = false,
    this.url,
    this.startupStage,
  }) : lines = lines ?? BoundedQueueList<String>(maxLogEntries),
       logHistory = logHistory ?? BoundedQueueList<Object>(maxLogEntries),
       scrollController = scrollController ?? InspectableScrollController();

  /// Maximum number of raw lines and structured entries to keep.
  static const maxLogEntries = 10000;

  /// Stable app identifier from [FlutterAppConfig.id].
  final String appId;

  @override
  final String label;

  /// Whether the Flutter app is running and a URL has been published.
  bool ready;

  /// Whether the Flutter app stopped.
  /// This can be from user quitting the app
  /// or from app launch failing.
  bool stopped;

  /// HTTP URL the Flutter app is served at.
  String? url;

  /// Latest `app.progress` message from the Flutter daemon.
  String? startupStage;

  @override
  String get areaId => kAppsArea;

  /// Raw stdout/stderr lines for this app.
  final BoundedQueueList<String> lines;

  /// Structured entries rendered in this app's log tab.
  final BoundedQueueList<Object> logHistory;

  @override
  final InspectableScrollController scrollController;
}

/// A layout region with its own tab strip.
class TabArea {
  /// Creates a [TabArea].
  TabArea({
    required this.id,
    this.flex = 1,
    List<PaneTab>? tabs,
    this.selectedIndex = 0,
  }) : tabs = tabs ?? [];

  /// Unique area identifier.
  final String id;

  /// Layout weight when sizing areas in a row or column.
  final int flex;

  /// Tabs hosted in this area.
  final List<PaneTab> tabs;

  /// Index of the currently selected tab in [tabs].
  int selectedIndex;

  /// The currently selected tab, or null when [tabs] is empty.
  PaneTab? get selected {
    if (tabs.isEmpty) return null;
    return tabs[selectedIndex.clamp(0, tabs.length - 1)];
  }
}

/// Areas-based tab model for the multi-pane TUI layout.
class TabModel {
  /// Creates a [TabModel] with the given [areas] in left-to-right order.
  TabModel(this.areas);

  /// Layout areas, ordered left to right.
  final List<TabArea> areas;

  /// Index of the area that currently holds keyboard focus.
  int focusedAreaIndex = 0;

  /// The area that currently holds keyboard focus.
  TabArea get focusedArea => areas[focusedAreaIndex];

  /// The selected tab in the focused area.
  PaneTab? get focusedTab => focusedArea.selected;

  /// Returns the area with [areaId].
  TabArea areaOf(String areaId) {
    return areas.firstWhere(
      (area) => area.id == areaId,
      orElse: () => throw StateError('Unknown tab area: $areaId'),
    );
  }

  /// Adds a tab area.
  void addArea(TabArea area) {
    areas.add(area);
  }

  /// Adds [tab] to the area named by its [PaneTab.areaId].
  void addTab(PaneTab tab) {
    areaOf(tab.areaId).tabs.add(tab);
  }

  /// Removes [tab] from its area and clamps that area's [TabArea.selectedIndex].
  void removeTab(PaneTab tab) {
    final area = areaOf(tab.areaId);
    final index = area.tabs.indexOf(tab);
    if (index == -1) return;

    area.tabs.removeAt(index);
    if (area.tabs.isEmpty) {
      area.selectedIndex = 0;
      return;
    }

    if (area.selectedIndex >= area.tabs.length) {
      area.selectedIndex = area.tabs.length - 1;
    } else if (area.selectedIndex > index) {
      area.selectedIndex--;
    }
  }

  /// Focuses the area containing [tab] and selects it.
  void focusTab(PaneTab tab) {
    final area = areaOf(tab.areaId);
    final index = area.tabs.indexOf(tab);
    if (index == -1) return;

    focusedAreaIndex = areas.indexOf(area);
    area.selectedIndex = index;
  }

  /// All tabs across every area, in area order then tab order.
  ///
  /// Used by the single-column (narrow) layout, where every area's tabs are
  /// merged into one tab strip, and by digit shortcuts for explicit jumps.
  List<PaneTab> get allTabs => [for (final area in areas) ...area.tabs];

  /// Tabs worth visiting during keyboard cycling for the current layout.
  ///
  /// In side-by-side mode, single-tab areas (typically the server pane) are
  /// skipped because they stay visible and selecting them does not change the
  /// layout. In the merged narrow layout every tab is included because only one
  /// pane is shown at a time.
  List<PaneTab> cyclableTabs({required bool sideBySide}) {
    if (!sideBySide) return allTabs;
    return [
      for (final area in areas)
        if (area.tabs.length > 1) ...area.tabs,
    ];
  }

  /// Index of [focusedTab] within [allTabs], or `-1` when there is none.
  int get focusedTabIndexInAll {
    final tab = focusedTab;
    if (tab == null) return -1;
    return allTabs.indexOf(tab);
  }

  /// Cycles keyboard focus across [cyclableTabs] by [delta], wrapping at the
  /// ends.
  ///
  /// When the current tab is outside the cyclable set (for example the server
  /// tab in side-by-side mode), the next forward step lands on the first
  /// cyclable tab and the next backward step lands on the last.
  void cycleTabs(int delta, {required bool sideBySide}) {
    final cyclable = cyclableTabs(sideBySide: sideBySide);
    if (cyclable.isEmpty || cyclable.length <= 1) return;

    var index = _indexOfFocusedTabIn(cyclable);
    if (index < 0) {
      index = delta > 0 ? -1 : cyclable.length;
    }
    index = (index + delta) % cyclable.length;
    if (index < 0) index += cyclable.length;
    focusTab(cyclable[index]);
  }

  int _indexOfFocusedTabIn(List<PaneTab> tabs) {
    final tab = focusedTab;
    if (tab == null) return -1;
    return tabs.indexOf(tab);
  }

  /// Focuses the [index]th tab across [allTabs].
  void selectAllTabs(int index) {
    final all = allTabs;
    if (index < 0 || index >= all.length) return;
    focusTab(all[index]);
  }
}
