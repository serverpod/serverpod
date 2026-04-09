import 'dart:isolate';

import 'package:cli_tools/cli_tools.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/commands/generate.dart' as gen;
import 'package:serverpod_cli/src/generator/analyzers.dart';
import 'package:serverpod_cli/src/util/isolated_object.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// An [Analyzers] that runs on a dedicated worker isolate via
/// [IsolatedObject].
///
/// All heavy analysis and code generation work happens off the main isolate,
/// keeping the event loop (and TUI) responsive. Follows the same pattern as
/// [IsolatedLogger].
final class IsolatedAnalyzers extends IsolatedObject<Analyzers>
    implements Analyzers {
  final ReceivePort _logPort;

  IsolatedAnalyzers._(super.create, this._logPort);

  /// Creates and primes analyzers on a worker isolate.
  ///
  /// Log messages from the worker are forwarded to the main isolate's
  /// [log] singleton via a [SendPort].
  static Future<IsolatedAnalyzers> create(GeneratorConfig config) async {
    final logPort = ReceivePort();
    logPort.listen((message) {
      final (LogLevel level, String msg) = message as (LogLevel, String);
      log.log(msg, level);
    });

    final logSendPort = logPort.sendPort;
    final isolated = IsolatedAnalyzers._(
      () {
        // Install a logger on the worker isolate that forwards to main.
        initializeLoggerWith(_PortForwardingLogger(logSendPort));
        return createAndUpdateAnalyzers(config);
      },
      logPort,
    );
    // Wait for the isolate to finish creating + priming the analyzers.
    await isolated.evaluate((_) {});
    return isolated;
  }

  @override
  Future<void> close() async {
    _logPort.close();
    await super.close();
  }

  @override
  Future<GenerateResult> analyzeAndGenerate({
    required GeneratorConfig config,
    required Set<String> affectedPaths,
    bool skipStalenessCheck = false,
    gen.GenerationRequirements requirements = gen.GenerationRequirements.full,
  }) {
    return evaluate(
      (analyzers) => gen.analyzeAndGenerate(
        config: config,
        analyzers: analyzers,
        affectedPaths: affectedPaths,
        skipStalenessCheck: skipStalenessCheck,
        requirements: requirements,
      ),
    );
  }

  // These are not accessible on the isolated proxy - the real instances
  // live on the worker isolate.
  @override
  Never get endpoints => throw UnsupportedError('Use analyzeAndGenerate()');
  @override
  Never get models => throw UnsupportedError('Use analyzeAndGenerate()');
  @override
  Never get futureCalls => throw UnsupportedError('Use analyzeAndGenerate()');
}

/// A lightweight logger that sends messages over a [SendPort] to the
/// main isolate. Used inside the worker isolate.
class _PortForwardingLogger extends Logger {
  final SendPort _port;

  _PortForwardingLogger(this._port) : super(LogLevel.debug);

  @override
  int? get wrapTextColumn => null;

  void _send(LogLevel level, String message) => _port.send((level, message));

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
    _send(LogLevel.info, message);
    return runner();
  }

  @override
  Future<void> flush() async {}
}
