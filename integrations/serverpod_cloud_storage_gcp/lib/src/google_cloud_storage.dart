import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';
import 'package:gcloud/storage.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
// ignore: implementation_imports
import 'package:googleapis_auth/src/crypto/pem.dart';
// ignore: implementation_imports
import 'package:googleapis_auth/src/crypto/rsa_sign.dart';
import 'package:intl/intl.dart';
import 'package:serverpod/serverpod.dart';

/// Concrete implementation of Google Cloud Storage, using native GCP APIs,
/// for use with Serverpod.
class GoogleCloudStorage extends CloudStorage {
  final String bucket;
  final bool public;

  late final String publicHost;
  late final Storage storage;

  /// The path to service account credentials with storage admin permissions
  final String serviceAccountPath;
  late final Map<String, dynamic> _serviceAccount;

  /// Creates a new [GoogleCloudStorage] instance.
  /// Uses service account credentials to authenticate to Cloud Storage.
  ///
  /// Usage:
  ///   final publicStorage = await GoogleCloudStorage.init(
  ///     serverpod: pod,
  ///     storageId: 'public',
  ///     public: true,
  ///     bucket: myBucket,
  ///     serviceAccountPath: '/config/google_account_credentials.json',
  ///   );
  ///
  ///   pod.addCloudStorage(publicStorage);
  static Future<GoogleCloudStorage> init({
    required Serverpod serverpod,
    required String storageId,
    required bool public,
    required String bucket,
    required String serviceAccountPath,
    String? publicHost,
  }) async {
    final instance = GoogleCloudStorage._(
      serverpod: serverpod,
      storageId: storageId,
      public: public,
      bucket: bucket,
      serviceAccountPath: serviceAccountPath,
    );

    await instance._initStorage();

    return instance;
  }

  // Initializes the Google Cloud Storage client.
  Future<void> _initStorage() async {
    final serviceAccount = await File(serviceAccountPath).readAsString();
    _serviceAccount = jsonDecode(serviceAccount);

    var json = jsonDecode(serviceAccount);
    final project = json['project_id'] as String;

    final credentials = auth.ServiceAccountCredentials.fromJson(serviceAccount);

    final client =
        await auth.clientViaServiceAccount(credentials, Storage.SCOPES);

    storage = Storage(client, project);
  }

  // Private constructor
  GoogleCloudStorage._({
    required Serverpod serverpod,
    required String storageId,
    required this.public,
    required this.bucket,
    required this.serviceAccountPath,
    String? publicHost,
  }) : super(storageId) {
    this.publicHost = publicHost ?? 'storage.googleapis.com/$bucket';
  }

  @override
  Future<void> storeFile({
    required Session session,
    required String path,
    required ByteData byteData,
    DateTime? expiration,
    bool verified = true,
  }) async {
    await storage
        .bucket(bucket)
        .writeBytes(path, byteData.buffer.asUint8List());
  }

  @override
  Future<ByteData?> retrieveFile({
    required Session session,
    required String path,
  }) async {
    var byteLists = await storage.bucket(bucket).read(path).toList();
    var totLength =
        byteLists.fold<int>(0, (prev, element) => prev + element.length);
    var bytes = Uint8List(totLength);
    var offset = 0;
    for (var byteList in byteLists) {
      bytes.setRange(offset, offset + byteList.length, byteList);
      offset += byteList.length;
    }
    return ByteData.view(bytes.buffer);
  }

  @override
  Future<Uri?> getPublicUrl({
    required Session session,
    required String path,
  }) async {
    if (!public) return null;

    if (await fileExists(session: session, path: path)) {
      return Uri.parse('https://$publicHost/$path');
    }

    return null;
  }

