import 'dart:async';
import 'dart:io';

const _timeoutExitCode = 124;

Future<void> main(List<String> arguments) async {
  final options = _Options.parse(arguments);

  for (var attempt = 1; attempt <= options.attempts; attempt++) {
    stdout.writeln(
      '### Attempt $attempt/${options.attempts}: '
      '${options.command.join(' ')}',
    );

    final result = await _run(options);
    if (result.exitCode == 0) return;

    final isRetriable =
        result.timedOut ||
        options.retryExitCodes.isEmpty ||
        options.retryExitCodes.contains(result.exitCode);
    if (!isRetriable || attempt == options.attempts) {
      exitCode = result.exitCode;
      return;
    }

    final delay = Duration(
      seconds:
          options.delaySeconds *
          (options.backoff == _Backoff.linear ? attempt : 1),
    );
    final reason = result.timedOut
        ? 'timed out after ${options.timeout!.inSeconds} seconds'
        : 'failed with exit code ${result.exitCode}';
    stdout.writeln(
      '### Command $reason; retrying in ${delay.inSeconds} second(s).',
    );
    await Future<void>.delayed(delay);
  }
}

Future<_Result> _run(_Options options) async {
  final process = await Process.start(
    options.command.first,
    options.command.skip(1).toList(),
    workingDirectory: options.workingDirectory,
    mode: ProcessStartMode.inheritStdio,
    runInShell: Platform.isWindows,
  );

  if (options.timeout == null) {
    return _Result(await process.exitCode, timedOut: false);
  }

  final timedOut = Completer<void>();
  final timer = Timer(options.timeout!, timedOut.complete);
  final result = await Future.any<Object?>([
    process.exitCode,
    timedOut.future,
  ]);
  timer.cancel();

  if (result is int) return _Result(result, timedOut: false);

  stderr.writeln(
    '### Command timed out after ${options.timeout!.inSeconds} seconds.',
  );
  await _terminate(process);
  return const _Result(_timeoutExitCode, timedOut: true);
}

Future<void> _terminate(Process process) async {
  if (Platform.isWindows) {
    await Process.run(
      'taskkill',
      ['/PID', '${process.pid}', '/T', '/F'],
      runInShell: true,
    );
  } else {
    final descendants = await _descendantProcessIds(process.pid);
    for (final pid in descendants.reversed) {
      Process.killPid(pid, ProcessSignal.sigterm);
    }
    process.kill(ProcessSignal.sigterm);

    try {
      await process.exitCode.timeout(const Duration(seconds: 2));
      return;
    } on TimeoutException {
      for (final pid in descendants.reversed) {
        Process.killPid(pid, ProcessSignal.sigkill);
      }
      process.kill(ProcessSignal.sigkill);
    }
  }

  try {
    await process.exitCode.timeout(const Duration(seconds: 5));
  } on TimeoutException {
    stderr.writeln(
      '### Timed-out process ${process.pid} did not terminate cleanly.',
    );
  }
}

Future<List<int>> _descendantProcessIds(int rootPid) async {
  final result = await Process.run('ps', ['-eo', 'pid=,ppid=']);
  if (result.exitCode != 0) return const [];

  final childrenByParent = <int, List<int>>{};
  for (final line in (result.stdout as String).split('\n')) {
    final columns = line.trim().split(RegExp(r'\s+'));
    if (columns.length != 2) continue;

    final pid = int.tryParse(columns[0]);
    final parentPid = int.tryParse(columns[1]);
    if (pid == null || parentPid == null) continue;
    childrenByParent.putIfAbsent(parentPid, () => []).add(pid);
  }

  final descendants = <int>[];
  void collect(int parentPid) {
    for (final childPid in childrenByParent[parentPid] ?? const <int>[]) {
      descendants.add(childPid);
      collect(childPid);
    }
  }

  collect(rootPid);
  return descendants;
}

