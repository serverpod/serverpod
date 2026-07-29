import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../test_util/builders/endpoint_definition_builder.dart';
import '../../test_util/builders/generator_config_builder.dart';
import '../../test_util/builders/method_definition_builder.dart';
import '../../test_util/builders/module_config_builder.dart';
import '../../test_util/builders/parameter_definition_builder.dart';
import '../../test_util/builders/type_definition_builder.dart';

const _projectName = 'example_project';
const _sharedPackageName = 'example_shared';
const _moduleName = 'example_module';
const _moduleSharedPackageName = 'example_module_shared';

const _serverGenerator = DartServerCodeGenerator();
const _clientGenerator = DartClientCodeGenerator();

final _serverEndpointsFileName = path.join(
  'lib',
  'src',
  'generated',
  'endpoints.dart',
);
final _clientFileName = path.join(
  '..',
  '${_projectName}_client',
  'lib',
  'src',
  'protocol',
  'client.dart',
);

/// An endpoint taking [url]-declared `SharedModel` as its only parameter. The
/// url mirrors what the analyzer reports: the library that declares the class,
/// which for a shared package model is inside its `lib/src`.
ProtocolDefinition _protocolDefinitionWithParameterFrom(String url) {
  return ProtocolDefinition(
    endpoints: [
      EndpointDefinitionBuilder()
          .withClassName('ExampleEndpoint')
          .withName('example')
          .withMethods([
            MethodDefinitionBuilder()
                .withName('echo')
                .withReturnType(
                  TypeDefinitionBuilder()
                      .withFutureOf('void')
                      .withUrl('dart:async')
                      .build(),
                )
                .withParameters([
                  ParameterDefinitionBuilder()
                      .withName('model')
                      .withType(
                        TypeDefinitionBuilder()
                            .withClassName('SharedModel')
                            .withUrl(url)
                            .build(),
                      )
                      .build(),
                ])
                .buildMethodCallDefinition(),
          ])
          .build(),
    ],
    models: [],
    futureCalls: [],
  );
}

void main() {
  group(
    'Given an endpoint taking a model from a shared package the project owns, '
    'when generating code,',
    () {
      late String serverEndpointsSource;
      late String clientSource;

      setUpAll(() {
        var config = GeneratorConfigBuilder()
            .withName(_projectName)
            .withSharedModelsSourcePathsParts({
              _sharedPackageName: ['..', _sharedPackageName],
            })
            .build();

        var protocolDefinition = _protocolDefinitionWithParameterFrom(
          'package:$_sharedPackageName/src/generated/shared_model.dart',
        );

        serverEndpointsSource = _serverGenerator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: config,
        )[_serverEndpointsFileName]!;
        clientSource = _clientGenerator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: config,
        )[_clientFileName]!;
      });

      test(
        'then the server endpoints file imports the shared package library.',
        () {
          expect(
            serverEndpointsSource,
            contains(
              "import 'package:$_sharedPackageName/$_sharedPackageName.dart'",
            ),
          );
          expect(
            serverEndpointsSource,
            isNot(contains('package:$_sharedPackageName/src/')),
          );
        },
      );

      test(
        'then the client file imports the shared package library.',
        () {
          expect(
            clientSource,
            contains(
              "import 'package:$_sharedPackageName/$_sharedPackageName.dart'",
            ),
          );
          expect(
            clientSource,
            isNot(contains('package:$_sharedPackageName/src/')),
          );
        },
      );
    },
  );

  group(
    'Given an endpoint taking a model from a shared package a module owns, '
    'when generating code,',
    () {
      late String serverEndpointsSource;
      late String clientSource;

      setUpAll(() {
        var config = GeneratorConfigBuilder()
            .withName(_projectName)
            .withModules([
              ModuleConfigBuilder(_moduleName).withSharedModelsSourcePathsParts(
                {
                  _moduleSharedPackageName: ['..', _moduleSharedPackageName],
                },
              ).build(),
            ])
            .build();

        var protocolDefinition = _protocolDefinitionWithParameterFrom(
          'package:$_moduleSharedPackageName/src/generated/shared_model.dart',
        );

        serverEndpointsSource = _serverGenerator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: config,
        )[_serverEndpointsFileName]!;
        clientSource = _clientGenerator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: config,
        )[_clientFileName]!;
      });

      test(
        'then the server endpoints file imports the module server package.',
        () {
          expect(
            serverEndpointsSource,
            contains(
              "import 'package:${_moduleName}_server/${_moduleName}_server.dart'",
            ),
          );
          expect(
            serverEndpointsSource,
            isNot(contains('package:$_moduleSharedPackageName/')),
          );
        },
      );

      test(
        'then the client file imports the module client package.',
        () {
          expect(
            clientSource,
            contains(
              "import 'package:${_moduleName}_client/${_moduleName}_client.dart'",
            ),
          );
          expect(
            clientSource,
            isNot(contains('package:$_moduleSharedPackageName/')),
          );
        },
      );
    },
  );
}
