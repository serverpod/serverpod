import 'package:recase/recase.dart';

import 'config.dart';
import 'protocol_definition.dart';
import 'protocol_generator.dart';

class ProtocolGeneratorDart extends ProtocolGenerator {
  ProtocolGeneratorDart({required ProtocolDefinition protocolDefinition}) : super(protocolDefinition: protocolDefinition);

  String generateClientEndpointCalls() {
    String out = '';

    // Header
    out += '/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */\n';
    out += '/*   To generate run: "serverpod generate"    */\n';
    out += '\n';

    out += 'import \'dart:io\';\n';
    out += 'import \'package:serverpod_client/serverpod_client.dart\';\n';
    out += '// ignore: unused_import\n';
    out += 'import \'protocol.dart\';\n';
    out += '\n';

    var hasBundles = config.bundles.length > 0 && config.type == PackageType.server;
    if (hasBundles) {
      for (var bundle in config.bundles) {
        out += 'import \'package:${bundle.config.clientPackage}/bundle.dart\' as ${bundle.package};\n';
      }
      out += '\n';
    }

    // Endpoints
    for (EndpointDefinition endpointDef in protocolDefinition.endpoints) {
      String endpointClassName = _endpointClassName(endpointDef.name);

      out += 'class $endpointClassName {\n';
      out += '  EndpointCaller caller;\n';

      out += '  $endpointClassName(this.caller);\n';

      // Add methods
      for (MethodDefinition methodDef in endpointDef.methods) {
        var requiredParams = methodDef.parameters;
        var optionalParams = methodDef.parametersPositional;
        var returnType = methodDef.returnType;

        // Method definition
        out += '\n';
        out += '  Future<${returnType.typePrefix}${returnType.type}> ${methodDef.name}(';

        for (var paramDef in requiredParams) {
          out += '${paramDef.type.typePrefix}${paramDef.type} ${paramDef.name},';
        }

        if (optionalParams.length > 0) {
          out += '[';

          for (var paramDef in optionalParams) {
            out += '${paramDef.type.type} ${paramDef.name},';
          }

          out += ']';
        }

        out += ') async {\n';

        // Call to server endpoint
        var prefix = config.type == PackageType.server ? '' : '${config.packageName}.';
        out += '    return await caller.callServerEndpoint(\'$prefix${endpointDef.name}\', \'${methodDef.name}\', \'${returnType.typeNonNullable}\', {\n';

        for (var paramDef in requiredParams) {
          out += '      \'${paramDef.name}\':${paramDef.name},\n';
        }

        for (var paramDef in optionalParams) {
          out += '      \'${paramDef.name}\': ${paramDef.name},\n';
        }

        out += '    });\n';
        out += '  }\n';
      }

      out += '}\n';
      out += '\n';
    }

    if (hasBundles) {
      out += 'class _Bundles {\n';
      for (var bundle in config.bundles) {
        out += '  late final ${bundle.package}.Caller ${bundle.name};\n';
      }
      out += '\n';

      out += '  _Bundles(Client client) {\n';
      for (var bundle in config.bundles) {
        out += '    bundle = ${bundle.package}.Caller(client);\n';
      }

      out += '  }\n';
      out += '}\n';
      out += '\n';
    }

    // Class definition
    if (config.type == PackageType.server)
      out += 'class Client extends ServerpodClient {\n';
    else
      out += 'class Caller extends BundleEndpointCaller {\n';

    for (var endpointDef in protocolDefinition.endpoints) {
      out += '  late final ${_endpointClassName(endpointDef.name)} ${endpointDef.name};\n';
    }

    if (hasBundles) {
      out += '  late final _Bundles bundles;\n';
      out += '\n';
    }

    out += '\n';
    if (config.type == PackageType.server)
      out += '  Client(String host, {SecurityContext? context, ServerpodClientErrorCallback? errorHandler, AuthenticationKeyManager? authenticationKeyManager}) : super(host, Protocol.instance, context: context, errorHandler: errorHandler, authenticationKeyManager: authenticationKeyManager) {\n';
    else
      out += '  Caller(ServerpodClientShared client) : super(client) {\n';
    for (var endpointDef in protocolDefinition.endpoints) {
      out += '    ${endpointDef.name} = ${_endpointClassName(endpointDef.name)}(this);\n';
    }

    if (hasBundles) {
      out += '    bundles = _Bundles(this);\n';
    }

    out += '  }\n';

    out += '}\n';


    return out;
  }

  String _endpointClassName(String endpointName) {
    return '_Endpoint${ReCase(endpointName).pascalCase}';
  }
}