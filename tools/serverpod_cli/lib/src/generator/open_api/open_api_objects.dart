// ignore_for_file: public_member_api_docs, sort_constructors_first

part of './open_api_definition.dart';

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
  /// CommonMark syntax may be used for rich text representation.
  final String? description;

  /// A URL to the Terms of Service for the API.
  /// This must be in the form of a URL.
  final Uri? termsOfService;

  /// Contact information for the exposed API.
  final ContactObject? contact;

  /// License information for the exposed API.
  final LicenseObject? license;

  /// The version of the OpenAPI document
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
  /// The license name used for the API.
  final String name;

  /// An SPDX license expression for the API.
  /// The identifier field is mutually exclusive of the url field.
  final String? identifier;

  /// A URL to the license used for the API.
  /// This must be in the form of a URL.
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

  /// The URL pointing to the contact information.
  final Uri url;

  /// The email address of the contact person/organization.
  /// This must be in the form of an email address.
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
  /// A URL to the target host. This URL supports Server Variables and
  ///  may be relative, to indicate that the host location is relative
  ///  to the location where the OpenAPI document is being served.
  /// Variable substitutions will be made when a variable is named in
  /// {brackets}.
  final Uri url;

  /// An optional string describing the host designated by the URL.
  /// CommonMark syntax may be used for rich text representation.
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
      // TODO: implement multiple servers
    }

    return map;
  }
}

/// An object representing a Server Variable for server URL template
/// substitution.
class ServerVariableObject {
  /// key - [enum]
  final List<String>? enumField;

  /// The default value to use for substitution, which SHALL be sent if an
  /// alternate value is not supplied.
  /// Note this behavior is different than the Schema Object's treatment of
  /// default values, because in those cases parameter values are optional.
  /// If the enum is defined, the value must exist in the enum's values.
  /// key - [default]
  final String defaultField;

  /// An optional description for the server variable. CommonMark syntax
  /// may be used for rich text representation.
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
/// All objects defined within the components object will have no effect
/// on the API unless they are explicitly referenced from properties outside the
/// components object.
/// example.
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
  final Set<ComponentSchemaObject>? schemas;

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

  /// An object to hold reusable Path Item Object.
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
    this.pathItems,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['components'] = {};
    if (schemas != null) {
      // TODO: Add Error Model
      map['components']['schemas'] = _getSchemaMapFromSetSchema(schemas!);
    }
    return map;
  }

  Map<String, dynamic> _getSchemaMapFromSetSchema(
      Set<ComponentSchemaObject>? schemas) {
    Map<String, dynamic> map = {};
    for (var schema in schemas!) {
      map.addAll(schema.toJson());
    }
    return map;
  }
}

/// [RequestBodyObject] Request bodies are typically used with “create” and
/// “update” operations
/// (POST, PUT, PATCH). For example, when creating a resource using POST or
/// PUT, the request body usually contains the representation of the resource
/// to be created. OpenAPI 3.0 provides the requestBody keyword to describe
/// request bodies.

class RequestBodyObject {
  final String? description;
  final ContentObject? content;
  final bool requiredField;
  RequestBodyObject({
    this.description,
    this.content,
    this.requiredField = true,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (description != null) map['description'] = map;
    if (content != null) map['content'] = content;
    map['required'] = requiredField;
    return map;
  }

  // factory RequestBodyObject.fromMethod(MethodDefinition methodDefinition) {

  // }
}

/// A Schema object which will use in [ComponentObject]
class ComponentSchemaObject {
  final ClassDefinition classDefinition;

  ComponentSchemaObject(
    this.classDefinition,
  );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    Map<String, dynamic> objectMap = {};
    objectMap['type'] = SchemaObjectType.object.name;
    objectMap['properties'] = {};
    for (var field in classDefinition.fields) {
      objectMap['properties'][field.name] = {
        'type': field.type.toSchemaObjectType.name,
      };
    }
    map[classDefinition.className] = objectMap;

    return map;
  }
}

