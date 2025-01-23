import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/service.dart';
import '../aws_s3_client/client/client.dart';
import '../aws_s3_upload/aws_s3_upload.dart';

/// Concrete implementation of S3 cloud storage for use with Serverpod.
class GoogleCloudStorage extends CloudStorage {
  late final String _hmacAccessKeyId;
  late final String _hmacSecretKey;
  final String region;
  final String bucket;
  final bool public;
  late final String publicHost;

  late final GCPS3Client _s3Client;

  /// Creates a new [GoogleCloudStorage] reference.
  GoogleCloudStorage({
    required Serverpod serverpod,
    required String storageId,
    required this.public,
    required this.region,
    required this.bucket,
    String? publicHost,
  }) : super(storageId) {
    serverpod.loadCustomPasswords([
      (envName: 'SERVERPOD_HMAC_ACCESS_KEY_ID', alias: 'HMACAccessKeyId'),
      (envName: 'SERVERPOD_HMAC_SECRET_KEY', alias: 'HMACSecretKey'),
    ]);

    var hmacAccessKeyId = serverpod.getPassword('HMACAccessKeyId');
    var hmacSecretKey = serverpod.getPassword('HMACSecretKey');

    if (hmacAccessKeyId == null) {
      throw StateError('HMACAccessKeyId must be configured in your passwords.');
    }

    if (hmacSecretKey == null) {
      throw StateError('HMACSecretKey must be configured in your passwords.');
    }

    _hmacAccessKeyId = hmacAccessKeyId;
    _hmacSecretKey = hmacSecretKey;

    // Create client
    _s3Client = GCPS3Client(
      accessKey: _hmacAccessKeyId,
      secretKey: _hmacSecretKey,
      bucketId: bucket,
      region: region,
    );

    this.publicHost = publicHost ?? 'storage.googleapis.com/$bucket';
  }

  @override
  Future<void> storeFile({
    required String path,
    required ServiceLocator serviceLocator,
    required ByteData byteData,
    DateTime? expiration,
    bool verified = true,
  }) async {
    await GCPS3Uploader.uploadData(
      accessKey: _hmacAccessKeyId,
      secretKey: _hmacSecretKey,
      bucket: bucket,
      region: region,
      data: byteData,
      uploadDst: path,
      public: public,
    );
  }

  @override
  Future<ByteData?> retrieveFile({
    required String path,
    required ServiceLocator serviceLocator,
  }) async {
    final response = await _s3Client.getObject(path);
    if (response.statusCode == 200) {
      return ByteData.view(response.bodyBytes.buffer);
    }
    return null;
  }

  @override
  Future<Uri?> getPublicUrl({
    required String path,
    required ServiceLocator serviceLocator,
  }) async {
    if (await fileExists(serviceLocator: serviceLocator, path: path)) {
      return Uri.parse('https://$publicHost/$path');
    }
    return null;
  }

  @override
  Future<bool> fileExists({
    required String path,
    required ServiceLocator serviceLocator,
  }) async {
    var response = await _s3Client.headObject(path);
    return response.statusCode == 200;
  }

  @override
  Future<void> deleteFile({
    required String path,
    required ServiceLocator serviceLocator,
  }) async {
    await _s3Client.deleteObject(path);
  }

  @override
  Future<String?> createDirectFileUploadDescription({
    required String path,
    required ServiceLocator serviceLocator,
    Duration expirationDuration = const Duration(minutes: 10),
    int maxFileSize = 10 * 1024 * 1024,
  }) async {
    return await GCPS3Uploader.getDirectUploadDescription(
      accessKey: _hmacAccessKeyId,
      secretKey: _hmacSecretKey,
      bucket: bucket,
      region: region,
      uploadDst: path,
      expires: expirationDuration,
      maxFileSize: maxFileSize,
    );
  }

  @override
  Future<bool> verifyDirectFileUpload({
    required String path,
    required ServiceLocator serviceLocator,
  }) async {
    return fileExists(serviceLocator: serviceLocator, path: path);
  }
}
