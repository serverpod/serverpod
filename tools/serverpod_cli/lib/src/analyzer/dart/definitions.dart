import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_cli/src/analyzer/yaml/file_analyzer.dart';

import '../../generator/types.dart';

/// Defines a projects protocol.
/// This does not include stuff the [ProtocolYamlFileAnalyzer] analyzed.
class ProtocolDefinition {
  /// The endpoints that are a part of this protocol.
  /// This does not include endpoints from other modules or package:serverpod.
  final List<EndpointDefinition> endpoints;

  /// The file paths the [endpoints] are defined in.
  //TODO: Maybe this should be part of the endpoint definition.
  final List<String> filePaths;

  /// Create a new [ProtocolDefinition].
  const ProtocolDefinition({
    required this.endpoints,
    required this.filePaths,
  });
}

/// Describes a single endpoint.
///
/// See also:
/// - [ProtocolDefinition]
class EndpointDefinition {
  /// The name of the endpoint.
  final String name;

  /// The documentation of the endpoint.
  final String? documentationComment;

  /// The actual class name of the endpoint.
  final String className;

  /// The file name, the endpoint is stored in.
  final String fileName;

  /// The methods this endpoint defines.
  final List<MethodDefinition> methods;

  /// The subdirectory this endpoints dart file is stored in,
  /// or null.
  final String? subDir;

  /// Create a new [EndpointDefinition].
  const EndpointDefinition({
    required this.name,
    required this.documentationComment,
    required this.methods,
    required this.className,
    required this.fileName,
    required this.subDir,
  });
}

/// Describes a single method in a [EndpointDefinition].
class MethodDefinition {
  /// The name of the method.
  final String name;

  /// The documentation of this method.
  final String? documentationComment;

  /// The returned type of this method.
  /// This should always be a future.
  final TypeDefinition returnType;

  /// The required positional parameters of this method.
  final List<ParameterDefinition> parameters;

  /// The optional positional parameters of this method.
  final List<ParameterDefinition> parametersPositional;

  /// The named parameters of this method.
  final List<ParameterDefinition> parametersNamed;

  /// Creates a new [MethodDefinition].
  const MethodDefinition(
      {required this.name,
      required this.documentationComment,
      required this.parameters,
      required this.parametersPositional,
      required this.parametersNamed,
      required this.returnType});
}

/// Describes a single parameter of a [MethodDefinition].
class ParameterDefinition {
  /// The variable name of the parameter.
  final String name;

  /// The type of the parameter.
  final TypeDefinition type;

  /// Whether this parameter is required.
  final bool required;

  /// Maybe the actual element received by the analyzer.
  final ParameterElement? dartParameter;

  /// Create a new [ParameterDefinition].
  const ParameterDefinition({
    required this.name,
    required this.type,
    required this.required,
    this.dartParameter,
  });
}
