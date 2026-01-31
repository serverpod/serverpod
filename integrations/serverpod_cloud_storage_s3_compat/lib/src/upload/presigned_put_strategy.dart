import 'dart:convert';
import 'dart:typed_data';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

import '../client/exceptions.dart';
import '../endpoints/s3_endpoint_config.dart';
import 's3_upload_strategy.dart';

/// Upload strategy using PUT with presigned URLs.
///
/// This is used by providers like Cloudflare R2 that don't support
/// POST with presigned policy. Instead, they use PUT requests with
/// the signature in the URL query parameters.
class PresignedPutUploadStrategy implements S3UploadStrategy {
  @override
  String get uploadType => 'binary';

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
  }) async {
    final bucketUri = endpoints.buildBucketUri(bucket, region);
    final objectPath = bucketUri.path.endsWith('/')
        ? '${bucketUri.path}$path'
        : '${bucketUri.path}/$path';

    final datetime = SigV4.generateDatetime();
    final credentialScope = SigV4.buildCredentialScope(datetime, region, 's3');

    // For PUT uploads, we hash the actual payload bytes using SHA256
    final payloadBytes = Uint8List.sublistView(data);
    final payloadHash = sha256.convert(payloadBytes).toString();

    final host = bucketUri.host;
    // URL-encode each path segment for the canonical request
    final encodedPath = objectPath
        .split('/')
        .map(Uri.encodeComponent)
        .join('/');
    final canonicalRequest =
        '''PUT
$encodedPath

host:$host
x-amz-content-sha256:$payloadHash
x-amz-date:$datetime

host;x-amz-content-sha256;x-amz-date
$payloadHash''';

    final stringToSign = SigV4.buildStringToSign(
      datetime,
      credentialScope,
      SigV4.hashCanonicalRequest(canonicalRequest),
    );

    final signingKey = SigV4.calculateSigningKey(
      secretKey,
      datetime,
      region,
      's3',
    );
    final signature = SigV4.calculateSignature(signingKey, stringToSign);

    final authorization =
        'AWS4-HMAC-SHA256 Credential=$accessKey/$credentialScope, '
        'SignedHeaders=host;x-amz-content-sha256;x-amz-date, '
        'Signature=$signature';

    final uri = Uri(
      scheme: bucketUri.scheme,
      host: bucketUri.host,
      port: bucketUri.port,
      path: objectPath,
    );

    final response = await http.put(
      uri,
      headers: {
        'Authorization': authorization,
        'x-amz-content-sha256': payloadHash,
        'x-amz-date': datetime,
        'host': host,
      },
      body: payloadBytes,
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
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
    final presignedUrl = _createPresignedUrl(
      accessKey: accessKey,
      secretKey: secretKey,
      bucket: bucket,
      region: region,
      path: path,
      expiration: expiration,
      endpoints: endpoints,
    );

    final fileName = p.basename(path);
    final contentType = lookupMimeType(fileName) ?? 'application/octet-stream';

    final uploadDescriptionData = {
      'url': presignedUrl,
      'type': uploadType,
      'method': 'PUT',
      'file-name': fileName,
      'headers': {
        'Content-Type': contentType,
      },
    };

    return jsonEncode(uploadDescriptionData);
  }

  /// Creates a presigned PUT URL for direct uploads.
  String _createPresignedUrl({
    required String accessKey,
    required String secretKey,
    required String bucket,
    required String region,
    required String path,
    required Duration expiration,
    required S3EndpointConfig endpoints,
  }) {
    final bucketUri = endpoints.buildBucketUri(bucket, region);
    final objectPath = bucketUri.path.endsWith('/')
        ? '${bucketUri.path}$path'
        : '${bucketUri.path}/$path';

    final datetime = SigV4.generateDatetime();
    final credentialScope = SigV4.buildCredentialScope(datetime, region, 's3');

    final queryParams = <String, String>{
      'X-Amz-Algorithm': 'AWS4-HMAC-SHA256',
      'X-Amz-Credential': '$accessKey/$credentialScope',
      'X-Amz-Date': datetime,
      'X-Amz-Expires': expiration.inSeconds.toString(),
      'X-Amz-SignedHeaders': 'host',
    };

    final host = bucketUri.host;
    final canonicalQuery = SigV4.buildCanonicalQueryString(queryParams);
    // URL-encode each path segment for the canonical request
    final encodedPath = objectPath
        .split('/')
        .map(Uri.encodeComponent)
        .join('/');
    final canonicalRequest =
        '''PUT
$encodedPath
$canonicalQuery
host:$host

host
UNSIGNED-PAYLOAD''';

    final stringToSign = SigV4.buildStringToSign(
      datetime,
      credentialScope,
      SigV4.hashCanonicalRequest(canonicalRequest),
    );

    final signingKey = SigV4.calculateSigningKey(
      secretKey,
      datetime,
      region,
      's3',
    );
    final signature = SigV4.calculateSignature(signingKey, stringToSign);

    queryParams['X-Amz-Signature'] = signature;

    final uri = Uri(
      scheme: bucketUri.scheme,
      host: bucketUri.host,
      port: bucketUri.port,
      path: objectPath,
      queryParameters: queryParams,
    );

    return uri.toString();
  }
}
