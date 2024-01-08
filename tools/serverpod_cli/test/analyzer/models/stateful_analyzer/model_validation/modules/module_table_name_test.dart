import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a module class with the same table name as a user defined table then there is an error reported.',
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
        class: User
        table: serverpod_user_info
        fields:
          name: String
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      models,
      onErrorsCollector(collector),
    );
    analyzer.validateAll();
    var errors = collector.errors;

    expect(errors, isNotEmpty);

    expect(
      errors.first.message,
      contains(
        'The table name "serverpod_user_info" is already in use by the class "UserInfo".',
      ),
    );
  });

  test(
      'Given a table with a name longer than 56 characters then there is an error reported.',
      () {
    var models = [
      ModelSourceBuilder().withFileName('user').withYaml(
        '''
        class: User
        table: this_table_name_is_very_long_and_exceeds_the_56_character_limit
        fields:
          nickname: String
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      models,
      onErrorsCollector(collector),
    );
    analyzer.validateAll();
    var errors = collector.errors;

    expect(errors, isNotEmpty);

    expect(
      errors.first.message,
      contains(
        'The table name "this_table_name_is_very_long_and_exceeds_the_56_character_limit" exceeds the 56 character table name limitation.',
      ),
    );
  });
}
