import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/validator.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';

import 'generator_config_builder.dart';

class FutureCallMethodParameterValidatorBuilder {
  StatefulAnalyzer _modelAnalyzer;

  FutureCallMethodParameterValidatorBuilder()
    : _modelAnalyzer = StatefulAnalyzer(GeneratorConfigBuilder().build(), []);

  FutureCallMethodParameterValidatorBuilder withModelAnalyzer(
    StatefulAnalyzer analyzer,
  ) {
    _modelAnalyzer = analyzer;
    return this;
  }

  FutureCallMethodParameterValidator build() {
    return FutureCallMethodParameterValidator(
      modelAnalyzer: _modelAnalyzer,
    );
  }
}
