// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:recase/recase.dart';
import 'package:serverpod_cli/src/logger/logger.dart';

import '../../../analyzer.dart';

part 'open_api_definition.dart';

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
class InfoObject {
  final String title;

  /// A short summary of the API.
  final String? summary;

  /// A description of the API.
  /// CommonMark syntax MAY be used for rich text representation.
  final String? description;

  /// A URL to the Terms of Service for the API.
  /// This MUST be in the form of a URL.
  final Uri? termsOfService;

  /// Contact information for the exposed API.
  final ContactObject? contact;

  /// License information for the exposed API.
  final LicenseObject? license;

  /// REQUIRED. The version of the OpenAPI document
  /// (which is distinct from the OpenAPI Specification version or
  /// the API implementation version).
  final String version;
  InfoObject({
    required this.title,
    this.summary,
    this.description,
    this.termsOfService,
    this.contact,
    this.license,
    required this.version,
  });

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'title': title,
      'version': version,
    };
    if (summary != null) {
      map['summary'] = summary;
    }
    if (description != null) {
      map['description'] = description;
    }
    if (contact != null) {
      map['contact'] = contact?.toJson();
    }
    if (license != null) {
      map['license'] = license?.toJson();
    }
    if (termsOfService != null) {
      map['termsOfService'] = termsOfService?.toString();
    }

    return map;
  }
}

/// example
///```json
///  {
///   "name": "Apache 2.0",
///   "identifier": "Apache-2.0"
///  }
///```
class LicenseObject {
  /// REQUIRED. The license name used for the API.
  final String name;

  /// An SPDX license expression for the API.
  /// The identifier field is mutually exclusive of the url field.
  final String? identifier;

  /// A URL to the license used for the API.
  /// This MUST be in the form of a URL.
  /// The url field is mutually exclusive of the identifier field.
  final Uri? url;
  LicenseObject({
    required this.name,
    this.identifier,
    this.url,
  });

  Map<String, String> toJson() {
    var map = {
      'name': name,
    };
    if (identifier != null) {
      map['identifier'] = identifier!;
    }
    if (url != null) {
      map['url'] = url.toString();
    }
    return map;
  }
}

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
class ContactObject {
  /// The identifying name of the contact person/organization.

  final String name;

  /// The URL pointing to the contact information. This MUST be in the form of a URL.
  final Uri url;

  /// The email address of the contact person/organization.
  /// This MUST be in the form of an email address.
  final String email;
  ContactObject({
    required this.name,
    required this.url,
    required this.email,
  });

  Map<String, String> toJson() {
    return {
      'name': name,
      'url': url.toString(),
      'email': email,
    };
  }
}

/// example
/// ```dart
///   {
///   "url": "https://development.gigantic-server.com/v1",
///   "description": "Development server"
///   }
/// ```
///
/// The following shows how variables can be used for a server configuration:
/// ```
/// {
///   "servers": [
///     {
///       "url": "https://{username}.gigantic-server.com:{port}/{basePath}",
///       "description": "The production API server",
///       "variables": {
///         "username": {
///           "default": "demo",
///           "description": "this value is assigned by the service provider, in this example `gigantic-server.com`"
///         },
///         "port": {
///           "enum": [
///             "8443",
///             "443"
///           ],
///           "default": "8443"
///         },
///         "basePath": {
///           "default": "v2"
///         }
///       }
///     }
///   ]
/// }
/// ```
class ServerObject {
  /// REQUIRED. A URL to the target host.
  /// This URL supports Server Variables and MAY be relative,
  /// to indicate that the host location is relative to the location where the OpenAPI document is being served.
  /// Variable substitutions will be made when a variable is named in {brackets}.
  final Uri url;

  /// An optional string describing the host designated by the URL.
  /// CommonMark syntax MAY be used for rich text representation.
  final String? description;

  /// A map between a variable name and its value.
  /// The value is used for substitution in the server's URL template.
  final Map<String, ServerVariableObject>? variables;
  ServerObject({
    required this.url,
    this.description,
    this.variables,
  });

  Map<String, dynamic> toJson() {
    var map = {
      'url': url.toString(),
    };
    if (description != null) {
      map['description'] = description!;
    }
    if (variables != null) {
      //TODO: implement multiple servers
    }

    return map;
  }
}

