import 'package:code_builder/code_builder.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_cli/src/generator/shared.dart';

class ServerTestToolsGenerator {
  final ProtocolDefinition protocolDefinition;
  final GeneratorConfig config;

  ServerTestToolsGenerator({
    required this.protocolDefinition,
    required this.config,
  });

  Library generateTestHelper() {
    var library = LibraryBuilder();

    _addPackageDirectives(library);

    library.body.addAll(
      [
        _buildWithServerpodFunction(),
        _buildPublicTestEndpointsClass(),
        _buildPrivateTestEndpointsClass(),
      ],
    );

    for (var endpoint in protocolDefinition.endpoints) {
      library.body.add(_buildEndpointClassWithMethodCalls(endpoint));
    }

    return library.build();
  }

  Class _buildEndpointClassWithMethodCalls(EndpointDefinition endpoint) {
    // Unused fields result in analyzer warnings in the generated code
    bool classNeedsFields = endpoint.methods.isNotEmpty;
    List<Field> classFields = classNeedsFields
        ? [
            Field(
              (fieldBuilder) {
                fieldBuilder
                  ..name = '_endpointDispatch'
                  ..modifier = FieldModifier.final$
                  ..type = refer('EndpointDispatch', serverpodUrl(true));
              },
            ),
            Field((fieldBuilder) {
              fieldBuilder
                ..name = '_serializationManager'
                ..modifier = FieldModifier.final$
                ..type = refer('SerializationManager', serverpodUrl(true));
            })
          ]
        : [];

    return Class((classBuilder) {
      classBuilder
        ..name = '_${endpoint.className}'
        ..fields.addAll(classFields)
        ..constructors.add(
          Constructor(
            (constructorBuilder) {
              constructorBuilder.requiredParameters.addAll(
                [
                  Parameter(
                    (p) => p
                      ..name = '_endpointDispatch'
                      ..toThis = classNeedsFields,
                  ),
                  Parameter(
                    (p) => p
                      ..name = '_serializationManager'
                      ..toThis = classNeedsFields,
                  ),
                ],
              );
            },
          ),
        );

      classBuilder.methods.addAll(
        [
          for (var method in endpoint.methods)
            _buildEndpointMethod(method, endpoint)
        ],
      );
    });
  }

  Method _buildEndpointMethod(
      MethodDefinition method, EndpointDefinition endpoint) {
    return Method(
      (methodBuilder) {
        bool returnsStream = method.returnType.isStreamType;
        bool hasStreamParameter =
            method.allParameters.any((p) => p.type.isStreamType);

        methodBuilder
          ..name = method.name
          ..returns = method.returnType.reference(true, config: config)
          ..modifier = returnsStream ? null : MethodModifier.async
          ..requiredParameters.addAll(
            [
              Parameter(
                (p) => p
                  ..name = 'sessionBuilder'
                  ..type = refer('TestSessionBuilder', serverpodTestUrl),
              ),
              for (var parameter in method.parameters)
                Parameter((p) => p
                  ..name = parameter.name
                  ..type = parameter.type.reference(true, config: config)),
            ],
          )
          ..optionalParameters.addAll(
            [
              for (var parameter in method.parametersPositional)
                Parameter(
                  (p) => p
                    ..name = parameter.name
                    ..type = parameter.type.reference(true, config: config)
                    ..named = false,
                ),
              for (var parameter in method.parametersNamed)
                Parameter(
                  (p) => p
                    ..name = parameter.name
                    ..type = parameter.type.reference(true, config: config)
                    ..named = true
                    ..required = parameter.required,
                ),
            ],
          );

        methodBuilder.body = returnsStream || hasStreamParameter
            ? _buildEndpointStreamMethodCall(endpoint, method,
                hasStreamParameter: hasStreamParameter,
                returnsStream: returnsStream)
            : _buildEndpointMethodCall(endpoint, method);
      },
    );
  }

