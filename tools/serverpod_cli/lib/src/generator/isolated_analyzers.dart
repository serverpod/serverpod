import 'dart:async';
import 'dart:isolate';

import 'package:cli_tools/cli_tools.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/commands/generate.dart'
    show GenerationRequirements;
import 'package:serverpod_cli/src/generator/analyzers.dart';
import 'package:serverpod_cli/src/util/isolated_object.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

import '../commands/generate.dart';

/// Messages sent from the worker isolate logger to the main isolate.
@pragma('vm:deeply-immutable')
sealed class IsolateLogEvent {
  const IsolateLogEvent();
}

/// A log entry with level and message.
@pragma('vm:deeply-immutable')
final class IsolateLogMessage extends IsolateLogEvent {
  final int levelIndex;
  final String message;
  const IsolateLogMessage(this.levelIndex, this.message);
}

/// Signals the start of a progress operation.
@pragma('vm:deeply-immutable')
final class IsolateProgressStart extends IsolateLogEvent {
  final String label;
  const IsolateProgressStart(this.label);
}

/// Signals the end of a progress operation.
@pragma('vm:deeply-immutable')
final class IsolateProgressEnd extends IsolateLogEvent {
  final String label;
  final bool success;
  const IsolateProgressEnd(this.label, this.success);
}

/// An [Analyzers] that runs on a dedicated worker isolate via
/// [IsolatedObject].
///
/// All heavy analysis and code generation work happens off the main isolate,
/// keeping the event loop (and TUI) responsive. Follows the same pattern as
/// [IsolatedLogger].
final class IsolatedAnalyzers extends IsolatedObject<Analyzers>
    implements Analyzers {
  final ReceivePort _logPort;
  static final _activeProgress = <String, Completer<bool>>{};

  IsolatedAnalyzers._(super.create, this._logPort);

  /// Creates and primes analyzers on a worker isolate.
  ///
  /// Log messages from the worker are forwarded to the main isolate's
  /// [log] singleton via a [SendPort].
  static Future<IsolatedAnalyzers> create(GeneratorConfig config) async {
    final logPort = ReceivePort();
    logPort.listen((message) {
      final event = message as IsolateLogEvent;
      switch (event) {
        case IsolateLogMessage(:final levelIndex, :final message):
          log.log(message, LogLevel.values[levelIndex]);
        case IsolateProgressStart(:final label):
          _activeProgress[label] = Completer<bool>();
          unawaited(
            log.progress(label, () => _activeProgress[label]!.future),
          );
        case IsolateProgressEnd(:final label, :final success):
          _activeProgress.remove(label)?.complete(success);
      }
    });

    final logSendPort = logPort.sendPort;
    final isolated = IsolatedAnalyzers._(
      () {
        // Install a logger on the worker isolate that forwards to main.
        initializeLoggerWith(_PortForwardingLogger(logSendPort));
        return Analyzers.createAndUpdate(config);
      },
      logPort,
    );
    // Wait for the isolate to finish creating + priming the analyzers.
    await isolated.evaluate((_) {});
    return isolated;
  }

  @override
  Future<bool> update({
    required GeneratorConfig config,
    required Set<String> affectedPaths,
    GenerationRequirements requirements = GenerationRequirements.full,
  }) {
    return evaluate(
      (analyzers) => analyzers.update(
        config: config,
        affectedPaths: affectedPaths,
        requirements: requirements,
      ),
    );
  }

  @override
  Future<GenerateResult> performGenerate({
    bool dartFormat = true,
    required GeneratorConfig config,
    GenerationRequirements requirements = GenerationRequirements.full,
    Set<String>? affectedPaths,
  }) {
    return evaluate(
      (analyzers) => analyzers.performGenerate(
        dartFormat: dartFormat,
        config: config,
        requirements: requirements,
        affectedPaths: affectedPaths,
      ),
    );
  }

  @override
  Future<void> close() async {
    _logPort.close();
    await super.close();
  }
}

/// A lightweight logger that sends messages over a [SendPort] to the
/// main isolate. Used inside the worker isolate.
class _PortForwardingLogger extends Logger {
  final SendPort _port;

  _PortForwardingLogger(this._port) : super(LogLevel.debug);

  @override
  int? get wrapTextColumn => null;

  void _send(LogLevel level, String message) =>
      _port.send(IsolateLogMessage(level.index, message));

  @override
  void debug(
    String message, {
    bool newParagraph = false,
    LogType type = TextLogType.normal,
  }) => _send(LogLevel.debug, message);

  @override
  void info(
    String message, {
    bool newParagraph = false,
    LogType type = TextLogType.normal,
  }) => _send(LogLevel.info, message);

  @override
  void warning(
    String message, {
    bool newParagraph = false,
    LogType type = TextLogType.normal,
  }) => _send(LogLevel.warning, message);

  @override
  void error(
    String message, {
    bool newParagraph = false,
    StackTrace? stackTrace,
    LogType type = TextLogType.normal,
  }) => _send(
    LogLevel.error,
    stackTrace != null ? '$message\n$stackTrace' : message,
  );

  @override
  void log(
    String message,
    LogLevel level, {
    bool newParagraph = false,
    LogType type = TextLogType.normal,
  }) => _send(level, message);

  @override
  void write(
    String message,
    LogLevel logLevel, {
    bool newParagraph = false,
    bool newLine = true,
  }) => _send(logLevel, message);

  @override
  Future<bool> progress(
    String message,
    Future<bool> Function() runner, {
    bool newParagraph = false,
  }) async {
    _port.send(IsolateProgressStart(message));
    try {
      final success = await runner();
      _port.send(IsolateProgressEnd(message, success));
      return success;
    } catch (_) {
      _port.send(IsolateProgressEnd(message, false));
      rethrow;
    }
  }

  @override
  Future<void> flush() async {}
}
