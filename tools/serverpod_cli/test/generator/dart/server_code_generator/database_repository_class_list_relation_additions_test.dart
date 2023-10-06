import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
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

  group('Given a class with table name when generating code', () {
    var tableName = 'example_table';
    var entities = [
      ClassDefinitionBuilder()
          .withFileName(testClassFileName)
          .withTableName(tableName)
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    test('then a class named ${testClassName}AttachRepository is NOT generated',
        () {
      expect(
        CompilationUnitHelpers.hasClassDeclaration(
          compilationUnit,
          name: '${testClassName}AttachRepository',
        ),
        isFalse,
        reason:
            'The class ${testClassName}AttachRepository was found but was expected to not exist.',
      );
    });
  });

  group(
      'Given a class with table name and explicit list relation field when generating code',
      () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName('example_table')
          .withListRelationField(
            'people',
            'Person',
            'organizationId',
            nullableRelation: true,
          )
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    var repositoryClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}Repository',
    );

    group('then the class name ${testClassName}Repository', () {
      test('has a final attach field', () {
        var field = CompilationUnitHelpers.tryFindFieldDeclaration(
          repositoryClass!,
          name: 'attachRow',
        );

        expect(
          field?.toSource(),
          'final attachRow = const ${testClassName}AttachRowRepository._();',
          reason: 'Missing static instance field.',
        );
      });

      test('has a final detach field', () {
        var field = CompilationUnitHelpers.tryFindFieldDeclaration(
          repositoryClass!,
          name: 'detachRow',
        );

        expect(
          field?.toSource(),
          'final detachRow = const ${testClassName}DetachRowRepository._();',
          reason: 'Missing static instance field.',
        );
      });
    }, skip: repositoryClass == null);

    test('then a class named ${testClassName}AttachRowRepository is generated',
        () {
      expect(
        CompilationUnitHelpers.hasClassDeclaration(
          compilationUnit,
          name: '${testClassName}AttachRowRepository',
        ),
        isTrue,
        reason:
            'Expected the class ${testClassName}AttachRowRepository to be generated.',
      );
    });

    var repositoryAttachRowClass =
        CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}AttachRowRepository',
    );

    group('then the ${testClassName}AttachRowRepository', () {
      var peopleMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
        repositoryAttachRowClass!,
        name: 'people',
      );

      test('has a people method defined.', () {
        expect(peopleMethod, isNotNull, reason: 'Missing people method.');
      });

      test('people method has the input params of session, example and person',
          () {
        expect(
          peopleMethod?.parameters?.toSource(),
          matches(
            r'(_i\d.Session session, Example example, Person person)',
          ),
        );
      }, skip: peopleMethod == null);
    });

    test('then a class named ${testClassName}AttachRepository is generated',
        () {
      expect(
        CompilationUnitHelpers.hasClassDeclaration(
          compilationUnit,
          name: '${testClassName}AttachRepository',
        ),
        isTrue,
        reason:
            'Expected the class ${testClassName}AttachRepository to be generated.',
      );
    });

    var repositoryAttachClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}AttachRepository',
    );

    group('then the ${testClassName}AttachRepository', () {
      test('has a private constructor', () {
        var constructor = CompilationUnitHelpers.tryFindConstructorDeclaration(
          repositoryAttachClass!,
          name: '_',
        );
        expect(
          constructor?.toSource(),
          'const ${testClassName}AttachRepository._();',
          reason: 'Missing private constructor.',
        );
      });

      var peopleMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
        repositoryAttachClass!,
        name: 'people',
      );

      test('has a people method defined.', () {
        expect(peopleMethod, isNotNull, reason: 'Missing people method.');
      });

      test('people method has the input params of session, example and person',
          () {
        expect(
          peopleMethod?.parameters?.toSource(),
          matches(
            r'(_i\d.Session session, Example example, List<Person> person)',
          ),
        );
      }, skip: peopleMethod == null);
    }, skip: repositoryAttachClass == null);

    test('then a class named ${testClassName}DetachRowRepository is generated',
        () {
      expect(
        CompilationUnitHelpers.hasClassDeclaration(
          compilationUnit,
          name: '${testClassName}DetachRowRepository',
        ),
        isTrue,
        reason:
            'Expected the class ${testClassName}DetachRowRepository to be generated.',
      );
    });

    var repositoryDetachRowClass =
        CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}DetachRowRepository',
    );
    group('then the ${testClassName}DetachRowRepository', () {
      var peopleMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
        repositoryDetachRowClass!,
        name: 'people',
      );

      test('has a people method defined.', () {
        expect(peopleMethod, isNotNull, reason: 'Missing people method.');
      });

      test('people method has the input params of session, person', () {
        expect(
          peopleMethod?.parameters?.toSource(),
          '(_i1.Session session, _i1.Person person)',
        );
      }, skip: peopleMethod == null);
    }, skip: repositoryClass == null);
  });

  group(
      'Given a class with table name and implicit list relation field when generating code',
      () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName('example_table')
          .withImplicitListRelationField('citizens', 'Person')
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    print(codeMap);

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    var repositoryAttachRowClass =
        CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}AttachRowRepository',
    );

    group('then the ${testClassName}AttachRowRepository', () {
      var citizenMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
        repositoryAttachRowClass!,
        name: 'citizens',
      );

      test('has a citizens method defined.', () {
        expect(citizenMethod, isNotNull, reason: 'Missing citizens method.');
      });

      test(
          'citizens method has the input params of session, example and person',
          () {
        expect(
          citizenMethod?.parameters?.toSource(),
          matches(
            r'(_i\d.Session session, Example example, Person person)',
          ),
        );
      }, skip: citizenMethod == null);
    });

    var repositoryDetachRowClass =
        CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}DetachRowRepository',
    );

    group('then the ${testClassName}DetachRowRepository', () {
      var citizenMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
        repositoryDetachRowClass!,
        name: 'citizens',
      );

      test('has a citizens method defined.', () {
        expect(citizenMethod, isNotNull, reason: 'Missing citizens method.');
      });

      test('citizens method has the input params of session, person', () {
        expect(
          citizenMethod?.parameters?.toSource(),
          '(_i1.Session session, _i1.Person person)',
        );
      }, skip: citizenMethod == null);
    });
  });
}
