import 'package:code_builder/code_builder.dart';
import 'package:recase/recase.dart';

import 'class_generator_dart.dart';
import 'config.dart';
import 'protocol_definition.dart';
import 'protocol_generator.dart';

class ProtocolGeneratorDart extends ProtocolGenerator {
  ProtocolGeneratorDart({required ProtocolDefinition protocolDefinition})
      : super(protocolDefinition: protocolDefinition);

  @override
  Library generateClientEndpointCalls() {
    var library = LibraryBuilder();

    var hasModules =
        config.modules.isNotEmpty && config.type == PackageType.server;

    String moduleUri(ModuleConfig module) =>
        'package:${module.clientPackage}/module.dart';

    var modulePrefix =
        config.type == PackageType.server ? '' : '${config.name}.';

    for (var endpointDef in protocolDefinition.endpoints) {
      var endpointClassName = _endpointClassName(endpointDef.name);

      library.body.add(Class((endpoint) {
        endpoint
          ..docs.add(endpointDef.documentationComment ?? '')
          ..name = endpointClassName
          ..extend = refer(
              'EndpointRef', 'package:serverpod_client/serverpod_client.dart');

        endpoint.methods.add(Method((m) => m
          ..annotations.add(refer('override'))
          ..name = 'name'
          ..type = MethodType.getter
          ..returns = refer('String')
          ..body = literalString('$modulePrefix${endpointDef.name}').code));

        endpoint.constructors.add(Constructor((c) => c
          ..requiredParameters.add(Parameter((p) => p
            ..name = 'caller'
            ..type = refer('EndpointCaller',
                'package:serverpod_client/serverpod_client.dart')))
          ..initializers.add(refer('super').call([refer('caller')]).code)));

        for (var methodDef in endpointDef.methods) {
          var requiredParams = methodDef.parameters;
          var optionalParams = methodDef.parametersPositional;
          var namedParameters = methodDef.parametersNamed;
          var returnType = methodDef.returnType;

          endpoint.methods.add(Method(
            (m) => m
              ..docs.add(methodDef.documentationComment ?? '')
              ..returns = returnType.reference(false)
              ..name = methodDef.name
              ..requiredParameters.addAll([
                for (var parameterDef in requiredParams)
                  Parameter((p) => p
                    ..name = parameterDef.name
                    ..type = parameterDef.type.reference(false))
              ])
              ..optionalParameters.addAll([
                for (var parameterDef in optionalParams)
                  Parameter((p) => p
                    ..named = false
                    ..name = parameterDef.name
                    ..type = parameterDef.type.reference(false)),
                for (var parameterDef in namedParameters)
                  Parameter((p) => p
                    ..named = false
                    ..name = parameterDef.name
                    ..type = parameterDef.type.reference(false))
              ])
              ..body = refer('caller').property('callServerEndpoint').call([
                literalString('$modulePrefix${endpointDef.name}'),
                literalString(methodDef.name),
                literalMap({
                  for (var parameterDef in requiredParams)
                    literalString(parameterDef.name): refer(parameterDef.name),
                  for (var parameterDef in optionalParams)
                    literalString(parameterDef.name): refer(parameterDef.name),
                  for (var parameterDef in namedParameters)
                    literalString(parameterDef.name): refer(parameterDef.name),
                })
              ], {}, [
                methodDef.returnType.generics.first.reference(false)
              ]).code,
          ));
        }
      }));
    }

    if (hasModules) {
      library.body.add(
        Class((c) => c
          ..name = '_Modules'
          ..fields.addAll([
            for (var module in config.modules)
              Field((f) => f
                ..late = true
                ..modifier = FieldModifier.final$
                ..name = module.nickname
                ..type = refer('Caller', moduleUri(module))),
          ])
          ..constructors.add(
            Constructor((c) => c
              ..requiredParameters.add(Parameter((p) => p
                ..type = refer('Client')
                ..name = 'client'))
              ..body = Block.of([
                for (var module in config.modules)
                  refer(module.nickname)
                      .assign(refer('Caller', moduleUri(module))
                          .call([refer('client')]))
                      .statement,
              ])),
          )),
      );
    }

    library.body.add(Class((c) => c
      ..name = config.type == PackageType.server ? 'Client' : 'Caller'
      ..extend = config.type == PackageType.server
          ? refer('ServerpodClient', serverPodUrl(false))
          : refer('ModuleEndpointCaller', serverPodUrl(false))
      ..fields.addAll([
        for (var endpointDef in protocolDefinition.endpoints)
          Field((f) => f
            ..late = true
            ..modifier = FieldModifier.final$
            ..name = endpointDef.name
            ..type = refer(_endpointClassName(endpointDef.name))),
        if (hasModules)
          Field((f) => f
            ..late = true
            ..modifier = FieldModifier.final$
            ..name = 'modules'
            ..type = refer('_Modules')),
      ])
      ..constructors.add(Constructor((c) {
        if (config.type == PackageType.server) {
          c
            ..requiredParameters.add(Parameter((p) => p
              ..type = refer('String')
              ..name = 'host'))
            ..optionalParameters.addAll([
              Parameter((p) => p
                ..name = 'context'
                ..named = true
                ..type = TypeReference((t) => t
                  ..symbol = 'SecurityContext'
                  ..url = 'dart:io'
                  ..isNullable = true)),
              Parameter((p) => p
                ..name = 'errorHandler'
                ..named = true
                ..type = TypeReference((t) => t
                  ..symbol = 'ServerpodClientErrorCallback'
                  ..url = serverPodUrl(false)
                  ..isNullable = true)),
              Parameter((p) => p
                ..name = 'authenticationKeyManager'
                ..named = true
                ..type = TypeReference((t) => t
                  ..symbol = 'AuthenticationKeyManager'
                  ..url = serverPodUrl(false)
                  ..isNullable = true)),
            ])
            ..initializers.add(refer('super').call([
              refer('host'),
              refer('Protocol', 'protocol.dart').property('instance')
            ], {
              'context': refer('context'),
              'errorHandler': refer('errorHandler'),
              'authenticationKeyManager': refer('authenticationKeyManager'),
            }).code);
        } else {
          c
            ..requiredParameters.add(Parameter((p) => p
              ..type = refer('ServerpodClientShared', serverPodUrl(false))
              ..name = 'client'))
            ..initializers.add(refer('super').call([refer('client')]).code);
        }
        c.body = Block.of([
          if (hasModules)
            refer('modules')
                .assign(refer('_Modules').call([refer('this')]))
                .statement,
          if (hasModules)
            for (var module in config.modules)
              refer('registerModuleProtocol').call(
                  [refer('Protocol', moduleUri(module)).call([])]).statement
        ]);
      }))
      ..methods.addAll([
        Method(
          (m) => m
            ..name = 'endpointRefLookup'
            ..annotations.add(refer('override'))
            ..type = MethodType.getter
            ..returns = TypeReference((t) => t
              ..symbol = 'Map'
              ..types.addAll([
                refer('String'),
                refer('EndpointRef', serverPodUrl(false)),
              ]))
            ..body = literalMap({
              for (var endpointDef in protocolDefinition.endpoints)
                '$modulePrefix${endpointDef.name}': refer(endpointDef.name)
            }).code,
        ),
        if (config.type == PackageType.server)
          Method(
            (m) => m
              ..name = 'moduleLookup'
              ..annotations.add(refer('override'))
              ..type = MethodType.getter
              ..returns = TypeReference((t) => t
                ..symbol = 'Map'
                ..types.addAll([
                  refer('String'),
                  refer('ModuleEndpointCaller', serverPodUrl(false)),
                ]))
              ..body = literalMap({
                for (var module in config.modules)
                  module.nickname: refer('modules').property(module.nickname),
              }).code,
          ),
      ])));

    return library.build();
    // var out = '';

    // // Header
    // out += '/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */\n';
    // out += '/*   To generate run: "serverpod generate"    */\n';
    // out += '\n';
    // out += '// ignore_for_file: public_member_api_docs\n';
    // out += '// ignore_for_file: unused_import\n';
    // out += '// ignore_for_file: library_private_types_in_public_api\n';
    // out += '// ignore_for_file: depend_on_referenced_packages\n';
    // out += '\n';

    // out += 'import \'dart:io\';\n';
    // out += 'import \'dart:typed_data\' as typed_data;\n';
    // out += 'import \'package:serverpod_client/serverpod_client.dart\';\n';
    // out += 'import \'protocol.dart\';\n';
    // out += '\n';

    // var hasModules =
    //     config.modules.isNotEmpty && config.type == PackageType.server;
    // if (hasModules) {
    //   for (var module in config.modules) {
    //     out +=
    //         'import \'package:${module.clientPackage}/module.dart\' as ${module.name};\n';
    //   }
    //   out += '\n';
    // }

    // var modulePrefix =
    //     config.type == PackageType.server ? '' : '${config.name}.';

    // // Endpoints
    // for (var endpointDef in protocolDefinition.endpoints) {
    //   var endpointClassName = _endpointClassName(endpointDef.name);

    //   if (endpointDef.documentationComment != null) {
    //     out += '${endpointDef.documentationComment}\n';
    //   }
    //   out += 'class $endpointClassName extends EndpointRef {\n';
    //   out += '  @override\n';
    //   out += '  String get name => \'$modulePrefix${endpointDef.name}\';\n';
    //   out += '\n';

    //   out += '  $endpointClassName(EndpointCaller caller) : super(caller);\n';

    //   // Add methods
    //   for (var methodDef in endpointDef.methods) {
    //     var requiredParams = methodDef.parameters;
    //     var optionalParams = methodDef.parametersPositional;
    //     var namedParameters = methodDef.parametersNamed;
    //     var returnType = methodDef.returnType;

    //     // Method definition
    //     out += '\n';
    //     if (methodDef.documentationComment != null) {
    //       out += '${methodDef.documentationComment}\n';
    //     }
    //     out += '  Future<${returnType.typeWithPrefix}> ${methodDef.name}(';

    //     for (var paramDef in requiredParams) {
    //       out += '${paramDef.type.typeWithPrefix} ${paramDef.name},';
    //     }

    //     if (optionalParams.isNotEmpty) {
    //       out += '[';

    //       for (var paramDef in optionalParams) {
    //         out += '${paramDef.type.type} ${paramDef.name},';
    //       }

    //       out += ']';
    //     }

    //     if (namedParameters.isNotEmpty) {
    //       out += '{';

    //       for (var paramDef in namedParameters) {
    //         if (paramDef.required) {
    //           out += 'required ${paramDef.type.type} ${paramDef.name},';
    //         } else {
    //           out += '${paramDef.type.type} ${paramDef.name},';
    //         }
    //       }

    //       out += '}';
    //     }

    //     out += ') async {\n';

    //     // Call to server endpoint
    //     out +=
    //         '    var retval = await caller.callServerEndpoint(\'$modulePrefix${endpointDef.name}\', \'${methodDef.name}\', \'${returnType.typeNonNullable}\', {\n';

    //     for (var paramDef in requiredParams) {
    //       out += '      \'${paramDef.name}\':${paramDef.name},\n';
    //     }

    //     for (var paramDef in optionalParams) {
    //       out += '      \'${paramDef.name}\': ${paramDef.name},\n';
    //     }

    //     for (var paramDef in namedParameters) {
    //       out += '      \'${paramDef.name}\': ${paramDef.name},\n';
    //     }

    //     out += '    });\n';

    //     if (returnType.isTypedList) {
    //       if (returnType.nullable) {
    //         out += '    return (retval as List?)?.cast();\n';
    //       } else {
    //         out += '    return (retval as List).cast();\n';
    //       }
    //     } else if (returnType.isTypedMap) {
    //       if (returnType.nullable) {
    //         out += '    return (retval as Map?)?.cast();\n';
    //       } else {
    //         out += '    return (retval as Map).cast();\n';
    //       }
    //     } else {
    //       out += '    return retval;\n';
    //     }

    //     out += '  }\n';
    //   }

    //   out += '}\n';
    //   out += '\n';
    // }

    // if (hasModules) {
    //   out += 'class _Modules {\n';
    //   for (var module in config.modules) {
    //     out += '  late final ${module.name}.Caller ${module.nickname};\n';
    //   }
    //   out += '\n';

    //   out += '  _Modules(Client client) {\n';
    //   for (var module in config.modules) {
    //     out += '    ${module.nickname} = ${module.name}.Caller(client);\n';
    //   }

    //   out += '  }\n';
    //   out += '}\n';
    //   out += '\n';
    // }

    // // Class definition
    // if (config.type == PackageType.server) {
    //   out += 'class Client extends ServerpodClient {\n';
    // } else {
    //   out += 'class Caller extends ModuleEndpointCaller {\n';
    // }

    // for (var endpointDef in protocolDefinition.endpoints) {
    //   out +=
    //       '  late final ${_endpointClassName(endpointDef.name)} ${endpointDef.name};\n';
    // }

    // if (hasModules) {
    //   out += '  late final _Modules modules;\n';
    //   out += '\n';
    // }

    // out += '\n';
    // if (config.type == PackageType.server) {
    //   out +=
    //       '  Client(String host, {SecurityContext? context, ServerpodClientErrorCallback? errorHandler, AuthenticationKeyManager? authenticationKeyManager}) : super(host, Protocol.instance, context: context, errorHandler: errorHandler, authenticationKeyManager: authenticationKeyManager) {\n';
    // } else {
    //   out += '  Caller(ServerpodClientShared client) : super(client) {\n';
    // }
    // for (var endpointDef in protocolDefinition.endpoints) {
    //   out +=
    //       '    ${endpointDef.name} = ${_endpointClassName(endpointDef.name)}(this);\n';
    // }

    // if (hasModules) {
    //   out += '\n';
    //   out += '    modules = _Modules(this);\n';
    //   for (var module in config.modules) {
    //     out += '    registerModuleProtocol(${module.name}.Protocol());\n';
    //   }
    // }

    // out += '  }\n';

    // out += '\n';
    // out += '  @override\n';
    // out += '  Map<String, EndpointRef> get endpointRefLookup => {\n';
    // for (var endpointDef in protocolDefinition.endpoints) {
    //   out +=
    //       '    \'$modulePrefix${endpointDef.name}\' : ${endpointDef.name},\n';
    // }
    // out += '  };\n';

    // if (config.type == PackageType.server) {
    //   out += '\n';
    //   out += '  @override\n';
    //   out += '  Map<String, ModuleEndpointCaller> get moduleLookup => {\n';
    //   for (var module in config.modules) {
    //     out += '    \'${module.nickname}\': modules.${module.nickname},\n';
    //   }
    //   out += '  };\n';
    // }

    // out += '}\n';

    // return out;
  }

  String _endpointClassName(String endpointName) {
    return '_Endpoint${ReCase(endpointName).pascalCase}';
  }
}
