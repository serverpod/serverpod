import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';

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

abstract class ParameterAnalyzer {
  static Parameters? analyze(
    List<ParameterElement> parameters,
    CodeAnalysisCollector collector,
  ) {
    var requiredParameters = <ParameterDefinition>[];
    var positionalParameters = <ParameterDefinition>[];
    var namedParameters = <ParameterDefinition>[];

    for (var parameter in parameters) {
      var definition = ParameterDefinition(
        name: parameter.name,
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

  static bool _isRequired(ParameterElement parameter) {
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
