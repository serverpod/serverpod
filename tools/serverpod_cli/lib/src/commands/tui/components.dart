import 'package:intl/intl.dart';
import 'package:nocterm/nocterm.dart' hide LogEntry;
import 'package:serverpod_shared/log.dart';

import 'format_duration.dart';
import 'serverpod_theme.dart';
import 'spinner.dart';
import 'state.dart';

// -- BorderedBox --

/// A container with a rounded border and optional title.
class BorderedBox extends StatelessComponent {
  const BorderedBox({super.key, required this.child, this.title, this.color});

  final Component child;
  final BorderTitle? title;
  final Color? color;

  @override
  Component build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.all(
          style: BoxBorderStyle.rounded,
          color: color ?? TuiTheme.of(context).outline,
        ),
        title: title,
      ),
      child: child,
    );
  }
}

// -- Button --

/// A keyboard-activated button with a highlighted activation character.
class Button extends StatelessComponent {
  const Button({
    super.key,
    required this.name,
    required this.activationChar,
    required this.activationKeys,
    required this.onActivate,
    this.enabled = true,
  }) : assert(activationKeys == const [], 'activationKeys can not be empty');

  final String name;
  final String activationChar;
  final List<LogicalKey> activationKeys;
  final void Function(LogicalKey) onActivate;
  final bool enabled;

  @override
  Component build(BuildContext context) {
    final st = ServerpodTheme.of(context);

    return Focusable(
      focused: enabled,
      onKeyEvent: (event) {
        if (activationKeys.contains(event.logicalKey)) {
          onActivate(event.logicalKey);
          return true;
        }
        return false;
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            activationChar,
            style: TextStyle(
              color: enabled ? st.activationKey : st.subtleDivider,
              fontWeight: enabled ? FontWeight.bold : FontWeight.dim,
            ),
          ),
          const Text(' '),
          Text(
            name,
            style: TextStyle(
              fontWeight: enabled ? FontWeight.normal : FontWeight.dim,
            ),
          ),
        ],
      ),
    );
  }
}

// -- Tab title builder --

/// Builds a [BorderTitle] with tab labels for use in [BorderedBox].
/// Selected tab uses reverse style, others are dimmed.
BorderTitle buildTabTitle({
  required List<String> labels,
  required int selectedTab,
  required ServerpodThemeData theme,
}) {
  return BorderTitle.rich(
    textSpan: TextSpan(
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i == selectedTab)
            TextSpan(
              text: ' ${labels[i]} ',
              style: TextStyle(color: theme.activeTab, reverse: true),
            )
          else
            TextSpan(
              text: ' ${labels[i]} ',
              style: const TextStyle(fontWeight: FontWeight.dim),
            ),
        ],
      ],
    ),
  );
}

final _timeFormat = DateFormat('HH:mm:ss.SSS');

// -- LogMessageWidget --

/// Renders a single structured log entry.
class LogMessageWidget extends StatelessComponent {
  const LogMessageWidget({super.key, required this.entry});

  final LogEntry entry;

  static const _levelLabels = {
    LogLevel.debug: 'debug',
    LogLevel.info: 'info ',
    LogLevel.warning: 'warn ',
    LogLevel.error: 'error',
    LogLevel.fatal: 'fatal',
  };

  @override
  Component build(BuildContext context) {
    final st = ServerpodTheme.of(context);

    final levelColor = switch (entry.level) {
      LogLevel.debug => st.debugLevel,
      LogLevel.info => st.infoLevel,
      LogLevel.warning => st.warningLevel,
      LogLevel.error || LogLevel.fatal => st.errorLevel,
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _levelLabels[entry.level] ?? entry.level.name,
          style: TextStyle(color: levelColor),
        ),
        const SizedBox(width: 1),
        Text(
          _timeFormat.format(entry.time.toLocal()),
          style: const TextStyle(fontWeight: FontWeight.dim),
        ),
        const SizedBox(width: 1),
        Expanded(child: Text(entry.message)),
      ],
    );
  }
}

// -- CompletedOperationWidget --

/// Renders a completed tracked operation as a left-aligned log-style line
/// with a trailing divider.
class CompletedOperationWidget extends StatelessComponent {
  const CompletedOperationWidget({
    super.key,
    required this.operation,
  });

  final CompletedOperation operation;

  @override
  Component build(BuildContext context) {
    final st = ServerpodTheme.of(context);
    final icon = operation.success ? '✓' : '✗';
    final color = operation.success ? st.success : st.failure;
    final durationStr = formatDuration(operation.duration);

    return Row(
      children: [
        Text('  $icon  ', style: TextStyle(color: color)),
        const SizedBox(width: 1),
        Text(
          _timeFormat.format(operation.completedAt.toLocal()),
          style: const TextStyle(fontWeight: FontWeight.dim),
        ),
        const SizedBox(width: 1),
        Text(
          '${operation.label} ($durationStr) ',
          style: TextStyle(color: color),
        ),
        Expanded(child: Divider(color: st.subtleDivider)),
      ],
    );
  }
}

// -- TrackedOperationWidget --

/// Renders an active tracked operation with spinner.
///
/// The spinner frame is driven by a shared [SpinnerScope] higher in the
/// tree, so any number of concurrent tracked operations share a single
/// animation controller - one 80ms tick for all of them.
class TrackedOperationWidget extends StatelessComponent {
  const TrackedOperationWidget({super.key, required this.operation});

  final TrackedOperation operation;

  @override
  Component build(BuildContext context) {
    final st = ServerpodTheme.of(context);

    return Row(
      children: [
        const Text('  '),
        SpinnerIcon(color: st.spinner),
        const Text('  '),
        const SizedBox(width: 14),
        Expanded(child: Text('${operation.label}...')),
      ],
    );
  }
}

// -- LogViewerWidget --

/// Renders structured log entries with active tracked operations
/// stacked at the bottom.
class LogViewerWidget extends StatelessComponent {
  const LogViewerWidget({
    super.key,
    required this.state,
    required this.scrollController,
    this.header,
  });

  final ServerpodState state;
  final ScrollController scrollController;
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

// -- RadioButton --

/// Renders a radio button component
class RadioButton extends StatelessComponent {
  const RadioButton({
    required this.label,
    required this.focused,
    required this.value,
    this.enabled = true,
  });

  final bool value;
  final bool focused;
  final String label;

  /// When false, the option is shown dimmed and must not receive focus
  /// in navigation logic.
  final bool enabled;

  @override
  Component build(BuildContext context) {
    final st = ServerpodTheme.of(context);
    final indicator = value ? '◉' : '○';
    final Color? color = enabled ? null : st.subtleDivider;
    final style = TextStyle(
      color: color,
      fontWeight: enabled
          ? (focused ? FontWeight.normal : FontWeight.dim)
          : FontWeight.dim,
    );

    return Row(
      children: [
        Text(indicator, style: style),
        const SizedBox(width: 2),
        Text(label, style: style),
      ],
    );
  }
}
