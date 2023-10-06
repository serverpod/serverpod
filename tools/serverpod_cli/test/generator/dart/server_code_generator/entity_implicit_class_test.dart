import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:recase/recase.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/serializable_entity_field_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/compilation_unit_helpers.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var testClassName = 'Example';
  var testClassFileName = 'example';
  var expectedFilePath =
      path.join('lib', 'src', 'generated', '$testClassFileName.dart');

  test(
      'Given a class with no fields that should persist but is scoped too none then no implicit class is generated.',
      () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName('example')
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    expect(
      CompilationUnitHelpers.hasClassDeclaration(
        compilationUnit,
        name: '${testClassName}Implicit',
      ),
      isFalse,
    );
  });
  group('Given a class with a field that should persist but is scoped too none',
      () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName('example')
          .withSimpleField('extra', 'bool')
          .withField(FieldDefinitionBuilder()
              .withName('_name')
              .withType(TypeDefinition(className: 'String', nullable: true))
              .withShouldPersist(true)
              .withScope(EntityFieldScopeDefinition.none)
              .build())
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    var implicitClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}Implicit',
    );
    test('then an implicit class is generated', () {
      expect(implicitClass, isNotNull);
    });

    group('then the implicit class has the field', () {
      var field = CompilationUnitHelpers.tryFindFieldDeclaration(
        implicitClass!,
        name: '\$_name',
      );
      test('defined', () {
        expect(field, isNotNull);
      });

      test('with the type set to nullable int', () {
        expect(field?.toSource(), 'String? \$_name;');
      });
    }, skip: implicitClass == null);

    group('then a private constructor', () {
      var constructor = CompilationUnitHelpers.tryFindConstructorDeclaration(
        implicitClass!,
        name: '_',
      );

      test('is defined', () {
        expect(constructor, isNotNull);
      });

      test('with the params from the original class and the additional fields',
          () {
        expect(
          constructor?.parameters.toSource(),
          '({int? id, required bool extra, this.\$_name})',
        );
      });

      test('with a call to super with the og params', () {
        expect(
          constructor?.initializers.first.toSource(),
          'super(id: id, extra: extra)',
        );
      });

      test('then an override allToJson method is defined', () {
        var method = CompilationUnitHelpers.tryFindMethodDeclaration(
            implicitClass,
            name: 'allToJson');

        expect(method, isNotNull);
        expect(method?.returnType?.toSource(), 'Map<String, dynamic>');
      });
    });

    group('then a factory constructor without a name', () {
      var constructor = CompilationUnitHelpers.tryFindConstructorDeclaration(
        implicitClass!,
        name: null,
      );
      test('is defined', () {
        expect(constructor, isNotNull);
      });

      test('is a factory', () {
        expect(constructor?.factoryKeyword, isNotNull);
      });

      test('with the params from the original class and the additional fields',
          () {
        expect(
          constructor?.parameters.toSource(),
          '($testClassName ${testClassName.camelCase}, {String? \$_name})',
        );
      });
    });
  });

  group(
      'Given a class with two fields that should persist but is scoped too none',
      () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName('example')
          .withField(FieldDefinitionBuilder()
              .withName('_firstName')
              .withType(TypeDefinition(className: 'String', nullable: true))
              .withShouldPersist(true)
              .withScope(EntityFieldScopeDefinition.none)
              .build())
          .withField(FieldDefinitionBuilder()
              .withName('_age')
              .withType(TypeDefinition.int.asNullable)
              .withShouldPersist(true)
              .withScope(EntityFieldScopeDefinition.none)
              .build())
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    var implicitClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}Implicit',
    );

    group('then the implicit class has the field name', () {
      var field = CompilationUnitHelpers.tryFindFieldDeclaration(
        implicitClass!,
        name: '\$_firstName',
      );
      test('defined', () {
        expect(field, isNotNull);
      });

      test('with the type set to nullable int', () {
        expect(field?.toSource(), 'String? \$_firstName;');
      });
    }, skip: implicitClass == null);

    group('then the implicit class has the field age', () {
      var field = CompilationUnitHelpers.tryFindFieldDeclaration(
        implicitClass!,
        name: '\$_age',
      );
      test('defined', () {
        expect(field, isNotNull);
      });

      test('with the type set to nullable int', () {
        expect(field?.toSource(), 'int? \$_age;');
      });
    }, skip: implicitClass == null);

    group('then a private constructor', () {
      var constructor = CompilationUnitHelpers.tryFindConstructorDeclaration(
        implicitClass!,
        name: '_',
      );

      test('is defined', () {
        expect(constructor, isNotNull);
      });

      test('with the params from the original class and the additional fields',
          () {
        expect(
          constructor?.parameters.toSource(),
          '({int? id, this.\$_firstName, this.\$_age})',
        );
      });

      test('with a call to super with the og params', () {
        expect(
          constructor?.initializers.first.toSource(),
          'super(id: id)',
        );
      });
    });

    test('then an override allToJson method is defined', () {
      var method = CompilationUnitHelpers.tryFindMethodDeclaration(
          implicitClass!,
          name: 'allToJson');

      expect(method, isNotNull);
      expect(method?.returnType?.toSource(), 'Map<String, dynamic>');
    }, skip: implicitClass == null);
  });
}
