import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import '../aws_s3_client/client/client.dart';
import '../aws_s3_upload/aws_s3_upload.dart';

/// Concrete implementation of S3 cloud storage for use with Serverpod.
class S3CloudStorage extends CloudStorage {
  late final String _awsAccessKeyId;
  late final String _awsSecretKey;
  final String region;
  final String bucket;
  final bool public;
  late final String publicHost;

  late final AwsS3Client _s3Client;

  /// Creates a new [S3CloudStorage] reference.
  S3CloudStorage({
    required Serverpod serverpod,
    required String storageId,
    required this.public,
    required this.region,
    required this.bucket,
    String? publicHost,
  }) : super(storageId) {
    serverpod.loadCustomPasswords([
      (envName: 'SERVERPOD_AWS_ACCESS_KEY_ID', alias: 'AWSAccessKeyId'),
      (envName: 'SERVERPOD_AWS_SECRET_KEY', alias: 'AWSSecretKey'),
    ]);

    var awsAccessKeyId = serverpod.getPassword('AWSAccessKeyId');
    var awsSecretKey = serverpod.getPassword('AWSSecretKey');

    if (awsAccessKeyId == null) {
      throw StateError('HMACAccessKeyId must be configured in your passwords.');
    }

    if (awsSecretKey == null) {
      throw StateError('HMACSecretKey must be configured in your passwords.');
    }

    _awsAccessKeyId = awsAccessKeyId;
    _awsSecretKey = awsSecretKey;

    // Create client
    _s3Client = AwsS3Client(
      accessKey: _awsAccessKeyId,
      secretKey: _awsSecretKey,
      bucketId: bucket,
      region: region,
    );

    this.publicHost = publicHost ?? '$bucket.s3.$region.amazonaws.com';
  }

  @override
  Future<void> storeFile({
    required Session session,
    required String path,
    required ByteData byteData,
    DateTime? expiration,
    bool verified = true,
  }) async {
    await AwsS3Uploader.uploadData(
      accessKey: _awsAccessKeyId,
      secretKey: _awsSecretKey,
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
    int maxFileSize = 10 * 1024 * 1024,
  }) async {
    return await AwsS3Uploader.getDirectUploadDescription(
      accessKey: _awsAccessKeyId,
      secretKey: _awsSecretKey,
      bucket: bucket,
      region: region,
      uploadDst: path,
      expires: expirationDuration,
      maxFileSize: maxFileSize,
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
