import 'dart:typed_data';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';

import '../client/exceptions.dart';
import '../config/s3_endpoint_config.dart';
import 'policy.dart';
import 's3_upload_strategy.dart';

/// Upload strategy using multipart POST with presigned policy.
///
/// This is the standard upload mechanism for AWS S3, GCP (via S3 compatibility),
/// and LocalStack. It uses a presigned policy document to authorize uploads.
///
class MultipartPostUploadStrategy implements S3UploadStrategy {
  @override
  String get uploadType => 'multipart';

  @override
  bool get supportsPreventOverwrite => false;

  @override
  Future<void> uploadData({
    required String accessKey,
    required String secretKey,
    required String bucket,
    required String region,
    required ByteData data,
    required String path,
    required bool public,
    required S3EndpointConfig endpoints,
    FileMetadata metadata = const FileMetadata(),
    bool preventOverwrite = false,
  }) async {
    if (preventOverwrite) {
      throw CloudStorageException(
        'Multipart POST uploads cannot prevent overwrites.',
      );
    }
    final uploadUri = endpoints.buildBucketUri(bucket, region);
    final stream = http.ByteStream.fromBytes(Uint8List.sublistView(data));
    final length = data.lengthInBytes;

    final req = http.MultipartRequest('POST', uploadUri);
    final multipartFile = http.MultipartFile(
      'file',
      stream,
      length,
      filename: p.basename(path),
    );

    final supportsAcl = endpoints.supportsObjectAcl;
    final metadataFields = _metadataFields(metadata);
    final policy = Policy.fromS3PresignedPost(
      path,
      bucket,
      accessKey,
      Duration(minutes: 15),
      length,
      region: region,
      public: public,
      includeAcl: supportsAcl,
      fields: metadataFields,
    );
    final signingKey = SigV4.calculateSigningKey(
      secretKey,
      policy.datetime,
      region,
      's3',
    );
    final signature = SigV4.calculateSignature(signingKey, policy.encode());

    req.files.add(multipartFile);
    req.fields['key'] = policy.key;
    if (supportsAcl) {
      req.fields['acl'] = public ? 'public-read' : 'private';
    }
    req.fields['X-Amz-Credential'] = policy.credential;
    req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
    req.fields['X-Amz-Date'] = policy.datetime;
    req.fields['Policy'] = policy.encode();
    req.fields['X-Amz-Signature'] = signature;
    req.fields.addAll(metadataFields);

    final res = await req.send();
    final response = await http.Response.fromStream(res);

    if (response.statusCode == 204) {
      return;
    }

    if (response.statusCode == 403) {
      throw NoPermissionsException(response);
    }

    throw S3Exception(response);
  }

  @override
  Future<UploadDescription> createUploadDescription({
    required String accessKey,
    required String secretKey,
    required String bucket,
    required String region,
    required String path,
    required Duration expiration,
    required int maxFileSize,
    required bool public,
    required S3EndpointConfig endpoints,
    FileMetadata metadata = const FileMetadata(),
    int? contentLength,
    bool preventOverwrite = false,
  }) async {
    if (preventOverwrite) {
      throw CloudStorageException(
        'Multipart POST uploads cannot prevent overwrites.',
      );
    }
    final uploadUri = endpoints.buildBucketUri(bucket, region);
    final supportsAcl = endpoints.supportsObjectAcl;
    final metadataFields = _metadataFields(metadata);

    final policy = Policy.fromS3PresignedPost(
      path,
      bucket,
      accessKey,
      expiration,
      contentLength ?? maxFileSize,
      region: region,
      public: public,
      includeAcl: supportsAcl,
      minFileSize: contentLength ?? 1,
      fields: metadataFields,
    );
    final signingKey = SigV4.calculateSigningKey(
      secretKey,
      policy.datetime,
      region,
      's3',
    );
    final signature = SigV4.calculateSignature(signingKey, policy.encode());

    final requestFields = {
      'key': policy.key,
      if (supportsAcl) 'acl': public ? 'public-read' : 'private',
      'X-Amz-Credential': policy.credential,
      'X-Amz-Algorithm': 'AWS4-HMAC-SHA256',
      'X-Amz-Date': policy.datetime,
      'Policy': policy.encode(),
      'X-Amz-Signature': signature,
      ...metadataFields,
    };

    return MultipartUploadDescription(
      url: uploadUri,
      field: 'file',
      fileName: p.basename(path),
      requestFields: requestFields,
    );
  }

  static Map<String, String> _metadataFields(FileMetadata metadata) => {
    if (metadata.contentType != null) 'Content-Type': metadata.contentType!,
    if (metadata.cacheControl != null) 'Cache-Control': metadata.cacheControl!,
    if (metadata.contentDisposition != null)
      'Content-Disposition': metadata.contentDisposition!,
    if (metadata.contentEncoding != null)
      'Content-Encoding': metadata.contentEncoding!,
    for (final entry in metadata.custom.entries)
      'x-amz-meta-${entry.key}': entry.value,
  };
}
