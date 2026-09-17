import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('Given a running server with the default database cloud storage', () {
    const storageId = 'public';
    late Serverpod server;
    late Session session;

    /// The upload URL of [description], pointed at the bound test server port.
    Uri uploadUri(String description) {
      final url = Uri.parse(jsonDecode(description)['url'] as String);
      return url.replace(
        scheme: 'http',
        host: 'localhost',
        port: server.server.port,
      );
    }

    setUp(() async {
      server = IntegrationTestServer.create();
      await server.startWithDatabase();
      session = await server.createSession(enableLogging: false);
    });

    tearDown(() async {
      await CloudStorageEntry.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      );
      await CloudStorageDirectUploadEntry.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      );
      await session.close();
      await server.shutdown(exitProcess: false);
    });

    test(
      'when a file is uploaded with a valid upload description, '
      'then the response status is 200 and the upload can be verified',
      () async {
        const path = 'upload/valid.bin';
        final description = await session.storage.createUploadDescription(
          storageId: storageId,
          path: path,
        );

        final response = await http.post(
          uploadUri(description),
          body: Uint8List(64),
        );

        expect(response.statusCode, HttpStatus.ok);
        expect(
          await session.storage.verifyUpload(storageId: storageId, path: path),
          isTrue,
        );
      },
    );

    test(
      'when a file is uploaded with an invalid key, '
      'then the response status is 403 and no file is stored',
      () async {
        const path = 'upload/invalid-key.bin';
        final description = await session.storage.createUploadDescription(
          storageId: storageId,
          path: path,
        );
        final uri = uploadUri(description);

        final response = await http.post(
          uri.replace(
            queryParameters: {...uri.queryParameters, 'key': 'invalid'},
          ),
          body: Uint8List(64),
        );

        expect(response.statusCode, HttpStatus.forbidden);
        expect(
          await session.storage.verifyUpload(storageId: storageId, path: path),
          isFalse,
        );
      },
    );

    test(
      'when a file is uploaded after the upload description has expired, '
      'then the response status is 403 and no file is stored',
      () async {
        const path = 'upload/expired.bin';
        final description = await session.storage.createUploadDescription(
          storageId: storageId,
          path: path,
          options: const UploadOptions(
            expirationDuration: Duration(milliseconds: 1),
          ),
        );
        await Future<void>.delayed(const Duration(milliseconds: 50));

        final response = await http.post(
          uploadUri(description),
          body: Uint8List(64),
        );

        expect(response.statusCode, HttpStatus.forbidden);
        expect(
          await session.storage.verifyUpload(storageId: storageId, path: path),
          isFalse,
        );
      },
    );

    test(
      'when a file is uploaded with a size other than the declared content length, '
      'then the response status is 400 and no file is stored',
      () async {
        const path = 'upload/length-mismatch.bin';
        final description = await session.storage.createUploadDescription(
          storageId: storageId,
          path: path,
          options: const UploadOptions(contentLength: 128),
        );

        final response = await http.post(
          uploadUri(description),
          body: Uint8List(64),
        );

        expect(response.statusCode, HttpStatus.badRequest);
        expect(
          await session.storage.verifyUpload(storageId: storageId, path: path),
          isFalse,
        );
      },
    );

    test(
      'when a file larger than the max request size but within the maximum file size is uploaded, '
      'then the response status is 200 and the upload can be verified',
      () async {
        const path = 'upload/larger-than-max-request-size.bin';
        final description = await session.storage.createUploadDescription(
          storageId: storageId,
          path: path,
        );

        final response = await http.post(
          uploadUri(description),
          body: Uint8List(server.config.maxRequestSize * 2),
        );

        expect(response.statusCode, HttpStatus.ok);
        expect(
          await session.storage.verifyUpload(storageId: storageId, path: path),
          isTrue,
        );
      },
    );

    test(
      'when a file larger than the maximum file size is uploaded, '
      'then the response status is 413 and no file is stored',
      () async {
        const path = 'upload/too-large.bin';
        final description = await session.storage.createUploadDescription(
          storageId: storageId,
          path: path,
          options: const UploadOptions(maxFileSize: 1024),
        );

        final response = await http.post(
          uploadUri(description),
          body: Uint8List(2 * 1024 * 1024),
        );

        expect(response.statusCode, HttpStatus.requestEntityTooLarge);
        expect(
          await session.storage.verifyUpload(storageId: storageId, path: path),
          isFalse,
        );
      },
    );

    test(
      'when a file larger than the maximum file size is streamed without a content length, '
      'then the response status is 413 and no file is stored',
      () async {
        const path = 'upload/too-large-streamed.bin';
        final description = await session.storage.createUploadDescription(
          storageId: storageId,
          path: path,
          options: const UploadOptions(maxFileSize: 1024),
        );
        final request = http.StreamedRequest('POST', uploadUri(description));

        final (_, response) = await (
          Stream<List<int>>.fromIterable(
            List.filled(32, Uint8List(64 * 1024)),
          ).pipe(request.sink),
          request.send(),
        ).wait;

        expect(response.statusCode, HttpStatus.requestEntityTooLarge);
        expect(
          await session.storage.verifyUpload(storageId: storageId, path: path),
          isFalse,
        );
      },
    );

    test(
      'when a file is uploaded to an existing path with preventOverwrite enabled, '
      'then the response status is 409 and the existing file is preserved',
      () async {
        const path = 'upload/prevent-overwrite.bin';
        await session.storage.storeFile(
          storageId: storageId,
          path: path,
          byteData: ByteData.sublistView(Uint8List.fromList([1])),
        );
        final description = await session.storage.createUploadDescription(
          storageId: storageId,
          path: path,
          options: const UploadOptions(preventOverwrite: true),
        );

        final response = await http.post(
          uploadUri(description),
          body: Uint8List(64),
        );

        expect(response.statusCode, HttpStatus.conflict);
        final stored = await session.storage.retrieveFile(
          storageId: storageId,
          path: path,
        );
        expect(stored.lengthInBytes, 1);
      },
    );

    test(
      'when a file is uploaded for a storage that is not a database cloud storage, '
      'then the response status is 404',
      () async {
        const path = 'upload/unknown-storage.bin';
        final entry = await CloudStorageDirectUploadEntry.db.insertRow(
          session,
          CloudStorageDirectUploadEntry(
            storageId: 'not-a-database-storage',
            path: path,
            expiration: DateTime.now().toUtc().add(const Duration(minutes: 1)),
            authKey: 'key',
          ),
        );

        final response = await http.post(
          Uri.parse(
            '${server.apiUrl}serverpod_cloud_storage'
            '?method=upload&storage=${entry.storageId}&path=$path&key=key',
          ),
          body: Uint8List(64),
        );

        expect(response.statusCode, HttpStatus.notFound);
      },
    );
  });
}
