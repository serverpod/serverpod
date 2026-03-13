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
  /// [headers] – HTTP headers to include in the signature. Keys are
  ///   normalized to lowercase internally for signing; callers may pass
  ///   mixed-case keys.
  /// [host] – when provided, overrides the default host resolution
  ///   ([publicHost] → [defaultHost]). Use this for upload URLs that
  ///   must hit the COS endpoint rather than a CDN / custom domain.
  String generatePresignedUrl(
    String httpMethod,
    String objectKey, {
    int expires = 3600,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    String? host,
  }) {
    if (!objectKey.startsWith('/')) {
      objectKey = '/$objectKey';
    }

    final now = DateTime.now();
    final startTime = now.millisecondsSinceEpoch ~/ 1000;
    final endTime = startTime + expires;
    final keyTime = '$startTime;$endTime';

    final signKey = _hmacSha1(secretKey, keyTime);

    // Normalize query param keys to lowercase for signing.
    final rawParams = queryParams ?? {};
    final normalizedParams = {
      for (final e in rawParams.entries) e.key.toLowerCase(): e.value,
    };
    final sortedParamKeys = normalizedParams.keys.toList()..sort();
    final urlParamList = sortedParamKeys.map(_cosEncode).join(';');
    final httpParameters = sortedParamKeys
        .map((k) => '${_cosEncode(k)}=${_cosEncode(normalizedParams[k] ?? '')}')
        .join('&');

    // Normalize header keys to lowercase for signing.
    final rawHeaders = headers ?? {};
    final normalizedHeaders = {
      for (final e in rawHeaders.entries) e.key.toLowerCase(): e.value,
    };
    final sortedHeaderKeys = normalizedHeaders.keys.toList()..sort();
    final headerList = sortedHeaderKeys.map(_cosEncode).join(';');
    final httpHeaders = sortedHeaderKeys
        .map(
          (k) => '${_cosEncode(k)}=${_cosEncode(normalizedHeaders[k] ?? '')}',
        )
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

    final allParams = {...rawParams, ...signatureParams};
    final queryString = allParams.entries
        .map((e) => '${e.key}=${_cosEncode(e.value)}')
        .join('&');

    final effectiveHost = host ?? _normalizeHost(publicHost) ?? defaultHost;
    return 'https://$effectiveHost$objectKey?$queryString';
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
