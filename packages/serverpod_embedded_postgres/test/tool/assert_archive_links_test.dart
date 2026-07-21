// The fixtures require POSIX hardlinks and symlinks.
@TestOn('!windows')
library;

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  final script = p.absolute('tool/build_postgres/assert-archive-links.sh');

  late Directory fixture;
  late String archivePath;

  Future<ProcessResult> validate({bool forbidSymlinks = false}) => Process.run(
    'bash',
    [script, archivePath, if (forbidSymlinks) '--forbid-symlinks'],
  );

  ProcessResult createTar(
    List<String> entries, {
    bool hardDereference = false,
  }) {
    return Process.runSync('tar', [
      '--format=ustar',
      if (hardDereference) '--hard-dereference',
      '-C',
      fixture.path,
      '-cf',
      archivePath,
      ...entries,
    ]);
  }

  setUp(() {
    fixture = Directory.systemTemp.createTempSync('assert_archive_links_');
    archivePath = p.join(fixture.path, 'bundle.tar');
  });

  tearDown(() {
    if (fixture.existsSync()) fixture.deleteSync(recursive: true);
  });

  test(
    'Given an archive containing a hardlink entry, '
    'when validating the runtime archive contract, '
    'then validation fails naming the hardlink entry.',
    () async {
      var target = File(p.join(fixture.path, 'target'))
        ..writeAsStringSync('content');
      var hardlink = p.join(fixture.path, 'hardlink');
      var linkResult = Process.runSync('ln', [target.path, hardlink]);
      expect(linkResult.exitCode, 0, reason: '${linkResult.stderr}');

      var tarResult = createTar(['target', 'hardlink']);
      expect(tarResult.exitCode, 0, reason: '${tarResult.stderr}');

      var result = await validate();

      expect(result.exitCode, isNot(0));
      expect(result.stderr, contains('forbidden link entries'));
      expect(result.stderr, contains('hardlink'));
    },
  );

  group('Given an archive containing a symbolic-link entry,', () {
    setUp(() {
      File(p.join(fixture.path, 'target')).writeAsStringSync('content');
      Link(p.join(fixture.path, 'symlink')).createSync('target');

      var tarResult = createTar(['target', 'symlink']);
      expect(tarResult.exitCode, 0, reason: '${tarResult.stderr}');
    });

    test(
      'when validating the POSIX runtime archive contract, '
      'then validation succeeds.',
      () async {
        var result = await validate();

        expect(result.exitCode, 0, reason: '${result.stderr}');
      },
    );

    test(
      'when validating the Windows runtime archive contract, '
      'then validation fails naming the symbolic-link entry.',
      () async {
        var result = await validate(forbidSymlinks: true);

        expect(result.exitCode, isNot(0));
        expect(result.stderr, contains('forbidden link entries'));
        expect(result.stderr, contains('symlink'));
      },
    );
  });

  test(
    'Given a stage containing hardlinked files, '
    'when GNU tar materializes them into independent archive files, '
    'then validation succeeds.',
    () async {
      var target = File(p.join(fixture.path, 'target'))
        ..writeAsStringSync('content');
      var hardlink = p.join(fixture.path, 'hardlink');
      var linkResult = Process.runSync('ln', [target.path, hardlink]);
      expect(linkResult.exitCode, 0, reason: '${linkResult.stderr}');

      var tarResult = createTar(
        ['target', 'hardlink'],
        hardDereference: true,
      );
      expect(tarResult.exitCode, 0, reason: '${tarResult.stderr}');

      var result = await validate();

      expect(result.exitCode, 0, reason: '${result.stderr}');
    },
    onPlatform: const {
      'mac-os': Skip('Apple bsdtar has no --hard-dereference option'),
    },
  );
}
