import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';

class SourceSpanExceptionBuilder {
  GeneratorConfig? generatorConfig;
  List<ModelSource> models;

  SourceSpanExceptionBuilder({
    this.generatorConfig,
    Iterable<ModelSource>? models,
  }) : models = models?.toList() ?? [];

  SourceSpanExceptionBuilder withSourceFile(String fileName, String contents) {
    models.add(
      ModelSourceBuilder().withFileName(fileName).withYaml(contents).build(),
    );
    return this;
  }

  List<SourceSpanException> build() =>
      models.validateAll(generatorConfig: generatorConfig);
}

extension ModelSourceListExtension on List<ModelSource> {
  List<SourceSpanException> validateAll({GeneratorConfig? generatorConfig}) {
    var collector = CodeGenerationCollector();

    var analyzer = StatefulAnalyzer(
      generatorConfig ?? GeneratorConfigBuilder().build(),
      this,
      onErrorsCollector(collector),
    );
    analyzer.validateAll();

    return collector.errors;
  }
}
