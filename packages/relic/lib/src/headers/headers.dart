import 'dart:collection';
import 'dart:convert';
import 'dart:io' as io;

import 'package:http_parser/http_parser.dart';
import 'package:relic/src/headers/extension/string_list_extensions.dart';
import 'package:relic/src/headers/parser/headers_parser.dart';
import 'package:relic/src/method/method.dart';

import '../body/body.dart';

part 'custom/custom_headers.dart';
part 'typed_headers/authorization_header.dart';
part 'typed_headers/content_range_header.dart';
part 'typed_headers/cache_control_header.dart';
part 'typed_headers/content_disposition_header.dart';
part 'typed_headers/range_header.dart';
part 'typed_headers/retry_after_header.dart';
part 'typed_headers/accept_header.dart';
part 'typed_headers/connection_header.dart';
part 'typed_headers/etag_header.dart';
part 'typed_headers/vary_header.dart';
part 'typed_headers/authentication_header.dart';
part 'typed_headers/transfer_encoding_header.dart';
part 'typed_headers/from_header.dart';
part 'typed_headers/if_range_header.dart';
part 'typed_headers/expect_header.dart';
part 'typed_headers/access_control_allow_origin_header.dart';
part 'typed_headers/access_control_allow_headers_header.dart';
part 'typed_headers/access_control_expose_headers_header.dart';
part 'typed_headers/strict_transport_security_header.dart';
part 'typed_headers/content_security_policy_header.dart';
part 'typed_headers/referrer_policy_header.dart';
part 'typed_headers/permission_policy_header.dart';
part 'typed_headers/access_control_allow_methods_header.dart';
part 'typed_headers/clear_site_data_header.dart';
part 'typed_headers/sec_fetch_dest_header.dart';
part 'typed_headers/sec_fetch_mode_header.dart';
part 'typed_headers/sec_fetch_site_header.dart';
part 'typed_headers/cross_origin_resource_policy_header.dart';
part 'typed_headers/cross_origin_embedder_policy_header.dart';
part 'typed_headers/cross_origin_opener_policy_header.dart';
part 'typed_headers/accept_encoding_header.dart';
part 'typed_headers/accept_language_header.dart';
part 'typed_headers/content_encoding_header.dart';
part 'typed_headers/etag_condition_header.dart';
part 'typed_headers/te_header.dart';
part 'typed_headers/content_language_header.dart';
part 'typed_headers/accept_ranges_header.dart';
part 'typed_headers/upgrade_header.dart';
part 'typed_headers/cookie_header.dart';

abstract class Headers {
  /// Request Headers
  static const _acceptHeader = "accept";
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
  static const _proxyAuthorizationHeader = "proxy-authorization";
  static const _rangeHeader = "range";
  static const _teHeader = "te";
  static const _upgradeHeader = "upgrade";
  static const _userAgentHeader = "user-agent";
  static const _accessControlRequestHeadersHeader =
      'access-control-request-headers';
  static const _accessControlRequestMethodHeader =
      'access-control-request-method';

  /// Response Headers
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
  static const _contentRangeHeader = "content-range";
  static const _etagHeader = "etag";
  static const _expiresHeader = "expires";
  static const _lastModifiedHeader = "last-modified";
  static const _locationHeader = "location";
  static const _proxyAuthenticationHeader = "proxy-authenticate";
  static const _retryAfterHeader = "retry-after";
  static const _trailerHeader = "trailer";
  static const _transferEncodingHeader = "transfer-encoding";
  static const _varyHeader = "vary";
  static const _wwwAuthenticateHeader = "www-authenticate";
  static const _xPoweredByHeader = 'x-powered-by';

  /// Common Headers (Used in Both Requests and Responses)
  static const _acceptRangesHeader = "accept-ranges";
  static const _contentLengthHeader = "content-length";
  static const _contentTypeHeader = "content-type";

  /// General Headers
  static const _dateHeader = "date";
  static const _originHeader = "origin";
  static const _refererHeader = "referer";
  static const _serverHeader = "server";
  static const _viaHeader = "via";
  static const _cookieHeader = "cookie";
  static const _setCookieHeader = "set-cookie";

  /// Security and Modern Headers
  static const _strictTransportSecurityHeader = "strict-transport-security";
  static const _contentSecurityPolicyHeader = "content-security-policy";
  static const _referrerPolicyHeader = "referrer-policy";
  static const _permissionsPolicyHeader = "permissions-policy";
  static const _accessControlAllowMethodsHeader =
      "access-control-allow-methods";
  static const _accessControlAllowHeadersHeader =
      "access-control-allow-headers";
  static const _clearSiteDataHeader = "clear-site-data";
  static const _secFetchDestHeader = "sec-fetch-dest";
  static const _secFetchModeHeader = "sec-fetch-mode";
  static const _secFetchSiteHeader = "sec-fetch-site";
  static const _crossOriginResourcePolicyHeader =
      "cross-origin-resource-policy";
  static const _crossOriginEmbedderPolicyHeader =
      "cross-origin-embedder-policy";
  static const _crossOriginOpenerPolicyHeader = "cross-origin-opener-policy";

  /// Define header properties

  /// Date-related headers
  final DateTime? date;
  final DateTime? expires;
  final DateTime? ifModifiedSince;
  final DateTime? lastModified;

  /// General Headers
  final Uri? origin;
  final String? server;
  final List<String>? via;

  /// Request Headers
  final FromHeader? from;
  final Uri? host;
  final AcceptEncodingHeader? acceptEncoding;
  final AcceptLanguageHeader? acceptLanguage;
  final List<String>? accessControlRequestHeaders;
  final Method? accessControlRequestMethod;
  final int? age;
  final List<Method>? allow;
  final AuthorizationHeader? authorization;
  final AuthorizationHeader? proxyAuthorization;
  final ConnectionHeader? connection;
  final ExpectHeader? expect;
  final IfMatchHeader? ifMatch;
  final IfNoneMatchHeader? ifNoneMatch;
  final IfRangeHeader? ifRange;
  final int? maxForwards;
  final RangeHeader? range;
  final Uri? referer;
  final String? userAgent;
  final TEHeader? te;
  final UpgradeHeader? upgrade;

  /// Response Headers
  final Uri? location;
  final String? xPoweredBy;
  final bool? accessControlAllowCredentials;
  final AccessControlAllowOriginHeader? accessControlAllowOrigin;
  final AccessControlExposeHeadersHeader? accessControlExposeHeaders;
  final int? accessControlMaxAge;
  final CacheControlHeader? cacheControl;
  final ContentEncodingHeader? contentEncoding;
  final ContentLanguageHeader? contentLanguage;
  final Uri? contentLocation;
  final ContentRangeHeader? contentRange;
  final ETagHeader? etag;
  final AuthenticationHeader? proxyAuthenticate;
  final AuthenticationHeader? wwwAuthenticate;
  final RetryAfterHeader? retryAfter;
  final List<String>? trailer;
  final VaryHeader? vary;
  final ContentDispositionHeader? contentDisposition;

  /// Common Headers (Used in Both Requests and Responses)

  final AcceptHeader? accept;
  final AcceptRangesHeader? acceptRanges;
  final TransferEncodingHeader? transferEncoding;
  final CookieHeader? cookie;
  final CookieHeader? setCookie;

