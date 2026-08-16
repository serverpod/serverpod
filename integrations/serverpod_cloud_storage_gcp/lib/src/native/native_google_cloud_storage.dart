import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:googleapis/storage/v1.dart' as gcs;
import 'package:googleapis_auth/auth_io.dart' as gcs;
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
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
/// pod.addCloudStorage(await NativeGoogleCloudStorage.create(
///   serverpod: pod,
///   storageId: 'public',
///   bucket: 'my-bucket',
///   public: true,
/// ));
/// ```
class NativeGoogleCloudStorage extends CloudStorage
    with CloudStorageWithOptions {
  /// The GCS bucket name.
  final String bucket;

  /// Whether files should be publicly accessible.
  final bool public;

  /// Custom public host for generating public URLs.
  /// If not provided, defaults to 'storage.googleapis.com/bucket'.
  final String? publicHost;

  final gcs.StorageApi _storageApi;
  final _SigningContext? _signingContext;
  final http.Client? _authClient;

  NativeGoogleCloudStorage._({
    required String storageId,
    required this.bucket,
    required this.public,
    required gcs.StorageApi storageApi,
    _SigningContext? signingContext,
    http.Client? authClient,
    this.publicHost,
  }) : _storageApi = storageApi,
       _signingContext = signingContext,
       _authClient = authClient,
       super(storageId);

  /// Creates a new [NativeGoogleCloudStorage] from a [Serverpod] instance.
  ///
  /// The service account JSON is loaded from the password system via:
  /// - `passwords.yaml`: `gcpServiceAccount` key with JSON content
  /// - Environment variable: `SERVERPOD_PASSWORD_gcpServiceAccount`
  static Future<NativeGoogleCloudStorage> create({
    required Serverpod serverpod,
    required String storageId,
    required String bucket,
    required bool public,
    String? publicHost,
  }) async {
    final serviceAccountJson = serverpod.getPassword('gcpServiceAccount');
    if (serviceAccountJson == null) {
      throw StateError(
        'GCP service account not configured. '
        'Set gcpServiceAccount in passwords.yaml or '
        'SERVERPOD_PASSWORD_gcpServiceAccount environment variable '
        'with the service account JSON content.',
      );
    }

    return fromServiceAccountJson(
      storageId: storageId,
      bucket: bucket,
      public: public,
      serviceAccountJson: serviceAccountJson,
      publicHost: publicHost,
    );
  }

  /// Creates a [NativeGoogleCloudStorage] from a service account JSON string.
  ///
  /// This factory authenticates directly with the provided JSON credentials
  /// without requiring a [Serverpod] instance, making it suitable for
  /// integration testing and standalone usage.
  static Future<NativeGoogleCloudStorage> fromServiceAccountJson({
    required String storageId,
    required String bucket,
    required bool public,
    required String serviceAccountJson,
    String? publicHost,
  }) async {
    final credentials = gcs.ServiceAccountCredentials.fromJson(
      serviceAccountJson,
    );

    final authClient = await gcs.clientViaServiceAccount(
      credentials,
      [gcs.StorageApi.devstorageFullControlScope],
    );

    return NativeGoogleCloudStorage._(
      storageId: storageId,
      bucket: bucket,
      public: public,
      storageApi: gcs.StorageApi(authClient),
      signingContext: _SigningContext.fromCredentials(credentials),
      authClient: authClient,
      publicHost: publicHost,
    );
  }

  /// Creates a [NativeGoogleCloudStorage] using Application Default Credentials.
  ///
  /// This factory uses ADC to authenticate, which automatically detects
  /// credentials from the environment (GKE workload identity, Cloud Run
  /// service account, `GOOGLE_APPLICATION_CREDENTIALS` env var, etc.).
  ///
  /// Signed URL generation requires the service account to have the
  /// `iam.serviceAccounts.signBlob` IAM permission, since ADC does not
  /// provide a local private key for signing.
  static Future<NativeGoogleCloudStorage> fromApplicationDefaultCredentials({
    required String storageId,
    required String bucket,
    required bool public,
    String? publicHost,
  }) async {
    final authClient = await gcs.clientViaApplicationDefaultCredentials(
      scopes: [gcs.StorageApi.devstorageFullControlScope],
    );

    final email = await _getServiceAccountEmail();

    return NativeGoogleCloudStorage._(
      storageId: storageId,
      bucket: bucket,
      public: public,
      storageApi: gcs.StorageApi(authClient),
      signingContext: _SigningContext.fromAuthClient(email, authClient),
      authClient: authClient,
      publicHost: publicHost,
    );
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
  }) : _storageApi = storageApi,
       _signingContext = null,
       _authClient = null,
       super(storageId);

  /// Creates a [NativeGoogleCloudStorage] with signing credentials for testing.
  ///
  /// This constructor allows testing direct upload functionality with
  /// service account credentials (local RSA signing).
  NativeGoogleCloudStorage.withSigningCredentials({
    required String storageId,
    required this.bucket,
    required this.public,
    required gcs.StorageApi storageApi,
    required gcs.ServiceAccountCredentials credentials,
    this.publicHost,
  }) : _storageApi = storageApi,
       _signingContext = _SigningContext.fromCredentials(credentials),
       _authClient = null,
       super(storageId);

  /// Creates a [NativeGoogleCloudStorage] with ADC-style signing for testing.
  ///
  /// This constructor allows testing the IAM signBlob signing path without
  /// requiring real Application Default Credentials. The [authClient] is used
  /// for IAM signBlob requests, and [email] identifies the service account.
  NativeGoogleCloudStorage.withAuthClient({
    required String storageId,
    required this.bucket,
    required this.public,
    required gcs.StorageApi storageApi,
    required String email,
    required gcs.AuthClient authClient,
    this.publicHost,
  }) : _storageApi = storageApi,
       _signingContext = _SigningContext.fromAuthClient(email, authClient),
       _authClient = null,
       super(storageId);

  /// Retrieves the default service account email from the GCE metadata server.
  ///
  /// An optional [client] can be provided for testing; otherwise uses a
  /// default HTTP client.
  static Future<String> _getServiceAccountEmail({http.Client? client}) async {
    final effectiveClient = client ?? http.Client();
    try {
      final response = await effectiveClient.get(
        Uri.parse(
          'http://metadata.google.internal/computeMetadata/v1/'
          'instance/service-accounts/default/email',
        ),
        headers: {'Metadata-Flavor': 'Google'},
      );
      if (response.statusCode != 200) {
        throw StateError(
          'Failed to get service account email from metadata server: '
          '${response.statusCode} ${response.body}',
        );
      }
      return response.body.trim();
    } finally {
      if (client == null) effectiveClient.close();
    }
  }

  /// Closes the underlying HTTP client.
  ///
  /// Call this when the storage instance is no longer needed to free
  /// resources. After calling [close], no further operations should be
  /// performed on this instance.
  ///
  /// Has no effect if this instance was created with a test constructor
  /// ([withStorageApi], [withSigningCredentials], [withAuthClient]).
  void close() {
    _authClient?.close();
  }

  @override
  Future<void> storeFile({
    required Session session,
    required String path,
    required ByteData byteData,
    DateTime? expiration,
    bool verified = true,
  }) async {
    final media = gcs.Media(
      Stream.value(Uint8List.sublistView(byteData)),
      byteData.lengthInBytes,
    );

    final object = gcs.Object()
      ..name = path
      ..bucket = bucket;

    await _storageApi.objects.insert(
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
    try {
      final response = await _storageApi.objects.get(
        bucket,
        path,
        downloadOptions: gcs.DownloadOptions.fullMedia,
      );

      if (response is! gcs.Media) {
        return null;
      }

      final bytes = await _collectBytes(response.stream);
      return ByteData.sublistView(bytes);
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
    try {
      await _storageApi.objects.get(bucket, path);
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
    try {
      await _storageApi.objects.delete(bucket, path);
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
    final signingContext = _signingContext;
    if (signingContext == null) {
      return null;
    }

    final fileName = p.basename(path);
    final contentType = lookupMimeType(fileName) ?? 'application/octet-stream';
    final acl = public ? 'public-read' : 'private';

    final headers = <String, String>{
      'Content-Type': contentType,
      'x-goog-acl': acl,
    };

    final signedUrl = await _createSignedUrl(
      signingContext: signingContext,
      bucket: bucket,
      path: path,
      expiration: expirationDuration,
      method: 'PUT',
      headers: headers,
    );

    return jsonEncode({
      'url': signedUrl,
      'type': 'binary',
      'method': 'PUT',
      'file-name': fileName,
      'headers': headers,
    });
  }

  @override
  Future<void> storeFileWithOptions({
    required Session session,
    required String path,
    required ByteData byteData,
    DateTime? expiration,
    bool verified = true,
    required CloudStorageOptions options,
  }) async {
    final media = gcs.Media(
      Stream.value(Uint8List.sublistView(byteData)),
      byteData.lengthInBytes,
    );

    final object = gcs.Object()
      ..name = path
      ..bucket = bucket;

    await _storageApi.objects.insert(
      object,
      bucket,
      uploadMedia: media,
      predefinedAcl: public ? 'publicRead' : null,
      ifGenerationMatch: options.preventOverwrite ? '0' : null,
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
        'Content length (${options.contentLength} bytes) exceeds maximum file size ($maxFileSize bytes).',
      );
    }

    final signingContext = _signingContext;
    if (signingContext == null) {
      return null;
    }

    final fileName = p.basename(path);
    final contentType = lookupMimeType(fileName) ?? 'application/octet-stream';
    final acl = public ? 'public-read' : 'private';

    final headers = <String, String>{
      'Content-Type': contentType,
      'x-goog-acl': acl,
    };
    if (options.contentLength != null) {
      headers['Content-Length'] = options.contentLength.toString();
    }
    if (options.preventOverwrite) {
      headers['x-goog-if-generation-match'] = '0';
    }

    final signedUrl = await _createSignedUrl(
      signingContext: signingContext,
      bucket: bucket,
      path: path,
      expiration: expirationDuration,
      method: 'PUT',
      headers: headers,
    );

    return jsonEncode({
      'url': signedUrl,
      'type': 'binary',
      'method': 'PUT',
      'file-name': fileName,
      'headers': headers,
    });
  }

  /// Creates a V4 signed URL for GCS operations.
  Future<String> _createSignedUrl({
    required _SigningContext signingContext,
    required String bucket,
    required String path,
    required Duration expiration,
    required String method,
    Map<String, String> headers = const {},
  }) async {
    final now = DateTime.now().toUtc();
    final datestamp = _formatDatestamp(now);
    final timestamp = _formatTimestamp(now);

    final host = 'storage.googleapis.com';
    final encodedPath = path.split('/').map(Uri.encodeComponent).join('/');
    final canonicalUri = '/$bucket/$encodedPath';
    final credentialScope = '$datestamp/auto/storage/goog4_request';

    // Build canonical headers (must be sorted by lowercase header name)
    final allHeaders = {
      'host': host,
      for (final entry in headers.entries) entry.key.toLowerCase(): entry.value,
    };
    final sortedHeaderNames = allHeaders.keys.toList()..sort();
    final canonicalHeaders =
        '${sortedHeaderNames.map((k) => '$k:${allHeaders[k]}').join('\n')}\n';
    final signedHeaders = sortedHeaderNames.join(';');

    // Build canonical query string (must be sorted by parameter name)
    final queryParams = {
      'X-Goog-Algorithm': 'GOOG4-RSA-SHA256',
      'X-Goog-Credential': '${signingContext.email}/$credentialScope',
      'X-Goog-Date': timestamp,
      'X-Goog-Expires': expiration.inSeconds.toString(),
      'X-Goog-SignedHeaders': signedHeaders,
    };
    final sortedQueryKeys = queryParams.keys.toList()..sort();

    final canonicalQueryString = sortedQueryKeys
        .map((k) => '${_uriEncode(k)}=${_uriEncode(queryParams[k]!)}')
        .join('&');

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

    // Sign the string
    final signature = await signingContext.sign(utf8.encode(stringToSign));
    final signatureHex = signature
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();

    // Build final URL
    return 'https://$host$canonicalUri?$canonicalQueryString&X-Goog-Signature=$signatureHex';
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

  @override
  Future<bool> verifyDirectFileUpload({
    required Session session,
    required String path,
  }) async {
    return fileExists(session: session, path: path);
  }

  /// Collects all bytes from a stream into a single Uint8List.
  Future<Uint8List> _collectBytes(Stream<List<int>> stream) async {
    final builder = BytesBuilder(copy: false);
    await for (final chunk in stream) {
      builder.add(chunk);
    }
    return builder.takeBytes();
  }
}

/// Abstraction over signing strategies for V4 signed URL generation.
///
/// Supports both service account credentials (local RSA signing via
/// pointycastle) and Application Default Credentials (IAM signBlob API).
class _SigningContext {
  final String email;
  final RSAPrivateKey? _privateKey;
  final gcs.AuthClient? _authClient;

  /// Creates a signing context from service account credentials.
  ///
  /// Parses the private key from the credentials JSON and signs locally
  /// using RSA-SHA256 — no network call needed.
  _SigningContext.fromCredentials(gcs.ServiceAccountCredentials credentials)
    : email = credentials.email,
      _privateKey = _parsePrivateKey(credentials),
      _authClient = null;

  /// Creates a signing context from an authenticated client (ADC).
  ///
  /// Signs via the IAM signBlob API — requires
  /// `iam.serviceAccounts.signBlob` permission.
  _SigningContext.fromAuthClient(this.email, gcs.AuthClient authClient)
    : _privateKey = null,
      _authClient = authClient;

  /// Signs the given [data] and returns the raw signature bytes.
  Future<Uint8List> sign(List<int> data) async {
    if (_privateKey != null) {
      return _rsaSign(_privateKey, data);
    }
    return _iamSignBlob(_authClient!, email, data);
  }

  /// Signs data locally using RSA-SHA256 with pointycastle.
  static Uint8List _rsaSign(RSAPrivateKey privateKey, List<int> data) {
    final signer = RSASigner(SHA256Digest(), '0609608648016503040201');
    signer.init(true, PrivateKeyParameter<RSAPrivateKey>(privateKey));
    final signature = signer.generateSignature(Uint8List.fromList(data));
    return signature.bytes;
  }

  /// Signs data via the IAM Credentials signBlob API.
  static Future<Uint8List> _iamSignBlob(
    gcs.AuthClient authClient,
    String email,
    List<int> data,
  ) async {
    final url = Uri.parse(
      'https://iamcredentials.googleapis.com/v1/'
      'projects/-/serviceAccounts/$email:signBlob',
    );

    final response = await authClient.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'payload': base64.encode(data)}),
    );

    if (response.statusCode != 200) {
      throw StateError(
        'IAM signBlob failed: ${response.statusCode} ${response.body}',
      );
    }

    final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    return base64.decode(responseJson['signedBlob'] as String);
  }

  /// Parses the RSA private key from service account credentials.
  ///
  /// The private key PEM is embedded in the JSON that was used to create
  /// the [ServiceAccountCredentials]. We re-parse it here since
  /// googleapis_auth <2.1.0 does not expose a `.sign()` method.
  static RSAPrivateKey _parsePrivateKey(
    gcs.ServiceAccountCredentials credentials,
  ) {
    // ServiceAccountCredentials stores the private key as an RSAPrivateKey
    // internally, but doesn't expose signing until 2.1.0. We access the
    // private key PEM via the credentials' JSON representation.
    final pem = credentials.privateKey;
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
}
