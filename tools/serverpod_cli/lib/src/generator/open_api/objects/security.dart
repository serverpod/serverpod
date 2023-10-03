part of '../open_api_objects.dart';

/// Defines a security scheme that can be used by the operations.
abstract class SecuritySchemeObject {
  /// The type of the security scheme.

  final String? description;
  SecuritySchemeObject({
    this.description,
  });
  Map<String, dynamic> toJson();
}

class HttpSecurityScheme extends SecuritySchemeObject {
  /// The name of the HTTP Authorization scheme to be used in the Authorization
  /// header as defined in RFC7235. Applies to [http]
  /// `basic` `bearer`
  final String scheme;

  /// A hint to the client to identify how the bearer token
  /// is formatted.  Applies to [http] ("bearer")
  /// example ```
  /// "bearerFormat": "JWT",
  /// ```
  final String? bearerFormat;
  HttpSecurityScheme({
    required this.scheme,
    super.description,
    this.bearerFormat,
  })  : assert(
          (scheme == 'basic') || (scheme == 'bearer'),
          '`scheme` must be one of `basic or bearer`.',
        ),
        assert(
            (scheme == 'basic') || (scheme == 'bearer' && bearerFormat != null),
            'When `scheme` is bearer `bearerFormat` should not be null');

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['type'] = SecuritySchemeType.http.name;
    if (description != null) map['description'] = description!;
    map['scheme'] = scheme;
    if (bearerFormat != null) map['bearerFormat'] = bearerFormat;
    return map;
  }
}

class ApiKeySecurityScheme extends SecuritySchemeObject {
  /// The name of the header, query or cookie parameter to be used. Applies to
  /// [apiKey]
  final String name;

  /// The location of the API key. Valid values are "query", "header" or
  /// "cookie". Applies to [apiKey]
  final String inField;
  ApiKeySecurityScheme({
    super.description,
    required this.name,
    required this.inField,
  }) : assert(
          ['query', 'header', 'cookie'].contains(inField),
          'inField only accept query,header and cookie',
        );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['type'] = SecuritySchemeType.apiKey.name;
    if (description != null) map['description'] = description!;
    map['name'] = name;
    map['in'] = inField;
    return map;
  }
}

class OauthSecurityScheme extends SecuritySchemeObject {
  final OauthFlowObject flows;
  OauthSecurityScheme({
    super.description,
    required this.flows,
  });

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['type'] = SecuritySchemeType.oauth2.name;
    if (description != null) map['description'] = description!;
    map['flows'] = flows.toJson();
    return map;
  }
}

class OpenIdSecurityScheme extends SecuritySchemeObject {
  /// OpenId Connect URL to discover OAuth2 configuration values.
  /// This must be in the form of a URL. The OpenID Connect standard requires
  /// the use of TLS.
  final String openIdConnectUrl;
  OpenIdSecurityScheme({
    super.description,
    required this.openIdConnectUrl,
  });

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['type'] = SecuritySchemeType.openIdConnect.name;
    if (description != null) map['description'] = description!;
    map['openIdConnectUrl'] = openIdConnectUrl;
    return map;
  }
}

class OauthFlowObject {
  Map<String, dynamic> toJson() {
    return {};
  }
}

class SecurityRequirementObject {}