/// An object representing a Server Variable for server URL template substitution.
class ServerVariableObject {
  /// key - [enum]
  final List<String>? enumField;

  /// REQUIRED. The default value to use for substitution, which SHALL be sent if an alternate value is not supplied.
  /// Note this behavior is different than the Schema Object's treatment of default values,
  /// because in those cases parameter values are optional.
  /// If the enum is defined, the value MUST exist in the enum's values.
  /// key - [default]
  final String defaultField;

  ///An optional description for the server variable. CommonMark syntax MAY be used for rich text representation.
  final String? description;
  ServerVariableObject({
    this.enumField,
    required this.defaultField,
    this.description,
  });

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'default': defaultField,
    };
    if (enumField?.isNotEmpty ?? false) {
      map['enum'] = enumField!;
    }
    if (description != null) {
      map['description'] = description;
    }
    return map;
  }
}

/// Holds a set of reusable objects for different aspects of the OAS.
/// All objects defined within the components object will have no effect on the API
/// unless they are explicitly referenced from properties outside the components object.
/// example
/// ```json
///    "components": {
///      "schemas": {
///        "GeneralError": {
///          "type": "object",
///          "properties": {
///            "code": {
///              "type": "integer",
///              "format": "int32"
///            },
///            "message": {
///              "type": "string"
///            }
///          }
///        },
///        "Category": {
///          "type": "object",
///          "properties": {
///            "id": {
///              "type": "integer",
///              "format": "int64"
///            },
///            "name": {
///              "type": "string"
///            }
///          }
///        },
///        "Tag": {
///          "type": "object",
///          "properties": {
///            "id": {
///              "type": "integer",
///              "format": "int64"
///            },
///            "name": {
///              "type": "string"
///            }
///          }
///        }
///      },
///      "parameters": {
///        "skipParam": {
///          "name": "skip",
///          "in": "query",
///          "description": "number of items to skip",
///          "required": true,
///          "schema": {
///            "type": "integer",
///            "format": "int32"
///          }
///        },
///        "limitParam": {
///          "name": "limit",
///          "in": "query",
///          "description": "max records to return",
///          "required": true,
///          "schema" : {
///            "type": "integer",
///            "format": "int32"
///          }
///        }
///      },
///      "responses": {
///        "NotFound": {
///          "description": "Entity not found."
///        },
///        "IllegalInput": {
///          "description": "Illegal input for operation."
///        },
///        "GeneralError": {
///          "description": "General Error",
///          "content": {
///            "application/json": {
///              "schema": {
///                "$ref": "#/components/schemas/GeneralError"
///              }
///            }
///          }
///        }
///      },
///      "securitySchemes": {
///        "api_key": {
///          "type": "apiKey",
///          "name": "api_key",
///          "in": "header"
///        },
///        "petstore_auth": {
///          "type": "oauth2",
///          "flows": {
///            "implicit": {
///              "authorizationUrl": "https://example.org/api/oauth/dialog",
///              "scopes": {
///                "write:pets": "modify pets in your account",
///                "read:pets": "read your pets"
///              }
///            }
///          }
///        }
///      }
///    }
/// ```
///
class ComponentsObject {
  /// An object to hold reusable Schema Objects.
  final Map<String, SchemaObject>? schemas;

  /// An object to hold reusable Response Objects.
  final Map<String, ResponseObject>? responses;

  /// An object to hold reusable Parameter Objects.
  final Map<String, ParameterObject>? parameters;

  /// An object to hold reusable Example Objects.
  final Map<String, ExampleObject>? examples;

  /// An object to hold reusable Request Body Objects.
  final Map<String, RequestBodyObject>? requestBodies;

  /// An object to hold reusable Header Objects.
  final Map<String, HeaderObject>? headers;

  /// An object to hold reusable Security Scheme Objects.
  final Map<String, SecuritySchemeObject>? securitySchemes;

  /// An object to hold reusable Link Objects.
  final Map<String, LinkObject>? links;

  /// An object to hold reusable Callback Objects.
  final Map<String, CallbackObject>? callbacks;

