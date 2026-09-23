import 'dart:convert';

import 'package:crypto/crypto.dart';

/// AWS Signature Version 4 for the SNS query API.
///
/// Not part of the push public API. SNS requests are POST bodies with an
/// empty canonical query string; the payload hash is the SHA-256 of those
/// exact body bytes.
class AwsSigV4 {
  /// Signs [body] for a POST to [uri].
  ///
  /// Returned headers are what the HTTP client must send. [body] itself is
  /// unchanged and must be sent as the request body.
  static Map<String, String> signedHeaders({
    required final String method,
    required final Uri uri,
    required final String body,
    required final String accessKeyId,
    required final String secretAccessKey,
    required final String region,
    required final String service,
    required final DateTime now,
    final String? sessionToken,
    final String contentType = 'application/x-www-form-urlencoded',
  }) {
    final amzDate = _amzDate(now.toUtc());
    final dateStamp = amzDate.substring(0, 8);
    final payloadHash = sha256.convert(utf8.encode(body)).toString();
    final canonicalHeaders = _canonicalHeaders(
      uri: uri,
      amzDate: amzDate,
      contentType: contentType,
      sessionToken: sessionToken,
    );
    final signed = _signedHeaderNames(sessionToken);
    final canonical = canonicalRequest(
      method: method,
      uri: uri,
      canonicalHeaders: canonicalHeaders,
      signedHeaders: signed,
      payloadHash: payloadHash,
    );
    final scope = '$dateStamp/$region/$service/aws4_request';
    final stringToSign = [
      'AWS4-HMAC-SHA256',
      amzDate,
      scope,
      sha256.convert(utf8.encode(canonical)).toString(),
    ].join('\n');
    final signature = _hex(
      _hmac(
        signingKey(
          secretAccessKey: secretAccessKey,
          dateStamp: dateStamp,
          region: region,
          service: service,
        ),
        stringToSign,
      ),
    );

    return {
      'Content-Type': contentType,
      'X-Amz-Date': amzDate,
      'X-Amz-Security-Token': ?sessionToken,
      'Authorization':
          'AWS4-HMAC-SHA256 Credential=$accessKeyId/$scope, '
          'SignedHeaders=$signed, Signature=$signature',
    };
  }

  /// SigV4 canonical request. Exposed so tests can lock the blank-line layout
  /// AWS requires between the headers and the signed-header list.
  static String canonicalRequest({
    required final String method,
    required final Uri uri,
    required final String canonicalHeaders,
    required final String signedHeaders,
    required final String payloadHash,
  }) {
    final path = uri.path.isEmpty ? '/' : uri.path;
    final canonicalUri = path.split('/').map(Uri.encodeComponent).join('/');
    final canonicalQuery = encodeForm(uri.queryParameters);
    return '$method\n'
        '$canonicalUri\n'
        '$canonicalQuery\n'
        '$canonicalHeaders\n'
        '$signedHeaders\n'
        '$payloadHash';
  }

  /// Derives the SigV4 signing key (`AWS4` + secret, then date, region,
  /// service, `aws4_request`).
  static List<int> signingKey({
    required final String secretAccessKey,
    required final String dateStamp,
    required final String region,
    required final String service,
  }) {
    final kDate = _hmac(utf8.encode('AWS4$secretAccessKey'), dateStamp);
    final kRegion = _hmac(kDate, region);
    final kService = _hmac(kRegion, service);
    return _hmac(kService, 'aws4_request');
  }

  /// `application/x-www-form-urlencoded` body. Keys are sorted so the signed
  /// payload is stable.
  static String encodeForm(final Map<String, String> fields) {
    final keys = fields.keys.toList()..sort();
    return [
      for (final key in keys)
        '${Uri.encodeComponent(key)}=${Uri.encodeComponent(fields[key]!)}',
    ].join('&');
  }

  static String _canonicalHeaders({
    required final Uri uri,
    required final String amzDate,
    required final String contentType,
    required final String? sessionToken,
  }) {
    final headers = <String, String>{
      'content-type': contentType,
      'host': _hostHeader(uri),
      'x-amz-date': amzDate,
      'x-amz-security-token': ?sessionToken,
    };
    final names = headers.keys.toList()..sort();
    return [
      for (final name in names) '$name:${headers[name]!.trim()}',
      '',
    ].join('\n');
  }

  static String _signedHeaderNames(final String? sessionToken) {
    final names = [
      'content-type',
      'host',
      'x-amz-date',
      if (sessionToken != null) 'x-amz-security-token',
    ]..sort();
    return names.join(';');
  }

  static String _hostHeader(final Uri uri) {
    if (!uri.hasPort) return uri.host;
    final isDefault =
        (uri.scheme == 'https' && uri.port == 443) ||
        (uri.scheme == 'http' && uri.port == 80);
    if (isDefault) return uri.host;
    return '${uri.host}:${uri.port}';
  }

  static String _amzDate(final DateTime utc) {
    String two(final int value) => value.toString().padLeft(2, '0');
    final year = utc.year.toString().padLeft(4, '0');
    return '$year${two(utc.month)}${two(utc.day)}'
        'T${two(utc.hour)}${two(utc.minute)}${two(utc.second)}Z';
  }

  static List<int> _hmac(final List<int> key, final String message) {
    return Hmac(sha256, key).convert(utf8.encode(message)).bytes;
  }

  static String _hex(final List<int> bytes) {
    return [
      for (final byte in bytes) byte.toRadixString(16).padLeft(2, '0'),
    ].join();
  }
}
