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

    var repositoryAttachClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}AttachRowRepository',
    );

    group('then the ${testClassName}AttachRowRepository', () {
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
            r'(_i\d.Session session, Example example, Person person)',
          ),
        );
      }, skip: peopleMethod == null);
    });

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

    var repositoryDetachClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}DetachRowRepository',
    );
    group('then the ${testClassName}DetachRowRepository', () {
      var peopleMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
        repositoryDetachClass!,
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

    var repositoryAttachClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}AttachRowRepository',
    );

    group('then the ${testClassName}AttachRowRepository', () {
      var citizenMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
        repositoryAttachClass!,
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

    var repositoryDetachClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}DetachRowRepository',
    );

    group('then the ${testClassName}DetachRowRepository', () {
      var citizenMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
        repositoryDetachClass!,
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
