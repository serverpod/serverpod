import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/create/copier.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';

void main() {
  setUpAll(() {
    initializeLoggerWith(VoidLogger());
  });

  tearDownAll(() async {
    await closeLogger();
  });

  late Directory srcDir;
  late Directory dstDir;

  setUp(() {
    srcDir = Directory.systemTemp.createTempSync('copier_src_');
    dstDir = Directory.systemTemp.createTempSync('copier_dst_');
  });

  tearDown(() {
    srcDir.deleteSync(recursive: true);
    dstDir.deleteSync(recursive: true);
  });

  test(
    'Given a YAML line that ends with a conditionally-remove marker, '
    'when the marker is replaced with an empty string, '
    'then the copied line has no trailing whitespace.',
    () {
      File(p.join(srcDir.path, 'pubspec.yaml')).writeAsStringSync(
        'dependency_overrides: #--CONDITIONALLY_REMOVE_LINE--#\n'
        '  serverpod: #--CONDITIONALLY_REMOVE_LINE--#\n'
        '    path: ../../../packages/serverpod #--CONDITIONALLY_REMOVE_LINE--#\n',
      );

      Copier(
        srcDir: srcDir,
        dstDir: dstDir,
        replacements: const [
          Replacement(
            slotName: '#--CONDITIONALLY_REMOVE_LINE--#',
            replacement: '',
          ),
        ],
        fileNameReplacements: const [],
        processUncommentMarker: false,
      ).copyFiles();

      expect(
        File(p.join(dstDir.path, 'pubspec.yaml')).readAsStringSync(),
        'dependency_overrides:\n'
        '  serverpod:\n'
        '    path: ../../../packages/serverpod\n',
      );
    },
  );

  test(
    'Given a file with a non-empty replacement slot, '
    'when the file is copied, '
    'then the slot is substituted with the replacement value.',
    () {
      File(p.join(srcDir.path, 'pubspec.yaml')).writeAsStringSync(
        'sdk: DART_VERSION\n',
      );

      Copier(
        srcDir: srcDir,
        dstDir: dstDir,
        replacements: const [
          Replacement(
            slotName: 'DART_VERSION',
            replacement: "'^3.12.2'",
          ),
        ],
        fileNameReplacements: const [],
        processUncommentMarker: false,
      ).copyFiles();

      expect(
        File(p.join(dstDir.path, 'pubspec.yaml')).readAsStringSync(),
        "sdk: '^3.12.2'\n",
      );
    },
  );
}
