import 'package:code_builder/code_builder.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/doc_comments/with_serverpod_doc_comment.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/library_generator.dart';
import 'package:serverpod_cli/src/generator/shared.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

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

  void _addPackageDirectives(LibraryBuilder library) {
    var protocolPackageImportPath = [
      'package:${config.name}_server',
      ...config.generatedServeModelPackagePathParts,
      'protocol.dart',
    ].join('/');

    var endpointsPath = [
      'package:${config.name}_server',
      ...config.generatedServeModelPackagePathParts,
      'endpoints.dart'
    ].join('/');

    library.directives.addAll([
      Directive.import(protocolPackageImportPath),
      Directive.import(endpointsPath),
      Directive.export(serverpodTestPublicExportsUrl),
    ]);

    library.ignoreForFile.add('no_leading_underscores_for_local_identifiers');
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
    EndpointDefinition endpoint,
    MethodDefinition method,
  ) {
    var mapRecordToJsonRef = refer(
      'mapRecordToJson',
      'package:${config.serverPackage}/src/generated/protocol.dart',
    );
    var mapRecordContainingContainerToJsonRef = refer(
      'mapRecordContainingContainerToJson',
      'package:${config.serverPackage}/src/generated/protocol.dart',
    );

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
          const Code('try {'),
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
                      literalString(parameter.name): parameter.type.isRecordType
                          ? mapRecordToJsonRef
                              .call([refer(parameter.name)]).code
                          : (parameter.type.returnsRecordInContainer
                              ? Block.of([
                                  if (parameter.type.nullable)
                                    Code('${parameter.name} == null ? null :'),
                                  mapRecordContainingContainerToJsonRef
                                      .call([refer(parameter.name)]).code,
                                ])
                              : refer(parameter.name).code)
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
                    .transformReturnType(method.returnType, config: config)
                    .awaited,
              )
              .statement,
          refer('_localReturnValue').returned.statement,
          const Code('} finally {'),
          refer('_localUniqueSession')
              .property('close')
              .call([])
              .awaited
              .statement,
          const Code('}'),
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
    required bool hasStreamParameter,
    required bool returnsStream,
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
                    literalString(parameter.name): parameter
                        .methodArgumentSerializationCode(config: config),
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
              ..returns = refer('void')
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

  Method _buildWithServerpodFunction() {
    var optionalParameters = [
      Parameter((p) => p
        ..name = 'runMode'
        ..named = true
        ..type = refer('String?')),
      Parameter((p) => p
        ..name = 'enableSessionLogging'
        ..named = true
        ..type = refer('bool?')),
      Parameter((p) => p
        ..name = 'serverpodLoggingMode'
        ..named = true
        ..type = refer('ServerpodLoggingMode?', serverpodUrl(true))),
      Parameter((p) => p
        ..name = 'testGroupTagsOverride'
        ..named = true
        ..type = refer('List<String>?')),
      Parameter((p) => p
        ..name = 'serverpodStartTimeout'
        ..named = true
        ..type = refer('Duration?')),
      Parameter(
        (p) => p
          ..name = 'experimentalFeatures'
          ..named = true
          ..type = refer('ExperimentalFeatures?', serverpodUrl(true)),
      ),
      if (config.isFeatureEnabled(ServerpodFeature.database)) ...[
        Parameter((p) => p
          ..name = 'rollbackDatabase'
          ..named = true
          ..type = refer('RollbackDatabase?', serverpodTestUrl)),
        Parameter((p) => p
          ..name = 'applyMigrations'
          ..named = true
          ..type = refer('bool?')),
        Parameter((p) => p
          ..name = 'runtimeParametersBuilder'
          ..named = true
          ..type = refer('RuntimeParametersListBuilder?', serverpodUrl(true))),
      ],
    ]..sort(_sortParameterByName);

    return Method((methodBuilder) {
      methodBuilder
        ..docs.add(buildWithServerpodDocComments(
          optionalParameters.map((p) => p.name).toList(),
        ))
        ..name = 'withServerpod'
        ..returns = refer('void')
        ..annotations.add(refer('isTestGroup', serverpodTestUrl))
        ..requiredParameters.addAll([
          Parameter((p) => p
            ..name = 'testGroupName'
            ..type = refer('String')),
          Parameter((p) => p
            ..name = 'testClosure'
            ..type = refer('TestClosure<TestEndpoints>', serverpodTestUrl)),
        ])
        ..optionalParameters.addAll(optionalParameters)
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
                'serverpodLoggingMode': refer('serverpodLoggingMode'),
                'experimentalFeatures': refer('experimentalFeatures'),
                if (config.isFeatureEnabled(ServerpodFeature.database))
                  'runtimeParametersBuilder': refer('runtimeParametersBuilder'),
              },
            ),
          ],
          {
            'maybeRollbackDatabase':
                config.isFeatureEnabled(ServerpodFeature.database)
                    ? refer('rollbackDatabase')
                    : refer('RollbackDatabase', serverpodTestUrl)
                        .property('disabled'),
            'maybeEnableSessionLogging': refer('enableSessionLogging'),
            'maybeTestGroupTagsOverride': refer('testGroupTagsOverride'),
            'maybeServerpodStartTimeout': refer('serverpodStartTimeout'),
          },
        ).call([
          refer('testClosure'),
        ]).statement;
    });
  }

  int _sortParameterByName(Parameter a, Parameter b) =>
      a.name.compareTo(b.name);
}

