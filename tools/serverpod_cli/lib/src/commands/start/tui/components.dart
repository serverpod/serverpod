import 'dart:async';

import 'package:intl/intl.dart';
import 'package:nocterm/nocterm.dart';

import 'format_duration.dart';
import 'state.dart';

// -- BorderedBox --

/// A container with a rounded border.
class BorderedBox extends StatelessComponent {
  const BorderedBox({super.key, required this.child});

  final Component child;

  @override
  Component build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.all(style: BoxBorderStyle.rounded),
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
              color: enabled ? Colors.magenta : Colors.gray,
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

// -- TabBar --

/// A terminal-style tab bar.
class TuiTabBar extends StatelessComponent {
  const TuiTabBar({
    super.key,
    required this.labels,
    required this.selectedTab,
  });

  final List<String> labels;
  final int selectedTab;

  @override
  Component build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          Text(
            labels[i],
            style: TextStyle(
              fontWeight: i == selectedTab ? FontWeight.normal : FontWeight.dim,
              color: i == selectedTab ? Colors.magenta : null,
              decoration: i == selectedTab ? TextDecoration.underline : null,
            ),
          ),
          if (i < labels.length - 1) const Text('  '),
        ],
        Expanded(child: const Divider()),
      ],
    );
  }
}

// -- LogMessageWidget --

/// Renders a single structured log entry.
class LogMessageWidget extends StatelessComponent {
  const LogMessageWidget({super.key, required this.entry});

  static final _timeFormat = DateFormat('HH:mm:ss');

  final TuiLogEntry entry;

  @override
  Component build(BuildContext context) {
    final levelColor = switch (entry.level) {
      TuiLogLevel.debug => Colors.gray,
      TuiLogLevel.info => Colors.blue,
      TuiLogLevel.warning => Colors.yellow,
      TuiLogLevel.error => Colors.red,
      TuiLogLevel.fatal => Colors.brightRed,
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

/// Renders a completed tracked operation as a divider-style summary line.
class CompletedOperationWidget extends StatelessComponent {
  const CompletedOperationWidget({super.key, required this.operation});

  final CompletedOperation operation;

  @override
  Component build(BuildContext context) {
    final icon = operation.success ? '✓' : '✗';
    final color = operation.success ? Colors.green : Colors.red;
    final durationStr = formatDuration(operation.duration);
    final label = ' $icon ${operation.label} ($durationStr) ';

    return Stack(
      children: [
        const Divider(),
        Center(
          child: Text(label, style: TextStyle(color: color)),
        ),
      ],
    );
  }
}

// -- TrackedOperationWidget --

/// Renders an active tracked operation with spinner and live duration.
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
    final op = component.operation;
    final durationStr = formatDuration(op.stopwatch.elapsed);
    final frame = _spinnerFrames[_frameIndex % _spinnerFrames.length];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(' $frame ', style: const TextStyle(color: Colors.cyan)),
            Expanded(
              child: Text('${op.label}... ($durationStr)'),
            ),
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
                          ? Colors.red
                          : Colors.gray,
                    ),
                  )
                else
                  const Text(
                    'query',
                    style: TextStyle(color: Colors.gray),
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
