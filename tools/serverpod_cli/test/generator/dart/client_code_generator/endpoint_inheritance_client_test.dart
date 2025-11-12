import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/endpoint_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/method_definition_builder.dart';
import '../../../test_util/builders/module_config_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

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
    'client.dart',
  );

  group(
    'Given protocol definition with an endpoint that extends another endpoint when generating client file',
    () {
      var baseEndpointName = 'base';
      var subclassEndpointName = 'subclass';
      var baseMethodName = 'baseMethod';
      var subclassMethodName = 'subclassMethod';

      // Create base endpoint
      var baseEndpoint = EndpointDefinitionBuilder()
          .withClassName('${baseEndpointName.pascalCase}Endpoint')
          .withName(baseEndpointName)
          .withMethods([
            MethodDefinitionBuilder()
                .withName(baseMethodName)
                .buildMethodCallDefinition(),
          ])
          .build();

      // Create endpoint that extends base endpoint
      var subclassEndpoint = EndpointDefinitionBuilder()
          .withClassName('${subclassEndpointName.pascalCase}Endpoint')
          .withName(subclassEndpointName)
          .withExtends(baseEndpoint)
          .withMethods([
            MethodDefinitionBuilder()
                .withName(baseMethodName)
                .buildMethodCallDefinition(),
            MethodDefinitionBuilder()
                .withName(subclassMethodName)
                .buildMethodCallDefinition(),
          ])
          .build();

      var protocolDefinition = ProtocolDefinition(
        endpoints: [baseEndpoint, subclassEndpoint],
        models: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test('then client file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      late var clientCompilationUnit = parseString(
        content: codeMap[expectedFileName]!,
      ).unit;

      test('then generated client file contains subclass endpoint class.', () {
        var subclass = CompilationUnitHelpers.tryFindClassDeclaration(
          clientCompilationUnit,
          name: 'Endpoint${subclassEndpointName.pascalCase}',
        );
        expect(subclass, isNotNull);
      });

      group('then generated subclass endpoint', () {
        late var subclass = CompilationUnitHelpers.tryFindClassDeclaration(
          clientCompilationUnit,
          name: 'Endpoint${subclassEndpointName.pascalCase}',
        )!;

        test('extends base endpoint.', () {
          expect(
            CompilationUnitHelpers.hasExtendsClause(
              subclass,
              name: 'Endpoint${baseEndpointName.pascalCase}',
            ),
            isTrue,
          );
        });

        test('has override annotation on inherited call method.', () {
          var baseMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            subclass,
            name: baseMethodName,
          );
          expect(baseMethod, isNotNull);

          var hasOverrideAnnotation = baseMethod!.metadata.any(
            (annotation) => annotation.name.name == 'override',
          );
          expect(hasOverrideAnnotation, isTrue);
        });
      });

      group('then generated Client class', () {
        late var clientClass = CompilationUnitHelpers.tryFindClassDeclaration(
          clientCompilationUnit,
          name: 'Client',
        )!;

        test('has late variable for subclass endpoint.', () {
          var endpointField = CompilationUnitHelpers.tryFindFieldDeclaration(
            clientClass,
            name: subclassEndpointName,
          );

          expect(endpointField, isNotNull);
        });

        test('initializes subclass endpoint in constructor body.', () {
          var constructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                clientClass,
                name: null,
              )!;

          var constructorBody = constructor.body.toString();
          expect(constructorBody, contains(subclassEndpointName));
        });

        test('contains subclass endpoint in endpointRefLookup.', () {
          var endpointRefLookupMethod =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                clientClass,
                name: 'endpointRefLookup',
              )!;

          var methodBody = endpointRefLookupMethod.body.toString();
          expect(methodBody, contains("'$subclassEndpointName'"));
        });
      });
    },
  );

  group(
    'Given protocol definition with an endpoint that extends an endpoint from other module when generating client file',
    () {
      var baseEndpointName = 'base';
      var subclassEndpointName = 'subclass';
      var baseMethodName = 'baseMethod';
      var baseStreamMethodName = 'baseStreamMethod';
      var subclassMethodName = 'subclassMethod';

      var externalModule = ModuleConfigBuilder('serverpod_test_module')
          .withServerPackageDirectoryPathParts([
            'tests',
            'serverpod_test_module',
            'serverpod_test_module_server',
          ])
          .build();

      // Create base endpoint
      var baseEndpoint = EndpointDefinitionBuilder()
          .withClassName('${baseEndpointName.pascalCase}Endpoint')
          .withName(baseEndpointName)
          .withFilePath(
            'example.dart',
            externalServerPackage: externalModule.serverPackage,
          )
          .withMethods([
            MethodDefinitionBuilder()
                .withName(baseMethodName)
                .buildMethodCallDefinition(),
            MethodDefinitionBuilder()
                .withName(baseStreamMethodName)
                .buildMethodStreamDefinition(),
          ])
          .build();

      // Create endpoint that extends base endpoint
      var subclassEndpoint = EndpointDefinitionBuilder()
          .withClassName('${subclassEndpointName.pascalCase}Endpoint')
          .withName(subclassEndpointName)
          .withExtends(baseEndpoint)
          .withMethods([
            MethodDefinitionBuilder()
                .withName(baseMethodName)
                .buildMethodCallDefinition(),
            MethodDefinitionBuilder()
                .withName(baseStreamMethodName)
                .buildMethodStreamDefinition(),
            MethodDefinitionBuilder()
                .withName(subclassMethodName)
                .buildMethodCallDefinition(),
          ])
          .build();

      var protocolDefinition = ProtocolDefinition(
        endpoints: [subclassEndpoint],
        models: [],
      );

      final customConfig = GeneratorConfigBuilder()
          .withName(projectName)
          .withModules([externalModule])
          .build();

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: customConfig,
      );

      test('then client file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      late var clientCompilationUnit = parseString(
        content: codeMap[expectedFileName]!,
      ).unit;

      test(
        'then generated client file contains import for external module.',
        () {
          var hasImport = CompilationUnitHelpers.hasImportDirective(
            clientCompilationUnit,
            uri: externalModule.dartImportUrl(false),
          );
          expect(hasImport, isTrue);
        },
      );

      group('then generated subclass endpoint class', () {
        late var subclassClass = CompilationUnitHelpers.tryFindClassDeclaration(
          clientCompilationUnit,
          name: 'Endpoint${subclassEndpointName.pascalCase}',
        );

        test('exists.', () {
          expect(subclassClass, isNotNull);
        });

        test('extends external module base endpoint.', () {
          var baseEndpoint = 'Endpoint${baseEndpointName.pascalCase}';
          var subclassEndpoint = 'Endpoint${subclassEndpointName.pascalCase}';

          expect(
            codeMap[expectedFileName],
            matches(
              RegExp('$subclassEndpoint extends _i[0-9]+[.]$baseEndpoint'),
            ),
          );
        });
      });
    },
  );
}
