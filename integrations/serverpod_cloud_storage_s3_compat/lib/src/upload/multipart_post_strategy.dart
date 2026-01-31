import 'dart:convert';
import 'dart:typed_data';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import '../client/exceptions.dart';
import '../endpoints/s3_endpoint_config.dart';
import 'policy.dart';
import 's3_upload_strategy.dart';

/// Upload strategy using multipart POST with presigned policy.
///
/// This is the standard upload mechanism for AWS S3, GCP (via S3 compatibility),
/// and MinIO. It uses a presigned policy document to authorize uploads.
class MultipartPostUploadStrategy implements S3UploadStrategy {
  @override
  String get uploadType => 'multipart';

  @override
  Future<String> uploadData({
    required String accessKey,
    required String secretKey,
    required String bucket,
    required String region,
    required ByteData data,
    required String path,
    required bool public,
    required S3EndpointConfig endpoints,
  }) async {
    final uploadUri = endpoints.buildBucketUri(bucket, region);

    final stream = http.ByteStream.fromBytes(data.buffer.asUint8List());
    final length = data.lengthInBytes;

    final req = http.MultipartRequest('POST', uploadUri);
    final multipartFile = http.MultipartFile(
      'file',
      stream,
      length,
      filename: p.basename(path),
    );

    final policy = Policy.fromS3PresignedPost(
      path,
      bucket,
      accessKey,
      15,
      length,
      region: region,
      public: public,
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
    req.fields['acl'] = public ? 'public-read' : 'private';
    req.fields['X-Amz-Credential'] = policy.credential;
    req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
    req.fields['X-Amz-Date'] = policy.datetime;
    req.fields['Policy'] = policy.encode();
    req.fields['X-Amz-Signature'] = signature;

    final res = await req.send();
    final response = await http.Response.fromStream(res);

    if (response.statusCode == 204) {
      return uploadUri.replace(path: '/${policy.key}').toString();
    }

    if (response.statusCode == 403) {
      throw NoPermissionsException(response);
    }

    throw S3Exception(response);
  }

  @override
  Future<String?> createDirectUploadDescription({
    required String accessKey,
    required String secretKey,
    required String bucket,
    required String region,
    required String path,
    required Duration expiration,
    required int maxFileSize,
    required bool public,
    required S3EndpointConfig endpoints,
  }) async {
    final uploadUri = endpoints.buildBucketUri(bucket, region);

    final policy = Policy.fromS3PresignedPost(
      path,
      bucket,
      accessKey,
      expiration.inMinutes,
      maxFileSize,
      region: region,
      public: public,
    );
    final signingKey = SigV4.calculateSigningKey(
      secretKey,
      policy.datetime,
      region,
      's3',
    );
    final signature = SigV4.calculateSignature(signingKey, policy.encode());

    final uploadDescriptionData = {
      'url': uploadUri.toString(),
      'type': uploadType,
      'field': 'file',
      'file-name': p.basename(path),
      'request-fields': {
        'key': policy.key,
        'acl': public ? 'public-read' : 'private',
        'X-Amz-Credential': policy.credential,
        'X-Amz-Algorithm': 'AWS4-HMAC-SHA256',
        'X-Amz-Date': policy.datetime,
        'Policy': policy.encode(),
        'X-Amz-Signature': signature,
      },
    };

    return jsonEncode(uploadDescriptionData);
  }
}
