import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod_cli/src/commands/start.dart';
import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:serverpod_shared/log.dart';
import 'package:serverpod_tui/serverpod_tui.dart' show CompletedOperation;
import 'package:test/test.dart';

void main() {
  group('Given a stopped serverpod start session,', () {
    late ServerWatchState state;
    late _RecordingSink out;

    setUp(() {
      state = ServerWatchState();
      out = _RecordingSink();
    });

    test(
      'when printing the log tail, '
      'then raw compile errors take precedence over CLI entries.',
      () {
        state.logHistory.add(
          LogEntry(
            time: DateTime.utc(2026, 9, 9),
            level: LogLevel.info,
            message: 'Starting server',
            scope: LogScope.root('serverpod'),
          ),
        );
        state.rawLines.add("bin/main.dart:3:1: Error: Expected ';'.");
        state.rawLines.add('Failed to compile.');

        printLogTail(state, out, exitCode: 1);

        expect(out.lines, [
          '--- serverpod start stopped (exit code 1). Its last output was ---',
          "bin/main.dart:3:1: Error: Expected ';'.",
          'Failed to compile.',
        ]);
      },
    );

    test(
      'when the pod never printed anything, '
      'then the CLI entries are the tail.',
      () {
        state.logHistory.add(
          LogEntry(
            time: DateTime.utc(2026, 9, 9),
            level: LogLevel.error,
            message: 'Docker is not running.',
            scope: LogScope.root('serverpod'),
          ),
        );

        printLogTail(state, out, exitCode: 1);

        expect(out.lines, hasLength(2));
        expect(out.lines.last, contains('Docker is not running.'));
      },
    );

    test(
      'when no output was recorded, '
      'then no header or tail is printed.',
      () {
        printLogTail(state, out, exitCode: 1);

        expect(out.lines, isEmpty);
      },
    );

    test(
      'when a CLI operation failed before the server printed anything, '
      'then the operation is printed with its result and duration.',
      () {
        state.logHistory.add(
          CompletedOperation(
            label: 'Starting Docker services',
            success: false,
            duration: const Duration(milliseconds: 42),
          ),
        );

        printLogTail(state, out, exitCode: 1);

        expect(out.lines, [
          '--- serverpod start stopped (exit code 1). Its last output was ---',
          '✗ Starting Docker services (42ms)',
        ]);
      },
    );

    test(
      'when the output is longer than the tail, '
      'then only its end is printed.',
      () {
        for (var i = 0; i < 30; i++) {
          state.rawLines.add('line $i');
        }

        printLogTail(state, out, exitCode: 1, lines: 3);

        expect(out.lines, [
          '--- serverpod start stopped (exit code 1). Its last output was ---',
          'line 27',
          'line 28',
          'line 29',
        ]);
      },
    );

    test(
      'when the captured crash entry is excluded from the tail, '
      'then another entry with the same message is retained.',
      () {
        final time = DateTime.utc(2026, 9, 9);
        final crashEntry = LogEntry(
          time: time,
          level: LogLevel.error,
          message: 'Startup failed.',
          scope: LogScope.root('serverpod'),
          stackTrace: StackTrace.fromString('captured crash stack'),
        );
        state.logHistory.addAll([
          LogEntry(
            time: time,
            level: LogLevel.error,
            message: 'Startup failed.',
            scope: LogScope.root('serverpod'),
            stackTrace: StackTrace.fromString('preceding error stack'),
          ),
          crashEntry,
        ]);

        printLogTail(state, out, exitCode: 1, excludedEntry: crashEntry);

        expect(out.lines, [
          '--- serverpod start stopped (exit code 1). Its last output was ---',
          '${time.toLocal().toIso8601String()} [ERROR] Startup failed.\n'
              'preceding error stack',
        ]);
        expect(state.logHistory, hasLength(2));
      },
    );
  });
}

class _RecordingSink implements IOSink {
  final List<String> lines = [];

  @override
  void writeln([Object? object = '']) => lines.add('$object');

  @override
  void write(Object? object) => lines.add('$object');

  @override
  Encoding encoding = utf8;

  @override
  void add(List<int> data) => lines.add(utf8.decode(data));

  @override
  void addError(Object error, [StackTrace? stackTrace]) {}

  @override
  Future<void> addStream(Stream<List<int>> stream) async {}

  @override
  Future<void> close() async {}

  @override
  Future<void> get done => Future.value();

  @override
  Future<void> flush() async {}

  @override
  void writeAll(Iterable<Object?> objects, [String separator = '']) {}

  @override
  void writeCharCode(int charCode) {}
}
