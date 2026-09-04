import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod_cli/src/util/strip_ansi.dart';

const _newline = 0x0a;
const _carriageReturn = 0x0d;

/// An [IOSink] that splits everything written to it into ANSI-free lines for
/// [_onLine], optionally forwarding the raw writes to another sink unchanged.
class LineSink implements IOSink {
  LineSink(this._onLine, [this._forwardTo]);

  final void Function(String line) _onLine;
  final IOSink? _forwardTo;
  final StringBuffer _lineBuffer = StringBuffer();

  /// Decodes the byte chunks a piped process hands over.
  ///
  /// Chunked and lenient. A pipe splits wherever its buffer did, so a
  /// multi-byte character can straddle two chunks, and a strict decode would
  /// throw a [FormatException] out of the stream listener.
  ///
  /// [encoding] exists for the [IOSink] contract. A process writes UTF-8.
  late final ByteConversionSink _bytes = const Utf8Decoder(
    allowMalformed: true,
  ).startChunkedConversion(_CallbackSink(_record));

  @override
  void add(List<int> data) {
    _forwardTo?.add(data);
    _bytes.add(data);
  }

  /// Forwards text as text, not bytes, so the terminal encodes it exactly
  /// as it would without this sink.
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

  @override
  Future<void> flush() async => _forwardTo?.flush();

  /// Records whatever was written without a trailing newline.
  ///
  /// Never closes [_forwardTo], which outside the TUI is the process's own
  /// stdout or stderr.
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

  /// Splits [text] on newlines, holding back a trailing partial line until the
  /// rest of it arrives.
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

/// Hands each decoded chunk to a callback as it arrives.
///
/// The `dart:convert` callback sinks buffer everything until close, which a
/// log read while the runner runs cannot wait for.
class _CallbackSink implements Sink<String> {
  _CallbackSink(this._onData);

  final void Function(String data) _onData;

  @override
  void add(String data) => _onData(data);

  @override
  void close() {}
}
