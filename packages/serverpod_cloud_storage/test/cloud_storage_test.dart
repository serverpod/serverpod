import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';
import 'package:test/test.dart';

class _StatStorage extends CloudStorage {
  _StatStorage(this.statCallback) : super('test');

  final Future<FileStat> Function() statCallback;

  @override
  Future<FileStat> statFile({
    required CloudStorageSession session,
    required String path,
  }) => statCallback();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSession implements CloudStorageSession {}

void main() {
  late CloudStorageSession session;

  setUp(() {
    session = _FakeSession();
  });

  group('Given a CloudStorage implementation', () {
    test(
      'when statFile succeeds, '
      'then fileExists returns true',
      () async {
        final storage = _StatStorage(
          () async => const FileStat(size: 1),
        );

        expect(
          await storage.fileExists(session: session, path: 'file.txt'),
          isTrue,
        );
      },
    );

    test(
      'when statFile throws CloudStorageFileNotFoundException, '
      'then fileExists returns false',
      () async {
        final storage = _StatStorage(
          () async => throw CloudStorageFileNotFoundException(
            storageId: 'test',
            path: 'missing.txt',
          ),
        );

        expect(
          await storage.fileExists(session: session, path: 'missing.txt'),
          isFalse,
        );
      },
    );

    test(
      'when statFile throws any other exception, '
      'then fileExists rethrows it',
      () {
        final storage = _StatStorage(
          () async => throw CloudStorageException('Network failure.'),
        );

        expect(
          () => storage.fileExists(session: session, path: 'file.txt'),
          throwsA(
            isA<CloudStorageException>().having(
              (e) => e.message,
              'message',
              'Network failure.',
            ),
          ),
        );
      },
    );
  });

  group('Given UploadOptions', () {
    test(
      'when expirationDuration is not positive, '
      'then validate throws CloudStorageException',
      () {
        expect(
          () => const UploadOptions(
            expirationDuration: Duration.zero,
          ).validate(),
          throwsA(
            isA<CloudStorageException>().having(
              (e) => e.message,
              'message',
              contains('expirationDuration must be positive'),
            ),
          ),
        );
      },
    );

    test(
      'when maxFileSize is negative, '
      'then validate throws CloudStorageException',
      () {
        expect(
          () => const UploadOptions(maxFileSize: -1).validate(),
          throwsA(
            isA<CloudStorageException>().having(
              (e) => e.message,
              'message',
              'Upload maxFileSize must be >= 0.',
            ),
          ),
        );
      },
    );

    test(
      'when contentLength is negative, '
      'then validate throws CloudStorageException',
      () {
        expect(
          () => const UploadOptions(contentLength: -1).validate(),
          throwsA(
            isA<CloudStorageException>().having(
              (e) => e.message,
              'message',
              'Upload contentLength must be >= 0.',
            ),
          ),
        );
      },
    );

    test(
      'when contentLength exceeds maxFileSize, '
      'then validate throws CloudStorageException',
      () {
        expect(
          () => const UploadOptions(
            maxFileSize: 1,
            contentLength: 2,
          ).validate(),
          throwsA(
            isA<CloudStorageException>().having(
              (e) => e.message,
              'message',
              contains('exceeds maximum file size'),
            ),
          ),
        );
      },
    );
  });

  test(
    'Given TemporaryDownloadUrlOptions'
    'when expirationDuration is not positive, '
    'then validate throws CloudStorageException',
    () {
      expect(
        () => const TemporaryDownloadUrlOptions(
          expirationDuration: Duration.zero,
        ).validate(),
        throwsA(
          isA<CloudStorageException>().having(
            (e) => e.message,
            'message',
            contains('expirationDuration must be positive'),
          ),
        ),
      );
    },
  );
}
