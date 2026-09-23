import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:serverpod_push_core_server/src/providers/sns/aws_sig_v4.dart';
import 'package:test/test.dart';

void main() {
  test('signingKey matches the AWS Signature Version 4 example.', () {
    final key = AwsSigV4.signingKey(
      secretAccessKey: 'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY',
      dateStamp: '20120215',
      region: 'us-east-1',
      service: 'iam',
    );
    expect(
      key.map((final b) => b.toRadixString(16).padLeft(2, '0')).join(),
      'f4780e2d9f65fa895f9c67b32ce1baf0b0d8a43505a000a1a9e090d414db404d',
    );
  });

  test('canonicalRequest keeps the blank line AWS requires.', () {
    const body = 'Action=Publish&Version=2010-03-31';
    final hash = sha256.convert(utf8.encode(body)).toString();
    const headers =
        'content-type:application/x-www-form-urlencoded\n'
        'host:sns.us-east-1.amazonaws.com\n'
        'x-amz-date:20150830T123600Z\n';

    final canonical = AwsSigV4.canonicalRequest(
      method: 'POST',
      uri: Uri.parse('https://sns.us-east-1.amazonaws.com/'),
      canonicalHeaders: headers,
      signedHeaders: 'content-type;host;x-amz-date',
      payloadHash: hash,
    );

    expect(canonical, '''
POST
/

content-type:application/x-www-form-urlencoded
host:sns.us-east-1.amazonaws.com
x-amz-date:20150830T123600Z

content-type;host;x-amz-date
$hash''');
  });

  test('signedHeaders include the session token when one is set.', () {
    final headers = AwsSigV4.signedHeaders(
      method: 'POST',
      uri: Uri.parse('https://sns.us-east-1.amazonaws.com/'),
      body: 'Action=Publish&Version=2010-03-31',
      accessKeyId: 'AKIATEST',
      secretAccessKey: 'secret',
      region: 'us-east-1',
      service: 'sns',
      now: DateTime.utc(2015, 8, 30, 12, 36),
      sessionToken: 'session-token',
    );

    expect(headers['X-Amz-Date'], '20150830T123600Z');
    expect(headers['X-Amz-Security-Token'], 'session-token');
    expect(
      headers['Authorization'],
      contains(
        'SignedHeaders=content-type;host;x-amz-date;x-amz-security-token',
      ),
    );
    expect(
      headers['Authorization'],
      contains('Credential=AKIATEST/20150830/us-east-1/sns/aws4_request'),
    );
  });
}