  Code _buildEndpointMethodCall(
      EndpointDefinition endpoint, MethodDefinition method) {
    var closure = Method(
      (methodBuilder) => methodBuilder
        ..modifier = MethodModifier.async
        ..body = Block.of([
          refer('var _localUniqueSession')
              .assign(refer('sessionBuilder')
                  .asA(refer('InternalTestSessionBuilder', serverpodTestUrl))
                  .property('internalBuild')
                  .call([], {
                'endpoint': literalString(endpoint.name),
                'method': literalString(method.name),
              }))
              .statement,
          refer('var _localCallContext')
              .assign(refer('_endpointDispatch')
                  .awaited
                  .property('getMethodCallContext')
                  .call([], {
                'createSessionCallback': Method((methodBuilder) => methodBuilder
                  ..requiredParameters.add(
                    Parameter((p) => p..name = '_'),
                  )
                  ..body = refer('_localUniqueSession').code).closure,
                'endpointPath': literalString(endpoint.name),
                'methodName': literalString(method.name),
                'parameters': refer('testObjectToJson', serverpodTestUrl).call([
                  literalMap({
                    for (var parameter in method.allParameters)
                      literalString(parameter.name): refer(parameter.name).code,
                  })
                ]),
                'serializationManager': refer('_serializationManager'),
              }))
              .statement,
          refer('var _localReturnValue')
              .assign(
                refer('_localCallContext')
                    .property('method')
                    .property('call')
                    .call([
                      refer('_localUniqueSession'),
                      refer('_localCallContext').property('arguments'),
                    ])
                    .asA(method.returnType.reference(true, config: config))
                    .awaited,
              )
              .statement,
          refer('_localUniqueSession')
              .property('close')
              .call([])
              .awaited
              .statement,
          refer('_localReturnValue').returned.statement,
        ])
        ..returns,
    ).closure;

    return refer('callAwaitableFunctionAndHandleExceptions', serverpodTestUrl)
        .call([closure])
        .returned
        .statement;
  }

  Code _buildEndpointStreamMethodCall(
    EndpointDefinition endpoint,
    MethodDefinition method, {
    required hasStreamParameter,
    required returnsStream,
  }) {
    var parameters =
        method.allParameters.where((p) => !p.type.isStreamType).toList();
    var streamParameters =
        method.allParameters.where((p) => p.type.isStreamType).toList();

    var closure = Method(
      (methodBuilder) => methodBuilder
        ..modifier = MethodModifier.async
        ..body = Block.of([
          refer('var _localUniqueSession')
              .assign(refer('sessionBuilder')
                  .asA(refer('InternalTestSessionBuilder', serverpodTestUrl))
                  .property('internalBuild')
                  .call([], {
                'endpoint': literalString(endpoint.name),
                'method': literalString(method.name),
              }))
              .statement,
          refer('var _localCallContext')
              .assign(refer('_endpointDispatch')
                  .awaited
                  .property('getMethodStreamCallContext')
                  .call([], {
                'createSessionCallback': Method((methodBuilder) => methodBuilder
                  ..requiredParameters.add(
                    Parameter((p) => p..name = '_'),
                  )
                  ..body = refer('_localUniqueSession').code).closure,
                'endpointPath': literalString(endpoint.name),
                'methodName': literalString(method.name),
                'arguments': literalMap({
                  for (var parameter in parameters)
                    literalString(parameter.name): refer(parameter.name).code,
                }),
                'requestedInputStreams':
                    literalList(streamParameters.map((p) => p.name)),
                'serializationManager': refer('_serializationManager'),
              }))
              .statement,
          refer('_localTestStreamManager')
              .property('callStreamMethod')
              .call([
                refer('_localCallContext'),
                refer('_localUniqueSession'),
                literalMap({
                  for (var parameter in streamParameters)
                    literalString(parameter.name): refer(parameter.name).code,
                }),
              ])
              .awaited
              .statement,
          if (hasStreamParameter && !returnsStream)
            refer('_localTestStreamManager')
                .property('outputStreamController')
                .property('stream')
                .returned
                .statement,
        ])
        ..returns,
    ).closure;

    var testStreamManagerType = TypeReference((b) {
      var typeRef = b
        ..symbol = 'TestStreamManager'
        ..url = serverpodTestUrl;
      typeRef.types.add(
        method.returnType.generics.first.reference(true, config: config),
      );
    });

    var streamManagerInstance = testStreamManagerType.newInstance([]);

    var streamManagerDeclaration = refer('var _localTestStreamManager')
        .assign(streamManagerInstance)
        .statement;

    if (returnsStream) {
      return Block.of([
        streamManagerDeclaration,
        refer('callStreamFunctionAndHandleExceptions', serverpodTestUrl).call([
          closure,
          refer('_localTestStreamManager').property('outputStreamController'),
        ]).statement,
        refer('_localTestStreamManager')
            .property('outputStreamController')
            .property('stream')
            .returned
            .statement,
      ]);
    }

    return Block.of([
      streamManagerDeclaration,
      refer(
        'callAwaitableFunctionWithStreamInputAndHandleExceptions',
        serverpodTestUrl,
      ).call([closure]).returned.statement,
    ]);
  }

