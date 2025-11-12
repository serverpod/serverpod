import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/element_extensions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/extension/endpoint_parameters_extension.dart';

import 'package:serverpod_cli/src/generator/types.dart';

abstract class EndpointParameterAnalyzer {
  /// Parses a [ParameterElement] into a [ParameterDefinition].
  /// Assumes that the [ParameterElement] is a valid endpoint parameter.
  static Parameters parse(
    List<FormalParameterElement> parameters,
  ) {
    var requiredParameters = <ParameterDefinition>[];
    var positionalParameters = <ParameterDefinition>[];
    var namedParameters = <ParameterDefinition>[];

    var filteredParameters = parameters.withoutSessionParameter;
    for (var parameter in filteredParameters) {
      var definition = ParameterDefinition(
        name: parameter.name!,
        required: _isRequired(parameter),
        type: TypeDefinition.fromDartType(parameter.type),
      );

      if (parameter.isRequiredPositional) {
        requiredParameters.add(definition);
      } else if (parameter.isOptionalPositional) {
        positionalParameters.add(definition);
      } else if (parameter.isNamed) {
        namedParameters.add(definition);
      }
    }

    return Parameters(
      required: requiredParameters,
      positional: positionalParameters,
      named: namedParameters,
    );
  }

  /// Validates a list of [ParameterElement] and returns a list of errors.
  static List<SourceSpanSeverityException> validate(
    List<FormalParameterElement> parameters,
  ) {
    List<SourceSpanSeverityException> exceptions = [];

    if (!parameters.isFirstRequiredParameterSession) {
      exceptions.add(
        SourceSpanSeverityException(
          'The first parameter of an endpoint method must be a required positional parameter of type "Session".',
          parameters.first.span,
          severity: SourceSpanSeverity.error,
        ),
      );
      return exceptions;
    }

    if (parameters.isSessionParameterNullable) {
      exceptions.add(
        SourceSpanSeverityException(
          'The "Session" argument in an endpoint method does not have to be nullable, consider making it non-nullable.',
          parameters.first.span,
          severity: SourceSpanSeverity.hint,
        ),
      );
    }

    exceptions.addAll(
      parameters.map((parameter) {
        var type = parameter.type;
        if (type.isDartAsyncFuture) {
          return SourceSpanSeverityException(
            'The type "Future" is not a supported endpoint parameter type.',
            parameter.span,
          );
        }

        if (type.isDartAsyncStream && type is ParameterizedType) {
          if (type.nullabilitySuffix != NullabilitySuffix.none) {
            return SourceSpanSeverityException(
              'Nullable parameters of the type "Stream" are not supported.',
              parameter.span,
            );
          }

          var typeArguments = type.typeArguments;
          if (typeArguments.length != 1) {
            // Streams only allow a single generic so this case is only here for safety.
            return SourceSpanSeverityException(
              'The type "Stream" must have exactly one type argument. E.g. Stream<String>.',
              parameter.span,
            );
          }
          var innerType = typeArguments[0];
          if (innerType is VoidType) {
            return SourceSpanSeverityException(
              'The type "Stream" does not support void generic type.',
              parameter.span,
            );
          }
        }

        try {
          TypeDefinition.fromDartType(parameter.type);
        } on FromDartTypeClassNameException catch (e) {
          return SourceSpanSeverityException(
            'The type "${e.type}" is not a supported endpoint parameter type.',
            parameter.span,
          );
        }

        return null;
      }).whereType<SourceSpanSeverityException>(),
    );

    return exceptions;
  }

  static bool _isRequired(FormalParameterElement parameter) {
    if (parameter.isRequiredPositional) {
      return true;
    }

    if (parameter.isRequiredNamed) {
      return true;
    }

    if (parameter.isNamed &&
        parameter.type.nullabilitySuffix == NullabilitySuffix.none) {
      return true;
    }

    return false;
  }
}

class Parameters {
  final List<ParameterDefinition> required;
  final List<ParameterDefinition> positional;
  final List<ParameterDefinition> named;

  Parameters({
    required this.required,
    required this.positional,
    required this.named,
  });
}
