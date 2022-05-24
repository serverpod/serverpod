import 'package:recase/recase.dart';

import 'config.dart';
import 'protocol_definition.dart';
import 'protocol_generator.dart';

class ProtocolGeneratorDart extends ProtocolGenerator {
  ProtocolGeneratorDart({required ProtocolDefinition protocolDefinition})
      : super(protocolDefinition: protocolDefinition);

  @override
  String generateClientEndpointCalls() {
    var out = '';

    // Header
    out += '/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */\n';
    out += '/*   To generate run: "serverpod generate"    */\n';
    out += '\n';
    out += '// ignore_for_file: public_member_api_docs\n';
    out += '// ignore_for_file: unused_import\n';
    out += '\n';

    out += 'import \'dart:io\';\n';
    out += 'import \'dart:typed_data\' as typed_data;\n';
    out += 'import \'package:serverpod_client/serverpod_client.dart\';\n';
    out += 'import \'protocol.dart\';\n';
    out += '\n';

    var hasModules =
        config.modules.isNotEmpty && config.type == PackageType.server;
    if (hasModules) {
      for (var module in config.modules) {
        out +=
            'import \'package:${module.clientPackage}/module.dart\' as ${module.name};\n';
      }
      out += '\n';
    }

    var modulePrefix =
        config.type == PackageType.server ? '' : '${config.name}.';

    // Endpoints
    for (var endpointDef in protocolDefinition.endpoints) {
      var endpointClassName = _endpointClassName(endpointDef.name);

      out += 'class $endpointClassName extends EndpointRef {\n';
      out += '  @override\n';
      out += '  String get name => \'$modulePrefix${endpointDef.name}\';\n';
      out += '\n';

      out += '  $endpointClassName(EndpointCaller caller) : super(caller);\n';

      // Add methods
      for (var methodDef in endpointDef.methods) {
        var requiredParams = methodDef.parameters;
        var optionalParams = methodDef.parametersPositional;
        var returnType = methodDef.returnType;

        // Method definition
        out += '\n';
        out +=
            '  Future<${returnType.typePrefix}${returnType.type}> ${methodDef.name}(';

        for (var paramDef in requiredParams) {
          out +=
              '${paramDef.type.typePrefix}${paramDef.type} ${paramDef.name},';
        }

        if (optionalParams.isNotEmpty) {
          out += '[';

          for (var paramDef in optionalParams) {
            out += '${paramDef.type.type} ${paramDef.name},';
          }

          out += ']';
        }

        out += ') async {\n';

        // Call to server endpoint
        String endPt = '';
        endPt +=
            '    await caller.callServerEndpoint(\'$modulePrefix${endpointDef.name}\', \'${methodDef.name}\', \'${returnType.typeNonNullable}\', {\n';
        for (var paramDef in requiredParams) {
          endPt += '      \'${paramDef.name}\':${paramDef.name},\n';
        }
        for (var paramDef in optionalParams) {
          endPt += '      \'${paramDef.name}\': ${paramDef.name},\n';
        }
        endPt += '    });\n';
        if (returnType.isTypedList) {
          out += '     List datas = $endPt';
          String _castStr = '';
          if (returnType.listType!.databaseType == 'json' && returnType.listType!.type != 'dynamic') {
            // Todo: check wheather this if else is correct or not [for Entity only]
            String isNulable =
                returnType.listType!.nullable ? 'e == null ? null : ' : '';
            _castStr += '.map((e) {';
            _castStr +=
                'return $isNulable${returnType.listType!.type}.fromSerialization(e.serializeAll());}).toList();';
          } else {
            _castStr +=
                '${returnType.nullable ? '?' : ''}.cast<${returnType.listType!.type}>();';
          }
          out += '     return datas$_castStr';
        } else {
          out += ' return $endPt';
        }
        out += '  }\n';
      }

      out += '}\n';
      out += '\n';
    }

    if (hasModules) {
      out += 'class _Modules {\n';
      for (var module in config.modules) {
        out += '  late final ${module.name}.Caller ${module.nickname};\n';
      }
      out += '\n';

      out += '  _Modules(Client client) {\n';
      for (var module in config.modules) {
        out += '    ${module.nickname} = ${module.name}.Caller(client);\n';
      }

      out += '  }\n';
      out += '}\n';
      out += '\n';
    }

    // Class definition
    if (config.type == PackageType.server) {
      out += 'class Client extends ServerpodClient {\n';
    } else {
      out += 'class Caller extends ModuleEndpointCaller {\n';
    }

    for (var endpointDef in protocolDefinition.endpoints) {
      out +=
          '  late final ${_endpointClassName(endpointDef.name)} ${endpointDef.name};\n';
    }

    if (hasModules) {
      out += '  late final _Modules modules;\n';
      out += '\n';
    }

    out += '\n';
    if (config.type == PackageType.server) {
      out +=
          '  Client(String host, {SecurityContext? context, ServerpodClientErrorCallback? errorHandler, AuthenticationKeyManager? authenticationKeyManager}) : super(host, Protocol.instance, context: context, errorHandler: errorHandler, authenticationKeyManager: authenticationKeyManager) {\n';
    } else {
      out += '  Caller(ServerpodClientShared client) : super(client) {\n';
    }
    for (var endpointDef in protocolDefinition.endpoints) {
      out +=
          '    ${endpointDef.name} = ${_endpointClassName(endpointDef.name)}(this);\n';
    }

    if (hasModules) {
      out += '\n';
      out += '    modules = _Modules(this);\n';
      for (var module in config.modules) {
        out += '    registerModuleProtocol(${module.name}.Protocol());\n';
      }
    }

    out += '  }\n';

    out += '\n';
    out += '  @override\n';
    out += '  Map<String, EndpointRef> get endpointRefLookup => {\n';
    for (var endpointDef in protocolDefinition.endpoints) {
      out +=
          '    \'$modulePrefix${endpointDef.name}\' : ${endpointDef.name},\n';
    }
    out += '  };\n';

    if (config.type == PackageType.server) {
      out += '\n';
      out += '  @override\n';
      out += '  Map<String, ModuleEndpointCaller> get moduleLookup => {\n';
      for (var module in config.modules) {
        out += '    \'${module.nickname}\': modules.${module.nickname},\n';
      }
      out += '  };\n';
    }

    out += '}\n';

    return out;
  }

  String _endpointClassName(String endpointName) {
    return '_Endpoint${ReCase(endpointName).pascalCase}';
  }
}
