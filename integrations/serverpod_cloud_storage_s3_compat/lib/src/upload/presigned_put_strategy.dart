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
    bool preventOverwrite = false,
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

    // Build headers that need to be signed
    final signedHeaderMap = <String, String>{
      'host': host,
      'x-amz-content-sha256': payloadHash,
      'x-amz-date': datetime,
    };
    if (preventOverwrite) {
      signedHeaderMap['if-none-match'] = '*';
    }

    final sortedHeaderNames = signedHeaderMap.keys.toList()..sort();
    final signedHeaders = sortedHeaderNames.join(';');
    final canonicalHeaderLines = sortedHeaderNames
        .map((k) => '$k:${signedHeaderMap[k]}')
        .join('\n');

    // URL-encode each path segment for the canonical request
    final encodedPath = objectPath
        .split('/')
        .map(Uri.encodeComponent)
        .join('/');
    final canonicalRequest =
        '''PUT
$encodedPath

$canonicalHeaderLines

$signedHeaders
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
        'SignedHeaders=$signedHeaders, '
        'Signature=$signature';

    final uri = Uri(
      scheme: bucketUri.scheme,
      host: bucketUri.host,
      port: bucketUri.port,
      path: objectPath,
    );

    final requestHeaders = <String, String>{
      'Authorization': authorization,
      ...signedHeaderMap,
    };

    final client = http.Client();
    try {
      final response = await client.put(
        uri,
        headers: requestHeaders,
        body: payloadBytes,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      }

      if (response.statusCode == 403) {
        throw NoPermissionsException(response);
      }

      throw S3Exception(response);
    } finally {
      client.close();
    }
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
    int? contentLength,
    bool preventOverwrite = false,
  }) async {
    final fileName = p.basename(path);
    final contentType = lookupMimeType(fileName) ?? 'application/octet-stream';

    final headers = <String, String>{
      'Content-Type': contentType,
    };
    if (contentLength != null) {
      headers['Content-Length'] = contentLength.toString();
    }
    if (preventOverwrite) {
      headers['If-None-Match'] = '*';
    }

    final presignedUrl = _createPresignedUrl(
      accessKey: accessKey,
      secretKey: secretKey,
      bucket: bucket,
      region: region,
      path: path,
      expiration: expiration,
      endpoints: endpoints,
      headers: headers,
    );

    final uploadDescriptionData = {
      'url': presignedUrl,
      'type': uploadType,
      'method': 'PUT',
      'file-name': fileName,
      'headers': headers,
    };

    return jsonEncode(uploadDescriptionData);
  }

  /// Creates a presigned PUT URL for direct uploads.
  ///
  /// The [headers] map contains all headers that should be signed into the URL.
  /// The client must send exactly these headers when making the PUT request.
  String _createPresignedUrl({
    required String accessKey,
    required String secretKey,
    required String bucket,
    required String region,
    required String path,
    required Duration expiration,
    required S3EndpointConfig endpoints,
    required Map<String, String> headers,
  }) {
    final bucketUri = endpoints.buildBucketUri(bucket, region);
    final objectPath = bucketUri.path.endsWith('/')
        ? '${bucketUri.path}$path'
        : '${bucketUri.path}/$path';

    final datetime = SigV4.generateDatetime();
    final credentialScope = SigV4.buildCredentialScope(datetime, region, 's3');

    final host = bucketUri.host;

    // Build canonical headers (must be sorted by lowercase key)
    final allHeaders = {
      'host': host,
      for (final entry in headers.entries) entry.key.toLowerCase(): entry.value,
    };
    final sortedHeaderNames = allHeaders.keys.toList()..sort();
    final signedHeaders = sortedHeaderNames.join(';');
    final canonicalHeaderLines = sortedHeaderNames
        .map((k) => '$k:${allHeaders[k]}')
        .join('\n');

    final queryParams = <String, String>{
      'X-Amz-Algorithm': 'AWS4-HMAC-SHA256',
      'X-Amz-Credential': '$accessKey/$credentialScope',
      'X-Amz-Date': datetime,
      'X-Amz-Expires': expiration.inSeconds.toString(),
      'X-Amz-SignedHeaders': signedHeaders,
    };

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
$canonicalHeaderLines

$signedHeaders
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
