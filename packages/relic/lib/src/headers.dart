import 'dart:collection';
import 'dart:convert';
import 'dart:io' as io;

import 'package:http_parser/http_parser.dart';

import 'body.dart';

part 'headers/custom_headers.dart';
part 'headers/authorization_header.dart';

abstract class Headers {
  // TODO: Add properties for all supported headers below.

  static const _acceptHeader = "accept";
  static const _acceptCharsetHeader = "accept-charset";
  // static const _acceptEncodingHeader = "accept-encoding";
  // static const _acceptLanguageHeader = "accept-language";
  // static const _acceptRangesHeader = "accept-ranges";
  // static const _accessControlAllowCredentialsHeader =
  //     'access-control-allow-credentials';
  // static const _accessControlAllowOriginHeader = 'access-control-allow-origin';
  // static const _accessControlExposeHeadersHeader =
  //     'access-control-expose-headers';
  // static const _accessControlMaxAgeHeader = 'access-control-max-age';
  // static const _accessControlRequestHeadersHeader =
  //     'access-control-request-headers';
  // static const _accessControlRequestMethodHeader =
  //     'access-control-request-method';
  // static const _ageHeader = "age";
  // static const _allowHeader = "allow";

  static const _authorizationHeader = "authorization";

  // static const _cacheControlHeader = "cache-control";
  // static const _connectionHeader = "connection";
  // static const _contentEncodingHeader = "content-encoding";
  // static const _contentLanguageHeader = "content-language";
  // static const _contentLengthHeader = "content-length";
  // static const _contentLocationHeader = "content-location";
  // static const _contentMD5Header = "content-md5";
  // static const _contentRangeHeader = "content-range";
  static const _contentTypeHeader = "content-type";
  static const _dateHeader = "date";
  // static const _etagHeader = "etag";
  // static const _expectHeader = "expect";
  static const _expiresHeader = "expires";
  static const _fromHeader = "from";
  static const _hostHeader = "host";
  // static const _ifMatchHeader = "if-match";
  static const _ifModifiedSinceHeader = "if-modified-since";
  // static const _ifNoneMatchHeader = "if-none-match";
  // static const _ifRangeHeader = "if-range";
  // static const _ifUnmodifiedSinceHeader = "if-unmodified-since";
  // static const _lastModifiedHeader = "last-modified";
  static const _locationHeader = "location";
  // static const _maxForwardsHeader = "max-forwards";
  // static const _pragmaHeader = "pragma";
  // static const _proxyAuthenticateHeader = "proxy-authenticate";
  // static const _proxyAuthorizationHeader = "proxy-authorization";
  // static const _rangeHeader = "range";
  // static const _refererHeader = "referer";
  // static const _retryAfterHeader = "retry-after";
  // static const _serverHeader = "server";
  // static const _teHeader = "te";
  // static const _trailerHeader = "trailer";
  // static const _transferEncodingHeader = "transfer-encoding";
  // static const _upgradeHeader = "upgrade";
  // static const _userAgentHeader = "user-agent";
  // static const _varyHeader = "vary";
  // static const _viaHeader = "via";
  // static const _warningHeader = "warning";
  // static const _wwwAuthenticateHeader = "www-authenticate";
  // static const _contentDisposition = "content-disposition";
  static const _xPoweredByHeader = 'X-Powered-By';

  static const _defaultXPoweredByHeader = 'Serverpod Relic';

  final DateTime? date;
  final DateTime? expires;
  final DateTime? ifModifiedSince;
  final String? from;
  final String? host;
  final int? port;
  final Uri? location;
  final String? xPoweredBy;
  final List<String>? accept;
  final List<String>? acceptCharset;
  final String? contentType;
  final AuthorizationHeader? authorization;
  final CustomHeaders custom;

  static const _managedHeaders = <String>{
    _dateHeader,
    _expiresHeader,
    _ifModifiedSinceHeader,
    _hostHeader,
    _contentTypeHeader,
    _locationHeader,
    _xPoweredByHeader,
    _acceptHeader,
    _authorizationHeader,
    _acceptCharsetHeader,
  };

  Headers._({
    this.date,
    this.expires,
    this.ifModifiedSince,
    this.from,
    this.host,
    this.port,
    this.location,
    this.xPoweredBy,
    this.accept,
    this.acceptCharset,
    this.contentType,
    this.authorization,
    CustomHeaders? custom,
  }) : custom = custom ?? CustomHeaders.empty();

  factory Headers.fromHttpRequest(io.HttpRequest request) {
    var headers = request.headers;

    // TODO: When implementing other pre-defined headers, remove the
    // Transfer-Encoding header per the adapter requirements. (This is what
    // Shelf does, not sure the purpose.)

    return _HeadersImpl(
      date: headers.date,
      expires: headers.expires,
      ifModifiedSince: headers.ifModifiedSince,
      from: headers.value(_fromHeader),
      host: headers.host,
      port: headers.port,
      accept: headers[_acceptHeader],
      acceptCharset: headers[_acceptCharsetHeader],
      contentType: headers.value(_contentTypeHeader),
      custom: CustomHeaders._fromHttpHeaders(
        headers,
        excludedHeaders: _managedHeaders,
      ),
      authorization: AuthorizationHeader._tryParseHttpHeaders(
        headers,
      ),
    );
  }

