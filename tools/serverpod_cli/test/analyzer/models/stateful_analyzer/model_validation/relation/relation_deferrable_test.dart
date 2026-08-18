import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
    'Given an object relation marked as deferrable, '
    'when the model is analyzed, '
    'then its foreign key is initially immediate.',
    () {
      var collector = CodeGenerationCollector();
      var definitions = StatefulAnalyzer(
        config,
        [
          ModelSourceBuilder().withYaml(
            '''
class: Example
table: example
fields:
  example: Example?, relation(deferrable)
''',
          ).build(),
        ],
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);
      var model = definitions.single as ClassDefinition;
      var relation =
          model.findField('exampleId')!.relation as ForeignRelationDefinition;
      expect(
        relation.deferrable,
        DeferrableConstraint.initiallyImmediate,
      );
    },
  );

  test(
    'Given an id relation marked as deferrable, '
    'when the model is analyzed, '
    'then its foreign key is initially immediate.',
    () {
      var collector = CodeGenerationCollector();
      var definitions = StatefulAnalyzer(
        config,
        [
          ModelSourceBuilder().withYaml(
            '''
class: Example
table: example
fields:
  parentId: int, relation(parent=example, deferrable)
''',
          ).build(),
        ],
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);
      var model = definitions.single as ClassDefinition;
      var relation =
          model.findField('parentId')!.relation as ForeignRelationDefinition;
      expect(
        relation.deferrable,
        DeferrableConstraint.initiallyImmediate,
      );
    },
  );

  test(
    'Given an object relation marked as deferred, '
    'when the model is analyzed, '
    'then its foreign key is initially deferred.',
    () {
      var collector = CodeGenerationCollector();
      var definitions = StatefulAnalyzer(
        config,
        [
          ModelSourceBuilder().withYaml(
            '''
class: Example
table: example
fields:
  example: Example?, relation(deferred)
''',
          ).build(),
        ],
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);
      var model = definitions.single as ClassDefinition;
      var relation =
          model.findField('exampleId')!.relation as ForeignRelationDefinition;
      expect(
        relation.deferrable,
        DeferrableConstraint.initiallyDeferred,
      );
    },
  );

  test(
    'Given an id relation marked as deferred, '
    'when the model is analyzed, '
    'then its foreign key is initially deferred.',
    () {
      var collector = CodeGenerationCollector();
      var definitions = StatefulAnalyzer(
        config,
        [
          ModelSourceBuilder().withYaml(
            '''
class: Example
table: example
fields:
  parentId: int, relation(parent=example, deferred)
''',
          ).build(),
        ],
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);
      var model = definitions.single as ClassDefinition;
      var relation =
          model.findField('parentId')!.relation as ForeignRelationDefinition;
      expect(
        relation.deferrable,
        DeferrableConstraint.initiallyDeferred,
      );
    },
  );

  test(
    'Given a relation without a deferrability flag, '
    'when the model is analyzed, '
    'then its foreign key is not deferrable.',
    () {
      var collector = CodeGenerationCollector();
      var definitions = StatefulAnalyzer(
        config,
        [
          ModelSourceBuilder().withYaml(
            '''
class: Example
table: example
fields:
  example: Example?, relation
''',
          ).build(),
        ],
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);
      var model = definitions.single as ClassDefinition;
      var relation =
          model.findField('exampleId')!.relation as ForeignRelationDefinition;
      expect(relation.deferrable, isNull);
    },
  );

  test(
    'Given a named relation with deferrable on the side not holding the foreign key, '
    'when the model is analyzed, '
    'then the deferrable option is rejected.',
    () {
      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        [
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
  user: User?, relation(name=user_address, deferrable)
''',
          ).build(),
        ],
        onErrorsCollector(collector),
      ).validateAll();

      expect(
        collector.errors.map((error) => error.message),
        contains(
          'The "deferrable" property can only be set on the side holding the foreign key.',
        ),
      );
    },
  );

  test(
    'Given a named relation with deferred on the side not holding the foreign key, '
    'when the model is analyzed, '
    'then the deferred option is rejected.',
    () {
      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        [
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
  user: User?, relation(name=user_address, deferred)
''',
          ).build(),
        ],
        onErrorsCollector(collector),
      ).validateAll();

      expect(
        collector.errors.map((error) => error.message),
        contains(
          'The "deferred" property can only be set on the side holding the foreign key.',
        ),
      );
    },
  );

  test(
    'Given a relation with a non-boolean deferrable value, '
    'when the model is analyzed, '
    'then the deferrable option is rejected.',
    () {
      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        [
          ModelSourceBuilder().withYaml(
            '''
class: Example
table: example
fields:
  example: Example?, relation(deferrable=Invalid)
''',
          ).build(),
        ],
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isNotEmpty);
    },
  );

  test(
    'Given a relation with a non-boolean deferred value, '
    'when the model is analyzed, '
    'then the deferred option is rejected.',
    () {
      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        [
          ModelSourceBuilder().withYaml(
            '''
class: Example
table: example
fields:
  example: Example?, relation(deferred=Invalid)
''',
          ).build(),
        ],
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isNotEmpty);
    },
  );

  test(
    'Given a relation marked as both deferrable and deferred, '
    'when the model is analyzed, '
    'then the mutually exclusive options are rejected.',
    () {
      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        [
          ModelSourceBuilder().withYaml(
            '''
class: Example
table: example
fields:
  example: Example?, relation(deferrable, deferred)
''',
          ).build(),
        ],
        onErrorsCollector(collector),
      ).validateAll();

      expect(
        collector.errors.map((error) => error.message),
        contains(
          'The "deferred" property is mutually exclusive with the "deferrable" property.',
        ),
      );
    },
  );
}