class _Options {
  const _Options({
    required this.attempts,
    required this.backoff,
    required this.delaySeconds,
    required this.retryExitCodes,
    required this.timeout,
    required this.workingDirectory,
    required this.command,
  });

  final int attempts;
  final _Backoff backoff;
  final int delaySeconds;
  final Set<int> retryExitCodes;
  final Duration? timeout;
  final String workingDirectory;
  final List<String> command;

  static _Options parse(List<String> arguments) {
    var attempts = 3;
    var backoff = _Backoff.linear;
    var delaySeconds = 1;
    var retryExitCodes = <int>{};
    var timeoutSeconds = 120;
    var workingDirectory = '.';
    final separator = arguments.indexOf('--');

    if (separator == -1 || separator == arguments.length - 1) {
      _usage('Expected "--" followed by a command.');
    }

    for (var index = 0; index < separator; index++) {
      final argument = arguments[index];
      switch (argument) {
        case '--attempts':
          attempts = _positiveInt(arguments, ++index, argument);
        case '--backoff':
          backoff = _backoff(_value(arguments, ++index, argument));
        case '--delay-seconds':
          delaySeconds = _nonNegativeInt(arguments, ++index, argument);
        case '--retry-exit-codes':
          retryExitCodes = _exitCodes(_value(arguments, ++index, argument));
        case '--timeout-seconds':
          timeoutSeconds = _nonNegativeInt(arguments, ++index, argument);
        case '--working-directory':
          workingDirectory = _value(arguments, ++index, argument);
        default:
          _usage('Unknown option: $argument');
      }
    }

    return _Options(
      attempts: attempts,
      backoff: backoff,
      delaySeconds: delaySeconds,
      retryExitCodes: retryExitCodes,
      timeout: timeoutSeconds == 0 ? null : Duration(seconds: timeoutSeconds),
      workingDirectory: workingDirectory,
      command: arguments.sublist(separator + 1),
    );
  }

  static String _value(
    List<String> arguments,
    int index,
    String option,
  ) {
    if (index >= arguments.length) _usage('Missing value for $option.');
    return arguments[index];
  }

  static int _positiveInt(
    List<String> arguments,
    int index,
    String option,
  ) {
    if (index >= arguments.length) _usage('Missing value for $option.');
    final value = int.tryParse(arguments[index]);
    if (value == null || value < 1) {
      _usage('$option must be a positive integer.');
    }
    return value;
  }

  static int _nonNegativeInt(
    List<String> arguments,
    int index,
    String option,
  ) {
    if (index >= arguments.length) _usage('Missing value for $option.');
    final value = int.tryParse(arguments[index]);
    if (value == null || value < 0) {
      _usage('$option must be a non-negative integer.');
    }
    return value;
  }

  static Set<int> _exitCodes(String value) {
    if (value == 'all') return {};

    final exitCodes = <int>{};
    for (final part in value.split(',')) {
      final exitCode = int.tryParse(part.trim());
      if (exitCode == null || exitCode < 1 || exitCode > 255) {
        _usage(
          '--retry-exit-codes must be "all" or contain integers from 1 to 255.',
        );
      }
      exitCodes.add(exitCode);
    }
    return exitCodes;
  }

  static _Backoff _backoff(String value) {
    return switch (value) {
      'fixed' => _Backoff.fixed,
      'linear' => _Backoff.linear,
      _ => _usage('--backoff must be either "fixed" or "linear".'),
    };
  }

  static Never _usage(String error) {
    stderr
      ..writeln(error)
      ..writeln(
        'Usage: dart run_with_retry.dart '
        '[--attempts N] [--backoff STRATEGY] [--delay-seconds N] '
        '[--retry-exit-codes CODES] [--timeout-seconds N] '
        '[--working-directory PATH] -- COMMAND [ARGUMENTS...]',
      );
    exit(64);
  }
}

enum _Backoff { fixed, linear }

class _Result {
  const _Result(this.exitCode, {required this.timedOut});

  final int exitCode;
  final bool timedOut;
}
