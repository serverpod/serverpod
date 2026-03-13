import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Tencent COS native XML API signer using HMAC-SHA1.
///
/// Inlined from the validated `tencent_cos_dart` package, trimmed to the
/// minimal presigned-URL generation needed for server-side PUT / GET / HEAD /
/// DELETE operations.
class CosSigner {
  final String secretId;
  final String secretKey;
  final String bucket;
  final String region;
  final String? publicHost;

  CosSigner({
    required this.secretId,
    required this.secretKey,
    required this.bucket,
    required this.region,
    this.publicHost,
  });

  /// Default COS virtual-hosted-style host.
  String get defaultHost => '$bucket.cos.$region.myqcloud.com';

  /// Generates a presigned URL for COS XML API.
  ///
  /// [httpMethod] – HTTP verb (put / get / head / delete).
  /// [objectKey] – object path; a leading `/` is added if missing.
  /// [expires] – signature validity in seconds, defaults to 3600.
  /// [queryParams] – query parameters to include in the signature.
  /// [headers] – HTTP headers to include in the signature.
  String generatePresignedUrl(
    String httpMethod,
    String objectKey, {
    int expires = 3600,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) {
    if (!objectKey.startsWith('/')) {
      objectKey = '/$objectKey';
    }

    final now = DateTime.now();
    final startTime = now.millisecondsSinceEpoch ~/ 1000;
    final endTime = startTime + expires;
    final keyTime = '$startTime;$endTime';

    final signKey = _hmacSha1(secretKey, keyTime);

    final params = queryParams ?? {};
    final sortedParamKeys = params.keys.map((k) => k.toLowerCase()).toList()
      ..sort();
    final urlParamList = sortedParamKeys.map(_cosEncode).join(';');
    final httpParameters = sortedParamKeys
        .map((k) => '${_cosEncode(k)}=${_cosEncode(params[k] ?? '')}')
        .join('&');

    final headerMap = headers ?? {};
    final sortedHeaderKeys = headerMap.keys.map((k) => k.toLowerCase()).toList()
      ..sort();
    final headerList = sortedHeaderKeys.map(_cosEncode).join(';');
    final httpHeaders = sortedHeaderKeys
        .map((k) => '${_cosEncode(k)}=${_cosEncode(headerMap[k] ?? '')}')
        .join('&');

    final httpString =
        '${httpMethod.toLowerCase()}\n$objectKey\n$httpParameters\n$httpHeaders\n';

    final sha1HttpString = sha1.convert(utf8.encode(httpString)).toString();
    final stringToSign = 'sha1\n$keyTime\n$sha1HttpString\n';

    final signature = _hmacSha1(signKey, stringToSign);

    final signatureParams = {
      'q-sign-algorithm': 'sha1',
      'q-ak': secretId,
      'q-sign-time': keyTime,
      'q-key-time': keyTime,
      'q-header-list': headerList,
      'q-url-param-list': urlParamList,
      'q-signature': signature,
    };

    final allParams = {...params, ...signatureParams};
    final queryString = allParams.entries
        .map((e) => '${e.key}=${_cosEncode(e.value)}')
        .join('&');

    final host = _normalizeHost(publicHost) ?? defaultHost;
    return 'https://$host$objectKey?$queryString';
  }

  String _hmacSha1(String key, String msg) {
    final hmac = Hmac(sha1, utf8.encode(key));
    return hmac.convert(utf8.encode(msg)).toString();
  }

  /// COS-standard URI encoding: spaces become `%20`, not `+`.
  static String _cosEncode(String input) {
    return Uri.encodeComponent(input).replaceAll('+', '%20');
  }

  /// Strips protocol from a host string (e.g. `https://cdn.example.com` →
  /// `cdn.example.com`). Returns `null` for blank input.
  static String? _normalizeHost(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final trimmed = raw.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return Uri.tryParse(trimmed)?.host;
    }
    return trimmed;
  }
}
