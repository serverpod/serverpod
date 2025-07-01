import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/endpoint_definition_builder.dart';
import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_class_definition_builder.dart';
import '../../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartClientCodeGenerator();

void main() {
  var expectedFileName = path.join(
    '..',
    'example_project_client',
    'lib',
    'src',
    'protocol',
    'protocol.dart',
  );

  group(
      'Given a hierarchy with a sealed parent, a normal child and a normal grandchild when generating protocol files',
      () {
    var parentClassName = 'Example';
    var parentClassFileName = 'example';

    var childClassName = 'ChildExample';
    var childClassFileName = 'child_example';

    var grandchildClassName = 'GrandChildExample';
    var grandchildClassFileName = 'grand_child_example';

    var parent = ModelClassDefinitionBuilder()
        .withClassName(parentClassName)
        .withFileName(parentClassFileName)
        .withSimpleField('name', 'String')
        .withIsSealed(true)
        .build();

    var child = ModelClassDefinitionBuilder()
        .withClassName(childClassName)
        .withFileName(childClassFileName)
        .withSimpleField('age', 'int', nullable: true)
        .withExtendsClass(
          parent,
        )
        .build();

    var grandChild = ModelClassDefinitionBuilder()
        .withClassName(grandchildClassName)
        .withFileName(grandchildClassFileName)
        .withSimpleField('height', 'int', nullable: true)
        .withExtendsClass(
          child,
        )
        .build();

    parent.childClasses.add(ResolvedInheritanceDefinition(child));
    child.childClasses.add(ResolvedInheritanceDefinition(grandChild));

    var models = [
      parent,
      child,
      grandChild,
    ];

    var endpoints = [
      EndpointDefinitionBuilder().build(),
    ];

    var protocolDefinition =
        ProtocolDefinition(endpoints: endpoints, models: models);

    var codeMap = generator.generateProtocolCode(
      protocolDefinition: protocolDefinition,
      config: config,
    );

    var protocolCompilationUnit =
        parseString(content: codeMap[expectedFileName]!).unit;

    var protocolClass = CompilationUnitHelpers.tryFindClassDeclaration(
      protocolCompilationUnit,
      name: 'Protocol',
    );

    test(
      'then the protocol.dart file is created.',
      () {
        expect(protocolCompilationUnit, isNotNull);
      },
    );

    group('then the protocol.dart file', () {
      test('does import the $parentClassFileName', () {
        var parentImport = CompilationUnitHelpers.tryFindImportDirective(
          protocolCompilationUnit,
          uri: '$parentClassFileName.dart',
        );
        expect(
          parentImport,
          isNotNull,
        );
      });
      test('does export the $parentClassFileName', () {
        var parentExport = CompilationUnitHelpers.tryFindExportDirective(
          protocolCompilationUnit,
          uri: '$parentClassFileName.dart',
        );
        expect(
          parentExport,
          isNotNull,
        );
      });

      test('does NOT import the $childClassFileName', () {
        var childImport = CompilationUnitHelpers.tryFindImportDirective(
          protocolCompilationUnit,
          uri: '$childClassFileName.dart',
        );
        expect(
          childImport,
          isNull,
        );
      });

      test('does NOT export the $childClassFileName', () {
        var childExport = CompilationUnitHelpers.tryFindExportDirective(
          protocolCompilationUnit,
          uri: '$childClassFileName.dart',
        );
        expect(
          childExport,
          isNull,
        );
      });

      test('does NOT import the $grandchildClassFileName', () {
        var grandchildImport = CompilationUnitHelpers.tryFindImportDirective(
          protocolCompilationUnit,
          uri: '$grandchildClassFileName.dart',
        );
        expect(
          grandchildImport,
          isNull,
        );
      });

      test('does NOT export the $grandchildClassFileName', () {
        var grandchildExport = CompilationUnitHelpers.tryFindExportDirective(
          protocolCompilationUnit,
          uri: '$grandchildClassFileName.dart',
        );
        expect(
          grandchildExport,
          isNull,
        );
      });
    });

    group('then the Protocol class', () {
      test('is defined', () {
        expect(protocolClass, isNotNull);
      });

      group('with a deserialize method', () {
        var deserializeMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          protocolClass!,
          name: 'deserialize',
        );

        test('defined', () {
          expect(deserializeMethod, isNotNull);
        });

        test('that does NOT return $parentClassName.fromJson', () {
          expect(
            deserializeMethod!
                .toSource()
                .contains('return _i3.$parentClassName.fromJson'),
            isFalse,
          );
        });

        test('that returns $childClassName.fromJson with the top nodes alias',
            () {
          expect(
            deserializeMethod!
                .toSource()
                .contains('return _i2.$childClassName.fromJson'),
            isTrue,
          );
        });

        test(
            'that does return $grandchildClassName.fromJson with the top nodes alias',
            () {
          expect(
            deserializeMethod!
                .toSource()
                .contains('return _i2.$grandchildClassName.fromJson'),
            isTrue,
          );
        });
      });

      group('with a getClassNameForObject method', () {
        var getClassNameForObjectMethod =
            CompilationUnitHelpers.tryFindMethodDeclaration(
          protocolClass!,
          name: 'getClassNameForObject',
        );

        test('defined', () {
          expect(getClassNameForObjectMethod, isNotNull);
        });

        test('that does NOT return the $parentClassName', () {
          expect(
            getClassNameForObjectMethod!
                .toSource()
                .contains('case _i3.$parentClassName():'),
            isFalse,
          );
        });

        test('that returns the $childClassName with the top node alias', () {
          expect(
            getClassNameForObjectMethod!
                .toSource()
                .contains('case _i2.$childClassName():'),
            isTrue,
          );
        });

        test('that returns the $grandchildClassName with the top node alias',
            () {
          expect(
            getClassNameForObjectMethod!
                .toSource()
                .contains('case _i2.$grandchildClassName():'),
            isTrue,
          );
        });

        test('that returns the $grandchildClassName before the $childClassName',
            () {
          final getClassNameForObjectMethodSource =
              getClassNameForObjectMethod!.toSource();

          expect(
            getClassNameForObjectMethodSource
                .indexOf('case _i2.$grandchildClassName():'),
            lessThan(
              getClassNameForObjectMethodSource
                  .indexOf('case _i2.$childClassName():'),
            ),
          );
        });
      });

      group('with a deserializeByClassName method', () {
        var deserializeByClassNameMethod =
            CompilationUnitHelpers.tryFindMethodDeclaration(
          protocolClass!,
          name: 'deserializeByClassName',
        );

        test('defined', () {
          expect(deserializeByClassNameMethod, isNotNull);
        });

        test(
            'that does NOT return the $parentClassName with the top node alias',
            () {
          expect(
            deserializeByClassNameMethod!
                .toSource()
                .contains('return deserialize<_i3.Example>'),
            isFalse,
          );
        });

        test('that returns the $childClassName with the top node alias', () {
          expect(
            deserializeByClassNameMethod!
                .toSource()
                .contains('return deserialize<_i2.ChildExample>'),
            isTrue,
          );
        });

        test('that returns the $grandchildClassName with the top node alias',
            () {
          expect(
            deserializeByClassNameMethod!
                .toSource()
                .contains('return deserialize<_i2.GrandChildExample>'),
            isTrue,
          );
        });
      });
    });
  });
}
