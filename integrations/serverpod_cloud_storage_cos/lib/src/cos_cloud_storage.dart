import 'dart:convert';
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
///
/// ## Client-side direct upload
///
/// Use `session.storage.createDirectFileUploadDescription(...)` to generate
/// a presigned PUT description. The client receives a JSON string that
/// `FileUploader` uses to perform a binary PUT directly to COS:
///
/// ```dart
/// // Server endpoint
/// final description = await session.storage
///     .createDirectFileUploadDescription(
///       storageId: 'public',
///       path: 'uploads/photo.jpg',
///     );
///
/// // Client
/// final uploader = FileUploader(description);
/// final success = await uploader.uploadByteData(byteData);
/// if (success) {
///   await session.storage.verifyDirectFileUpload(
///     storageId: 'public',
///     path: 'uploads/photo.jpg',
///   );
/// }
/// ```
///
/// ## Provider-specific limitations
///
/// - **preventOverwrite on versioning-enabled buckets**: The
///   `x-cos-forbid-overwrite` header has no effect when bucket versioning is
///   enabled. COS will silently create a new object version instead of
///   returning 409 Conflict.
/// - **contentLength enforcement**: For server-side uploads,
///   `storeFileWithOptions` performs both a client-side pre-check and
///   server-side `Content-Length` validation. For direct client uploads,
///   `Content-Length` is signed into the presigned URL; however, COS may
///   still accept uploads if the actual size differs from the signed value
///   depending on the transfer encoding.
/// - **maxFileSize**: Pure presigned PUT URLs cannot enforce a maximum file
///   size at the storage layer (unlike S3 POST policies). The `maxFileSize`
///   parameter in `createDirectFileUploadDescription(WithOptions)` is used
///   only for the server-side `contentLength > maxFileSize` pre-check.
/// - **publicHost semantics**: The [publicHost] field is used exclusively
///   for generating public read URLs via `getPublicUrl`. All other
///   operations — `storeFile`, `retrieveFile`, `fileExists`, `deleteFile`,
///   `verifyDirectFileUpload`, and `createDirectFileUploadDescription*` —
///   always target the COS bucket endpoint
///   (`<bucket>.cos.<region>.myqcloud.com`) because CDN / custom domains
///   typically do not accept PUT/HEAD/DELETE requests.
/// - **CORS configuration**: For client-side direct uploads from web
///   browsers, the COS bucket must have a CORS policy allowing `PUT`
///   requests from the client's origin, with the headers used in the
///   upload description (`Content-Type`, `x-cos-forbid-overwrite`,
///   `Content-Length`) listed as allowed headers.
/// - **CAM permissions**: The access key must have `cos:PutObject`,
///   `cos:GetObject`, `cos:HeadObject`, and `cos:DeleteObject` permissions
///   on the target bucket.
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
  final http.Client _httpClient;
  final bool _ownsHttpClient;
  bool _isClosed = false;

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
  }) : _httpClient = http.Client(),
       _ownsHttpClient = true,
       super(storageId) {
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

  /// Creates a COS cloud storage with a pre-built [CosSigner] and optional
  /// [httpClient].
  ///
  /// Intended for testing — bypasses credential loading. When [httpClient] is
  /// omitted a default [http.Client] is used.
  CosCloudStorage.withSigner({
    required String storageId,
    required this.public,
    required this.bucket,
    required this.region,
    required CosSigner signer,
    this.publicHost,
    http.Client? httpClient,
  }) : _signer = signer,
       _httpClient = httpClient ?? http.Client(),
       _ownsHttpClient = httpClient == null,
       super(storageId);

  /// Closes the underlying HTTP client, releasing its resources.
  ///
  /// Only closes the client if it was internally created by this instance.
  /// When an external [http.Client] was provided via
  /// [CosCloudStorage.withSigner], the caller retains ownership and is
  /// responsible for closing it.
  ///
  /// This method is idempotent — calling it multiple times is safe.
  /// After calling [close], no further operations should be performed
  /// on this instance.
  void close() {
    if (_isClosed) return;
    _isClosed = true;
    if (_ownsHttpClient) {
      _httpClient.close();
    }
  }

  @override
  Future<String?> createDirectFileUploadDescription({
    required Session session,
    required String path,
    Duration expirationDuration = const Duration(minutes: 10),
    int maxFileSize = 10 * 1024 * 1024,
  }) async {
    return _buildUploadDescription(
      path: path,
      expirationDuration: expirationDuration,
    );
  }

  @override
  Future<String?> createDirectFileUploadDescriptionWithOptions({
    required Session session,
    required String path,
    Duration expirationDuration = const Duration(minutes: 10),
    int maxFileSize = 10 * 1024 * 1024,
    required CloudStorageOptions options,
  }) async {
    if (options.contentLength != null && options.contentLength! > maxFileSize) {
      throw CloudStorageException(
        'Content length (${options.contentLength} bytes) exceeds '
        'maximum file size ($maxFileSize bytes).',
      );
    }

    return _buildUploadDescription(
      path: path,
      expirationDuration: expirationDuration,
      contentLength: options.contentLength,
      preventOverwrite: options.preventOverwrite,
    );
  }

  @override
  Future<void> deleteFile({
    required Session session,
    required String path,
  }) async {
    final url = _signer.generatePresignedUrl(
      'DELETE',
      _normalizePath(path),
      host: _signer.defaultHost,
    );
    final response = await _httpClient.delete(Uri.parse(url));
    if (response.statusCode == 200 || response.statusCode == 204) return;
    if (response.statusCode == 404) return;
    throw CloudStorageException(
      'Failed to delete file "$path" '
      '(status: ${response.statusCode}).',
    );
  }

  @override
  Future<bool> fileExists({
    required Session session,
    required String path,
  }) async {
    final url = _signer.generatePresignedUrl(
      'HEAD',
      _normalizePath(path),
      host: _signer.defaultHost,
    );
    final response = await _httpClient.head(Uri.parse(url));
    if (response.statusCode == 200) return true;
    if (response.statusCode == 404) return false;
    throw CloudStorageException(
      'Failed to check existence of "$path" '
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
  Future<ByteData?> retrieveFile({
    required Session session,
    required String path,
  }) async {
    final url = _signer.generatePresignedUrl(
      'GET',
      _normalizePath(path),
      host: _signer.defaultHost,
    );
    final response = await _httpClient.get(Uri.parse(url));
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

  @override
  Future<bool> verifyDirectFileUpload({
    required Session session,
    required String path,
  }) async {
    return fileExists(session: session, path: path);
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

  /// Builds a `FileUploader`-compatible binary PUT upload description.
  ///
  /// The returned JSON encodes a presigned PUT URL targeting the COS
  /// bucket endpoint ([CosSigner.defaultHost]) rather than any CDN or
  /// custom [publicHost], because CDN domains do not accept PUT requests.
  ///
  /// Headers that affect server-side validation (`x-cos-forbid-overwrite`,
  /// `Content-Length`) are signed into the URL **and** included in the
  /// description so that `FileUploader` sends them with the PUT request.
  String _buildUploadDescription({
    required String path,
    required Duration expirationDuration,
    int? contentLength,
    bool preventOverwrite = false,
  }) {
    final normalizedPath = _normalizePath(path);

    final headers = <String, String>{
      'Content-Type': 'application/octet-stream',
    };
    if (contentLength != null) {
      headers['Content-Length'] = contentLength.toString();
    }
    if (preventOverwrite) {
      headers['x-cos-forbid-overwrite'] = 'true';
    }

    final presignedUrl = _signer.generatePresignedUrl(
      'PUT',
      normalizedPath,
      expires: expirationDuration.inSeconds,
      headers: headers,
      host: _signer.defaultHost,
    );

    return jsonEncode({
      'url': presignedUrl,
      'type': 'binary',
      'method': 'PUT',
      'headers': headers,
    });
  }

  /// Strips a leading `/` to produce a relative path.
  String _normalizePath(String path) {
    if (path.startsWith('/')) return path.substring(1);
    return path;
  }

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
      host: _signer.defaultHost,
    );

    final response = await _httpClient.put(
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

  /// Resolves the COS access key with the following priority:
  ///
  /// 1. `SERVERPOD_COS_ACCESS_KEY_ID` env var → `COSAccessKeyId` alias
  /// 2. `tencentCosSecretId` legacy alias (for backward compatibility)
  ///
  /// Throws [StateError] if none of the above are configured.
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

  /// Resolves the COS secret key with the following priority:
  ///
  /// 1. `SERVERPOD_COS_SECRET_KEY` env var → `COSSecretKey` alias
  /// 2. `tencentCosSecretKey` legacy alias (for backward compatibility)
  ///
  /// Throws [StateError] if none of the above are configured.
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
