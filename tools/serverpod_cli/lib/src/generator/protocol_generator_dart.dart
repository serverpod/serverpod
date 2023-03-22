import 'package:code_builder/code_builder.dart';
import 'package:recase/recase.dart';

import 'class_generator_dart.dart';
import 'config.dart';
import 'protocol_generator.dart';

class ProtocolGeneratorDart extends ProtocolGenerator {
  ProtocolGeneratorDart({
    required super.protocolDefinition,
    required super.config,
  });

  @override
  Library generateClientEndpointCalls() {
    var library = LibraryBuilder();

    var hasModules =
        config.modules.isNotEmpty && config.type == PackageType.server;

    var modulePrefix =
        config.type == PackageType.server ? '' : '${config.name}.';

    for (var endpointDef in protocolDefinition.endpoints) {
      var endpointClassName = _endpointClassName(endpointDef.name);

      library.body.add(
        Class((endpoint) {
          endpoint
            ..docs.add(endpointDef.documentationComment ?? '')
            ..name = endpointClassName
            ..extend = refer('EndpointRef', serverpodUrl(false));

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

            endpoint.methods.add(
              Method(
                (m) => m
                  ..docs.add(methodDef.documentationComment ?? '')
                  ..returns = returnType.reference(false, config: config)
                  ..name = methodDef.name
                  ..requiredParameters.addAll([
                    for (var parameterDef in requiredParams)
                      Parameter((p) => p
                        ..name = parameterDef.name
                        ..type =
                            parameterDef.type.reference(false, config: config))
                  ])
                  ..optionalParameters.addAll([
                    for (var parameterDef in optionalParams)
                      Parameter((p) => p
                        ..named = false
                        ..name = parameterDef.name
                        ..type =
                            parameterDef.type.reference(false, config: config)),
                    for (var parameterDef in namedParameters)
                      Parameter((p) => p
                        ..named = true
                        ..required = parameterDef.required
                        ..name = parameterDef.name
                        ..type =
                            parameterDef.type.reference(false, config: config))
                  ])
                  ..body = refer('caller').property('callServerEndpoint').call([
                    literalString('$modulePrefix${endpointDef.name}'),
                    literalString(methodDef.name),
                    literalMap({
                      for (var parameterDef in requiredParams)
                        literalString(parameterDef.name):
                            refer(parameterDef.name),
                      for (var parameterDef in optionalParams)
                        literalString(parameterDef.name):
                            refer(parameterDef.name),
                      for (var parameterDef in namedParameters)
                        literalString(parameterDef.name):
                            refer(parameterDef.name),
                    })
                  ], {}, [
                    methodDef.returnType.generics.first
                        .reference(false, config: config)
                  ]).code,
              ),
            );
          }
        }),
      );
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
                ..type = refer('Caller', module.url(false))),
          ])
          ..constructors.add(
            Constructor((c) => c
              ..requiredParameters.add(Parameter((p) => p
                ..type = refer('Client')
                ..name = 'client'))
              ..body = Block.of([
                for (var module in config.modules)
                  refer(module.nickname)
                      .assign(refer('Caller', module.url(false))
                          .call([refer('client')]))
                      .statement,
              ])),
          )),
      );
    }

    library.body.add(
      Class(
        (c) => c
          ..name = config.type == PackageType.server ? 'Client' : 'Caller'
          ..extend = config.type == PackageType.server
              ? refer('ServerpodClient', serverpodUrl(false))
              : refer('ModuleEndpointCaller', serverpodUrl(false))
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
          ..constructors.add(
            Constructor((c) {
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
                      ..name = 'authenticationKeyManager'
                      ..named = true
                      ..type = TypeReference((t) => t
                        ..symbol = 'AuthenticationKeyManager'
                        ..url = serverpodUrl(false)
                        ..isNullable = true)),
                  ])
                  ..initializers.add(refer('super').call([
                    refer('host'),
                    refer('Protocol', 'protocol.dart').call([])
                  ], {
                    'context': refer('context'),
                    'authenticationKeyManager':
                        refer('authenticationKeyManager'),
                  }).code);
              } else {
                c
                  ..requiredParameters.add(Parameter((p) => p
                    ..type = refer('ServerpodClientShared', serverpodUrl(false))
                    ..name = 'client'))
                  ..initializers
                      .add(refer('super').call([refer('client')]).code);
              }
              c.body = Block.of([
                for (var endpointDef in protocolDefinition.endpoints)
                  refer(endpointDef.name)
                      .assign(refer(_endpointClassName(endpointDef.name))
                          .call([refer('this')]))
                      .statement,
                if (hasModules)
                  refer('modules')
                      .assign(refer('_Modules').call([refer('this')]))
                      .statement,
              ]);
            }),
          )
          ..methods.addAll(
            [
              Method(
                (m) => m
                  ..name = 'endpointRefLookup'
                  ..annotations.add(refer('override'))
                  ..type = MethodType.getter
                  ..returns = TypeReference((t) => t
                    ..symbol = 'Map'
                    ..types.addAll([
                      refer('String'),
                      refer('EndpointRef', serverpodUrl(false)),
                    ]))
                  ..body = literalMap({
                    for (var endpointDef in protocolDefinition.endpoints)
                      '$modulePrefix${endpointDef.name}':
                          refer(endpointDef.name)
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
                        refer('ModuleEndpointCaller', serverpodUrl(false)),
                      ]))
                    ..body = literalMap({
                      for (var module in config.modules)
                        module.nickname:
                            refer('modules').property(module.nickname),
                    }).code,
                ),
            ],
          ),
      ),
    );

    return library.build();
  }

  String _endpointClassName(String endpointName) {
    return '_Endpoint${ReCase(endpointName).pascalCase}';
  }
}
