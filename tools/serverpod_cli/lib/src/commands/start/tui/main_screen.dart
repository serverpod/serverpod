import 'package:nocterm/nocterm.dart';

import 'components.dart';
import 'help_overlay.dart';
import 'loading_screen.dart';
import 'serverpod_theme.dart';
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
        if (state.showHelp) const HelpOverlay(),
      ],
    );
  }

  Component _buildTabBar(ServerpodThemeData st) {
    const labels = ['Log Messages', 'Raw Output'];
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
            return switch (items[items.length - 1 - index]) {
              TuiLogEntry entry => LogMessageWidget(
                key: ValueKey(index),
                entry: entry,
              ),
              CompletedOperation op => CompletedOperationWidget(
                key: ValueKey(index),
                operation: op,
                expanded: state.expandOperations,
              ),
            };
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

    return Row(
      children: [
        const SizedBox(width: 1),
        Button(
          name: 'Hot Reload',
          activationChar: 'R',
          activationKey: LogicalKey.keyR,
          onActivate: onHotReload ?? () {},
          enabled: actionsEnabled && onHotReload != null,
        ),
        const SizedBox(width: 2),
        Button(
          name: 'Create Migration',
          activationChar: 'M',
          activationKey: LogicalKey.keyM,
          onActivate: onCreateMigration ?? () {},
          enabled: actionsEnabled && onCreateMigration != null,
        ),
        const SizedBox(width: 2),
        Button(
          name: 'Apply Migration',
          activationChar: 'A',
          activationKey: LogicalKey.keyA,
          onActivate: onApplyMigration ?? () {},
          enabled: actionsEnabled && onApplyMigration != null,
        ),
        const SizedBox(width: 2),
        Button(
          name: 'Help',
          activationChar: 'H',
          activationKey: LogicalKey.keyH,
          onActivate: onToggleHelp ?? () {},
          enabled: onToggleHelp != null,
        ),
        const SizedBox(width: 2),
        Button(
          name: 'Quit',
          activationChar: 'Q',
          activationKey: LogicalKey.keyQ,
          onActivate:
              onQuit ??
              () {
                shutdownApp(0);
              },
        ),
      ],
    );
  }
}
