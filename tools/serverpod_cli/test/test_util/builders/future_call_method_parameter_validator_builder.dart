import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/validator.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/config.dart';

import 'generator_config_builder.dart';

class FutureCallMethodParameterValidatorBuilder {
  GeneratorConfig _config;
  StatefulAnalyzer _modelAnalyzer;

  FutureCallMethodParameterValidatorBuilder()
    : _config = GeneratorConfigBuilder().build(),
      _modelAnalyzer = StatefulAnalyzer(GeneratorConfigBuilder().build(), []);

  FutureCallMethodParameterValidatorBuilder withGeneratorConfig(
    GeneratorConfig config,
  ) {
    _config = config;
    return this;
  }

  FutureCallMethodParameterValidatorBuilder withModelAnalyzer(
    StatefulAnalyzer analyzer,
  ) {
    _modelAnalyzer = analyzer;
    return this;
  }

  FutureCallMethodParameterValidator build() {
    return FutureCallMethodParameterValidator(
      config: _config,
      modelAnalyzer: _modelAnalyzer,
    );
  }
}
