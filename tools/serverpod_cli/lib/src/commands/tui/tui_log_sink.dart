import 'dart:convert';
import 'dart:io';

import 'package:serverpod_cli/src/commands/tui/app_state_holder.dart';
import 'package:serverpod_cli/src/util/strip_ansi.dart';

/// An [IOSink] implementation that captures server stdout/stderr output
/// and routes it to [addLine].
/// The output is typically routed to the TUI's "Raw server output" tab
/// or "Flutter output" tab.
class TuiLogSink implements IOSink {
  TuiLogSink(this._holder, {required this.addLine});

  final ServerpodAppStateHolder _holder;
  final void Function(String) addLine;

  final StringBuffer _lineBuffer = StringBuffer();

  @override
  void add(List<int> data) {
    final text = utf8.decode(data, allowMalformed: true);
    for (var i = 0; i < text.length; i++) {
      final char = text[i];
      if (char == '\n') {
        addLine(stripAnsi(_lineBuffer.toString()));
        _lineBuffer.clear();
        _holder.markDirty();
      } else if (char != '\r') {
        _lineBuffer.writeCharCode(char.codeUnitAt(0));
      }
    }
  }

  @override
  void write(Object? object) => add(utf8.encode('$object'));

  @override
  void writeln([Object? object = '']) => write('$object\n');

  @override
  void writeAll(Iterable objects, [String separator = '']) =>
      write(objects.join(separator));

  @override
  void writeCharCode(int charCode) => add([charCode]);

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    addLine(stripAnsi('ERROR: $error'));
    if (stackTrace != null) {
      addLine(stripAnsi('$stackTrace'));
    }
    _holder.markDirty();
  }

  @override
  Future addStream(Stream<List<int>> stream) => stream.forEach(add);

  @override
  Future flush() async {}

  @override
  Future close() async {
    if (_lineBuffer.isNotEmpty) {
      addLine(stripAnsi(_lineBuffer.toString()));
      _lineBuffer.clear();
      _holder.markDirty();
    }
  }

  @override
  Encoding get encoding => utf8;

  @override
  set encoding(Encoding value) {}

  @override
  Future get done => Future.value();
}
