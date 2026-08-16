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

  /// Whether to include an ACL condition in the policy.
  ///
  /// Set to `false` for providers that don't support per-object ACLs
  /// (e.g. GCP with uniform bucket-level access, Cloudflare R2).
  final bool includeAcl;

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
    this.includeAcl = true,
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
    bool includeAcl = true,
  }) {
    final datetime = SigV4.generateDatetime();
    final exp = DateTime.now().add(Duration(minutes: expiryMinutes)).toUtc();
    final expiration =
        '${exp.year}-'
        '${exp.month.toString().padLeft(2, '0')}-'
        '${exp.day.toString().padLeft(2, '0')}T'
        '${exp.hour.toString().padLeft(2, '0')}:'
        '${exp.minute.toString().padLeft(2, '0')}:'
        '${exp.second.toString().padLeft(2, '0')}.000Z';
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
      includeAcl: includeAcl,
    );
  }

  /// Encodes the policy as a base64 string.
  String encode() {
    final bytes = utf8.encode(toString());
    return base64.encode(bytes);
  }

  @override
  String toString() {
    final conditions = [
      '{"bucket": "$bucket"}',
      '["starts-with", "\$key", "$key"]',
      if (includeAcl) '{"acl": "${public ? 'public-read' : 'private'}"}',
      '["content-length-range", 1, $maxFileSize]',
      '{"x-amz-credential": "$credential"}',
      '{"x-amz-algorithm": "AWS4-HMAC-SHA256"}',
      '{"x-amz-date": "$datetime" }',
    ];
    return '''
{ "expiration": "$expiration",
  "conditions": [
    ${conditions.join(',\n    ')}
  ]
}
''';
  }
}
