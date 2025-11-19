import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../test_util/compilation_unit_matcher.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var testClassName = 'Example';
  var testClassFileName = 'example';
  var expectedFilePath = path.join(
    'lib',
    'src',
    'generated',
    '$testClassFileName.dart',
  );

  test(
    'Given a class with no fields that should persist but is scoped too none then no implicit class is generated.',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName('example')
            .build(),
      ];

      var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      var compilationUnit = parseCode(codeMap[expectedFilePath]!);

      expect(compilationUnit, isNot(containsClass('${testClassName}Implicit')));
    },
  );
  group('Given a class with a field that should persist but is scoped too none', () {
    late final models = [
      ModelClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName('example')
          .withSimpleField('extra', 'bool')
          .withField(
            FieldDefinitionBuilder()
                .withName('_name')
                .withType(TypeDefinition(className: 'String', nullable: true))
                .withShouldPersist(true)
                .withScope(ModelFieldScopeDefinition.none)
                .build(),
          )
          .build(),
    ];

    late var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    late var compilationUnit = parseCode(codeMap[expectedFilePath]!);

    var implicitClassName = '${testClassName}Implicit';

    test('then an implicit class is generated', () {
      expect(compilationUnit, containsClass(implicitClassName));
    });

    test(
      'then the implicit class overrides the field from inherited class',
      () {
        expect(
          compilationUnit,
          containsClass(implicitClassName).withField(
            '_name',
            isNullable: true,
            isFinal: true,
            isOverride: true,
          ),
        );
      },
    );

    test('then implicit class has a private constructor', () {
      expect(
        compilationUnit,
        containsClass(implicitClassName).withNamedConstructor('_'),
      );
    });

    test(
      'then implicit class has private constructor that takes private field prefixed with "\$"',
      () {
        expect(
          compilationUnit,
          containsClass(
            implicitClassName,
          ).withNamedConstructor('_').withTypedParameter('\$_name', 'String?'),
        );
      },
    );

    test(
      'then implicit class has private constructor with initializer for private fields from prefixed with "\$"',
      () {
        expect(
          compilationUnit,
          containsClass(implicitClassName)
              .withNamedConstructor('_')
              .withFieldInitializer('_name')
              .withArgument('\$_name'),
        );
      },
    );

    test(
      'then implicit class has private constructor with parameters from original class',
      () {
        expect(
          compilationUnit,
          containsClass(implicitClassName)
              .withNamedConstructor('_')
              .withTypedParameter('extra', 'bool', isRequired: true),
        );
        expect(
          compilationUnit,
          containsClass(
            implicitClassName,
          ).withNamedConstructor('_').withTypedParameter('id', 'int?'),
        );
      },
    );

    test(
      'then implicit class constructor has super initializer named parameters from original class',
      () {
        expect(
          compilationUnit,
          containsClass(implicitClassName)
              .withNamedConstructor('_')
              .withSuperInitializer()
              .withNamedArgument('id', 'id'),
        );

        expect(
          compilationUnit,
          containsClass(implicitClassName)
              .withNamedConstructor('_')
              .withSuperInitializer()
              .withNamedArgument('extra', 'extra'),
        );
      },
    );

    test(
      'then an unnamed factory constructor with params from original class and additional fields is defined',
      () {
        expect(
          compilationUnit,
          containsClass(implicitClassName)
              .withUnnamedConstructor(isFactory: true)
              .withTypedParameter(testClassName.camelCase, testClassName),
        );
        expect(
          compilationUnit,
          containsClass(implicitClassName)
              .withUnnamedConstructor(isFactory: true)
              .withTypedParameter('\$_name', 'String?'),
        );
      },
    );
  });

  group('Given a class with two fields that should persist but is scoped too none', () {
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName('example')
          .withField(
            FieldDefinitionBuilder()
                .withName('_firstName')
                .withType(TypeDefinition(className: 'String', nullable: true))
                .withShouldPersist(true)
                .withScope(ModelFieldScopeDefinition.none)
                .build(),
          )
          .withField(
            FieldDefinitionBuilder()
                .withName('_age')
                .withType(TypeDefinition.int.asNullable)
                .withShouldPersist(true)
                .withScope(ModelFieldScopeDefinition.none)
                .build(),
          )
          .build(),
    ];

    late var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    late var compilationUnit = parseCode(codeMap[expectedFilePath]!);

    test(
      'then the implicit class has the field name with type set to nullable String',
      () {
        expect(
          compilationUnit,
          containsClass('${testClassName}Implicit').withField(
            '_firstName',
            isNullable: true,
            isOverride: true,
            type: 'String',
          ),
        );
      },
    );

    test(
      'then the implicit class has the field age with type set to nullable int',
      () {
        expect(
          compilationUnit,
          containsClass('${testClassName}Implicit').withField(
            '_age',
            isNullable: true,
            isOverride: true,
            type: 'int',
          ),
        );
      },
    );

    test(
      'then the implicit class has a private constructor with params from the original class and the additional fields',
      () {
        expect(
          compilationUnit,
          containsClass(
            '${testClassName}Implicit',
          ).withNamedConstructor('_').withTypedParameter('id', 'int?'),
        );
        expect(
          compilationUnit,
          containsClass('${testClassName}Implicit')
              .withNamedConstructor('_')
              .withTypedParameter('\$_firstName', 'String?'),
        );
        expect(
          compilationUnit,
          containsClass(
            '${testClassName}Implicit',
          ).withNamedConstructor('_').withTypedParameter('\$_age', 'int?'),
        );
      },
    );

    test(
      'then the implicit class has private constructor with call to super with og parameters',
      () {
        expect(
          compilationUnit,
          containsClass('${testClassName}Implicit')
              .withNamedConstructor('_')
              .withSuperInitializer()
              .withNamedArgument('id', 'id'),
        );
      },
    );
  });
}
