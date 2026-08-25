import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('Given a process whose stdin is a pipe,', () {
    test(
      'when stdin is probed for terminal modes, '
      'then it is reported as unsupported rather than throwing',
      () async {
        final result = await Process.run(Platform.resolvedExecutable, [
          p.join('test', 'util', 'terminal_modes_probe.dart'),
        ], stdoutEncoding: utf8);

        expect(result.exitCode, 0, reason: result.stderr.toString());
        expect(result.stdout.toString().trim(), 'false');
      },
    );
  });
}
