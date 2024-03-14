import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().withAuthModule().build();
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
      config,
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
        table: this_table_name_is_exactly_57_characters_long_and_invalid
        fields:
          nickname: String
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
      contains(
        'The table name "this_table_name_is_exactly_57_characters_long_and_invalid" exceeds the 56 character table name limitation.',
      ),
    );
  });

  group('Given a table with a name that is 56 characters when analyzing models',
      () {
    var models = [
      ModelSourceBuilder().withFileName('user').withYaml(
        '''
        class: User
        table: this_table_name_is_exactly_56_characters_long_and_valid_
        fields:
          nickname: String
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();

    var errors = collector.errors;

    test('then no errors are collected.', () {
      expect(errors, isEmpty);
    });

    var definition = definitions.firstOrNull as ClassDefinition?;

    test('then a table definition is created.', () {
      expect(definition?.tableName,
          'this_table_name_is_exactly_56_characters_long_and_valid_');
    }, skip: errors.isNotEmpty);
  });
}
