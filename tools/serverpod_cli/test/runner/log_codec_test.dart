import 'dart:convert';

import 'package:serverpod_cli/src/runner/log_codec.dart';
import 'package:serverpod_shared/log.dart';
import 'package:test/test.dart';

/// Stands in for the `LogType` the CLI logger stashes in every entry's
/// metadata, which `jsonEncode` has no idea what to do with.
class _Opaque {
  @override
  String toString() => 'opaque';
}

void main() {
  group('Given a log entry carrying metadata,', () {
    test(
      'when it holds a value JSON cannot encode, '
      'then encoding carries it as text rather than throwing',
      () {
        final entry = LogEntry(
          time: DateTime.utc(2026),
          level: LogLevel.info,
          message: 'hello',
          scope: LogScope(
            id: 'scope',
            label: 'server',
            startTime: DateTime.utc(2026),
          ),
          metadata: {'logType': _Opaque(), 'alert': true, 'count': 3},
        );

        final encoded = encodeLogHistoryItem(entry);

        expect(() => jsonEncode(encoded), returnsNormally);
        expect(
          (encoded['metadata']! as Map)['logType'],
          'opaque',
        );
        expect((encoded['metadata']! as Map)['alert'], isTrue);
        expect((encoded['metadata']! as Map)['count'], 3);
      },
    );
  });

  group('Given a log entry stamped in UTC,', () {
    test(
      'when it is formatted as a line, '
      'then the time is local',
      () {
        final time = DateTime.utc(2026, 8, 25, 10, 30);
        final line = formatLogEntryLine(
          LogEntry(
            time: time,
            level: LogLevel.info,
            message: 'hello',
            scope: LogScope.root('server'),
          ),
        );

        expect(line, '${time.toLocal().toIso8601String()} [INFO] hello');
      },
    );
  });
}
