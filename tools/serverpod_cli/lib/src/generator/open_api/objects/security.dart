import 'package:serverpod_cli/src/generator/open_api/helpers/utils.dart';

/// Defines a security scheme that can be used by the API operations.
abstract class SecuritySchemeObject {
  final String? description;
  SecuritySchemeObject({
    this.description,
  });
  Map<String, dynamic> toJson();
}

enum HttpSecuritySchemeType {
  basic,
  bearer,
}

class HttpSecurityScheme extends SecuritySchemeObject {
  /// Specifies the HTTP Authorization scheme to be used in the Authorization
  /// header, as defined in RFC7235. This applies to `http` and
  /// supporting 'basic' and 'bearer' schemes.
  final HttpSecuritySchemeType scheme;

  /// A hint to the client to identify how the bearer token
  /// is formatted.  Applies to `http`'s `bearer` authentication.
  /// example ```
  /// "bearerFormat": "JWT",
  /// ```
  final String? bearerFormat;
  HttpSecurityScheme({
    required this.scheme,
    super.description,
    this.bearerFormat,
  }) : assert(
            (scheme == HttpSecuritySchemeType.basic) ||
                (scheme == HttpSecuritySchemeType.bearer &&
                    bearerFormat != null),
            'When `scheme` is bearer `bearerFormat` should not be null');

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map[OpenAPIJsonKey.type.name] = SecuritySchemeType.http.name;

    var theDescription = description;
    if (theDescription != null) {
      map[OpenAPIJsonKey.description.name] = theDescription;
    }
    map[OpenAPIJsonKey.scheme.name] = scheme.name;
    if (bearerFormat != null) {
      map[OpenAPIJsonKey.bearerFormat.name] = bearerFormat;
    }
    return map;
  }
}

enum ApiKeyLocation {
  query,
  header,
  cookie,
}

class ApiKeySecurityScheme extends SecuritySchemeObject {
  /// The name of the header, query or cookie parameter to be used. Applies to
  /// [apiKey]
  final String name;

  /// The location of the API key. Valid values are "query", "header" or
  /// "cookie".
  final ApiKeyLocation inField;
  ApiKeySecurityScheme({
    super.description,
    required this.name,
    required this.inField,
  });

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map[OpenAPIJsonKey.type.name] = SecuritySchemeType.apiKey.name;
    var theDescription = description;
    if (theDescription != null) {
      map[OpenAPIJsonKey.description.name] = theDescription;
    }
    map[OpenAPIJsonKey.name.name] = name;
    map['in'] = inField.name;
    return map;
  }
}

class OauthSecurityScheme extends SecuritySchemeObject {
  final Set<OauthFlowObject> flows;
  OauthSecurityScheme({
    super.description,
    required this.flows,
  });

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map[OpenAPIJsonKey.type.name] = SecuritySchemeType.oauth2.name;
    var theDescription = description;
    if (theDescription != null) {
      map[OpenAPIJsonKey.description.name] = theDescription;
    }
    Map<String, dynamic> oauthFlows = {};
    for (var flow in flows) {
      oauthFlows.addAll(flow.toJson());
    }
    map[OpenAPIJsonKey.flows.name] = oauthFlows;
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
    map[OpenAPIJsonKey.type.name] = SecuritySchemeType.openIdConnect.name;
    var theDescription = description;
    if (theDescription != null) {
      map[OpenAPIJsonKey.description.name] = theDescription;
    }
    map[OpenAPIJsonKey.openIdConnectUrl.name] = openIdConnectUrl;
    return map;
  }
}

/// Allows configuration of the supported OAuth Flows.
class OauthFlowObject {
  /// Fixed Fields [implicit, password, clientCredentials, authorizationCode]
  final OauthFlowField fieldName;

  /// The authorization URL to be used for this flow
  /// Applies to oauth2 ("implicit", "authorizationCode")
  final Uri? authorizationUrl;

  /// The token URL to be used for this flow.
  /// Applies to oauth2 ("password", "clientCredentials", "authorizationCode")
  final Uri? tokenUrl;

  /// The URL to be used for obtaining refresh tokens
  final Uri refreshUrl;

  /// The available scopes for the OAuth2 security scheme. A map between
  /// the scope name and a short description for it.
  final Map<String, String> scopes;

  /// The extensions properties are implemented as patterned fields that are
  /// always prefixed by "x-".
  final Map<String, dynamic> specificationExtensions;
  OauthFlowObject({
    required this.fieldName,
    this.authorizationUrl,
    this.tokenUrl,
    required this.refreshUrl,
    required this.scopes,
    required this.specificationExtensions,
  });
  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map[fieldName.name] = {};
    if (tokenUrl != null) {
      map[fieldName.name] = tokenUrl.toString();
    }
    if (authorizationUrl != null) {
      map[fieldName.name] = authorizationUrl.toString();
    }

    map[fieldName.name] = refreshUrl.toString();
    map[fieldName.name] = scopes;
    if (specificationExtensions.isEmpty) {
      for (var ext in specificationExtensions.entries) {
        if (ext.key.startsWith('x-')) {
          map[fieldName.name][ext.key] = ext.value;
        }
      }
    }
    return {};
  }
}

enum OauthFlowField {
  implicit,
  password,
  clientCredentials,
  authorizationCode,
}

class OpenAPISecurityRequirement {
  final String name;
  final SecuritySchemeObject securitySchemes;
  OpenAPISecurityRequirement({
    required this.name,
    required this.securitySchemes,
  });
  Map<String, dynamic> toJson([bool ref = false]) {
    Map<String, dynamic> map = {};
    map[name] = ref
        ? _getScopeFromSecurityScheme(securitySchemes)
        : securitySchemes.toJson();
    return map;
  }

  dynamic _getScopeFromSecurityScheme(SecuritySchemeObject securitySchemes) {
    if (securitySchemes is OauthSecurityScheme) {
      // eg  - googleOAuth: ['openid', 'profile']
      return securitySchemes.flows.first.scopes.keys.toList();
    }
    return [];
  }
}

// TODO : Test all Serverpod auth flows and implement them.
OpenAPISecurityRequirement googleAuth = OpenAPISecurityRequirement(
  name: 'googleOauth',
  securitySchemes: OauthSecurityScheme(description: 'Google Auth 2.0', flows: {
    OauthFlowObject(
      fieldName: OauthFlowField.authorizationCode,
      refreshUrl: Uri.parse('https://accounts.google.com/o/oauth2/token'),
      scopes: {
        'openid': 'OpenID Connect',
        'profile': 'User profile information'
      },
      specificationExtensions: {},
    ),
  }),
);

OpenAPISecurityRequirement serverpodAuth = OpenAPISecurityRequirement(
  name: 'serverpodAuth',
  securitySchemes: HttpSecurityScheme(
    scheme: HttpSecuritySchemeType.bearer,
    bearerFormat: 'JWT',
  ),
);
