import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
    'Given a model class with a record with 2 positional fields, when the class definition is build, then fields match the spec.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
        class: MyModel
        fields:
          testField: (String, int)
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      final analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isEmpty,
      );

      var definitions = analyzer.validateAll();

      var modelDefinition = definitions.first as ClassDefinition;

      var testField = modelDefinition.findField('testField');
      expect(testField?.type.isRecordType, isTrue);
      expect(testField?.type.generics, hasLength(2));
      expect(testField?.type.generics.first.className, 'String');
      expect(testField?.type.generics.last.className, 'int');
    },
  );

  test(
    'Given a model class with a record with a single positional fields, when the class definition is build, then fields match the spec.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
        class: MyModel
        fields:
          testField: (int,)
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      final analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isEmpty,
      );

      var definitions = analyzer.validateAll();

      var modelDefinition = definitions.first as ClassDefinition;

      var testField = modelDefinition.findField('testField');
      expect(testField?.type.isRecordType, isTrue);
      expect(testField?.type.generics, hasLength(1));
      expect(testField?.type.generics.single.className, 'int');
    },
  );

  test(
    'Given a model class with a record with 2 positional fields without whitespace, when the class definition is build, then fields match the spec.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
        class: MyModel
        fields:
          testField: (int,int,)
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      final analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isEmpty,
      );

      var definitions = analyzer.validateAll();

      var modelDefinition = definitions.first as ClassDefinition;

      var testField = modelDefinition.findField('testField');
      expect(testField?.type.isRecordType, isTrue);
      expect(testField?.type.generics, hasLength(2));
      expect(testField?.type.generics.first.className, 'int');
      expect(testField?.type.generics.last.className, 'int');
    },
  );

  test(
    'Given a model class with a record with 1 positional and 1 named field, when the class definition is build, then fields match the spec.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
        class: MyModel
        fields:
          testField: (int, {String named})
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      final analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isEmpty,
      );

      var definitions = analyzer.validateAll();

      var modelDefinition = definitions.first as ClassDefinition;

      var testField = modelDefinition.findField('testField');
      expect(testField?.type.isRecordType, isTrue);
      expect(testField?.type.generics, hasLength(2));
      expect(testField?.type.generics.first.className, 'int');
      expect(testField?.type.generics.first.recordFieldName, isNull);
      expect(testField?.type.generics.last.className, 'String');
      expect(testField?.type.generics.last.recordFieldName, 'named');
    },
  );

  test(
    'Given a model class with a record with 1 positional and 1 named field and extra whitespace, when the class definition is build, then fields match the spec.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
        class: MyModel
        fields:
          testField: (  int  ,   {    String   named  ,  }  )
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      final analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isEmpty,
      );

      var definitions = analyzer.validateAll();

      var modelDefinition = definitions.first as ClassDefinition;

      var testField = modelDefinition.findField('testField');
      expect(testField?.type.isRecordType, isTrue);
      expect(testField?.type.generics, hasLength(2));
      expect(testField?.type.generics.first.className, 'int');
      expect(testField?.type.generics.first.recordFieldName, isNull);
      expect(testField?.type.generics.last.className, 'String');
      expect(testField?.type.generics.last.recordFieldName, 'named');
    },
  );

  test(
    'Given a model class with a record with 1 positional and 1 named field with extra whitespace and all possible commas, when the class definition is build, then fields match the spec.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
        class: MyModel
        fields:
          testField: (  int  ,   ({    String   named  ,  },) )
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      final analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isEmpty,
      );

      var definitions = analyzer.validateAll();

      var modelDefinition = definitions.first as ClassDefinition;

      var testField = modelDefinition.findField('testField');

      expect(testField?.type.isRecordType, isTrue);
      expect(testField!.type.nullable, false);
      expect(testField.type.generics, hasLength(2));

      var intField = testField.type.generics.first;
      expect(intField.className, 'int');
      expect(intField.nullable, isFalse);
      expect(intField.recordFieldName, isNull);
      expect(intField.generics, isEmpty);

      var nestedRecord = testField.type.generics.last;
      expect(nestedRecord.isRecordType, isTrue);
      expect(nestedRecord.nullable, isFalse);
      expect(nestedRecord.recordFieldName, isNull);
      expect(nestedRecord.generics, hasLength(1));

      var namedField = nestedRecord.generics.single;
      expect(namedField.className, 'String');
      expect(namedField.nullable, isFalse);
      expect(namedField.recordFieldName, 'named');
      expect(namedField.generics, isEmpty);
    },
  );

  test(
    'Given a model class with a record with 1 nullable positional field, when the class definition is build, then fields match the spec.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
        class: MyModel
        fields:
          testField: (String?,)
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      final analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isEmpty,
      );

      var definitions = analyzer.validateAll();

      var modelDefinition = definitions.first as ClassDefinition;

      var testField = modelDefinition.findField('testField');
      expect(testField?.type.isRecordType, isTrue);
      expect(testField?.type.nullable, isFalse);
      expect(testField?.type.generics, hasLength(1));
      expect(testField?.type.generics.single.className, 'String');
      expect(testField?.type.generics.single.nullable, isTrue);
    },
  );

  test(
    'Given a model class with a nullable record with 1 positional field, when the class definition is build, then fields match the spec.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
        class: MyModel
        fields:
          testField: (String,)?
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      final analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isEmpty,
      );

      var definitions = analyzer.validateAll();

      var modelDefinition = definitions.first as ClassDefinition;

      var testField = modelDefinition.findField('testField');
      expect(testField?.type.isRecordType, isTrue);
      expect(testField?.type.nullable, isTrue);
      expect(testField?.type.generics, hasLength(1));
      expect(testField?.type.generics.single.className, 'String');
    },
  );

  test(
    'Given a model class with a list of records with 1 positional field, when the class definition is build, then fields match the spec.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
        class: MyModel
        fields:
          testField: List<(String,)>?
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      final analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isEmpty,
      );

      var definitions = analyzer.validateAll();

      var modelDefinition = definitions.first as ClassDefinition;

      var testField = modelDefinition.findField('testField');
      expect(testField?.type.isListType, isTrue);
      expect(testField?.type.generics, hasLength(1));
      expect(testField?.type.generics.first.isRecordType, isTrue);
      expect(testField?.type.generics.first.generics, hasLength(1));
      expect(
        testField?.type.generics.first.generics.first.className,
        'String',
      );
    },
  );

  test(
    'Given a model class with a list of nullable records with 1 positional field, when the class definition is build, then fields match the spec.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
        class: MyModel
        fields:
          testField: List<(String,)?>)
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      final analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isEmpty,
      );

      var definitions = analyzer.validateAll();

      var modelDefinition = definitions.first as ClassDefinition;

      var testField = modelDefinition.findField('testField');
      expect(testField?.type.isListType, isTrue);
      expect(testField?.type.generics, hasLength(1));
      expect(testField?.type.generics.first.isRecordType, isTrue);
      expect(testField?.type.generics.first.generics, hasLength(1));
      expect(
        testField?.type.generics.first.generics.first.className,
        'String',
      );
    },
  );

  test(
    'Given a model class with a records with 1 named positional and 1 unnamed positional field, when the class definition is build, then fields match the spec.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
        class: MyModel
        fields:
          testField: (String positionalWithHintName, int)
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      final analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isEmpty,
      );

      var definitions = analyzer.validateAll();

      var modelDefinition = definitions.first as ClassDefinition;

      var testField = modelDefinition.findField('testField');
      expect(testField?.type.isRecordType, isTrue);
      expect(testField?.type.generics, hasLength(2));
      expect(testField?.type.generics.first.className, 'String');
      expect(testField?.type.generics.first.recordFieldName, isNull);
      expect(testField?.type.generics.last.className, 'int');
    },
  );
}
