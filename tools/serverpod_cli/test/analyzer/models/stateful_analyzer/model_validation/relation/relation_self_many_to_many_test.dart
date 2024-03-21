import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
      'Given a class with an implicit many to many relation then an error is collected that it is not supported.',
      () {
    var models = [
      ModelSourceBuilder().withFileName('member').withYaml(
        '''
        class: Member
        table: member
        fields:
          name: String
          blocked: List<Member>?, relation(name=blocking)
          blockedBy: List<Member>?, relation(name=blocking)
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    analyzer.validateAll();
    var errors = collector.errors;

    expect(errors, isNotEmpty);
    expect(
      errors.first.message,
      contains('A named relation to another list field is not supported.'),
    );
  });
}
