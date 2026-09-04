import 'dart:convert';

import 'package:serverpod_shared/log.dart';
import 'package:test/test.dart';

void main() {
  group('Given a log entry crossing the VM service,', () {
    test(
      'when it is encoded and decoded, '
      'then every field survives',
      () {
        final entry = LogEntry(
          time: DateTime.utc(2026, 8, 25, 11, 5),
          level: LogLevel.warning,
          message: 'Something to note.',
          scope: LogScope(
            id: 'session-42',
            label: 'greeting',
            startTime: DateTime.utc(2026, 8, 25, 11, 4),
          ),
          error: 'boom',
          stackTrace: StackTrace.fromString('#0 main'),
          metadata: const {'attempt': 2},
        );

        final decoded = decodeLogEntry(
          jsonDecode(jsonEncode(encodeLogEntry(entry))) as Map<String, Object?>,
        );

        expect(decoded.time, entry.time);
        expect(decoded.level, LogLevel.warning);
        expect(decoded.message, 'Something to note.');
        expect(decoded.error, 'boom');
        expect(decoded.stackTrace.toString(), contains('#0 main'));
        expect(decoded.metadata, {'attempt': 2});
        expect(decoded.scope.startTime, DateTime.utc(2026, 8, 25, 11, 4));
      },
    );

    test(
      'when it comes from a pod older than the shared codec, '
      'then its timestamp is read rather than replaced with the arrival time',
      () {
        final decoded = decodeLogEntry(const {
          'type': 'log',
          'message': 'From an older pod.',
          'timestamp': '2026-08-25T11:05:00.000Z',
        }, fallbackScopeLabel: 'server');

        expect(decoded.time, DateTime.utc(2026, 8, 25, 11, 5));
        expect(decoded.scope.label, 'server');
      },
    );

    test(
      'when the entry belongs to a session, '
      'then the scope id that correlates it survives',
      () {
        final entry = LogEntry(
          time: DateTime.utc(2026, 8, 25),
          level: LogLevel.info,
          message: 'Query ran.',
          scope: LogScope(
            id: 'session-42',
            label: 'greeting',
            startTime: DateTime.utc(2026, 8, 25),
          ),
        );

        final decoded = decodeLogEntry(encodeLogEntry(entry));

        expect(decoded.scope.id, 'session-42');
        expect(decoded.scope.label, 'greeting');
      },
    );

    test(
      'when the payload carries no scope, '
      'then the caller names the source rather than showing nothing',
      () {
        final decoded = decodeLogEntry(const {
          'type': 'log',
          'message': 'From the pod.',
        }, fallbackScopeLabel: 'server');

        expect(decoded.scope.label, 'server');
        expect(decoded.message, 'From the pod.');
        expect(decoded.level, LogLevel.info);
      },
    );

    test(
      'when the scope carries the empty label a session entry sends, '
      'then the caller names the source rather than showing nothing',
      () {
        final entry = LogEntry(
          time: DateTime.utc(2026, 8, 25),
          level: LogLevel.info,
          message: 'Query ran.',
          scope: LogScope(
            id: 'session-42',
            label: '',
            startTime: DateTime.utc(2026, 8, 25),
          ),
        );

        final decoded = decodeLogEntry(
          encodeLogEntry(entry),
          fallbackScopeLabel: 'server',
        );

        expect(decoded.scope.label, 'server');
        expect(decoded.scope.id, 'session-42');
      },
    );

    test(
      'when metadata holds something jsonEncode cannot take, '
      'then it is carried as text rather than breaking the connection',
      () {
        final entry = LogEntry(
          time: DateTime.utc(2026, 8, 25),
          level: LogLevel.info,
          message: 'With metadata.',
          scope: LogScope.root('server'),
          metadata: {'when': DateTime.utc(2026, 1, 1)},
        );

        final encoded = encodeLogEntry(entry);

        expect(() => jsonEncode(encoded), returnsNormally);
        expect(
          (encoded['metadata']! as Map)['when'],
          contains('2026-01-01'),
        );
      },
    );

    test(
      'when the level is spelled "warn", '
      'then it is not silently demoted to info',
      () {
        expect(parseLogLevel('warn'), LogLevel.warning);
        expect(parseLogLevel('warning'), LogLevel.warning);
        expect(parseLogLevel('nonsense'), LogLevel.info);
        expect(parseLogLevel(null), LogLevel.info);
      },
    );
  });
}
