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
abstract base class MethodDefinition {
  /// The name of the method.
  final String name;

  /// The documentation of this method.
  final String? documentationComment;

  /// The annotations of this method.
  final List<AnnotationDefinition> annotations;

  /// The returned type of this method.
  /// This should always be a future.
  final TypeDefinition returnType;

  /// The required positional parameters of this method.
  final List<ParameterDefinition> parameters;

  /// The optional positional parameters of this method.
  final List<ParameterDefinition> parametersPositional;

  /// The named parameters of this method.
  final List<ParameterDefinition> parametersNamed;

  List<ParameterDefinition> get allParameters => [
        ...parameters,
        ...parametersPositional,
        ...parametersNamed,
      ];

  const MethodDefinition({
    required this.name,
    required this.documentationComment,
    required this.annotations,
    required this.returnType,
    required this.parameters,
    required this.parametersPositional,
    required this.parametersNamed,
  });
}

/// Describes a single callable method in a [EndpointDefinition].
final class MethodCallDefinition extends MethodDefinition {
  /// Creates a new [MethodCallDefinition].
  const MethodCallDefinition({
    required super.name,
    required super.documentationComment,
    required super.annotations,
    required super.parameters,
    required super.parametersPositional,
    required super.parametersNamed,
    required super.returnType,
  });
}

/// Describes a single streaming method in a [EndpointDefinition].
final class MethodStreamDefinition extends MethodDefinition {
  MethodStreamDefinition({
    required super.name,
    required super.documentationComment,
    required super.annotations,
    required super.returnType,
    required super.parameters,
    required super.parametersPositional,
    required super.parametersNamed,
  });
}

/// Describes a single parameter of a [MethodCallDefinition].
class ParameterDefinition {
  /// The variable name of the parameter.
  final String name;

  /// The type of the parameter.
  final TypeDefinition type;

  /// Whether this parameter is required.
  final bool required;

  /// Create a new [ParameterDefinition].
  const ParameterDefinition({
    required this.name,
    required this.type,
    required this.required,
  });
}

/// Describes an annotation.
class AnnotationDefinition {
  final String name;

  /// The arguments of the annotation.
  /// Null means no arguments and no parenthesis; empty list means no arguments but with parenthesis.
  /// Arguments must be valid Dart literals.
  final List<String>? arguments;

  /// If set, this rule will be injected as an analyzer ignore directive on
  /// the line preceeding internally generated method call sites.
  /// This can be useful for suppressing deprecated method invocation
  ///  within the generated server code.
  final String? methodCallAnalyzerIgnoreRule;

  const AnnotationDefinition({
    required this.name,
    this.arguments,
    this.methodCallAnalyzerIgnoreRule,
  });
}
