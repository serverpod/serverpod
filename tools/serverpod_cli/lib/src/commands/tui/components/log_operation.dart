import 'package:intl/intl.dart';
import 'package:nocterm/nocterm.dart' hide LogEntry;
import 'package:serverpod_cli/src/commands/tui/components/spinner.dart';
import 'package:serverpod_cli/src/commands/tui/format_duration.dart';
import 'package:serverpod_cli/src/commands/tui/serverpod_theme.dart';
import 'package:serverpod_cli/src/commands/tui/state.dart';
import 'package:serverpod_shared/log.dart';

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

    final body = entry.error == null
        ? entry.message
        : entry.message.isEmpty
        ? entry.error.toString()
        : '${entry.message}\n${entry.error}';

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
        Expanded(child: Text(body)),
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
