import 'dart:io' as io;

import 'package:http_parser/http_parser.dart';
import 'package:relic/src/headers/custom/custom_headers.dart';
import 'package:relic/src/headers/extension/string_list_extensions.dart';
import 'package:relic/src/headers/parser/headers_parser.dart';
import 'package:relic/src/headers/parser/common_types_parser.dart';
import 'package:relic/src/headers/typed/typed_header_interface.dart';
import 'package:relic/src/method/request_method.dart';

import 'typed/typed_headers.dart';

import '../body/body.dart';

abstract base class Headers {
  /// Request Headers
  static const acceptHeader = "accept";
  static const acceptEncodingHeader = "accept-encoding";
  static const acceptLanguageHeader = "accept-language";
  static const authorizationHeader = "authorization";
  static const expectHeader = "expect";
  static const fromHeader = "from";
  static const hostHeader = "host";
  static const ifMatchHeader = "if-match";
  static const ifModifiedSinceHeader = "if-modified-since";
  static const ifNoneMatchHeader = "if-none-match";
  static const ifRangeHeader = "if-range";
  static const ifUnmodifiedSinceHeader = "if-unmodified-since";
  static const maxForwardsHeader = "max-forwards";
  static const proxyAuthorizationHeader = "proxy-authorization";
  static const rangeHeader = "range";
  static const teHeader = "te";
  static const upgradeHeader = "upgrade";
  static const userAgentHeader = "user-agent";
  static const accessControlRequestHeadersHeader =
      'access-control-request-headers';
  static const accessControlRequestMethodHeader =
      'access-control-request-method';

  /// Response Headers
  static const accessControlAllowCredentialsHeader =
      'access-control-allow-credentials';
  static const accessControlAllowOriginHeader = 'access-control-allow-origin';
  static const accessControlExposeHeadersHeader =
      'access-control-expose-headers';
  static const accessControlMaxAgeHeader = 'access-control-max-age';
  static const ageHeader = "age";
  static const allowHeader = "allow";
  static const cacheControlHeader = "cache-control";
  static const connectionHeader = "connection";
  static const contentDispositionHeader = "content-disposition";
  static const contentEncodingHeader = "content-encoding";
  static const contentLanguageHeader = "content-language";
  static const contentLocationHeader = "content-location";
  static const contentRangeHeader = "content-range";
  static const etagHeader = "etag";
  static const expiresHeader = "expires";
  static const lastModifiedHeader = "last-modified";
  static const locationHeader = "location";
  static const proxyAuthenticationHeader = "proxy-authenticate";
  static const retryAfterHeader = "retry-after";
  static const trailerHeader = "trailer";
  static const transferEncodingHeader = "transfer-encoding";
  static const varyHeader = "vary";
  static const wwwAuthenticateHeader = "www-authenticate";
  static const xPoweredByHeader = 'x-powered-by';

  /// Common Headers (Used in Both Requests and Responses)
  static const acceptRangesHeader = "accept-ranges";
  static const contentLengthHeader = "content-length";
  static const contentTypeHeader = "content-type";

  /// General Headers
  static const dateHeader = "date";
  static const originHeader = "origin";
  static const refererHeader = "referer";
  static const serverHeader = "server";
  static const viaHeader = "via";
  static const cookieHeader = "cookie";
  static const setCookieHeader = "set-cookie";

  /// Security and Modern Headers
  static const strictTransportSecurityHeader = "strict-transport-security";
  static const contentSecurityPolicyHeader = "content-security-policy";
  static const referrerPolicyHeader = "referrer-policy";
  static const permissionsPolicyHeader = "permissions-policy";
  static const accessControlAllowMethodsHeader = "access-control-allow-methods";
  static const accessControlAllowHeadersHeader = "access-control-allow-headers";
  static const clearSiteDataHeader = "clear-site-data";
  static const secFetchDestHeader = "sec-fetch-dest";
  static const secFetchModeHeader = "sec-fetch-mode";
  static const secFetchSiteHeader = "sec-fetch-site";
  static const crossOriginResourcePolicyHeader = "cross-origin-resource-policy";
  static const crossOriginEmbedderPolicyHeader = "cross-origin-embedder-policy";
  static const crossOriginOpenerPolicyHeader = "cross-origin-opener-policy";

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
  final RequestMethod? accessControlRequestMethod;
  final int? age;
  final List<RequestMethod>? allow;
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
  final SetCookieHeader? setCookie;

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

  /// Failed headers to parse
  /// When 'strict' flag is disabled, we save the failed headers to parse
  final Map<String, List<String>> failedHeadersToParse;

  /// Managed headers
  /// Headers that are managed by the library
  static const _managedHeaders = <String>{
    dateHeader,
    expiresHeader,
    ifModifiedSinceHeader,
    ifUnmodifiedSinceHeader,
    lastModifiedHeader,

    // General Headers
    originHeader,
    serverHeader,
    viaHeader,

    // Request Headers
    acceptEncodingHeader,
    acceptLanguageHeader,
    accessControlRequestHeadersHeader,
    accessControlRequestMethodHeader,
    ageHeader,
    allowHeader,
    authorizationHeader,
    connectionHeader,
    expectHeader,
    fromHeader,
    hostHeader,
    ifMatchHeader,
    ifNoneMatchHeader,
    ifRangeHeader,
    maxForwardsHeader,
    proxyAuthorizationHeader,
    rangeHeader,
    refererHeader,
    teHeader,
    upgradeHeader,
    userAgentHeader,

    // Response Headers
    accessControlAllowCredentialsHeader,
    accessControlAllowOriginHeader,
    accessControlExposeHeadersHeader,
    accessControlMaxAgeHeader,
    cacheControlHeader,
    contentDispositionHeader,
    contentEncodingHeader,
    contentLanguageHeader,
    contentLocationHeader,
    contentRangeHeader,
    etagHeader,
    locationHeader,
    proxyAuthenticationHeader,
    retryAfterHeader,
    trailerHeader,
    transferEncodingHeader,
    varyHeader,
    wwwAuthenticateHeader,
    xPoweredByHeader,

    // Common Headers (Used in Both Requests and Responses)
    acceptHeader,
    acceptRangesHeader,
    contentLengthHeader,
    contentTypeHeader,
    cookieHeader,
    setCookieHeader,

    // Security and Modern Headers
    accessControlAllowHeadersHeader,
    accessControlAllowMethodsHeader,
    clearSiteDataHeader,
    contentSecurityPolicyHeader,
    crossOriginEmbedderPolicyHeader,
    crossOriginOpenerPolicyHeader,
    crossOriginResourcePolicyHeader,
    permissionsPolicyHeader,
    referrerPolicyHeader,
    secFetchDestHeader,
    secFetchModeHeader,
    secFetchSiteHeader,
    strictTransportSecurityHeader,
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

  /// Create a new request headers instance from a Dart IO request
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
      date: dartIOHeaders.parseSingleValue(
        dateHeader,
        onParse: parseDate,
      ),
      expires: dartIOHeaders.parseSingleValue(
        expiresHeader,
        onParse: parseDate,
      ),
      ifModifiedSince: dartIOHeaders.parseSingleValue(
        ifModifiedSinceHeader,
        onParse: parseDate,
      ),
      lastModified: dartIOHeaders.parseSingleValue(
        lastModifiedHeader,
        onParse: parseDate,
      ),

      // General Headers
      origin: dartIOHeaders.parseSingleValue(
        originHeader,
        onParse: parseUri,
      ),
      server: dartIOHeaders.parseSingleValue(
        serverHeader,
        onParse: parseString,
      ),
      via: dartIOHeaders.parseMultipleValue(
        viaHeader,
        onParse: parseStringList,
      ),

      // Request Headers
      from: dartIOHeaders.parseMultipleValue(
        fromHeader,
        onParse: FromHeader.parse,
      ),
      host: dartIOHeaders.parseSingleValue(
        hostHeader,
        onParse: parseUri,
      ),
      acceptEncoding: dartIOHeaders.parseMultipleValue(
        acceptEncodingHeader,
        onParse: AcceptEncodingHeader.parse,
      ),
      acceptLanguage: dartIOHeaders.parseMultipleValue(
        acceptLanguageHeader,
        onParse: AcceptLanguageHeader.parse,
      ),
      accessControlRequestHeaders: dartIOHeaders.parseMultipleValue(
        accessControlRequestHeadersHeader,
        onParse: parseStringList,
      ),
      accessControlRequestMethod: dartIOHeaders.parseSingleValue(
        accessControlRequestMethodHeader,
        onParse: RequestMethod.parse,
      ),
      age: dartIOHeaders.parseSingleValue(
        ageHeader,
        onParse: parsePositiveInt,
      ),
      allow: dartIOHeaders.parseMultipleValue(
        allowHeader,
        onParse: parseMethodList,
      ),
      cookie: dartIOHeaders.parseSingleValue(
        cookieHeader,
        onParse: CookieHeader.parse,
      ),
      setCookie: dartIOHeaders.parseSingleValue(
        setCookieHeader,
        onParse: SetCookieHeader.parse,
      ),
      authorization: dartIOHeaders.parseSingleValue(
        authorizationHeader,
        onParse: AuthorizationHeader.parse,
      ),
      connection: dartIOHeaders.parseMultipleValue(
        connectionHeader,
        onParse: ConnectionHeader.parse,
      ),
      expect: dartIOHeaders.parseSingleValue(
        expectHeader,
        onParse: ExpectHeader.parse,
      ),
      ifMatch: dartIOHeaders.parseMultipleValue(
        ifMatchHeader,
        onParse: IfMatchHeader.parse,
      ),
      ifNoneMatch: dartIOHeaders.parseMultipleValue(
        ifNoneMatchHeader,
        onParse: IfNoneMatchHeader.parse,
      ),
      ifRange: dartIOHeaders.parseSingleValue(
        ifRangeHeader,
        onParse: IfRangeHeader.parse,
      ),
      maxForwards: dartIOHeaders.parseSingleValue(
        maxForwardsHeader,
        onParse: parsePositiveInt,
      ),
      proxyAuthorization: dartIOHeaders.parseSingleValue(
        proxyAuthorizationHeader,
        onParse: AuthorizationHeader.parse,
      ),
      range: dartIOHeaders.parseSingleValue(
        rangeHeader,
        onParse: RangeHeader.parse,
      ),
      referer: dartIOHeaders.parseSingleValue(
        refererHeader,
        onParse: parseUri,
      ),
      te: dartIOHeaders.parseMultipleValue(
        teHeader,
        onParse: TEHeader.parse,
      ),
      upgrade: dartIOHeaders.parseMultipleValue(
        upgradeHeader,
        onParse: UpgradeHeader.parse,
      ),
      userAgent: dartIOHeaders.parseSingleValue(
        userAgentHeader,
        onParse: parseString,
      ),

      // Response Headers
      location: dartIOHeaders.parseSingleValue(
        locationHeader,
        onParse: parseUri,
      ),
      xPoweredBy: dartIOHeaders.parseSingleValue(
            xPoweredByHeader,
            onParse: parseString,
          ) ??
          xPoweredBy,
      accessControlAllowCredentials: dartIOHeaders.parseSingleValue(
        accessControlAllowCredentialsHeader,
        onParse: parsePositiveBool,
      ),
      accessControlAllowOrigin: dartIOHeaders.parseSingleValue(
        accessControlAllowOriginHeader,
        onParse: AccessControlAllowOriginHeader.parse,
      ),
      accessControlExposeHeaders: dartIOHeaders.parseMultipleValue(
        accessControlExposeHeadersHeader,
        onParse: AccessControlExposeHeadersHeader.parse,
      ),
      accessControlMaxAge: dartIOHeaders.parseSingleValue(
        accessControlMaxAgeHeader,
        onParse: parseInt,
      ),
      cacheControl: dartIOHeaders.parseMultipleValue(
        cacheControlHeader,
        onParse: CacheControlHeader.parse,
      ),
      contentDisposition: dartIOHeaders.parseSingleValue(
        contentDispositionHeader,
        onParse: ContentDispositionHeader.parse,
      ),
      contentEncoding: dartIOHeaders.parseMultipleValue(
        contentEncodingHeader,
        onParse: ContentEncodingHeader.parse,
      ),
      contentLanguage: dartIOHeaders.parseMultipleValue(
        contentLanguageHeader,
        onParse: ContentLanguageHeader.parse,
      ),
      contentLocation: dartIOHeaders.parseSingleValue(
        contentLocationHeader,
        onParse: parseUri,
      ),
      contentRange: dartIOHeaders.parseSingleValue(
        contentRangeHeader,
        onParse: ContentRangeHeader.parse,
      ),
      etag: dartIOHeaders.parseSingleValue(
        etagHeader,
        onParse: ETagHeader.parse,
      ),
      proxyAuthenticate: dartIOHeaders.parseSingleValue(
        proxyAuthenticationHeader,
        onParse: AuthenticationHeader.parse,
      ),
      retryAfter: dartIOHeaders.parseSingleValue(
        retryAfterHeader,
        onParse: RetryAfterHeader.parse,
      ),
      trailer: dartIOHeaders.parseMultipleValue(
        trailerHeader,
        onParse: parseStringList,
      ),
      transferEncoding: dartIOHeaders.parseMultipleValue(
        transferEncodingHeader,
        onParse: TransferEncodingHeader.parse,
      ),
      vary: dartIOHeaders.parseMultipleValue(
        varyHeader,
        onParse: VaryHeader.parse,
      ),
      wwwAuthenticate: dartIOHeaders.parseSingleValue(
        wwwAuthenticateHeader,
        onParse: AuthenticationHeader.parse,
      ),

      // Common Headers (Used in Both Requests and Responses)
      accept: dartIOHeaders.parseMultipleValue(
        acceptHeader,
        onParse: AcceptHeader.parse,
      ),
      acceptRanges: dartIOHeaders.parseSingleValue(
        acceptRangesHeader,
        onParse: AcceptRangesHeader.parse,
      ),

      // Security and Modern Headers
      strictTransportSecurity: dartIOHeaders.parseSingleValue(
        strictTransportSecurityHeader,
        onParse: StrictTransportSecurityHeader.parse,
      ),
      contentSecurityPolicy: dartIOHeaders.parseSingleValue(
        contentSecurityPolicyHeader,
        onParse: ContentSecurityPolicyHeader.parse,
      ),
      referrerPolicy: dartIOHeaders.parseSingleValue(
        referrerPolicyHeader,
        onParse: ReferrerPolicyHeader.parse,
      ),
      permissionsPolicy: dartIOHeaders.parseSingleValue(
        permissionsPolicyHeader,
        onParse: PermissionsPolicyHeader.parse,
      ),
      accessControlAllowMethods: dartIOHeaders.parseMultipleValue(
        accessControlAllowMethodsHeader,
        onParse: AccessControlAllowMethodsHeader.parse,
      ),
      accessControlAllowHeaders: dartIOHeaders.parseMultipleValue(
        accessControlAllowHeadersHeader,
        onParse: AccessControlAllowHeadersHeader.parse,
      ),
      clearSiteData: dartIOHeaders.parseMultipleValue(
        clearSiteDataHeader,
        onParse: ClearSiteDataHeader.parse,
      ),
      secFetchDest: dartIOHeaders.parseSingleValue(
        secFetchDestHeader,
        onParse: SecFetchDestHeader.parse,
      ),
      secFetchMode: dartIOHeaders.parseSingleValue(
        secFetchModeHeader,
        onParse: SecFetchModeHeader.parse,
      ),
      secFetchSite: dartIOHeaders.parseSingleValue(
        secFetchSiteHeader,
        onParse: SecFetchSiteHeader.parse,
      ),
      crossOriginResourcePolicy: dartIOHeaders.parseSingleValue(
        crossOriginResourcePolicyHeader,
        onParse: CrossOriginResourcePolicyHeader.parse,
      ),
      crossOriginEmbedderPolicy: dartIOHeaders.parseSingleValue(
        crossOriginEmbedderPolicyHeader,
        onParse: CrossOriginEmbedderPolicyHeader.parse,
      ),
      crossOriginOpenerPolicy: dartIOHeaders.parseSingleValue(
        crossOriginOpenerPolicyHeader,
        onParse: CrossOriginOpenerPolicyHeader.parse,
      ),
      custom: parseCustomHeaders(
        dartIOHeaders.headers,
        excludedHeaders: _managedHeaders,
      ),

      failedHeadersToParse: failedHeadersToParse,
    );
  }

  /// Create a new request headers instance
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
    RequestMethod? accessControlRequestMethod,
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
    List<RequestMethod>? allow,
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
    SetCookieHeader? setCookie,
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
    RequestMethod? accessControlRequestMethod,
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
    List<RequestMethod>? allow,
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

  /// Apply headers to the response
  void applyHeaders(io.HttpResponse response, Body body);

  /// Convert headers to a map
  Map<String, Object> toMap();
}

