import 'package:nocterm/nocterm.dart' hide LogEntry;
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_tui/serverpod_tui.dart';

import 'loading_screen.dart';
import 'state.dart';
import 'tab_model.dart';

/// Main screen shown after startup completes.
///
/// Layout:
/// - Bordered box with area panes + scrollable log views + pinned operations
/// - Bottom button bar with keyboard shortcuts
class MainScreen extends StatelessComponent {
  const MainScreen({
    super.key,
    required this.state,
    this.showSplash = false,
    required this.rawScrollController,
    required this.helpScrollController,
    this.onToggleHelp,
    this.onHotReload,
    this.onHotRestart,
    this.onCreateMigration,
    this.onCreateRepairMigration,
    this.onApplyMigration,
    this.onClearLogs,
    this.onLaunchApp,
    this.onTabSelected,
    this.onQuit,
  });

  final ServerWatchState state;
  final bool showSplash;
  final ScrollController rawScrollController;
  final ScrollController helpScrollController;
  final VoidCallback? onToggleHelp;
  final VoidCallback? onHotReload;
  final VoidCallback? onHotRestart;
  final void Function({bool force})? onCreateMigration;
  final void Function({bool force})? onCreateRepairMigration;
  final VoidCallback? onApplyMigration;
  final VoidCallback? onClearLogs;
  final ValueChanged<int>? onLaunchApp;

  /// Invoked after a tab is selected via mouse click so the screen redraws.
  final VoidCallback? onTabSelected;
  final VoidCallback? onQuit;

  List<(String, List<(String, String)>)> get _helpBindings => [
    (
      'Navigation',
      [
        ('G', 'Scroll to top'),
        ('Shift+G', 'Scroll to bottom'),
        ('Tab', 'Switch tabs'),
      ],
    ),
    (
      'Actions',
      [
        if (state.canLaunchApps)
          (
            'Ctrl+R',
            state.launchableApps.length == 1 ? 'Launch app' : 'Launch apps',
          ),
        ('Shift+M', 'Force Create migration'),
        ('Shift+P', 'Force Repair migration'),
        ('E', 'Expand / collapse stack traces'),
        ('S', 'Show raw server logs'),
      ],
    ),
  ];