///example
///```
///"content": {
///               "application/json": {
///                 "schema": {
///                   "$ref": "#/components/schemas/Pet"
///                 }
///               },
///               "application/xml": {
///                 "schema": {
///                   "$ref": "#/components/schemas/Pet"
///                 }
///               }
///             }
///           },
/// ```
class ContentObject {
  final List<String> contentTypes;
  final ContentSchemaObject schemaObject;

  ContentObject({
    required this.contentTypes,
    required this.schemaObject,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> contentMap = {};
    for (var type in contentTypes) {
      contentMap[type] = {};
      contentMap[type]['schema'] = schemaObject.toJson();
    }
    return contentMap;
  }
}

class ContentType {
  static const applicationJson = 'application/json';
  static const applicationXml = 'application/xml';
  static const applicationForm = 'application/x-www-form-urlencoded';
  static const any = '*/*';
  static const image = 'image/png';
  static const applicationOctetStream = 'application/octet-stream';
}

class ExampleObject {}

/// Holds the relative paths to the individual endpoints and their operations.
/// The path is appended to the URL from the Server Object in order to
///  construct the full URL.
/// The Paths may be empty, due to Access Control List (ACL) constraints.
class PathsObject {
  /// name of the path
  /// ```
  /// /pets <- pathName (ServerPod Endpoint Name)
  ///     - post/ <- pathItemObject (Serverpod Endpoint's method name)
  /// ```
  final String pathName;
  final PathItemObject? path;
  PathsObject({
    required this.pathName,
    this.path,
  });

  Map<String, dynamic> toJson() {
    return {'/$pathName': path ?? {}};
  }
}

/// An API specification needs to specify the responses for all API operations.
/// Each operation must have at least one response defined, usually a
/// successful response. A response is defined by its HTTP status code and the
/// data returned in the response body and/or headers.
class ResponseObject {
  final ContentObject responseType;
  ResponseObject({
    required this.responseType,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    //200 response
    map['200'] = <String, dynamic>{'description': 'Success'};
    map['200']['content'] = responseType.toJson();
    //400 bad request
    map['400'] = {
      'description':
          'Bad request (the query passed to the server was incorrect).'
    };
    //403 forbidden
    map['403'] = {
      'description':
          'Forbidden (the caller is trying to call a restricted endpoint, but doesn\'t have the correct credentials/scope).'
    };
    //500 internal server error
    map['500'] = {'description': 'Internal server error '};
    return map;
  }
}

/// Holds the relative paths to the individual endpoints and their operations.
/// The path is appended to the URL from the Server Object in order to
///  construct the full URL.
/// The Paths may be empty, due to Access Control List (ACL) constraints.
/// ***Parameter Locations***
/// There are four possible parameter locations specified by the in field:
///  - path - Used together with Path Templating, where the parameter value is
///    actually part of the operation's URL. This does not include the host or
///    base path of the API. For example, in /items/{itemId}, the path
///    parameter is itemId.
///  - query - Parameters that are appended to the URL. For example, in /items?
///    id=###, the query parameter is id.
///  - header - Custom headers that are expected as part of the request.
///    Note that RFC7230 states header names are case insensitive.
///  - cookie - Used to pass a specific cookie value to the API.
class ParameterObject {
  /// parameter name
  final String name;

  /// The location of the parameter. Possible values are "query", "header",
  /// "path" or "cookie". key - [in]
  final ParameterLocation inField;
  final String? description;

  /// Determines whether this parameter is mandatory. I
  /// If the parameter location is "path",
  /// this property is required and its value must be true.
  /// Otherwise, the property may be included and
  /// its default value is false.
  final bool requiredField;

  /// Specifies that a parameter is deprecated and should be transitioned
  /// out of usage. Default value is false.
  final bool deprecated;

  /// Sets the ability to pass empty-valued parameters.
  /// This is valid only for query parameters and allows sending a
  /// parameter
  /// with an empty value. Default value is false. If style is used,
  /// and if behavior is n/a (cannot be serialized), the value of
  /// allowEmptyValue SHALL be ignored. Use of this property is not
  /// recommended, as it is likely to be removed in a later revision.
  final bool allowEmptyValue;

  /// Describes how the parameter value will be serialized depending
  /// on the type of the parameter value. Default values (based on value of in)
  /// query -> form; path -> simple; header -> simple; cookie -> form.
  final ParameterStyle? style;

