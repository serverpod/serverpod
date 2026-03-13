import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import 'signing/cos_signer.dart';

/// Tencent Cloud Object Storage (COS) implementation for Serverpod.
///
/// Uses COS-native XML API signatures (HMAC-SHA1) rather than the
/// S3-compatible layer, ensuring full compatibility with virtual-hosted-style
/// endpoints and COS-specific features like `x-cos-forbid-overwrite`.
///
/// ## Configuration
///
/// Set credentials via environment variables or `config/passwords.yaml`:
/// - `SERVERPOD_COS_ACCESS_KEY_ID` / `COSAccessKeyId`
/// - `SERVERPOD_COS_SECRET_KEY` / `COSSecretKey`
///
/// Legacy aliases are also supported:
/// - `tencentCosSecretId` / `tencentCosSecretKey`
///
/// ## Example
///
/// ```dart
/// pod.addCloudStorage(CosCloudStorage(
///   serverpod: pod,
///   storageId: 'public',
///   public: true,
///   bucket: 'my-bucket-1250000000',
///   region: 'ap-guangzhou',
/// ));
/// ```
class CosCloudStorage extends CloudStorage with CloudStorageWithOptions {
  /// The COS bucket name (including the APPID suffix,
  /// e.g. `my-bucket-1250000000`).
  final String bucket;

  /// The COS region identifier (e.g. `ap-guangzhou`).
  final String region;

  /// Whether this storage serves publicly readable objects.
  final bool public;

  /// Optional custom domain used for public URL generation.
  ///
  /// Accepts either a bare hostname (`cdn.example.com`) or a full URL
  /// (`https://cdn.example.com`). When set, [getPublicUrl] returns URLs
  /// using this domain instead of the default COS virtual-hosted-style host.
  final String? publicHost;

  late final CosSigner _signer;

  /// Creates a new COS cloud storage instance.
  ///
  /// [serverpod] is the Serverpod instance used for loading credentials.
  /// [storageId] identifies this storage (typically `'public'` or `'private'`).
  /// [public] indicates whether files should be publicly accessible.
  /// [bucket] is the COS bucket name (including the APPID suffix).
  /// [region] is the COS region identifier.
  /// [publicHost] optionally overrides the public URL host.
  CosCloudStorage({
    required Serverpod serverpod,
    required String storageId,
    required this.public,
    required this.bucket,
    required this.region,
    this.publicHost,
  }) : super(storageId) {
    final accessKey = _loadAccessKey(serverpod);
    final secretKey = _loadSecretKey(serverpod);

    _signer = CosSigner(
      secretId: accessKey,
      secretKey: secretKey,
      bucket: bucket,
      region: region,
      publicHost: publicHost,
    );
  }

  /// Creates a COS cloud storage with a pre-built [CosSigner].
  ///
  /// Intended for testing — bypasses credential loading.
  CosCloudStorage.withSigner({
    required String storageId,
    required this.public,
    required this.bucket,
    required this.region,
    required CosSigner signer,
    this.publicHost,
  }) : _signer = signer,
       super(storageId);

  // ---------------------------------------------------------------------------
  // CloudStorage overrides
  // ---------------------------------------------------------------------------

