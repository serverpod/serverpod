import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
      'Given a model class with a primitive record field, then no errors are collected.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: MyModel
        fields:
          testField: (String, int)
          testField2: (int,)
          testField3: (int,int,)
          testField4: (int, {String named})
          testField5: (  int  ,   {    String   named  ,  }  )
          testField6: (  int  ,   ({    String   named  ,  } nestedRecord) )
          testField7: (String?,)
          testField8: (String,)?
          testField9: List<(String,)>?
          testField10: List<(String,)?>
        ''',
      ).build()
    ];

    (
      int, {
      String named,
    })? x = (2, named: '3');

    var collector = CodeGenerationCollector();
    final analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    analyzer.validateAll();

    expect(
      collector.errors,
      isEmpty,
      // reason: 'Expected no errors but some were generated.',
    );

    var definitions = analyzer.validateAll();

    var userDefinition = definitions.first as ClassDefinition;
    var addressDefinition = definitions.last as ClassDefinition;

    // group('then the successor field relation', () {
    //   var field = userDefinition?.findField('successor');
    //   var relation = field?.relation;

    //   test('name is null', () {
    //     expect(relation?.name, isNull);
    //   });

    //   test('is foreign key origin', () {
    //     expect(relation?.isForeignKeyOrigin, isTrue);
    //   });

    //   test('is of type ObjectRelationDefinition', () {
    //     expect(relation.runtimeType, ObjectRelationDefinition);
    //   });

    //   test('has the parent table set to it self.', () {
    //     relation as ObjectRelationDefinition;

    //     expect(relation.parentTable, 'user');
    //   });
  });

  // valid types (Uuid, DateTime, other model class, module class (why not DOT syntax?))
  // invalid / unknown types which would also not be allowed for classes
  // Support (int,) but not just (int)
  // test with nullability (interspersed and globally); "(String,)   ?" is also a valid nullable
  // test various cases where braces don't match etc.
  // Model name `Record` should not be allowed
}
