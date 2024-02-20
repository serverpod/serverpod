import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().withAuthModule().build();

  test(
      'Given a module class with the same name as a user defined class then there is no name conflict reported.',
      () {
    var models = [
      ModelSourceBuilder()
          .withModuleAlias('auth')
          .withFileName('user_info')
          .withYaml(
        '''
        class: UserInfo
        table: serverpod_user_info
        fields:
          nickname: String
        ''',
      ).build(),
      ModelSourceBuilder()
          .withModuleAlias('protocol')
          .withFileName('user_info')
          .withYaml(
        '''
        class: UserInfo
        table: user_info
        fields:
          name: String
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    analyzer.validateAll();
    var errors = collector.errors;

    expect(errors, isEmpty);
  });
}
