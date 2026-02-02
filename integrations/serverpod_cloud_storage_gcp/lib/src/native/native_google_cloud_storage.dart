import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:googleapis/storage/v1.dart' as gcs;
import 'package:googleapis_auth/auth_io.dart';
import 'package:path/path.dart' as p;
import 'package:pointycastle/asn1.dart';
import 'package:pointycastle/export.dart';
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
  final Completer<_SigningCredentials> _signingCredentialsCompleter =
      Completer();

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

  /// Creates a [NativeGoogleCloudStorage] with an already-initialized
  /// [StorageApi].
  ///
  /// This constructor is primarily intended for testing purposes.
  ///
  /// Note: Direct upload via signed URLs is not available when using this
  /// constructor, as signing credentials are not provided.
  NativeGoogleCloudStorage.withStorageApi({
    required String storageId,
    required this.bucket,
    required this.public,
    required gcs.StorageApi storageApi,
    this.publicHost,
  }) : super(storageId) {
    _storageApiCompleter.complete(storageApi);
    // No signing credentials available in test mode
  }

  /// Creates a [NativeGoogleCloudStorage] with signing credentials for testing.
  ///
  /// This constructor allows testing direct upload functionality.
  NativeGoogleCloudStorage.withSigningCredentials({
    required String storageId,
    required this.bucket,
    required this.public,
    required gcs.StorageApi storageApi,
    required String clientEmail,
    required RSAPrivateKey privateKey,
    this.publicHost,
  }) : super(storageId) {
    _storageApiCompleter.complete(storageApi);
    _signingCredentialsCompleter.complete(
      _SigningCredentials(
        clientEmail: clientEmail,
        privateKey: privateKey,
      ),
    );
  }

  Future<void> _initializeAsync(String serviceAccountJson) async {
    try {
      final jsonData = jsonDecode(serviceAccountJson) as Map<String, dynamic>;
      final credentials = ServiceAccountCredentials.fromJson(jsonData);

      final authClient = await clientViaServiceAccount(
        credentials,
        [gcs.StorageApi.devstorageFullControlScope],
      );

      _storageApiCompleter.complete(gcs.StorageApi(authClient));

      // Parse signing credentials for direct uploads
      final clientEmail = jsonData['client_email'] as String?;
      final privateKeyPem = jsonData['private_key'] as String?;

      if (clientEmail != null && privateKeyPem != null) {
        final privateKey = _parsePrivateKeyFromPem(privateKeyPem);
        _signingCredentialsCompleter.complete(
          _SigningCredentials(
            clientEmail: clientEmail,
            privateKey: privateKey,
          ),
        );
      } else {
        _signingCredentialsCompleter.completeError(
          StateError(
            'Service account JSON missing client_email or private_key',
          ),
        );
      }
    } catch (e) {
      if (!_storageApiCompleter.isCompleted) {
        _storageApiCompleter.completeError(e);
      }
      if (!_signingCredentialsCompleter.isCompleted) {
        _signingCredentialsCompleter.completeError(e);
      }
    }
  }

  /// Parses an RSA private key from PEM format.
  RSAPrivateKey _parsePrivateKeyFromPem(String pem) {
    final lines = pem
        .split('\n')
        .where((line) => !line.startsWith('-----'))
        .join();
    final bytes = base64.decode(lines);
    final asn1Parser = ASN1Parser(Uint8List.fromList(bytes));
    final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

    // PKCS#8 format: PrivateKeyInfo ::= SEQUENCE { version, algorithm, privateKey }
    // The privateKey is an OCTET STRING containing the RSA private key
    ASN1Sequence rsaSeq;
    if (topLevelSeq.elements!.length == 3) {
      // PKCS#8 format
      final privateKeyOctet = topLevelSeq.elements![2] as ASN1OctetString;
      final pkParser = ASN1Parser(privateKeyOctet.valueBytes);
      rsaSeq = pkParser.nextObject() as ASN1Sequence;
    } else {
      // PKCS#1 format (raw RSA key)
      rsaSeq = topLevelSeq;
    }

    final modulus = (rsaSeq.elements![1] as ASN1Integer).integer!;
    final privateExponent = (rsaSeq.elements![3] as ASN1Integer).integer!;
    final p = (rsaSeq.elements![4] as ASN1Integer).integer!;
    final q = (rsaSeq.elements![5] as ASN1Integer).integer!;

    return RSAPrivateKey(modulus, privateExponent, p, q);
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
    // Check if signing credentials are available
    if (!_signingCredentialsCompleter.isCompleted) {
      return null;
    }

    final signingCredentials = await _signingCredentialsCompleter.future;

    final signedUrl = _createSignedUrl(
      credentials: signingCredentials,
      bucket: bucket,
      path: path,
      expiration: expirationDuration,
      method: 'PUT',
    );

    final fileName = p.basename(path);
    final contentType = _detectMimeType(fileName);

    return jsonEncode({
      'url': signedUrl,
      'type': 'binary',
      'method': 'PUT',
      'file-name': fileName,
      'headers': {
        'Content-Type': contentType,
      },
    });
  }

  /// Creates a V4 signed URL for GCS operations.
  String _createSignedUrl({
    required _SigningCredentials credentials,
    required String bucket,
    required String path,
    required Duration expiration,
    required String method,
  }) {
    final now = DateTime.now().toUtc();
    final datestamp = _formatDatestamp(now);
    final timestamp = _formatTimestamp(now);

    final host = 'storage.googleapis.com';
    final encodedPath = path.split('/').map(Uri.encodeComponent).join('/');
    final canonicalUri = '/$bucket/$encodedPath';
    final credentialScope = '$datestamp/auto/storage/goog4_request';

    // Build canonical query string (sorted alphabetically)
    final queryParams = <String, String>{
      'X-Goog-Algorithm': 'GOOG4-RSA-SHA256',
      'X-Goog-Credential': '${credentials.clientEmail}/$credentialScope',
      'X-Goog-Date': timestamp,
      'X-Goog-Expires': expiration.inSeconds.toString(),
      'X-Goog-SignedHeaders': 'host',
    };

    final canonicalQueryString = queryParams.entries
        .toList()
        .map((e) => '${_uriEncode(e.key)}=${_uriEncode(e.value)}')
        .join('&');

    // Build canonical headers
    final canonicalHeaders = 'host:$host\n';
    final signedHeaders = 'host';

    // Build canonical request
    final canonicalRequest = [
      method,
      canonicalUri,
      canonicalQueryString,
      canonicalHeaders,
      signedHeaders,
      'UNSIGNED-PAYLOAD',
    ].join('\n');

    // Build string to sign
    final hashedCanonicalRequest = sha256
        .convert(utf8.encode(canonicalRequest))
        .toString();
    final stringToSign = [
      'GOOG4-RSA-SHA256',
      timestamp,
      credentialScope,
      hashedCanonicalRequest,
    ].join('\n');

    // Sign with RSA-SHA256
    final signature = _rsaSign(credentials.privateKey, stringToSign);
    final signatureHex = signature
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();

    // Build final URL
    return 'https://$host$canonicalUri?$canonicalQueryString&X-Goog-Signature=$signatureHex';
  }

  /// Signs data using RSA-SHA256.
  Uint8List _rsaSign(RSAPrivateKey privateKey, String data) {
    final signer = RSASigner(SHA256Digest(), '0609608648016503040201');
    signer.init(true, PrivateKeyParameter<RSAPrivateKey>(privateKey));
    final signature = signer.generateSignature(
      Uint8List.fromList(utf8.encode(data)),
    );
    return signature.bytes;
  }

  /// Formats a DateTime as YYYYMMDD.
  String _formatDatestamp(DateTime dt) {
    return '${dt.year}${dt.month.toString().padLeft(2, '0')}${dt.day.toString().padLeft(2, '0')}';
  }

  /// Formats a DateTime as YYYYMMDDTHHMMSSZ.
  String _formatTimestamp(DateTime dt) {
    return '${_formatDatestamp(dt)}T${dt.hour.toString().padLeft(2, '0')}${dt.minute.toString().padLeft(2, '0')}${dt.second.toString().padLeft(2, '0')}Z';
  }

  /// URI-encodes a string according to RFC 3986.
  String _uriEncode(String input) {
    return Uri.encodeComponent(input).replaceAll('+', '%2B');
  }

  /// Detects MIME type based on file extension.
  static String _detectMimeType(String filename) {
    final ext = p.extension(filename).toLowerCase();

    const mimeTypes = {
      '.jpg': 'image/jpeg',
      '.jpeg': 'image/jpeg',
      '.png': 'image/png',
      '.gif': 'image/gif',
      '.webp': 'image/webp',
      '.svg': 'image/svg+xml',
      '.pdf': 'application/pdf',
      '.txt': 'text/plain',
      '.html': 'text/html',
      '.css': 'text/css',
      '.js': 'application/javascript',
      '.json': 'application/json',
      '.xml': 'application/xml',
      '.mp4': 'video/mp4',
      '.mp3': 'audio/mpeg',
      '.zip': 'application/zip',
    };

    return mimeTypes[ext] ?? 'application/octet-stream';
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

/// Internal class to hold signing credentials.
class _SigningCredentials {
  final String clientEmail;
  final RSAPrivateKey privateKey;

  _SigningCredentials({
    required this.clientEmail,
    required this.privateKey,
  });
}