/// Headers implementation
final class _HeadersImpl extends Headers {
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
      accessControlRequestMethod: accessControlRequestMethod is RequestMethod?
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
      allow: allow is List<RequestMethod>? ? allow : this.allow,
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
      setCookie: setCookie is SetCookieHeader? ? setCookie : this.setCookie,
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

  /// Apply headers to the response
  @override
  void applyHeaders(
    io.HttpResponse response,
    Body body,
  ) {
    var headers = response.headers;
    headers.clear();

    // Date-related headers
    var dateHeaders = _dateHeadersMap;
    for (var entry in dateHeaders.entries) {
      var key = entry.key;
      var value = entry.value;
      if (value != null) {
        headers.set(key, formatHttpDate(value));
      }
    }

    // Number-related headers
    var numberHeaders = _numberHeadersMap;
    for (var entry in numberHeaders.entries) {
      var key = entry.key;
      var value = entry.value;
      if (value != null) {
        headers.set(key, value);
      }
    }

    // String-related headers
    var stringHeaders = _stringHeadersMap;
    for (var entry in stringHeaders.entries) {
      var key = entry.key;
      var value = entry.value;
      if (value != null) {
        headers.set(key, value);
      }
    }

    // List<String>-related headers
    var listStringHeaders = _listStringHeadersMap;
    for (var entry in listStringHeaders.entries) {
      var key = entry.key;
      var value = entry.value;
      if (value != null) {
        headers.set(key, value);
      }
    }

    // Uri-related headers
    var uriHeaders = _uriHeadersMap;
    for (var entry in uriHeaders.entries) {
      var key = entry.key;
      var value = entry.value;
      if (value != null) {
        headers.set(key, value.toString());
      }
    }

    // TypedHeader-related headers
    var typedHeaders = _typedHeadersMap;
    for (var entry in typedHeaders.entries) {
      var key = entry.key;
      var value = entry.value;
      if (value != null) {
        headers.set(key, value.toHeaderString());
      }
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

  /// Convert headers to a map
  @override
  Map<String, Object> toMap() {
    var map = <String, Object>{};

    // Date-related headers
    var dateHeaders = _dateHeadersMap;
    for (var entry in dateHeaders.entries) {
      var key = entry.key;
      var value = entry.value;
      if (value != null) {
        map[key] = formatHttpDate(value);
      }
    }

    // Number-related headers
    var numberHeaders = _numberHeadersMap;
    for (var entry in numberHeaders.entries) {
      var key = entry.key;
      var value = entry.value;
      if (value != null) {
        map[key] = value;
      }
    }

    // String-related headers
    var stringHeaders = _stringHeadersMap;
    for (var entry in stringHeaders.entries) {
      var key = entry.key;
      var value = entry.value;
      if (value != null) {
        map[key] = value;
      }
    }

    // List<String>-related headers
    var listStringHeaders = _listStringHeadersMap;
    for (var entry in listStringHeaders.entries) {
      var key = entry.key;
      var value = entry.value;
      if (value != null) {
        map[key] = value;
      }
    }

    // Uri-related headers
    var uriHeaders = _uriHeadersMap;
    for (var entry in uriHeaders.entries) {
      var key = entry.key;
      var value = entry.value;
      if (value != null) {
        map[key] = value.toString();
      }
    }

    // TypedHeader-related headers
    var typedHeaders = _typedHeadersMap;
    for (var entry in typedHeaders.entries) {
      var key = entry.key;
      var value = entry.value;
      if (value != null) {
        map[key] = value.toHeaderString();
      }
    }

    // Custom headers
    for (var entry in custom.entries) {
      map[entry.key] = entry.value;
    }

    return map;
  }

  /// Date-related headers
  Map<String, DateTime?> get _dateHeadersMap => {
        Headers.dateHeader: date ?? DateTime.now().toUtc(),
        Headers.expiresHeader: expires,
        Headers.ifModifiedSinceHeader: ifModifiedSince,
        Headers.lastModifiedHeader: lastModified,
      };

  /// Number-related headers
  Map<String, int?> get _numberHeadersMap => <String, int?>{
        Headers.ageHeader: age,
        Headers.maxForwardsHeader: maxForwards,
        Headers.accessControlMaxAgeHeader: accessControlMaxAge,
      };

  /// String-related headers
  Map<String, String?> get _stringHeadersMap => <String, String?>{
        Headers.serverHeader: server,
        Headers.userAgentHeader: userAgent,
        Headers.xPoweredByHeader: xPoweredBy,
        Headers.accessControlRequestMethodHeader:
            accessControlRequestMethod?.value,
      };

  /// List<String>-related headers
  Map<String, List<String>?> get _listStringHeadersMap =>
      <String, List<String>?>{
        Headers.viaHeader: via,
        Headers.allowHeader: allow?.map((m) => m.value).toList(),
        Headers.accessControlRequestHeadersHeader: accessControlRequestHeaders,
        Headers.trailerHeader: trailer,
      };

  /// Uri-related headers
  Map<String, Uri?> get _uriHeadersMap => <String, Uri?>{
        Headers.locationHeader: location,
        Headers.refererHeader: referer,
        Headers.contentLocationHeader: contentLocation,
        Headers.originHeader: origin,
        Headers.hostHeader: host,
      };

  /// TypedHeader-related headers
  Map<String, TypedHeader?> get _typedHeadersMap => <String, TypedHeader?>{
        Headers.fromHeader: from,
        Headers.acceptEncodingHeader: acceptEncoding,
        Headers.acceptLanguageHeader: acceptLanguage,
        Headers.authorizationHeader: authorization,
        Headers.connectionHeader: connection,
        Headers.expectHeader: expect,
        Headers.ifMatchHeader: ifMatch,
        Headers.ifNoneMatchHeader: ifNoneMatch,
        Headers.ifRangeHeader: ifRange,
        Headers.proxyAuthorizationHeader: proxyAuthorization,
        Headers.rangeHeader: range,
        Headers.teHeader: te,
        Headers.upgradeHeader: upgrade,
        Headers.accessControlAllowOriginHeader: accessControlAllowOrigin,
        Headers.accessControlExposeHeadersHeader: accessControlExposeHeaders,
        Headers.cacheControlHeader: cacheControl,
        Headers.contentEncodingHeader: contentEncoding,
        Headers.contentLanguageHeader: contentLanguage,
        Headers.contentRangeHeader: contentRange,
        Headers.etagHeader: etag,
        Headers.proxyAuthenticationHeader: proxyAuthenticate,
        Headers.retryAfterHeader: retryAfter,
        Headers.transferEncodingHeader: transferEncoding,
        Headers.varyHeader: vary,
        Headers.wwwAuthenticateHeader: wwwAuthenticate,
        Headers.contentDispositionHeader: contentDisposition,
        Headers.cookieHeader: cookie,
        Headers.setCookieHeader: setCookie,
        Headers.strictTransportSecurityHeader: strictTransportSecurity,
        Headers.contentSecurityPolicyHeader: contentSecurityPolicy,
        Headers.referrerPolicyHeader: referrerPolicy,
        Headers.permissionsPolicyHeader: permissionsPolicy,
        Headers.accessControlAllowMethodsHeader: accessControlAllowMethods,
        Headers.accessControlAllowHeadersHeader: accessControlAllowHeaders,
        Headers.clearSiteDataHeader: clearSiteData,
        Headers.secFetchDestHeader: secFetchDest,
        Headers.secFetchModeHeader: secFetchMode,
        Headers.secFetchSiteHeader: secFetchSite,
        Headers.crossOriginResourcePolicyHeader: crossOriginResourcePolicy,
        Headers.crossOriginEmbedderPolicyHeader: crossOriginEmbedderPolicy,
        Headers.crossOriginOpenerPolicyHeader: crossOriginOpenerPolicy,
      };
}

class _Undefined {}
