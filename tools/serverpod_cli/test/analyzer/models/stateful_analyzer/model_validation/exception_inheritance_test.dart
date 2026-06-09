import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
    'Given an exception with the sealed property set to true, '
    'when parsing, '
    'then no errors are collected.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          exception: AppException
          sealed: true
          fields:
            message: String
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var models = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);
      expect((models.first as ExceptionClassDefinition).isSealed, isTrue);
    },
  );

  test(
    'Given an exception with the sealed property explicitly set to false, '
    'when parsing, '
    'then no errors are collected.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          exception: AppException
          sealed: false
          fields:
            message: String
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var models = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);
      expect((models.first as ExceptionClassDefinition).isSealed, isFalse);
    },
  );

  test(
    'Given an exception with the sealed property set to a non-boolean value, '
    'when parsing, '
    'then an error is collected that the value must be a boolean.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          exception: AppException
          sealed: 'unexpected string'
          fields:
            message: String
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isNotEmpty);
      expect(collector.errors.first.message, 'The value must be a boolean.');
    },
  );

  group(
    'Given a child exception of an existing exception, '
    'when parsing,',
    () {
      var modelSources = [
        ModelSourceBuilder().withFileName('app_exception').withYaml(
          '''
          exception: AppException
          fields:
            message: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('not_found').withYaml(
          '''
          exception: NotFoundException
          extends: AppException
          fields:
            code: int
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var models = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });

      test('then the child exception is resolved on the parent.', () {
        var parent = models.first as ExceptionClassDefinition;
        expect(parent.childClasses.first, isA<ResolvedInheritanceDefinition>());
      });

      test('then extendsClass is resolved on the child.', () {
        var child = models.last as ExceptionClassDefinition;
        expect(child.extendsClass, isA<ResolvedInheritanceDefinition>());
      });
    },
  );

  test(
    'Given a child exception of a non-existing type, '
    'when parsing, '
    'then an error is collected that no class was found in models.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          exception: AppException
          extends: NotExistingException
          fields:
            message: String
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isNotEmpty);
      expect(
        collector.errors.first.message,
        'The class "NotExistingException" was not found in any model.',
      );
    },
  );

  test(
    'Given an exception that extends a model class, '
    'when parsing, '
    'then an error is collected that an exception can only extend another exception.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('app_exception').withYaml(
          '''
          exception: AppException
          extends: Example
          fields:
            message: String
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isNotEmpty);
      expect(
        collector.errors.first.message,
        'A exception class can only extend another exception class, but got '
        'parent class "Example".',
      );
    },
  );

  test(
    'Given a model class that extends an exception, '
    'when parsing, '
    'then an error is collected that a class can only extend another class.',
    () {
      var modelSources = [
        ModelSourceBuilder().withFileName('app_exception').withYaml(
          '''
          exception: AppException
          fields:
            message: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('example').withYaml(
          '''
          class: Example
          extends: AppException
          fields:
            name: String
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isNotEmpty);
      expect(
        collector.errors.first.message,
        'A model class can only extend another model class, but got parent '
        'class "AppException".',
      );
    },
  );

  test(
    'Given a child exception that extends a foreign exception, '
    'when parsing, '
    'then an error is collected that only exceptions from the project can be extended.',
    () {
      var modelSources = [
        ModelSourceBuilder()
            .withYaml(
              '''
              exception: ForeignAppException
              fields:
                message: String
              ''',
            )
            .withModuleAlias('ForeignModule')
            .build(),
        ModelSourceBuilder().withFileName('app_exception').withYaml(
          '''
          exception: AppException
          extends: ForeignAppException
          fields:
            code: int
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isNotEmpty);
      expect(
        collector.errors.first.message,
        'You can only extend classes from your own project.',
      );
    },
  );

  test(
    'Given a child exception with a field name that already exists within the hierarchy, '
    'when parsing, '
    'then an error is collected that the field cannot be redeclared.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          exception: AppException
          fields:
            message: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('not_found').withYaml(
          '''
          exception: NotFoundException
          extends: AppException
          fields:
            message: String
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isNotEmpty);
      expect(
        collector.errors.first.message,
        'The field name "message" is already defined in an inherited class ("AppException").',
      );
    },
  );

  test(
    'Given a child exception with a parent exception that is serverOnly but the child is not, '
    'when parsing, '
    'then an error is collected that serverOnly cannot be extended by a client exception.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          exception: AppException
          serverOnly: true
          fields:
            message: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('not_found').withYaml(
          '''
          exception: NotFoundException
          extends: AppException
          fields:
            code: int
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isNotEmpty);
      expect(
        collector.errors.first.message,
        'Cannot extend a "serverOnly" class in the inheritance chain ("AppException") unless class is marked as "serverOnly".',
      );
    },
  );

  test(
    'Given a serverOnly child exception with a parent exception that is not serverOnly but the grandparent is, '
    'when parsing, '
    'then an error is collected that serverOnly cannot be extended by a client exception.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          exception: AppGrandparentException
          serverOnly: true
          fields:
            message: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('app_parent').withYaml(
          '''
          exception: AppParentException
          extends: AppGrandparentException
          fields:
            message: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('not_found').withYaml(
          '''
          exception: NotFoundException
          extends: AppParentException
          fields:
            code: int
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isNotEmpty);
      expect(
        collector.errors.first.message,
        'Cannot extend a "serverOnly" class in the inheritance chain ("AppGrandparentException") unless class is marked as "serverOnly".',
      );
    },
  );

  test(
    'Given a serverOnly child exception extending a serverOnly parent exception, '
    'when parsing, '
    'then no errors are collected.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          exception: AppException
          serverOnly: true
          fields:
            message: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('not_found').withYaml(
          '''
          exception: NotFoundException
          extends: AppException
          serverOnly: true
          fields:
            code: int
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);
    },
  );

  test(
    'Given a sealed shared package exception and a subclass on the same shared package '
    'when parsing, '
    'then no error is collected.',
    () {
      var models = <ModelSource>[
        ModelSourceBuilder()
            .withIsSharedModel(true)
            .withModuleAlias('shared')
            .withFileName('shared_app_exception')
            .withYaml(
              '''
              exception: SharedAppException
              sealed: true
              fields:
                message: String
              ''',
            )
            .build(),
        ModelSourceBuilder()
            .withIsSharedModel(true)
            .withModuleAlias('shared')
            .withFileName('shared_not_found')
            .withYaml(
              '''
              exception: SharedNotFoundException
              extends: SharedAppException
              fields:
                code: int
              ''',
            )
            .build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors to be collected',
      );
    },
  );

  test(
    'Given a sealed shared package exception and a subclass on the project package '
    'when parsing, '
    'then an error is collected that sealed exceptions cannot be inherited from another package.',
    () {
      var models = <ModelSource>[
        ModelSourceBuilder()
            .withIsSharedModel(true)
            .withModuleAlias('shared')
            .withYaml(
              '''
              exception: SharedAppException
              sealed: true
              fields:
                message: String
              ''',
            )
            .build(),
        ModelSourceBuilder().withFileName('app_exception').withYaml(
          '''
          exception: AppException
          extends: SharedAppException
          fields:
            code: int
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error to be collected',
      );

      expect(
        collector.errors.first.message,
        'Cannot extend a sealed exception class from another package.',
      );
    },
  );
}
