import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given a model class with a record field,', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: MyModel
        fields:
          testField: (String, int)
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
    });
  });

  group('Given a model class with a record field,', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: MyModel
        fields:
          testField: (int,)
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
      expect(testField?.type.generics, hasLength(1));
      expect(testField?.type.generics.single.className, 'int');
    });
  });

  group('Given a model class with a record field,', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: MyModel
        fields:
          testField: (int,int,)
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
      expect(testField?.type.generics.first.className, 'int');
      expect(testField?.type.generics.last.className, 'int');
    });
  });

  group('Given a model class with a record field,', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: MyModel
        fields:
          testField: (int, {String named})
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
      expect(testField?.type.generics.first.className, 'int');
      expect(testField?.type.generics.first.recordFieldName, isNull);
      expect(testField?.type.generics.last.className, 'String');
      expect(testField?.type.generics.last.recordFieldName, 'named');
    });
  });

  group('Given a model class with a record field,', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: MyModel
        fields:
          testField: (  int  ,   {    String   named  ,  }  )
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
      expect(testField?.type.generics.first.className, 'int');
      expect(testField?.type.generics.first.recordFieldName, isNull);
      expect(testField?.type.generics.last.className, 'String');
      expect(testField?.type.generics.last.recordFieldName, 'named');
    });
  });

  group('Given a model class with a record field,', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: MyModel
        fields:
          testField: (  int  ,   ({    String   named  ,  },) )
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
      expect(testField?.type.generics.first.className, 'int');
      expect(testField?.type.generics.first.recordFieldName, isNull);
      expect(testField?.type.generics.last.className, 'String');
      expect(testField?.type.generics.last.recordFieldName, 'named');
    });
  });

  group('Given a model class with a record field,', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: MyModel
        fields:
          testField: (String?,)
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
      expect(testField?.type.nullable, isFalse);
      expect(testField?.type.generics, hasLength(1));
      expect(testField?.type.generics.single.className, 'String');
      expect(testField?.type.generics.single.nullable, isTrue);
    });
  });

  group('Given a model class with a record field,', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: MyModel
        fields:
          testField: (String,)?
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
      expect(testField?.type.nullable, isTrue);
      expect(testField?.type.generics, hasLength(1));
      expect(testField?.type.generics.single.className, 'String');
    });
  });

  group('Given a model class with a record field,', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: MyModel
        fields:
          testField: List<(String,)>?
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
      expect(testField?.type.isListType, isTrue);
      expect(testField?.type.generics, hasLength(1));
      expect(testField?.type.generics.first.isRecordType, isTrue);
      expect(testField?.type.generics.first.generics, hasLength(1));
      expect(
        testField?.type.generics.first.generics.first.className,
        'String',
      );
    });
  });

  group('Given a model class with a record field,', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: MyModel
        fields:
          testField: List<(String,)?>)
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
      expect(testField?.type.isListType, isTrue);
      expect(testField?.type.generics, hasLength(1));
      expect(testField?.type.generics.first.isRecordType, isTrue);
      expect(testField?.type.generics.first.generics, hasLength(1));
      expect(
        testField?.type.generics.first.generics.first.className,
        'String',
      );
    });
  });

  group('Given a model class with a record field,', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: MyModel
        fields:
          testField: (String positionalWithHintName, int)
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
      expect(testField?.type.generics.first.recordFieldName, isNull);
      expect(testField?.type.generics.last.className, 'int');
    });
  });
}
