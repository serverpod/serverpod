import 'package:nocterm/nocterm.dart' hide LogEntry;
import 'package:serverpod_cli/src/commands/tui/components/log_operation.dart';
import 'package:serverpod_cli/src/commands/tui/state.dart';
import 'package:serverpod_shared/log.dart';

/// Renders structured log entries with active tracked operations
/// stacked at the bottom.
class LogViewerWidget extends StatelessComponent {
  const LogViewerWidget({
    super.key,
    required this.state,
    required this.scrollController,
    this.keyboardScrollable = false,
    this.header,
  });

  final ServerpodState state;
  final ScrollController scrollController;
  final bool keyboardScrollable;
  final Component? header;

  @override
  Component build(BuildContext context) {
    final items = state.logHistory;

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: SelectionArea(
                onSelectionCompleted: (text) {
                  if (text.isNotEmpty) ClipboardManager.copy(text);
                },
                child: Scrollbar(
                  controller: scrollController,
                  thumbVisibility: true,
                  child: ListView.builder(
                    controller: scrollController,
                    reverse: true,
                    keyboardScrollable: keyboardScrollable,
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
              ),
            ),
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
        ?header,
      ],
    );
  }
}
