import 'package:serverpod_cli/src/generator/open_api/helpers/utils.dart';

/// The [OpenAPIConfig] is used to provide metadata and information about
/// the API.
/// eg.
/// ```
///     {
///       "title": "Sample Pet Store App",
///       "summary": "A pet store manager.",
///       "description": "This is a sample server for a pet store.",
///       "termsOfService": "https://example.com/terms/",
///       "contact": {
///         "name": "API Support",
///         "url": "https://www.example.com/support",
///         "email": "support@example.com"
///       },
///       "license": {
///         "name": "Apache 2.0",
///         "url": "https://www.apache.org/licenses/LICENSE-2.0.html"
///       },
///       "version": "1.0.1"
///     }
/// ```
class OpenAPIConfig {
  final String title;

  /// A short summary of the API.
  final String? summary;

  /// A description of the API.
  /// CommonMark syntax may be used for rich text representation.
  final String? description;

  /// A URL to the Terms of Service for the API.
  final Uri? termsOfService;

  /// Contact information for the exposed API.
  final OpenAPIContact? contact;

  /// License information for the exposed API.
  final OpenAPILicense? license;

  /// The version of the OpenAPI document
  /// (which is distinct from the OpenAPI Specification version or
  /// the API implementation version).
  final String version;
  OpenAPIConfig({
    required this.title,
    this.summary,
    this.description,
    this.termsOfService,
    this.contact,
    this.license,
    required this.version,
  });

  factory OpenAPIConfig.fromJson(Map<String, dynamic> map) {
    return OpenAPIConfig(
      title: map[OpenAPIJsonKey.title],
      version: map[OpenAPIJsonKey.version],
      description: map[OpenAPIJsonKey.description],
    );
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      OpenAPIJsonKey.title: title,
      OpenAPIJsonKey.version: version,
    };
    if (summary != null) {
      map[OpenAPIJsonKey.summary] = summary;
    }
    if (description != null) {
      map[OpenAPIJsonKey.description] = description;
    }
    if (contact != null) {
      map[OpenAPIJsonKey.contact] = contact?.toJson();
    }
    if (license != null) {
      map[OpenAPIJsonKey.license] = license?.toJson();
    }
    if (termsOfService != null) {
      map[OpenAPIJsonKey.termOfService] = termsOfService?.toString();
    }
    return map;
  }

  factory OpenAPIConfig.fromConfig(Map map, {required String version}) {
    return OpenAPIConfig(
      title: map[OpenAPIJsonKey.title],
      summary: map.containsKey(OpenAPIJsonKey.summary)
          ? map[OpenAPIJsonKey.summary]
          : null,
      description: map[OpenAPIJsonKey.description],
      contact: map.containsKey(OpenAPIJsonKey.contact)
          ? OpenAPIContact.fromJson(map[OpenAPIJsonKey.contact])
          : null,
      license: map.containsKey(OpenAPIJsonKey.license)
          ? OpenAPILicense.fromJson(map[OpenAPIJsonKey.license])
          : null,
      termsOfService: map.containsKey(OpenAPIJsonKey.termOfService)
          ? Uri.parse(map[OpenAPIJsonKey.termOfService])
          : null,
      version: version,
    );
  }
}

/// Information about the license governing the use of the API.
/// example
///```json
///  {
///   "name": "Apache 2.0",
///   "identifier": "Apache-2.0"
///  }
///```
class OpenAPILicense {
  /// The license name used for the API.
  final String name;

  /// A url to the license used for the API.
  /// The url field is mutually exclusive of the identifier field.
  final Uri? url;
  OpenAPILicense({
    required this.name,
    this.url,
  });

  Map<String, String> toJson() {
    var map = {
      OpenAPIJsonKey.name: name,
    };
    if (url != null) {
      map[OpenAPIJsonKey.url] = url.toString();
    }
    return map;
  }

  factory OpenAPILicense.fromJson(Map map) {
    return OpenAPILicense(
      name: map[OpenAPIJsonKey.name] as String,
      url: map[OpenAPIJsonKey.url] != null
          ? Uri.parse(map[OpenAPIJsonKey.url])
          : null,
    );
  }
}

/// Information about the organization or individual responsible for the API.
/// example.
///```json
/// {
///     "name": "API Support",
///     "url": "https://www.example.com/support",
///     "email": "support@example.com"
/// }
///
///```
///
class OpenAPIContact {
  /// The identifying name of the contact person/organization.
  final String name;

  /// The URL pointing to the contact information.
  final Uri url;

  /// The email address of the contact person/organization.
  final String email;
  OpenAPIContact({
    required this.name,
    required this.url,
    required this.email,
  });

  Map<String, String> toJson() {
    return {
      OpenAPIJsonKey.name: name,
      OpenAPIJsonKey.url: url.toString(),
      OpenAPIJsonKey.email: email,
    };
  }

  factory OpenAPIContact.fromJson(Map map) {
    return OpenAPIContact(
      name: map[OpenAPIJsonKey.name] as String,
      url: Uri.parse(map[OpenAPIJsonKey.url] as String),
      email: map[OpenAPIJsonKey.email] as String,
    );
  }
}

/// Allows referencing an external resource for extended documentation.
/// ```json
/// {
///   "description": "Find more info here",
///   "url": "https://example.com"
/// }
/// ```
class OpenAPIExternalDocumentation {
  /// A description of the target documentation.
  final String? description;

  /// The URL for the target documentation..
  final Uri url;
  OpenAPIExternalDocumentation({
    this.description,
    required this.url,
  });

  Map<String, String> toJson() {
    var map = {OpenAPIJsonKey.url: url.toString()};
    var theDescription = description;
    if (theDescription != null) {
      map[OpenAPIJsonKey.description] = theDescription;
    }
    return map;
  }

  factory OpenAPIExternalDocumentation.fromJson(Map map) {
    return OpenAPIExternalDocumentation(
      url: Uri.parse(map[OpenAPIJsonKey.url] as String),
      description: map[OpenAPIJsonKey.description] != null
          ? map[OpenAPIJsonKey.description] as String
          : null,
    );
  }
}