  /// When this is true, parameter values of type array or
  /// object generate separate parameters for each value of the array
  /// or key-value pair of the map.
  /// For other types of parameters this property has no effect.
  /// When style is form, the default value is true. For all other styles,
  /// the default value is false.
  final bool explode;

  /// Determines whether the parameter value should allow reserved characters,
  /// as defined by RFC3986 :/?#[]@!$&'()*+,;= to be included without
  /// percent-encoding. This property only applies to parameters
  /// with an in value of query. The default value is false.
  final bool allowReserved;

  /// The schema defining the type used for the parameter.
  final ParameterSchemaObject? schema;
  ParameterObject({
    required this.name,
    required this.inField,
    this.description,
    required this.requiredField,
    this.deprecated = false,
    required this.allowEmptyValue,
    this.style,
    this.explode = false,
    this.allowReserved = false,
    this.schema,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': name,
      'in': inField.name,
      'required': requiredField,
    };
    if (description != null) {
      map['description'] = description!;
    }
    if (deprecated) {
      map['deprecated'] = deprecated;
    }
    if (allowEmptyValue) {
      map['allowEmptyValue'] = allowEmptyValue;
    }

    if (style != null) {
      map['style'] = style!.name.camelToKebabCase;
    }

    if (explode) {
      map['explode'] = explode;
    }

    if (allowReserved) {
      map['allowReserved'] = allowReserved;
    }

    if (schema != null) {
      map['schema'] = schema!.toJson();
    }

    return map;
  }
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
    var map = <String, dynamic>{
      'name': name,
    };
    if (description != null) {
      map['description'] = description!;
    }
    if (externalDocumentationObject != null) {
      map['externalDocumentationObject'] =
          externalDocumentationObject!.toJson();
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

  Map<String, String> toJson() {
    var map = {'url': url.toString()};
    if (description != null) {
      map['description'] = description!;
    }
    return map;
  }
}

/// The Schema Object allows the definition of input and output data types.
/// These types can be objects, but also primitives and arrays.
/// This object is a superset of the JSON Schema Specification Draft 2020-12.
// TODO: rewrite schema object
// class SchemaObject {
//   /// Adds support for polymorphism.
//   /// The discriminator is an object name that is used to differentiate between other schemas which may satisfy the payload description.
//   /// See Composition and Inheritance for more details.
//   final DiscriminatorObject? discriminator;

//   /// external docs
//   final ExternalDocumentationObject? externalDocs;

//   /// example
//   /// ```
//   /// "Order": {
//   ///     "type": "object",
//   ///     "properties": {
//   ///       "id": {
//   ///         "type": "integer",
//   ///         "format": "int64",
//   ///         "example": 10
//   ///       },
//   /// ```
//   /// [Order] and [id] are schemaName
//   final String schemaName;

//   /// the type of object schema [integer,string,etc]
//   final SchemaObjectType type;

//   /// format of the type eg.[int64,string,password]
//   final SchemaObjectFormat? format;

//   /// whether the object schema is nullable or not
//   final bool nullable;

//   ///if type is array items must not null
//   final SchemaObject? items;

//   ///example
//   ///``` "Order": {
//   ///       "type": "object",
//   ///       "properties": {
//   ///         "id": {
//   ///           "type": "integer",
//   ///           "format": "int64",
//   ///         },
//   ///```
//   final List<SchemaObject>? properties;

//   ///if type is object properties cannot be null
//   /// ```
//   /// "status": {
//   ///   "type": "string",
//   ///   "description": "Order Status",
//   ///   "example": "approved",
//   ///   "enum": [
//   ///     "placed",
//   ///     "approved",
//   ///     "delivered"
//   ///   ]
//   /// },
//   /// ```
//   final List<String>? enumField;

//   SchemaObject({
//     required this.schemaName,
//     this.externalDocs,
//     required this.type,
//     this.items,
//     this.format,
//     this.nullable = false,
//     this.discriminator,
//     this.properties,
//     this.enumField,
//   });

//   /// only to be use in component
//   Map<String, dynamic> toJson() {
//     Map<String, dynamic> map = {schemaName: {}};
//     map[schemaName]['type'] = type.type;

//     if (type != SchemaObjectType.object) {
//       if (format != null) {
//         map[schemaName]['format'] = format!.name;
//       }
//     } else {
//       if (properties != null) {
//         Map<String, dynamic> props = {};
//         for (var p in properties!) {
//           props.addAll(p.toJson());
//         }
//         map[schemaName]['properties'] = props;
//       }
//     }

//     return map;
//   }

//   /// To be used, for example, on `requestBody`.
//   Map<String, dynamic> toRefJson() {
//     Map<String, dynamic> map = {'schema': {}};

//     /// if type is object use ref`# $ref: '#/components/schemas/Pet'`
//     if (type == SchemaObjectType.object) {
//       map['schema']['\$ref'] = _getRef(schemaName);
//     } else {
//       map['schema']['type'] = type.type;
//       if (format != null && type != SchemaObjectType.array) {
//         map[schemaName]['format'] = format!.name;
//       }
//       if (type == SchemaObjectType.array) {
//         map['schemaName']['items'] = items!.toItemsJson();
//       }
//     }
//     return map;
//   }

//   /// To be used, on ContentObject
//   Map<String, dynamic> toContentJson() {
//     Map<String, dynamic> map = {'schema': {}};
//     if (type == SchemaObjectType.object) {
//       map['schema']['\$ref'] = _getRef(schemaName);
//     }
//     //
//     else if (type == SchemaObjectType.array) {
//       map['schema']['type'] = type.type;
//       map['schema']['items'] = {};
//       map['schema']['items']['\$ref'] = _getRef(schemaName);
//     }
//     return map;
//   }

//   /// To be used, for example, on `items`.
//   Map<String, dynamic> toItemsJson() {
//     Map<String, dynamic> map = {};
//     if (items != null) {
//       if (items!.type == SchemaObjectType.object) {
//         map['\$ref'] = _getRef(items!.schemaName);
//       } else {
//         map['type'] = items!.type;
//         if (items!.format != null) {
//           map['format'] = items!.format;
//         }
//       }
//     }
//     return map;
//   }

//   factory SchemaObject.fromClassDefinition(ClassDefinition classDefinition) {
//     List<SchemaObject> properties = [];
//     for (var field in classDefinition.fields) {
//       var prop = SchemaObject(
//           schemaName: field.name,
//           type: field.type.toSchemaObjectType,
//           format: field.type.toSchemaObjectFormat);
//       properties.add(prop);
//     }
//     return SchemaObject(
//         schemaName: classDefinition.className,
//         type: SchemaObjectType.object,
//         properties: properties);
//   }

//   /// call from [ResponseObject]
//   factory SchemaObject.fromMethod(MethodDefinition methodDefinition) {
//     ///return is Future<List<String>
//     ///return is Future<int>
//     ///return is Future<object>
//     SchemaObjectType? returnType;
//     String? schemaName;
//     var generics = methodDefinition.returnType.generics;
//     if (generics.first.className == 'List') {
//       returnType = generics.last.toSchemaObjectType;
//       schemaName = generics.last.className;
//     } else {
//       returnType = generics.first.toSchemaObjectType;
//       schemaName = generics.first.className;
//     }
//     return SchemaObject(schemaName: schemaName, type: returnType);
//   }
// }

class DiscriminatorObject {}

/// A Schema Object that will be used in ParameterObject
class ParameterSchemaObject {
  final TypeDefinition typeDefinition;

