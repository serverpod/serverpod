import 'package:serverpod_cli/src/analyzer/entities/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/protocol_source_builder.dart';
import 'package:test/test.dart';

void main() {
  test('test name', () {
    var protocols = [
      ProtocolSourceBuilder()
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
      ProtocolSourceBuilder()
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
      protocols,
      onErrorsCollector(collector),
    );
    analyzer.validateAll();
    var errors = collector.errors;

    expect(errors, isEmpty);
  });
}
