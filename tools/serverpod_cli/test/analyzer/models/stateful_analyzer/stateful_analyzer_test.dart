import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();
  test(
    'Given that no initial validation was done, then an empty list is returned when validating all files.',
    () {
      var statefulAnalyzer = StatefulAnalyzer(config, []);

      var models = statefulAnalyzer.validateAll();

      expect(models, []);
    },
  );

  test(
    'When we add and remove a model, then an empty list is returned when validating all files.',
    () {
      var statefulAnalyzer = StatefulAnalyzer(config, []);

      var modelUri = Uri(path: 'lib/src/model/example.yaml');
      var yamlSource = ModelSourceBuilder()
          .withYamlSourceUri(modelUri)
          .withYaml(
            '''
      class: Example
      fields:
        name: String
      ''',
          )
          .build();
      statefulAnalyzer.addYamlModel(yamlSource);
      statefulAnalyzer.removeYamlModel(modelUri);

      var models = statefulAnalyzer.validateAll();

      expect(models, []);
    },
  );

  test(
    'Given an empty state, when removing a model that does not exist and validating all, then an empty list is returned',
    () {
      var statefulAnalyzer = StatefulAnalyzer(config, []);

      var modelUri = Uri(path: 'lib/src/model/example.yaml');
      statefulAnalyzer.removeYamlModel(modelUri);

      var models = statefulAnalyzer.validateAll();

      expect(models, []);
    },
  );

  test(
    'Given an empty state, when validating a single model, then an empty list is returned',
    () {
      var statefulAnalyzer = StatefulAnalyzer(config, []);

      var modelUri = Uri(path: 'lib/src/model/example.yaml');
      var yaml = '''
class: Example
fields:
  name: String
''';

      var models = statefulAnalyzer.validateModel(yaml, modelUri);

      expect(models, []);
    },
  );
  test(
    'Given a valid model class as the initial state, when validating all, then the class is serialized.',
    () {
      var yamlSource = ModelSourceBuilder().withYaml(
        '''
      class: Example
      fields:
        name: String
      ''',
      ).build();

      var statefulAnalyzer = StatefulAnalyzer(config, [yamlSource]);

      var models = statefulAnalyzer.validateAll();

      expect(models.length, 1);
      expect(models.first.className, 'Example');
    },
  );

  test(
    'Given a valid shared model as the initial state, when validating all, then the class is serialized and has sharedPackageName set.',
    () {
      var yamlSource = ModelSourceBuilder()
          .withYaml(
            '''
      class: SharedExample
      fields:
        name: String
      ''',
          )
          .withIsSharedModel(true)
          .withModuleAlias('shared')
          .build();

      var statefulAnalyzer = StatefulAnalyzer(config, [yamlSource]);

      var models = statefulAnalyzer.validateAll();

      expect(models.length, 1);
      expect(models.first.className, 'SharedExample');
      expect(models.first.isSharedModel, true);
      expect(models.first.sharedPackageName, 'shared');
    },
  );

  test(
    'Given a valid model class and an error callback is registered, when validating all, then the callback is triggered.',
    () {
      var yamlSource = ModelSourceBuilder().withYaml(
        '''
      class: Example
      fields:
        name: String
      ''',
      ).build();

      var wasCalled = false;
      var statefulAnalyzer = StatefulAnalyzer(config, [yamlSource], (
        uri,
        errors,
      ) {
        wasCalled = true;
      });

      statefulAnalyzer.validateAll();
      expect(wasCalled, true, reason: 'The error callback was not triggered.');
    },
  );

  test(
    'Given a model with invalid syntax and an error callback is registered, when validating all, then the callback is triggered.',
    () {
      var yamlSource = ModelSourceBuilder().withYaml('''''').build();

      var wasCalled = false;
      var statefulAnalyzer = StatefulAnalyzer(config, [yamlSource], (
        uri,
        errors,
      ) {
        wasCalled = true;
      });

      statefulAnalyzer.validateAll();
      expect(wasCalled, true, reason: 'The error callback was not triggered.');
    },
  );

  test(
    'Given a model with a severe error (invalid syntax), when validating all, then hasSevereErrors returns true',
    () {
      var yamlSource = ModelSourceBuilder().withYaml('''''').build();

      var statefulAnalyzer = StatefulAnalyzer(
        config,
        [yamlSource],
      );

      statefulAnalyzer.validateAll();
      expect(statefulAnalyzer.hasSevereErrors, true);
    },
  );

  test(
    'Given a model with multi line invalid yaml syntax when validating all then error is reported.',
    () {
      var invalidSource = ModelSourceBuilder().withYaml(
        '''
this is not valid yaml
and neither is this line
''',
      ).build();

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, [
        invalidSource,
      ], onErrorsCollector(collector)).validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(error.span, isNotNull);
      expect(error.span!.start.line, 0);
      expect(error.span!.start.column, 0);
      expect(error.span!.end.line, 0);
      expect(error.span!.end.column, 22);
    },
  );

  test(
    'Given a model that was invalid on first validation, when validating the same model with an updated valid syntax, then the previous errors are cleared.',
    () {
      var modelUri = Uri(path: 'lib/src/model/example.yaml');
      var invalidSource = ModelSourceBuilder()
          .withYamlSourceUri(modelUri)
          .withYaml(
            '''
      class:
      fields:
        name: String
      ''',
          )
          .build();

      var validSource = ModelSourceBuilder()
          .withYamlSourceUri(modelUri)
          .withYaml(
            '''
      class: Example
      fields:
        name: String
      ''',
          )
          .build();

      CodeGenerationCollector? reportedErrors;
      var statefulAnalyzer = StatefulAnalyzer(config, [invalidSource], (
        uri,
        errors,
      ) {
        reportedErrors = errors;
      });

      statefulAnalyzer.validateAll();

      expect(
        reportedErrors?.errors,
        hasLength(1),
        reason: 'Expected an error to be reported.',
      );

      statefulAnalyzer.validateModel(validSource.yaml, modelUri);

      expect(
        reportedErrors?.errors,
        hasLength(0),
        reason: 'Expected the error to be cleared.',
      );
    },
  );

  test(
    'Given two yaml models with the same class name, when validating all, then an error is reported.',
    () {
      var yamlSource1 = ModelSourceBuilder().withFileName('example1').withYaml(
        '''
      class: Example
      fields:
        name: String
      ''',
      ).build();

      var yamlSource2 = ModelSourceBuilder().withFileName('example2').withYaml(
        '''
      class: Example
      fields:
        name: String
      ''',
      ).build();

      CodeGenerationCollector? reportedErrors;

      var statefulAnalyzer = StatefulAnalyzer(
        config,
        [yamlSource1, yamlSource2],
        (uri, errors) {
          reportedErrors = errors;
        },
      );

      statefulAnalyzer.validateAll();

      expect(
        reportedErrors?.errors,
        hasLength(1),
        reason: 'Expected an error to be reported.',
      );
    },
  );

  test(
    'Given two yaml models with the same class name, when removing and revalidating, then the previous error is cleared.',
    () {
      var yamlSource1 = ModelSourceBuilder().withFileName('example1').withYaml(
        '''
      class: Example
      fields:
        name: String
      ''',
      ).build();

      var yamlSource2 = ModelSourceBuilder().withFileName('example2').withYaml(
        '''
      class: Example
      fields:
        name: String
      ''',
      ).build();

      CodeGenerationCollector? reportedErrors;
      var statefulAnalyzer = StatefulAnalyzer(
        config,
        [yamlSource1, yamlSource2],
        (uri, errors) {
          reportedErrors = errors;
        },
      );

      statefulAnalyzer.validateAll();

      expect(
        reportedErrors?.errors,
        hasLength(1),
        reason: 'Expected an error to be reported.',
      );

      statefulAnalyzer.removeYamlModel(yamlSource2.yamlSourceUri);

      statefulAnalyzer.validateAll();

      expect(
        reportedErrors?.errors,
        hasLength(0),
        reason: 'Expected the error to be cleared.',
      );
    },
  );

  test(
    'Given an initial validation with one valid model, when adding a second model with the same class and revalidating, then an error is reported.',
    () {
      var yamlSource1 = ModelSourceBuilder().withFileName('example1').withYaml(
        '''
      class: Example
      fields:
        name: String
      ''',
      ).build();

      var yamlSource2 = ModelSourceBuilder().withFileName('example2').withYaml(
        '''
      class: Example
      fields:
        name: String
      ''',
      ).build();

      CodeGenerationCollector? reportedErrors;
      var statefulAnalyzer = StatefulAnalyzer(config, [yamlSource1], (
        uri,
        errors,
      ) {
        reportedErrors = errors;
      });

      statefulAnalyzer.validateAll();

      expect(
        reportedErrors?.errors,
        hasLength(0),
        reason: 'Expected no errors to be reported.',
      );

      statefulAnalyzer.addYamlModel(yamlSource2);

      statefulAnalyzer.validateModel(
        yamlSource2.yaml,
        yamlSource2.yamlSourceUri,
      );

      expect(
        reportedErrors?.errors,
        hasLength(1),
        reason: 'Expected an error to be reported.',
      );
    },
  );

  test(
    'Given a yaml model with a field type wrapped in (), when parsing, then an error should be returned',
    () {
      var yamlSource = ModelSourceBuilder().withFileName('example').withYaml(
        '''
      class: Example
      fields:
        name: (String)
      ''',
      ).build();

      CodeGenerationCollector? reportedErrors;
      var statefulAnalyzer = StatefulAnalyzer(config, [yamlSource], (
        uri,
        errors,
      ) {
        reportedErrors = errors;
      });

      statefulAnalyzer.validateAll();

      expect(reportedErrors?.errors, hasLength(1));
      expect(
        reportedErrors?.errors.single.message,
        contains('invalid datatype "(String)"'),
      );
    },
  );

  test(
    'Given a valid model and reportIssuesForPaths containing only that model path, '
    'when validateAll is called, '
    'then the notifier is called once with an empty collector.',
    () {
      const pathInScope = 'lib/src/model/in_scope.yaml';
      var yamlInScope = ModelSourceBuilder()
          .withFileName('in_scope')
          .withYaml(
            '''
          class: Valid
          fields:
            name: String
          ''',
          )
          .withYamlSourceUri(Uri(path: pathInScope))
          .build();

      var notified = <Uri>[];
      var statefulAnalyzer = StatefulAnalyzer(
        config,
        [yamlInScope],
        (uri, collector) {
          notified.add(uri);
          expect(collector.errors, isEmpty);
        },
      );

      statefulAnalyzer.validateAll(reportIssuesForPaths: {pathInScope});

      expect(notified, [Uri(path: pathInScope)]);
    },
  );

  test(
    'Given two models containing a hint-severity issue and reportIssuesForPaths containing only one model path, '
    'when validateAll is called '
    'then only the in-scope model is notified.',
    () {
      const pathInScope = 'lib/src/model/in_scope.yaml';
      var yamlInScope = ModelSourceBuilder()
          .withYaml(
            '''
class: Example1
table: example1
fields:
  id: UuidValue?, defaultModel=random
''',
          )
          .withYamlSourceUri(Uri(path: pathInScope))
          .build();

      const pathOutOfScope = 'lib/src/model/out_of_scope.yaml';
      var yamlOutOfScope = ModelSourceBuilder()
          .withFileName('out')
          .withYaml(
            '''
class: Example2
table: example2
fields:
  id: UuidValue?, defaultModel=random
''',
          )
          .withYamlSourceUri(Uri(path: pathOutOfScope))
          .build();

      var notified = <Uri>[];
      var statefulAnalyzer = StatefulAnalyzer(
        config,
        [yamlInScope, yamlOutOfScope],
        (uri, collector) {
          notified.add(uri);
          expect(collector.errors, isNotEmpty);
        },
      );

      statefulAnalyzer.validateAll(reportIssuesForPaths: {pathInScope});

      expect(notified, hasLength(1));
      expect(notified.single.toFilePath(windows: false), pathInScope);
    },
  );

  test(
    'Given two models containing an info-severity issue and reportIssuesForPaths containing only one model path, '
    'when validateAll is called, '
    'then only the in-scope model is notified.',
    () {
      const pathInScope = 'lib/src/model/in_scope.yaml';

      var yamlInScope = ModelSourceBuilder()
          .withFileName('in_scope')
          .withYaml(
            '''
          class: Valid
          fields:
            name: String
          ''',
          )
          .withYamlSourceUri(Uri(path: pathInScope))
          .build();

      const pathOutOfScope = 'lib/src/model/out_of_scope.yaml';
      var yamlOutOfScope = ModelSourceBuilder()
          .withFileName('out')
          .withYaml(
            '''
class: Example2
fields:
  my_field: String
''',
          )
          .withYamlSourceUri(Uri(path: pathOutOfScope))
          .build();

      var notified = <Uri>[];
      var statefulAnalyzer = StatefulAnalyzer(
        config,
        [yamlInScope, yamlOutOfScope],
        (uri, collector) {
          notified.add(uri);
        },
      );

      statefulAnalyzer.validateAll(reportIssuesForPaths: {pathInScope});

      expect(notified, [Uri(path: pathInScope)]);
    },
  );

  test(
    'Given two models containing an error-severity issue and reportIssuesForPaths containing only one model path, '
    'when validateAll is called, '
    'then both the in-scope and out-of-scope models are notified.',
    () {
      const pathInScope = 'lib/src/model/in_scope.yaml';
      var yamlInScope = ModelSourceBuilder()
          .withFileName('in_scope')
          .withYaml(
            '''
          class: Valid
          fields:
            name: String
          ''',
          )
          .withYamlSourceUri(Uri(path: pathInScope))
          .build();

      const pathOutOfScope = 'lib/src/model/out_of_scope.yaml';
      var yamlOutOfScope = ModelSourceBuilder()
          .withFileName('out')
          .withYaml(
            '''
          class: Example2
          fields:
            name: (String)
          ''',
          )
          .withYamlSourceUri(Uri(path: pathOutOfScope))
          .build();

      var notified = <Uri>[];
      var statefulAnalyzer = StatefulAnalyzer(
        config,
        [yamlInScope, yamlOutOfScope],
        (uri, collector) {
          notified.add(uri);
        },
      );

      statefulAnalyzer.validateAll(reportIssuesForPaths: {pathInScope});

      expect(notified, hasLength(2));
      expect(notified, contains(Uri(path: pathOutOfScope)));
      expect(notified, contains(Uri(path: pathInScope)));
    },
  );

  test(
    'Given a project without the database feature and two models where reportIssuesForPaths contains only the path for the model with no table, '
    'when validateAll is called, '
    'then the out-of-scope model is still notified with a warning.',
    () {
      const pathInScope = 'lib/src/model/in_scope.yaml';
      var configNoDatabase = GeneratorConfigBuilder()
          .withEnabledFeatures([])
          .build();

      var yamlInScope = ModelSourceBuilder()
          .withFileName('in_scope')
          .withYaml(
            '''
          class: Valid
          fields:
            name: String
          ''',
          )
          .withYamlSourceUri(Uri(path: pathInScope))
          .build();

      const pathOutOfScope = 'lib/src/model/out_of_scope.yaml';
      var yamlOutOfScope = ModelSourceBuilder()
          .withFileName('out')
          .withYaml(
            '''
          class: Example2
          table: example2
          fields:
            name: String
          ''',
          )
          .withYamlSourceUri(Uri(path: pathOutOfScope))
          .build();

      var errors = <SourceSpanSeverityException>[];
      var statefulAnalyzer = StatefulAnalyzer(
        configNoDatabase,
        [yamlInScope, yamlOutOfScope],
        (uri, collector) {
          for (var error in collector.errors) {
            if (error is SourceSpanSeverityException) {
              errors.add(error);
            }
          }
        },
      );

      statefulAnalyzer.validateAll(reportIssuesForPaths: {pathInScope});

      expect(errors, isNotEmpty);
      expect(errors, hasLength(1));
      expect(errors.single.severity, SourceSpanSeverity.warning);
    },
  );

  test(
    'Given valid yaml models with one-to-one relationship on the id field, '
    'when validateAll is called, '
    'then the class with the relation is serialized containing an id field with valid relation.',
    () {
      var yamlSource = ModelSourceBuilder().withFileName('example').withYaml(
        '''
      class: Example
      table: example
      fields:
        id: int?, relation(parent=other, onDelete=Cascade)
        name: String
      ''',
      ).build();

      var parentYamlSource = ModelSourceBuilder()
          .withFileName('other')
          .withYaml(
            '''
      class: Other
      table: other
      fields:
        name: String
      ''',
          )
          .build();

      var statefulAnalyzer = StatefulAnalyzer(config, [
        yamlSource,
        parentYamlSource,
      ]);

      var models = statefulAnalyzer.validateAll();

      var fields = models
          .whereType<ModelClassDefinition>()
          .firstWhere(
            (e) => e.className == 'Example',
          )
          .fields;

      var idField = fields.firstWhere((field) => field.name == 'id');

      expect(idField.relation, isA<ForeignRelationDefinition>());
    },
  );
}
