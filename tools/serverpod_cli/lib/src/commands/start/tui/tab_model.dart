import 'package:nocterm/nocterm.dart';
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
  ServerLogTab({ScrollController? scrollController})
    : scrollController = scrollController ?? ScrollController();

  @override
  String get areaId => kMainArea;

  @override
  String get label => 'Server logs';

  @override
  final ScrollController scrollController;
}

/// Flutter app log view pinned to [kAppsArea].
class AppLogTab implements PaneTab {
  /// Creates an [AppLogTab].
  AppLogTab({
    required this.appId,
    required this.label,
    BoundedQueueList<String>? lines,
    ScrollController? scrollController,
    this.ready = false,
    this.url,
    this.startupStage,
  }) : lines = lines ?? BoundedQueueList<String>(maxRawLines),
       scrollController = scrollController ?? ScrollController();

  /// Maximum number of raw lines to keep.
  static const maxRawLines = 10000;

  /// Stable app identifier from [FlutterAppConfig.id].
  final String appId;

  @override
  final String label;

  /// Whether the Flutter app is running and a URL has been published.
  bool ready;

  /// HTTP URL the Flutter app is served at.
  String? url;

  /// Latest `app.progress` message from the Flutter daemon.
  String? startupStage;

  @override
  String get areaId => kAppsArea;

  /// Raw stdout/stderr lines for this app.
  final BoundedQueueList<String> lines;

  @override
  final ScrollController scrollController;
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

  /// Moves keyboard focus across areas by [delta] positions, wrapping around.
  void focusArea(int delta) {
    if (areas.isEmpty) return;
    focusedAreaIndex = (focusedAreaIndex + delta) % areas.length;
    if (focusedAreaIndex < 0) {
      focusedAreaIndex += areas.length;
    }
  }

  /// Cycles the selected tab within the focused area by [delta] positions,
  /// wrapping at the ends.
  void cycleTabInFocusedArea(int delta) {
    final area = focusedArea;
    if (area.tabs.length <= 1) return;

    area.selectedIndex = (area.selectedIndex + delta) % area.tabs.length;
    if (area.selectedIndex < 0) {
      area.selectedIndex += area.tabs.length;
    }
  }

  /// Selects the tab at [index] within the focused area.
  void selectInFocusedArea(int index) {
    final area = focusedArea;
    if (index < 0 || index >= area.tabs.length) return;
    area.selectedIndex = index;
  }

  /// All tabs across every area, in area order then tab order.
  ///
  /// Used by the single-column (narrow) layout, where every area's tabs are
  /// merged into one tab strip.
  List<PaneTab> get allTabs => [for (final area in areas) ...area.tabs];

  /// Index of [focusedTab] within [allTabs], or `-1` when there is none.
  int get focusedTabIndexInAll {
    final tab = focusedTab;
    if (tab == null) return -1;
    return allTabs.indexOf(tab);
  }

  /// Cycles focus across [allTabs] by [delta], wrapping at the ends.
  ///
  /// Unlike [cycleTabInFocusedArea] this crosses area boundaries, for the
  /// merged single-column tab strip.
  void cycleAllTabs(int delta) {
    final all = allTabs;
    if (all.length <= 1) return;
    var index = focusedTabIndexInAll;
    if (index < 0) index = 0;
    index = (index + delta) % all.length;
    if (index < 0) index += all.length;
    focusTab(all[index]);
  }

  /// Focuses the [index]th tab across [allTabs].
  void selectAllTabs(int index) {
    final all = allTabs;
    if (index < 0 || index >= all.length) return;
    focusTab(all[index]);
  }
}
