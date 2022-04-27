import 'dart:convert';
import 'dart:io';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:built_value/serializer.dart';
import 'exceptions.dart';
import 'package:http/http.dart';
import 'package:xml2json/xml2json.dart';

import '../model/list_bucket_result.dart';
import '../model/list_bucket_result_parker.dart';

class AwsS3Client {
  final String _secretKey;
  final String _accessKey;
  final String _host;
  final String _region;
  final String _bucketId;
  final String? _sessionToken;
  final Client _client;

  static const _service = "s3";

  /// Creates a new AwsS3Client instance.
  ///
  /// @param secretKey The secret key. Required. see https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html
  /// @param accessKey The access key. Required. see https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html
  /// @param bucketId The bucket. Required. See https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingBucket.html#access-bucket-intro
  /// @param host The host, in path-style. Defaults to "s3.$region.amazonaws.com". See https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingBucket.html#access-bucket-intro
  /// @param region The region of the bucket. Required.
  /// @param sessionToken The session token. Optional.
  /// @param client The http client. Optional. Useful for debugging.
  AwsS3Client(
      {required String secretKey,
      required String accessKey,
      required String bucketId,
      String? host,
      required String region,
      String? sessionToken,
      Client? client})
      : _accessKey = accessKey,
        _secretKey = secretKey,
        _host = host ?? "s3.$region.amazonaws.com",
        _bucketId = bucketId,
        _region = region,
        _sessionToken = sessionToken,
        _client = client ?? Client();

  Future<ListBucketResult?> listObjects(
      {String? prefix, String? delimiter, int? maxKeys}) async {
    final response = await _doSignedGetRequest(key: '', queryParams: {
      "list-type": "2",
      if (prefix != null) "prefix": prefix,
      if (delimiter != null) "delimiter": delimiter,
      if (maxKeys != null) "maxKeys": maxKeys.toString(),
    });
    _checkResponseError(response);
    return _parseListObjectResponse(response.body);
  }

  Future<Response> getObject(String key) {
    return _doSignedGetRequest(key: key);
  }

  Future<Response> headObject(String key) {
    return _doSignedHeadRequest(key: key);
  }

  Future<Response> deleteObject(String key) {
    return _doSignedDeleteRequest(key: key);
  }

  String keytoPath(String key) =>
      '/$key'.split('/').map(Uri.encodeQueryComponent).join('/');

  ///Returns a [SignedRequestParams] object containing the uri and the HTTP headers
  ///needed to do a signed GET request to AWS S3. Does not actually execute a request.
  ///You can use this method to integrate this client with an HTTP client of your choice.
  SignedRequestParams buildSignedParams(
      {required String key,
      Map<String, String>? queryParams,
      String method = 'GET'}) {
    final unencodedPath = "$_bucketId/$key";
    final uri = Uri.https(_host, unencodedPath, queryParams);
    final payload = SigV4.hashCanonicalRequest('');
    final datetime = SigV4.generateDatetime();
    final credentialScope =
        SigV4.buildCredentialScope(datetime, _region, _service);

    final canonicalQuery = SigV4.buildCanonicalQueryString(queryParams);
    final canonicalRequest = '''$method
${'/$unencodedPath'.split('/').map(Uri.encodeComponent).join('/')}
$canonicalQuery
host:$_host
x-amz-content-sha256:$payload
x-amz-date:$datetime
x-amz-security-token:${_sessionToken ?? ""}

host;x-amz-content-sha256;x-amz-date;x-amz-security-token
$payload''';

    final stringToSign = SigV4.buildStringToSign(datetime, credentialScope,
        SigV4.hashCanonicalRequest(canonicalRequest));
    final signingKey =
        SigV4.calculateSigningKey(_secretKey, datetime, _region, _service);
    final signature = SigV4.calculateSignature(signingKey, stringToSign);

    final authorization = [
      'AWS4-HMAC-SHA256 Credential=$_accessKey/$credentialScope',
      'SignedHeaders=host;x-amz-content-sha256;x-amz-date;x-amz-security-token',
      'Signature=$signature',
    ].join(',');

    return SignedRequestParams(uri, {
      'Authorization': authorization,
      'x-amz-content-sha256': payload,
      'x-amz-date': datetime,
    });
  }

  Future<Response> _doSignedGetRequest({
    required String key,
    Map<String, String>? queryParams,
  }) async {
    final SignedRequestParams params =
        buildSignedParams(key: key, queryParams: queryParams);
    return _client.get(params.uri, headers: params.headers);
  }

  Future<Response> _doSignedHeadRequest({
    required String key,
    Map<String, String>? queryParams,
  }) async {
    final SignedRequestParams params =
        buildSignedParams(key: key, queryParams: queryParams, method: 'HEAD');
    return _client.head(params.uri, headers: params.headers);
  }

  Future<Response> _doSignedDeleteRequest({
    required String key,
    Map<String, String>? queryParams,
  }) async {
    final SignedRequestParams params =
        buildSignedParams(key: key, queryParams: queryParams, method: 'DELETE');
    return _client.delete(params.uri, headers: params.headers);
  }

  void _checkResponseError(Response response) {
    if (response.statusCode >= 200 && response.statusCode <= 300) {
      return;
    }
    switch (response.statusCode) {
      case 403:
        throw NoPermissionsException(response);
      default:
        throw S3Exception(response);
    }
  }
}

class SignedRequestParams {
  final Uri uri;
  final Map<String, String> headers;

  const SignedRequestParams(this.uri, this.headers);
}

/// aws s3 list bucket response string -> [ListBucketResult] object,
/// this function should be called via [compute]
ListBucketResult? _parseListObjectResponse(String responseXml) {
  //parse xml
  final Xml2Json myTransformer = Xml2Json();
  myTransformer.parse(responseXml);
  //convert xml to json
  String jsonString = myTransformer.toParker();
  //parse json to src.model objects
  try {
    ListBucketResult? parsedObj =
        ListBucketResultParker.fromJson(jsonString).result;

    return parsedObj;
  } on DeserializationError {
    //fix for https://github.com/diagnosia/flutter_aws_s3_client/issues/6
    //issue due to json/xml transform: Lists with 1 element are transformed to json objects instead of lists
    final fixedJson = json.decode(jsonString);

    fixedJson["ListBucketResult"]
        ["Contents"] = [fixedJson["ListBucketResult"]["Contents"]];

    return ListBucketResultParker.fromJsonMap(fixedJson).result;
  }
}
