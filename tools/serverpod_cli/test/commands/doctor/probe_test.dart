import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/doctor/probe.dart';
import 'package:test/test.dart';

/// The Dart VM running these tests, used to run controlled scripts.
final _dart = Platform.resolvedExecutable;

Directory _createTempDirectory() {
  final directory = Directory.systemTemp.createTempSync('serverpod_probe');
  addTearDown(() => directory.deleteSync(recursive: true));
  return directory;
}

String _writeScript(
  final Directory directory,
  final String name,
  final String source,
) {
  final path = p.join(directory.path, name);
  File(path).writeAsStringSync(source);
  return path;
}

void main() {
  test(
    'Given an executable that prints and exits with a code, '
    'when probing, then its exit code and output are returned',
    () async {
      final script = _writeScript(_createTempDirectory(), 'print.dart', '''
import 'dart:io';
void main() {
  stdout.write('out');
  stderr.write('err');
  exit(3);
}
''');

      final result = await runProbe(_dart, [script]);

      expect(result, isNotNull);
      expect(result!.exitCode, 3);
      expect(result.stdout, 'out');
      expect(result.stderr, 'err');
    },
  );

  test(
    'Given an executable that does not exist, '
    'when probing, then null is returned',
    () async {
      final result = await runProbe(
        p.join(_createTempDirectory().path, 'missing'),
        [],
      );

      expect(result, isNull);
    },
  );

  test(
    'Given a wrapper that exits while its child still holds stdout open, '
    'when probing with a timeout, then null is returned once the timeout '
    'passes instead of waiting for the child',
    () async {
      final directory = _createTempDirectory();
      final pidFile = p.join(directory.path, 'child.pid');
      final child = _writeScript(directory, 'child.dart', '''
import 'dart:io';
void main() => sleep(const Duration(seconds: 30));
''');
      // The child inherits the wrapper's stdout, and the wrapper exits
      // without waiting for it. The pid lets the test clean the child up.
      final wrapper = _writeScript(directory, 'wrapper.dart', '''
import 'dart:io';
void main(List<String> args) async {
  final child = await Process.start(
    args[0],
    [args[1]],
    mode: ProcessStartMode.inheritStdio,
  );
  File(args[2]).writeAsStringSync(child.pid.toString());
  exit(0);
}
''');
      addTearDown(() {
        final pid = int.tryParse(
          File(pidFile).existsSync() ? File(pidFile).readAsStringSync() : '',
        );
        if (pid != null) Process.killPid(pid, ProcessSignal.sigkill);
      });

      const timeout = Duration(seconds: 5);
      final stopwatch = Stopwatch()..start();
      final result = await runProbe(
        _dart,
        [wrapper, _dart, child, pidFile],
        timeout: timeout,
      );
      stopwatch.stop();

      expect(result, isNull);
      expect(
        File(pidFile).existsSync(),
        isTrue,
        reason: 'The wrapper should have spawned its child and exited.',
      );
      expect(stopwatch.elapsed, lessThan(timeout * 3));
    },
  );
}
