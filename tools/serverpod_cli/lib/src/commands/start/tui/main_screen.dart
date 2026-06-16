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
  final VoidCallback? onQuit;

  List<(String, List<(String, String)>)> get _helpBindings => [
    (
      'Navigation',
      [
        ('↑ / k', 'Scroll up'),
        ('↓ / j / Enter', 'Scroll down'),
        ('Shift+↑', 'Scroll up ¼ screen'),
        ('Shift+↓', 'Scroll down ¼ screen'),
        ('u / Ctrl+u', 'Scroll up ½ screen'),
        ('d / Ctrl+d', 'Scroll down ½ screen'),
        ('PgUp / b / Backspace', 'Scroll up one screen'),
        ('PgDn / Space / f', 'Scroll down one screen'),
        ('Home / g', 'Go to start'),
        ('End / G', 'Go to end'),
      ],
    ),
    (
      'Panes',
      [
        ('← / →', 'Move focus between panes'),
        ('Tab / Shift+Tab', 'Cycle tabs in focused pane'),
        ('1–9', 'Select tab in focused pane'),
      ],
    ),
    (
      'Actions',
      [
        if (state.watchModeEnabled)
          ('R', 'Hot restart')
        else
          ('R / Shift+R', 'Hot reload / restart'),
        if (state.canLaunchApps) ('Ctrl+R', 'Launch app…'),
        ('M / Shift+M', 'Create migration (⇧ = force)'),
        ('P / Shift+P', 'Repair migration (⇧ = force)'),
        ('A', 'Apply migrations'),
        ('e', 'Expand / collapse stack traces'),
        ('` / .', 'Show raw server logs'),
        ('L', 'Clear logs'),
        ('Q', 'Quit'),
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
                                child: state.stackAreasVertically
                                    ? Column(
                                        children: [
                                          for (
                                            var i = 0;
                                            i < state.tabs.areas.length;
                                            i++
                                          ) ...[
                                            if (i > 0)
                                              Divider(color: st.subtleDivider),
                                            Expanded(
                                              child: _buildArea(
                                                st,
                                                state.tabs.areas[i],
                                                i,
                                              ),
                                            ),
                                          ],
                                        ],
                                      )
                                    : Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          for (
                                            var i = 0;
                                            i < state.tabs.areas.length;
                                            i++
                                          ) ...[
                                            if (i > 0)
                                              VerticalDivider(
                                                color: st.subtleDivider,
                                                width: 1,
                                                thickness: 1,
                                              ),
                                            Expanded(
                                              flex: state.tabs.areas[i].flex,
                                              child: _buildArea(
                                                st,
                                                state.tabs.areas[i],
                                                i,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
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
            controller: helpScrollController,
          ),
      ],
    );
  }

  Component _buildArea(ServerpodThemeData st, TabArea area, int areaIndex) {
    final focused = state.tabs.focusedAreaIndex == areaIndex;

    return Column(
      children: [
        if (area.tabs.length >= 2)
          Padding(
            padding: const EdgeInsets.only(left: 1),
            child: TabBar(
              labels: [for (final tab in area.tabs) tab.label],
              selectedTab: area.selectedIndex,
              onTabChanged: (index) {
                area.selectedIndex = index;
                state.tabs.focusedAreaIndex = areaIndex;
              },
            ),
          )
        else if (focused && area.tabs.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 1, top: 1),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                area.tabs.first.label,
                style: TextStyle(
                  color: st.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        Expanded(
          child: area.id == kAppsArea && area.selected == null
              ? _buildEmptyAppsPlaceholder(st)
              : _buildTabContent(st, area.selected!),
        ),
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
      ServerLogTab() => Column(
        children: [
          Expanded(child: _buildStructuredLogView(tab.scrollController)),
        ],
      ),
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
    }
    if (value == null) return null;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 1),
          child: Row(
            children: [
              Text(' ${tab.label}', style: mutedText),
              Text(' │ ', style: separatorStyle),
              Text(value, style: mutedText),
            ],
          ),
        ),
        Divider(color: st.subtleDivider),
      ],
    );
  }

  /// The raw server logs "dev console", shown as a full-area overlay when
  /// toggled via the backtick (`` ` ``) shortcut.
  Component _buildRawServerLogsPanel(ServerpodThemeData st) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 1),
          child: Row(
            children: [
              Text(
                'Raw server logs',
                style: TextStyle(
                  color: st.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                '  press ` / . or Esc to close',
                style: TextStyle(fontWeight: FontWeight.dim),
              ),
            ],
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
        if (state.watchModeEnabled)
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
        if (state.canLaunchApps)
          Button(
            name: 'Launch app…',
            activationChar: 'R',
            activationKeys: const [LogicalKey.keyR],
            onActivate: (_) {},
            enabled: false,
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