  @override
  Component build(BuildContext context) {
    final st = ServerpodTheme.of(context);

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BorderedBox(
                child: state.showRawServerLogs
                    ? _buildRawServerLogsPanel(st)
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          state.contentWidth = constraints.maxWidth;

                          return Column(
                            children: [
                              Expanded(
                                child: state.useSideBySideLayout
                                    ? _buildSideBySideLayout(st, constraints)
                                    : _buildMergedColumn(st),
                              ),
                              if (state.activeOperations.isNotEmpty)
                                ...state.activeOperations.values.map(
                                  (op) => TrackedOperationWidget(
                                    key: ValueKey(op.id),
                                    operation: op,
                                  ),
                                ),
                              if (state.alert case final alert?) ...[
                                const SizedBox(height: 1),
                                Divider(color: st.subtleDivider),
                                AlertLine(alert: alert, time: state.alertTime),
                              ],
                            ],
                          );
                        },
                      ),
              ),
            ),
            _buildButtonBar(),
          ],
        ),
        LoadingScreen(visible: showSplash),
        if (state.showHelp)
          HelpOverlay(
            bindings: _helpBindings,
            closeKey: 'Esc',
            controller: helpScrollController,
            closeKey: 'Esc',
          ),
        if (state.showLaunchPanel)
          Positioned(
            top: 0,
            right: 0,
            bottom: 1,
            child: _buildLaunchPanel(st),
          ),
      ],
    );
  }

  Component _buildSideBySideLayout(
    ServerpodThemeData st,
    BoxConstraints constraints,
  ) {
    final tabAreas = state.tabs.areas;
    final tabAreasCount = tabAreas.length;
    final dividerPositionFactor = (1 / tabAreasCount) * 0.99;

    // Stack is used here to position the dividers correctly,
    // removing small gaps between the area panes and dividers.
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < tabAreasCount; i++)
              Expanded(
                flex: tabAreas[i].flex,
                child: _buildAreaPane(st, tabAreas[i], i),
              ),
          ],
        ),
        if (tabAreasCount > 1)
          for (var i = 1; i <= tabAreasCount - 1; i++)
            Positioned(
              key: ValueKey(i),
              left: constraints.maxWidth * dividerPositionFactor * i,
              child: SizedBox(
                height: constraints.maxHeight,
                child: VerticalDivider(
                  color: st.subtleDivider,
                  width: 1,
                  thickness: 1,
                ),
              ),
            ),
      ],
    );
  }

  Component _buildLaunchPanel(ServerpodThemeData st) {
    final apps = state.launchableApps;
    final isRunning = state.isAppRunning;

    // The enterAction tracks the highlighted row: a running app is relaunched, a
    // stopped one is launched — matching what pressing Enter does.
    final focusedIndex = apps.isEmpty
        ? -1
        : state.launchPanelIndex.clamp(0, apps.length - 1);
    final focusedRunning =
        focusedIndex >= 0 && (isRunning?.call(apps[focusedIndex].id) ?? false);
    final enterAction = focusedRunning ? 'Relaunch app' : 'Launch app';

    return Align(
      alignment: Alignment.topRight,
      child: BorderedBox(
        child: SizedBox(
          width: 30,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 1),
                child: Text(
                  'Apps',
                  style: TextStyle(
                    color: st.brightText,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < apps.length; i++)
                      _buildLaunchAppRow(
                        st,
                        i,
                        isRunning,
                        state.isAppLaunching,
                      ),
                    const SizedBox(height: 1),
                    const Tip('Click app to launch'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 1, bottom: 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final (key, desc, enabled) in [
                      ('↑↓', 'Navigate', true),
                      ('Enter', enterAction, true),
                      ('X', 'Stop app', focusedRunning),
                      ('Esc', 'Close', true),
                    ])
                      Row(
                        children: [
                          SizedBox(
                            width: 8,
                            child: Text(
                              key,
                              style: TextStyle(
                                color: enabled
                                    ? st.activationKey
                                    : st.subtleDivider,
                                fontWeight: enabled
                                    ? FontWeight.bold
                                    : FontWeight.dim,
                              ),
                            ),
                          ),
                          Text(
                            desc,
                            style: TextStyle(
                              fontWeight: enabled
                                  ? FontWeight.normal
                                  : FontWeight.dim,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// One launch-panel row: the app's name with a running marker.
  ///
  /// Stopped apps are dimmed, launching apps show an orange marker, running
  /// apps show a green marker, and the cursor row gets a background highlight
  /// (matching the `serverpod create` selection style).
  Component _buildLaunchAppRow(
    ServerpodThemeData st,
    int i,
    bool Function(String appId)? isRunning,
    bool Function(String appId)? isLaunching,
  ) {
    final apps = state.launchableApps;
    final app = apps[i];
    final running = isRunning?.call(app.id) ?? false;
    final launching = isLaunching?.call(app.id) ?? false;
    final active = running || launching;
    final focused = i == state.launchPanelIndex.clamp(0, apps.length - 1);
    final muted = !active && !focused;
    final background = focused ? st.activationKey : null;
    final weight = muted ? FontWeight.dim : FontWeight.normal;
    final foreground = muted ? st.debugLevel : st.brightText;
    final markerColor = launching
        ? st.warningLevel
        : running
        ? st.success
        : st.debugLevel;

    return GestureDetector(
      onTap: () {
        state.launchPanelIndex = i;
        onLaunchApp?.call(i);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 1),
        child: Row(
          children: [
            Text(
              '${active ? '●' : '○'} ',
              style: TextStyle(color: markerColor, fontWeight: weight),
            ),
            Expanded(
              child: Container(
                color: background,
                child: Row(
                  children: [
                    Text(
                      ' ${i < 9 ? '${i + 1}' : ' '}  ',
                      style: TextStyle(
                        color: focused ? st.brightText : st.debugLevel,
                        fontWeight: weight,
                      ),
                    ),
                    Text(
                      app.name,
                      style: TextStyle(
                        color: foreground,
                        fontWeight: weight,
                      ),
                    ),
                    Expanded(child: const SizedBox.shrink()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// A single side-by-side pane: the area's own tab strip over the selected
  /// tab's content. Shown for each area in the wide layout.
  Component _buildAreaPane(ServerpodThemeData st, TabArea area, int areaIndex) {
    final selected = area.selected;
    if (selected == null) {
      // Apps area with nothing launched yet.
      return _buildEmptyAppsPlaceholder(st);
    }

    return Column(
      children: [
        TabBar(
          labels: [for (final tab in area.tabs) tab.label],
          selectedTab: area.selectedIndex.clamp(0, area.tabs.length - 1),
          onTabChanged: (index) {
            area.selectedIndex = index;
            state.tabs.focusedAreaIndex = areaIndex;
            onTabSelected?.call();
          },
        ),
        Expanded(child: _buildTabContent(st, selected)),
      ],
    );
  }

  /// The single-column layout: one tab strip merging every area's tabs
  /// (server + apps), over the focused tab's content.
  Component _buildMergedColumn(ServerpodThemeData st) {
    final all = state.tabs.allTabs;
    if (all.isEmpty) return const SizedBox.shrink();

    final selected = state.tabs.focusedTabIndexInAll.clamp(0, all.length - 1);

    return Column(
      children: [
        TabBar(
          labels: [for (final tab in all) tab.label],
          selectedTab: selected,
          onTabChanged: (index) {
            state.tabs.focusTab(all[index]);
            onTabSelected?.call();
          },
        ),
        Expanded(child: _buildTabContent(st, all[selected])),
      ],
    );
  }

  Component _buildEmptyAppsPlaceholder(ServerpodThemeData st) {
    return Center(
      child: Text(
        state.canLaunchApps
            ? 'No app running · Ctrl+R to launch'
            : 'No app configured',
        style: TextStyle(color: st.debugLevel, fontWeight: FontWeight.dim),
      ),
    );
  }

  Component _buildTabContent(ServerpodThemeData st, PaneTab tab) {
    return switch (tab) {
      ServerLogTab() => _buildStructuredLogView(tab.scrollController),
      AppLogTab appTab => Column(
        children: [
          ?_buildFlutterStatusLine(st, appTab),
          Expanded(
            child: _buildRawOutputView(appTab.lines, appTab.scrollController),
          ),
        ],
      ),
      _ => const SizedBox.shrink(),
    };
  }

  /// Breadcrumb for a Flutter app tab: horizontal rules, muted label, and URL
  /// or startup stage.
  Component? _buildFlutterStatusLine(ServerpodThemeData st, AppLogTab tab) {
    final mutedText = TextStyle(
      color: st.debugLevel,
      fontWeight: FontWeight.dim,
    );
    final separatorStyle = TextStyle(
      color: st.subtleDivider,
      fontWeight: FontWeight.dim,
    );

    String? value;
    if (tab.ready) {
      value = tab.url ?? 'ready';
    } else {
      value = tab.startupStage;
      if (value != null && value.contains('.')) {
        value = value.replaceFirst(RegExp(r'\.+$'), '');
      }
    }
    if (value == null) return null;

    Component child = Row(
      children: [
        Text(' ${tab.label}', style: mutedText),
        Text(' │ ', style: separatorStyle),
        Text(value, style: mutedText),
      ],
    );

    if (!tab.ready & !tab.launchFailed) {
      child = Shimmer(child: child);
    }

    return Column(
      children: [
        Padding(padding: const EdgeInsets.only(left: 1), child: child),
        Divider(color: st.subtleDivider),
      ],
    );
  }

  /// The raw server logs "dev console", shown as a full-area overlay when
  /// toggled via the key S shortcut.
  Component _buildRawServerLogsPanel(ServerpodThemeData st) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 1),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontWeight: FontWeight.dim),
              children: [
                TextSpan(
                  text: 'Raw server logs',
                  style: TextStyle(
                    color: st.brightText,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const TextSpan(text: '  press '),
                TextSpan(
                  text: 'Esc',
                  style: TextStyle(
                    color: st.activationKey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: ' to close'),
              ],
            ),
          ),
        ),
        Divider(color: st.subtleDivider),
        Expanded(
          child: _buildRawOutputView(state.rawLines, rawScrollController),
        ),
      ],
    );
  }

  Component _buildStructuredLogView(ScrollController logScrollController) {
    final items = state.logHistory;

    return SelectionArea(
      onSelectionCompleted: (text) {
        if (text.isNotEmpty) ClipboardManager.copy(text);
      },
      child: Scrollbar(
        controller: logScrollController,
        thumbVisibility: true,
        child: ListView.builder(
          controller: logScrollController,
          reverse: true,
          keyboardScrollable: false,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[items.length - 1 - index];
            if (item is LogEntry) {
              return _buildLogEntry(context, item, index);
            }
            if (item is CompletedOperation) {
              return CompletedOperationWidget(
                key: ValueKey(index),
                operation: item,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /// Renders a single [LogEntry], appending its stack trace - or a collapsed
  /// affordance hinting that one exists - when the entry carries one.
  Component _buildLogEntry(BuildContext context, LogEntry entry, int index) {
    final message = LogMessageWidget(key: ValueKey(index), entry: entry);
    final stackTrace = entry.stackTrace?.toString().trimRight();
    if (stackTrace == null || stackTrace.isEmpty) return message;

    final st = ServerpodTheme.of(context);
    final dim = TextStyle(color: st.debugLevel, fontWeight: FontWeight.dim);

    final trailing = state.expandStackTraces
        ? Text(stackTrace, style: dim)
        : Text(
            '▸ ${stackTrace.split('\n').length}-line stack trace (press e)',
            style: dim,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        message,
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: trailing,
        ),
      ],
    );
  }

  Component _buildRawOutputView(
    BoundedQueueList<String> lines,
    ScrollController controller,
  ) {
    return SelectionArea(
      onSelectionCompleted: (text) {
        if (text.isNotEmpty) ClipboardManager.copy(text);
      },
      child: Scrollbar(
        controller: controller,
        thumbVisibility: true,
        child: ListView.builder(
          controller: controller,
          reverse: true,
          keyboardScrollable: false,
          itemCount: lines.length,
          itemBuilder: (context, index) {
            final line = lines[lines.length - 1 - index];
            return Text(line, key: ValueKey(index));
          },
        ),
      ),
    );
  }

  Component _buildButtonBar() {
    final actionsEnabled = state.serverReady && !state.actionBusy;

    return ButtonBar(
      buttons: [
        // Degraded start: no server is running because the project has errors.
        // The same "R" key rebuilds and starts it once the user has fixed them.
        // Only while degraded - during a normal startup the server is on its
        // way, so the usual (disabled) reload/restart button is shown instead.
        if (state.serverStartable && !state.serverReady)
          Button(
            name: 'Start server',
            activationChar: 'R',
            activationKeys: const [LogicalKey.keyR],
            onActivate: (_) => onHotRestart?.call(),
            enabled: !state.actionBusy && onHotRestart != null,
          )
        // In watch mode the incremental compiler already hot reloads on file
        // changes, so the manual action is a hot restart (with no shift
        // variant, Shift+R restarts too). Without watch, R hot reloads and
        // Shift+R hot restarts.
        else if (state.watchModeEnabled)
          Button(
            name: 'Hot restart',
            activationChar: 'R',
            activationKeys: const [LogicalKey.keyR],
            onActivate: (_) => onHotRestart?.call(),
            enabled: actionsEnabled && onHotRestart != null,
          )
        else
          Button(
            name: 'Hot reload / restart',
            activationChar: 'R',
            activationKeys: const [LogicalKey.keyR],
            onActivate: (_) => onHotReload?.call(),
            onShiftActivate: (_) => onHotRestart?.call(),
            enabled: actionsEnabled && onHotReload != null,
          ),
        Button(
          name: 'Create migration',
          activationChar: 'M',
          activationKeys: const [LogicalKey.keyM],
          onActivate: (_) => onCreateMigration?.call(),
          onShiftActivate: (_) => onCreateMigration?.call(force: true),
          enabled: actionsEnabled && onCreateMigration != null,
        ),
        Button(
          name: 'Repair migration',
          activationChar: 'P',
          activationKeys: const [LogicalKey.keyP],
          onActivate: (_) => onCreateRepairMigration?.call(),
          onShiftActivate: (_) => onCreateRepairMigration?.call(force: true),
          enabled: actionsEnabled && onCreateRepairMigration != null,
        ),
        Button(
          name: 'Apply migrations',
          activationChar: 'A',
          activationKeys: const [LogicalKey.keyA],
          onActivate: (_) => onApplyMigration?.call(),
          enabled: actionsEnabled && onApplyMigration != null,
        ),
        Button(
          name: 'Clear logs',
          activationChar: 'L',
          activationKeys: const [LogicalKey.keyL],
          onActivate: (_) => onClearLogs?.call(),
          enabled: onClearLogs != null,
        ),
        Button(
          name: 'Help',
          activationChar: 'H',
          activationKeys: const [LogicalKey.keyH],
          onActivate: (_) => onToggleHelp?.call(),
          enabled: onToggleHelp != null,
        ),
        Button(
          name: 'Quit',
          activationChar: 'Q',
          activationKeys: const [LogicalKey.keyQ],
          onActivate: (_) {
            if (onQuit != null) {
              onQuit?.call();
            } else {
              shutdownTuiApp(0);
            }
          },
        ),
      ],
    );
  }
}