  /// Security and Modern Headers
  final StrictTransportSecurityHeader? strictTransportSecurity;
  final ContentSecurityPolicyHeader? contentSecurityPolicy;
  final ReferrerPolicyHeader? referrerPolicy;
  final PermissionsPolicyHeader? permissionsPolicy;
  final AccessControlAllowMethodsHeader? accessControlAllowMethods;
  final AccessControlAllowHeadersHeader? accessControlAllowHeaders;
  final ClearSiteDataHeader? clearSiteData;
  final SecFetchDestHeader? secFetchDest;
  final SecFetchModeHeader? secFetchMode;
  final SecFetchSiteHeader? secFetchSite;
  final CrossOriginResourcePolicyHeader? crossOriginResourcePolicy;
  final CrossOriginEmbedderPolicyHeader? crossOriginEmbedderPolicy;
  final CrossOriginOpenerPolicyHeader? crossOriginOpenerPolicy;

  /// Custom Headers
  final CustomHeaders custom;

  final Map<String, List<String>> failedHeadersToParse;

  static const _managedHeaders = <String>{
    _dateHeader,
    _expiresHeader,
    _ifModifiedSinceHeader,
    _ifUnmodifiedSinceHeader,
    _lastModifiedHeader,

    // General Headers
    _originHeader,
    _serverHeader,
    _viaHeader,

    // Request Headers
    _acceptEncodingHeader,
    _acceptLanguageHeader,
    _accessControlRequestHeadersHeader,
    _accessControlRequestMethodHeader,
    _ageHeader,
    _allowHeader,
    _authorizationHeader,
    _connectionHeader,
    _expectHeader,
    _fromHeader,
    _hostHeader,
    _ifMatchHeader,
    _ifNoneMatchHeader,
    _ifRangeHeader,
    _maxForwardsHeader,
    _proxyAuthorizationHeader,
    _rangeHeader,
    _refererHeader,
    _teHeader,
    _upgradeHeader,
    _userAgentHeader,

    // Response Headers
    _accessControlAllowCredentialsHeader,
    _accessControlAllowOriginHeader,
    _accessControlExposeHeadersHeader,
    _accessControlMaxAgeHeader,
    _cacheControlHeader,
    _contentDispositionHeader,
    _contentEncodingHeader,
    _contentLanguageHeader,
    _contentLocationHeader,
    _contentRangeHeader,
    _etagHeader,
    _locationHeader,
    _proxyAuthenticationHeader,
    _retryAfterHeader,
    _trailerHeader,
    _transferEncodingHeader,
    _varyHeader,
    _wwwAuthenticateHeader,
    _xPoweredByHeader,

    // Common Headers (Used in Both Requests and Responses)
    _acceptHeader,
    _acceptRangesHeader,
    _contentLengthHeader,
    _contentTypeHeader,
    _cookieHeader,
    _setCookieHeader,

    // Security and Modern Headers
    _accessControlAllowHeadersHeader,
    _accessControlAllowMethodsHeader,
    _clearSiteDataHeader,
    _contentSecurityPolicyHeader,
    _crossOriginEmbedderPolicyHeader,
    _crossOriginOpenerPolicyHeader,
    _crossOriginResourcePolicyHeader,
    _permissionsPolicyHeader,
    _referrerPolicyHeader,
    _secFetchDestHeader,
    _secFetchModeHeader,
    _secFetchSiteHeader,
    _strictTransportSecurityHeader,
  };

  Headers._({
    // Date-related headers
    this.date,
    this.expires,
    this.ifModifiedSince,
    this.lastModified,

    // General Headers
    this.origin,
    this.server,
    this.via,

    // Request Headers
    this.from,
    this.host,
    this.acceptEncoding,
    this.acceptLanguage,
    this.accessControlRequestHeaders,
    this.accessControlRequestMethod,
    this.age,
    this.allow,
    this.authorization,
    this.connection,
    this.expect,
    this.ifMatch,
    this.ifNoneMatch,
    this.ifRange,
    this.maxForwards,
    this.proxyAuthorization,
    this.range,
    this.referer,
    this.userAgent,
    this.te,
    this.upgrade,

    // Response Headers
    this.location,
    this.xPoweredBy,
    this.accessControlAllowCredentials,
    this.accessControlAllowOrigin,
    this.accessControlExposeHeaders,
    this.accessControlMaxAge,
    this.cacheControl,
    this.contentEncoding,
    this.contentLanguage,
    this.contentLocation,
    this.contentRange,
    this.etag,
    this.proxyAuthenticate,
    this.retryAfter,
    this.trailer,
    this.vary,
    this.wwwAuthenticate,
    this.contentDisposition,

    // Common Headers (Used in Both Requests and Responses)
    this.accept,
    this.acceptRanges,
    this.transferEncoding,
    this.cookie,
    this.setCookie,
    CustomHeaders? custom,

    // Security and Modern Headers
    this.strictTransportSecurity,
    this.contentSecurityPolicy,
    this.referrerPolicy,
    this.permissionsPolicy,
    this.accessControlAllowMethods,
    this.accessControlAllowHeaders,
    this.clearSiteData,
    this.secFetchDest,
    this.secFetchMode,
    this.secFetchSite,
    this.crossOriginResourcePolicy,
    this.crossOriginEmbedderPolicy,
    this.crossOriginOpenerPolicy,
    required this.failedHeadersToParse,
  }) : custom = custom ?? CustomHeaders.empty();

