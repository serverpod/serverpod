import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  group('Given a path a file cannot be renamed over,', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('fet');
      await Directory('${tempDir.path}/target').create();
    });

    tearDown(() => tempDir.delete(recursive: true));

    test(
      'when a file is written atomically to it, '
      'then the error propagates and no temp file is left beside it',
      () async {
        final file = File('${tempDir.path}/target');

        await expectLater(
          file.writeAsStringAtomically('contents'),
          throwsA(isA<FileSystemException>()),
        );

        expect(
          tempDir.listSync().map((e) => p.basename(e.path)),
          ['target'],
        );
      },
    );
  });
}
