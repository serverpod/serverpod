import 'dart:io';

import 'package:path/path.dart' as p;

import 'config.dart';
import 'protocol_analyzer.dart';
import 'protocol_definition.dart';
import 'protocol_generator_dart.dart';

Future<void> performGenerateProtocol(
  bool verbose, {
  bool requestNewAnalyzer = true,
}) async {
  // Analyze the endpoint classes
  if (verbose) print('Analyzing protocol');
  var definition = await performAnalysis(
    verbose,
    requestNewAnalyzer: requestNewAnalyzer,
  );
  var generator = ProtocolGeneratorDart(protocolDefinition: definition);

  // Generate code for the client
  if (verbose) print('Generating client endpoints');
  var protocol = generator.generateClientEndpointCalls();
  if (verbose) print(protocol);

  var filePath = p.join(config.generatedClientProtocolPath, 'client.dart');
  if (verbose) print('Writing: $filePath');
  var outFile = File(filePath);
  outFile.createSync();
  outFile.writeAsStringSync(protocol);

  // Generate server mappings with endpoint connectors
  if (verbose) print('Generating server endpoint dispatch');
  var endpointDispatch = generator.generateServerEndpointDispatch();
  if (verbose) print(endpointDispatch);

  var endpointsFilePath =
      p.join(config.generatedServerProtocolPath,'endpoints.dart');
  if (verbose) print('Writing: $endpointsFilePath');
  var endpointsFile = File(endpointsFilePath);
  endpointsFile.createSync();
  endpointsFile.writeAsStringSync(endpointDispatch);

  // Write endpoint definition
  var endpointDef = generator.generateEndpointDefinition();
  var endpointDefPath = p.join('generated','protocol.yaml');
  if (verbose) print('Writing: $endpointDefPath');
  var endpointsDefFile = File(endpointDefPath);
  endpointsDefFile.createSync();
  endpointsDefFile.writeAsStringSync(endpointDef);
}

abstract class ProtocolGenerator {
  final ProtocolDefinition protocolDefinition;

  ProtocolGenerator({required this.protocolDefinition});

  String generateServerEndpointDispatch() {
    var hasModules = config.modules.isNotEmpty;

    var out = '';

    // Header
    out += '/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */\n';
    out += '/*   To generate run: "serverpod generate"    */\n';
    out += '\n';
    out += '// ignore_for_file: public_member_api_docs\n';
    out += '// ignore_for_file: unnecessary_import\n';
    out += '// ignore_for_file: unused_import\n';
    out += '\n';

    // Imports
    out += 'import \'dart:typed_data\' as typed_data;\n';
    out += 'import \'package:serverpod/serverpod.dart\';\n';
    out += '\n';
    if (hasModules) {
      for (var module in config.modules) {
        out +=
            'import \'package:${module.serverPackage}/module.dart\' as ${module.name};\n';
      }
      out += '\n';
    }
    out += 'import \'protocol.dart\';\n';
    out += '\n';
    for (var importPath in protocolDefinition.filePaths) {
      var fileName = '../endpoints/' + p.basename(importPath);
      out += 'import \'$fileName\';\n';
    }
    out += '\n';

    // Endpoint class
    out += 'class Endpoints extends EndpointDispatch {\n';

    // Init method
    out += '  @override\n';
    out += '  void initializeEndpoints(Server server) {\n';

    // Endpoints lookup map
    var moduleName =
        config.type == PackageType.server ? 'null' : '\'${config.name}\'';
    out += '    var endpoints = <String, Endpoint>{\n';
    for (var endpoint in protocolDefinition.endpoints) {
      out +=
          '      \'${endpoint.name}\': ${endpoint.className}()..initialize(server, \'${endpoint.name}\', $moduleName),\n';
    }
    out += '    };\n';

    // Connectors
    for (var endpoint in protocolDefinition.endpoints) {
      out += '\n';
      out += '    connectors[\'${endpoint.name}\'] = EndpointConnector(\n';
      out += '      name: \'${endpoint.name}\',\n';
      out += '      endpoint: endpoints[\'${endpoint.name}\']!,\n';
      out += '      methodConnectors: {\n';
      for (var method in endpoint.methods) {
        out += '        \'${method.name}\': MethodConnector(\n';
        out += '          name: \'${method.name}\',\n';
        out += '          params: {\n';
        for (var param in method.parameters) {
          out +=
              '            \'${param.name}\': ParameterDescription(name: \'${param.name}\', type: ${param.type.typePrefix}${param.type.typeNonNullable}, nullable: ${param.type.nullable}),\n';
        }
        out += '          },\n';
        out +=
            '          call: (Session session, Map<String, dynamic> params) async {\n';
        out +=
            '            return (endpoints[\'${endpoint.name}\'] as ${endpoint.className}).${method.name}(session,';
        for (var param in method.parameters) {
          out += 'params[\'${param.name}\'],';
        }
        for (var param in method.parametersPositional) {
          out += 'params[\'${param.name}\'],';
        }
        out += ');\n';
        out += '          },\n';
        out += '        ),\n';
      }
      out += '      },\n';
      out += '    );\n';
    }

    // Hook up modules
    if (hasModules) {
      out += '\n';
      for (var module in config.modules) {
        out +=
            '    modules[\'${module.name}\'] = ${module.name}.Endpoints()..initializeEndpoints(server);\n';
      }
    }

    // End init method
    out += '  }\n';

    // Register modules
    out += '\n';
    out += '  @override\n';
    out += '  void registerModules(Serverpod pod) {\n';
    for (var module in config.modules) {
      out +=
          '    pod.registerModule(${module.name}.Protocol(), \'${module.nickname}\');\n';
    }
    out += '  }\n';

    // Endpoint class end
    out += '}\n';

    out += '\n';

    return out;
  }

  String generateClientEndpointCalls();

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
