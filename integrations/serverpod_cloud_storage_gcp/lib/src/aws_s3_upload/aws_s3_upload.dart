library aws_s3_upload;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import 'policy.dart';

/// Convenience class for uploading files to AWS S3
class GCPS3Uploader {
  /// Upload a file, returning the file's public URL on success.
  static Future<String?> uploadFile({
    /// AWS access key
    required String accessKey,

    /// AWS secret key
    required String secretKey,

    /// The name of the S3 storage bucket to upload  to
    required String bucket,

    /// The file to upload
    required File file,

    /// The path to upload the file to (e.g. "uploads/public"). Defaults to the root "directory"
    required String uploadDst,

    /// The AWS region. Must be formatted correctly, e.g. us-west-1
    required String region,
  }) async {
    final endpoint = 'https://storage.googleapis.com/$bucket';

    final stream = http.ByteStream(Stream.castFrom(file.openRead()));
    final length = await file.length();

    final uri = Uri.parse(endpoint);
    final req = http.MultipartRequest("POST", uri);
    final multipartFile = http.MultipartFile('file', stream, length,
        filename: path.basename(file.path));

    final policy = Policy.fromS3PresignedPost(
        uploadDst, bucket, accessKey, 15, length,
        region: region);
    final key =
        SigV4.calculateSigningKey(secretKey, policy.datetime, region, 's3');
    final signature = SigV4.calculateSignature(key, policy.encode());

    req.files.add(multipartFile);
    req.fields['key'] = policy.key;
    req.fields['acl'] = 'public-read';
    req.fields['X-Amz-Credential'] = policy.credential;
    req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
    req.fields['X-Amz-Date'] = policy.datetime;
    req.fields['Policy'] = policy.encode();
    req.fields['X-Amz-Signature'] = signature;

    try {
      final res = await req.send();

      if (res.statusCode == 204) return '$endpoint/$uploadDst';
    } catch (e) {
      print('Failed to upload to AWS, with exception:');
      print(e);
      return null;
    }
    return null;
  }

  /// Upload a file, returning the file's public URL on success.
  static Future<String?> uploadData({
    /// AWS access key
    required String accessKey,

    /// AWS secret key
    required String secretKey,

    /// The name of the S3 storage bucket to upload  to
    required String bucket,

    /// The file to upload
    required ByteData data,

    /// The path to upload the file to (e.g. "uploads/public"). Defaults to the root "directory"
    String destDir = '',

    /// The AWS region. Must be formatted correctly, e.g. us-west-1
    required String region,

    /// The filename to upload as. If null, defaults to the given file's current filename.
    required String uploadDst,
    bool public = true,
  }) async {
    final endpoint = 'https://storage.googleapis.com/$bucket';
    // final uploadDest = '$destDir/${filename ?? path.basename(file.path)}';

    final stream = http.ByteStream.fromBytes(data.buffer.asUint8List());

    // final stream = http.ByteStream(Stream.castFrom(file.openRead()));
    final length = data.lengthInBytes;

    final uri = Uri.parse(endpoint);
    final req = http.MultipartRequest("POST", uri);
    final multipartFile = http.MultipartFile('file', stream, length,
        filename: path.basename(uploadDst));

    final policy = Policy.fromS3PresignedPost(
        uploadDst, bucket, accessKey, 15, length,
        region: region, public: public);
    final key =
        SigV4.calculateSigningKey(secretKey, policy.datetime, region, 's3');
    final signature = SigV4.calculateSignature(key, policy.encode());

    req.files.add(multipartFile);
    req.fields['key'] = policy.key;
    req.fields['acl'] = public ? 'public-read' : 'private';
    req.fields['X-Amz-Credential'] = policy.credential;
    req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
    req.fields['X-Amz-Date'] = policy.datetime;
    req.fields['Policy'] = policy.encode();
    req.fields['X-Amz-Signature'] = signature;

    try {
      final res = await req.send();

      if (res.statusCode == 204) return '$endpoint/$uploadDst';
    } catch (e) {
      print('Failed to upload to AWS, with exception:');
      print(e);
      return null;
    }
    return null;
  }

  static Future<String?> getDirectUploadDescription({
    /// AWS access key
    required String accessKey,

    /// AWS secret key
    required String secretKey,

    /// The name of the S3 storage bucket to upload  to
    required String bucket,

    /// The path to upload the file to (e.g. "uploads/public"). Defaults to the root "directory"
    String destDir = '',

    /// The AWS region. Must be formatted correctly, e.g. us-west-1
    required String region,

    /// The filename to upload as. If null, defaults to the given file's current filename.
    required String uploadDst,
    bool public = true,
  }) async {
    final endpoint = 'https://storage.googleapis.com/$bucket';

    final policy = Policy.fromS3PresignedPost(
        uploadDst, bucket, accessKey, 15, 10 * 1024 * 1024,
        region: region, public: public);
    final key =
        SigV4.calculateSigningKey(secretKey, policy.datetime, region, 's3');
    final signature = SigV4.calculateSignature(key, policy.encode());

    var uploadDescriptionData = {
      'url': endpoint,
      'type': 'multipart',
      'field': 'file',
      'file-name': path.basename(uploadDst),
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
