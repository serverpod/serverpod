import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/endpoint_definition_builder.dart';
import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/interface_class_definition_builder.dart';
import '../../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var expectedFileName = path.join(
    'lib',
    'src',
    'generated',
    'protocol.dart',
  );

  group('Given an interface class when generating code', () {
    var interfaceName = 'ExampleInterface';
    var interfaceFileName = 'example_interface';

    var interfaceClass = InterfaceClassDefinitionBuilder()
        .withClassName(interfaceName)
        .withFileName(interfaceFileName)
        .build();

    var models = [
      interfaceClass,
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
        expect(protocolClass, isNotNull);
      },
    );

    group('then the protocol.dart file', () {
      test('does NOT import the $interfaceFileName', () {
        var interfaceImport = CompilationUnitHelpers.tryFindImportDirective(
          protocolCompilationUnit,
          uri: '$interfaceFileName.dart',
        );

        expect(interfaceImport, isNull);
      });

      test('does export the $interfaceFileName', () {
        var interfaceExport = CompilationUnitHelpers.tryFindExportDirective(
          protocolCompilationUnit,
          uri: '$interfaceFileName.dart',
        );
        expect(interfaceExport, isNotNull);
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

        test('is defined', () {
          expect(deserializeMethod, isNotNull);
        });

        test('that does NOT return $interfaceName.fromJson', () {
          expect(
            deserializeMethod!.toSource().contains('$interfaceName.fromJson'),
            isFalse,
          );
        });
      });

      group('with a getClassNameForObject method', () {
        var getClassNameForObjectMethod =
            CompilationUnitHelpers.tryFindMethodDeclaration(
          protocolClass!,
          name: 'getClassNameForObject',
        );

        test('is defined', () {
          expect(getClassNameForObjectMethod, isNotNull);
        });

        test('that does NOT return $interfaceName', () {
          expect(
            getClassNameForObjectMethod!.toSource().contains(interfaceName),
            isFalse,
          );
        });
      });

      group('with a deserializeByClassName method', () {
        var deserializeByClassNameMethod =
            CompilationUnitHelpers.tryFindMethodDeclaration(
          protocolClass!,
          name: 'deserializeByClassName',
        );

        test('is defined', () {
          expect(deserializeByClassNameMethod, isNotNull);
        });

        test('that does NOT return $interfaceName', () {
          expect(
            deserializeByClassNameMethod!.toSource().contains(interfaceName),
            isFalse,
          );
        });
      });
    });
  });
}
