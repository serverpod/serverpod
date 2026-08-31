@Tags(['timing'])
library;

import 'dart:math';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the default database cloud storage,', (
    sessionBuilder,
    _,
  ) {
    late Session session;
    const storageId = 'public';

    setUp(() async {
      session = await sessionBuilder.build();
    });

    test(
      'when checking existence of a large file, '
      'then it costs about as much as for a small file',
      () async {
        const smallPath = 'cloud-storage/existence-small.bin';
        const largePath = 'cloud-storage/existence-large.bin';
        final random = Random(1);
        final largeBytes = Uint8List(32 * 1024 * 1024);
        for (var i = 0; i < largeBytes.length; i++) {
          largeBytes[i] = random.nextInt(256);
        }
        await session.storage.storeFile(
          storageId: storageId,
          path: smallPath,
          byteData: ByteData(8),
        );
        await session.storage.storeFile(
          storageId: storageId,
          path: largePath,
          byteData: ByteData.sublistView(largeBytes),
        );

        Future<Duration> timeFileExists(String path) async {
          final stopwatch = Stopwatch()..start();
          for (var i = 0; i < 5; i++) {
            await session.storage.fileExists(storageId: storageId, path: path);
          }
          return stopwatch.elapsed;
        }

        // Warm up so the measured runs don't pay for the first query plan.
        await timeFileExists(smallPath);
        await timeFileExists(largePath);

        final smallElapsed = await timeFileExists(smallPath);
        final largeElapsed = await timeFileExists(largePath);

        expect(
          largeElapsed.inMicroseconds,
          lessThan(smallElapsed.inMicroseconds * 10),
          reason: 'Existence checks should not transfer the file contents.',
        );
      },
    );
  });
}