  factory Headers.response({
    DateTime? date,
    DateTime? expires,
    DateTime? ifModifiedSince,
    String? from,
    String? host,
    int? port,
    Uri? location,
    String? xPoweredBy,
    List<String>? accept,
    List<String>? acceptCharset,
    CustomHeaders? custom,
    AuthorizationHeader? authorization,
  }) {
    return _HeadersImpl(
      date: date ?? DateTime.now(),
      expires: expires,
      ifModifiedSince: ifModifiedSince,
      from: from,
      host: host,
      port: port,
      location: location,
      xPoweredBy: xPoweredBy,
      accept: accept,
      acceptCharset: acceptCharset,
      custom: custom ?? CustomHeaders.empty(),
      authorization: authorization,
    );
  }

  factory Headers.request({
    DateTime? date,
    DateTime? expires,
    DateTime? ifModifiedSince,
    String? from,
    String? host,
    int? port,
    Uri? location,
    String? xPoweredBy,
    List<String>? accept,
    List<String>? acceptCharset,
    CustomHeaders? custom,
    AuthorizationHeader? authorization,
  }) {
    return _HeadersImpl(
      date: date ?? DateTime.now(),
      expires: expires,
      ifModifiedSince: ifModifiedSince,
      from: from,
      host: host,
      port: port,
      location: location,
      xPoweredBy: xPoweredBy,
      accept: accept,
      acceptCharset: acceptCharset,
      custom: custom ?? CustomHeaders.empty(),
      authorization: authorization,
    );
  }

  void applyHeaders(io.HttpResponse response, Body body) {
    var headers = response.headers;
    headers.clear();

    headers.date = date?.toUtc() ?? DateTime.now().toUtc();
    headers.expires = expires;
    headers.ifModifiedSince = ifModifiedSince;
    headers.host = host;
    headers.port = port;
    if (from != null) headers.set(_fromHeader, from!);

    headers.set(_xPoweredByHeader, xPoweredBy ?? _defaultXPoweredByHeader);

    // Set the content type from the Body
    headers.contentType = io.ContentType(
      body.contentType.mimeType.primaryType,
      body.contentType.mimeType.subType,
      charset: body.contentType.encoding?.name,
    );
  }

  Headers copyWith({
    DateTime? date,
    DateTime? expires,
    DateTime? ifModifiedSince,
    String? from,
    String? host,
    int? port,
    Uri? location,
    String? xPoweredBy,
    List<String>? accept,
    List<String>? acceptCharset,
    CustomHeaders? custom,
    AuthorizationHeader? authorization,
  });

  @override
  String toString() {
    var strings = <String>[
      if (date != null) '$_dateHeader: $date',
      if (expires != null) '$_expiresHeader: $expires',
      if (ifModifiedSince != null) '$_ifModifiedSinceHeader: $ifModifiedSince',
      if (from != null) '$_fromHeader: $from',
      if (host != null) '$_hostHeader: $host${port != null ? ':$port' : ''}',
      if (location != null) '$_locationHeader: $location',
      if (xPoweredBy != null) '$_xPoweredByHeader: $xPoweredBy',
      if (accept != null) ...accept!.map((value) => '$_acceptHeader: $value'),
      if (acceptCharset != null)
        ...acceptCharset!.map((value) => '$_acceptCharsetHeader: $value'),
      if (xPoweredBy != null) '$_xPoweredByHeader: $xPoweredBy',
      if (authorization != null) '$authorization',
      ...custom.entries.map((entry) => '${entry.key}:${entry.value}'),
    ];

    return strings.join('\n');
  }
}

class _HeadersImpl extends Headers {
  _HeadersImpl({
    super.date,
    super.expires,
    super.ifModifiedSince,
    super.from,
    super.host,
    super.port,
    super.location,
    super.xPoweredBy,
    super.accept,
    super.acceptCharset,
    super.contentType,
    super.custom,
    super.authorization,
  }) : super._();

  @override
  Headers copyWith({
    Object? date = _Undefined,
    Object? expires = _Undefined,
    Object? ifModifiedSince = _Undefined,
    Object? from = _Undefined,
    Object? host = _Undefined,
    Object? location = _Undefined,
    Object? port = _Undefined,
    Object? xPoweredBy = _Undefined,
    Object? accept = _Undefined,
    Object? acceptCharset = _Undefined,
    Object? contentType = _Undefined,
    CustomHeaders? custom,
    AuthorizationHeader? authorization,
  }) {
    return _HeadersImpl(
      date: date is DateTime? ? date : this.date,
      expires: expires is DateTime? ? expires : this.expires,
      ifModifiedSince:
          ifModifiedSince is DateTime? ? ifModifiedSince : this.ifModifiedSince,
      from: from is String? ? from : this.from,
      host: host is String? ? host : this.host,
      port: port is int? ? port : this.port,
      location: location is Uri? ? location : this.location,
      xPoweredBy: xPoweredBy is String? ? xPoweredBy : this.xPoweredBy,
      accept: accept is List<String> ? accept : this.accept,
      acceptCharset:
          acceptCharset is List<String> ? acceptCharset : this.acceptCharset,
      contentType: contentType is String ? contentType : this.contentType,
      custom: custom ?? this.custom,
      authorization: authorization ?? this.authorization,
    );
  }
}

class _Undefined {}