  factory Headers.fromHttpRequest(
    io.HttpRequest request, {
    bool strict = false,
    required String? xPoweredBy,
  }) {
    Map<String, List<String>> failedHeadersToParse = {};
    var dartIOHeaders = HeadersParser(
      headers: request.headers,
      strict: strict,
      onHeaderFailedToParse: (String key, List<String> value) {
        // We dont remove empty values because we want to save the
        // original value as it is, so we can see what was the invalid value
        value = value.splitTrimAndFilterUnique(
          emptyCheck: false,
        );
        if (failedHeadersToParse.containsKey(key)) {
          failedHeadersToParse[key]!.addAll(value);
        } else {
          failedHeadersToParse[key] = value;
        }
      },
    );

    return _HeadersImpl(
      // Date-related headers
      date: dartIOHeaders.parseDate(_dateHeader),
      expires: dartIOHeaders.parseDate(_expiresHeader),
      ifModifiedSince: dartIOHeaders.parseDate(_ifModifiedSinceHeader),
      lastModified: dartIOHeaders.parseDate(_lastModifiedHeader),

      // General Headers
      origin: dartIOHeaders.parseUri(_originHeader),
      server: dartIOHeaders.parseString(
        _serverHeader,
      ),
      via: dartIOHeaders.parseStringList(
        _viaHeader,
      ),

      // Request Headers
      from: dartIOHeaders.parseMultipleValue(
        _fromHeader,
        onParse: FromHeader.parse,
      ),
      host: dartIOHeaders.parseUri(_hostHeader),
      acceptEncoding: dartIOHeaders.parseMultipleValue(
        _acceptEncodingHeader,
        onParse: AcceptEncodingHeader.parse,
      ),
      acceptLanguage: dartIOHeaders.parseMultipleValue(
        _acceptLanguageHeader,
        onParse: AcceptLanguageHeader.parse,
      ),
      accessControlRequestHeaders: dartIOHeaders.parseStringList(
        _accessControlRequestHeadersHeader,
      ),
      accessControlRequestMethod: dartIOHeaders.parseSingleValue(
        _accessControlRequestMethodHeader,
        onParse: Method.parse,
      ),
      age: dartIOHeaders.parseInt(
        _ageHeader,
        allowNegative: false,
      ),
      allow: dartIOHeaders.parseMultipleValue(
        _allowHeader,
        onParse: (values) {
          return values
              .splitTrimAndFilterUnique(emptyCheck: false)
              .map(Method.parse)
              .toList();
        },
      ),
      cookie: dartIOHeaders.parseSingleValue(
        _cookieHeader,
        onParse: CookieHeader.parse,
      ),
      setCookie: dartIOHeaders.parseSingleValue(
        _setCookieHeader,
        onParse: CookieHeader.parse,
      ),
      authorization: dartIOHeaders.parseSingleValue(
        _authorizationHeader,
        onParse: AuthorizationHeader.parse,
      ),
      connection: dartIOHeaders.parseMultipleValue(
        _connectionHeader,
        onParse: ConnectionHeader.parse,
      ),
      expect: dartIOHeaders.parseSingleValue(
        _expectHeader,
        onParse: ExpectHeader.parse,
      ),
      ifMatch: dartIOHeaders.parseMultipleValue(
        _ifMatchHeader,
        onParse: IfMatchHeader.parse,
      ),
      ifNoneMatch: dartIOHeaders.parseMultipleValue(
        _ifNoneMatchHeader,
        onParse: IfNoneMatchHeader.parse,
      ),
      ifRange: dartIOHeaders.parseSingleValue(
        _ifRangeHeader,
        onParse: IfRangeHeader.parse,
      ),
      maxForwards: dartIOHeaders.parseInt(
        _maxForwardsHeader,
        allowNegative: false,
      ),
      proxyAuthorization: dartIOHeaders.parseSingleValue(
        _proxyAuthorizationHeader,
        onParse: AuthorizationHeader.parse,
      ),
      range: dartIOHeaders.parseSingleValue(
        _rangeHeader,
        onParse: RangeHeader.parse,
      ),
      referer: dartIOHeaders.parseUri(_refererHeader),
      te: dartIOHeaders.parseMultipleValue(
        _teHeader,
        onParse: TEHeader.parse,
      ),
      upgrade: dartIOHeaders.parseMultipleValue(
        _upgradeHeader,
        onParse: UpgradeHeader.parse,
      ),
      userAgent: dartIOHeaders.parseString(
        _userAgentHeader,
      ),

      // Response Headers
      location: dartIOHeaders.parseUri(_locationHeader),
      xPoweredBy: dartIOHeaders.parseString(
            _xPoweredByHeader,
          ) ??
          xPoweredBy,
      accessControlAllowCredentials: dartIOHeaders.parseBool(
        _accessControlAllowCredentialsHeader,
        allowFalse: false,
      ),
      accessControlAllowOrigin: dartIOHeaders.parseSingleValue(
        _accessControlAllowOriginHeader,
        onParse: AccessControlAllowOriginHeader.parse,
      ),
      accessControlExposeHeaders: dartIOHeaders.parseMultipleValue(
        _accessControlExposeHeadersHeader,
        onParse: AccessControlExposeHeadersHeader.parse,
      ),
      accessControlMaxAge: dartIOHeaders.parseInt(_accessControlMaxAgeHeader),
      cacheControl: dartIOHeaders.parseMultipleValue(
        _cacheControlHeader,
        onParse: CacheControlHeader.parse,
      ),
      contentDisposition: dartIOHeaders.parseSingleValue(
        _contentDispositionHeader,
        onParse: ContentDispositionHeader.parse,
      ),
      contentEncoding: dartIOHeaders.parseMultipleValue(
        _contentEncodingHeader,
        onParse: ContentEncodingHeader.parse,
      ),
      contentLanguage: dartIOHeaders.parseMultipleValue(
        _contentLanguageHeader,
        onParse: ContentLanguageHeader.parse,
      ),
      contentLocation: dartIOHeaders.parseUri(_contentLocationHeader),
      contentRange: dartIOHeaders.parseSingleValue(
        _contentRangeHeader,
        onParse: ContentRangeHeader.parse,
      ),
      etag: dartIOHeaders.parseSingleValue(
        _etagHeader,
        onParse: ETagHeader.parse,
      ),
      proxyAuthenticate: dartIOHeaders.parseSingleValue(
        _proxyAuthenticationHeader,
        onParse: AuthenticationHeader.parse,
      ),
      retryAfter: dartIOHeaders.parseSingleValue(
        _retryAfterHeader,
        onParse: RetryAfterHeader.parse,
      ),
      trailer: dartIOHeaders.parseStringList(
        _trailerHeader,
      ),
      transferEncoding: dartIOHeaders.parseMultipleValue(
        _transferEncodingHeader,
        onParse: TransferEncodingHeader.parse,
      ),
      vary: dartIOHeaders.parseMultipleValue(
        _varyHeader,
        onParse: VaryHeader.parse,
      ),
      wwwAuthenticate: dartIOHeaders.parseSingleValue(
        _wwwAuthenticateHeader,
        onParse: AuthenticationHeader.parse,
      ),

      // Common Headers (Used in Both Requests and Responses)
      accept: dartIOHeaders.parseMultipleValue(
        _acceptHeader,
        onParse: AcceptHeader.parse,
      ),
      acceptRanges: dartIOHeaders.parseSingleValue(
        _acceptRangesHeader,
        onParse: AcceptRangesHeader.parse,
      ),
      custom: CustomHeaders._fromHttpHeaders(
        dartIOHeaders.headers,
        excludedHeaders: _managedHeaders,
      ),

      // Security and Modern Headers
      strictTransportSecurity: dartIOHeaders.parseSingleValue(
        _strictTransportSecurityHeader,
        onParse: StrictTransportSecurityHeader.parse,
      ),
      contentSecurityPolicy: dartIOHeaders.parseSingleValue(
        _contentSecurityPolicyHeader,
        onParse: ContentSecurityPolicyHeader.parse,
      ),
      referrerPolicy: dartIOHeaders.parseSingleValue(
        _referrerPolicyHeader,
        onParse: ReferrerPolicyHeader.parse,
      ),
      permissionsPolicy: dartIOHeaders.parseSingleValue(
        _permissionsPolicyHeader,
        onParse: PermissionsPolicyHeader.parse,
      ),
      accessControlAllowMethods: dartIOHeaders.parseMultipleValue(
        _accessControlAllowMethodsHeader,
        onParse: AccessControlAllowMethodsHeader.parse,
      ),
      accessControlAllowHeaders: dartIOHeaders.parseMultipleValue(
        _accessControlAllowHeadersHeader,
        onParse: AccessControlAllowHeadersHeader.parse,
      ),
      clearSiteData: dartIOHeaders.parseMultipleValue(
        _clearSiteDataHeader,
        onParse: ClearSiteDataHeader.parse,
      ),
      secFetchDest: dartIOHeaders.parseSingleValue(
        _secFetchDestHeader,
        onParse: SecFetchDestHeader.parse,
      ),
      secFetchMode: dartIOHeaders.parseSingleValue(
        _secFetchModeHeader,
        onParse: SecFetchModeHeader.parse,
      ),
      secFetchSite: dartIOHeaders.parseSingleValue(
        _secFetchSiteHeader,
        onParse: SecFetchSiteHeader.parse,
      ),
      crossOriginResourcePolicy: dartIOHeaders.parseSingleValue(
        _crossOriginResourcePolicyHeader,
        onParse: CrossOriginResourcePolicyHeader.parse,
      ),
      crossOriginEmbedderPolicy: dartIOHeaders.parseSingleValue(
        _crossOriginEmbedderPolicyHeader,
        onParse: CrossOriginEmbedderPolicyHeader.parse,
      ),
      crossOriginOpenerPolicy: dartIOHeaders.parseSingleValue(
        _crossOriginOpenerPolicyHeader,
        onParse: CrossOriginOpenerPolicyHeader.parse,
      ),

      failedHeadersToParse: failedHeadersToParse,
    );
  }

