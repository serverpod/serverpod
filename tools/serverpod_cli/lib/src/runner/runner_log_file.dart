import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod_cli/src/runner/log_codec.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_cli/src/util/strip_ansi.dart';
import 'package:serverpod_shared/log.dart' show LogEntry, LogScope, LogWriter;

/// The runner's own log file.
///
/// [ProcessStartMode.detached] leaves the child no streams, so a detached
/// runner writes its output here instead.
///
/// Size-capped and rotated. A client's in-memory history dies with the
/// process, leaving this the only record of a run nobody attached to.
class RunnerLogFile {
  RunnerLogFile({
    required this.path,
    this.maxBytes = defaultMaxBytes,
  });

  /// Opens the log for the server package at [serverDir].
  factory RunnerLogFile.forServer(String serverDir, {int? maxBytes}) =>
      RunnerLogFile(
        path: serverpodRunnerLogPath(serverDir),
        maxBytes: maxBytes ?? defaultMaxBytes,
      );

  /// The size past which the file is rotated.
  ///
  /// One previous generation is kept, as `runner.log.1`.
  static const defaultMaxBytes = 8 * 1024 * 1024;

  final String path;
  final int maxBytes;

  IOSink? _sink;
  int _written = 0;
  bool _rotating = false;

  /// The size at which the next rotation is attempted.
  ///
  /// [maxBytes], except after a rotation that could not rename the file. The
  /// next attempt then waits for another [maxBytes] of output.
  int _rotateAt = 0;

  /// The rotation in flight, so [close] can wait for it rather than racing it
  /// to the sink.
  Future<void>? _rotation;

  /// Lines with nowhere to go yet, flushed once the file is open again.
  ///
  /// Rotation is asynchronous while [writeLine] is not, so without this every
  /// line written across a rotation is lost, including the one that triggered
  /// it.
  final List<String> _pending = [];

  /// How many lines to hold across a rotation before dropping the oldest.
  ///
  /// A bound only a wedged rotation reaches. This runs for days.
  static const _maxPendingLines = 4096;

  /// The path of the single retained previous generation.
  String get previousPath => '$path.1';

  /// Opens the file, appending to whatever a previous run left.
  Future<void> open() async {
    final file = File(path);
    await file.parent.create(recursive: true);
    _written = await file.exists() ? await file.length() : 0;
    _rotateAt = maxBytes;
    _sink = file.openWrite(mode: FileMode.append);
  }

  /// Appends [line], rotating first when the file has grown past [maxBytes].
  ///
  /// ANSI styling is stripped, since nothing renders this file as a terminal.
  void writeLine(String line) {
    _write('${stripAnsi(line)}\n');
  }

  void _write(String text) {
    final sink = _sink;
    if (sink == null || _rotating) {
      _hold(text);
      return;
    }
    final bytes = utf8.encode(text);
    if (_written > 0 && _written + bytes.length > _rotateAt) {
      _hold(text);
      _rotation = _rotate();
      return;
    }
    _written += bytes.length;
    sink.add(bytes);
  }

  void _hold(String text) {
    if (_pending.length >= _maxPendingLines) _pending.removeAt(0);
    _pending.add(text);
  }

  Future<void> _rotate() async {
    if (_rotating) return;
    _rotating = true;
    final sink = _sink;
    _sink = null;
    await sink?.flush();
    await sink?.close();

    var rotated = true;
    try {
      final previous = File(previousPath);
      if (await previous.exists()) await previous.delete();
      await File(path).rename(previousPath);
    } on FileSystemException {
      rotated = false;
    }
    await open();
    if (!rotated) _rotateAt = _written + maxBytes;
    _rotating = false;
    _flushPending();
  }

  /// Writes what was held across a rotation, oldest first.
  void _flushPending() {
    if (_pending.isEmpty) return;
    final held = List.of(_pending);
    _pending.clear();
    for (final text in held) {
      _write(text);
    }
  }

