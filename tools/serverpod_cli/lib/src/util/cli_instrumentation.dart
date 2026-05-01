import 'dart:io';

/// Opt-in tracing for debugging hangs and slow CLI phases.
///
/// Set `SERVERPOD_CLI_INSTRUMENT=1` (also accepts `true` / `yes`, case-insensitive).
/// Lines go to **stderr** with wall time and monotonic elapsed ms so stdout
/// piping and the async logger do not affect visibility.
bool get isCliInstrumentationEnabled {
  final raw = Platform.environment['SERVERPOD_CLI_INSTRUMENT'];
  if (raw == null) return false;
  final v = raw.toLowerCase();
  return v == '1' || v == 'true' || v == 'yes';
}

Stopwatch? _cliInstrumentStopwatch;

void cliInstrument(String phase, [String? detail]) {
  if (!isCliInstrumentationEnabled) return;
  _cliInstrumentStopwatch ??= Stopwatch()..start();
  final elapsedMs = _cliInstrumentStopwatch!.elapsedMilliseconds;
  final wallUtc = DateTime.now().toUtc().toIso8601String();
  final extra = detail == null ? '' : ' | $detail';
  stderr.writeln(
    '[serverpod_cli][instrument] +${elapsedMs}ms $wallUtc | $phase$extra',
  );
}
