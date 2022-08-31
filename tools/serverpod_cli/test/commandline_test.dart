import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import '../bin/create/copier.dart';
import '../bin/create/create.dart';
import '../bin/generated/version.dart';
import '../bin/shared/environment.dart';
import '../bin/util/command_line_tools.dart';
import '../bin/util/process_killer_extension.dart';
import '../bin/util/windows.dart';

Future<void> main() async {
  loadEnvironmentVars();
  serverpodHome = _getProjectRootPath();
  Directory dummyProject = Directory(p.join(Directory.current.path, 'dummy'));
  var clientDir = Directory(p.join(dummyProject.path, 'dummy_client'));
  var serverDir = Directory(p.join(dummyProject.path, 'dummy_server'));
  var flutterDir = Directory(p.join(dummyProject.path, 'dummy_flutter'));
  Directory dest = Directory(p.join(Directory.current.path, 'test', 'dummy'));
  await tearDown([dest, serverDir, flutterDir, clientDir, dummyProject]);
  group('CommandLineTools test', () {
    test('to get command path', () {
      var dartPath = WindowsUtil.commandPath('dart');
      expect(dartPath, isNotNull);
    });
    test('for checking command exists', () async {
      var dartExists = await CommandLineTools.existsCommand('dart');
      expect(dartExists, true);
    });
    test('for checking command exists with extension (Only for windows)',
        () async {
      if (!Platform.isWindows) {
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
    test('Checking flutter create', () async {
      if (await dest.exists()) await dest.delete(recursive: true);
      await dest.create();
      String path = _getProjectRootPath();
      Directory src =
          Directory(p.join(path, 'templates', 'serverpod_templates'));
      var copier = Copier(
        srcDir: Directory(p.join(src.path, 'projectname_flutter')),
        dstDir: dest,
        replacements: [
          Replacement(
            slotName: 'projectname',
            replacement: 'dummy',
          ),
          Replacement(
            slotName: '#^',
            replacement: '^',
          ),
          Replacement(
            slotName: 'VERSION',
            replacement: templateVersion,
          ),
        ],
        fileNameReplacements: [
          Replacement(
            slotName: 'projectname',
            replacement: 'dummy',
          ),
          Replacement(
            slotName: 'gitignore',
            replacement: '.gitignore',
          ),
        ],
        removePrefixes: [],
        ignoreFileNames: [
          'pubspec.lock',
          'ios',
          'android',
          'web',
          'macos',
          'build',
        ],
        verbose: false,
      );
      copier.copyFiles();
      CommandLineTools.flutterCreate(dest);
      var a = Directory(p.join(dest.path, 'lib')).existsSync();
      expect(a, true);
      await tearDown([dest]);
    });
    test(
      'to test serverpod create command',
      () async {
        bool serverDirExists = false;
        bool flutterDirExists = false;
        bool clientDirExists = false;
        if (await dummyProject.exists()) {
          await dummyProject.delete(recursive: true);
        }
        await performCreate('dummy', false, 'server', true);
        if (await clientDir.exists()) {
          clientDirExists = true;
        }
        if (await flutterDir.exists()) {
          flutterDirExists = true;
        }
        if (await serverDir.exists()) {
          serverDirExists = true;
        }
        expect(serverDirExists, true);
        expect(flutterDirExists, true);
        expect(clientDirExists, true);
        await tearDown([dest, serverDir, flutterDir, clientDir, dummyProject]);
      },
      timeout: const Timeout(
        Duration(seconds: 60),
      ),
    );
  });
}

String _getProjectRootPath() {
  List<String> path =
      Directory.current.absolute.path.split(Platform.pathSeparator);
  path.removeLast();
  path.removeLast();
  return p.joinAll(!Platform.isWindows ? ['/', ...path] : path);
}

Future<void> tearDown(List<Directory> directories) async {
  print('Tear down called');
  await Future.delayed(const Duration(seconds: 3), () async {
    for (var directory in directories) {
      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }
    }
  });
}
