import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given a model class with a record fields,', () {
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
          testField6: (  int  ,   ({    String   named  ,  },) )
          testField7: (String?,)
          testField8: (String,)?
          testField9: List<(String,)>?
          testField10: List<(String,)?>)
          testField11: (String positionalWithHintName, int)
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    final analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    analyzer.validateAll();

    test('when the validation completes, then no errors are collected.', () {
      expect(
        collector.errors,
        isEmpty,
      );
    });

    test('when the class definition is build, then fields match the spec.', () {
      var definitions = analyzer.validateAll();

      var modelDefinition = definitions.first as ClassDefinition;

      var testField = modelDefinition.findField('testField');
      expect(testField?.type.isRecordType, isTrue);
      expect(testField?.type.generics, hasLength(2));
      expect(testField?.type.generics.first.className, 'String');
      expect(testField?.type.generics.last.className, 'int');

      var testField5 = modelDefinition.findField('testField5');
      expect(testField5?.type.isRecordType, isTrue);
      expect(testField5?.type.generics, hasLength(2));
      expect(testField5?.type.generics.first.className, 'int');
      expect(testField5?.type.generics.first.recordFieldName, isNull);
      expect(testField5?.type.generics.last.className, 'String');
      expect(testField5?.type.generics.last.recordFieldName, 'named');

      var testField10 = modelDefinition.findField('testField10');
      expect(testField10?.type.isListType, isTrue);
      expect(testField10?.type.generics, hasLength(1));
      expect(testField10?.type.generics.first.isRecordType, isTrue);
      expect(testField10?.type.generics.first.generics, hasLength(1));
      expect(
        testField10?.type.generics.first.generics.first.className,
        'String',
      );

      var testField11 = modelDefinition.findField('testField11');
      expect(testField11?.type.isRecordType, isTrue);
      expect(testField11?.type.generics, hasLength(2));
      expect(testField11?.type.generics.first.className, 'String');
      expect(testField11?.type.generics.first.recordFieldName, isNull);
      expect(testField11?.type.generics.last.className, 'int');
    });
  });

  test(
      'Given a model class named "Record", when the validation completes, then an error is returned for this reserver class name.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Record
        fields:
          field: (String,)
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    final analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    analyzer.validateAll();

    expect(
      collector.errors.single.message,
      contains('is reserved and cannot be used'),
    );
  });
}
