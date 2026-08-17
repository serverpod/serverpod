import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  var databaseActions = [
    'Cascade',
    'NoAction',
    'Restrict',
    'SetNull',
    'SetDefault',
  ];

  for (var action in databaseActions) {
    group(
      'Given a class with onUpdate database action explicitly set to $action,',
      () {
        late var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          example: Example?, relation(onUpdate=$action)
        ''',
          ).build(),
        ];

        late var collector = CodeGenerationCollector();
        late var analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        late var definitions = analyzer.validateAll();

        test('then no errors are detected.', () {
          expect(collector.errors, isEmpty);
        });

        var model = definitions.first as ClassDefinition;
        late var field = model.findField('exampleId');

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
      'Given a class with onDelete database action explicitly set to $action,',
      () {
        late var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          example: Example?, relation(onDelete=$action)
        ''',
          ).build(),
        ];

        late var collector = CodeGenerationCollector();
        late var analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        late var definitions = analyzer.validateAll();
        var model = definitions.first as ClassDefinition;

        test('then no errors are detected.', () {
          expect(collector.errors, isEmpty);
        });

        late var field = model.findField('exampleId');

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

  group('Given a class with no database action explicitly set,', () {
    late var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          example: Example?, relation
        ''',
      ).build(),
    ];

    late var collector = CodeGenerationCollector();
    late var analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    late var definitions = analyzer.validateAll();
    var model = definitions.first as ClassDefinition;

    test('then no errors are detected.', () {
      expect(collector.errors, isEmpty);
    });

    late var field = model.findField('exampleId');

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
    'Given a class with onUpdate database action set to an invalid value, '
    'then collect an error.',
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
    'Given a class with onDelete database action set to an invalid value, '
    'then collect an error.',
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
    'Given a class with a named object relation on both sides with onDelete defined on the side not holding the foreign key,',
    () {
      late var models = [
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

      late var collector = CodeGenerationCollector();
      late var analyzer = StatefulAnalyzer(
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
    'Given a class with a named object relation on both sides with onUpdate defined on the side not holding the foreign key,',
    () {
      late var collector = CodeGenerationCollector();

      late var models = [
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

      late var analyzer = StatefulAnalyzer(
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
    'Given a class with a named object - list relation with onDelete defined on the side not holding the foreign key,',
    () {
      late var collector = CodeGenerationCollector();

      late var models = [
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

      late var analyzer = StatefulAnalyzer(
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
    'Given a class with a named object - list relation with onUpdate defined on the side not holding the foreign key,',
    () {
      late var collector = CodeGenerationCollector();

      late var models = [
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

      late var analyzer = StatefulAnalyzer(
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
