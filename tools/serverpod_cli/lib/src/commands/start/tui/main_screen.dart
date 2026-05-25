import 'package:nocterm/nocterm.dart' hide LogEntry;
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_tui/serverpod_tui.dart';

import 'loading_screen.dart';
import 'state.dart';

/// Main screen shown after startup completes.
///
/// Layout:
/// - Bordered box with tab bar + scrollable log view + pinned active operations
/// - Bottom button bar with keyboard shortcuts
class MainScreen extends StatelessComponent {
  const MainScreen({
    super.key,
    required this.state,
    required this.onTabChanged,
    this.showSplash = false,
    required this.logScrollController,
    required this.rawScrollController,
    required this.flutterRawScrollController,
    required this.helpScrollController,
    this.onToggleHelp,
    this.onHotReload,
    this.onHotRestart,
    this.onCreateMigration,
    this.onCreateRepairMigration,
    this.onApplyMigration,
    this.onQuit,
  });

  final ServerWatchState state;
  final ValueChanged<int> onTabChanged;
  final bool showSplash;
  final ScrollController logScrollController;
  final ScrollController rawScrollController;
  final ScrollController flutterRawScrollController;
  final ScrollController helpScrollController;
  final VoidCallback? onToggleHelp;
  final VoidCallback? onHotReload;
  final VoidCallback? onHotRestart;
  final void Function({bool force})? onCreateMigration;
  final void Function({bool force})? onCreateRepairMigration;
  final VoidCallback? onApplyMigration;
  final VoidCallback? onQuit;

  static const _helpBindings = [
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
      'Tabs',
      [
        ('Tab / →', 'Next tab'),
        ('←', 'Previous tab'),
        ('1', 'Log Messages'),
        ('2', 'Raw server output'),
      ],
    ),
    (
      'Actions',
      [
        ('R / Shift+R', 'Hot reload / restart'),
        ('M / Shift+M', 'Create migration (⇧ = force)'),
        ('P / Shift+P', 'Repair migration (⇧ = force)'),
        ('A', 'Apply migrations'),
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    state.contentWidth = constraints.maxWidth;
                    final showSideBySide = state.useSideBySideLayout;

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 1),
                          child: _buildTabBar(st, showSideBySide),
                        ),
                        if (!showSideBySide) ?_buildFlutterStatusLine(st),
                        Expanded(
                          child: !showSideBySide
                              ? _buildTabContent(state.selectedTab)
                              : Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: _buildTabContent(
                                              state.selectedTab,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    VerticalDivider(
                                      color: st.subtleDivider,
                                      width: 1,
                                      thickness: 1,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          ?_buildFlutterStatusLine(
                                            st,
                                            withTitle: false,
                                          ),
                                          Expanded(
                                            child: _buildTabContent(1),
                                          ),
                                        ],
                                      ),
                                    ),
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

  /// Breadcrumb when a Flutter app is attached: horizontal rules, muted
  /// label, vertical divider, and value.
  ///
  /// Returns `null` when no Flutter app is running or starting.
  Component? _buildFlutterStatusLine(
    ServerpodThemeData st, {
    bool withTitle = true,
  }) {
    final mutedText = TextStyle(
      color: st.debugLevel,
      fontWeight: FontWeight.dim,
    );
    final separatorStyle = TextStyle(
      color: st.subtleDivider,
      fontWeight: FontWeight.dim,
    );

    String? value;
    if (state.flutterReady) {
      value = state.flutterUrl ?? 'ready';
    } else {
      value = state.flutterStartupStage;
    }
    if (value == null) return null;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 1),
          child: Row(
            children: [
              if (withTitle) ...[
                Text(' Flutter app', style: mutedText),
                Text(' │ ', style: separatorStyle),
              ],
              Text(value, style: mutedText),
            ],
          ),
        ),
        Divider(color: st.subtleDivider),
      ],
    );
  }

  Component _buildTabBar(ServerpodThemeData st, bool sideBySide) {
    const serverLogs = 'Server logs';
    const rawServerLogs = 'Raw server logs';
    const flutterLogs = 'Flutter logs';

    return !sideBySide
        ? TabBar(
            labels: [
              serverLogs,
              if (state.showFlutterOutput) flutterLogs,
              rawServerLogs,
            ],
            selectedTab: state.selectedTab,
            onTabChanged: onTabChanged,
          )
        : Row(
            children: [
              Expanded(
                child: TabBar(
                  labels: const [serverLogs, rawServerLogs],
                  selectedTab: state.selectedTab == 2 ? 1 : 0,
                  onTabChanged: (index) => onTabChanged(index == 0 ? 0 : 2),
                ),
              ),
              Expanded(
                child: TabBar(
                  labels: const [flutterLogs],
                  selectedTab: 0,
                  onTabChanged: (_) {},
                ),
              ),
            ],
          );
  }

  Component _buildTabContent(int index) {
    return switch (index) {
      1 => _buildRawOutputView(
        state.rawFlutterLines,
        flutterRawScrollController,
      ),
      2 => _buildRawOutputView(state.rawLines, rawScrollController),
      _ => _buildStructuredLogView(),
    };
  }

  Component _buildStructuredLogView() {
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
              return LogMessageWidget(
                key: ValueKey(index),
                entry: item,
              );
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
              // Boot path: [onQuit] is wired only after [WatchLoopReady].
              shutdownTuiApp(0);
            }
          },
        ),
      ],
    );
  }
}