  @override
  Future<void> storeFile({
    required Session session,
    required String path,
    required ByteData byteData,
    DateTime? expiration,
    bool verified = true,
  }) async {
    await _putObject(
      path: path,
      bytes: byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      ),
    );
  }

  @override
  Future<ByteData?> retrieveFile({
    required Session session,
    required String path,
  }) async {
    final url = _signer.generatePresignedUrl('GET', _normalizePath(path));
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return ByteData.sublistView(response.bodyBytes);
    }
    if (response.statusCode == 404) return null;
    throw CloudStorageException(
      'Failed to retrieve file "$path" '
      '(status: ${response.statusCode}).',
    );
  }

  @override
  Future<Uri?> getPublicUrl({
    required Session session,
    required String path,
  }) async {
    if (!public) return null;
    if (!await fileExists(session: session, path: path)) return null;
    return _buildPublicUri(path);
  }

  @override
  Future<bool> fileExists({
    required Session session,
    required String path,
  }) async {
    final url = _signer.generatePresignedUrl('HEAD', _normalizePath(path));
    final response = await http.head(Uri.parse(url));
    if (response.statusCode == 200) return true;
    if (response.statusCode == 404) return false;
    throw CloudStorageException(
      'Failed to check existence of "$path" '
      '(status: ${response.statusCode}).',
    );
  }

  @override
  Future<void> deleteFile({
    required Session session,
    required String path,
  }) async {
    final url = _signer.generatePresignedUrl('DELETE', _normalizePath(path));
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200 || response.statusCode == 204) return;
    if (response.statusCode == 404) return;
    throw CloudStorageException(
      'Failed to delete file "$path" '
      '(status: ${response.statusCode}).',
    );
  }

  /// Direct file upload is not yet implemented; returns `null`.
  ///
  /// This will be delivered in a follow-up with full presigned-URL
  /// support and `FileUploader` integration.
  @override
  Future<String?> createDirectFileUploadDescription({
    required Session session,
    required String path,
    Duration expirationDuration = const Duration(minutes: 10),
    int maxFileSize = 10 * 1024 * 1024,
  }) async {
    return null;
  }

  @override
  Future<bool> verifyDirectFileUpload({
    required Session session,
    required String path,
  }) async {
    return fileExists(session: session, path: path);
  }

  // ---------------------------------------------------------------------------
  // CloudStorageWithOptions overrides
  // ---------------------------------------------------------------------------

  /// Stores a file with extended options.
  ///
  /// **preventOverwrite semantics**: Sends the `x-cos-forbid-overwrite: true`
  /// header on the PUT request. COS returns 409 Conflict when an object
  /// already exists at the given path, which this method surfaces as a
  /// [CloudStorageException]. Note: this header has no effect on
  /// versioning-enabled buckets.
  ///
  /// **contentLength semantics**: When [options.contentLength] is non-null,
  /// it is set as the `Content-Length` header and COS validates the actual
  /// byte count server-side. This method also performs a client-side
  /// pre-check: if [options.contentLength] differs from the actual
  /// [byteData] length, a [CloudStorageException] is thrown immediately.
  @override
  Future<void> storeFileWithOptions({
    required Session session,
    required String path,
    required ByteData byteData,
    DateTime? expiration,
    bool verified = true,
    required CloudStorageOptions options,
  }) async {
    if (options.contentLength != null &&
        options.contentLength != byteData.lengthInBytes) {
      throw CloudStorageException(
        'Content length mismatch: options.contentLength '
        '(${options.contentLength}) != actual data length '
        '(${byteData.lengthInBytes}).',
      );
    }

    final extraHeaders = <String, String>{};
    if (options.preventOverwrite) {
      extraHeaders['x-cos-forbid-overwrite'] = 'true';
    }

    await _putObject(
      path: path,
      bytes: byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      ),
      extraHeaders: extraHeaders,
    );
  }

  /// Direct file upload with options is not yet implemented; returns `null`.
  ///
  /// This will be delivered in a follow-up.
  @override
  Future<String?> createDirectFileUploadDescriptionWithOptions({
    required Session session,
    required String path,
    Duration expirationDuration = const Duration(minutes: 10),
    int maxFileSize = 10 * 1024 * 1024,
    required CloudStorageOptions options,
  }) async {
    return null;
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  Future<void> _putObject({
    required String path,
    required Uint8List bytes,
    Map<String, String> extraHeaders = const {},
  }) async {
    final normalizedPath = _normalizePath(path);

    final signedHeaders = <String, String>{
      'content-type': 'application/octet-stream',
      'content-length': bytes.length.toString(),
      ...extraHeaders,
    };

    final url = _signer.generatePresignedUrl(
      'PUT',
      normalizedPath,
      headers: signedHeaders,
    );

    final response = await http.put(
      Uri.parse(url),
      headers: signedHeaders,
      body: bytes,
    );

    if (response.statusCode == 200) return;

    if (response.statusCode == 409) {
      throw CloudStorageException(
        'Failed to store file "$path": object already exists '
        '(preventOverwrite is active).',
      );
    }

    throw CloudStorageException(
      'Failed to store file "$path" '
      '(status: ${response.statusCode}).',
    );
  }

  /// Builds a public URI for the given [path].
  ///
  /// Uses [publicHost] (custom domain) when available, otherwise falls back
  /// to the COS virtual-hosted-style default domain.
  Uri _buildPublicUri(String path) {
    final normalized = _normalizePath(path);
    final host = publicHost;

    if (host != null && host.trim().isNotEmpty) {
      final trimmed = host.trim();
      final parsed = Uri.tryParse(trimmed);
      if (parsed != null && parsed.hasScheme && parsed.host.isNotEmpty) {
        return Uri(
          scheme: parsed.scheme,
          host: parsed.host,
          port: parsed.hasPort ? parsed.port : null,
          path: '/$normalized',
        );
      }
      return Uri(scheme: 'https', host: trimmed, path: '/$normalized');
    }

    return Uri(
      scheme: 'https',
      host: '$bucket.cos.$region.myqcloud.com',
      path: '/$normalized',
    );
  }

  /// Strips a leading `/` to produce a relative path.
  String _normalizePath(String path) {
    if (path.startsWith('/')) return path.substring(1);
    return path;
  }

  // ---------------------------------------------------------------------------
  // Credential loading
  // ---------------------------------------------------------------------------

  static String _loadAccessKey(Serverpod serverpod) {
    serverpod.loadCustomPasswords([
      (envName: 'SERVERPOD_COS_ACCESS_KEY_ID', alias: 'COSAccessKeyId'),
    ]);
    final key =
        serverpod.getPassword('COSAccessKeyId') ??
        serverpod.getPassword('tencentCosSecretId');
    if (key == null) {
      throw StateError(
        'COS access key not configured. '
        'Set COSAccessKeyId in passwords.yaml or '
        'SERVERPOD_COS_ACCESS_KEY_ID environment variable.',
      );
    }
    return key;
  }

  static String _loadSecretKey(Serverpod serverpod) {
    serverpod.loadCustomPasswords([
      (envName: 'SERVERPOD_COS_SECRET_KEY', alias: 'COSSecretKey'),
    ]);
    final key =
        serverpod.getPassword('COSSecretKey') ??
        serverpod.getPassword('tencentCosSecretKey');
    if (key == null) {
      throw StateError(
        'COS secret key not configured. '
        'Set COSSecretKey in passwords.yaml or '
        'SERVERPOD_COS_SECRET_KEY environment variable.',
      );
    }
    return key;
  }
}
