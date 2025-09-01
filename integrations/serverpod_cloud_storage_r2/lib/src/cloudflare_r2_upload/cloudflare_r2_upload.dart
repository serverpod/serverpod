import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

/// Utility function to detect MIME type from file extension
String _detectMimeType(String fileName) {
  final ext = path.extension(fileName).toLowerCase();
  
  final mimeTypes = {
    '.jpg': 'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.png': 'image/png',
    '.gif': 'image/gif',
    '.webp': 'image/webp',
    '.svg': 'image/svg+xml',
    '.pdf': 'application/pdf',
    '.txt': 'text/plain',
    '.html': 'text/html',
    '.css': 'text/css',
    '.js': 'application/javascript',
    '.json': 'application/json',
    '.xml': 'application/xml',
    '.mp4': 'video/mp4',
    '.mp3': 'audio/mpeg',
    '.wav': 'audio/wav',
    '.zip': 'application/zip',
    '.doc': 'application/msword',
    '.docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    '.xls': 'application/vnd.ms-excel',
    '.xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  };
  
  return mimeTypes[ext] ?? 'application/octet-stream';
}

/// Convenience class for uploading files to Cloudflare R2
class CloudflareR2Uploader {
  /// Upload a file using PUT method, returning the file's public URL on success.
  static Future<String?> uploadFile({
    /// R2 access key
    required String accessKey,

    /// R2 secret key
    required String secretKey,

    /// The name of the R2 storage bucket to upload to
    required String bucket,

    /// The file to upload
    required File file,

    /// The path to upload the file to (e.g. "uploads/public")
    required String uploadDst,

    /// The R2 account ID
    required String accountId,

    /// The region (defaults to 'auto' for R2)
    String region = 'auto',
  }) async {
    final fileBytes = await file.readAsBytes();
    return uploadData(
      accessKey: accessKey,
      secretKey: secretKey,
      bucket: bucket,
      data: ByteData.view(fileBytes.buffer),
      uploadDst: uploadDst,
      accountId: accountId,
      region: region,
    );
  }

  /// Upload data using PUT method, returning the file's public URL on success.
  static Future<String?> uploadData({
    /// R2 access key
    required String accessKey,

    /// R2 secret key
    required String secretKey,

    /// The name of the R2 storage bucket to upload to
    required String bucket,

    /// The data to upload
    required ByteData data,

    /// The path to upload the file to (e.g. "uploads/public")
    String destDir = '',

    /// The R2 account ID
    required String accountId,

    /// The region (defaults to 'auto' for R2)
    String region = 'auto',

    /// The filename to upload as
    required String uploadDst,
    bool public = true,
  }) async {
    final host = '$accountId.r2.cloudflarestorage.com';
    final objectKey = '$bucket/$uploadDst';
    
    final datetime = SigV4.generateDatetime();
    final credentialScope = SigV4.buildCredentialScope(datetime, region, 's3');
    final payloadHash = SigV4.hashCanonicalRequest(
      String.fromCharCodes(data.buffer.asUint8List())
    );

    final canonicalRequest = '''PUT
/$objectKey

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

    final signingKey = SigV4.calculateSigningKey(secretKey, datetime, region, 's3');
    final signature = SigV4.calculateSignature(signingKey, stringToSign);
    
    final authorization = 'AWS4-HMAC-SHA256 Credential=$accessKey/$credentialScope, SignedHeaders=host;x-amz-content-sha256;x-amz-date, Signature=$signature';

    final uri = Uri.https(host, '/$objectKey');
    
    try {
      final response = await http.put(
        uri,
        headers: {
          'Authorization': authorization,
          'x-amz-content-sha256': payloadHash,
          'x-amz-date': datetime,
          'host': host,
        },
        body: data.buffer.asUint8List(),
      );

      if (response.statusCode >= 400) {
        stderr.writeln(
            'Failed to upload to Cloudflare R2, status: ${response.statusCode}, reason: ${response.reasonPhrase}');
        stderr.writeln('Response body: ${response.body}');
        return null;
      }

      if (response.statusCode == 200 || response.statusCode == 204) {
        return 'https://$host/$objectKey';
      }
    } catch (e) {
      stderr.writeln('Failed to upload to Cloudflare R2, with exception:');
      stderr.writeln(e);
      return null;
    }
    return null;
  }

  /// Get direct upload description using PUT method (recommended for R2)
  static Future<String?> getDirectUploadDescription({
    /// R2 access key
    required String accessKey,

    /// R2 secret key
    required String secretKey,

    /// The name of the R2 storage bucket to upload to
    required String bucket,

    /// The R2 account ID
    required String accountId,

    /// The region (defaults to 'auto' for R2)
    String region = 'auto',

    /// The filename to upload as
    required String uploadDst,
    Duration expires = const Duration(minutes: 10),
    int maxFileSize = 10 * 1024 * 1024,
    bool public = true,
  }) async {
    // For R2, we use PUT presigned URLs instead of POST multipart
    final uploadUrl = await getDirectUploadUrl(
      accessKey: accessKey,
      secretKey: secretKey,
      bucket: bucket,
      accountId: accountId,
      region: region,
      uploadDst: uploadDst,
      expires: expires,
    );

    if (uploadUrl == null) return null;

    final fileName = path.basename(uploadDst);
    final contentType = _detectMimeType(fileName);
    
    var uploadDescriptionData = {
      'url': uploadUrl,
      'type': 'binary',
      'method': 'PUT',
      'file-name': fileName,
      'headers': {
        'Content-Type': contentType,
      },
    };

    return jsonEncode(uploadDescriptionData);
  }

  /// Get direct upload URL for PUT method (presigned URL)
  /// This is the preferred method for R2 as it's simpler for client implementations
  static Future<String?> getDirectUploadUrl({
    /// R2 access key
    required String accessKey,

    /// R2 secret key
    required String secretKey,

    /// The name of the R2 storage bucket to upload to
    required String bucket,

    /// The R2 account ID
    required String accountId,

    /// The region (defaults to 'auto' for R2)
    String region = 'auto',

    /// The filename to upload as
    required String uploadDst,
    Duration expires = const Duration(minutes: 10),
    String? contentType,
  }) async {
    final host = '$accountId.r2.cloudflarestorage.com';
    final objectKey = '$bucket/$uploadDst';
    
    final datetime = SigV4.generateDatetime();
    final credentialScope = SigV4.buildCredentialScope(datetime, region, 's3');
    
    final queryParams = <String, String>{
      'X-Amz-Algorithm': 'AWS4-HMAC-SHA256',
      'X-Amz-Credential': '$accessKey/$credentialScope',
      'X-Amz-Date': datetime,
      'X-Amz-Expires': expires.inSeconds.toString(),
      'X-Amz-SignedHeaders': 'host',
    };
    
    if (contentType != null) {
      queryParams['X-Amz-ContentType'] = contentType;
    }

    final canonicalQuery = SigV4.buildCanonicalQueryString(queryParams);
    final canonicalRequest = '''PUT
/$objectKey
$canonicalQuery
host:$host

host
UNSIGNED-PAYLOAD''';

    final stringToSign = SigV4.buildStringToSign(
      datetime,
      credentialScope,
      SigV4.hashCanonicalRequest(canonicalRequest),
    );

    final signingKey = SigV4.calculateSigningKey(secretKey, datetime, region, 's3');
    final signature = SigV4.calculateSignature(signingKey, stringToSign);
    
    queryParams['X-Amz-Signature'] = signature;
    
    final uri = Uri.https(host, '/$objectKey', queryParams);

    return uri.toString();
  }
}