import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/endpoint_definition_builder.dart';
import '../../../../test_util/builders/exception_class_definition_builder.dart';
import '../../../../test_util/builders/generator_config_builder.dart';
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
    'Given a hierarchy with a sealed parent exception, a normal child and a normal grandchild when generating protocol files',
    () {
      var parentClassName = 'AppException';
      var parentClassFileName = 'app_exception';

      var childClassName = 'NotFoundException';
      var childClassFileName = 'not_found_exception';

      var grandchildClassName = 'UserNotFoundException';
      var grandchildClassFileName = 'user_not_found_exception';

      var parent = ExceptionClassDefinitionBuilder()
          .withClassName(parentClassName)
          .withFileName(parentClassFileName)
          .withSimpleField('message', 'String')
          .withIsSealed(true)
          .build();

      var child = ExceptionClassDefinitionBuilder()
          .withClassName(childClassName)
          .withFileName(childClassFileName)
          .withSimpleField('code', 'int', nullable: true)
          .withExtendsClass(parent)
          .build();

      var grandChild = ExceptionClassDefinitionBuilder()
          .withClassName(grandchildClassName)
          .withFileName(grandchildClassFileName)
          .withSimpleField('userId', 'int', nullable: true)
          .withExtendsClass(child)
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

      var protocolDefinition = ProtocolDefinition(
        endpoints: endpoints,
        models: models,
        futureCalls: [],
      );

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      var protocolCompilationUnit = parseString(
        content: codeMap[expectedFileName]!,
      ).unit;

      var protocolClass = CompilationUnitHelpers.tryFindClassDeclaration(
        protocolCompilationUnit,
        name: 'Protocol',
      );

      test('then the protocol.dart file is created.', () {
        expect(protocolCompilationUnit, isNotNull);
      });

      group('then the protocol.dart file', () {
        test('does export the sealed top node $parentClassFileName.', () {
          var parentExport = CompilationUnitHelpers.tryFindExportDirective(
            protocolCompilationUnit,
            uri: '$parentClassFileName.dart',
          );

          expect(parentExport, isNotNull);
        });

        test('does NOT export the child part file $childClassFileName.', () {
          var childExport = CompilationUnitHelpers.tryFindExportDirective(
            protocolCompilationUnit,
            uri: '$childClassFileName.dart',
          );

          expect(childExport, isNull);
        });

        test(
          'does NOT export the grandchild part file $grandchildClassFileName.',
          () {
            var grandchildExport =
                CompilationUnitHelpers.tryFindExportDirective(
                  protocolCompilationUnit,
                  uri: '$grandchildClassFileName.dart',
                );

            expect(grandchildExport, isNull);
          },
        );

        test('does NOT import the child part file $childClassFileName.', () {
          var childImport = CompilationUnitHelpers.tryFindImportDirective(
            protocolCompilationUnit,
            uri: '$childClassFileName.dart',
          );

          expect(childImport, isNull);
        });

        test(
          'does NOT import the grandchild part file $grandchildClassFileName.',
          () {
            var grandchildImport =
                CompilationUnitHelpers.tryFindImportDirective(
                  protocolCompilationUnit,
                  uri: '$grandchildClassFileName.dart',
                );

            expect(grandchildImport, isNull);
          },
        );
      });

      group('then the Protocol class', () {
        test('is defined.', () {
          expect(protocolClass, isNotNull);
        });

        group('with a deserialize method', () {
          var deserializeMethod =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                protocolClass!,
                name: 'deserialize',
              );

          test('defined.', () {
            expect(deserializeMethod, isNotNull);
          });

          test(
            'that does NOT return $parentClassName.fromJson.',
            () {
              expect(
                deserializeMethod!.toSource().contains(
                  '$parentClassName.fromJson',
                ),
                isFalse,
              );
            },
          );

          test('that returns $childClassName.fromJson.', () {
            expect(
              deserializeMethod!.toSource().contains(
                '$childClassName.fromJson',
              ),
              isTrue,
            );
          });

          test('that returns $grandchildClassName.fromJson.', () {
            expect(
              deserializeMethod!.toSource().contains(
                '$grandchildClassName.fromJson',
              ),
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

          test('defined.', () {
            expect(getClassNameForObjectMethod, isNotNull);
          });

          test('that does NOT return $parentClassName.', () {
            expect(
              getClassNameForObjectMethod!.toSource().contains(
                '$parentClassName():',
              ),
              isFalse,
            );
          });

          test('that returns $childClassName.', () {
            expect(
              getClassNameForObjectMethod!.toSource().contains(
                '$childClassName():',
              ),
              isTrue,
            );
          });

          test('that returns $grandchildClassName.', () {
            expect(
              getClassNameForObjectMethod!.toSource().contains(
                '$grandchildClassName():',
              ),
              isTrue,
            );
          });
        });

        group('with a deserializeByClassName method', () {
          var deserializeByClassNameMethod =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                protocolClass!,
                name: 'deserializeByClassName',
              );

          test('defined.', () {
            expect(deserializeByClassNameMethod, isNotNull);
          });

          test(
            'that does NOT deserialize $parentClassName.',
            () {
              expect(
                deserializeByClassNameMethod!.toSource().contains(
                  'dataClassName == \'$parentClassName\'',
                ),
                isFalse,
              );
            },
          );

          test('that deserializes $childClassName.', () {
            expect(
              deserializeByClassNameMethod!.toSource().contains(
                'dataClassName == \'$childClassName\'',
              ),
              isTrue,
            );
          });

          test('that deserializes $grandchildClassName.', () {
            expect(
              deserializeByClassNameMethod!.toSource().contains(
                'dataClassName == \'$grandchildClassName\'',
              ),
              isTrue,
            );
          });
        });
      });
    },
  );
}
