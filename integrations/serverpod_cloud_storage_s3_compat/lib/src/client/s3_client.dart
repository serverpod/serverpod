import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:http/http.dart' as http;

import '../endpoints/s3_endpoint_config.dart';
import 'exceptions.dart';

/// Client for making signed requests to S3-compatible storage APIs.
///
/// This client handles AWS Signature Version 4 signing for all requests.
class S3Client {
  final String _secretKey;
  final String _accessKey;
  final String _bucket;
  final String _region;
  final S3EndpointConfig _endpoints;
  final http.Client _httpClient;

  static const _service = 's3';

  /// Creates a new S3Client.
  ///
  /// [accessKey] and [secretKey] are the credentials for signing requests.
  /// [bucket] is the target bucket name.
  /// [region] is the AWS region (or equivalent).
  /// [endpoints] provides the URL patterns for the storage provider.
  /// [httpClient] can be provided for testing or custom HTTP handling.
  S3Client({
    required String accessKey,
    required String secretKey,
    required String bucket,
    required String region,
    required S3EndpointConfig endpoints,
    http.Client? httpClient,
  }) : _accessKey = accessKey,
       _secretKey = secretKey,
       _bucket = bucket,
       _region = region,
       _endpoints = endpoints,
       _httpClient = httpClient ?? http.Client();

  /// Gets an object from the bucket.
  ///
  /// Returns the HTTP response containing the object data.
  Future<http.Response> getObject(String key) {
    return _doSignedRequest(key: key, method: 'GET');
  }

  /// Checks if an object exists in the bucket.
  ///
  /// Returns the HTTP response. Check statusCode == 200 for existence.
  Future<http.Response> headObject(String key) {
    return _doSignedRequest(key: key, method: 'HEAD');
  }

  /// Deletes an object from the bucket.
  ///
  /// Returns the HTTP response.
  Future<http.Response> deleteObject(String key) {
    return _doSignedRequest(key: key, method: 'DELETE');
  }

  /// Builds signed request parameters without executing the request.
  ///
  /// Useful for integrating with custom HTTP clients.
  SignedRequestParams buildSignedParams({
    required String key,
    Map<String, String>? queryParams,
    String method = 'GET',
  }) {
    final bucketUri = _endpoints.buildBucketUri(_bucket, _region);
    final unencodedPath = bucketUri.path.endsWith('/')
        ? '${bucketUri.path}$key'
        : '${bucketUri.path}/$key';
    final uri = Uri(
      scheme: bucketUri.scheme,
      host: bucketUri.host,
      port: bucketUri.port,
      path: unencodedPath,
      queryParameters: queryParams?.isNotEmpty == true ? queryParams : null,
    );

    // For signing, include port in host header for non-standard ports
    final hostHeader = _buildHostHeader(bucketUri);

    final payload = SigV4.hashCanonicalRequest('');
    final datetime = SigV4.generateDatetime();
    final credentialScope = SigV4.buildCredentialScope(
      datetime,
      _region,
      _service,
    );

    final canonicalQuery = SigV4.buildCanonicalQueryString(queryParams);
    // Normalize the path to avoid double slashes, then encode each segment
    final normalizedPath = unencodedPath.startsWith('/')
        ? unencodedPath
        : '/$unencodedPath';
    final encodedPath = normalizedPath
        .split('/')
        .map(Uri.encodeComponent)
        .join('/');

    final canonicalRequest =
        '''$method
$encodedPath
$canonicalQuery
host:$hostHeader
x-amz-content-sha256:$payload
x-amz-date:$datetime

host;x-amz-content-sha256;x-amz-date
$payload''';

    final stringToSign = SigV4.buildStringToSign(
      datetime,
      credentialScope,
      SigV4.hashCanonicalRequest(canonicalRequest),
    );
    final signingKey = SigV4.calculateSigningKey(
      _secretKey,
      datetime,
      _region,
      _service,
    );
    final signature = SigV4.calculateSignature(signingKey, stringToSign);

    final authorization = [
      'AWS4-HMAC-SHA256 Credential=$_accessKey/$credentialScope',
      'SignedHeaders=host;x-amz-content-sha256;x-amz-date',
      'Signature=$signature',
    ].join(',');

    return SignedRequestParams(uri, {
      'Authorization': authorization,
      'x-amz-content-sha256': payload,
      'x-amz-date': datetime,
    });
  }

  Future<http.Response> _doSignedRequest({
    required String key,
    required String method,
    Map<String, String>? queryParams,
  }) async {
    final params = buildSignedParams(
      key: key,
      queryParams: queryParams,
      method: method,
    );

    switch (method) {
      case 'GET':
        return _httpClient.get(params.uri, headers: params.headers);
      case 'HEAD':
        return _httpClient.head(params.uri, headers: params.headers);
      case 'DELETE':
        return _httpClient.delete(params.uri, headers: params.headers);
      default:
        throw ArgumentError('Unsupported HTTP method: $method');
    }
  }

  /// Checks the response for errors and throws appropriate exceptions.
  void checkResponseError(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    switch (response.statusCode) {
      case 403:
        throw NoPermissionsException(response);
      default:
        throw S3Exception(response);
    }
  }

  /// Builds the host header value, including port for non-standard ports.
  String _buildHostHeader(Uri uri) {
    // Standard ports (80 for http, 443 for https) should not include port
    final isStandardPort =
        (uri.scheme == 'https' && uri.port == 443) ||
        (uri.scheme == 'http' && uri.port == 80) ||
        uri.port == 0;

    if (isStandardPort) {
      return uri.host;
    }
    return '${uri.host}:${uri.port}';
  }
}

/// Contains the URI and headers for a signed S3 request.
class SignedRequestParams {
  /// The full URI for the request.
  final Uri uri;

  /// The headers required for the signed request.
  final Map<String, String> headers;

  /// Creates a new SignedRequestParams.
  const SignedRequestParams(this.uri, this.headers);
}
