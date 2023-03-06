import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import '../aws_s3_client/client/client.dart';
import '../aws_s3_upload/aws_s3_upload.dart';

/// Concrete implementation of S3 cloud storage for use with Serverpod.
class GoogleCloudStorage extends CloudStorage {
  final String _hmacAccessKeyId;
  final String _hmacSecretKey;
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
  })  : assert(serverpod.getPassword('HMACAccessKeyId') != null,
            'HMACAccessKeyId must be present in your password.yaml file'),
        assert(serverpod.getPassword('HMACSecretKey') != null,
            'HMACSecretKey must be present in your password.yaml file'),
        _hmacAccessKeyId = serverpod.getPassword('HMACAccessKeyId')!,
        _hmacSecretKey = serverpod.getPassword('HMACSecretKey')!,
        super(storageId) {
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
    required Session session,
    required String path,
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
    required Session session,
    required String path,
  }) async {
    final response = await _s3Client.getObject(path);
    if (response.statusCode == 200) {
      return ByteData.view(response.bodyBytes.buffer);
    }
    return null;
  }

  @override
  Future<Uri?> getPublicUrl({
    required Session session,
    required String path,
  }) async {
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
    var response = await _s3Client.headObject(path);
    return response.statusCode == 200;
  }

  @override
  Future<void> deleteFile({
    required Session session,
    required String path,
  }) async {
    await _s3Client.deleteObject(path);
  }

  @override
  Future<String?> createDirectFileUploadDescription({
    required Session session,
    required String path,
    Duration expirationDuration = const Duration(minutes: 10),
  }) async {
    return await GCPS3Uploader.getDirectUploadDescription(
      accessKey: _hmacAccessKeyId,
      secretKey: _hmacSecretKey,
      bucket: bucket,
      region: region,
      uploadDst: path,
    );
  }

  @override
  Future<bool> verifyDirectFileUpload({
    required Session session,
    required String path,
  }) async {
    return fileExists(session: session, path: path);
  }
}
