import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/generator/open_api/helpers/utils.dart';
import 'package:serverpod_cli/src/generator/open_api/objects/content.dart';
import 'package:serverpod_cli/src/generator/open_api/objects/schema.dart';

/// Describes a single request body.
class OpenAPIRequestBody {
  /// A brief description of the request body.
  final String? description;

  /// A list of parameters from a Serverpod's endpoint method, to be converted
  /// into the content of the request body.
  final List<ParameterDefinition> parameterList;

  /// Determines if the request body is required in the request.
  final bool requiredField;
  OpenAPIRequestBody({
    this.description,
    required this.parameterList,
    this.requiredField = true,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (description != null) map[OpenAPIJsonKey.description.name] = description;
    map[OpenAPIJsonKey.content.name] = OpenAPIContent(
      requestContentSchemaObject: RequestContentSchemaObject(
        params: parameterList,
      ),
    ).toJson();
    map['required'] = requiredField;
    return map;
  }
}
