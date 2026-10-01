import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  CodeGenerationCollector analyze(String yaml) {
    var collector = CodeGenerationCollector();
    StatefulAnalyzer(
      config,
      [ModelSourceBuilder().withYaml(yaml).build()],
      onErrorsCollector(collector),
    ).validateAll();
    return collector;
  }

  var databaseActions = [
    'Cascade',
    'NoAction',
    'Restrict',
    'SetNull',
    'SetDefault',
  ];

  for (var action in databaseActions) {
    group(
      'Given a class with onUpdate database action explicitly set to $action',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          exampleId: int?, default=1
          example: Example?, relation(field=exampleId, onUpdate=$action)
        ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        var definitions = analyzer.validateAll();

        test('then no errors are detected.', () {
          expect(collector.errors, isEmpty);
        });

        var model = definitions.first as ClassDefinition;
        var field = model.findField('exampleId');

        var noneFieldRelation =
            field == null || field.relation is! ForeignRelationDefinition;
        test('then onUpdate is set to $action.', () {
          var relation = field?.relation as ForeignRelationDefinition;

          expect(
            relation.onUpdate.name.toString().toLowerCase(),
            action.toLowerCase(),
          );
        }, skip: noneFieldRelation);
      },
    );
  }

  for (var action in databaseActions) {
    group(
      'Given a class with onDelete database action explicitly set to $action',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          exampleId: int?, default=1
          example: Example?, relation(field=exampleId, onDelete=$action)
        ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        var definitions = analyzer.validateAll();
        var model = definitions.first as ClassDefinition;

        test('then no errors are detected.', () {
          expect(collector.errors, isEmpty);
        });

        var field = model.findField('exampleId');

        var noneFieldRelation =
            field == null || field.relation is! ForeignRelationDefinition;
        test('then onDelete is set to $action.', () {
          var relation = field?.relation as ForeignRelationDefinition;
          expect(
            relation.onDelete.name.toString().toLowerCase(),
            action.toLowerCase(),
          );
        }, skip: noneFieldRelation);
      },
    );
  }

  test(
    'Given an object relation with onDelete=SetNull and a non-nullable foreign key field, '
    'when validating, '
    'then an error is generated on the onDelete value.',
    () {
      var collector = analyze('''
class: Example
table: example
fields:
  exampleId: int
  example: Example?, relation(field=exampleId, onDelete=SetNull)
''');

      expect(collector.errors, hasLength(1));
      expect(
        collector.errors.first.message,
        'The "SetNull" action requires the foreign key field "exampleId" to be '
        'nullable.',
      );
      expect(collector.errors.first.span?.text, 'SetNull');
    },
  );

  test(
    'Given a non-optional object relation with onDelete=SetNull and a generated foreign key field, '
    'when validating, '
    'then an error is generated for the generated foreign key field.',
    () {
      var collector = analyze('''
class: Example
table: example
fields:
  example: Example?, relation(onDelete=SetNull)
''');

      expect(collector.errors, hasLength(1));
      expect(
        collector.errors.first.message,
        'The "SetNull" action requires the foreign key field "exampleId" to be '
        'nullable.',
      );
    },
  );

  test(
    'Given an optional object relation with onDelete=SetNull and a generated foreign key field, '
    'when validating, '
    'then no errors are generated.',
    () {
      var collector = analyze('''
class: Example
table: example
fields:
  example: Example?, relation(optional, onDelete=SetNull)
''');

      expect(collector.errors, isEmpty);
    },
  );

  test(
    'Given an id relation with onDelete=SetNull on a non-nullable field, '
    'when validating, '
    'then an error is generated.',
    () {
      var collector = analyze('''
class: Example
table: example
fields:
  parentId: int, relation(parent=example, onDelete=SetNull)
''');

      expect(collector.errors, hasLength(1));
      expect(
        collector.errors.first.message,
        'The "SetNull" action requires the foreign key field "parentId" to be '
        'nullable.',
      );
    },
  );

  test(
    'Given an object relation with onUpdate=SetNull and a non-nullable foreign key field, '
    'when validating, '
    'then an error is generated on the onUpdate value.',
    () {
      var collector = analyze('''
class: Example
table: example
fields:
  exampleId: int
  example: Example?, relation(field=exampleId, onUpdate=SetNull)
''');

      expect(collector.errors, hasLength(1));
      expect(
        collector.errors.first.message,
        'The "SetNull" action requires the foreign key field "exampleId" to be '
        'nullable.',
      );
      expect(collector.errors.first.span?.text, 'SetNull');
    },
  );

  test(
    'Given an object relation with onDelete=SetDefault and a foreign key field without a default, '
    'when validating, '
    'then an error is generated on the onDelete value.',
    () {
      var collector = analyze('''
class: Example
table: example
fields:
  exampleId: int
  example: Example?, relation(field=exampleId, onDelete=SetDefault)
''');

      expect(collector.errors, hasLength(1));
      expect(
        collector.errors.first.message,
        'The "SetDefault" action requires the foreign key field "exampleId" to '
        'have a database default. Declare the field with "default" or '
        '"defaultPersist" and reference it from an object relation with '
        '"field=exampleId".',
      );
      expect(collector.errors.first.span?.text, 'SetDefault');
    },
  );

  test(
    'Given an object relation with onDelete=SetDefault and a foreign key field with only a model default, '
    'when validating, '
    'then an error is generated.',
    () {
      var collector = analyze('''
class: Example
table: example
fields:
  exampleId: int, defaultModel=1
  example: Example?, relation(field=exampleId, onDelete=SetDefault)
''');

      expect(collector.errors, hasLength(1));
      expect(
        collector.errors.first.message,
        'The "SetDefault" action requires the foreign key field "exampleId" to '
        'have a database default. Declare the field with "default" or '
        '"defaultPersist" and reference it from an object relation with '
        '"field=exampleId".',
      );
    },
  );

  test(
    'Given an object relation with onDelete=SetDefault and a foreign key field with a persist default, '
    'when validating, '
    'then no errors are generated.',
    () {
      var collector = analyze('''
class: Example
table: example
fields:
  exampleId: int?, defaultPersist=1
  example: Example?, relation(field=exampleId, onDelete=SetDefault)
''');

      expect(collector.errors, isEmpty);
    },
  );

  test(
    'Given an id relation with onDelete=SetDefault, '
    'when validating, '
    'then an error is generated.',
    () {
      var collector = analyze('''
class: Example
table: example
fields:
  parentId: int?, relation(parent=example, onDelete=SetDefault)
''');

      expect(collector.errors, hasLength(1));
      expect(
        collector.errors.first.message,
        'The "SetDefault" action requires the foreign key field "parentId" to '
        'have a database default. Declare the field with "default" or '
        '"defaultPersist" and reference it from an object relation with '
        '"field=parentId".',
      );
    },
  );

  test(
    'Given an object relation with onUpdate=SetDefault and a foreign key field without a default, '
    'when validating, '
    'then an error is generated on the onUpdate value.',
    () {
      var collector = analyze('''
class: Example
table: example
fields:
  exampleId: int
  example: Example?, relation(field=exampleId, onUpdate=SetDefault)
''');

      expect(collector.errors, hasLength(1));
      expect(
        collector.errors.first.message,
        'The "SetDefault" action requires the foreign key field "exampleId" to '
        'have a database default. Declare the field with "default" or '
        '"defaultPersist" and reference it from an object relation with '
        '"field=exampleId".',
      );
      expect(collector.errors.first.span?.text, 'SetDefault');
    },
  );

  group('Given a class with no database action explicitly set', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          example: Example?, relation
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();
    var model = definitions.first as ClassDefinition;

    test('then no errors are detected.', () {
      expect(collector.errors, isEmpty);
    });

    var field = model.findField('exampleId');

    var noneFieldRelation =
        field == null || field.relation is! ForeignRelationDefinition;
    test('then onUpdate is set to the default.', () {
      var relation = field?.relation as ForeignRelationDefinition;
      expect(relation.onUpdate, ForeignKeyAction.noAction);
    }, skip: noneFieldRelation);

    test('then onDelete is set to the default.', () {
      var relation = field?.relation as ForeignRelationDefinition;
      expect(relation.onDelete, ForeignKeyAction.noAction);
    }, skip: noneFieldRelation);
  });

  test(
    'Given a class with onUpdate database action set to an invalid value, then collect an error.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
        class: Example
        table: example
        fields:
          example: Example?, relation(onUpdate=Invalid)
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        '"Invalid" is not a valid property. Valid properties are (setNull, setDefault, restrict, noAction, cascade).',
      );
    },
  );

  test(
    'Given a class with onDelete database action set to an invalid value, then collect an error.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
        class: Example
        table: example
        fields:
          example: Example?, relation(onDelete=Invalid)
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        '"Invalid" is not a valid property. Valid properties are (setNull, setDefault, restrict, noAction, cascade).',
      );
    },
  );

  group(
    'Given a class with a named object relation on both sides with onDelete defined on the side not holding the foreign key',
    () {
      var models = [
        ModelSourceBuilder().withFileName('user').withYaml(
          '''
class: User
table: user
fields:
  addressId: int
  address: Address?, relation(name=user_address, field=addressId)
indexes:
  address_index_idx:
    fields: addressId
    unique: true
        ''',
        ).build(),
        ModelSourceBuilder().withFileName('address').withYaml(
          '''
class: Address
table: address
fields:
  user: User?, relation(name=user_address, onDelete=SetNull)
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );

      analyzer.validateAll();
      var errors = collector.errors;

      test('then an error was collected.', () {
        expect(errors, isNotEmpty);
      });

      test('then the error message is correct.', () {
        expect(
          errors.first.message,
          'The "onDelete" property can only be set on the side holding the foreign key.',
        );
      }, skip: errors.isEmpty);

      test('then the error location is on the onDelete key', () {
        var error = collector.errors.first;
        expect(
          error.span,
          isNotNull,
          reason: 'Expected error to have a source span.',
        );

        var startSpan = error.span!.start;
        expect(startSpan.line, 3);
        expect(startSpan.column, 43);

        var endSpan = error.span!.end;
        expect(endSpan.line, 3);
        expect(endSpan.column, 51);
      }, skip: errors.isEmpty);
    },
  );

  group(
    'Given a class with a named object relation on both sides with onUpdate defined on the side not holding the foreign key',
    () {
      var collector = CodeGenerationCollector();

      var models = [
        ModelSourceBuilder().withFileName('user').withYaml(
          '''
class: User
table: user
fields:
  addressId: int
  address: Address?, relation(name=user_address, field=addressId)
indexes:
  address_index_idx:
    fields: addressId
    unique: true
        ''',
        ).build(),
        ModelSourceBuilder().withFileName('address').withYaml(
          '''
class: Address
table: address
fields:
  user: User?, relation(name=user_address, onUpdate=SetNull)
        ''',
        ).build(),
      ];

      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      var errors = collector.errors;

      test('then an error was collected.', () {
        expect(errors, isNotEmpty);
      });

      test('then the error message is correct.', () {
        expect(
          errors.first.message,
          'The "onUpdate" property can only be set on the side holding the foreign key.',
        );
      }, skip: errors.isEmpty);

      test('then the error location is on the onDelete key', () {
        var error = collector.errors.first;
        expect(
          error.span,
          isNotNull,
          reason: 'Expected error to have a source span.',
        );

        var startSpan = error.span!.start;
        expect(startSpan.line, 3);
        expect(startSpan.column, 43);

        var endSpan = error.span!.end;
        expect(endSpan.line, 3);
        expect(endSpan.column, 51);
      }, skip: errors.isEmpty);
    },
  );

  group(
    'Given a class with a named object - list relation with onDelete defined on the side not holding the foreign key',
    () {
      var collector = CodeGenerationCollector();

      var models = [
        ModelSourceBuilder().withFileName('user').withYaml(
          '''
        class: User
        table: user
        fields:
          addressId: int
          address: Address?, relation(name=user_address, field=addressId)
        ''',
        ).build(),
        ModelSourceBuilder().withFileName('address').withYaml(
          '''
        class: Address
        table: address
        fields:
          user: List<User>?, relation(name=user_address, onDelete=SetNull)
        ''',
        ).build(),
      ];

      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      var errors = collector.errors;

      test('then an error was collected.', () {
        expect(errors, isNotEmpty);
      });

      test('then the error message is correct.', () {
        expect(
          errors.first.message,
          'The "onDelete" property can only be set on the side holding the foreign key.',
        );
      }, skip: errors.isEmpty);
    },
  );

  group(
    'Given a class with a named object - list relation with onUpdate defined on the side not holding the foreign key',
    () {
      var collector = CodeGenerationCollector();

      var models = [
        ModelSourceBuilder().withFileName('user').withYaml(
          '''
        class: User
        table: user
        fields:
          addressId: int
          address: Address?, relation(name=user_address, field=addressId)
        ''',
        ).build(),
        ModelSourceBuilder().withFileName('address').withYaml(
          '''
        class: Address
        table: address
        fields:
          user: List<User>?, relation(name=user_address, onUpdate=SetNull)
        ''',
        ).build(),
      ];

      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      var errors = collector.errors;

      test('then an error was collected.', () {
        expect(errors, isNotEmpty);
      });

      test('then the error message is correct.', () {
        expect(
          errors.first.message,
          'The "onUpdate" property can only be set on the side holding the foreign key.',
        );
      }, skip: errors.isEmpty);
    },
  );
}
