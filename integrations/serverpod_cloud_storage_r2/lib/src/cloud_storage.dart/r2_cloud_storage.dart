import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import '../cloudflare_r2_client/client/client.dart';
import '../cloudflare_r2_upload/cloudflare_r2_upload.dart';

/// Concrete implementation of Cloudflare R2 cloud storage for use with Serverpod.
class R2CloudStorage extends CloudStorage {
  late final String _r2AccessKeyId;
  late final String _r2SecretKey;
  final String region;
  final String bucket;
  final String accountId;
  final bool public;
  late final String publicHost;

  late final CloudflareR2Client _r2Client;

  /// Creates a new [R2CloudStorage] reference.
  R2CloudStorage({
    required Serverpod serverpod,
    required String storageId,
    required this.public,
    required this.region,
    required this.bucket,
    required this.accountId,
    String? publicHost,
  }) : super(storageId) {
    serverpod.loadCustomPasswords([
      (envName: 'SERVERPOD_R2_ACCESS_KEY_ID', alias: 'R2AccessKeyId'),
      (envName: 'SERVERPOD_R2_SECRET_KEY', alias: 'R2SecretKey'),
    ]);

    var r2AccessKeyId = serverpod.getPassword('R2AccessKeyId');
    var r2SecretKey = serverpod.getPassword('R2SecretKey');

    if (r2AccessKeyId == null) {
      throw StateError('R2AccessKeyId must be configured in your passwords.');
    }

    if (r2SecretKey == null) {
      throw StateError('R2SecretKey must be configured in your passwords.');
    }

    _r2AccessKeyId = r2AccessKeyId;
    _r2SecretKey = r2SecretKey;

    // Create client
    _r2Client = CloudflareR2Client(
      accessKey: _r2AccessKeyId,
      secretKey: _r2SecretKey,
      bucketId: bucket,
      accountId: accountId,
      region: region,
    );

    this.publicHost = publicHost ?? '$bucket.$accountId.r2.dev';
  }

  @override
  Future<void> storeFile({
    required Session session,
    required String path,
    required ByteData byteData,
    DateTime? expiration,
    bool verified = true,
  }) async {
    await CloudflareR2Uploader.uploadData(
      accessKey: _r2AccessKeyId,
      secretKey: _r2SecretKey,
      bucket: bucket,
      accountId: accountId,
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
    final response = await _r2Client.getObject(path);
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
    var response = await _r2Client.headObject(path);
    return response.statusCode == 200;
  }

  @override
  Future<void> deleteFile({
    required Session session,
    required String path,
  }) async {
    await _r2Client.deleteObject(path);
  }

  @override
  Future<String?> createDirectFileUploadDescription({
    required Session session,
    required String path,
    Duration expirationDuration = const Duration(minutes: 10),
    int maxFileSize = 10 * 1024 * 1024,
  }) async {
    return await CloudflareR2Uploader.getDirectUploadDescription(
      accessKey: _r2AccessKeyId,
      secretKey: _r2SecretKey,
      bucket: bucket,
      accountId: accountId,
      region: region,
      uploadDst: path,
      expires: expirationDuration,
      maxFileSize: maxFileSize,
      public: public,
    );
  }

  /// Creates a presigned PUT URL for direct file upload to R2.
  /// This is an alternative to the POST-based multipart upload.
  Future<String?> createDirectFileUploadUrl({
    required Session session,
    required String path,
    Duration expirationDuration = const Duration(minutes: 10),
    String? contentType,
  }) async {
    return await CloudflareR2Uploader.getDirectUploadUrl(
      accessKey: _r2AccessKeyId,
      secretKey: _r2SecretKey,
      bucket: bucket,
      accountId: accountId,
      region: region,
      uploadDst: path,
      expires: expirationDuration,
      contentType: contentType,
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