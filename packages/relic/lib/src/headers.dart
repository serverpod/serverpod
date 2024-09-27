import 'dart:collection';
import 'dart:convert';
import 'dart:io' as io;

import 'package:http_parser/http_parser.dart';
import 'package:relic/src/method/method.dart';

import 'body.dart';

part 'headers/util/authorization_util.dart';
part 'headers/custom_headers.dart';
part 'headers/authorization_header.dart';
part 'headers/proxy_authorization_header.dart';
part 'headers/content_range_header.dart';
part 'headers/cache_control_header.dart';
part 'headers/content_disposition_header.dart';
part 'headers/range_header.dart';
part 'headers/retry_after_header.dart';
part 'headers/accept_header.dart';
part 'headers/connection_header.dart';
part 'headers/etag_header.dart';
part 'headers/vary_header.dart';
part 'headers/server_header.dart';
part 'headers/proxy_authenticate_header.dart';
part 'headers/transfer_encoding_header.dart';

abstract class Headers {
  // Request Headers
  static const _acceptHeader = "accept";
  static const _acceptCharsetHeader = "accept-charset";
  static const _acceptEncodingHeader = "accept-encoding";
  static const _acceptLanguageHeader = "accept-language";
  static const _authorizationHeader = "authorization";
  static const _expectHeader = "expect";
  static const _fromHeader = "from";
  static const _hostHeader = "host";
  static const _ifMatchHeader = "if-match";
  static const _ifModifiedSinceHeader = "if-modified-since";
  static const _ifNoneMatchHeader = "if-none-match";
  static const _ifRangeHeader = "if-range";
  static const _ifUnmodifiedSinceHeader = "if-unmodified-since";
  static const _maxForwardsHeader = "max-forwards";
  static const _pragmaHeader = "pragma";
  static const _proxyAuthorizationHeader = "proxy-authorization";
  static const _rangeHeader = "range";
  static const _refererHeader = "referer";
  static const _teHeader = "te";
  static const _upgradeHeader = "upgrade";
  static const _userAgentHeader = "user-agent";
  static const _accessControlRequestHeadersHeader =
      'access-control-request-headers';
  static const _accessControlRequestMethodHeader =
      'access-control-request-method';

// Response Headers
  static const _accessControlAllowCredentialsHeader =
      'access-control-allow-credentials';
  static const _accessControlAllowOriginHeader = 'access-control-allow-origin';
  static const _accessControlExposeHeadersHeader =
      'access-control-expose-headers';
  static const _accessControlMaxAgeHeader = 'access-control-max-age';
  static const _ageHeader = "age";
  static const _allowHeader = "allow";
  static const _cacheControlHeader = "cache-control";
  static const _connectionHeader = "connection";
  static const _contentDispositionHeader = "content-disposition";
  static const _contentEncodingHeader = "content-encoding";
  static const _contentLanguageHeader = "content-language";
  static const _contentLocationHeader = "content-location";
  static const _contentMD5Header = "content-md5";
  static const _contentRangeHeader = "content-range";
  static const _dateHeader = "date";
  static const _etagHeader = "etag";
  static const _expiresHeader = "expires";
  static const _lastModifiedHeader = "last-modified";
  static const _locationHeader = "location";
  static const _proxyAuthenticateHeader = "proxy-authenticate";
  static const _retryAfterHeader = "retry-after";
  static const _serverHeader = "server";
  static const _trailerHeader = "trailer";
  static const _transferEncodingHeader = "transfer-encoding";
  static const _varyHeader = "vary";
  static const _viaHeader = "via";
  static const _warningHeader = "warning";
  static const _wwwAuthenticateHeader = "www-authenticate";
  static const _xPoweredByHeader = 'X-Powered-By';

  /// Common Headers (Used in Both Requests and Responses)
  static const _acceptRangesHeader = "accept-ranges";
  static const _contentLengthHeader = "content-length";
  static const _contentTypeHeader = "content-type";

  /// Define header properties

  /// Date-related headers
  final DateTime? date;
  final DateTime? expires;
  final DateTime? ifModifiedSince;
  final DateTime? lastModified;

  /// Request Headers
  final String? from;
  final String? host;
  final int? port;
  final List<String>? acceptCharset;
  final List<String>? acceptEncoding;
  final List<String>? acceptLanguage;
  final List<String>? accessControlRequestHeaders;
  final Method? accessControlRequestMethod;
  final int? age;
  final List<Method>? allow;
  final AuthorizationHeader? authorization;
  final ConnectionHeader? connection;
  final String? expect;
  final List<String>? ifMatch;
  final List<String>? ifNoneMatch;
  final String? ifRange;
  final int? maxForwards;
  final ProxyAuthorizationHeader? proxyAuthorization;
  final RangeHeader? range;
  final Uri? referer;
  final String? userAgent;
  final List<String>? te;
  final List<String>? upgrade;

  /// Renamed from `pragma` to avoid conflict with Dart's built-in `pragma`
  final String? mPragma;

  /// Response Headers
  final Uri? location;
  final String? xPoweredBy;
  final bool? accessControlAllowCredentials;
  final String? accessControlAllowOrigin;
  final List<String>? accessControlExposeHeaders;
  final int? accessControlMaxAge;
  final CacheControlHeader? cacheControl;
  final List<String>? contentEncoding;
  final List<String>? contentLanguage;
  final String? contentLocation;
  final String? contentMD5;
  final ContentRangeHeader? contentRange;
  final ETagHeader? etag;
  final ProxyAuthenticateHeader? proxyAuthenticate;
  final RetryAfterHeader? retryAfter;
  final ServerHeader? server;
  final List<String>? trailer;
  final VaryHeader? vary;
  final List<String>? via;
  final List<String>? warning;
  final List<String>? wwwAuthenticate;
  final ContentDispositionHeader? contentDisposition;

