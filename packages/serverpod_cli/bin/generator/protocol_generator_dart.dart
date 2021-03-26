import 'package:recase/recase.dart';

import 'protocol_definition.dart';
import 'protocol_generator.dart';

class ProtocolGeneratorDart extends ProtocolGenerator {
  ProtocolGeneratorDart({ProtocolDefinition protocolDefinition}) : super(protocolDefinition: protocolDefinition);

  String generateClientEndpointCalls() {
    String out = '';

    // Header
    out += '/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */\n';
    out += '/*   To generate run: "serverpod generate"    */\n';
    out += '\n';

    out += 'import \'dart:io\';\n';
    out += 'import \'package:serverpod_client/serverpod_client.dart\';\n';
    out += 'import \'protocol.dart\';\n';
    out += '\n';

    // Endpoints
    for (EndpointDefinition endpointDef in protocolDefinition.endpoints) {
      String endpointClassName = _endpointClassName(endpointDef.name);

      out += 'class $endpointClassName {\n';
      out += '  Client client;\n';

      out += '  $endpointClassName(this.client);\n';

      // Add methods
      for (MethodDefinition methodDef in endpointDef.methods) {
        var requiredParams = methodDef.parameters;
        var optionalParams = methodDef.parametersPositional;
        String returnType = methodDef.returnType;
        assert(returnType.startsWith('Future<'));
        assert(returnType.endsWith('>'));
        String returnTypeNoFuture = returnType.substring(7, returnType.length -1);

        // Method definition
        out += '\n';
        out += '  Future<$returnTypeNoFuture${returnTypeNoFuture != 'void' ? '?' : ''}> ${methodDef.name}(';

        if (requiredParams != null) {
          for (var paramDef in requiredParams) {
            out += '${paramDef.type}? ${paramDef.name},';
          }
        }

        if (optionalParams != null && optionalParams.length > 0) {
          out += '[';

          for (var paramDef in optionalParams) {
            out += '${paramDef.type}? ${paramDef.name},';
          }

          out += ']';
        }

        out += ') async {\n';

        // Call to server endpoint
        out += '    return await client.callServerEndpoint(\'${endpointDef.name}\', \'${methodDef.name}\', \'$returnTypeNoFuture\', {\n';

        if (requiredParams != null) {
          for (var paramDef in requiredParams) {
            out += '      \'${paramDef.name}\':${paramDef.name},\n';
          }
        }

        if (optionalParams != null) {
          for (var paramDef in optionalParams) {
            out += '      \'${paramDef.name}\': ${paramDef.name},\n';
          }
        }

        out += '    });\n';
        out += '  }\n';
      }

      out += '}\n';
      out += '\n';
    }

    // Class definition
    out += 'class Client extends ServerpodClient {\n';

    for (var endpointDef in protocolDefinition.endpoints) {
      out += '  late final ${_endpointClassName(endpointDef.name)} ${endpointDef.name};\n';
    }

    out += '\n';
    out += '  Client(host, {SecurityContext? context, ServerpodClientErrorCallback? errorHandler, AuthenticationKeyManager? authenticationKeyManager}) : super(host, Protocol.instance, context: context, errorHandler: errorHandler, authenticationKeyManager: authenticationKeyManager) {\n';
    for (var endpointDef in protocolDefinition.endpoints) {
      out += '    ${endpointDef.name} = ${_endpointClassName(endpointDef.name)}(this);\n';
    }
    out += '  }\n';

    out += '}\n';


    return out;
  }

  String _endpointClassName(String endpointName) {
    return '_Endpoint${ReCase(endpointName).pascalCase}';
  }
}