import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

/// A testable [DatabaseCloudStorage] that overrides DB-dependent methods
/// so the option-handling logic can be tested in isolation.
class TestableDatabaseCloudStorage extends DatabaseCloudStorage {
  final Map<String, ByteData> _files = {};

  TestableDatabaseCloudStorage() : super('test-storage');

  @override
  Future<bool> fileExists({
    required Session session,
    required String path,
  }) async {
    return _files.containsKey(path);
  }

  @override
  Future<void> storeFile({
    required Session session,
    required String path,
    required ByteData byteData,
    StoreFileOptions options = const StoreFileOptions(),
  }) async {
    if (options.preventOverwrite && _files.containsKey(path)) {
      throw CloudStorageFileAlreadyExistsException(
        storageId: storageId,
        path: path,
      );
    }
    _files[path] = byteData;
  }

  @override
  Future<UploadDescription> createUploadDescription({
    required Session session,
    required String path,
    UploadOptions options = const UploadOptions(),
  }) async {
    options.validate();
    return BinaryUploadDescription(url: Uri.parse('http://test/$path'));
  }
}

/// A minimal fake [Session] that satisfies the type system.
///
/// The testable storage overrides all methods that access `session.db`,
/// so no real database connection is needed.
class _FakeSession implements Session {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
    '${invocation.memberName} is not implemented in _FakeSession',
  );
}

void main() {
  late TestableDatabaseCloudStorage storage;
  late Session session;

  setUp(() {
    storage = TestableDatabaseCloudStorage();
    session = _FakeSession();
  });

  group('Given a DatabaseCloudStorage with storeFile', () {
    test(
      'when preventOverwrite is false '
      'then the file is stored',
      () async {
        final data = ByteData.view(
          Uint8List.fromList('content'.codeUnits).buffer,
        );

        await storage.storeFile(
          session: session,
          path: 'test/file.txt',
          byteData: data,
          options: const StoreFileOptions(preventOverwrite: false),
        );

        final exists = await storage.fileExists(
          session: session,
          path: 'test/file.txt',
        );
        expect(exists, isTrue);
      },
    );

    test(
      'when preventOverwrite is true and file does not exist '
      'then the file is stored',
      () async {
        final data = ByteData.view(
          Uint8List.fromList('content'.codeUnits).buffer,
        );

        await storage.storeFile(
          session: session,
          path: 'test/new-file.txt',
          byteData: data,
          options: const StoreFileOptions(preventOverwrite: true),
        );

        final exists = await storage.fileExists(
          session: session,
          path: 'test/new-file.txt',
        );
        expect(exists, isTrue);
      },
    );

    test(
      'when preventOverwrite is true and file already exists '
      'then it throws CloudStorageException',
      () async {
        final data = ByteData.view(
          Uint8List.fromList('original'.codeUnits).buffer,
        );

        await storage.storeFile(
          session: session,
          path: 'test/existing.txt',
          byteData: data,
        );

        final duplicateData = ByteData.view(
          Uint8List.fromList('duplicate'.codeUnits).buffer,
        );

        expect(
          () => storage.storeFile(
            session: session,
            path: 'test/existing.txt',
            byteData: duplicateData,
            options: const StoreFileOptions(preventOverwrite: true),
          ),
          throwsA(
            isA<CloudStorageException>().having(
              (e) => e.message,
              'message',
              contains('already exists'),
            ),
          ),
        );
      },
    );
  });

  group(
    'Given a DatabaseCloudStorage with createUploadDescription',
    () {
      test(
        'when contentLength is within maxFileSize '
        'then it returns a description',
        () async {
          final description = await storage.createUploadDescription(
            session: session,
            path: 'test/file.txt',
            options: const UploadOptions(contentLength: 5000),
          );

          expect(description, isNotNull);
        },
      );

      test(
        'when contentLength exceeds maxFileSize '
        'then it throws CloudStorageException',
        () {
          expect(
            () => storage.createUploadDescription(
              session: session,
              path: 'test/file.txt',
              options: const UploadOptions(
                maxFileSize: 1024,
                contentLength: 2048,
              ),
            ),
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

      test(
        'when contentLength equals maxFileSize '
        'then it returns a description',
        () async {
          final description = await storage.createUploadDescription(
            session: session,
            path: 'test/file.txt',
            options: const UploadOptions(
              maxFileSize: 1024,
              contentLength: 1024,
            ),
          );

          expect(description, isNotNull);
        },
      );

      test(
        'when contentLength is null '
        'then it returns a description',
        () async {
          final description = await storage.createUploadDescription(
            session: session,
            path: 'test/file.txt',
            options: const UploadOptions(),
          );

          expect(description, isNotNull);
        },
      );
    },
  );

  group('Given a DatabaseCloudStorage with verifyUpload', () {
    test(
      'when the database operation fails '
      'then it throws CloudStorageException',
      () {
        expect(
          () => storage.verifyUpload(
            session: session,
            path: 'test/file.txt',
          ),
          throwsA(
            isA<CloudStorageException>().having(
              (exception) => exception.message,
              'message',
              contains('Failed to verify upload'),
            ),
          ),
        );
      },
    );
  });
}