  ParameterSchemaObject(this.typeDefinition);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (typeDefinition.isEnum) {
      map['type'] = SchemaObjectType.string.name;
      map['enum'] = {};
      return map;
    }
    if (typeDefinition.isListType) {
      map['type'] = SchemaObjectType.array.name;
      map['items'] = {
        'type': typeDefinition.generics.first.toSchemaObjectType.name,
      };
      return map;
    }

    if ((typeDefinition.className == 'String') ||
        (typeDefinition.className == 'int') ||
        (typeDefinition.className == 'double')) {
      map['type'] = typeDefinition.toSchemaObjectType.name;
    }
    return map;
  }
}

/// A Schema Object that will be used in ContentObject
class ContentSchemaObject {
  /// Should be [returnType] from [MethodDefinition]
  final TypeDefinition returnType;

  ContentSchemaObject({
    required this.returnType,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    List<TypeDefinition> generics = returnType.generics;

    /// If type is [Map] set [SchemaObjectType] to [object]
    /// and should contain key [additionalProperties]
    /// If type is dart:core type
    /// ```
    ///   "type":"string",
    ///
    /// ```
    /// else
    /// ```
    /// "\$ref":"#/components/schemas/ComplexModel"
    /// ```
    ///
    if (returnType.generics.first.isMapType) {
      map['type'] = SchemaObjectType.object.name;
      if (returnType.generics.length > 1) {
        map['additionalProperties'] = ItemSchemaObject(
          generics.last,
          additionalProperties: true,
        ).toJson();
      }
      return map;
    }

    /// If type is [List] set [SchemaObjectType] to [array]
    /// and should contain key [items]
    /// example
    /// ```
    /// {
    ///   'type':'array',
    ///   'items':{
    ///      # 1. "type": "string"
    ///      # 2."type":"object"
    ///      #   "$ref": "#/components/schemas/ComplexModel"
    ///     }
    /// }
    /// ```
    if (generics.first.isListType) {
      map['type'] = SchemaObjectType.array.name;
      var items = ItemSchemaObject(generics.last);
      map['items'] = items.toJson();
      return map;
    }

    if (!generics.first.isDartCoreType) {
      map['type'] = SchemaObjectType.object.name;
      map['\$ref'] = _getRef(generics.first.className);
      return map;
    } else {
      map['type'] = generics.first.toSchemaObjectType.name;
    }

    /// Binary file and an arbitrary binary file can omit schema .Just return {}
    return map;
  }
}

/// A SchemaObject used in [items]
class ItemSchemaObject {
  /// Use in Map items if true remove type.
  final bool additionalProperties;
  final TypeDefinition typeDefinition;

