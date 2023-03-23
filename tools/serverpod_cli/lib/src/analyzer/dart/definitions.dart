import 'package:analyzer/dart/element/element.dart';

import '../../generator/types.dart';

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

  /// The file path, the endpoint is stored in.
  final String filePath;

  /// The methods this endpoint defines.
  final List<MethodDefinition> methods;

  /// The subdirectories this endpoints dart file is stored in,
  final List<String> subDirParts;

  /// Create a new [EndpointDefinition].
  const EndpointDefinition({
    required this.name,
    required this.documentationComment,
    required this.methods,
    required this.className,
    required this.filePath,
    required this.subDirParts,
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
