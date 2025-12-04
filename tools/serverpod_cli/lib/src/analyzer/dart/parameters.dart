import 'package:serverpod_cli/src/analyzer/dart/definitions.dart'
    show ParameterDefinition;

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
