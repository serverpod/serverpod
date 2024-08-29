import 'dart:io' as io;

import 'package:relic/src/headers/authorization_header.dart';
import 'package:relic/src/headers/custom_headers.dart';
import 'package:relic/src/util.dart';

import 'body.dart';

abstract class Headers {
  // TODO: Add properties for all supported headers below.

  // static const _acceptHeader = "accept";

  // static const _acceptCharsetHeader = "accept-charset";
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
    authorizationHeaderKey,
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
    this.authorization,
    CustomHeaders? custom,
  }) : custom = custom ?? CustomHeaders.empty();

  factory Headers.fromHttpRequest(io.HttpRequest request) {
    var headers = request.headers;

    var custom = <MapEntry<String, List<String>>>[];

    headers.forEach((name, values) {
      // Skip headers that we support natively.
      if (_managedHeaders.contains(name.toLowerCase())) {
        return;
      }
      for (var value in values) {
        custom.add(MapEntry(name, [value]));
      }
    });

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
      custom: CustomHeaders.fromHttpRequestEntries(custom),
      authorization: AuthorizationHeader.tryParse(custom),
    );
  }

  // factory Headers.fromHttpResponse(io.HttpResponse response) {
  //   var headers = response.headers;

  //   var custom = <CustomHeader>[];

  //   headers.forEach((name, values) {
  //     // Skip headers that we support natively.
  //     if (_managedHeaders.contains(name.toLowerCase())) {
  //       return;
  //     }
  //     for (var value in values) {
  //       custom.add(_StringHeader(name, value));
  //     }
  //   });

  //   return _HeadersImpl(
  //     date: headers.date,
  //     expires: headers.expires,
  //     ifModifiedSince: headers.ifModifiedSince,
  //     host: headers.host,
  //     port: headers.port,
  //     customHeaders: custom,
  //   );
  // }

  factory Headers.response({
    DateTime? date,
    DateTime? expires,
    DateTime? ifModifiedSince,
    String? from,
    String? host,
    int? port,
    Uri? location,
    String? xPoweredBy,
    CustomHeaders? custom,
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
      custom: custom ?? CustomHeaders.empty(),
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
    CustomHeaders? custom,
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
      custom: custom ?? CustomHeaders.empty(),
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
      if (authorization != null) '$authorization',
      ...custom.httpRequestEntries
          .map((entry) => '${entry.key}:${entry.value}'),
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
      custom: custom ?? this.custom,
      authorization: authorization ?? this.authorization,
    );
  }
}

// abstract class CustomHeader {
//   final String name;

//   const CustomHeader(this.name);

//   String get formattedValue;

//   @override
//   String toString() {
//     return '$name: $formattedValue';
//   }
// }

class _Undefined {}

// // class _DateTimeEntry extends CustomHeader {
// //   final DateTime value;

// //   const _DateTimeEntry(
// //     String name,
// //     this.value,
// //   ) : super(name);

// //   @override
// //   String get formattedValue => throw UnimplementedError();
// // }

// class _StringHeader extends CustomHeader {
//   final String value;

//   const _StringHeader(super.name, this.value);

//   @override
//   String get formattedValue => value;
// }


