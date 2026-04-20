import 'dart:async';

import 'package:intl/intl.dart';
import 'package:nocterm/nocterm.dart';

import 'format_duration.dart';
import 'serverpod_theme.dart';
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
    required this.activationKey,
    required this.onActivate,
    this.enabled = true,
  });

  final String name;
  final String activationChar;
  final LogicalKey activationKey;
  final VoidCallback onActivate;
  final bool enabled;

  @override
  Component build(BuildContext context) {
    final st = ServerpodTheme.of(context);

    return Focusable(
      focused: enabled,
      onKeyEvent: (event) {
        if (event.logicalKey == activationKey) {
          onActivate();
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

  final TuiLogEntry entry;

  @override
  Component build(BuildContext context) {
    final st = ServerpodTheme.of(context);

    final levelColor = switch (entry.level) {
      TuiLogLevel.debug => st.debugLevel,
      TuiLogLevel.info => st.infoLevel,
      TuiLogLevel.warning => st.warningLevel,
      TuiLogLevel.error => st.errorLevel,
      TuiLogLevel.fatal => st.errorLevel,
    };

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(entry.level.label, style: TextStyle(color: levelColor)),
        const SizedBox(width: 1),
        Text(
          _timeFormat.format(entry.timestamp.toLocal()),
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
    this.expanded = false,
  });

  final CompletedOperation operation;
  final bool expanded;

  @override
  Component build(BuildContext context) {
    final st = ServerpodTheme.of(context);
    final icon = operation.success ? '✓' : '✗';
    final color = operation.success ? st.success : st.failure;
    final durationStr = formatDuration(operation.duration);
    final showEntries = !operation.success || expanded;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
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
        ),
        if (showEntries && operation.entries.isNotEmpty)
          for (final entry in operation.entries)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Row(
                children: [
                  if (entry.level != null)
                    Text(
                      entry.level!.label,
                      style: TextStyle(
                        color: entry.level == TuiLogLevel.error
                            ? st.errorLevel
                            : st.debugLevel,
                      ),
                    )
                  else
                    Text('query', style: TextStyle(color: st.debugLevel)),
                  const SizedBox(width: 1),
                  Expanded(child: Text(entry.message)),
                  if (entry.duration != null)
                    Text(
                      ' (${formatDuration(Duration(microseconds: (entry.duration! * 1000000).round()))})',
                      style: const TextStyle(fontWeight: FontWeight.dim),
                    ),
                ],
              ),
            ),
      ],
    );
  }
}

// -- TrackedOperationWidget --

/// Renders an active tracked operation with spinner.
class TrackedOperationWidget extends StatefulComponent {
  const TrackedOperationWidget({super.key, required this.operation});

  final TrackedOperation operation;

  @override
  State<TrackedOperationWidget> createState() => _TrackedOperationWidgetState();
}

class _TrackedOperationWidgetState extends State<TrackedOperationWidget> {
  static const _spinnerFrames = '⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏';

  late Timer _timer;
  int _frameIndex = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 80), (_) {
      setState(() => _frameIndex++);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    final st = ServerpodTheme.of(context);
    final op = component.operation;
    final frame = _spinnerFrames[_frameIndex % _spinnerFrames.length];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text('  $frame  ', style: TextStyle(color: st.spinner)),
            const SizedBox(width: 14),
            Expanded(child: Text('${op.label}...')),
          ],
        ),
        // Sub-entries indented
        for (final entry in op.entries)
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Row(
              children: [
                if (entry.level != null)
                  Text(
                    entry.level!.label,
                    style: TextStyle(
                      color: entry.level == TuiLogLevel.error
                          ? st.errorLevel
                          : st.debugLevel,
                    ),
                  )
                else
                  Text(
                    'query',
                    style: TextStyle(color: st.debugLevel),
                  ),
                const SizedBox(width: 1),
                Expanded(child: Text(entry.message)),
                if (entry.duration != null)
                  Text(
                    ' (${formatDuration(Duration(microseconds: (entry.duration! * 1000000).round()))})',
                    style: const TextStyle(fontWeight: FontWeight.dim),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