extension on ParameterDefinition {
  /// Returns the tests tools serialization code for arguments
  ///
  /// Records and record-containing containers need to be mapped to their JSON (Map) representation,
  /// whereas models and primitives can be returned verbatim.
  Code methodArgumentSerializationCode({required GeneratorConfig config}) {
    var mapRecordToJsonRef = refer(
      'mapRecordToJson',
      'package:${config.serverPackage}/src/generated/protocol.dart',
    );
    var mapRecordContainingContainerToJsonRef = refer(
      'mapRecordContainingContainerToJson',
      'package:${config.serverPackage}/src/generated/protocol.dart',
    );

    if (type.isRecordType) {
      return refer('jsonDecode', 'dart:convert').call([
        refer('SerializationManager', serverpodUrl(true))
            .property('encode')
            .call([
          mapRecordToJsonRef.call([refer(name)])
        ]),
      ]).code;
    } else if (type.returnsRecordInContainer) {
      return Block.of([
        if (type.nullable) Code('$name == null ? null :'),
        refer('jsonDecode', 'dart:convert').call([
          refer('SerializationManager', serverpodUrl(true))
              .property('encode')
              .call([
            mapRecordContainingContainerToJsonRef.call([refer(name)]),
          ]),
        ]).code,
      ]);
    } else if ((!autoSerializedTypes.contains(type.className) &&
        !extensionSerializedTypes.contains(type.className))) {
      return refer('jsonDecode', 'dart:convert').call([
        refer('SerializationManager', serverpodUrl(true))
            .property('encode')
            .call([refer(name)]),
      ]).code;
    } else {
      return refer(name).code;
    }
  }
}

extension on Expression {
  /// Adds deserialization for record return types if needed,
  /// else cast into the desired return type.
  Expression transformReturnType(
    TypeDefinition returnType, {
    required GeneratorConfig config,
  }) {
    if (returnType.isFutureType &&
        (returnType.generics.single.isRecordType ||
            returnType.generics.single.returnsRecordInContainer)) {
      var protocolRef = refer(
        'Protocol',
        'package:${config.serverPackage}/src/generated/protocol.dart',
      );

      return property('then').call([
        CodeExpression(
          Block.of([
            const Code('(record) => '),
            protocolRef
                .newInstance([])
                .property('deserialize')
                .call(
                  [refer('record')],
                  {},
                  [returnType.generics.single.reference(true, config: config)],
                )
                .code,
          ]),
        ),
      ]);
    }

    return asA(returnType.reference(true, config: config));
  }
}
