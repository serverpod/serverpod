import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the default database cloud storage', (
    sessionBuilder,
    _,
  ) {
    late Session session;
    const storageId = 'public';

    setUp(() async {
      session = await sessionBuilder.build();
    });

    test(
      'when statFile is called for a file with metadata, '
      'then it returns the stored metadata',
      () async {
        const path = 'cloud-storage/stat.txt';
        await session.storage.storeFile(
          storageId: storageId,
          path: path,
          byteData: ByteData.sublistView(Uint8List.fromList([1, 2, 3])),
          options: const StoreFileOptions(
            metadata: FileMetadata(
              contentType: 'text/custom',
              cacheControl: 'max-age=60',
              contentDisposition: 'inline',
              contentEncoding: 'gzip',
              custom: {'tenant': 'acme'},
            ),
          ),
        );

        final stat = await session.storage.statFile(
          storageId: storageId,
          path: path,
        );

        expect(stat.size, 3);
        expect(stat.contentType, 'text/custom');
        expect(stat.cacheControl, 'max-age=60');
        expect(stat.contentDisposition, 'inline');
        expect(stat.contentEncoding, 'gzip');
        expect(stat.custom, {'tenant': 'acme'});
      },
    );

    test(
      'when retrieving an expired file, '
      'then it throws a CloudStorageFileNotFoundException',
      () async {
        const path = 'cloud-storage/expired.txt';
        await session.storage.storeFile(
          storageId: storageId,
          path: path,
          byteData: ByteData(1),
          options: StoreFileOptions(
            expiration: DateTime.now().toUtc().subtract(
              const Duration(seconds: 1),
            ),
          ),
        );

        expect(
          () => session.storage.retrieveFile(storageId: storageId, path: path),
          throwsA(isA<CloudStorageFileNotFoundException>()),
        );
      },
    );

    test(
      'when storing an existing file with preventOverwrite enabled, '
      'then it throws and preserves the existing file',
      () async {
        const path = 'cloud-storage/prevent-overwrite.txt';
        await session.storage.storeFile(
          storageId: storageId,
          path: path,
          byteData: ByteData.sublistView(Uint8List.fromList([1])),
        );

        expect(
          () => session.storage.storeFile(
            storageId: storageId,
            path: path,
            byteData: ByteData.sublistView(Uint8List.fromList([2])),
            options: const StoreFileOptions(preventOverwrite: true),
          ),
          throwsA(isA<CloudStorageFileAlreadyExistsException>()),
        );
        final data = await session.storage.retrieveFile(
          storageId: storageId,
          path: path,
        );
        expect(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
          [1],
        );
      },
    );

    test(
      'when temporaryDownloadUrl is called for an existing file, '
      'then it returns a temporary token URL',
      () async {
        const path = 'cloud-storage/temporary.txt';
        await session.storage.storeFile(
          storageId: storageId,
          path: path,
          byteData: ByteData(1),
        );

        final url = await session.storage.temporaryDownloadUrl(
          storageId: storageId,
          path: path,
          options: const TemporaryDownloadUrlOptions(
            expirationDuration: Duration(minutes: 5),
            downloadFileName: 'download.txt',
            contentType: 'text/plain',
          ),
        );

        expect(url.queryParameters['method'], 'temporaryFile');
        expect(url.queryParameters['storage'], storageId);
        expect(url.queryParameters['path'], path);
        expect(url.queryParameters['key'], isNotEmpty);
      },
    );

    test(
      'when publicDownloadUrls includes a missing file, '
      'then it retains the successful results',
      () async {
        const firstPath = 'cloud-storage/public-list-first.txt';
        const secondPath = 'cloud-storage/public-list-second.txt';
        await session.storage.storeFile(
          storageId: storageId,
          path: firstPath,
          byteData: ByteData(1),
        );
        await session.storage.storeFile(
          storageId: storageId,
          path: secondPath,
          byteData: ByteData(1),
        );

        final urls = await session.storage.publicDownloadUrls(
          storageId: storageId,
          paths: const [firstPath, 'cloud-storage/missing.txt', secondPath],
        );

        expect(urls, hasLength(3));
        expect(urls[0]?.queryParameters['path'], firstPath);
        expect(urls[1], isNull);
        expect(urls[2]?.queryParameters['path'], secondPath);
      },
    );
  });
}
