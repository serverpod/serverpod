import 'package:serverpod_cli/src/generator/open_api/helpers/utils.dart';
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
class OpenAPIComponents {
  /// A set of reusable [OpenAPIComponentSchema].that can be
  /// referenced.
  final Set<OpenAPIComponentSchema> schemas;

  /// A mapping that associates response names with reusable [OpenAPIResponse]
  /// eg
  /// ```json
  ///  "NotFound": {
  ///    "description": "Entity not found."
  ///  },
  /// ```
  final Map<String, OpenAPIResponse>? responses;

  /// A collection of reusable [OpenAPIParameter].that can be
  /// referenced.
  final Map<String, OpenAPIParameter>? parameters;

  /// A collection of reusable [OpenAPIRequestBody].that can be
  /// referenced.
  final Map<String, OpenAPIRequestBody>? requestBodies;

  /// A collection of reusable [OpenAPISecurityRequirement] that can be
  /// referenced.
  final Set<OpenAPISecurityRequirement> securitySchemes;

  /// A mapping that associates path name with reusable [OpenAPIPathItem].
  final Map<String, OpenAPIPathItem>? pathItems;
  OpenAPIComponents({
    required this.schemas,
    this.responses,
    this.parameters,
    this.requestBodies,
    required this.securitySchemes,
    this.pathItems,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    Map<String, dynamic> schemasMap = {};
    for (var schema in schemas) {
      schemasMap.addAll(schema.toJson());
    }

    map[OpenAPIJsonKey.schemas.name] = schemasMap;
    if (securitySchemes.isNotEmpty) {
      var securityMap = <String, dynamic>{};
      for (var security in securitySchemes) {
        securityMap.addAll(security.toJson());
      }
      map[OpenAPIJsonKey.securitySchemes.name] = securityMap;
    }

    return map;
  }
}
