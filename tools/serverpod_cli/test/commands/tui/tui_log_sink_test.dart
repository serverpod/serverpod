import 'dart:convert';

import 'package:serverpod_cli/src/commands/start/tui/app.dart';
import 'package:serverpod_cli/src/commands/start/tui/state.dart';
import 'package:serverpod_cli/src/commands/tui/tui_log_sink.dart';
import 'package:test/test.dart';

void main() {
  late ServerWatchState state;
  late StartAppStateHolder holder;
  late TuiLogSink sink;

  setUp(() {
    state = ServerWatchState();
    holder = StartAppStateHolder(state);
    sink = TuiLogSink(holder, addLine: state.rawLines.add);
  });

  group('Given a TuiLogSink', () {
    test('when writing a complete line then adds to rawLines', () {
      sink.add(utf8.encode('hello world\n'));

      expect(state.rawLines, ['hello world']);
    });

    test('when writing multiple lines then adds each to rawLines', () {
      sink.add(utf8.encode('line 1\nline 2\nline 3\n'));

      expect(state.rawLines, ['line 1', 'line 2', 'line 3']);
    });

    test('when writing partial line then buffers until newline', () {
      sink.add(utf8.encode('hel'));

      expect(state.rawLines, isEmpty);

      sink.add(utf8.encode('lo\n'));

      expect(state.rawLines, ['hello']);
    });

    test('when writing with carriage return then strips it', () {
      sink.add(utf8.encode('hello\r\n'));

      expect(state.rawLines, ['hello']);
    });

    test('when closing with partial line then flushes it', () async {
      sink.add(utf8.encode('partial'));

      expect(state.rawLines, isEmpty);

      await sink.close();

      expect(state.rawLines, ['partial']);
    });

    test('when adding error then adds to rawLines', () {
      sink.addError('something broke');

      expect(state.rawLines.first, 'ERROR: something broke');
    });
  });
}