  Future<void> close() async {
    var rotation = _rotation;
    while (rotation != null) {
      _rotation = null;
      await rotation;
      rotation = _rotation;
    }
    final sink = _sink;
    _sink = null;
    final held = List.of(_pending);
    _pending.clear();
    if (sink == null) {
      if (held.isNotEmpty) {
        log.warning(
          '${held.length} lines were lost closing $path: it could not be '
          'reopened after a rotation.',
        );
      }
      return;
    }
    for (final text in held) {
      sink.write(text);
    }
    await sink.flush();
    await sink.close();
  }
}

/// A [LogWriter] that appends the CLI's own log to the runner's log file.
///
/// Paired with the file sinks the pod and the Flutter apps write to, this is
/// what makes a detached runner's output survive the process.
class RunnerLogFileWriter extends LogWriter {
  RunnerLogFileWriter(this._file);

  final RunnerLogFile _file;

  @override
  Future<void> log(LogEntry entry) async {
    _file.writeLine(formatLogEntryLine(entry));
  }

  @override
  Future<void> openScope(LogScope scope) async {
    _file.writeLine(
      '${scope.startTime.toIso8601String()} [SCOPE] ${scope.label} started',
    );
  }

  @override
  Future<void> closeScope(
    LogScope scope, {
    required bool success,
    required Duration duration,
    Object? error,
    StackTrace? stackTrace,
  }) async {
    _file.writeLine(
      '[SCOPE] ${scope.label} '
      '${success ? 'succeeded' : 'failed'} in ${duration.inMilliseconds}ms',
    );
    if (error != null) _file.writeLine('$error');
  }

  @override
  Future<void> close() => _file.close();
}

const _newline = 0x0a;
const _carriageReturn = 0x0d;

/// An [IOSink] that records everything written to it in the runner's log file.
///
/// Used for the pod's stdout and stderr, which are otherwise lost in a runner
/// with no terminal.
class RunnerLogFileSink implements IOSink {
  RunnerLogFileSink(this._file, {String? prefix}) : _prefix = prefix ?? '';

  final RunnerLogFile _file;
  final String _prefix;
  final StringBuffer _lineBuffer = StringBuffer();

  /// Decodes the byte chunks a piped process hands over.
  ///
  /// Chunked and lenient on purpose: the pipe splits wherever its buffer did,
  /// so a multi-byte character straddles two chunks often enough, and a
  /// one-shot strict decode would throw a [FormatException] out of the stream
  /// listener - an unhandled error in a runner with nobody watching. [encoding]
  /// is kept for the [IOSink] contract; what a process writes is UTF-8.
  late final ByteConversionSink _bytes = const Utf8Decoder(
    allowMalformed: true,
  ).startChunkedConversion(_CallbackSink(write));

  @override
  Encoding encoding = systemEncoding;

  @override
  void add(List<int> data) => _bytes.add(data);

  @override
  void write(Object? object) {
    final text = '$object';
    var start = 0;
    for (var i = 0; i < text.length; i++) {
      final unit = text.codeUnitAt(i);
      if (unit != _newline && unit != _carriageReturn) continue;
      if (i > start) _lineBuffer.write(text.substring(start, i));
      if (unit == _newline) _emit();
      start = i + 1;
    }
    if (start < text.length) _lineBuffer.write(text.substring(start));
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
    _file.writeLine('${_prefix}ERROR: $error');
    if (stackTrace != null) _file.writeLine('$stackTrace');
  }

  @override
  Future<void> addStream(Stream<List<int>> stream) => stream.forEach(add);

  @override
  Future<void> flush() async {}

  @override
  Future<void> close() async {
    _bytes.close();
    if (_lineBuffer.isNotEmpty) _emit();
  }

  @override
  Future<void> get done => Future.value();

  void _emit() {
    _file.writeLine('$_prefix$_lineBuffer');
    _lineBuffer.clear();
  }
}

/// Hands each decoded chunk to a callback as it arrives.
///
/// The `dart:convert` sinks that take a callback hold everything until close,
/// which for a log that has to be readable while the runner runs is the wrong
/// end of the trade.
class _CallbackSink implements Sink<String> {
  _CallbackSink(this._onData);

  final void Function(String data) _onData;

  @override
  void add(String data) => _onData(data);

  @override
  void close() {}
}
