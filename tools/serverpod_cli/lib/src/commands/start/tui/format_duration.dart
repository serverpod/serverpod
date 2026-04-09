// Vendored from tuid
// SPDX-License-Identifier: BSD-3-Clause

/// Format a duration with dynamic units (μs/ms/s/m).
String formatDuration(Duration duration) {
  final us = duration.inMicroseconds;
  if (us < 1000) return '$usμs';

  final ms = duration.inMilliseconds;
  if (ms < 1000) return '${ms}ms';

  final s = duration.inSeconds;
  if (s < 10) {
    final ds = (ms % 1000) ~/ 100;
    return '$s.${ds}s';
  }
  if (s < 60) return '${s}s';

  final m = duration.inMinutes;
  if (m < 10) {
    final rs = duration.inSeconds % 60;
    return '${m}m${rs < 10 ? '0$rs' : '$rs'}s';
  }
  if (m < 60) return '${m}m';

  final h = duration.inHours;
  final rm = duration.inMinutes % 60;
  return '${h}h${rm}m';
}