  final Map<String, PathItemObject>? pathItems;
  ComponentsObject({
    this.schemas,
    this.responses,
    this.parameters,
    this.examples,
    this.requestBodies,
    this.headers,
    this.securitySchemes,
    this.links,
    this.callbacks,
    required this.pathItems,
  });
}

class RequestBodyObject {}

class ExampleObject {}

/// Holds the relative paths to the individual endpoints and their operations.
/// The path is appended to the URL from the Server Object in order to construct the full URL.
/// The Paths MAY be empty, due to Access Control List (ACL) constraints.
class PathsObject {
  final PathItemObject path;
  PathsObject({
    required this.path,
  });
}

class ResponseObject {}

/// Holds the relative paths to the individual endpoints and their operations.
/// The path is appended to the URL from the Server Object in order to construct the full URL.
/// The Paths MAY be empty, due to Access Control List (ACL) constraints.
///
/// ***Parameter Locations***
///
/// There are four possible parameter locations specified by the in field:
///
///  - path - Used together with Path Templating, where the parameter value is actually part of the operation's URL. This does not include the host or base path of the API. For example, in /items/{itemId}, the path parameter is itemId.
///  - query - Parameters that are appended to the URL. For example, in /items?id=###, the query parameter is id.
///  - header - Custom headers that are expected as part of the request. Note that RFC7230 states header names are case insensitive.
///  - cookie - Used to pass a specific cookie value to the API.
class ParameterObject {
  final String name;

  /// REQUIRED. The location of the parameter. Possible values are "query", "header", "path" or "cookie".
  final String inField;
  final String? description;

  /// required
  /// Determines whether this parameter is mandatory. If the parameter location is "path", this property is REQUIRED and its value MUST be true. Otherwise, the property MAY be included and its default value is false.
  final bool requiredField;

  /// Specifies that a parameter is deprecated and SHOULD be transitioned out of usage. Default value is false.
  final bool deprecated;

  /// Sets the ability to pass empty-valued parameters. This is valid only for query parameters and allows sending a parameter with an empty value. Default value is false. If style is used, and if behavior is n/a (cannot be serialized), the value of allowEmptyValue SHALL be ignored. Use of this property is NOT RECOMMENDED, as it is likely to be removed in a later revision.
  final bool allowEmptyValue;
  ParameterObject({
    required this.name,
    required this.inField,
    this.description,
    this.requiredField = false,
    this.deprecated = false,
    required this.allowEmptyValue,
  });
}

class SecurityRequirementObject {}

///  example
/// ```
/// {
///  "name": "pet",
///  "description": "Pets operations"
/// }
///```
/// must be unique
/// used for grouping endpoints
class TagObject {
  final String name;
  final String? description;
  final ExternalDocumentationObject? externalDocumentationObject;
  TagObject({
    required this.name,
    this.description,
    this.externalDocumentationObject,
  });

  Map<String, dynamic> toJson() {
    var map = {
      'name': name,
    };
    if (description != null) {
      map['description'] = description!;
    }
    if (externalDocumentationObject != null) {
      ///TODO: implement
      // map['externalDocumentationObject'] = externalDocumentationObject.;
    }
    return map;
  }

  @override
  bool operator ==(covariant TagObject other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.description == description &&
        other.externalDocumentationObject == externalDocumentationObject;
  }

  @override
  int get hashCode =>
      name.hashCode ^
      description.hashCode ^
      externalDocumentationObject.hashCode;
}

/// Allows referencing an external resource for extended documentation.
/// ```json
/// {
///   "description": "Find more info here",
///   "url": "https://example.com"
/// }
/// ```
class ExternalDocumentationObject {
  final String? description;
  final Uri url;
  ExternalDocumentationObject({
    this.description,
    required this.url,
  });
}

class SchemaObject {}

/// A simple object to allow referencing other components in the OpenAPI document,
/// internally and externally.
/// The $ref string value contains a URI RFC3986, which identifies the location of the value being referenced.
class ReferenceObject {
  /// REQUIRED. The reference identifier. This MUST be in the form of a URI.
  /// key - [$ref]
  /// ```
  /// {
  /// "$ref": "#/components/schemas/Pet"
  /// }
  ///
  /// ref = 'Pet';
  /// ```
  ///

  final String ref;
  final String? summary;
  final String? description;
  ReferenceObject({
    required this.ref,
    this.summary,
    this.description,
  });

