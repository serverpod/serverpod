import 'dart:io';

import 'package:test/test.dart';

import '../bin/util/command_line_tools.dart';
import '../bin/util/process_killer_extension.dart';

void main() {
  group('CommandLineTools test', () {
    test('for checking command exists', () async {
      var dartExists = await CommandLineTools.existsCommand('dart');
      expect(dartExists, true);
    });
    test('for checking command exists with extension (Only for windows)',
        () async {
      if (Platform.isWindows) {
        markTestSkipped('Skipping for non-Windows platform');
      } else {
        var dartExeExists = await CommandLineTools.existsCommand('dart.exe');
        expect(dartExeExists, true);
      }
    });
    test('for killing a task', () async {
      var process =
          await Process.start('timeout', ['1000', 'ping', 'serverpod.dev']);
      var isKilled = await process.killAll();
      expect(isKilled, true);
    });
  });
}
