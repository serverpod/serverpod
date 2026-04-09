import 'dart:convert';
import 'dart:io';

import 'app.dart';

/// An [IOSink] implementation that captures server stdout/stderr output
/// and routes it to the TUI's "Raw Output" tab.
///
/// Decodes UTF-8 byte chunks into lines, buffering partial lines until a
/// newline is received.
class TuiLogSink implements IOSink {
  TuiLogSink(this._appState);

  final ServerpodWatchAppState _appState;
  final StringBuffer _lineBuffer = StringBuffer();

  @override
  void add(List<int> data) {
    final text = utf8.decode(data, allowMalformed: true);
    for (var i = 0; i < text.length; i++) {
      final char = text[i];
      if (char == '\n') {
        _appState.addRawLine(_lineBuffer.toString());
        _lineBuffer.clear();
      } else if (char != '\r') {
        _lineBuffer.writeCharCode(char.codeUnitAt(0));
      }
    }
  }

  @override
  void write(Object? object) {
    add(utf8.encode('$object'));
  }

  @override
  void writeln([Object? object = '']) {
    write('$object\n');
  }

  @override
  void writeAll(Iterable objects, [String separator = '']) {
    write(objects.join(separator));
  }

  @override
  void writeCharCode(int charCode) {
    add([charCode]);
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    _appState.addRawLine('ERROR: $error');
    if (stackTrace != null) {
      _appState.addRawLine('$stackTrace');
    }
  }

  @override
  Future addStream(Stream<List<int>> stream) {
    return stream.forEach(add);
  }

  @override
  Future flush() async {}

  @override
  Future close() async {
    // Flush any remaining partial line.
    if (_lineBuffer.isNotEmpty) {
      _appState.addRawLine(_lineBuffer.toString());
      _lineBuffer.clear();
    }
  }

  @override
  Encoding get encoding => utf8;

  @override
  set encoding(Encoding value) {
    // Only UTF-8 is supported.
  }

  @override
  Future get done => Future.value();
}