  ItemSchemaObject(this.typeDefinition, {this.additionalProperties = false});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    ///if type is custom class return ref
    if (!typeDefinition.isDartCoreType) {
      if (!additionalProperties) {
        map['type'] = SchemaObjectType.object.name;
      }
      map['\$ref'] = _getRef(typeDefinition.className);
    } else {
      map['type'] = typeDefinition.toSchemaObjectType.name;
    }

    return map;
  }
}

/// A SchemaObject that will use in Request
class RequestSchemaObject {
  final TypeDefinition typeDefinition;
  RequestSchemaObject({
    required this.typeDefinition,
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    /// If type is [Map] set [SchemaObjectType] to [object]
    /// and should contain key [additionalProperties]
    /// If type is dart:core type
    /// ```
    ///   "type":"string",
    ///
    /// ```
    /// else
    /// ```
    /// "\$ref":"#/components/schemas/ComplexModel"
    /// ```
    ///
    if (typeDefinition.isMapType) {
      map['type'] = SchemaObjectType.object.name;
      if (typeDefinition.generics.length > 1) {
        map['additionalProperties'] = ItemSchemaObject(
          typeDefinition.generics.last,
          additionalProperties: true,
        ).toJson();
      }
      return map;
    }

    /// If type is [List] set [SchemaObjectType] to [array]
    /// and should contain key [items]
    /// example
    /// ```
    /// {
    ///   'type':'array',
    ///   'items':{
    ///      # 1. "type": "string"
    ///      # 2."type":"object"
    ///      #   "$ref": "#/components/schemas/ComplexModel"
    ///     }
    /// }
    /// ```
    if (typeDefinition.isListType) {
      map['type'] = SchemaObjectType.array.name;
      var items = ItemSchemaObject(typeDefinition.generics.last);
      map['items'] = items.toJson();
      return map;
    }

    if (!typeDefinition.isDartCoreType) {
      map['\$ref'] = _getRef(typeDefinition.className);
      return map;
    }

    /// Binary file and an arbitrary binary file can omit schema .Just return {}
    return map;
  }
}

/// A simple object to allow referencing other components in the OpenAPI document,
/// internally and externally.
/// The $ref string value contains a URI RFC3986, which identifies the location of the value being referenced.
class ReferenceObject {
  /// The reference identifier. This must be in the form of a URI.
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
      '\$ref': _getRef(ref),
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
/// A Path Item may be empty, due to ACL constraints.
/// The path itself is still exposed to the documentation viewer
/// but they will not know which operations and parameters are available.
class PathItemObject {
  /// Allows for a referenced definition of this path item.
  /// The referenced structure must be in the form of a Path Item Object.
  /// In case a Path Item Object field appears both in the defined object and the referenced object, the behavior is undefined.
  /// See the rules for resolving Relative References.
  final String? ref;