  Map<String, String> toJson() {
    var map = {
      '\$ref': '#/components/schemas/$ref',
    };
    if (summary != null) {
      map['summary'] = summary!;
    }
    if (description != null) {
      map['description'] = description!;
    }
    return map;
  }
}

class HeaderObject {}

class SecuritySchemeObject {}

class LinkObject {}

class CallbackObject {}

/// Describes the operations available on a single path.
/// A Path Item MAY be empty, due to ACL constraints.
/// The path itself is still exposed to the documentation viewer
/// but they will not know which operations and parameters are available.
class PathItemObject {
  /// Allows for a referenced definition of this path item.
  /// The referenced structure MUST be in the form of a Path Item Object.
  /// In case a Path Item Object field appears both in the defined object and the referenced object, the behavior is undefined.
  /// See the rules for resolving Relative References.
  final String? ref;

  /// An optional, string summary, intended to apply to all operations in this path.
  final String? summary;

  /// An optional, string description, intended to apply to all operations in this path. CommonMark syntax MAY be used for rich text representation.
  final String? description;

  /// A definition of a GET operation on this path.
  final OperationObject? getOperation;

  /// A definition of a PUT operation on this path.
  final OperationObject? putOperation;

  /// A definition of a POST operation on this path.
  final OperationObject? postOperation;

  /// A definition of a DELETE operation on this path.
  final OperationObject? deleteOperation;

  /// A definition of a OPTIONS operation on this path.
  final OperationObject? optionsOperation;

  /// A definition of a HEAD operation on this path.
  final OperationObject? headOperation;

  /// A definition of a PATCH operation on this path.
  final OperationObject? patchOperation;

  /// A definition of a TRACE operation on this path.
  final OperationObject? traceOperation;

  /// An alternative server array to service all operations in this path.
  final List<ServerObject>? servers;

  final List<ParameterObject>? parameters;
  PathItemObject({
    this.ref,
    this.summary,
    this.description,
    this.getOperation,
    this.putOperation,
    this.postOperation,
    this.deleteOperation,
    this.optionsOperation,
    this.headOperation,
    this.patchOperation,
    this.traceOperation,
    this.servers,
    this.parameters,
  });
}

/// Describes a single API operation on a path.
class OperationObject {
  /// A list of tags for API documentation control. Tags can be used for logical grouping of operations by resources or any other qualifier.
  final List<String>? tags;

  /// A short summary of what the operation does.
  final String? summary;

  final String? description;

  final ExternalDocumentationObject? externalDocs;

  /// Unique string used to identify the operation.
  /// The id MUST be unique among all operations described in the API.
  /// The operationId value is case-sensitive.
  /// Tools and libraries MAY use the operationId to uniquely identify an operation, therefore, it is RECOMMENDED to follow common programming naming conventions.
  /// it should be serverpod endpoint's method name
  final String? operationId;

  /// A list of parameters that are applicable for this operation.
  /// If a parameter is already defined at the Path Item, the new definition will override it but can never remove it.
  /// The list MUST NOT include duplicated parameters.
  /// A unique parameter is defined by a combination of a name and location. T
  /// he list can use the Reference Object to link to parameters that are defined at the OpenAPI Object's components/parameters.
  final List<ParameterObject>? parameters;

  /// The request body applicable for this operation.
  /// The requestBody is fully supported in HTTP methods where the HTTP 1.1 specification RFC7231 has explicitly defined semantics for request bodies.
  /// In other cases where the HTTP spec is vague (such as GET, HEAD and DELETE),
  /// requestBody is permitted but does not have well-defined semantics and SHOULD be avoided if possible.

  final RequestBodyObject? requestBody;

  /// The list of possible responses as they are returned from executing this operation.
  final ResponseObject responses;

  /// Declares this operation to be deprecated. Consumers SHOULD refrain from usage of the declared operation.
  /// Default value is false.

  final bool deprecated;

  final SecurityRequirementObject security;

  final List<ServerObject>? servers;
  OperationObject({
    this.tags,
    this.summary,
    this.description,
    this.externalDocs,
    this.operationId,
    this.parameters,
    this.requestBody,
    this.deprecated = false,
    required this.responses,
    required this.security,
    this.servers,
  });
}
