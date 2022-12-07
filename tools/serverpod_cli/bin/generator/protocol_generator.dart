import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:path/path.dart' as p;

import 'class_generator_dart.dart';
import 'code_analysis_collector.dart';
import 'config.dart';
import 'generator.dart';
import 'protocol_definition.dart';
import 'protocol_generator_dart.dart';

Future<void> performGenerateProtocol({
  required bool verbose,
  required ProtocolDefinition protocolDefinition,
  required CodeAnalysisCollector collector,
  required CodeGenerator codeGenerator,
}) async {
  var generator = ProtocolGeneratorDart(protocolDefinition: protocolDefinition);

  // Generate code for the client
  if (verbose) print('Generating client endpoints');
  var protocol = generator.generateClientEndpointCalls();
  if (verbose) print(protocol);

  var filePath = p.join(config.generatedClientProtocolPath, 'client.dart');
  if (verbose) print('Writing: $filePath');
  var outFile = File(filePath);
  outFile.createSync();
  outFile.writeAsStringSync(codeGenerator(protocol));
  collector.addGeneratedFile(outFile);

  // Generate server mappings with endpoint connectors
  if (verbose) print('Generating server endpoint dispatch');
  var endpointDispatch =
      codeGenerator(generator.generateServerEndpointDispatch());
  if (verbose) print(endpointDispatch);

  var endpointsFilePath =
      p.join(config.generatedServerProtocolPath, 'endpoints.dart');
  if (verbose) print('Writing: $endpointsFilePath');
  var endpointsFile = File(endpointsFilePath);
  endpointsFile.createSync();
  endpointsFile.writeAsStringSync(endpointDispatch);
  collector.addGeneratedFile(endpointsFile);

  // Write endpoint definition
  var endpointDef = generator.generateEndpointDefinition();
  var endpointDefPath = p.join('generated', 'protocol.yaml');
  if (verbose) print('Writing: $endpointDefPath');
  var endpointsDefFile = File(endpointDefPath);
  endpointsDefFile.createSync();
  endpointsDefFile.writeAsStringSync(endpointDef);
}

abstract class ProtocolGenerator {
  final ProtocolDefinition protocolDefinition;

  ProtocolGenerator({required this.protocolDefinition});

  Library generateServerEndpointDispatch() {
    var library = LibraryBuilder();

    String endpointPath(EndpointDefinition endpoint) =>
        '../endpoints/${p.basename(endpoint.fileName)}';

    // Endpoint class
    library.body.add(
      Class(
        (c) => c
          ..name = 'Endpoints'
          ..extend = refer('EndpointDispatch', serverpodUrl(true))
          // Init method
          ..methods.add(
            Method.returnsVoid(
              (m) => m
                ..name = 'initializeEndpoints'
                ..annotations.add(refer('override'))
                ..requiredParameters.add(Parameter(((p) => p
                  ..name = 'server'
                  ..type = refer('Server', serverpodUrl(true)))))
                ..body = Block.of([
                  // Endpoints lookup map
                  refer('var endpoints')
                      .assign(literalMap({
                        for (var endpoint in protocolDefinition.endpoints)
                          endpoint.name:
                              refer(endpoint.className, endpointPath(endpoint))
                                  .call([])
                                  .cascade('initialize')
                                  .call([
                                    refer('server'),
                                    literalString(endpoint.name),
                                    config.type == PackageType.server
                                        ? refer('null')
                                        : literalString(config.name)
                                  ])
                      }, refer('String'),
                          refer('Endpoint', serverpodUrl(true))))
                      .statement,
                  // Connectors
                  for (var endpoint in protocolDefinition.endpoints)
                    refer('connectors')
                        .index(literalString(endpoint.name))
                        .assign(refer('EndpointConnector', serverpodUrl(true))
                            .call([], {
                          'name': literalString(endpoint.name),
                          'endpoint': refer('endpoints')
                              .index(literalString(endpoint.name))
                              .nullChecked,
                          'methodConnectors': literalMap({
                            for (var method in endpoint.methods)
                              literalString(method.name):
                                  refer('MethodConnector', serverpodUrl(true))
                                      .call([], {
                                'name': literalString(method.name),
                                'params': literalMap({
                                  for (var param in [
                                    ...method.parameters,
                                    ...method.parametersPositional,
                                    ...method.parametersNamed,
                                  ])
                                    literalString(param.name): refer(
                                            'ParameterDescription',
                                            serverpodUrl(true))
                                        .call([], {
                                      'name': literalString(param.name),
                                      'type':
                                          refer('getType', serverpodUrl(true))
                                              .call([], {},
                                                  [param.type.reference(true)]),
                                      'nullable':
                                          literalBool(param.type.nullable),
                                    })
                                }),
                                'call': Method(
                                  (m) => m
                                    ..requiredParameters.addAll([
                                      Parameter((p) => p
                                        ..name = 'session'
                                        ..type = refer(
                                            'Session', serverpodUrl(true))),
                                      Parameter((p) => p
                                        ..name = 'params'
                                        ..type = TypeReference((t) => t
                                          ..symbol = 'Map'
                                          ..types.addAll([
                                            refer('String'),
                                            refer('dynamic'),
                                          ])))
                                    ])
                                    ..modifier = MethodModifier.async
                                    ..body = refer('endpoints')
                                        .index(literalString(endpoint.name))
                                        .asA(refer(endpoint.className,
                                            endpointPath(endpoint)))
                                        .property(method.name)
                                        .call([
                                      refer('session'),
                                      for (var param in [
                                        ...method.parameters,
                                        ...method.parametersPositional
                                      ])
                                        refer('params')
                                            .index(literalString(param.name)),
                                    ], {
                                      for (var param in [
                                        ...method.parametersNamed
                                      ])
                                        param.name: refer('params')
                                            .index(literalString(param.name)),
                                    }).code,
                                ).closure,
                              }),
                          })
                        }))
                        .statement,
                  // Hook up modules
                  for (var module in config.modules)
                    refer('modules')
                        .index(literalString(module.name))
                        .assign(refer('Endpoints',
                                'package:${module.serverPackage}/module.dart')
                            .call([])
                            .cascade('initializeEndpoints')
                            .call([refer('server')]))
                        .statement,
                ]),
            ),
          ),
      ),
    );

    return library.build();
  }

  Library generateClientEndpointCalls();

  String generateEndpointDefinition() {
    // TODO: Also output parameter and return type data

    var out = '';
    for (var endpoint in protocolDefinition.endpoints) {
      out += '${endpoint.name}:\n';
      for (var method in endpoint.methods) {
        out += '  - ${method.name}:\n';
      }
    }

    return out;
  }
}
