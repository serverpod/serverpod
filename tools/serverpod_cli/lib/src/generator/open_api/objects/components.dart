import 'package:serverpod_cli/src/generator/open_api/objects/parameter.dart';
import 'package:serverpod_cli/src/generator/open_api/objects/paths.dart';
import 'package:serverpod_cli/src/generator/open_api/objects/request.dart';
import 'package:serverpod_cli/src/generator/open_api/objects/response.dart';
import 'package:serverpod_cli/src/generator/open_api/objects/schema.dart';
import 'package:serverpod_cli/src/generator/open_api/objects/security.dart';

/// Holds a set of reusable objects for different aspects of the OAS.
/// All objects defined within the components object will have no effect
/// on the API unless they are explicitly referenced from properties outside the
/// components object.
class ComponentsObject {
  /// A set of reusable [ComponentSchemaObject].that can be
  /// referenced.
  final Set<ComponentSchemaObject>? schemas;

  /// A mapping that associates response names with reusable [ResponseObject]
  /// eg
  /// ```json
  ///  "NotFound": {
  ///    "description": "Entity not found."
  ///  },
  /// ```
  final Map<String, ResponseObject>? responses;

  /// A collection of reusable [ParameterObject].that can be
  /// referenced.
  final Map<String, ParameterObject>? parameters;

  /// A collection of reusable [RequestBodyObject].that can be
  /// referenced.
  final Map<String, RequestBodyObject>? requestBodies;

  /// A collection of reusable [SecurityRequirementObject] that can be
  /// referenced.
  final Set<SecurityRequirementObject> securitySchemes;

  /// A mapping that associates path name with reusable [PathItemObject].
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