  @override
  Future<bool> fileExists({
    required Session session,
    required String path,
  }) async {
    try {
      await storage.bucket(bucket).info(path);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> deleteFile({
    required Session session,
    required String path,
  }) async {
    await storage.bucket(bucket).delete(path);
  }

  // Creates a V4 signed url to allow direct API calls to cloud storage.
  String? _createSignedUrl({
    required Session session,
    required String path,
    String? subresource,
    int expiration = 604800,
    String httpMethod = 'GET',
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) {
    if (expiration > 604800) {
      session.log(
          'Expiration Time can\'t be longer than 604800 seconds (7 days).',
          level: LogLevel.error);
      return null;
    }

    final escapedObjectName = Uri.encodeComponent(path);
    final canonicalUri = "/$escapedObjectName";

    final dateTimeNow = DateTime.now().toUtc();
    final requestTimestamp =
        DateFormat("yyyyMMdd'T'HHmmss'Z'").format(dateTimeNow);
    final datestamp = DateFormat('yyyyMMdd').format(dateTimeNow);

    final clientEmail = _serviceAccount['client_email'];
    final credentialScope = '$datestamp/auto/storage/goog4_request';
    final credential = "$clientEmail/$credentialScope";

    headers ??= {};
    final host = '$bucket.storage.googleapis.com';

    headers['host'] = host;

    SplayTreeMap splayTreeMap = SplayTreeMap.from(headers);
    headers = Map.from(splayTreeMap);

    final canonicalHeaders = headers.entries
        .map((entry) =>
            '${entry.key.toLowerCase()}:${entry.value.trim().toLowerCase()}\n')
        .join();
    final signedHeaders = headers.keys.map((k) => k.toLowerCase()).join(';');

    queryParameters ??= {};
    queryParameters.addAll({
      'X-Goog-Algorithm': 'GOOG4-RSA-SHA256',
      'X-Goog-Credential': credential,
      'X-Goog-Date': requestTimestamp,
      'X-Goog-Expires': expiration.toString(),
      'X-Goog-SignedHeaders': signedHeaders,
    });
    if (subresource != null) {
      queryParameters[subresource] = '';
    }

    final canonicalQueryString = queryParameters.entries
        .map((entry) =>
            '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}')
        .join('&');

    final canonicalRequest = [
      httpMethod,
      canonicalUri,
      canonicalQueryString,
      canonicalHeaders,
      signedHeaders,
      'UNSIGNED-PAYLOAD',
    ].join("\n");

    final canonicalRequestHash =
        sha256.convert(utf8.encode(canonicalRequest)).toString();

    final stringToSign = [
      'GOOG4-RSA-SHA256',
      requestTimestamp,
      credentialScope,
      canonicalRequestHash,
    ].join('\n');

    var pem = _serviceAccount['private_key'];
    var rsaKey = keyFromString(pem!);
    var signer = RS256Signer(rsaKey);

    List<int> stringToSignList = utf8.encode(stringToSign);
    var signedRequestBytes = signer.sign(stringToSignList);
    var signature = HEX.encode(signedRequestBytes);

    final schemeAndHost = 'https://$host';
    return '$schemeAndHost$canonicalUri?$canonicalQueryString&x-goog-signature=$signature';
  }

  @override
  Future<String?> createDirectFileUploadDescription({
    required Session session,
    required String path,
    Duration expirationDuration = const Duration(minutes: 10),
    int maxFileSize = 10 * 1024 * 1024,
  }) async {
    if (await fileExists(session: session, path: path)) return null;

    final headers = {
      'content-type': 'application/octet-stream',
      'accept': '*/*',
      'x-goog-content-length-range': '0,$maxFileSize',
      if (public) 'x-goog-acl': 'public-read',
    };

    final url = _createSignedUrl(
      session: session,
      path: path,
      httpMethod: 'PUT',
      expiration: expirationDuration.inSeconds,
      headers: headers,
    );

    var uploadDescriptionData = {
      'url': url,
      'type': 'binary',
      'httpMethod': 'PUT',
      'headers': headers,
    };

    return jsonEncode(uploadDescriptionData);
  }

  @override
  Future<bool> verifyDirectFileUpload({
    required Session session,
    required String path,
  }) async {
    return fileExists(session: session, path: path);
  }
}
