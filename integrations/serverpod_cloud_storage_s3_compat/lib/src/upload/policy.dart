import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';

/// Represents an S3 presigned POST policy.
///
/// Used to generate the policy document and signature required for
/// uploading files directly to S3-compatible storage.
class Policy {
  /// The expiration timestamp for this policy.
  final String expiration;

  /// The AWS region (or equivalent for other providers).
  final String region;

  /// The bucket name.
  final String bucket;

  /// The key (path) where the file will be stored.
  final String key;

  /// The credential string for signing.
  final String credential;

  /// The datetime string in AWS format.
  final String datetime;

  /// Maximum allowed file size in bytes.
  final int maxFileSize;

  /// Whether the uploaded file should be publicly accessible.
  final bool public;

  /// Creates a new policy with the given parameters.
  Policy({
    required this.key,
    required this.bucket,
    required this.datetime,
    required this.expiration,
    required this.credential,
    required this.maxFileSize,
    this.region = 'us-east-1',
    this.public = true,
  });

  /// Creates a policy for S3 presigned POST uploads.
  ///
  /// [key] is the destination path for the file.
  /// [bucket] is the target bucket name.
  /// [accessKeyId] is the access key for signing.
  /// [expiryMinutes] is how long the policy is valid.
  /// [maxFileSize] is the maximum allowed upload size in bytes.
  /// [region] is the AWS region (default: 'us-east-1').
  /// [public] determines if the file should be publicly readable.
  factory Policy.fromS3PresignedPost(
    String key,
    String bucket,
    String accessKeyId,
    int expiryMinutes,
    int maxFileSize, {
    String region = 'us-east-1',
    bool public = true,
  }) {
    final datetime = SigV4.generateDatetime();
    final expiration = (DateTime.now())
        .add(Duration(minutes: expiryMinutes))
        .toUtc()
        .toString()
        .split(' ')
        .join('T');
    final cred =
        '$accessKeyId/${SigV4.buildCredentialScope(datetime, region, 's3')}';

    return Policy(
      key: key,
      bucket: bucket,
      datetime: datetime,
      expiration: expiration,
      credential: cred,
      maxFileSize: maxFileSize,
      region: region,
      public: public,
    );
  }

  /// Encodes the policy as a base64 string.
  String encode() {
    final bytes = utf8.encode(toString());
    return base64.encode(bytes);
  }

  @override
  String toString() {
    return '''
{ "expiration": "$expiration",
  "conditions": [
    {"bucket": "$bucket"},
    ["starts-with", "\$key", "$key"],
    {"acl": "${public ? 'public-read' : 'private'}"},
    ["content-length-range", 1, $maxFileSize],
    {"x-amz-credential": "$credential"},
    {"x-amz-algorithm": "AWS4-HMAC-SHA256"},
    {"x-amz-date": "$datetime" }
  ]
}
''';
  }
}
