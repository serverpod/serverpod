import 'dart:convert';
import 'dart:io';

import 'package:serverpod_cli/src/commands/start/flutter_log_event.dart';
import 'package:serverpod_cli/src/commands/start/log_history.dart';
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_tui/serverpod_tui.dart';
import 'package:test/test.dart';
import 'package:vm_service/vm_service.dart';

Event _logEvent(Map<String, Object?> data) {
  return Event(
    kind: EventKind.kExtension,
    timestamp: 0,
    extensionKind: 'ext.serverpod.log',
    extensionData: ExtensionData.parse(data),
  );
}

Event _flutterErrorEvent(Map<String, Object?> data) {
  return Event(
    kind: EventKind.kExtension,
    timestamp: 0,
    extensionKind: 'Flutter.Error',
    extensionData: ExtensionData.parse(data),
  );
}

void main() {
  late StartLogHistory history;

  setUp(() {
    history = StartLogHistory();
  });

  group('Given a log event, when it is recorded,', () {
    setUp(() {
      history.recordServerLogEvent(
        _logEvent({
          'type': 'log',
          'level': 'info',
          'message': 'Server started',
          'timestamp': '2026-04-10T12:00:00.000Z',
        }),
      );
    });

    test('then it is added to the server history.', () {
      expect(history.serverEntries, hasLength(1));
      final entry = history.serverEntries.first as LogEntry;
      expect(entry.message, 'Server started');
      expect(entry.level, LogLevel.info);
      expect(entry.time, DateTime.parse('2026-04-10T12:00:00.000Z'));
    });
  });

  group(
    'Given a warning log event, '
    'when it is recorded,',
    () {
      setUp(() {
        history.recordServerLogEvent(
          _logEvent({
            'type': 'log',
            'level': 'warning',
            'message': 'Slow query',
          }),
        );
      });

      test('then its level is parsed correctly.', () {
        final entry = history.serverEntries.first as LogEntry;
        expect(entry.level, LogLevel.warning);
      });
    },
  );

  group(
    'Given an error log event with error details and stackTrace, '
    'when it is recorded,',
    () {
      setUp(() {
        history.recordServerLogEvent(
          _logEvent({
            'type': 'log',
            'level': 'error',
            'message': 'Failed to apply database migrations.',
            'error':
                'Exception: DB has migration version 20260428173453748 '
                'registered but it is not found in the project files.',
            'stackTrace': '#0      fake (file:///fake.dart:1:1)',
          }),
        );
      });

      test('then the error text and stack trace are stored.', () {
        final entry = history.serverEntries.first as LogEntry;
        expect(entry.level, LogLevel.error);
        expect(entry.message, 'Failed to apply database migrations.');
        expect(
          entry.error,
          'Exception: DB has migration version 20260428173453748 '
          'registered but it is not found in the project files.',
        );
        expect(entry.stackTrace, isNotNull);
        expect(
          entry.stackTrace.toString(),
          '#0      fake (file:///fake.dart:1:1)',
        );
      });
    },
  );

  group(
    'Given a server log event with an empty stack trace, '
    'when it is recorded,',
    () {
      setUp(() {
        history.recordServerLogEvent(
          _logEvent({
            'type': 'log',
            'level': 'error',
            'message': 'Something failed.',
            'stackTrace': '',
          }),
        );
      });

      test('then the retained entry has no stack trace.', () {
        final entry = history.serverEntries.single as LogEntry;
        expect(entry.stackTrace, isNull);
      });
    },
  );

  group(
    'Given a listener on recorded server entries, '
    'when a server log event is recorded,',
    () {
      late List<LogEntry> notified;

      setUp(() {
        notified = [];
        history.onServerEntry = notified.add;
        history.recordServerLogEvent(
          _logEvent({
            'type': 'log',
            'level': 'info',
            'message': 'Server started',
          }),
        );
      });

      test('then the listener receives the recorded entry.', () {
        expect(notified, hasLength(1));
        expect(notified.single.message, 'Server started');
        expect(notified.single, same(history.serverEntries.single));
      });
    },
  );

  group('Given a scope_start event, when it is recorded,', () {
    setUp(() {
      history.recordServerLogEvent(
        _logEvent({
          'type': 'scope_start',
          'id': 'scope_1',
          'label': 'POST /api/user',
        }),
      );
    });

    test('then the scope is tracked as an active operation.', () {
      expect(history.activeOperations, contains('scope_1'));
      expect(history.activeOperations['scope_1']!.label, 'POST /api/user');
    });
  });

  group('Given an INTERNAL scope_start event, when it is recorded,', () {
    setUp(() {
      history.recordServerLogEvent(
        _logEvent({
          'type': 'scope_start',
          'id': 'scope_2',
          'label': 'INTERNAL',
        }),
      );
    });

    test('then it is not tracked as an active operation.', () {
      expect(history.activeOperations, isEmpty);
    });
  });

  group('Given an open server scope,', () {
    setUp(() {
      history.recordServerLogEvent(
        _logEvent({
          'type': 'scope_start',
          'id': 'scope_3',
          'label': 'GET /api/data',
        }),
      );
    });

    test(
      'when a successful scope_end is recorded, '
      'then the scope is retained as a completed operation.',
      () {
        history.recordServerLogEvent(
          _logEvent({
            'type': 'scope_end',
            'id': 'scope_3',
            'success': true,
            'duration': 0.1,
          }),
        );

        expect(history.activeOperations, isEmpty);
        final operation = history.serverEntries.single as CompletedOperation;
        expect(operation.label, 'GET /api/data');
        expect(operation.success, isTrue);
        expect(operation.duration.inMilliseconds, 100);
      },
    );

    test(
      'when a failed scope_end is recorded, '
      'then the completed operation is marked as failed.',
      () {
        history.recordServerLogEvent(
          _logEvent({
            'type': 'scope_end',
            'id': 'scope_3',
            'success': false,
          }),
        );

        final operation = history.serverEntries.single as CompletedOperation;
        expect(operation.success, isFalse);
      },
    );
  });

  group(
    'Given an extension event from another publisher, '
    'when it is recorded as a server event,',
    () {
      setUp(() {
        history.recordServerLogEvent(
          Event(
            kind: EventKind.kExtension,
            timestamp: 0,
            extensionKind: 'ext.other.event',
            extensionData: ExtensionData.parse({'type': 'log'}),
          ),
        );
      });

      test('then nothing is retained.', () {
        expect(history.serverEntries, isEmpty);
      });
    },
  );

  group('Given a Flutter framework error event, when it is recorded,', () {
    const error =
        "'package:flutter/src/widgets/framework.dart': Failed assertion: "
        "line 2168 pos 12: '_elements.contains(element)': is not true.\n"
        'See also: https://docs.flutter.dev/testing/errors';
    late List<(String, LogEntry)> notified;

    setUp(() {
      notified = [];
      history.onFlutterEntry = (appId, entry) => notified.add((appId, entry));
      history.recordFlutterExtensionEvent(
        'serverpod-app',
        _flutterErrorEvent({
          'errorsSinceReload': 0,
          'renderedErrorText': error,
        }),
      );
    });

    test('then the whole error is retained as the app\'s raw lines.', () {
      expect(history.flutterLinesFor('serverpod-app'), error.split('\n'));
    });

    test('then it is reported as one structured entry for the app.', () {
      expect(notified, hasLength(1));
      final (appId, entry) = notified.single;
      expect(appId, 'serverpod-app');
      expect(entry.level, LogLevel.error);
      expect(entry.time, DateTime.fromMillisecondsSinceEpoch(0));
      expect(entry.message, error);
      expect(entry.metadata, {
        'errorsSinceReload': 0,
        'source': 'flutterError',
        'levelIsInferred': false,
        'timestampIsInferred': false,
      });
    });

    test('then the server history is left untouched.', () {
      expect(history.serverEntries, isEmpty);
    });
  });

  group(
    'Given a Flutter framework error event without rendered error text, '
    'when it is recorded,',
    () {
      late List<LogEntry> notified;

      setUp(() {
        notified = [];
        history.onFlutterEntry = (_, entry) => notified.add(entry);
        history.recordFlutterExtensionEvent(
          'serverpod-app',
          _flutterErrorEvent({'errorsSinceReload': 0}),
        );
      });

      test('then it is ignored.', () {
        expect(history.flutterLinesFor('serverpod-app'), isEmpty);
        expect(notified, isEmpty);
      });
    },
  );

  group(
    'Given a Flutter framework error event without an error count, '
    'when it is recorded,',
    () {
      late LogEntry entry;

      setUp(() {
        history.onFlutterEntry = (_, recorded) => entry = recorded;
        history.recordFlutterExtensionEvent(
          'serverpod-app',
          _flutterErrorEvent({'renderedErrorText': 'A framework error'}),
        );
      });

      test('then the reported entry carries no null metadata value.', () {
        expect(entry.metadata, {
          'source': 'flutterError',
          'levelIsInferred': false,
          'timestampIsInferred': false,
        });
      });
    },
  );

  group(
    'Given a Flutter framework error event styled with ANSI codes, '
    'when it is recorded,',
    () {
      late LogEntry entry;

      setUp(() {
        history.onFlutterEntry = (_, recorded) => entry = recorded;
        history.recordFlutterExtensionEvent(
          'serverpod-app',
          _flutterErrorEvent({
            'renderedErrorText': '\x1b[31mA framework error\x1b[0m',
          }),
        );
      });

      test('then the raw lines contain plain text.', () {
        expect(history.flutterLinesFor('serverpod-app'), ['A framework error']);
      });

      test('then the reported entry contains plain text.', () {
        expect(entry.message, 'A framework error');
      });
    },
  );

  group(
    'Given a structured log event from a Flutter app, '
    'when it is recorded,',
    () {
      late LogEntry entry;

      setUp(() {
        history.onFlutterEntry = (_, recorded) => entry = recorded;
        history.recordFlutterExtensionEvent(
          'serverpod-app',
          _logEvent({
            'type': 'log',
            'level': 'warning',
            'message': 'Application warning',
            'timestamp': '2026-07-14T03:00:00.000Z',
          }),
        );
      });

      test('then it is retained as the app\'s raw lines.', () {
        expect(history.flutterLinesFor('serverpod-app'), [
          'Application warning',
        ]);
      });

      test('then it is reported as a structured entry for the app.', () {
        expect(entry.level, LogLevel.warning);
        expect(entry.message, 'Application warning');
      });

      test('then it is kept out of the server history.', () {
        expect(history.serverEntries, isEmpty);
      });
    },
  );

  group('Given output sinks for a Flutter app that is not being rendered,', () {
    late IOSink appStdout;

    setUp(() {
      appStdout = history.flutterOutputSink('serverpod-app');
    });

    test(
      'when complete lines are written, '
      'then each is retained as a raw line of that app.',
      () {
        appStdout.writeln('Launching lib/main.dart');
        appStdout.writeln('Debug service listening');

        expect(history.flutterLinesFor('serverpod-app'), [
          'Launching lib/main.dart',
          'Debug service listening',
        ]);
      },
    );

    test(
      'when a line styled with ANSI codes is written, '
      'then it is retained as plain text.',
      () {
        appStdout.writeln('\x1b[31mBuild failed\x1b[0m');

        expect(history.flutterLinesFor('serverpod-app'), ['Build failed']);
      },
    );

    test(
      'when a partial line is written, '
      'then it is retained only once the line is terminated.',
      () {
        appStdout.write('Resolving ');
        expect(history.flutterLinesFor('serverpod-app'), isEmpty);

        appStdout.writeln('dependencies...');
        expect(history.flutterLinesFor('serverpod-app'), [
          'Resolving dependencies...',
        ]);
      },
    );

    test(
      'when the sink is closed with an unterminated line, '
      'then that line is retained too.',
      () async {
        appStdout.write('Waiting for connection');

        await appStdout.close();

        expect(history.flutterLinesFor('serverpod-app'), [
          'Waiting for connection',
        ]);
      },
    );

    test(
      'when output is written for a second app, '
      'then each app keeps only its own lines.',
      () {
        appStdout.writeln('app one');
        history.flutterOutputSink('other-app').writeln('app two');

        expect(history.flutterLinesFor('serverpod-app'), ['app one']);
        expect(history.flutterLinesFor('other-app'), ['app two']);
      },
    );
  });

  group(
    'Given an output sink for a Flutter app that also writes to the terminal, '
    'when a line is written,',
    () {
      late _CapturingSink terminal;

      setUp(() {
        terminal = _CapturingSink();
        history
            .flutterOutputSink('serverpod-app', forwardTo: terminal)
            .writeln('\x1b[31mBuild failed\x1b[0m');
      });

      test('then the terminal receives it with its styling intact.', () {
        expect(terminal.written, '\x1b[31mBuild failed\x1b[0m\n');
      });

      test('then it is also retained as a raw line of that app.', () {
        expect(history.flutterLinesFor('serverpod-app'), ['Build failed']);
      });
    },
  );

  group(
    'Given a history with server entries, Flutter lines and an open operation, '
    'when it is cleared,',
    () {
      setUp(() {
        history.recordServerLogEvent(
          _logEvent({
            'type': 'scope_start',
            'id': 'scope_1',
            'label': 'Hot reload',
          }),
        );
        history.recordServerLogEvent(
          _logEvent({
            'type': 'log',
            'level': 'info',
            'message': 'Server started',
          }),
        );
        history.addFlutterLine('serverpod-app', 'Launching lib/main.dart');
        history.clear();
      });

      test('then the server entries are dropped.', () {
        expect(history.serverEntries, isEmpty);
      });

      test('then the Flutter lines are dropped.', () {
        expect(history.flutterLinesFor('serverpod-app'), isEmpty);
      });

      test('then the operation still in progress is kept.', () {
        expect(history.activeOperations, contains('scope_1'));
      });
    },
  );

  group(
    'Given a structured log event from a Flutter app carrying a logger name, an error and a stack trace, '
    'when it is recorded,',
    () {
      late LogEntry entry;

      setUp(() {
        history.onFlutterEntry = (_, recorded) => entry = recorded;
        history.recordFlutterLogEvent(
          'serverpod-app',
          FlutterLogEvent(
            time: DateTime.utc(2026, 7, 14, 3),
            level: LogLevel.warning,
            message: 'Connection is slow',
            source: FlutterLogSource.vmLogging,
            loggerName: 'sync',
            error: 'TimeoutException',
            stackTrace: '#0 sync (package:app/sync.dart:10:3)',
          ),
        );
      });

      test(
        'then its severity, timestamp, logger, error and stack trace are preserved.',
        () {
          expect(entry.level, LogLevel.warning);
          expect(entry.time, DateTime.utc(2026, 7, 14, 3));
          expect(entry.message, '[sync] Connection is slow');
          expect(entry.error, 'TimeoutException');
          expect(
            entry.stackTrace.toString(),
            '#0 sync (package:app/sync.dart:10:3)',
          );
          expect(entry.metadata, {
            'source': 'vmLogging',
            'loggerName': 'sync',
            'levelIsInferred': false,
            'timestampIsInferred': false,
          });
        },
      );
    },
  );

  group(
    'Given a Flutter log event styled with ANSI codes, '
    'when it is recorded,',
    () {
      late LogEntry entry;

      setUp(() {
        history.onFlutterEntry = (_, recorded) => entry = recorded;
        history.recordFlutterLogEvent(
          'serverpod-app',
          FlutterLogEvent(
            time: DateTime.utc(2026, 7, 14, 3),
            level: LogLevel.error,
            message: '\x1b[31mFailed\x1b[0m',
            source: FlutterLogSource.processStderr,
            loggerName: '\x1b[33mflutter\x1b[0m',
            error: '\x1b[31mBad state\x1b[0m',
            stackTrace: '\x1b[2m#0 main (app.dart:1)\x1b[0m',
          ),
        );
      });

      test('then its message, error and stack trace contain plain text.', () {
        expect(entry.message, '[flutter] Failed');
        expect(entry.error, 'Bad state');
        expect(entry.stackTrace.toString(), '#0 main (app.dart:1)');
      });
    },
  );

  test(
    'Given the log level name "debug", '
    'when it is parsed, '
    'then debug is returned.',
    () {
      expect(parseLogLevel('debug'), LogLevel.debug);
    },
  );

  test(
    'Given the log level name "info", '
    'when it is parsed, '
    'then info is returned.',
    () {
      expect(parseLogLevel('info'), LogLevel.info);
    },
  );

  test(
    'Given the log level name "warning", '
    'when it is parsed, '
    'then warning is returned.',
    () {
      expect(parseLogLevel('warning'), LogLevel.warning);
    },
  );

  test(
    'Given the log level name "warn", '
    'when it is parsed, '
    'then warning is returned.',
    () {
      expect(parseLogLevel('warn'), LogLevel.warning);
    },
  );

  test(
    'Given the log level name "error", '
    'when it is parsed, '
    'then error is returned.',
    () {
      expect(parseLogLevel('error'), LogLevel.error);
    },
  );

  test(
    'Given the log level name "fatal", '
    'when it is parsed, '
    'then fatal is returned.',
    () {
      expect(parseLogLevel('fatal'), LogLevel.fatal);
    },
  );

  test(
    'Given an unknown log level name, '
    'when it is parsed, '
    'then info is returned.',
    () {
      expect(parseLogLevel('unknown'), LogLevel.info);
    },
  );
}

/// Collects everything written to it, standing in for the process's real
/// stdout/stderr.
class _CapturingSink implements IOSink {
  final StringBuffer _written = StringBuffer();

  String get written => _written.toString();

  @override
  void add(List<int> data) => _written.write(utf8.decode(data));

  @override
  void write(Object? object) => _written.write(object);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
