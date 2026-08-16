import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';
import '../../generator/types.dart';
import '../models/definitions.dart';

/// Describes a single future call.
class FutureCallDefinition {
  /// Create a new [FutureCallDefinition].
  const FutureCallDefinition({
    required this.name,
    required this.documentationComment,
    required this.methods,
    required this.className,
    required this.filePath,
    required this.annotations,
    required this.isAbstract,
  });

  /// The name of the future call.
  final String name;

  /// The documentation of the future call.
  final String? documentationComment;

  /// The actual class name of the future call.
  final String className;

  /// The file path, the future call is stored in.
  final String filePath;

  /// The methods this future call defines.
  final List<FutureCallMethodDefinition> methods;

  /// The annotations of this future call.
  final List<AnnotationDefinition> annotations;

  /// Whether this future call is abstract.
  final bool isAbstract;

  /// The name of the external package where this future call is defined. Will
  /// return null if the future call comes from the project under generation.
  String? get packageName => filePath.startsWith('package:')
      ? filePath.split('/').first.split(':').last
      : null;
}

/// Describes a single callable method in a [FutureCallDefinition].
final class FutureCallMethodDefinition extends MethodDefinition {
  /// The optional parameter that will be generated from other
  /// valid Dart types to implement [SerializableModel] interface.
  final FutureCallParameterDefinition? futureCallMethodParameter;

  /// Creates a new [FutureCallMethodDefinition].
  const FutureCallMethodDefinition({
    required super.name,
    required super.documentationComment,
    required super.annotations,
    required super.parameters,
    required super.parametersPositional,
    required super.parametersNamed,
    required super.returnType,
    required this.futureCallMethodParameter,
  });
}

/// Describes parameters of a [FutureCallMethodDefinition]
/// which should be used to generate [SerializableModel] interfaces.
class FutureCallParameterDefinition {
  /// The variable name of the parameter.
  final String name;

  /// The type of the parameter.
  final TypeDefinition type;

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

  /// Create a new [FutureCallParameterDefinition].
  const FutureCallParameterDefinition({
    required this.name,
    required this.type,
    required this.parameters,
    required this.parametersPositional,
    required this.parametersNamed,
  });

  SerializableModelDefinition toSerializableModel() {
    return ModelClassDefinition(
      fileName: p.join(
        'future_calls_generated_models',
        type.className.snakeCase,
      ),
      sourceFileName: '',
      className: type.className,
      fields: [
        for (final parameter in allParameters)
          SerializableModelFieldDefinition(
            name: parameter.name,
            isRequired: true,
            type: parameter.type,
            scope: ModelFieldScopeDefinition.serverOnly,
            shouldPersist: false,
          ),
      ],
      serverOnly: true,
      manageMigration: false,
      type: type,
      isSealed: false,
      isImmutable: false,
    );
  }
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

  /// The file path, the endpoint is stored in. For endpoint definitions of
  /// external modules (evaluated for inheritance parsing), this will be the
  /// library identifier - with format "package:{packageName}/{path}".
  final String filePath;

  /// The methods this endpoint defines.
  final List<MethodDefinition> methods;

  /// The annotations of this endpoint.
  final List<AnnotationDefinition> annotations;

  /// Whether this endpoint is abstract.
  final bool isAbstract;

  /// The parent of this endpoint if it exists.
  final EndpointDefinition? extendsClass;

  /// Create a new [EndpointDefinition].
  const EndpointDefinition({
    required this.name,
    required this.documentationComment,
    required this.methods,
    required this.className,
    required this.filePath,
    required this.annotations,
    required this.isAbstract,
    required this.extendsClass,
  });

  /// The name of the external package where this endpoint is defined. Will
  /// return null if the endpoint comes from the project under generation.
  String? get packageName => filePath.startsWith('package:')
      ? filePath.split('/').first.split(':').last
      : null;
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

  /// The default value of this parameter, if any.
  final String? defaultValue;

  /// The annotations of this parameter.
  final List<AnnotationDefinition> annotations;

  /// Create a new [ParameterDefinition].
  const ParameterDefinition({
    required this.name,
    required this.type,
    required this.required,
    required this.annotations,
    this.defaultValue,
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

extension HasAnnotation on List<AnnotationDefinition> {
  bool has(String name) => any((e) => e.name == name);
}
