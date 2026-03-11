import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/element_extensions.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/annotation.dart';
import 'package:serverpod_cli/src/analyzer/dart/parameters.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/types.dart';

abstract class FutureCallParameterAnalyzer {
  /// Parses a list of [FormalParameterElement] into a [Parameters].
  /// Assumes that the list of [FormalParameterElement] contains valid future call parameters.
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
        defaultValue: parameter.defaultValueCode,
        annotations: parameter.futureCallAnnotations,
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

  /// Validates a list of [FormalParameterElement] and returns a list of errors.
  ///
  /// The [analyzedModels] parameter are the validated models from a previous
  /// call to [StatefulAnalyzer.validateAll].
  static List<SourceSpanSeverityException> validate(
    List<FormalParameterElement> parameters,
    List<SerializableModelDefinition> analyzedModels,
  ) {
    List<SourceSpanSeverityException> exceptions = [];

    if (!parameters.isFirstRequiredParameterSession) {
      exceptions.add(
        SourceSpanSeverityException(
          'The first parameter of a future call method must be a required positional parameter of type "Session".',
          parameters.firstOrNull?.span,
        ),
      );
      return exceptions;
    }

    if (parameters.isSessionParameterNullable) {
      exceptions.add(
        SourceSpanSeverityException(
          'The "Session" argument in a future call method does not have to be nullable, consider making it non-nullable.',
          parameters.first.span,
          severity: SourceSpanSeverity.hint,
        ),
      );
    }

    exceptions.addAll(
      parameters.withoutSessionParameter.map((parameter) {
        var type = parameter.type;

        if (!_isValidParameter(parameter, analyzedModels)) {
          return SourceSpanSeverityException(
            'The type "$type" is not a supported future call parameter type.',
            parameter.span,
          );
        }

        if (type.isDartAsyncFuture) {
          return SourceSpanSeverityException(
            'The type "Future" is not a supported future call parameter type.',
            parameter.span,
          );
        }

        if (type.isDartAsyncStream) {
          return SourceSpanSeverityException(
            'The type "Stream" is not a supported future call parameter type.',
            parameter.span,
          );
        }

        try {
          TypeDefinition.fromDartType(parameter.type);
        } on FromDartTypeClassNameException catch (e) {
          return SourceSpanSeverityException(
            'The type "${e.type}" is not a supported future call parameter type.',
            parameter.span,
          );
        }

        return null;
      }).whereType<SourceSpanSeverityException>(),
    );

    return exceptions;
  }

  static bool _isValidParameter(
    FormalParameterElement parameter,
    List<SerializableModelDefinition> models,
  ) {
    return _isValidType(
      TypeDefinition.fromDartType(parameter.type),
      models,
    );
  }

  static bool _isValidType(
    TypeDefinition type,
    List<SerializableModelDefinition> models,
  ) {
    return (type.isSerializableDartType &&
            type.generics.every((t) => _isValidType(t, models))) ||
        _isSerializableModel(type) ||
        _isModelType(type, models) ||
        _isRecordType(type, models);
  }

  static bool _isSerializableModel(TypeDefinition type) {
    return type.className == 'SerializableModel';
  }

  static bool _isModelType(
    TypeDefinition type,
    List<SerializableModelDefinition> models,
  ) {
    return models.any((model) => model.className == type.className);
  }

  static bool _isRecordType(
    TypeDefinition type,
    List<SerializableModelDefinition> models,
  ) {
    return type.isRecordType &&
        type.generics.every((t) => _isValidType(t, models));
  }

  static bool _isRequired(FormalParameterElement parameter) {
    if (parameter.isRequiredPositional) {
      return true;
    }

    if (parameter.isRequiredNamed) {
      return true;
    }

    return false;
  }
}