  factory Headers.request({
    // Date-related headers
    DateTime? date,
    DateTime? ifModifiedSince,

    // Request Headers
    String? xPoweredBy,
    FromHeader? from,
    Uri? host,
    AcceptEncodingHeader? acceptEncoding,
    AcceptLanguageHeader? acceptLanguage,
    List<String>? accessControlRequestHeaders,
    Method? accessControlRequestMethod,
    int? age,
    AuthorizationHeader? authorization,
    ConnectionHeader? connection,
    ExpectHeader? expect,
    IfMatchHeader? ifMatch,
    IfNoneMatchHeader? ifNoneMatch,
    IfRangeHeader? ifRange,
    int? maxForwards,
    AuthorizationHeader? proxyAuthorization,
    RangeHeader? range,
    Uri? referer,
    String? userAgent,
    CookieHeader? cookie,
    CookieHeader? setCookie,
    TEHeader? te,
    UpgradeHeader? upgrade,

    // Fetch Metadata Headers
    SecFetchDestHeader? secFetchDest,
    SecFetchModeHeader? secFetchMode,
    SecFetchSiteHeader? secFetchSite,

    // Common Headers (Used in Both Requests and Responses)
    AcceptHeader? accept,
    AcceptRangesHeader? acceptRanges,
    TransferEncodingHeader? transferEncoding,
    CustomHeaders? custom,
  }) {
    return _HeadersImpl(
      // Date-related headers
      date: date,
      ifModifiedSince: ifModifiedSince,

      // Request Headers
      xPoweredBy: xPoweredBy,
      from: from,
      host: host,
      acceptEncoding: acceptEncoding,
      acceptLanguage: acceptLanguage,
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
      proxyAuthorization: proxyAuthorization,
      range: range,
      referer: referer,
      userAgent: userAgent,
      cookie: cookie,
      setCookie: setCookie,
      te: te,
      upgrade: upgrade,
      secFetchDest: secFetchDest,
      secFetchMode: secFetchMode,
      secFetchSite: secFetchSite,
      accept: accept,
      acceptRanges: acceptRanges,
      transferEncoding: transferEncoding,
      custom: custom ?? CustomHeaders.empty(),
      failedHeadersToParse: {},
    );
  }

  factory Headers.response({
    // Date-related headers
    DateTime? date,
    DateTime? expires,
    DateTime? lastModified,

    // General Headers
    Uri? origin,
    String? server,
    List<String>? via,

    // Used from middleware
    FromHeader? from,

    // Response Headers
    Uri? location,
    String? xPoweredBy,
    bool? accessControlAllowCredentials,
    AccessControlAllowOriginHeader? accessControlAllowOrigin,
    AccessControlExposeHeadersHeader? accessControlExposeHeaders,
    int? accessControlMaxAge,
    List<Method>? allow,
    CacheControlHeader? cacheControl,
    ContentEncodingHeader? contentEncoding,
    ContentLanguageHeader? contentLanguage,
    Uri? contentLocation,
    ContentRangeHeader? contentRange,
    ETagHeader? etag,
    AuthenticationHeader? proxyAuthenticate,
    AuthenticationHeader? wwwAuthenticate,
    RetryAfterHeader? retryAfter,
    List<String>? trailer,
    VaryHeader? vary,
    ContentDispositionHeader? contentDisposition,

    // Common Headers (Used in Both Requests and Responses)
    AcceptHeader? accept,
    AcceptRangesHeader? acceptRanges,
    TransferEncodingHeader? transferEncoding,
    CustomHeaders? custom,

    // Security and Modern Headers
    CookieHeader? cookie,
    CookieHeader? setCookie,
    StrictTransportSecurityHeader? strictTransportSecurity,
    ContentSecurityPolicyHeader? contentSecurityPolicy,
    ReferrerPolicyHeader? referrerPolicy,
    PermissionsPolicyHeader? permissionsPolicy,
    AccessControlAllowMethodsHeader? accessControlAllowMethods,
    AccessControlAllowHeadersHeader? accessControlAllowHeaders,
    ClearSiteDataHeader? clearSiteData,
    SecFetchDestHeader? secFetchDest,
    SecFetchModeHeader? secFetchMode,
    SecFetchSiteHeader? secFetchSite,
    CrossOriginResourcePolicyHeader? crossOriginResourcePolicy,
    CrossOriginEmbedderPolicyHeader? crossOriginEmbedderPolicy,
    CrossOriginOpenerPolicyHeader? crossOriginOpenerPolicy,
  }) {
    return _HeadersImpl(
      date: date ?? DateTime.now(),
      expires: expires,
      lastModified: lastModified,
      origin: origin,
      server: server,
      via: via,
      from: from,
      location: location,
      xPoweredBy: xPoweredBy,
      accessControlAllowCredentials: accessControlAllowCredentials,
      accessControlAllowOrigin: accessControlAllowOrigin,
      accessControlExposeHeaders: accessControlExposeHeaders,
      accessControlMaxAge: accessControlMaxAge,
      allow: allow,
      cacheControl: cacheControl,
      contentEncoding: contentEncoding,
      contentLanguage: contentLanguage,
      contentLocation: contentLocation,
      contentRange: contentRange,
      etag: etag,
      proxyAuthenticate: proxyAuthenticate,
      retryAfter: retryAfter,
      trailer: trailer,
      vary: vary,
      wwwAuthenticate: wwwAuthenticate,
      contentDisposition: contentDisposition,
      accept: accept,
      acceptRanges: acceptRanges,
      transferEncoding: transferEncoding,
      custom: custom ?? CustomHeaders.empty(),
      cookie: cookie,
      setCookie: setCookie,
      strictTransportSecurity: strictTransportSecurity,
      contentSecurityPolicy: contentSecurityPolicy,
      referrerPolicy: referrerPolicy,
      permissionsPolicy: permissionsPolicy,
      accessControlAllowMethods: accessControlAllowMethods,
      accessControlAllowHeaders: accessControlAllowHeaders,
      clearSiteData: clearSiteData,
      secFetchDest: secFetchDest,
      secFetchMode: secFetchMode,
      secFetchSite: secFetchSite,
      crossOriginResourcePolicy: crossOriginResourcePolicy,
      crossOriginEmbedderPolicy: crossOriginEmbedderPolicy,
      crossOriginOpenerPolicy: crossOriginOpenerPolicy,
      failedHeadersToParse: {},
    );
  }

