import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart'
    show ParameterDefinition;
import 'package:serverpod_cli/src/analyzer/dart/keywords.dart';

class Parameters {
  final List<ParameterDefinition> required;
  final List<ParameterDefinition> positional;
  final List<ParameterDefinition> named;

  Parameters({
    required this.required,
    required this.positional,
    required this.named,
  });

  List<ParameterDefinition> get allParameters => [
    ...required,
    ...positional,
    ...named,
  ];
}

/// Extension for [List<ParameterElement>] to analyze endpoint parameters.
extension ParametersExtension on List<FormalParameterElement> {
  /// Returns true if the first required parameter is a session parameter.
  bool get isFirstRequiredParameterSession {
    if (isEmpty) return false;

    var parameter = first;

    return parameter.type.element?.displayName == Keyword.sessionClassName &&
        parameter.isRequiredPositional;
  }

  bool get isSessionParameterNullable {
    return first.type.nullabilitySuffix != NullabilitySuffix.none;
  }

  /// Returns a list of parameters without the session parameter.
  List<FormalParameterElement> get withoutSessionParameter {
    return where(
      (parameter) =>
          parameter.type.element?.displayName != Keyword.sessionClassName,
    ).toList();
  }
}
