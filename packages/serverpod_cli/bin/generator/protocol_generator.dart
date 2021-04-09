import 'dart:io';

import 'package:path/path.dart' as p;

import 'config.dart';
import 'protocol_definition.dart';
import 'protocol_analyzer.dart';
import 'protocol_generator_dart.dart';

Future<void> performGenerateProtocol(bool verbose) async {
  // Analyze the endpoint classes
  if (verbose)
    print('Analyzing protol');
  ProtocolDefinition definition = await performAnalysis(verbose);
  var generator = ProtocolGeneratorDart(protocolDefinition: definition);

  // Generate code for the client
  if (verbose)
    print('Generating client endpoints');
  var protocol = generator.generateClientEndpointCalls();
  if (verbose)
    print(protocol);

  var filePath = config.generatedClientDart + '/client.dart';
  if (verbose)
    print('Writing: $filePath');
  File outFile = File(filePath);
  outFile.createSync();
  outFile.writeAsStringSync(protocol);
  
  // Generate server mappings with endpoint connectors
  if (verbose)
    print('Generating server endpoint dispatch');
  var endpointDispatch = generator.generateServerEndpointDispatch();
  if (verbose)
    print(endpointDispatch);

  var endpointsFilePath = config.generatedServerProtocol + '/endpoints.dart';
  if (verbose)
    print('Writing: $endpointsFilePath');
  File endpointsFile = File(endpointsFilePath);
  endpointsFile.createSync();
  endpointsFile.writeAsStringSync(endpointDispatch);
}

abstract class ProtocolGenerator {
  final ProtocolDefinition protocolDefinition;

  ProtocolGenerator({required this.protocolDefinition});

  String generateServerEndpointDispatch() {
    String out = '';

    // Header
    out += '/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */\n';
    out += '/*   To generate run: "serverpod generate"    */\n';
    out += '\n';

    // Imports
    out += 'import \'package:serverpod/serverpod.dart\';\n';
    out += '\n';
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
    out += '  void initializeEndpoints(Server server) {\n';


    // Endpoints lookup map
    out += '    Map<String, Endpoint> endpoints = {\n';
    for (var endpoint in protocolDefinition.endpoints) {
      out += '      \'${endpoint.name}\': ${endpoint.className}()..initialize(server, \'${endpoint.name}\'),\n';
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
          out += '            \'${param.name}\': ParameterDescription(name: \'${param.name}\', type: ${param.type}),\n';
        }
        out += '          },\n';
        out += '          call: (Session session, Map<String, dynamic> params) async {\n';
        out += '            return (endpoints[\'${endpoint.name}\'] as ${endpoint.className}).${method.name}(session,';
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

    // End init method
    out += '  }\n';

    // Endpoint class end
    out += '}\n';

    out += '\n';

    return out;
  }

  String generateClientEndpointCalls();
}