  void applyHeaders(
    io.HttpResponse response,
    Body body,
  ) {
    var headers = response.headers;
    headers.clear();

    // Date-related headers
    headers.date = date?.toUtc() ?? DateTime.now().toUtc();
    headers.expires = expires;
    headers.ifModifiedSince = ifModifiedSince;

    if (xPoweredBy != null) {
      headers.set(_xPoweredByHeader, xPoweredBy!);
    }

    if (lastModified != null) {
      headers.set(_lastModifiedHeader, formatHttpDate(lastModified!));
    }

    // General Headers
    if (origin != null) headers.set(_originHeader, origin!.toString());
    if (server != null) headers.set(_serverHeader, server!);
    if (via != null) headers.set(_viaHeader, via!);

    // Request Headers
    if (from != null) {
      headers.set(
        _fromHeader,
        from!.toHeaderString(),
      );
    }
    if (host != null) {
      headers.host = host!.host;
      headers.port = host!.port;
    }
    if (acceptEncoding != null) {
      headers.set(
        _acceptEncodingHeader,
        acceptEncoding!.toHeaderString(),
      );
    }
    if (acceptLanguage != null) {
      headers.set(
        _acceptLanguageHeader,
        acceptLanguage!.toHeaderString(),
      );
    }
    if (accessControlRequestHeaders != null) {
      headers.set(
        _accessControlRequestHeadersHeader,
        accessControlRequestHeaders!,
      );
    }
    if (accessControlRequestMethod != null) {
      headers.set(
        _accessControlRequestMethodHeader,
        accessControlRequestMethod!.toHeaderString(),
      );
    }
    if (age != null) headers.set(_ageHeader, age!);
    if (authorization != null) {
      headers.set(
        _authorizationHeader,
        authorization!.toHeaderString(),
      );
    }
    if (connection != null) {
      headers.set(
        _connectionHeader,
        connection!.toHeaderString(),
      );
    }
    if (expect != null) {
      headers.set(
        _expectHeader,
        expect!.toHeaderString(),
      );
    }
    if (ifMatch != null) {
      headers.set(
        _ifMatchHeader,
        ifMatch!.toHeaderString(),
      );
    }
    if (ifNoneMatch != null) {
      headers.set(
        _ifNoneMatchHeader,
        ifNoneMatch!.toHeaderString(),
      );
    }
    if (ifRange != null) {
      headers.set(
        _ifRangeHeader,
        ifRange!.toHeaderString(),
      );
    }
    if (maxForwards != null) {
      headers.set(_maxForwardsHeader, maxForwards!);
    }
    if (proxyAuthorization != null) {
      headers.set(
        _proxyAuthorizationHeader,
        proxyAuthorization!.toHeaderString(),
      );
    }
    if (range != null) {
      headers.set(_rangeHeader, range!.toHeaderString());
    }
    if (referer != null) {
      headers.set(_refererHeader, referer!.toString());
    }
    if (userAgent != null) {
      headers.set(_userAgentHeader, userAgent!);
    }
    if (te != null) {
      headers.set(_teHeader, te!.toHeaderString());
    }
    if (upgrade != null) {
      headers.set(
        _upgradeHeader,
        upgrade!.toHeaderString(),
      );
    }

    // Response Headers
    if (location != null) {
      headers.set(_locationHeader, location!.toString());
    }

    if (accessControlAllowCredentials != null) {
      headers.set(
        _accessControlAllowCredentialsHeader,
        accessControlAllowCredentials!,
      );
    }
    if (accessControlAllowOrigin != null) {
      headers.set(
        _accessControlAllowOriginHeader,
        accessControlAllowOrigin!.toHeaderString(),
      );
    }
    if (accessControlExposeHeaders != null) {
      headers.set(
        _accessControlExposeHeadersHeader,
        accessControlExposeHeaders!.toHeaderString(),
      );
    }
    if (accessControlMaxAge != null) {
      headers.set(
        _accessControlMaxAgeHeader,
        accessControlMaxAge!,
      );
    }
    if (allow != null) {
      headers.set(
        _allowHeader,
        allow!.map((m) => m.toHeaderString()).join(','),
      );
    }
    if (cacheControl != null) {
      headers.set(
        _cacheControlHeader,
        cacheControl!.toHeaderString(),
      );
    }
    if (contentEncoding != null) {
      headers.set(
        _contentEncodingHeader,
        contentEncoding!.toHeaderString(),
      );
    }
    if (contentLanguage != null) {
      headers.set(
        _contentLanguageHeader,
        contentLanguage!.toHeaderString(),
      );
    }
    if (contentLocation != null) {
      headers.set(
        _contentLocationHeader,
        contentLocation!.toString(),
      );
    }
    if (contentRange != null) {
      headers.set(
        _contentRangeHeader,
        contentRange!.toHeaderString(),
      );
    }
    if (etag != null) {
      headers.set(_etagHeader, etag!.toHeaderString());
    }
    if (proxyAuthenticate != null) {
      headers.set(
        _proxyAuthenticationHeader,
        proxyAuthenticate!.toHeaderString(),
      );
    }
    if (retryAfter != null) {
      headers.set(
        _retryAfterHeader,
        retryAfter!.toHeaderString(),
      );
    }
    if (trailer != null) {
      headers.set(_trailerHeader, trailer!);
    }
    if (transferEncoding != null) {
      headers.set(
        _transferEncodingHeader,
        transferEncoding!.toHeaderString(),
      );
    }
    if (vary != null) {
      headers.set(
        _varyHeader,
        vary!.toHeaderString(),
      );
    }
    if (wwwAuthenticate != null) {
      headers.set(
        _wwwAuthenticateHeader,
        wwwAuthenticate!.toHeaderString(),
      );
    }
    if (contentDisposition != null) {
      headers.set(
        _contentDispositionHeader,
        contentDisposition!.toHeaderString(),
      );
    }

    // Security and Modern Headers
    if (cookie != null) {
      headers.set(_cookieHeader, cookie!.toHeaderString());
    }
    if (setCookie != null) {
      headers.set(_setCookieHeader, setCookie!.toHeaderString());
    }
    if (strictTransportSecurity != null) {
      headers.set(
        _strictTransportSecurityHeader,
        strictTransportSecurity!.toHeaderString(),
      );
    }
    if (contentSecurityPolicy != null) {
      headers.set(
        _contentSecurityPolicyHeader,
        contentSecurityPolicy!.toHeaderString(),
      );
    }
    if (referrerPolicy != null) {
      headers.set(
        _referrerPolicyHeader,
        referrerPolicy!.toHeaderString(),
      );
    }
    if (permissionsPolicy != null) {
      headers.set(
        _permissionsPolicyHeader,
        permissionsPolicy!.toHeaderString(),
      );
    }
    if (accessControlAllowMethods != null) {
      headers.set(
        _accessControlAllowMethodsHeader,
        accessControlAllowMethods!.toHeaderString(),
      );
    }
    if (accessControlAllowHeaders != null) {
      headers.set(
        _accessControlAllowHeadersHeader,
        accessControlAllowHeaders!.toHeaderString(),
      );
    }
    if (clearSiteData != null) {
      headers.set(
        _clearSiteDataHeader,
        clearSiteData!.toHeaderString(),
      );
    }
    if (secFetchDest != null) {
      headers.set(
        _secFetchDestHeader,
        secFetchDest!.toHeaderString(),
      );
    }
    if (secFetchMode != null) {
      headers.set(
        _secFetchModeHeader,
        secFetchMode!.toHeaderString(),
      );
    }
    if (secFetchSite != null) {
      headers.set(
        _secFetchSiteHeader,
        secFetchSite!.toHeaderString(),
      );
    }
    if (crossOriginResourcePolicy != null) {
      headers.set(
        _crossOriginResourcePolicyHeader,
        crossOriginResourcePolicy!.toHeaderString(),
      );
    }
    if (crossOriginEmbedderPolicy != null) {
      headers.set(
        _crossOriginEmbedderPolicyHeader,
        crossOriginEmbedderPolicy!.toHeaderString(),
      );
    }
    if (crossOriginOpenerPolicy != null) {
      headers.set(
        _crossOriginOpenerPolicyHeader,
        crossOriginOpenerPolicy!.toHeaderString(),
      );
    }

    // Set custom headers
    for (var entry in custom.entries) {
      headers.set(entry.key, entry.value);
    }

    // Set the content length from the Body
    headers.contentLength = body.contentLength ?? 0;

    // Set the content type from the Body
    headers.contentType = body.getContentType();
  }