  Class _buildPublicTestEndpointsClass() {
    return Class((classBuilder) {
      classBuilder.name = 'TestEndpoints';

      for (var endpoint in protocolDefinition.endpoints) {
        classBuilder.fields.add(
          Field(
            (fieldBuilder) {
              fieldBuilder
                ..name = endpoint.name
                ..modifier = FieldModifier.final$
                ..type = refer('_${endpoint.className}')
                ..late = true;
            },
          ),
        );
      }
    });
  }

  Class _buildPrivateTestEndpointsClass() {
    return Class((classBuilder) {
      classBuilder
        ..name = '_InternalTestEndpoints'
        ..extend = refer('TestEndpoints')
        ..implements.add(refer('InternalTestEndpoints', serverpodTestUrl))
        ..methods.add(Method(
          (methodBuilder) {
            methodBuilder
              ..name = 'initialize'
              ..annotations.add(refer('override'))
              ..requiredParameters.add(
                Parameter(
                  (p) => p
                    ..name = 'serializationManager'
                    ..type = refer('SerializationManager', serverpodUrl(true)),
                ),
              )
              ..requiredParameters.add(
                Parameter(
                  (p) => p
                    ..name = 'endpoints'
                    ..type = refer('EndpointDispatch', serverpodUrl(true)),
                ),
              )
              ..body = Block.of(
                [
                  for (var endpoint in protocolDefinition.endpoints)
                    refer(endpoint.name)
                        .assign(
                          refer('_${endpoint.className}').newInstance(
                            [
                              refer('endpoints'),
                              refer('serializationManager'),
                            ],
                          ),
                        )
                        .statement,
                ],
              );
          },
        ));
    });
  }

  Method _buildWithServerpodFunction() {
    return Method((methodBuilder) {
      methodBuilder
        ..name = 'withServerpod'
        ..annotations.add(refer('isTestGroup', serverpodTestUrl))
        ..requiredParameters.addAll([
          Parameter((p) => p
            ..name = 'testGroupName'
            ..type = refer('String')),
          Parameter((p) => p
            ..name = 'testClosure'
            ..type = refer('TestClosure<TestEndpoints>', serverpodTestUrl)),
        ])
        ..optionalParameters.addAll([
          Parameter((p) => p
            ..name = 'runMode'
            ..named = true
            ..type = refer('String?')),
          Parameter((p) => p
            ..name = 'enableSessionLogging'
            ..named = true
            ..type = refer('bool?')),
          if (config.isFeatureEnabled(ServerpodFeature.database)) ...[
            Parameter((p) => p
              ..name = 'rollbackDatabase'
              ..named = true
              ..type = refer('RollbackDatabase?', serverpodTestUrl)),
            Parameter((p) => p
              ..name = 'applyMigrations'
              ..named = true
              ..type = refer('bool?'))
          ],
        ])
        ..body = refer(
                'buildWithServerpod<_InternalTestEndpoints>', serverpodTestUrl)
            .call(
          [
            refer('testGroupName'),
            refer('TestServerpod', serverpodTestUrl).newInstance(
              [],
              {
                'testEndpoints':
                    refer('_InternalTestEndpoints').newInstance([]),
                'endpoints': refer('Endpoints').newInstance([]),
                'serializationManager': refer('Protocol').newInstance([]),
                'runMode': refer('runMode'),
                'applyMigrations':
                    config.isFeatureEnabled(ServerpodFeature.database)
                        ? refer('applyMigrations')
                        : literalBool(false),
                'isDatabaseEnabled': literalBool(
                  config.isFeatureEnabled(ServerpodFeature.database),
                ),
              },
            ),
          ],
          {
            'maybeRollbackDatabase':
                config.isFeatureEnabled(ServerpodFeature.database)
                    ? refer('rollbackDatabase')
                    : literalNull,
            'maybeEnableSessionLogging': refer('enableSessionLogging'),
          },
        ).call([
          refer('testClosure'),
        ]).statement;
    });
  }

  void _addPackageDirectives(LibraryBuilder library) {
    var protocolPackageImportPath = 'package:${config.name}_server/${p.joinAll([
          ...config.generatedServeModelPackagePathParts,
          'protocol.dart'
        ])}';
    var endpointsPath = 'package:${config.name}_server/${p.joinAll([
          ...config.generatedServeModelPackagePathParts,
          'endpoints.dart'
        ])}';

    library.directives.addAll([
      Directive.import(protocolPackageImportPath),
      Directive.import(endpointsPath),
      Directive.export(serverpodTestPublicExportsUrl),
    ]);

    library.ignoreForFile.add('no_leading_underscores_for_local_identifiers');
  }
}
