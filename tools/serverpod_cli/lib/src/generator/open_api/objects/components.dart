part of '../open_api_objects.dart';

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

  /// An object to hold reusable Request Body Objects.
  final Map<String, RequestBodyObject>? requestBodies;

  /// An object to hold reusable Security Scheme Objects.
  final Map<String, SecuritySchemeObject>? securitySchemes;

  /// An object to hold reusable Path Item Object.
  final Map<String, PathItemObject>? pathItems;
  ComponentsObject({
    this.schemas,
    this.responses,
    this.parameters,
    this.requestBodies,
    this.securitySchemes,
    this.pathItems,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    if (schemas != null) {
      map['schemas'] = _getSchemaMapFromSetSchema(schemas!);
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