  Headers copyWith({
    /// Date-related headers
    DateTime? date,
    DateTime? expires,
    DateTime? ifModifiedSince,
    DateTime? lastModified,

    /// General Headers
    Uri? origin,
    String? server,
    List<String>? via,

    /// Request Headers
    FromHeader? from,
    Uri? host,
    AcceptEncodingHeader? acceptEncoding,
    AcceptLanguageHeader? acceptLanguage,
    List<String>? accessControlRequestHeaders,
    Method? accessControlRequestMethod,
    int? age,
    AuthorizationHeader? authorization,
    ConnectionHeader? connection,
    ExpectHeader? expect,
    IfMatchHeader? ifMatch,
    IfNoneMatchHeader? ifNoneMatch,
    IfRangeHeader? ifRange,
    int? maxForwards,
    AuthorizationHeader? proxyAuthorization,
    RangeHeader? range,
    Uri? referer,
    String? userAgent,
    TEHeader? te,
    UpgradeHeader? upgrade,

    /// Response Headers
    Uri? location,
    String? xPoweredBy,
    bool? accessControlAllowCredentials,
    AccessControlAllowOriginHeader? accessControlAllowOrigin,
    AccessControlExposeHeadersHeader? accessControlExposeHeaders,
    int? accessControlMaxAge,
    List<Method>? allow,
    CacheControlHeader? cacheControl,
    ContentEncodingHeader? contentEncoding,
    ContentLanguageHeader? contentLanguage,
    Uri? contentLocation,
    ContentRangeHeader? contentRange,
    ETagHeader? etag,
    AuthenticationHeader? proxyAuthenticate,
    RetryAfterHeader? retryAfter,
    List<String>? trailer,
    VaryHeader? vary,
    List<String>? wwwAuthenticate,
    ContentDispositionHeader? contentDisposition,

    /// Common Headers (Used in Both Requests and Responses)
    AcceptHeader? accept,
    AcceptRangesHeader? acceptRanges,
    TransferEncodingHeader? transferEncoding,
    CookieHeader? cookie,
    CookieHeader? setCookie,
    CustomHeaders? custom,

    /// Security and Modern Headers
    StrictTransportSecurityHeader? strictTransportSecurity,
    ContentSecurityPolicyHeader? contentSecurityPolicy,
    ReferrerPolicyHeader? referrerPolicy,
    PermissionsPolicyHeader? permissionsPolicy,
    AccessControlAllowMethodsHeader? accessControlAllowMethods,
    AccessControlAllowHeadersHeader? accessControlAllowHeaders,
    ClearSiteDataHeader? clearSiteData,
    SecFetchDestHeader? secFetchDest,
    SecFetchModeHeader? secFetchMode,
    SecFetchSiteHeader? secFetchSite,
    CrossOriginResourcePolicyHeader? crossOriginResourcePolicy,
    CrossOriginEmbedderPolicyHeader? crossOriginEmbedderPolicy,
    CrossOriginOpenerPolicyHeader? crossOriginOpenerPolicy,
  });

  Map<String, Object> toMap() {
    return {
      /// Date-related headers
      if (date != null) _dateHeader: '$date',
      if (expires != null) _expiresHeader: '$expires',
      if (ifModifiedSince != null) _ifModifiedSinceHeader: '$ifModifiedSince',
      if (lastModified != null) _lastModifiedHeader: '$lastModified',

      /// General Headers
      if (origin != null) _originHeader: origin!.toString(),
      if (server != null) _serverHeader: server!,
      if (via != null) _viaHeader: via!,
      if (cookie != null) _cookieHeader: cookie!.toHeaderString(),
      if (setCookie != null) _setCookieHeader: setCookie!.toHeaderString(),

      /// Request Headers
      if (from != null) _fromHeader: from!.toHeaderString(),
      if (host != null) _hostHeader: host!,
      if (acceptEncoding != null)
        _acceptEncodingHeader: acceptEncoding!.toHeaderString(),
      if (acceptLanguage != null)
        _acceptLanguageHeader: acceptLanguage!.toHeaderString(),
      if (accessControlRequestHeaders != null)
        _accessControlRequestHeadersHeader: accessControlRequestHeaders!,
      if (accessControlRequestMethod != null)
        _accessControlRequestMethodHeader:
            accessControlRequestMethod!.toHeaderString(),
      if (age != null) _ageHeader: age!,
      if (authorization != null)
        _authorizationHeader: authorization!.toHeaderString(),
      if (connection != null) _connectionHeader: connection!.toHeaderString(),
      if (expect != null) _expectHeader: expect!.toHeaderString(),
      if (ifMatch != null) _ifMatchHeader: ifMatch!.toHeaderString(),
      if (ifNoneMatch != null)
        _ifNoneMatchHeader: ifNoneMatch!.toHeaderString(),
      if (ifRange != null) _ifRangeHeader: ifRange!.toHeaderString(),
      if (maxForwards != null) _maxForwardsHeader: maxForwards!,
      if (proxyAuthorization != null)
        _proxyAuthorizationHeader: proxyAuthorization!.toHeaderString(),
      if (range != null) _rangeHeader: range!.toHeaderString(),
      if (referer != null) _refererHeader: referer!.toString(),
      if (userAgent != null) _userAgentHeader: userAgent!,
      if (te != null) _teHeader: te!.toHeaderString(),
      if (upgrade != null) _upgradeHeader: upgrade!.toHeaderString(),

      /// Response Headers
      if (location != null) _locationHeader: location!.toString(),
      if (xPoweredBy != null) _xPoweredByHeader: xPoweredBy!,
      if (accessControlAllowCredentials != null)
        _accessControlAllowCredentialsHeader: accessControlAllowCredentials!,
      if (accessControlAllowOrigin != null)
        _accessControlAllowOriginHeader:
            accessControlAllowOrigin!.toHeaderString(),
      if (accessControlExposeHeaders != null)
        _accessControlExposeHeadersHeader:
            accessControlExposeHeaders!.toHeaderString(),
      if (accessControlMaxAge != null)
        _accessControlMaxAgeHeader: accessControlMaxAge!,
      if (allow != null) _allowHeader: allow!.map((m) => m.toHeaderString()),
      if (cacheControl != null) _cacheControlHeader: cacheControl!,
      if (contentEncoding != null)
        _contentEncodingHeader: contentEncoding!.toHeaderString(),
      if (contentLanguage != null)
        _contentLanguageHeader: contentLanguage!.toHeaderString(),
      if (contentLocation != null)
        _contentLocationHeader: contentLocation!.toString(),
      if (contentRange != null)
        _contentRangeHeader: contentRange!.toHeaderString(),
      if (etag != null) _etagHeader: etag!.toHeaderString(),
      if (proxyAuthenticate != null)
        _proxyAuthenticationHeader: proxyAuthenticate!.toHeaderString(),
      if (retryAfter != null) _retryAfterHeader: retryAfter!.toHeaderString(),
      if (trailer != null) _trailerHeader: trailer!,
      if (vary != null) _varyHeader: vary!.toHeaderString(),
      if (wwwAuthenticate != null)
        _wwwAuthenticateHeader: wwwAuthenticate!.toHeaderString(),
      if (contentDisposition != null)
        _contentDispositionHeader: contentDisposition!.toHeaderString(),

      /// Security and Modern Headers
      if (strictTransportSecurity != null)
        _strictTransportSecurityHeader:
            strictTransportSecurity!.toHeaderString(),
      if (contentSecurityPolicy != null)
        _contentSecurityPolicyHeader: contentSecurityPolicy!.toHeaderString(),
      if (referrerPolicy != null) _referrerPolicyHeader: referrerPolicy!,
      if (permissionsPolicy != null)
        _permissionsPolicyHeader: permissionsPolicy!.toHeaderString(),
      if (accessControlAllowMethods != null)
        _accessControlAllowMethodsHeader:
            accessControlAllowMethods!.toHeaderString(),
      if (accessControlAllowHeaders != null)
        _accessControlAllowHeadersHeader:
            accessControlAllowHeaders!.toHeaderString(),
      if (clearSiteData != null)
        _clearSiteDataHeader: clearSiteData!.toHeaderString(),
      if (secFetchDest != null)
        _secFetchDestHeader: secFetchDest!.toHeaderString(),
      if (secFetchMode != null)
        _secFetchModeHeader: secFetchMode!.toHeaderString(),
      if (secFetchSite != null)
        _secFetchSiteHeader: secFetchSite!.toHeaderString(),
      if (crossOriginResourcePolicy != null)
        _crossOriginResourcePolicyHeader:
            crossOriginResourcePolicy!.toHeaderString(),
      if (crossOriginEmbedderPolicy != null)
        _crossOriginEmbedderPolicyHeader:
            crossOriginEmbedderPolicy!.toHeaderString(),
      if (crossOriginOpenerPolicy != null)
        _crossOriginOpenerPolicyHeader:
            crossOriginOpenerPolicy!.toHeaderString(),

      // Custom headers
      ...custom,
    };
  }
}

