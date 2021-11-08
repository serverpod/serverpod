import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';

class Policy {
  String expiration;
  String region;
  String bucket;
  String key;
  String credential;
  String datetime;
  int maxFileSize;
  bool public;

  Policy(this.key, this.bucket, this.datetime, this.expiration, this.credential, this.maxFileSize,
      {this.region = 'us-east-1', this.public = true});

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
    final expiration = (DateTime.now()).add(Duration(minutes: expiryMinutes)).toUtc().toString().split(' ').join('T');
    final cred = '$accessKeyId/${SigV4.buildCredentialScope(datetime, region, 's3')}';

    return Policy(key, bucket, datetime, expiration, cred, maxFileSize, region: region, public: public);
  }

  String encode() {
    final bytes = utf8.encode(toString());
    return base64.encode(bytes);
  }

  @override
  String toString() {
    return '''
{ "expiration": "${this.expiration}",
  "conditions": [
    {"bucket": "${this.bucket}"},
    ["starts-with", "\$key", "${this.key}"],
    {"acl": "${ public ? 'public-read' : 'private' }"},
    ["content-length-range", 1, ${this.maxFileSize}],
    {"x-amz-credential": "${this.credential}"},
    {"x-amz-algorithm": "AWS4-HMAC-SHA256"},
    {"x-amz-date": "${this.datetime}" }
  ]
}
''';
  }
}