  /// Common Headers (Used in Both Requests and Responses)
  final AcceptHeader? accept;
  final List<String>? acceptRanges;
  final TransferEncodingHeader? transferEncoding;
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
    _acceptEncodingHeader,
    _acceptLanguageHeader,
    _acceptRangesHeader,
    _accessControlAllowCredentialsHeader,
    _accessControlAllowOriginHeader,
    _accessControlExposeHeadersHeader,
    _accessControlMaxAgeHeader,
    _accessControlRequestHeadersHeader,
    _accessControlRequestMethodHeader,
    _ageHeader,
    _allowHeader,
    _cacheControlHeader,
    _connectionHeader,
    _contentEncodingHeader,
    _contentLanguageHeader,
    _contentLengthHeader,
    _contentLocationHeader,
    _contentMD5Header,
    _contentRangeHeader,
    _etagHeader,
    _expectHeader,
    _ifMatchHeader,
    _ifNoneMatchHeader,
    _ifRangeHeader,
    _ifUnmodifiedSinceHeader,
    _lastModifiedHeader,
    _maxForwardsHeader,
    _pragmaHeader,
    _proxyAuthenticateHeader,
    _proxyAuthorizationHeader,
    _rangeHeader,
    _refererHeader,
    _retryAfterHeader,
    _serverHeader,
    _teHeader,
    _trailerHeader,
    _transferEncodingHeader,
    _upgradeHeader,
    _userAgentHeader,
    _varyHeader,
    _viaHeader,
    _warningHeader,
    _wwwAuthenticateHeader,
    _contentDispositionHeader,
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
    this.acceptEncoding,
    this.acceptLanguage,
    this.acceptRanges,
    this.accessControlAllowCredentials,
    this.accessControlAllowOrigin,
    this.accessControlExposeHeaders,
    this.accessControlMaxAge,
    this.accessControlRequestHeaders,
    this.accessControlRequestMethod,
    this.age,
    this.allow,
    this.contentDisposition,
    this.authorization,
    this.cacheControl,
    this.connection,
    this.contentEncoding,
    this.contentLanguage,
    this.contentLocation,
    this.contentMD5,
    this.contentRange,
    this.etag,
    this.expect,
    this.ifMatch,
    this.ifNoneMatch,
    this.ifRange,
    this.lastModified,
    this.maxForwards,
    this.mPragma,
    this.proxyAuthenticate,
    this.proxyAuthorization,
    this.range,
    this.referer,
    this.retryAfter,
    this.server,
    this.te,
    this.trailer,
    this.transferEncoding,
    this.upgrade,
    this.userAgent,
    this.vary,
    this.via,
    this.warning,
    this.wwwAuthenticate,
    CustomHeaders? custom,
  }) : custom = custom ?? CustomHeaders.empty();

  factory Headers.fromHttpRequest(io.HttpRequest request) {
    var headers = request.headers;

    return _HeadersImpl(
      date: headers.date,
      expires: headers.expires,
      ifModifiedSince: headers.ifModifiedSince,
      lastModified: headers.value(_lastModifiedHeader) != null
          ? parseHttpDate(headers.value(_lastModifiedHeader)!)
          : null,
      from: headers.value(_fromHeader),
      host: headers.host,
      port: headers.port,
      accept: AcceptHeader.tryParse(headers[_acceptHeader]),
      acceptCharset: headers[_acceptCharsetHeader],
      acceptEncoding: headers[_acceptEncodingHeader],
      acceptLanguage: headers[_acceptLanguageHeader],
      acceptRanges: headers[_acceptRangesHeader],
      accessControlAllowCredentials: bool.tryParse(
        headers.value(_accessControlAllowCredentialsHeader) ?? '',
      ),
      accessControlAllowOrigin: headers.value(_accessControlAllowOriginHeader),
      accessControlExposeHeaders: headers[_accessControlExposeHeadersHeader],
      accessControlMaxAge: int.tryParse(
        headers.value(_accessControlMaxAgeHeader) ?? '',
      ),
      accessControlRequestHeaders: headers[_accessControlRequestHeadersHeader],
      accessControlRequestMethod: Method.tryParse(
        headers.value(_accessControlRequestMethodHeader),
      ),
      age: int.tryParse(headers.value(_ageHeader) ?? ""),
      allow: headers[_allowHeader]
          ?.map((e) => Method.tryParse(e))
          .nonNulls
          .toList(),
      contentDisposition: ContentDispositionHeader.tryParse(
        headers.value(_contentDispositionHeader),
      ),
      cacheControl: CacheControlHeader.tryParse(
        headers[_cacheControlHeader],
      ),
      connection: ConnectionHeader.tryParse(
        headers.value(_connectionHeader),
      ),
      contentEncoding: headers[_contentEncodingHeader],
      contentLanguage: headers[_contentLanguageHeader],
      contentLocation: headers.value(_contentLocationHeader),
      contentMD5: headers.value(_contentMD5Header),
      contentRange: ContentRangeHeader.tryParse(
        headers.value(_contentRangeHeader),
      ),
      etag: ETagHeader.tryParse(headers.value(_etagHeader)),
      expect: headers.value(_expectHeader),
      ifMatch: headers[_ifMatchHeader],
      ifNoneMatch: headers[_ifNoneMatchHeader],
      ifRange: headers.value(_ifRangeHeader),
      maxForwards: int.tryParse(headers.value(_maxForwardsHeader) ?? ''),
      mPragma: headers.value(_pragmaHeader),
      proxyAuthenticate: ProxyAuthenticateHeader.tryParse(
        headers.value(_proxyAuthenticateHeader),
      ),
      proxyAuthorization: ProxyAuthorizationHeader._tryParseHttpHeaders(
        headers,
      ),
      range: RangeHeader.tryParse(headers.value(_rangeHeader)),
      referer: Uri.tryParse(headers.value(_refererHeader) ?? ''),
      retryAfter: RetryAfterHeader.tryParse(headers.value(_retryAfterHeader)),
      server: ServerHeader.tryParse(headers.value(_serverHeader)),
      te: headers[_teHeader],
      trailer: headers[_trailerHeader],
      transferEncoding: TransferEncodingHeader.tryParse(
        headers.value(_transferEncodingHeader),
      ),
      upgrade: headers[_upgradeHeader],
      userAgent: headers.value(_userAgentHeader),
      vary: VaryHeader.tryParse(headers.value(_varyHeader)),
      via: headers[_viaHeader],
      warning: headers[_warningHeader],
      wwwAuthenticate: headers[_wwwAuthenticateHeader],
      custom: CustomHeaders._fromHttpHeaders(
        headers,
        excludedHeaders: _managedHeaders,
      ),
      authorization: AuthorizationHeader._tryParseHttpHeaders(
        headers,
      ),
    );
  }

  factory Headers.request({
    DateTime? date,
    DateTime? ifModifiedSince,
    String? from,
    String? host,
    int? port,
    AcceptHeader? accept,
    List<String>? acceptCharset,
    List<String>? acceptEncoding,
    List<String>? acceptLanguage,
    List<String>? acceptRanges,
    List<String>? accessControlRequestHeaders,
    Method? accessControlRequestMethod,
    int? age,
    AuthorizationHeader? authorization,
    ConnectionHeader? connection,
    String? expect,
    List<String>? ifMatch,
    List<String>? ifNoneMatch,
    String? ifRange,
    int? maxForwards,
    String? mPragma,
    ProxyAuthorizationHeader? proxyAuthorization,
    TransferEncodingHeader? transferEncoding,
    RangeHeader? range,
    Uri? referer,
    List<String>? te,
    List<String>? upgrade,
    String? userAgent,
    CustomHeaders? custom,
  }) {
    return _HeadersImpl(
      date: date,
      ifModifiedSince: ifModifiedSince,
      from: from,
      host: host,
      port: port,
      accept: accept,
      acceptCharset: acceptCharset,
      acceptEncoding: acceptEncoding,
      acceptLanguage: acceptLanguage,
      acceptRanges: acceptRanges,
      accessControlRequestHeaders: accessControlRequestHeaders,
      accessControlRequestMethod: accessControlRequestMethod,
      age: age,
      authorization: authorization,
      connection: connection,
      expect: expect,
      ifMatch: ifMatch,
      ifNoneMatch: ifNoneMatch,
      ifRange: ifRange,
      maxForwards: maxForwards,
      mPragma: mPragma,
      proxyAuthorization: proxyAuthorization,
      transferEncoding: transferEncoding,
      range: range,
      referer: referer,
      te: te,
      upgrade: upgrade,
      userAgent: userAgent,
      custom: custom ?? CustomHeaders.empty(),
    );
  }

  factory Headers.response({
    DateTime? date,
    DateTime? expires,
    Uri? location,
    String? xPoweredBy,
    bool? accessControlAllowCredentials,
    String? accessControlAllowOrigin,
    List<String>? accessControlExposeHeaders,
    int? accessControlMaxAge,
    int? age,
    List<Method>? allow,
    ContentDispositionHeader? contentDisposition,
    CacheControlHeader? cacheControl,
    ConnectionHeader? connection,
    List<String>? contentEncoding,
    List<String>? contentLanguage,
    List<String>? acceptRanges,
    String? contentLocation,
    String? contentMD5,
    ContentRangeHeader? contentRange,
    ETagHeader? etag,
    DateTime? lastModified,
    ProxyAuthenticateHeader? proxyAuthenticate,
    RetryAfterHeader? retryAfter,
    ServerHeader? server,
    List<String>? trailer,
    TransferEncodingHeader? transferEncoding,
    VaryHeader? vary,
    List<String>? via,
    List<String>? warning,
    List<String>? wwwAuthenticate,
    CustomHeaders? custom,
  }) {
    return _HeadersImpl(
      date: date ?? DateTime.now(),
      expires: expires,
      location: location,
      xPoweredBy: xPoweredBy,
      accessControlAllowCredentials: accessControlAllowCredentials,
      accessControlAllowOrigin: accessControlAllowOrigin,
      accessControlExposeHeaders: accessControlExposeHeaders,
      accessControlMaxAge: accessControlMaxAge,
      age: age,
      allow: allow,
      contentDisposition: contentDisposition,
      cacheControl: cacheControl,
      connection: connection,
      contentEncoding: contentEncoding,
      contentLanguage: contentLanguage,
      acceptRanges: acceptRanges,
      contentLocation: contentLocation,
      contentMD5: contentMD5,
      contentRange: contentRange,
      etag: etag,
      lastModified: lastModified,
      proxyAuthenticate: proxyAuthenticate,
      retryAfter: retryAfter,
      server: server,
      trailer: trailer,
      transferEncoding: transferEncoding,
      vary: vary,
      via: via,
      warning: warning,
      wwwAuthenticate: wwwAuthenticate,
      custom: custom ?? CustomHeaders.empty(),
    );
  }

  void applyHeaders(
    io.HttpResponse response,
    Body body, {
    String? poweredByHeader,
  }) {
    var headers = response.headers;
    headers.clear();

    headers.date = date?.toUtc() ?? DateTime.now().toUtc();
    headers.expires = expires;
    headers.ifModifiedSince = ifModifiedSince;

    if (lastModified != null) {
      headers.set(_lastModifiedHeader, formatHttpDate(lastModified!));
    }

    headers.host = host;
    headers.port = port;

    if (from != null) headers.set(_fromHeader, from!);
    if (location != null) headers.set(_locationHeader, location!);

    var poweredBy = xPoweredBy ?? poweredByHeader;
    if (poweredBy != null) {
      headers.set(_xPoweredByHeader, poweredBy);
    }

    if (accept != null) headers.set(_acceptHeader, accept!);
    if (acceptCharset != null) {
      headers.set(_acceptCharsetHeader, acceptCharset!);
    }
    if (acceptEncoding != null) {
      headers.set(_acceptEncodingHeader, acceptEncoding!);
    }
    if (acceptLanguage != null) {
      headers.set(_acceptLanguageHeader, acceptLanguage!);
    }
    if (acceptRanges != null) headers.set(_acceptRangesHeader, acceptRanges!);
    if (accessControlAllowCredentials != null) {
      headers.set(
          _accessControlAllowCredentialsHeader, accessControlAllowCredentials!);
    }
    if (accessControlAllowOrigin != null) {
      headers.set(_accessControlAllowOriginHeader, accessControlAllowOrigin!);
    }
    if (accessControlExposeHeaders != null) {
      headers.set(
          _accessControlExposeHeadersHeader, accessControlExposeHeaders!);
    }
    if (accessControlMaxAge != null) {
      headers.set(_accessControlMaxAgeHeader, accessControlMaxAge!);
    }
    if (accessControlRequestHeaders != null) {
      headers.set(
          _accessControlRequestHeadersHeader, accessControlRequestHeaders!);
    }
    if (accessControlRequestMethod != null) {
      headers.set(
          _accessControlRequestMethodHeader, accessControlRequestMethod!);
    }
    if (age != null) headers.set(_ageHeader, age!);
    if (allow != null) headers.set(_allowHeader, allow!);
    if (authorization != null) {
      headers.set(_authorizationHeader, authorization.toString());
    }
    if (cacheControl != null) headers.set(_cacheControlHeader, cacheControl!);
    if (connection != null) headers.set(_connectionHeader, connection!);
    if (contentEncoding != null) {
      headers.set(_contentEncodingHeader, contentEncoding!);
    }
    if (contentLanguage != null) {
      headers.set(_contentLanguageHeader, contentLanguage!);
    }

    if (contentLocation != null) {
      headers.set(_contentLocationHeader, contentLocation!);
    }
    if (contentMD5 != null) headers.set(_contentMD5Header, contentMD5!);
    if (contentRange != null) headers.set(_contentRangeHeader, contentRange!);
    if (etag != null) headers.set(_etagHeader, etag!);
    if (expect != null) headers.set(_expectHeader, expect!);
    if (ifMatch != null) headers.set(_ifMatchHeader, ifMatch!);
    if (ifNoneMatch != null) headers.set(_ifNoneMatchHeader, ifNoneMatch!);
    if (ifRange != null) headers.set(_ifRangeHeader, ifRange!);

    if (maxForwards != null) headers.set(_maxForwardsHeader, maxForwards!);
    if (mPragma != null) headers.set(_pragmaHeader, mPragma!);
    if (proxyAuthenticate != null) {
      headers.set(_proxyAuthenticateHeader, proxyAuthenticate!);
    }
    if (proxyAuthorization != null) {
      headers.set(_proxyAuthorizationHeader, proxyAuthorization!);
    }
    if (range != null) headers.set(_rangeHeader, range!);
    if (referer != null) headers.set(_refererHeader, referer!);
    if (retryAfter != null) headers.set(_retryAfterHeader, retryAfter!);
    if (server != null) headers.set(_serverHeader, server!);
    if (te != null) headers.set(_teHeader, te!);
    if (trailer != null) headers.set(_trailerHeader, trailer!);
    if (transferEncoding != null) {
      headers.set(_transferEncodingHeader, transferEncoding!);
    }
    if (upgrade != null) headers.set(_upgradeHeader, upgrade!);
    if (userAgent != null) headers.set(_userAgentHeader, userAgent!);
    if (vary != null) headers.set(_varyHeader, vary!);
    if (via != null) headers.set(_viaHeader, via!);
    if (warning != null) headers.set(_warningHeader, warning!);
    if (wwwAuthenticate != null) {
      headers.set(_wwwAuthenticateHeader, wwwAuthenticate!);
    }
    if (contentDisposition != null) {
      headers.set(_contentDispositionHeader, contentDisposition!);
    }

    // Set custom headers
    for (var entry in custom.entries) {
      headers.set(entry.key, entry.value);
    }

    // Set the content length from the Body
    headers.contentLength = body.contentLength ?? 0;

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
    AcceptHeader? accept,
    List<String>? acceptCharset,
    List<String>? acceptEncoding,
    List<String>? acceptLanguage,
    List<String>? acceptRanges,
    bool? accessControlAllowCredentials,
    String? accessControlAllowOrigin,
    List<String>? accessControlExposeHeaders,
    int? accessControlMaxAge,
    List<String>? accessControlRequestHeaders,
    Method? accessControlRequestMethod,
    String? age,
    List<Method>? allow,
    ContentDispositionHeader? contentDisposition,
    AuthorizationHeader? authorization,
    CacheControlHeader? cacheControl,
    ConnectionHeader? connection,
    List<String>? contentEncoding,
    List<String>? contentLanguage,
    String? contentLocation,
    String? contentMD5,
    ContentRangeHeader? contentRange,
    ETagHeader? etag,
    String? expect,
    List<String>? ifMatch,
    List<String>? ifNoneMatch,
    String? ifRange,
    String? lastModified,
    int? maxForwards,
    String? mPragma,
    ProxyAuthenticateHeader? proxyAuthenticate,
    ProxyAuthorizationHeader? proxyAuthorization,
    RangeHeader? range,
    String? referer,
    RetryAfterHeader? retryAfter,
    ServerHeader? server,
    List<String>? te,
    List<String>? trailer,
    TransferEncodingHeader? transferEncoding,
    List<String>? upgrade,
    String? userAgent,
    VaryHeader? vary,
    List<String>? via,
    List<String>? warning,
    List<String>? wwwAuthenticate,
    CustomHeaders? custom,
  });

  Headers withOther(Headers? other);

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
      if (accept != null) '$_acceptHeader: $accept!',
      if (acceptCharset != null)
        '$_acceptCharsetHeader: ${acceptCharset!.join(', ')}',
      if (acceptEncoding != null)
        '$_acceptEncodingHeader: ${acceptEncoding!.join(', ')}',
      if (acceptLanguage != null)
        '$_acceptLanguageHeader: ${acceptLanguage!.join(', ')}',
      if (acceptRanges != null)
        '$_acceptRangesHeader: ${acceptRanges!.join(', ')}',
      if (accessControlAllowCredentials != null)
        '$_accessControlAllowCredentialsHeader: $accessControlAllowCredentials',
      if (accessControlAllowOrigin != null)
        '$_accessControlAllowOriginHeader: $accessControlAllowOrigin',
      if (accessControlExposeHeaders != null)
        '$_accessControlExposeHeadersHeader: ${accessControlExposeHeaders!.join(', ')}',
      if (accessControlMaxAge != null)
        '$_accessControlMaxAgeHeader: $accessControlMaxAge',
      if (accessControlRequestHeaders != null)
        '$_accessControlRequestHeadersHeader: ${accessControlRequestHeaders!.join(', ')}',
      if (accessControlRequestMethod != null)
        '$_accessControlRequestMethodHeader: $accessControlRequestMethod',
      if (age != null) '$_ageHeader: $age',
      if (allow != null) '$_allowHeader: ${allow!.join(', ')}',
      if (authorization != null) '$authorization',
      if (cacheControl != null) '$_cacheControlHeader: $cacheControl',
      if (connection != null) '$_connectionHeader: $connection',
      if (contentEncoding != null)
        '$_contentEncodingHeader: ${contentEncoding!.join(', ')}',
      if (contentLanguage != null)
        '$_contentLanguageHeader: ${contentLanguage!.join(', ')}',
      if (contentLocation != null) '$_contentLocationHeader: $contentLocation',
      if (contentMD5 != null) '$_contentMD5Header: $contentMD5',
      if (contentRange != null) '$_contentRangeHeader: $contentRange',
      if (etag != null) '$_etagHeader: $etag',
      if (expect != null) '$_expectHeader: $expect',
      if (ifMatch != null) '$_ifMatchHeader: ${ifMatch!.join(', ')}',
      if (ifNoneMatch != null)
        '$_ifNoneMatchHeader: ${ifNoneMatch!.join(', ')}',
      if (ifRange != null) '$_ifRangeHeader: $ifRange',
      if (lastModified != null) '$_lastModifiedHeader: $lastModified',
      if (maxForwards != null) '$_maxForwardsHeader: $maxForwards',
      if (mPragma != null) '$_pragmaHeader: $mPragma',
      if (proxyAuthenticate != null)
        '$_proxyAuthenticateHeader: $proxyAuthenticate',
      if (proxyAuthorization != null)
        '$_proxyAuthorizationHeader: $proxyAuthorization',
      if (range != null) '$_rangeHeader: $range',
      if (referer != null) '$_refererHeader: $referer',
      if (retryAfter != null) '$_retryAfterHeader: $retryAfter',
      if (server != null) '$_serverHeader: $server',
      if (te != null) '$_teHeader: ${te!.join(', ')}',
      if (trailer != null) '$_trailerHeader: ${trailer!.join(', ')}',
      if (transferEncoding != null)
        '$_transferEncodingHeader: $transferEncoding',
      if (upgrade != null) '$_upgradeHeader: ${upgrade!.join(', ')}',
      if (userAgent != null) '$_userAgentHeader: $userAgent',
      if (vary != null) '$_varyHeader: $vary',
      if (via != null) '$_viaHeader: ${via!.join(', ')}',
      if (warning != null)
        ...warning!.map((value) => '$_warningHeader: $value'),
      if (wwwAuthenticate != null)
        ...wwwAuthenticate!.map((value) => '$_wwwAuthenticateHeader: $value'),
      if (contentDisposition != null)
        '$_contentDispositionHeader: $contentDisposition',
      ...custom.entries.map((entry) => '${entry.key}: ${entry.value}'),
    ];

    return strings.join('\n');
  }

  Map<String, Object> toMap() {
    return {
      if (date != null) _dateHeader: '$date',
      if (expires != null) _expiresHeader: '$expires',
      if (ifModifiedSince != null) _ifModifiedSinceHeader: '$ifModifiedSince',
      if (from != null) _fromHeader: from!,
      if (host != null) _hostHeader: port != null ? '$host:$port' : host!,
      if (location != null) _locationHeader: location.toString(),
      if (xPoweredBy != null) _xPoweredByHeader: xPoweredBy!,
      if (accept != null) _acceptHeader: accept!,
      if (acceptCharset != null) _acceptCharsetHeader: acceptCharset!,
      if (acceptEncoding != null) _acceptEncodingHeader: acceptEncoding!,
      if (acceptLanguage != null) _acceptLanguageHeader: acceptLanguage!,
      if (acceptRanges != null) _acceptRangesHeader: acceptRanges!,
      if (accessControlAllowCredentials != null)
        _accessControlAllowCredentialsHeader: accessControlAllowCredentials!,
      if (accessControlAllowOrigin != null)
        _accessControlAllowOriginHeader: accessControlAllowOrigin!,
      if (accessControlExposeHeaders != null)
        _accessControlExposeHeadersHeader: accessControlExposeHeaders!,
      if (accessControlMaxAge != null)
        _accessControlMaxAgeHeader: accessControlMaxAge!,
      if (accessControlRequestHeaders != null)
        _accessControlRequestHeadersHeader: accessControlRequestHeaders!,
      if (accessControlRequestMethod != null)
        _accessControlRequestMethodHeader: accessControlRequestMethod!,
      if (age != null) _ageHeader: age!,
      if (allow != null) _allowHeader: allow!,
      if (authorization != null) _authorizationHeader: authorization.toString(),
      if (cacheControl != null) _cacheControlHeader: cacheControl!,
      if (connection != null) _connectionHeader: connection!,
      if (contentEncoding != null) _contentEncodingHeader: contentEncoding!,
      if (contentLanguage != null) _contentLanguageHeader: contentLanguage!,
      if (contentLocation != null) _contentLocationHeader: contentLocation!,
      if (contentMD5 != null) _contentMD5Header: contentMD5!,
      if (contentRange != null) _contentRangeHeader: contentRange!,
      if (etag != null) _etagHeader: etag!,
      if (expect != null) _expectHeader: expect!,
      if (ifMatch != null) _ifMatchHeader: ifMatch!,
      if (ifNoneMatch != null) _ifNoneMatchHeader: ifNoneMatch!,
      if (ifRange != null) _ifRangeHeader: ifRange!,
      if (lastModified != null) _lastModifiedHeader: lastModified!,
      if (maxForwards != null) _maxForwardsHeader: maxForwards!,
      if (mPragma != null) _pragmaHeader: mPragma!,
      if (proxyAuthenticate != null)
        _proxyAuthenticateHeader: proxyAuthenticate!,
      if (proxyAuthorization != null)
        _proxyAuthorizationHeader: proxyAuthorization!,
      if (range != null) _rangeHeader: range!,
      if (referer != null) _refererHeader: referer!,
      if (retryAfter != null) _retryAfterHeader: retryAfter!,
      if (server != null) _serverHeader: server!,
      if (te != null) _teHeader: te!,
      if (trailer != null) _trailerHeader: trailer!,
      if (transferEncoding != null) _transferEncodingHeader: transferEncoding!,
      if (upgrade != null) _upgradeHeader: upgrade!,
      if (userAgent != null) _userAgentHeader: userAgent!,
      if (vary != null) _varyHeader: vary!,
      if (via != null) _viaHeader: via!,
      if (warning != null) _warningHeader: warning!,
      if (wwwAuthenticate != null) _wwwAuthenticateHeader: wwwAuthenticate!,
      if (contentDisposition != null)
        _contentDispositionHeader: contentDisposition!,
      ...custom,
    };
  }

  bool get isEmpty {
    /// Check if all managed fields are null or empty
    bool managedHeadersEmpty = date == null &&
        expires == null &&
        ifModifiedSince == null &&
        from == null &&
        host == null &&
        port == null &&
        location == null &&
        xPoweredBy == null &&
        (accept == null || accept!.mediaTypes.isEmpty) &&
        (acceptCharset == null || acceptCharset!.isEmpty) &&
        (acceptEncoding == null || acceptEncoding!.isEmpty) &&
        (acceptLanguage == null || acceptLanguage!.isEmpty) &&
        (acceptRanges == null || acceptRanges!.isEmpty) &&
        accessControlAllowCredentials == null &&
        accessControlAllowOrigin == null &&
        (accessControlExposeHeaders == null ||
            accessControlExposeHeaders!.isEmpty) &&
        accessControlMaxAge == null &&
        (accessControlRequestHeaders == null ||
            accessControlRequestHeaders!.isEmpty) &&
        accessControlRequestMethod == null &&
        age == null &&
        (allow == null || allow!.isEmpty) &&
        authorization == null &&
        cacheControl == null &&
        (connection == null || connection!.directives.isEmpty) &&
        (contentEncoding == null || contentEncoding!.isEmpty) &&
        (contentLanguage == null || contentLanguage!.isEmpty) &&
        contentLocation == null &&
        contentMD5 == null &&
        contentRange == null &&
        etag == null &&
        expect == null &&
        (ifMatch == null || ifMatch!.isEmpty) &&
        (ifNoneMatch == null || ifNoneMatch!.isEmpty) &&
        ifRange == null &&
        lastModified == null &&
        maxForwards == null &&
        mPragma == null &&
        (proxyAuthenticate == null || proxyAuthenticate!.schemes.isEmpty) &&
        proxyAuthorization == null &&
        range == null &&
        referer == null &&
        retryAfter == null &&
        server == null &&
        (te == null || te!.isEmpty) &&
        (trailer == null || trailer!.isEmpty) &&
        (transferEncoding == null || transferEncoding!.encodings.isEmpty) &&
        (upgrade == null || upgrade!.isEmpty) &&
        userAgent == null &&
        (vary == null || vary!.fields.isEmpty) &&
        (via == null || via!.isEmpty) &&
        (warning == null || warning!.isEmpty) &&
        (wwwAuthenticate == null || wwwAuthenticate!.isEmpty) &&
        contentDisposition == null;

    /// Check if custom headers are empty
    bool customHeadersEmpty = custom.isEmpty;

    /// Return true if both managed and custom headers are empty
    return managedHeadersEmpty && customHeadersEmpty;
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
    super.acceptEncoding,
    super.acceptLanguage,
    super.acceptRanges,
    super.accessControlAllowCredentials,
    super.accessControlAllowOrigin,
    super.accessControlExposeHeaders,
    super.accessControlMaxAge,
    super.accessControlRequestHeaders,
    super.accessControlRequestMethod,
    super.age,
    super.allow,
    super.contentDisposition,
    super.authorization,
    super.cacheControl,
    super.connection,
    super.contentEncoding,
    super.contentLanguage,
    super.contentLocation,
    super.contentMD5,
    super.contentRange,
    super.etag,
    super.expect,
    super.ifMatch,
    super.ifNoneMatch,
    super.ifRange,
    super.lastModified,
    super.maxForwards,
    super.mPragma,
    super.proxyAuthenticate,
    super.proxyAuthorization,
    super.range,
    super.referer,
    super.retryAfter,
    super.server,
    super.te,
    super.trailer,
    super.transferEncoding,
    super.upgrade,
    super.userAgent,
    super.vary,
    super.via,
    super.warning,
    super.wwwAuthenticate,
    super.custom,
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
    Object? acceptEncoding = _Undefined,
    Object? acceptLanguage = _Undefined,
    Object? acceptRanges = _Undefined,
    Object? accessControlAllowCredentials = _Undefined,
    Object? accessControlAllowOrigin = _Undefined,
    Object? accessControlExposeHeaders = _Undefined,
    Object? accessControlMaxAge = _Undefined,
    Object? accessControlRequestHeaders = _Undefined,
    Object? accessControlRequestMethod = _Undefined,
    Object? age = _Undefined,
    Object? allow = _Undefined,
    Object? contentDisposition = _Undefined,
    CustomHeaders? custom,
    AuthorizationHeader? authorization,
    Object? cacheControl = _Undefined,
    Object? connection = _Undefined,
    Object? contentEncoding = _Undefined,
    Object? contentLanguage = _Undefined,
    Object? contentLocation = _Undefined,
    Object? contentMD5 = _Undefined,
    Object? contentRange = _Undefined,
    Object? etag = _Undefined,
    Object? expect = _Undefined,
    Object? ifMatch = _Undefined,
    Object? ifNoneMatch = _Undefined,
    Object? ifRange = _Undefined,
    Object? lastModified = _Undefined,
    Object? maxForwards = _Undefined,
    Object? mPragma = _Undefined,
    Object? proxyAuthenticate = _Undefined,
    Object? proxyAuthorization = _Undefined,
    Object? range = _Undefined,
    Object? referer = _Undefined,
    Object? retryAfter = _Undefined,
    Object? server = _Undefined,
    Object? te = _Undefined,
    Object? trailer = _Undefined,
    Object? transferEncoding = _Undefined,
    Object? upgrade = _Undefined,
    Object? userAgent = _Undefined,
    Object? vary = _Undefined,
    Object? via = _Undefined,
    Object? warning = _Undefined,
    Object? wwwAuthenticate = _Undefined,
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
      accept: accept is AcceptHeader ? accept : this.accept,
      acceptCharset:
          acceptCharset is List<String> ? acceptCharset : this.acceptCharset,
      acceptEncoding:
          acceptEncoding is List<String> ? acceptEncoding : this.acceptEncoding,
      acceptLanguage:
          acceptLanguage is List<String> ? acceptLanguage : this.acceptLanguage,
      acceptRanges:
          acceptRanges is List<String> ? acceptRanges : this.acceptRanges,
      accessControlAllowCredentials: accessControlAllowCredentials is bool
          ? accessControlAllowCredentials
          : this.accessControlAllowCredentials,
      accessControlAllowOrigin: accessControlAllowOrigin is String
          ? accessControlAllowOrigin
          : this.accessControlAllowOrigin,
      accessControlExposeHeaders: accessControlExposeHeaders is List<String>
          ? accessControlExposeHeaders
          : this.accessControlExposeHeaders,
      accessControlMaxAge: accessControlMaxAge is int
          ? accessControlMaxAge
          : this.accessControlMaxAge,
      accessControlRequestHeaders: accessControlRequestHeaders is List<String>
          ? accessControlRequestHeaders
          : this.accessControlRequestHeaders,
      accessControlRequestMethod: accessControlRequestMethod is Method
          ? accessControlRequestMethod
          : this.accessControlRequestMethod,
      age: age is int ? age : this.age,
      allow: allow is List<Method> ? allow : this.allow,
      contentDisposition: contentDisposition is ContentDispositionHeader
          ? contentDisposition
          : this.contentDisposition,
      authorization: authorization ?? this.authorization,
      cacheControl:
          cacheControl is CacheControlHeader ? cacheControl : this.cacheControl,
      connection: connection is ConnectionHeader ? connection : this.connection,
      contentEncoding: contentEncoding is List<String>
          ? contentEncoding
          : this.contentEncoding,
      contentLanguage: contentLanguage is List<String>
          ? contentLanguage
          : this.contentLanguage,
      contentLocation:
          contentLocation is String ? contentLocation : this.contentLocation,
      contentMD5: contentMD5 is String ? contentMD5 : this.contentMD5,
      contentRange:
          contentRange is ContentRangeHeader ? contentRange : this.contentRange,
      etag: etag is ETagHeader ? etag : this.etag,
      expect: expect is String ? expect : this.expect,
      ifMatch: ifMatch is List<String> ? ifMatch : this.ifMatch,
      ifNoneMatch: ifNoneMatch is List<String> ? ifNoneMatch : this.ifNoneMatch,
      ifRange: ifRange is String ? ifRange : this.ifRange,
      lastModified: lastModified is DateTime ? lastModified : this.lastModified,
      maxForwards: maxForwards is int ? maxForwards : this.maxForwards,
      mPragma: mPragma is String ? mPragma : this.mPragma,
      proxyAuthenticate: proxyAuthenticate is ProxyAuthenticateHeader
          ? proxyAuthenticate
          : this.proxyAuthenticate,
      proxyAuthorization: proxyAuthorization is ProxyAuthorizationHeader
          ? proxyAuthorization
          : this.proxyAuthorization,
      range: range is RangeHeader ? range : this.range,
      referer: referer is Uri ? referer : this.referer,
      retryAfter: retryAfter is RetryAfterHeader ? retryAfter : this.retryAfter,
      server: server is ServerHeader ? server : this.server,
      te: te is List<String> ? te : this.te,
      trailer: trailer is List<String> ? trailer : this.trailer,
      transferEncoding: transferEncoding is TransferEncodingHeader
          ? transferEncoding
          : this.transferEncoding,
      upgrade: upgrade is List<String> ? upgrade : this.upgrade,
      userAgent: userAgent is String ? userAgent : this.userAgent,
      vary: vary is VaryHeader ? vary : this.vary,
      via: via is List<String> ? via : this.via,
      warning: warning is List<String> ? warning : this.warning,
      wwwAuthenticate: wwwAuthenticate is List<String>
          ? wwwAuthenticate
          : this.wwwAuthenticate,
      custom: custom ?? this.custom,
    );
  }

  /// Merges the current `Headers` instance with another `Headers`.
  ///
  /// If `other` is `null`, this instance is returned unchanged. Otherwise, fields
  /// from `other` will overwrite the corresponding fields in this instance.
  /// Custom headers are merged as well.
  ///
  /// Returns a new `Headers` instance with the merged values.
  @override
  Headers withOther(Headers? other) {
    if (other == null) return this;

    return copyWith(
      date: other.date,
      expires: other.expires,
      ifModifiedSince: other.ifModifiedSince,
      from: other.from,
      host: other.host,
      port: other.port,
      location: other.location,
      xPoweredBy: other.xPoweredBy,
      accept: other.accept,
      acceptCharset: other.acceptCharset,
      acceptEncoding: other.acceptEncoding,
      acceptLanguage: other.acceptLanguage,
      acceptRanges: other.acceptRanges,
      accessControlAllowCredentials: other.accessControlAllowCredentials,
      accessControlAllowOrigin: other.accessControlAllowOrigin,
      accessControlExposeHeaders: other.accessControlExposeHeaders,
      accessControlMaxAge: other.accessControlMaxAge,
      accessControlRequestHeaders: other.accessControlRequestHeaders,
      accessControlRequestMethod: other.accessControlRequestMethod,
      age: other.age,
      allow: other.allow,
      contentDisposition: other.contentDisposition,
      authorization: other.authorization,
      cacheControl: other.cacheControl,
      connection: other.connection,
      contentEncoding: other.contentEncoding,
      contentLanguage: other.contentLanguage,
      contentLocation: other.contentLocation,
      contentMD5: other.contentMD5,
      contentRange: other.contentRange,
      etag: other.etag,
      expect: other.expect,
      ifMatch: other.ifMatch,
      ifNoneMatch: other.ifNoneMatch,
      ifRange: other.ifRange,
      lastModified: other.lastModified,
      maxForwards: other.maxForwards,
      mPragma: other.mPragma,
      proxyAuthenticate: other.proxyAuthenticate,
      proxyAuthorization: other.proxyAuthorization,
      range: other.range,
      referer: other.referer,
      retryAfter: other.retryAfter,
      server: other.server,
      te: other.te,
      trailer: other.trailer,
      transferEncoding: other.transferEncoding,
      upgrade: other.upgrade,
      userAgent: other.userAgent,
      vary: other.vary,
      via: other.via,
      warning: other.warning,
      wwwAuthenticate: other.wwwAuthenticate,
      custom: custom._withOther(other.custom),
    );
  }
}

class _Undefined {}