class _HeadersImpl extends Headers {
  _HeadersImpl({
    /// Date-related headers
    super.date,
    super.expires,
    super.ifModifiedSince,
    super.lastModified,

    /// General Headers
    super.origin,
    super.server,
    super.via,

    /// Request Headers
    super.from,
    super.host,
    super.acceptEncoding,
    super.acceptLanguage,
    super.accessControlRequestHeaders,
    super.accessControlRequestMethod,
    super.age,
    super.authorization,
    super.connection,
    super.expect,
    super.ifMatch,
    super.ifNoneMatch,
    super.ifRange,
    super.maxForwards,
    super.proxyAuthorization,
    super.range,
    super.referer,
    super.userAgent,
    super.te,
    super.upgrade,

    /// Response Headers
    super.location,
    super.xPoweredBy,
    super.accessControlAllowCredentials,
    super.accessControlAllowOrigin,
    super.accessControlExposeHeaders,
    super.accessControlMaxAge,
    super.allow,
    super.cacheControl,
    super.contentEncoding,
    super.contentLanguage,
    super.contentLocation,
    super.contentRange,
    super.etag,
    super.proxyAuthenticate,
    super.retryAfter,
    super.trailer,
    super.vary,
    super.wwwAuthenticate,
    super.contentDisposition,

    /// Common Headers (Used in Both Requests and Responses)
    super.accept,
    super.acceptRanges,
    super.transferEncoding,
    super.cookie,
    super.setCookie,
    super.custom,

    /// Security and Modern Headers
    super.strictTransportSecurity,
    super.contentSecurityPolicy,
    super.referrerPolicy,
    super.permissionsPolicy,
    super.accessControlAllowMethods,
    super.accessControlAllowHeaders,
    super.clearSiteData,
    super.secFetchDest,
    super.secFetchMode,
    super.secFetchSite,
    super.crossOriginResourcePolicy,
    super.crossOriginEmbedderPolicy,
    super.crossOriginOpenerPolicy,
    required super.failedHeadersToParse,
  }) : super._();