  /// An optional, string summary, intended to apply to all operations in this path.
  final String? summary;

  /// An optional, string description, intended to apply to all operations in this path. CommonMark syntax may be used for rich text representation.
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

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (summary != null) {
      map['summary'] = summary;
    }
    if (description != null) {
      map['description'] = description;
    }

    if (postOperation != null) {
      map['post'] = postOperation!.toJson();
    }

    if (ref != null) {
      map['\$ref'] = _getRef(ref!);
    }

    return map;
  }

  factory PathItemObject.fromMethod(MethodDefinition method, String tag) {
    String? description = method.documentationComment;
    String operationId = method.name;
    ResponseObject responseObject = ResponseObject(
      responseType: ContentObject(
        contentTypes: [ContentType.applicationJson],
        schemaObject: ContentSchemaObject(
          returnType: method.returnType,
        ),
      ),
    );

    return PathItemObject(
      description: description,
      postOperation: OperationObject(
        description: description,
        operationId: operationId,
        responses: responseObject,
        tags: [tag],
        // requestBody: RequestBodyObjec,
        security: SecurityRequirementObject(),
      ),
    );
  }
}

/// Describes a single API operation on a path.
class OperationObject {
  /// A list of tags for API documentation control. Tags can be used for logical grouping of operations by resources or any other qualifier.
  final List<String>? tags;

  /// A short summary of what the operation does.
  final String? summary;

  final String? description;

  final ExternalDocumentationObject? externalDocs;

  /// Unique string used to identify the operation.The id must be unique among
  /// all operations described in the API.The operationId value is
  /// case-sensitive. Tools and libraries may use the operationId to uniquely
  /// identify an operation, therefore, it is recommended to follow common
  /// programming naming conventions. It should be serverpod endpoint's method
  /// name eg ``` findPetById ```
  final String? operationId;

  /// A list of parameters that are applicable for this operation.
  /// If a parameter is already defined at the Path Item, the new definition
  /// will override it but can never remove it. The list must not include
  /// duplicated parameters. A unique parameter is defined by a combination of
  /// a name and location.The list can use the Reference Object to link to
  /// parameters that are defined at the OpenAPI Object's components/parameters.
  final List<ParameterObject>? parameters;

  /// The request body applicable for this operation.
  /// The requestBody is fully supported in HTTP methods where the HTTP 1.1
  /// specification RFC7231 has explicitly defined semantics for request bodies.
  /// In other cases where the HTTP spec is vague
  /// (such as GET, HEAD and DELETE),
  /// requestBody is permitted but does not have well-defined semantics
  /// and should be avoided if possible.
  final RequestBodyObject? requestBody;

  /// The list of possible responses as they are returned from executing
  /// this operation.
  final ResponseObject responses;

  /// Declares this operation to be deprecated. Consumers should refrain
  /// from usage of the declared operation.
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

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'operationId': operationId,
    };

    if (tags?.isNotEmpty ?? false) {
      map['tags'] = tags!;
    }

    if (summary != null) {
      map['summary'] = summary;
    }

    if (description != null) {
      map['description'] = description;
    }
    if (externalDocs != null) {
      map['externalDocs'] = externalDocs;
    }

    if (requestBody != null) {
      map['requestBody'] = requestBody!.toJson();
    }

    if (parameters?.isNotEmpty ?? false) {
      map['parameters'] = parameters!.map((e) => e.toJson()).toList();
    }
    map['responses'] = responses.toJson();

    return map;
  }
}
