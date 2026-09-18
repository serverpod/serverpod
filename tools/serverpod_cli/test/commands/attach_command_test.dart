import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod_cli/src/commands/attach.dart';
import 'package:serverpod_cli/src/commands/start/log_history.dart';
import 'package:serverpod_shared/log.dart';
import 'package:test/test.dart';

void main() {
  group('Given a stack that failed with the pod dead,', () {
    late StartLogHistory history;
    late _RecordingSink out;

    setUp(() {
      history = StartLogHistory();
      out = _RecordingSink();
    });

    test(
      'when the attach session leaves and prints the tail, '
      'then it is the pod\'s raw output, which is where a compile error went',
      () {
        history.recordCliLogEntry(
          LogEntry(
            time: DateTime.utc(2026, 9, 9),
            level: LogLevel.info,
            message: 'Starting server',
            scope: LogScope.root('serverpod'),
          ),
        );
        history.addServerLine("bin/main.dart:3:1: Error: Expected ';'.");
        history.addServerLine('Failed to compile.');

        printLogTail(history, out);

        expect(out.lines, [
          '--- the runner stopped. Its last output was ---',
          "bin/main.dart:3:1: Error: Expected ';'.",
          'Failed to compile.',
        ]);
      },
    );

    test(
      'when the pod never printed anything, '
      'then the runner\'s own entries are the tail',
      () {
        history.recordCliLogEntry(
          LogEntry(
            time: DateTime.utc(2026, 9, 9),
            level: LogLevel.error,
            message: 'Docker is not running.',
            scope: LogScope.root('serverpod'),
          ),
        );

        printLogTail(history, out);

        expect(out.lines, hasLength(2));
        expect(out.lines.last, contains('Docker is not running.'));
      },
    );

    test(
      'when the output is longer than the tail, '
      'then only its end is printed',
      () {
        for (var i = 0; i < 30; i++) {
          history.addServerLine('line $i');
        }

        printLogTail(history, out, lines: 3);

        expect(out.lines, [
          '--- the runner stopped. Its last output was ---',
          'line 27',
          'line 28',
          'line 29',
        ]);
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
