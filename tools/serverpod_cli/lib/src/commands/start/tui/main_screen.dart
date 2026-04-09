import 'package:nocterm/nocterm.dart';

import 'components.dart';
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
    this.onHotReload,
    this.onCreateMigration,
    this.onApplyMigration,
    this.onQuit,
  });

  final ServerWatchState state;
  final ValueChanged<int> onTabChanged;
  final VoidCallback? onHotReload;
  final VoidCallback? onCreateMigration;
  final VoidCallback? onApplyMigration;
  final VoidCallback? onQuit;

  @override
  Component build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BorderedBox(
            child: Column(
              children: [
                TuiTabBar(
                  labels: const ['Log Messages', 'Raw Output'],
                  selectedTab: state.selectedTab,
                ),
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
        ),
        _buildButtonBar(),
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
    if (items.isEmpty) {
      return const Center(
        child: Text(
          'Waiting for log messages...',
          style: TextStyle(fontWeight: FontWeight.dim),
        ),
      );
    }

    return ListView.builder(
      reverse: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        // ListView with reverse shows items from the bottom, so we read
        // from the end of the list.
        final item = items[items.length - 1 - index];
        if (item is TuiLogEntry) {
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
    );
  }

  Component _buildRawOutputView() {
    final lines = state.rawLines;
    if (lines.isEmpty) {
      return const Center(
        child: Text(
          'No raw output yet.',
          style: TextStyle(fontWeight: FontWeight.dim),
        ),
      );
    }

    return ListView.builder(
      reverse: true,
      itemCount: lines.length,
      itemBuilder: (context, index) {
        final line = lines[lines.length - 1 - index];
        return Text(line, key: ValueKey(index));
      },
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
