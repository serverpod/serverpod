import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:googleapis/storage/v1.dart' as gcs;
import 'package:googleapis_auth/auth_io.dart';
import 'package:serverpod/serverpod.dart';

/// GCP cloud storage using native Google Cloud JSON API.
///
/// This implementation uses service account credentials and Google's
/// native Storage API, providing full GCP feature support.
///
/// Configuration:
/// - Set `gcpServiceAccount` in passwords.yaml with the service account JSON
/// - Or set `SERVERPOD_PASSWORD_gcpServiceAccount` environment variable
///
/// Example:
/// ```dart
/// pod.addCloudStorage(NativeGoogleCloudStorage(
///   serverpod: pod,
///   storageId: 'public',
///   bucket: 'my-bucket',
///   public: true,
/// ));
/// ```
class NativeGoogleCloudStorage extends CloudStorage {
  /// The GCS bucket name.
  final String bucket;

  /// Whether files should be publicly accessible.
  final bool public;

  /// Custom public host for generating public URLs.
  /// If not provided, defaults to 'storage.googleapis.com/bucket'.
  final String? publicHost;

  final Completer<gcs.StorageApi> _storageApiCompleter = Completer();

  /// Creates a new [NativeGoogleCloudStorage] reference.
  ///
  /// The [serverpod] instance is used to load the service account JSON from
  /// the password system. The service account can be set via:
  /// - `passwords.yaml`: `gcpServiceAccount` key with JSON content
  /// - Environment variable: `SERVERPOD_PASSWORD_gcpServiceAccount`
  ///
  /// The [storageId] uniquely identifies this storage configuration.
  ///
  /// Set [public] to true if files should be publicly accessible.
  ///
  /// The [bucket] is the name of the GCS bucket.
  ///
  /// Optionally specify [publicHost] to use a custom domain for public URLs.
  NativeGoogleCloudStorage({
    required Serverpod serverpod,
    required String storageId,
    required this.bucket,
    required this.public,
    this.publicHost,
  }) : super(storageId) {
    final serviceAccountJson = serverpod.getPassword('gcpServiceAccount');
    if (serviceAccountJson == null) {
      throw StateError(
        'GCP service account not configured. '
        'Set gcpServiceAccount in passwords.yaml or '
        'SERVERPOD_PASSWORD_gcpServiceAccount environment variable '
        'with the service account JSON content.',
      );
    }

    _initializeAsync(serviceAccountJson);
  }

  Future<void> _initializeAsync(String serviceAccountJson) async {
    try {
      final credentials = ServiceAccountCredentials.fromJson(
        jsonDecode(serviceAccountJson) as Map<String, dynamic>,
      );

      final authClient = await clientViaServiceAccount(
        credentials,
        [gcs.StorageApi.devstorageFullControlScope],
      );

      _storageApiCompleter.complete(gcs.StorageApi(authClient));
    } catch (e) {
      _storageApiCompleter.completeError(e);
    }
  }

  Future<gcs.StorageApi> get _storageApi => _storageApiCompleter.future;

  @override
  Future<void> storeFile({
    required Session session,
    required String path,
    required ByteData byteData,
    DateTime? expiration,
    bool verified = true,
  }) async {
    final storageApi = await _storageApi;

    final media = gcs.Media(
      Stream.value(byteData.buffer.asUint8List()),
      byteData.lengthInBytes,
    );

    final object = gcs.Object()
      ..name = path
      ..bucket = bucket;

    await storageApi.objects.insert(
      object,
      bucket,
      uploadMedia: media,
      predefinedAcl: public ? 'publicRead' : null,
    );
  }

  @override
  Future<ByteData?> retrieveFile({
    required Session session,
    required String path,
  }) async {
    final storageApi = await _storageApi;

    try {
      final response = await storageApi.objects.get(
        bucket,
        path,
        downloadOptions: gcs.DownloadOptions.fullMedia,
      );

      if (response is! gcs.Media) {
        return null;
      }

      final bytes = await _collectBytes(response.stream);
      return ByteData.view(bytes.buffer);
    } on gcs.DetailedApiRequestError catch (e) {
      if (e.status == 404) return null;
      rethrow;
    }
  }

  @override
  Future<Uri?> getPublicUrl({
    required Session session,
    required String path,
  }) async {
    if (!public) return null;

    if (await fileExists(session: session, path: path)) {
      final host = publicHost ?? 'storage.googleapis.com/$bucket';
      return Uri.parse('https://$host/$path');
    }
    return null;
  }

  @override
  Future<bool> fileExists({
    required Session session,
    required String path,
  }) async {
    final storageApi = await _storageApi;

    try {
      await storageApi.objects.get(bucket, path);
      return true;
    } on gcs.DetailedApiRequestError catch (e) {
      if (e.status == 404) return false;
      rethrow;
    }
  }

  @override
  Future<void> deleteFile({
    required Session session,
    required String path,
  }) async {
    final storageApi = await _storageApi;

    try {
      await storageApi.objects.delete(bucket, path);
    } on gcs.DetailedApiRequestError catch (e) {
      if (e.status == 404) return; // Already deleted
      rethrow;
    }
  }

  @override
  Future<String?> createDirectFileUploadDescription({
    required Session session,
    required String path,
    Duration expirationDuration = const Duration(minutes: 10),
    int maxFileSize = 10 * 1024 * 1024,
  }) async {
    // Native GCP signed URL generation requires the service account private key.
    // This is a more complex implementation that involves:
    // 1. Creating a signed URL with the service account credentials
    // 2. The client uploads directly using PUT to the signed URL
    //
    // For now, we don't support direct upload with native GCP.
    // Users who need direct upload should use GoogleCloudStorage (S3-compat).
    return null;
  }

  @override
  Future<bool> verifyDirectFileUpload({
    required Session session,
    required String path,
  }) async {
    return fileExists(session: session, path: path);
  }

  /// Collects all bytes from a stream into a single Uint8List.
  Future<Uint8List> _collectBytes(Stream<List<int>> stream) async {
    final chunks = <List<int>>[];
    await for (final chunk in stream) {
      chunks.add(chunk);
    }

    final totalLength = chunks.fold<int>(0, (sum, chunk) => sum + chunk.length);
    final result = Uint8List(totalLength);

    var offset = 0;
    for (final chunk in chunks) {
      result.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }

    return result;
  }
}
