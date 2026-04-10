import 'dart:convert';
import 'dart:io';

import 'app.dart';
import 'state.dart';

/// An [IOSink] implementation that captures server stdout/stderr output
/// and routes it to the TUI's "Raw Output" tab.
class TuiLogSink implements IOSink {
  TuiLogSink(this._holder);

  final AppStateHolder _holder;
  final StringBuffer _lineBuffer = StringBuffer();

  void _addRawLine(String line) {
    final rawLines = _holder.state.rawLines;
    rawLines.addLast(line);
    if (rawLines.length > ServerWatchState.maxRawLines) {
      rawLines.removeFirst();
    }
  }

  @override
  void add(List<int> data) {
    final text = utf8.decode(data, allowMalformed: true);
    for (var i = 0; i < text.length; i++) {
      final char = text[i];
      if (char == '\n') {
        _addRawLine(_lineBuffer.toString());
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
    _addRawLine('ERROR: $error');
    if (stackTrace != null) _addRawLine('$stackTrace');
    _holder.markDirty();
  }

  @override
  Future addStream(Stream<List<int>> stream) => stream.forEach(add);

  @override
  Future flush() async {}

  @override
  Future close() async {
    if (_lineBuffer.isNotEmpty) {
      _addRawLine(_lineBuffer.toString());
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
