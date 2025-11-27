import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/endpoint_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/method_definition_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/parameter_definition_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../test_util/builders/type_definition_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartClientCodeGenerator();

void main() {
  String getExpectedFilePath(String fileName, {List<String>? subDirParts}) =>
      p.joinAll([
        '..',
        'example_project_client',
        'lib',
        'src',
        'protocol',
        ...?subDirParts,
        '$fileName.dart',
      ]);

  group(
    'Given a hierarchy with a sealed parent that has a model and a normal child, when generating code',
    () {
      var parent = ModelClassDefinitionBuilder()
          .withSubDirParts(['subdir'])
          .withClassName('Example')
          .withFileName('example')
          .withField(
            FieldDefinitionBuilder()
                .withName('user')
                .withType(
                  TypeDefinitionBuilder()
                      .withClassName('User')
                      .withUrl(defaultModuleAlias)
                      .build(),
                )
                .build(),
          )
          .withIsSealed(true)
          .build();

      var child = ModelClassDefinitionBuilder()
          .withSubDirParts(['subdir'])
          .withClassName('ExampleChild')
          .withFileName('example_child')
          .withSimpleField('age', 'int')
          .withExtendsClass(parent)
          .build();

      var user = ModelClassDefinitionBuilder()
          .withSubDirParts(['subdir'])
          .withClassName('User')
          .withFileName('user')
          .withSimpleField('name', 'String')
          .build();

      parent.childClasses.add(ResolvedInheritanceDefinition(child));

      var models = [
        parent,
        child,
        user,
      ];

      late var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late var parentCompilationUnit = parseString(
        content:
            codeMap[getExpectedFilePath(
              parent.fileName,
              subDirParts: ['subdir'],
            )]!,
      ).unit;

      test(
        'then the ${parent.className} has a relative protocol import directive correctly generated',
        () {
          var protocolImport = CompilationUnitHelpers.tryFindImportDirective(
            parentCompilationUnit,
            uri: '../protocol.dart',
          );

          expect(protocolImport, isNotNull);
        },
      );
    },
  );

  group(
    'Given an endpoint that has a UuidValue parameter imported from Serverpod when generating client code',
    () {
      var endpoint = EndpointDefinitionBuilder()
          .withClassName('ExampleEndpoint')
          .withName('example')
          .withMethods([
            MethodDefinitionBuilder().withName('getById').withParameters([
              ParameterDefinitionBuilder()
                  .withName('id')
                  .withType(
                    TypeDefinitionBuilder()
                        .withClassName('UuidValue')
                        .withUrl('serverpod')
                        .build(),
                  )
                  .build(),
            ]).buildMethodCallDefinition(),
          ])
          .build();

      var protocolDefinition = ProtocolDefinition(
        endpoints: [endpoint],
        models: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      late var clientCompilationUnit = parseString(
        content: codeMap[getExpectedFilePath('client')]!,
      ).unit;

      test(
        'then the generated client file has an import directive for serverpod_client',
        () {
          var import = CompilationUnitHelpers.tryFindImportDirective(
            clientCompilationUnit,
            uri: 'package:serverpod_client/serverpod_client.dart',
          );

          expect(import, isNotNull);
        },
      );

      test(
        'then the generated client does not have an import directive for UuidValue',
        () {
          var import = CompilationUnitHelpers.tryFindImportDirective(
            clientCompilationUnit,
            uri: 'package:uuid/uuid.dart',
          );

          expect(import, isNull);
        },
      );
    },
  );

  group(
    'Given an endpoint that has a UuidValue parameter imported from package:uuid/uuid.dart when generating client code',
    () {
      var endpoint = EndpointDefinitionBuilder()
          .withClassName('ExampleEndpoint')
          .withName('example')
          .withMethods([
            MethodDefinitionBuilder().withName('getById').withParameters([
              ParameterDefinitionBuilder()
                  .withName('id')
                  .withType(
                    TypeDefinitionBuilder()
                        .withClassName('UuidValue')
                        .withUrl('package:uuid/uuid.dart')
                        .build(),
                  )
                  .build(),
            ]).buildMethodCallDefinition(),
          ])
          .build();

      var protocolDefinition = ProtocolDefinition(
        endpoints: [endpoint],
        models: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      late var clientCompilationUnit = parseString(
        content: codeMap[getExpectedFilePath('client')]!,
      ).unit;

      test(
        'then the generated client file has an import directive for serverpod_client',
        () {
          var import = CompilationUnitHelpers.tryFindImportDirective(
            clientCompilationUnit,
            uri: 'package:serverpod_client/serverpod_client.dart',
          );

          expect(import, isNotNull);
        },
      );

      test(
        'then the generated client does not have an import directive for uuid/uuid.dart',
        () {
          var import = CompilationUnitHelpers.tryFindImportDirective(
            clientCompilationUnit,
            uri: 'package:uuid/uuid.dart',
          );

          expect(import, isNull);
        },
      );
    },
  );

  group(
    'Given an endpoint that has a UuidValue parameter imported from package:uuid/uuid_value.dart when generating client code',
    () {
      var endpoint = EndpointDefinitionBuilder()
          .withClassName('ExampleEndpoint')
          .withName('example')
          .withMethods([
            MethodDefinitionBuilder().withName('getById').withParameters([
              ParameterDefinitionBuilder()
                  .withName('id')
                  .withType(
                    TypeDefinitionBuilder()
                        .withClassName('UuidValue')
                        .withUrl('package:uuid/uuid_value.dart')
                        .build(),
                  )
                  .build(),
            ]).buildMethodCallDefinition(),
          ])
          .build();

      var protocolDefinition = ProtocolDefinition(
        endpoints: [endpoint],
        models: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      late var clientCompilationUnit = parseString(
        content: codeMap[getExpectedFilePath('client')]!,
      ).unit;

      test(
        'then the generated client file has an import directive for serverpod_client',
        () {
          var import = CompilationUnitHelpers.tryFindImportDirective(
            clientCompilationUnit,
            uri: 'package:serverpod_client/serverpod_client.dart',
          );

          expect(import, isNotNull);
        },
      );

      test(
        'then the generated client does not have an import directive for uuid/uuid_value.dart',
        () {
          var import = CompilationUnitHelpers.tryFindImportDirective(
            clientCompilationUnit,
            uri: 'package:uuid/uuid_value.dart',
          );

          expect(import, isNull);
        },
      );
    },
  );

  group(
    'Given an endpoint that has a UuidValue parameter imported from unkown source when generating client code',
    () {
      var endpoint = EndpointDefinitionBuilder()
          .withClassName('ExampleEndpoint')
          .withName('example')
          .withMethods([
            MethodDefinitionBuilder().withName('getById').withParameters([
              ParameterDefinitionBuilder()
                  .withName('id')
                  .withType(
                    TypeDefinitionBuilder()
                        .withClassName('UuidValue')
                        .withUrl('package:custom_uuid/uuid.dart')
                        .build(),
                  )
                  .build(),
            ]).buildMethodCallDefinition(),
          ])
          .build();

      var protocolDefinition = ProtocolDefinition(
        endpoints: [endpoint],
        models: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      late var clientCompilationUnit = parseString(
        content: codeMap[getExpectedFilePath('client')]!,
      ).unit;

      test(
        'then the generated client file has an import directive for unknown source',
        () {
          var import = CompilationUnitHelpers.tryFindImportDirective(
            clientCompilationUnit,
            uri: 'package:custom_uuid/uuid.dart',
          );

          expect(import, isNotNull);
        },
      );
    },
  );
}