  @override
  Headers copyWith({
    Object? date = _Undefined,
    Object? expires = _Undefined,
    Object? ifModifiedSince = _Undefined,
    Object? lastModified = _Undefined,

    /// General Headers
    Object? origin = _Undefined,
    Object? server = _Undefined,
    Object? via = _Undefined,

    /// Request Headers
    Object? from = _Undefined,
    Object? host = _Undefined,
    Object? acceptEncoding = _Undefined,
    Object? acceptLanguage = _Undefined,
    Object? accessControlRequestHeaders = _Undefined,
    Object? accessControlRequestMethod = _Undefined,
    Object? age = _Undefined,
    Object? authorization = _Undefined,
    Object? connection = _Undefined,
    Object? expect = _Undefined,
    Object? ifMatch = _Undefined,
    Object? ifNoneMatch = _Undefined,
    Object? ifRange = _Undefined,
    Object? maxForwards = _Undefined,
    Object? proxyAuthorization = _Undefined,
    Object? range = _Undefined,
    Object? referer = _Undefined,
    Object? userAgent = _Undefined,
    Object? te = _Undefined,
    Object? upgrade = _Undefined,

    /// Response Headers
    Object? location = _Undefined,
    Object? xPoweredBy = _Undefined,
    Object? accessControlAllowCredentials = _Undefined,
    Object? accessControlAllowOrigin = _Undefined,
    Object? accessControlExposeHeaders = _Undefined,
    Object? accessControlMaxAge = _Undefined,
    Object? allow = _Undefined,
    Object? cacheControl = _Undefined,
    Object? contentEncoding = _Undefined,
    Object? contentLanguage = _Undefined,
    Object? contentLocation = _Undefined,
    Object? contentRange = _Undefined,
    Object? etag = _Undefined,
    Object? proxyAuthenticate = _Undefined,
    Object? retryAfter = _Undefined,
    Object? trailer = _Undefined,
    Object? vary = _Undefined,
    Object? wwwAuthenticate = _Undefined,
    Object? contentDisposition = _Undefined,

    /// Common Headers (Used in Both Requests and Responses)
    Object? accept = _Undefined,
    Object? acceptRanges = _Undefined,
    Object? transferEncoding = _Undefined,
    Object? cookie = _Undefined,
    Object? setCookie = _Undefined,
    CustomHeaders? custom,

    /// Security and Modern Headers
    Object? strictTransportSecurity = _Undefined,
    Object? contentSecurityPolicy = _Undefined,
    Object? referrerPolicy = _Undefined,
    Object? permissionsPolicy = _Undefined,
    Object? accessControlAllowMethods = _Undefined,
    Object? accessControlAllowHeaders = _Undefined,
    Object? clearSiteData = _Undefined,
    Object? secFetchDest = _Undefined,
    Object? secFetchMode = _Undefined,
    Object? secFetchSite = _Undefined,
    Object? crossOriginResourcePolicy = _Undefined,
    Object? crossOriginEmbedderPolicy = _Undefined,
    Object? crossOriginOpenerPolicy = _Undefined,
  }) {
    return _HeadersImpl(
      date: date is DateTime? ? date : this.date,
      expires: expires is DateTime? ? expires : this.expires,
      ifModifiedSince:
          ifModifiedSince is DateTime? ? ifModifiedSince : this.ifModifiedSince,
      lastModified:
          lastModified is DateTime? ? lastModified : this.lastModified,

      /// General Headers
      origin: origin is Uri? ? origin : this.origin,
      server: server is String? ? server : this.server,
      via: via is List<String>? ? via : this.via,

      /// Request Headers
      from: from is FromHeader? ? from : this.from,
      host: host is Uri? ? host : this.host,
      acceptEncoding: acceptEncoding is AcceptEncodingHeader?
          ? acceptEncoding
          : this.acceptEncoding,
      acceptLanguage: acceptLanguage is AcceptLanguageHeader?
          ? acceptLanguage
          : this.acceptLanguage,
      accessControlRequestHeaders: accessControlRequestHeaders is List<String>?
          ? accessControlRequestHeaders
          : this.accessControlRequestHeaders,
      accessControlRequestMethod: accessControlRequestMethod is Method?
          ? accessControlRequestMethod
          : this.accessControlRequestMethod,
      age: age is int? ? age : this.age,
      authorization: authorization is AuthorizationHeader?
          ? authorization
          : this.authorization,
      connection:
          connection is ConnectionHeader? ? connection : this.connection,
      expect: expect is ExpectHeader? ? expect : this.expect,
      ifMatch: ifMatch is IfMatchHeader? ? ifMatch : this.ifMatch,
      ifNoneMatch:
          ifNoneMatch is IfNoneMatchHeader? ? ifNoneMatch : this.ifNoneMatch,
      ifRange: ifRange is IfRangeHeader? ? ifRange : this.ifRange,
      maxForwards: maxForwards is int? ? maxForwards : this.maxForwards,
      proxyAuthorization: proxyAuthorization is AuthorizationHeader?
          ? proxyAuthorization
          : this.proxyAuthorization,
      range: range is RangeHeader? ? range : this.range,
      referer: referer is Uri? ? referer : this.referer,
      userAgent: userAgent is String? ? userAgent : this.userAgent,
      te: te is TEHeader? ? te : this.te,
      upgrade: upgrade is UpgradeHeader? ? upgrade : this.upgrade,

      /// Response Headers
      location: location is Uri? ? location : this.location,
      xPoweredBy: xPoweredBy is String? ? xPoweredBy : this.xPoweredBy,
      accessControlAllowCredentials: accessControlAllowCredentials is bool?
          ? accessControlAllowCredentials
          : this.accessControlAllowCredentials,
      accessControlAllowOrigin:
          accessControlAllowOrigin is AccessControlAllowOriginHeader?
              ? accessControlAllowOrigin
              : this.accessControlAllowOrigin,
      accessControlExposeHeaders:
          accessControlExposeHeaders is AccessControlExposeHeadersHeader?
              ? accessControlExposeHeaders
              : this.accessControlExposeHeaders,
      accessControlMaxAge: accessControlMaxAge is int?
          ? accessControlMaxAge
          : this.accessControlMaxAge,
      allow: allow is List<Method>? ? allow : this.allow,
      cacheControl: cacheControl is CacheControlHeader?
          ? cacheControl
          : this.cacheControl,
      contentEncoding: contentEncoding is ContentEncodingHeader?
          ? contentEncoding
          : this.contentEncoding,
      contentLanguage: contentLanguage is ContentLanguageHeader?
          ? contentLanguage
          : this.contentLanguage,
      contentLocation:
          contentLocation is Uri? ? contentLocation : this.contentLocation,
      contentRange: contentRange is ContentRangeHeader?
          ? contentRange
          : this.contentRange,
      etag: etag is ETagHeader? ? etag : this.etag,
      proxyAuthenticate: proxyAuthenticate is AuthenticationHeader?
          ? proxyAuthenticate
          : this.proxyAuthenticate,
      retryAfter:
          retryAfter is RetryAfterHeader? ? retryAfter : this.retryAfter,
      trailer: trailer is List<String>? ? trailer : this.trailer,
      vary: vary is VaryHeader? ? vary : this.vary,
      wwwAuthenticate: wwwAuthenticate is AuthenticationHeader?
          ? wwwAuthenticate
          : this.wwwAuthenticate,
      contentDisposition: contentDisposition is ContentDispositionHeader?
          ? contentDisposition
          : this.contentDisposition,

      /// Common Headers (Used in Both Requests and Responses)
      accept: accept is AcceptHeader? ? accept : this.accept,
      acceptRanges: acceptRanges is AcceptRangesHeader?
          ? acceptRanges
          : this.acceptRanges,
      transferEncoding: transferEncoding is TransferEncodingHeader?
          ? transferEncoding
          : this.transferEncoding,
      cookie: cookie is CookieHeader? ? cookie : this.cookie,
      setCookie: setCookie is CookieHeader? ? setCookie : this.setCookie,
      custom: custom ?? this.custom,

      /// Security and Modern Headers
      strictTransportSecurity:
          strictTransportSecurity is StrictTransportSecurityHeader?
              ? strictTransportSecurity
              : this.strictTransportSecurity,
      contentSecurityPolicy:
          contentSecurityPolicy is ContentSecurityPolicyHeader?
              ? contentSecurityPolicy
              : this.contentSecurityPolicy,
      referrerPolicy: referrerPolicy is ReferrerPolicyHeader?
          ? referrerPolicy
          : this.referrerPolicy,
      permissionsPolicy: permissionsPolicy is PermissionsPolicyHeader?
          ? permissionsPolicy
          : this.permissionsPolicy,
      accessControlAllowMethods:
          accessControlAllowMethods is AccessControlAllowMethodsHeader?
              ? accessControlAllowMethods
              : this.accessControlAllowMethods,
      accessControlAllowHeaders:
          accessControlAllowHeaders is AccessControlAllowHeadersHeader?
              ? accessControlAllowHeaders
              : this.accessControlAllowHeaders,
      clearSiteData: clearSiteData is ClearSiteDataHeader?
          ? clearSiteData
          : this.clearSiteData,
      secFetchDest: secFetchDest is SecFetchDestHeader?
          ? secFetchDest
          : this.secFetchDest,
      secFetchMode: secFetchMode is SecFetchModeHeader?
          ? secFetchMode
          : this.secFetchMode,
      secFetchSite: secFetchSite is SecFetchSiteHeader?
          ? secFetchSite
          : this.secFetchSite,
      crossOriginResourcePolicy:
          crossOriginResourcePolicy is CrossOriginResourcePolicyHeader?
              ? crossOriginResourcePolicy
              : this.crossOriginResourcePolicy,
      crossOriginEmbedderPolicy:
          crossOriginEmbedderPolicy is CrossOriginEmbedderPolicyHeader?
              ? crossOriginEmbedderPolicy
              : this.crossOriginEmbedderPolicy,
      crossOriginOpenerPolicy:
          crossOriginOpenerPolicy is CrossOriginOpenerPolicyHeader?
              ? crossOriginOpenerPolicy
              : this.crossOriginOpenerPolicy,
      failedHeadersToParse: failedHeadersToParse,
    );
  }
}

class _Undefined {}
