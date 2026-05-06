import 'package:nocterm/nocterm.dart' hide LogEntry;
import 'package:serverpod_cli/src/commands/tui/components.dart';
import 'package:serverpod_cli/src/commands/tui/run_app.dart';
import 'package:serverpod_cli/src/commands/tui/serverpod_theme.dart';
import 'package:serverpod_cli/src/commands/tui/state.dart';
import 'package:serverpod_shared/log.dart';

import '../../tui/help_overlay.dart';
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
    required this.helpScrollController,
    this.onToggleHelp,
    this.onHotReload,
    this.onCreateMigration,
    this.onApplyMigration,
    this.onQuit,
  });

  final ServerWatchState state;
  final ValueChanged<int> onTabChanged;
  final bool showSplash;
  final ScrollController logScrollController;
  final ScrollController rawScrollController;
  final ScrollController helpScrollController;
  final VoidCallback? onToggleHelp;
  final VoidCallback? onHotReload;
  final VoidCallback? onCreateMigration;
  final VoidCallback? onApplyMigration;
  final VoidCallback? onQuit;

  @override
  Component build(BuildContext context) {
    final st = ServerpodTheme.of(context);

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  BorderedBox(
                    color: st.activeTab,
                    child: Column(
                      children: [
                        Expanded(child: _buildTabContent()),
                        // Pinned active operations
                        if (state.activeOperations.isNotEmpty) ...[
                          for (final op in state.activeOperations.values)
                            TrackedOperationWidget(
                              key: ValueKey(op.id),
                              operation: op,
                            ),
                        ],
                      ],
                    ),
                  ),
                  // Tab labels overlaid on top border, offset past the corner.
                  Padding(
                    padding: const EdgeInsets.only(left: 1),
                    child: _buildTabBar(st),
                  ),
                ],
              ),
            ),
            _buildButtonBar(),
          ],
        ),
        LoadingScreen(visible: showSplash),
        if (state.showHelp) HelpOverlay(controller: helpScrollController),
      ],
    );
  }

  Component _buildTabBar(ServerpodThemeData st) {
    const labels = ['Log Messages', 'Raw server output'];
    return Row(
      children: [
        for (var i = 0; i < labels.length; i++)
          if (i == state.selectedTab) ...[
            Text('▐', style: TextStyle(color: st.activeTab)),
            Text(
              labels[i],
              style: TextStyle(color: st.activeTab, reverse: true),
            ),
            Text('▌─', style: TextStyle(color: st.activeTab)),
          ] else ...[
            Text(' ', style: TextStyle(color: st.activeTab)),
            Text(labels[i], style: const TextStyle(fontWeight: FontWeight.dim)),
            Text(' ─', style: TextStyle(color: st.activeTab)),
          ],
      ],
    );
  }

  Component _buildTabContent() {
    if (state.selectedTab == 0) {
      return _buildStructuredLogView();
    }
    return _buildRawOutputView();
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

  Component _buildRawOutputView() {
    final lines = state.rawLines;

    return SelectionArea(
      onSelectionCompleted: (text) {
        if (text.isNotEmpty) ClipboardManager.copy(text);
      },
      child: Scrollbar(
        controller: rawScrollController,
        thumbVisibility: true,
        child: ListView.builder(
          controller: rawScrollController,
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
          name: 'Hot Reload',
          activationChar: 'R',
          activationKeys: const [LogicalKey.keyR],
          onActivate: (_) {
            onHotReload?.call();
          },
          enabled: actionsEnabled && onHotReload != null,
        ),
        Button(
          name: 'Create Migration',
          activationChar: 'M',
          activationKeys: const [LogicalKey.keyM],
          onActivate: (_) {
            onCreateMigration?.call();
          },
          enabled: actionsEnabled && onCreateMigration != null,
        ),
        Button(
          name: 'Apply Migration',
          activationChar: 'A',
          activationKeys: const [LogicalKey.keyA],
          onActivate: (_) {
            onApplyMigration?.call();
          },
          enabled: actionsEnabled && onApplyMigration != null,
        ),
        Button(
          name: 'Help',
          activationChar: 'H',
          activationKeys: const [LogicalKey.keyH],
          onActivate: (_) {
            onToggleHelp?.call();
          },
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
              restoreServerpodTerminal();
              shutdownApp(0);
            }
          },
        ),
      ],
    );
  }
}
