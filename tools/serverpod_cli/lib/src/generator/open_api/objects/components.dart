part of '../open_api_objects.dart';

/// Holds a set of reusable objects for different aspects of the OAS.
/// All objects defined within the components object will have no effect
/// on the API unless they are explicitly referenced from properties outside the
/// components object.
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
  final Set<SecurityRequirementObject> securitySchemes;

  /// An object to hold reusable Path Item Object.
  final Map<String, PathItemObject>? pathItems;
  ComponentsObject({
    this.schemas,
    this.responses,
    this.parameters,
    this.requestBodies,
    required this.securitySchemes,
    this.pathItems,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    if (schemas != null) {
      Map<String, dynamic> schemasMap = {};
      for (var schema in schemas!) {
        schemasMap.addAll(schema.toJson());
      }
      map['schemas'] = schemasMap;
    }
    if (securitySchemes.isNotEmpty) {
      var securityMap = <String, dynamic>{};
      for (var security in securitySchemes) {
        securityMap.addAll(security.toJson());
      }
      map['securitySchemes'] = securityMap;
    }
    return map;
  }
}
