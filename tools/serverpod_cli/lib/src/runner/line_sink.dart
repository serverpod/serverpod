import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod_cli/src/util/strip_ansi.dart';

const _newline = 0x0a;
const _carriageReturn = 0x0d;

/// An [IOSink] that hands ANSI-free lines to [_onLine], forwarding raw writes.
class LineSink implements IOSink {
  LineSink(this._onLine, [this._forwardTo]);

  final void Function(String line) _onLine;
  final IOSink? _forwardTo;
  final StringBuffer _lineBuffer = StringBuffer();

  /// Chunked and lenient, since a pipe can split a multi-byte character.
  late final ByteConversionSink _bytes = const Utf8Decoder(
    allowMalformed: true,
  ).startChunkedConversion(_CallbackSink(_record));

  @override
  void add(List<int> data) {
    _forwardTo?.add(data);
    _bytes.add(data);
  }

  /// Forwards text as text, so the terminal encodes it as usual.
  @override
  void write(Object? object) {
    _forwardTo?.write(object);
    _record('$object');
  }

  @override
  void writeln([Object? object = '']) => write('$object\n');

  @override
  void writeAll(Iterable<Object?> objects, [String separator = '']) =>
      write(objects.join(separator));

  @override
  void writeCharCode(int charCode) => write(String.fromCharCode(charCode));

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    _onLine(stripAnsi('ERROR: $error'));
    if (stackTrace != null) _onLine(stripAnsi('$stackTrace'));
    _forwardTo?.addError(error, stackTrace);
  }

  @override
  Future<void> addStream(Stream<List<int>> stream) => stream.forEach(add);

  /// Ends a partial line, so one pod's leftover never prefixes the next's.
  @override
  Future<void> flush() async {
    if (_lineBuffer.isNotEmpty) _emitLine();
    await _forwardTo?.flush();
  }

  /// Ends a partial line, leaving [_forwardTo] open as it may be stdout.
  @override
  Future<void> close() async {
    _bytes.close();
    if (_lineBuffer.isNotEmpty) _emitLine();
  }

  @override
  Encoding get encoding => utf8;

  @override
  set encoding(Encoding value) {}

  @override
  Future<void> get done => Future.value();

  /// Splits [text] into lines, holding back a trailing partial line.
  void _record(String text) {
    var start = 0;
    for (var i = 0; i < text.length; i++) {
      final unit = text.codeUnitAt(i);
      if (unit != _newline && unit != _carriageReturn) continue;
      if (i > start) _lineBuffer.write(text.substring(start, i));
      if (unit == _newline) _emitLine();
      start = i + 1;
    }
    if (start < text.length) _lineBuffer.write(text.substring(start));
  }

  void _emitLine() {
    _onLine(stripAnsi(_lineBuffer.toString()));
    _lineBuffer.clear();
  }
}

/// Hands each chunk on at once, unlike `dart:convert`'s buffering sinks.
class _CallbackSink implements Sink<String> {
  _CallbackSink(this._onData);

  final void Function(String data) _onData;

  @override
  void add(String data) => _onData(data);

  @override
  void close() {}
}
