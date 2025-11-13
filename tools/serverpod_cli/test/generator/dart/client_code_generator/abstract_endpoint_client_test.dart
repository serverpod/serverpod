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
    'Given protocol definition with an abstract endpoint when generating client file',
    () {
      var endpointName = 'testing';
      var methodName = 'testMethod';
      var streamMethodName = 'streamMethod';

      // Create abstract endpoint definition
      var abstractEndpoint = EndpointDefinitionBuilder()
          .withClassName('${endpointName.pascalCase}Endpoint')
          .withName(endpointName)
          .withIsAbstract()
          .withMethods([
            MethodDefinitionBuilder()
                .withName(methodName)
                .buildMethodCallDefinition(),
            MethodDefinitionBuilder()
                .withName(streamMethodName)
                .buildMethodStreamDefinition(),
          ])
          .build();

      var protocolDefinition = ProtocolDefinition(
        endpoints: [abstractEndpoint],
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

      test(
        'then the generated client file has the endpoint class defined.',
        () {
          var endpointClass = CompilationUnitHelpers.tryFindClassDeclaration(
            clientCompilationUnit,
            name: 'Endpoint${endpointName.pascalCase}',
          );

          expect(endpointClass, isNotNull);
        },
      );

      group('then generated endpoint class', () {
        late var abstractEndpointClass =
            CompilationUnitHelpers.tryFindClassDeclaration(
              clientCompilationUnit,
              name: 'Endpoint${endpointName.pascalCase}',
            )!;

        test('has the abstract keyword.', () {
          expect(abstractEndpointClass.abstractKeyword, isNotNull);
        });

        test('extends EndpointRef.', () {
          expect(
            CompilationUnitHelpers.hasExtendsClause(
              abstractEndpointClass,
              name: 'EndpointRef',
            ),
            isTrue,
          );
        });

        test('has a constructor.', () {
          var constructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                abstractEndpointClass,
                name: null,
              );
          expect(constructor, isNotNull);
        });

        test('has an abstract call method with no body.', () {
          var method = CompilationUnitHelpers.tryFindMethodDeclaration(
            abstractEndpointClass,
            name: methodName,
          );
          expect(method, isNotNull);
          expect(method!.body.toSource(), ';');
        });

        test('has an abstract stream method with no body.', () {
          var method = CompilationUnitHelpers.tryFindMethodDeclaration(
            abstractEndpointClass,
            name: streamMethodName,
          );
          expect(method, isNotNull);
          expect(method!.body.toSource(), ';');
        });
      });

      group('then generated Client class', () {
        late var clientClass = CompilationUnitHelpers.tryFindClassDeclaration(
          clientCompilationUnit,
          name: 'Client',
        )!;

        test('does not have late variable for abstract endpoint.', () {
          var endpointField = CompilationUnitHelpers.tryFindFieldDeclaration(
            clientClass,
            name: endpointName,
          );

          expect(endpointField, isNull);
        });

        test('does not initialize abstract endpoint in constructor body.', () {
          var constructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                clientClass,
                name: null,
              )!;

          var constructorBody = constructor.body.toString();
          expect(constructorBody.contains(endpointName), isFalse);
        });

        test('does not contain abstract endpoint in endpointRefLookup.', () {
          var endpointRefLookupMethod =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                clientClass,
                name: 'endpointRefLookup',
              )!;

          var methodBody = endpointRefLookupMethod.body.toString();
          expect(methodBody.contains("'$endpointName'"), isFalse);
        });
      });
    },
  );

  group(
    'Given protocol definition with a concrete endpoint that extends an abstract base endpoint when generating client file',
    () {
      var baseEndpointName = 'base';
      var concreteEndpointName = 'concrete';
      var baseMethodName = 'baseMethod';
      var baseStreamMethodName = 'baseStreamMethod';
      var concreteMethodName = 'concreteMethod';

      // Create abstract base endpoint
      var abstractBaseEndpoint = EndpointDefinitionBuilder()
          .withClassName('${baseEndpointName.pascalCase}Endpoint')
          .withName(baseEndpointName)
          .withIsAbstract()
          .withMethods([
            MethodDefinitionBuilder()
                .withName(baseMethodName)
                .buildMethodCallDefinition(),
            MethodDefinitionBuilder()
                .withName(baseStreamMethodName)
                .buildMethodStreamDefinition(),
          ])
          .build();

      // Create concrete endpoint that extends base abstract endpoint
      var concreteEndpoint = EndpointDefinitionBuilder()
          .withClassName('${concreteEndpointName.pascalCase}Endpoint')
          .withName(concreteEndpointName)
          .withExtends(abstractBaseEndpoint)
          .withMethods([
            MethodDefinitionBuilder()
                .withName(baseMethodName)
                .buildMethodCallDefinition(),
            MethodDefinitionBuilder()
                .withName(baseStreamMethodName)
                .buildMethodStreamDefinition(),
            MethodDefinitionBuilder()
                .withName(concreteMethodName)
                .buildMethodCallDefinition(),
          ])
          .build();

      var protocolDefinition = ProtocolDefinition(
        endpoints: [abstractBaseEndpoint, concreteEndpoint],
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

      group('then generated client file', () {
        test('contains abstract base endpoint class.', () {
          var abstractClass = CompilationUnitHelpers.tryFindClassDeclaration(
            clientCompilationUnit,
            name: 'Endpoint${baseEndpointName.pascalCase}',
          );
          expect(abstractClass, isNotNull);
          expect(abstractClass!.abstractKeyword, isNotNull);
        });

        test('contains concrete endpoint class.', () {
          var concreteClass = CompilationUnitHelpers.tryFindClassDeclaration(
            clientCompilationUnit,
            name: 'Endpoint${concreteEndpointName.pascalCase}',
          );
          expect(concreteClass, isNotNull);
          expect(concreteClass!.abstractKeyword, isNull);
        });
      });

      group('then generated concrete endpoint class', () {
        late var concreteClass = CompilationUnitHelpers.tryFindClassDeclaration(
          clientCompilationUnit,
          name: 'Endpoint${concreteEndpointName.pascalCase}',
        )!;

        test('has no abstract keyword.', () {
          expect(concreteClass.abstractKeyword, isNull);
        });

        test('extends abstract base endpoint.', () {
          expect(
            CompilationUnitHelpers.hasExtendsClause(
              concreteClass,
              name: 'Endpoint${baseEndpointName.pascalCase}',
            ),
            isTrue,
          );
        });

        test('has implemented methods.', () {
          var baseMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            concreteClass,
            name: baseMethodName,
          );
          expect(baseMethod, isNotNull);
          expect(baseMethod!.body.toSource(), isNot(';'));

          var baseStreamMethod =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                concreteClass,
                name: baseStreamMethodName,
              );
          expect(baseStreamMethod, isNotNull);
          expect(baseStreamMethod!.body.toSource(), isNot(';'));

          var concreteMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            concreteClass,
            name: concreteMethodName,
          );
          expect(concreteMethod, isNotNull);
          expect(concreteMethod!.body.toSource(), isNot(';'));
        });

        test('has override annotation on inherited call method.', () {
          var baseMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            concreteClass,
            name: baseMethodName,
          );
          expect(baseMethod, isNotNull);

          var hasOverrideAnnotation = baseMethod!.metadata.any(
            (annotation) => annotation.name.name == 'override',
          );
          expect(hasOverrideAnnotation, isTrue);
        });

        test('has override annotation on inherited stream method.', () {
          var baseStreamMethod =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                concreteClass,
                name: baseStreamMethodName,
              );
          expect(baseStreamMethod, isNotNull);

          var hasOverrideAnnotation = baseStreamMethod!.metadata.any(
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

        test('has late variable for concrete endpoint.', () {
          var endpointField = CompilationUnitHelpers.tryFindFieldDeclaration(
            clientClass,
            name: concreteEndpointName,
          );

          expect(endpointField, isNotNull);
        });

        test('initializes concrete endpoint in constructor body.', () {
          var constructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                clientClass,
                name: null,
              )!;

          var constructorBody = constructor.body.toString();
          expect(constructorBody, contains(concreteEndpointName));
        });

        test('contains concrete endpoint in endpointRefLookup.', () {
          var endpointRefLookupMethod =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                clientClass,
                name: 'endpointRefLookup',
              )!;

          var methodBody = endpointRefLookupMethod.body.toString();
          expect(methodBody, contains("'$concreteEndpointName'"));
        });
      });
    },
  );

  group(
    'Given protocol definition with a concrete endpoint that extends an abstract base endpoint from other module when generating client file',
    () {
      var baseEndpointName = 'base';
      var concreteEndpointName = 'concrete';
      var baseMethodName = 'baseMethod';
      var baseStreamMethodName = 'baseStreamMethod';
      var concreteMethodName = 'concreteMethod';

      var externalModule = ModuleConfigBuilder('serverpod_test_module')
          .withServerPackageDirectoryPathParts([
            'tests',
            'serverpod_test_module',
            'serverpod_test_module_server',
          ])
          .build();

      // Create abstract base endpoint
      var abstractBaseEndpoint = EndpointDefinitionBuilder()
          .withClassName('${baseEndpointName.pascalCase}Endpoint')
          .withName(baseEndpointName)
          .withIsAbstract()
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

      // Create concrete endpoint that extends base abstract endpoint
      var concreteEndpoint = EndpointDefinitionBuilder()
          .withClassName('${concreteEndpointName.pascalCase}Endpoint')
          .withName(concreteEndpointName)
          .withExtends(abstractBaseEndpoint)
          .withMethods([
            MethodDefinitionBuilder()
                .withName(baseMethodName)
                .buildMethodCallDefinition(),
            MethodDefinitionBuilder()
                .withName(baseStreamMethodName)
                .buildMethodStreamDefinition(),
            MethodDefinitionBuilder()
                .withName(concreteMethodName)
                .buildMethodCallDefinition(),
          ])
          .build();

      var protocolDefinition = ProtocolDefinition(
        endpoints: [concreteEndpoint],
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

      group('then generated concrete endpoint class', () {
        late var concreteClass = CompilationUnitHelpers.tryFindClassDeclaration(
          clientCompilationUnit,
          name: 'Endpoint${concreteEndpointName.pascalCase}',
        );

        test('exists as non-abstract class.', () {
          expect(concreteClass, isNotNull);
          expect(concreteClass!.abstractKeyword, isNull);
        });

        test('extends external module abstract base endpoint.', () {
          var baseEndpoint = 'Endpoint${baseEndpointName.pascalCase}';
          var concreteEndpoint = 'Endpoint${concreteEndpointName.pascalCase}';

          expect(
            codeMap[expectedFileName],
            matches(
              RegExp('$concreteEndpoint extends _i[0-9]+[.]$baseEndpoint'),
            ),
          );
        });
      });
    },
  );

  group(
    'Given protocol definition with abstract > concrete > abstract subclass > concrete subclass endpoint hierarchy when generating client file',
    () {
      var abstractBaseEndpointName = 'baseAbstract';
      var concreteBaseEndpointName = 'base';
      var abstractSubClassEndpointName = 'abstractSubClass';
      var concreteSubclassEndpointName = 'subclass';

      var abstractBaseEndpoint = EndpointDefinitionBuilder()
          .withClassName('BaseAbstractEndpoint')
          .withName(abstractBaseEndpointName)
          .withIsAbstract()
          .withMethods([
            MethodDefinitionBuilder()
                .withName('baseMethod')
                .buildMethodCallDefinition(),
          ])
          .build();

      var concreteBaseEndpoint = EndpointDefinitionBuilder()
          .withClassName('BaseEndpoint')
          .withName(concreteBaseEndpointName)
          .withExtends(abstractBaseEndpoint)
          .withMethods([
            MethodDefinitionBuilder()
                .withName('baseMethod')
                .buildMethodCallDefinition(),
          ])
          .build();

      var abstractSubClassEndpoint = EndpointDefinitionBuilder()
          .withClassName('AbstractSubClassEndpoint')
          .withName(abstractSubClassEndpointName)
          .withIsAbstract()
          .withExtends(concreteBaseEndpoint)
          .withMethods([
            MethodDefinitionBuilder()
                .withName('abstractSubClassMethod')
                .buildMethodCallDefinition(),
          ])
          .build();

      var concreteSubclassEndpoint = EndpointDefinitionBuilder()
          .withClassName('SubclassEndpoint')
          .withName(concreteSubclassEndpointName)
          .withExtends(abstractSubClassEndpoint)
          .withMethods([
            MethodDefinitionBuilder()
                .withName('subclassMethod')
                .buildMethodCallDefinition(),
          ])
          .build();

      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          abstractBaseEndpoint,
          concreteBaseEndpoint,
          abstractSubClassEndpoint,
          concreteSubclassEndpoint,
        ],
        models: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test('then client file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      group('then generated client file', () {
        late var clientCompilationUnit = parseString(
          content: codeMap[expectedFileName]!,
        ).unit;

        test('contains abstract base endpoint class.', () {
          var endpointClass = CompilationUnitHelpers.tryFindClassDeclaration(
            clientCompilationUnit,
            name: 'Endpoint${abstractBaseEndpointName.pascalCase}',
          );

          expect(endpointClass, isNotNull);
          expect(endpointClass!.abstractKeyword, isNotNull);
        });

        test(
          'contains concrete base endpoint class that extends abstract base.',
          () {
            var endpointClass = CompilationUnitHelpers.tryFindClassDeclaration(
              clientCompilationUnit,
              name: 'Endpoint${concreteBaseEndpointName.pascalCase}',
            );

            expect(endpointClass, isNotNull);
            expect(endpointClass!.abstractKeyword, isNull);
            expect(
              CompilationUnitHelpers.hasExtendsClause(
                endpointClass,
                name: 'Endpoint${abstractBaseEndpointName.pascalCase}',
              ),
              isTrue,
            );
          },
        );

        test(
          'contains abstract subclass endpoint class that extends concrete base.',
          () {
            var endpointClass = CompilationUnitHelpers.tryFindClassDeclaration(
              clientCompilationUnit,
              name: 'Endpoint${abstractSubClassEndpointName.pascalCase}',
            );

            expect(endpointClass, isNotNull);
            expect(endpointClass!.abstractKeyword, isNotNull);
            expect(
              CompilationUnitHelpers.hasExtendsClause(
                endpointClass,
                name: 'Endpoint${concreteBaseEndpointName.pascalCase}',
              ),
              isTrue,
            );
          },
        );

        test(
          'contains concrete subclass endpoint class that extends abstract subclass.',
          () {
            var endpointClass = CompilationUnitHelpers.tryFindClassDeclaration(
              clientCompilationUnit,
              name: 'Endpoint${concreteSubclassEndpointName.pascalCase}',
            );

            expect(endpointClass, isNotNull);
            expect(endpointClass!.abstractKeyword, isNull);
            expect(
              CompilationUnitHelpers.hasExtendsClause(
                endpointClass,
                name: 'Endpoint${abstractSubClassEndpointName.pascalCase}',
              ),
              isTrue,
            );
          },
        );
      });
    },
  );
}
