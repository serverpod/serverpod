import 'package:code_builder/code_builder.dart' hide RecordType;
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_cli/src/generator/shared.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

const _mapRecordToJsonFuncName = 'mapRecordToJson';

/// Generates all the [ProtocolDefinition] based
/// dart libraries (basically the content of a standalone dart file).
class LibraryGenerator {
  final bool serverCode;

  final ProtocolDefinition protocolDefinition;
  final GeneratorConfig config;

  LibraryGenerator({
    required this.serverCode,
    required this.protocolDefinition,
    required this.config,
  });

  /// Generate the protocol library.
  Library generateProtocol() {
    var library = LibraryBuilder();

    var allModels = protocolDefinition.models
        .where((model) => serverCode || !model.serverOnly)
        .toList();

    var topLevelModels = allModels.where((model) {
      if (model is! ModelClassDefinition) return true;
      var sealedTopNode = model.sealedTopNode;
      bool isSealedTopNode = sealedTopNode == model;

      bool isNotPartOfSealedHierarchy = sealedTopNode == null;

      return isSealedTopNode || isNotPartOfSealedHierarchy;
    }).toList();

    var unsealedModels = allModels
        .where((model) => !(model is ModelClassDefinition && model.isSealed))
        .toList()
      ..sort(_byChildClassesBeforeParents);

    // exports
    library.directives.addAll([
      for (var classInfo in topLevelModels)
        Directive.export(TypeDefinition.getRef(classInfo)),
      if (!serverCode) Directive.export('client.dart'),
    ]);

    var protocol = ClassBuilder();

    var nonModelStreamTypes = protocolDefinition
        .getNonModelOrPrimitiveStreamTypes(modules: config.modules);

    protocol
      ..name = 'Protocol'
      ..extend = serverCode
          ? refer('SerializationManagerServer', serverpodUrl(true))
          : refer('SerializationManager', serverpodUrl(false));

    protocol.constructors.addAll([
      Constructor((c) => c..name = '_'),
      Constructor((c) => c
        ..factory = true
        ..body = refer('_instance').code),
    ]);

    var allTypesToDeserialize = protocolDefinition.typesToDeserialize;
    var recordTypesToDeserialize =
        allTypesToDeserialize.where((t) => t.isRecordType).toList();

    protocol.fields.addAll([
      Field((f) => f
        ..name = '_instance'
        ..static = true
        ..type = refer('Protocol')
        ..modifier = FieldModifier.final$
        ..assignment = const Code('Protocol._()')),
      if (serverCode)
        Field(
          (f) => f
            ..name = 'targetTableDefinitions'
            ..static = true
            ..modifier = FieldModifier.final$
            ..type = TypeReference((t) => t
              ..symbol = 'List'
              ..types.add(
                refer('TableDefinition', serverpodProtocolUrl(serverCode)),
              ))
            ..assignment = createDatabaseDefinitionFromModels(
              allModels,
              config.name,
              config.modulesAll,
            ).toCode(
              config: config,
              serverCode: serverCode,
              additionalTables: [
                for (var module in config.modules)
                  refer('Protocol.targetTableDefinitions',
                          module.dartImportUrl(serverCode))
                      .spread,
                if (config.name != 'serverpod' &&
                    config.type != PackageType.module)
                  refer('Protocol.targetTableDefinitions',
                          serverpodProtocolUrl(serverCode))
                      .spread,
              ],
            ),
        ),
    ]);
    protocol.methods.addAll([
      Method((m) => m
        ..annotations.add(refer('override'))
        ..name = 'deserialize'
        ..returns = refer('T')
        ..types.add(refer('T'))
        ..requiredParameters.add(Parameter((p) => p
          ..name = 'data'
          ..type = refer('dynamic')))
        ..optionalParameters.add(Parameter((p) => p
          ..name = 't'
          ..type = refer('Type?')))
        ..body = Block.of([
          const Code('t ??= T;'),
          ...(<Expression, Code>{
            for (var classInfo in unsealedModels)
              refer(
                  classInfo.className,
                  TypeDefinition.getRef(
                      classInfo)): Code.scope((a) =>
                  '${a(refer(classInfo.className, TypeDefinition.getRef(classInfo)))}'
                  '.fromJson(data) as T'),
            for (var classInfo in unsealedModels)
              refer('getType', serverpodUrl(serverCode)).call([], {}, [
                TypeReference(
                  (b) => b
                    ..symbol = classInfo.className
                    ..url = TypeDefinition.getRef(classInfo)
                    ..isNullable = true,
                )
              ]): Code.scope((a) => '(data!=null?'
                  '${a(refer(classInfo.className, TypeDefinition.getRef(classInfo)))}'
                  '.fromJson(data) :null) as T'),
          }..addEntries([
                  for (var classInfo in unsealedModels)
                    // Generate deserialization for fields of models.
                    if (classInfo is ClassDefinition)
                      for (var field in classInfo.fields.where(
                          (field) => field.shouldIncludeField(serverCode)))
                        ...field.type.generateDeserialization(serverCode,
                            config: config),
                  for (var type in allTypesToDeserialize)
                    ...type.generateDeserialization(
                      serverCode,
                      config: config,
                    ),
                  // Generate deserialization for extra classes.
                  for (var extraClass in config.extraClasses)
                    ...extraClass.generateDeserialization(serverCode,
                        config: config),
                  // Generate deserialization for extra classes as nullables.
                  for (var extraClass in config.extraClasses)
                    ...extraClass.asNullable
                        .generateDeserialization(serverCode, config: config),
                  // Generate deserialization for containers used in streams
                  for (var type in nonModelStreamTypes)
                    ...type.generateDeserialization(serverCode, config: config)
                ]))
              .entries
              .map((e) => Block.of([
                    const Code('if(t=='),
                    e.key.code,
                    const Code('){return '),
                    e.value,
                    const Code(';}'),
                  ])),
          for (var module in config.modules)
            Code.scope((a) =>
                'try{return ${a(refer('Protocol', module.dartImportUrl(serverCode)))}().deserialize<T>(data,t);}'
                'on ${a(refer('DeserializationTypeNotFoundException', serverpodUrl(serverCode)))} catch(_){}'),
          if (config.name != 'serverpod' &&
              (serverCode || config.dartClientDependsOnServiceClient))
            Code.scope((a) =>
                'try{return ${a(refer('Protocol', serverCode ? 'package:serverpod/protocol.dart' : 'package:serverpod_service_client/serverpod_service_client.dart'))}().deserialize<T>(data,t);}'
                'on ${a(refer('DeserializationTypeNotFoundException', serverpodUrl(serverCode)))} catch(_){}'),
          const Code('return super.deserialize<T>(data,t);'),
        ])),
      Method((m) => m
        ..annotations.add(refer('override'))
        ..name = 'getClassNameForObject'
        ..returns = refer('String?')
        ..requiredParameters.add(Parameter((p) => p
          ..name = 'data'
          ..type = refer('Object?')))
        ..body = Block.of([
          const Code(
            'String? className = super.getClassNameForObject(data);'
            'if(className != null) return className;',
          ),
          if (unsealedModels.isNotEmpty || config.extraClasses.isNotEmpty) ...[
            const Code('switch (data) {'),
            for (var extraClass in config.extraClasses)
              Code.scope((a) =>
                  'case ${a(extraClass.reference(serverCode, config: config))}():'
                  '  return \'${extraClass.className}\';'),
            for (var classInfo in unsealedModels)
              Code.scope((a) =>
                  'case ${a(refer(classInfo.className, TypeDefinition.getRef(classInfo)))}():'
                  '  return \'${classInfo.className}\';'),
            const Code('}'),
          ],
          if (config.name != 'serverpod' && serverCode)
            _buildGetClassNameForObjectDelegation(
                serverpodProtocolUrl(serverCode), 'serverpod'),
          for (var module in config.modules)
            _buildGetClassNameForObjectDelegation(
                module.dartImportUrl(serverCode), module.name),
          for (var containerType in nonModelStreamTypes)
            Block.of([
              const Code('if(data is '),
              containerType.reference(serverCode, config: config).code,
              const Code(') {'),
              Code(
                  'return \'${containerType.classNameWithGenericsForProtocol(modules: config.modules)}\';'),
              const Code('}'),
            ]),
          const Code('return null;'),
        ])),
      Method((m) => m
        ..annotations.add(refer('override'))
        ..name = 'deserializeByClassName'
        ..returns = refer('dynamic')
        ..requiredParameters.add(Parameter((p) => p
          ..name = 'data'
          ..type = refer('Map<String,dynamic>')))
        ..body = Block.of([
          const Code('var dataClassName = data[\'className\'];'),
          const Code('if (dataClassName is! String) {'
              'return super.deserializeByClassName(data);}'),
          for (var extraClass in config.extraClasses)
            Code.scope((a) =>
                'if(dataClassName == \'${extraClass.className}\'){'
                'return deserialize<${a(extraClass.reference(serverCode, config: config))}>(data[\'data\']);}'),
          for (var classInfo in unsealedModels)
            Code.scope((a) => 'if(dataClassName == \'${classInfo.className}\'){'
                'return deserialize<${a(refer(classInfo.className, TypeDefinition.getRef(classInfo)))}>(data[\'data\']);}'),
          if (config.name != 'serverpod' && serverCode)
            _buildDeserializeByClassNameDelegation(
              serverpodProtocolUrl(serverCode),
              'serverpod',
            ),
          for (var module in config.modules)
            _buildDeserializeByClassNameDelegation(
              module.dartImportUrl(serverCode),
              module.name,
            ),
          for (final containerType in nonModelStreamTypes) ...[
            Code(
                "if (dataClassName == '${containerType.classNameWithGenericsForProtocol(modules: config.modules)}') {"),
            const Code('return deserialize<'),
            containerType.reference(serverCode, config: config).code,
            const Code('>(data[\'data\']);'),
            const Code('}'),
          ],
          const Code('return super.deserializeByClassName(data);'),
        ])),
      if (serverCode)
        Method(
          (m) => m
            ..name = 'getTableForType'
            ..annotations.add(refer('override'))
            ..returns = TypeReference((t) => t
              ..symbol = 'Table'
              ..url = serverpodUrl(serverCode)
              ..isNullable = true)
            ..requiredParameters.add(Parameter((p) => p
              ..name = 't'
              ..type = refer('Type')))
            ..body = Block.of([
              for (var module in config.modules)
                Code.scope((a) =>
                    '{var table = ${a(refer('Protocol', module.dartImportUrl(serverCode)))}().getTableForType(t);'
                    'if(table!=null) {return table;}}'),
              if (config.name != 'serverpod' &&
                  (serverCode || config.dartClientDependsOnServiceClient))
                Code.scope((a) =>
                    '{var table = ${a(refer('Protocol', serverCode ? 'package:serverpod/protocol.dart' : 'package:serverpod_service_client/serverpod_service_client.dart'))}().getTableForType(t);'
                    'if(table!=null) {return table;}}'),
              if (allModels.any((classInfo) =>
                  classInfo is ModelClassDefinition &&
                  classInfo.tableName != null))
                Block.of([
                  const Code('switch(t){'),
                  for (var classInfo in allModels)
                    if (classInfo is ModelClassDefinition &&
                        classInfo.tableName != null)
                      Code.scope((a) =>
                          'case ${a(refer(classInfo.className, TypeDefinition.getRef(classInfo)))}:'
                          'return ${a(refer(classInfo.className, TypeDefinition.getRef(classInfo)))}.t;'),
                  const Code('}'),
                ]),
              const Code('return null;'),
            ]),
        ),
      if (serverCode)
        Method(
          (m) => m
            ..name = 'getTargetTableDefinitions'
            ..annotations.add(refer('override'))
            ..returns = TypeReference((t) => t
              ..symbol = 'List'
              ..types.add(
                refer('TableDefinition', serverpodProtocolUrl(serverCode)),
              ))
            ..body = refer('targetTableDefinitions').code,
        ),
      if (serverCode)
        Method(
          (m) => m
            ..name = 'getModuleName'
            ..annotations.add(refer('override'))
            ..returns = TypeReference((t) => t..symbol = 'String')
            ..body = literalString(config.name).code,
        ),
      if (protocolDefinition.usesRecordsInStreams)
        Method(
          (m) => m
            ..annotations.add(refer('override'))
            ..docs.add('''
  /// Wraps serialized data with its class name so that it can be deserialized
  /// with [deserializeByClassName].
  ///
  /// Records and containers containing records will be return in their JSON representation in the returned map.''')
            ..name = 'wrapWithClassName'
            ..returns = refer('Map<String, dynamic>')
            ..requiredParameters.add(Parameter((p) => p
              ..name = 'data'
              ..type = refer('Object?')))
            ..body = const Code('''
/// In case the value (to be streamed) contains a record, we need to map it before it reaches the underlying JSON encode
   if (data is Iterable || data is Map) {
      return {
        'className': getClassNameForObject(data)!,
        'data': mapRecordContainingContainerToJson(data!),
      };
    } else if (data is Record) {
      return {
        'className': getClassNameForObject(data)!,
        'data': mapRecordToJson(data),
      };
    }

    return super.wrapWithClassName(data);
'''),
        ),
    ]);

    library.body.add(protocol.build());

    if (recordTypesToDeserialize.isNotEmpty) {
      library.body.addAll(
        _deserializationMethodsForRecordTypes(recordTypesToDeserialize),
      );
    }

    return library.build();
  }

  Block _buildGetClassNameForObjectDelegation(
    String protocolImportPath,
    String projectName,
  ) {
    return Block.of([
      Code.scope((a) =>
          'className = ${a(refer('Protocol', protocolImportPath))}().getClassNameForObject(data);'),
      Code('if(className != null){return \'$projectName.\$className\';}'),
    ]);
  }

  Block _buildDeserializeByClassNameDelegation(
    String protocolImportPath,
    String projectName,
  ) {
    return Block.of([
      Code('if(dataClassName.startsWith(\'$projectName.\')){'
          'data[\'className\'] = dataClassName.substring(${projectName.length + 1});'),
      Code.scope((a) =>
          'return ${a(refer('Protocol', protocolImportPath))}().deserializeByClassName(data);'),
      const Code('}'),
    ]);
  }

  /// Generates the EndpointDispatch for the server side.
  /// Executing this only makes sens for the server code
  /// (if [serverCode] is `true`).
  Library generateServerEndpointDispatch() {
    var library = LibraryBuilder();

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
                  if (protocolDefinition.endpoints.isNotEmpty) ...[
                    _buildEndpointLookupMap(protocolDefinition.endpoints),
                    _buildEndpointConnectors(protocolDefinition.endpoints),
                  ],

                  // Connectors
                  // Hook up modules
                  for (var module in config.modules)
                    refer('modules')
                        .index(literalString(module.name))
                        .assign(refer('Endpoints',
                                'package:${module.serverPackage}/${module.serverPackage}.dart')
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

  /// Generates endpoint calls for the client side.
  /// Executing this only makes sens for the client code
  /// (if [serverCode] is `false`).
  Library generateClientEndpointCalls() {
    String getEndpointClassName(String endpointName) {
      return 'Endpoint${ReCase(endpointName).pascalCase}';
    }

    var library = LibraryBuilder();

    var hasModules =
        config.modules.isNotEmpty && config.type != PackageType.module;

    var modulePrefix =
        config.type != PackageType.module ? '' : '${config.name}.';

    for (var endpointDef in protocolDefinition.endpoints) {
      var endpointClassName = getEndpointClassName(endpointDef.name);

      library.body.add(
        Class((endpoint) {
          endpoint
            ..docs.add(endpointDef.documentationComment ?? '')
            ..docs.add('/// {@category Endpoint}')
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
                  ..annotations.addAll(_buildEndpointCallAnnotations(methodDef))
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
                  ..body = switch (methodDef) {
                    MethodCallDefinition methodDef => _buildCallServerEndpoint(
                        modulePrefix,
                        endpointDef,
                        methodDef,
                        requiredParams,
                        optionalParams,
                        namedParameters,
                      ),
                    MethodStreamDefinition methodDef =>
                      _buildCallStreamingServerEndpoint(
                        modulePrefix,
                        endpointDef,
                        methodDef,
                        requiredParams,
                        optionalParams,
                        namedParameters,
                      ),
                    _ => throw Exception(
                        'Unknown method definition type: $methodDef',
                      ),
                  },
              ),
            );
          }
        }),
      );
    }

    if (hasModules) {
      library.body.add(
        Class((c) => c
          ..name = 'Modules'
          ..fields.addAll([
            for (var module in config.modules)
              Field((f) => f
                ..late = true
                ..modifier = FieldModifier.final$
                ..name = module.nickname
                ..type = refer('Caller', module.dartImportUrl(false))),
          ])
          ..constructors.add(
            Constructor((c) => c
              ..requiredParameters.add(Parameter((p) => p
                ..type = refer('Client')
                ..name = 'client'))
              ..body = Block.of([
                for (var module in config.modules)
                  refer(module.nickname)
                      .assign(refer('Caller', module.dartImportUrl(false))
                          .call([refer('client')]))
                      .statement,
              ])),
          )),
      );
    }

    library.body.add(
      Class(
        (c) => c
          ..name = config.type != PackageType.module ? 'Client' : 'Caller'
          ..extend = config.type != PackageType.module
              ? refer('ServerpodClientShared', serverpodUrl(false))
              : refer('ModuleEndpointCaller', serverpodUrl(false))
          ..fields.addAll([
            for (var endpointDef in protocolDefinition.endpoints)
              Field((f) => f
                ..late = true
                ..modifier = FieldModifier.final$
                ..name = endpointDef.name
                ..type = refer(getEndpointClassName(endpointDef.name))),
            if (hasModules)
              Field((f) => f
                ..late = true
                ..modifier = FieldModifier.final$
                ..name = 'modules'
                ..type = refer('Modules')),
          ])
          ..constructors.add(
            Constructor((c) {
              if (config.type != PackageType.module) {
                c
                  ..requiredParameters.add(Parameter((p) => p
                    ..type = refer('String')
                    ..name = 'host'))
                  ..optionalParameters.addAll([
                    Parameter((p) => p
                      ..name = 'securityContext'
                      ..named = false
                      ..type = TypeReference((t) => t..symbol = 'dynamic')),
                    Parameter((p) => p
                      ..name = 'authenticationKeyManager'
                      ..named = true
                      ..type = TypeReference((t) => t
                        ..symbol = 'AuthenticationKeyManager'
                        ..url = serverpodUrl(false)
                        ..isNullable = true)),
                    Parameter((p) => p
                      ..name = 'streamingConnectionTimeout'
                      ..named = true
                      ..type = TypeReference((t) => t
                        ..symbol = 'Duration'
                        ..url = 'dart:core'
                        ..isNullable = true)),
                    Parameter((p) => p
                      ..name = 'connectionTimeout'
                      ..named = true
                      ..type = TypeReference((t) => t
                        ..symbol = 'Duration'
                        ..url = 'dart:core'
                        ..isNullable = true)),
                    Parameter((p) => p
                      ..name = 'onFailedCall'
                      ..named = true
                      ..type = FunctionType((f) => f
                        ..isNullable = true
                        ..requiredParameters.addAll([
                          TypeReference((t) => t
                            ..symbol = 'MethodCallContext'
                            ..url = serverpodUrl(false)
                            ..isNullable = false),
                          TypeReference((t) => t
                            ..symbol = 'Object'
                            ..url = 'dart:core'
                            ..isNullable = false),
                          TypeReference((t) => t
                            ..symbol = 'StackTrace'
                            ..url = 'dart:core'
                            ..isNullable = false),
                        ]))),
                    Parameter((p) => p
                      ..name = 'onSucceededCall'
                      ..named = true
                      ..type = FunctionType((f) => f
                        ..isNullable = true
                        ..requiredParameters.add(
                          TypeReference((t) => t
                            ..symbol = 'MethodCallContext'
                            ..url = serverpodUrl(false)
                            ..isNullable = false),
                        ))),
                    Parameter((p) => p
                      ..name = 'disconnectStreamsOnLostInternetConnection'
                      ..named = true
                      ..type = TypeReference(
                        (t) => t
                          ..symbol = 'bool'
                          ..url = 'dart:core'
                          ..isNullable = true,
                      )),
                  ])
                  ..initializers.add(refer('super').call([
                    refer('host'),
                    refer('Protocol', 'protocol.dart').call([])
                  ], {
                    'securityContext': refer('securityContext'),
                    'authenticationKeyManager':
                        refer('authenticationKeyManager'),
                    'streamingConnectionTimeout':
                        refer('streamingConnectionTimeout'),
                    'connectionTimeout': refer('connectionTimeout'),
                    'onFailedCall': refer('onFailedCall'),
                    'onSucceededCall': refer('onSucceededCall'),
                    'disconnectStreamsOnLostInternetConnection':
                        refer('disconnectStreamsOnLostInternetConnection'),
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
                      .assign(refer(getEndpointClassName(endpointDef.name))
                          .call([refer('this')]))
                      .statement,
                if (hasModules)
                  refer('modules')
                      .assign(refer('Modules').call([refer('this')]))
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
              if (config.type != PackageType.module)
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

  Iterable<Expression> _buildEndpointCallAnnotations(
      MethodDefinition methodDef) {
    return methodDef.annotations.map((annotation) {
      var args = annotation.arguments;
      return refer(args != null
          ? '${annotation.name}(${args.join(',')})'
          : annotation.name);
    });
  }

  Code _buildCallServerEndpoint(
    String modulePrefix,
    EndpointDefinition endpointDef,
    MethodCallDefinition methodDef,
    List<ParameterDefinition> requiredParams,
    List<ParameterDefinition> optionalParams,
    List<ParameterDefinition> namedParameters,
  ) {
    var params = [
      ...requiredParams,
      ...optionalParams,
      ...namedParameters,
    ];

    var mapRecordContainingContainerToJsonRef = refer(
      'mapRecordContainingContainerToJson',
      serverCode
          ? 'package:${config.serverPackage}/src/generated/protocol.dart'
          : 'package:${config.dartClientPackage}/src/protocol/protocol.dart',
    );
    var mapRecordToJsonRef = refer(
      _mapRecordToJsonFuncName,
      serverCode
          ? 'package:${config.serverPackage}/src/generated/protocol.dart'
          : 'package:${config.dartClientPackage}/src/protocol/protocol.dart',
    );

    return refer('caller').property('callServerEndpoint').call([
      literalString('$modulePrefix${endpointDef.name}'),
      literalString(methodDef.name),
      literalMap({
        for (var parameterDef in params)
          // The generated classes implement `ProtocolSerialization` and get handle by `serverpod_serialization` later
          // For the records we need to transform them into a map that can be handled by the shared (non-project specific) serialization code
          literalString(parameterDef.name): parameterDef.type.isRecordType
              ? mapRecordToJsonRef.call([refer(parameterDef.name)]).code
              : (parameterDef.type.returnsRecordInContainer
                  ? Block.of([
                      if (parameterDef.type.nullable)
                        Code('${parameterDef.name} == null ? null :'),
                      mapRecordContainingContainerToJsonRef
                          .call([refer(parameterDef.name)]).code,
                    ])
                  : refer(parameterDef.name)),
      })
    ], {}, [
      methodDef.returnType.generics.first.reference(false, config: config)
    ]).code;
  }

  Code _buildCallStreamingServerEndpoint(
    String modulePrefix,
    EndpointDefinition endpointDef,
    MethodStreamDefinition methodDef,
    List<ParameterDefinition> requiredParams,
    List<ParameterDefinition> optionalParams,
    List<ParameterDefinition> namedParameters,
  ) {
    var (streamingParams, params) = separateStreamParametersFromParameters([
      ...requiredParams,
      ...optionalParams,
      ...namedParameters,
    ]);

    return refer('caller').property('callStreamingServerEndpoint').call([
      literalString('$modulePrefix${endpointDef.name}'),
      literalString(methodDef.name),
      literalMap({
        for (var parameterDef in params)
          literalString(parameterDef.name): refer(parameterDef.name),
      }),
      literalMap({
        for (var parameterDef in streamingParams)
          literalString(parameterDef.name): refer(parameterDef.name),
      }),
    ], {}, [
      methodDef.returnType.reference(false, config: config),
      methodDef.returnType.generics.first.reference(false, config: config),
    ]).code;
  }

  String? _generatedDirectoryPathCache;
  String _buildGeneratedDirectoryPath() => _generatedDirectoryPathCache ??=
      p.joinAll([...config.generatedServeModelPathParts]);

  String _endpointPath(EndpointDefinition endpoint) {
    var relativePath = p.relative(
      endpoint.filePath,
      from: _buildGeneratedDirectoryPath(),
    );

    // Replace backslashes with forward slashes to make it work on Windows.
    return p.split(relativePath).join('/');
  }

  Code _buildEndpointLookupMap(List<EndpointDefinition> endpoints) {
    return refer('var endpoints')
        .assign(literalMap({
          for (var endpoint in endpoints)
            endpoint.name: refer(endpoint.className, _endpointPath(endpoint))
                .call([])
                .cascade('initialize')
                .call([
                  refer('server'),
                  literalString(endpoint.name),
                  config.type != PackageType.module
                      ? refer('null')
                      : literalString(config.name)
                ])
        }, refer('String'), refer('Endpoint', serverpodUrl(true))))
        .statement;
  }

  Code _buildEndpointConnectors(List<EndpointDefinition> endpoints) {
    return Block.of([
      for (var endpoint in endpoints)
        refer('connectors')
            .index(literalString(endpoint.name))
            .assign(refer('EndpointConnector', serverpodUrl(true)).call([], {
              'name': literalString(endpoint.name),
              'endpoint': refer('endpoints')
                  .index(literalString(endpoint.name))
                  .nullChecked,
              'methodConnectors': literalMap(
                {
                  ..._buildMethodConnectors(
                    endpoint,
                    endpoint.methods.whereType<MethodCallDefinition>(),
                  ),
                  ..._buildMethodStreamConnectors(
                    endpoint,
                    endpoint.methods.whereType<MethodStreamDefinition>(),
                  )
                },
              )
            }))
            .statement
    ]);
  }

  Map<Object, Object> _buildMethodConnectors(
    EndpointDefinition endpoint,
    Iterable<MethodCallDefinition> methods,
  ) {
    var methodConnectors = <Object, Object>{};
    for (var method in methods) {
      methodConnectors[literalString(method.name)] =
          refer('MethodConnector', serverpodUrl(true)).call([], {
        'name': literalString(method.name),
        'params': literalMap({
          for (var param in method.allParameters)
            literalString(param.name):
                refer('ParameterDescription', serverpodUrl(true)).call([], {
              'name': literalString(param.name),
              'type': refer('getType', serverpodUrl(true))
                  .call([], {}, [param.type.reference(true, config: config)]),
              'nullable': literalBool(param.type.nullable),
            })
        }),
        'call': Method(
          (m) => m
            ..requiredParameters.addAll([
              Parameter((p) => p
                ..name = 'session'
                ..type = refer('Session', serverpodUrl(true))),
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
                .asA(refer(endpoint.className, _endpointPath(endpoint)))
                .property(
                  '${_getMethodCallComment(method) ?? ''}${method.name}',
                )
                .call([
                  refer('session'),
                  for (var param in [
                    ...method.parameters,
                    ...method.parametersPositional
                  ])
                    refer('params').index(literalString(param.name)),
                ], {
                  for (var param in [...method.parametersNamed])
                    param.name:
                        refer('params').index(literalString(param.name)),
                })
                .transformRecordReturnType(
                  method.returnType,
                  serverCode: serverCode,
                  config: config,
                )
                .code,
        ).closure,
      });
    }
    return methodConnectors;
  }

  String? _getMethodCallComment(MethodCallDefinition m) {
    for (var a in m.annotations) {
      if (a.methodCallAnalyzerIgnoreRule != null) {
        return '\n// ignore: ${a.methodCallAnalyzerIgnoreRule}\n';
      }
    }
    return null;
  }

  Map<Object, Object> _buildMethodStreamConnectors(
    EndpointDefinition endpoint,
    Iterable<MethodStreamDefinition> methods,
  ) {
    var methodStreamConnectors = <Object, Object>{};
    for (var method in methods) {
      var (streamingParams, nonStreamingParams) =
          separateStreamParametersFromParameters(method.allParameters);
      methodStreamConnectors[literalString(method.name)] =
          refer('MethodStreamConnector', serverpodUrl(true)).call([], {
        'name': literalString(method.name),
        'params': literalMap({
          for (var param in nonStreamingParams)
            literalString(param.name):
                refer('ParameterDescription', serverpodUrl(true)).call([], {
              'name': literalString(param.name),
              'type': refer('getType', serverpodUrl(true))
                  .call([], {}, [param.type.reference(true, config: config)]),
              'nullable': literalBool(param.type.nullable),
            })
        }),
        'streamParams': literalMap({
          for (var param in streamingParams)
            literalString(param.name):
                refer('StreamParameterDescription', serverpodUrl(true))
                    .call([], {
              'name': literalString(param.name),
              'nullable': literalBool(param.type.nullable),
            }, [
              param.type.generics.first.reference(true, config: config)
            ])
        }),
        'returnType': _buildMethodStreamReturnType(method.returnType),
        'call': Method(
          (m) => m
            ..requiredParameters.addAll([
              Parameter((p) => p
                ..name = 'session'
                ..type = refer('Session', serverpodUrl(true))),
              Parameter((p) => p
                ..name = 'params'
                ..type = TypeReference((t) => t
                  ..symbol = 'Map'
                  ..types.addAll([
                    refer('String'),
                    refer('dynamic'),
                  ]))),
              Parameter((p) => p
                ..name = 'streamParams'
                ..type = TypeReference((t) => t
                  ..symbol = 'Map'
                  ..types.addAll([
                    refer('String'),
                    refer('Stream'),
                  ]))),
            ])
            ..body = refer('endpoints')
                .index(literalString(endpoint.name))
                .asA(refer(endpoint.className, _endpointPath(endpoint)))
                .property(method.name)
                .call([
              refer('session'),
              for (var param in [
                ...method.parameters,
                ...method.parametersPositional
              ])
                _referMethodStreamParam(param),
            ], {
              for (var param in [...method.parametersNamed])
                param.name: _referMethodStreamParam(param),
            }).code,
        ).closure,
      });
    }
    return methodStreamConnectors;
  }

  Expression _buildMethodStreamReturnType(TypeDefinition returnType) {
    var returnEnum = refer('MethodStreamReturnType', serverpodUrl(true));

    if (returnType.generics.first.isVoidType) {
      return returnEnum.property('voidType');
    } else if (returnType.isStreamType) {
      return returnEnum.property('streamType');
    } else if (returnType.isFutureType) {
      return returnEnum.property('futureType');
    }

    throw Exception('Unrecognized return type for endpoint method stream.');
  }

  (
    List<ParameterDefinition> streamingParams,
    List<ParameterDefinition> nonStreamingParams
  ) separateStreamParametersFromParameters(
    Iterable<ParameterDefinition> params,
  ) {
    List<ParameterDefinition> streamingParams = [];
    List<ParameterDefinition> nonStreamingParams = [];

    for (var param in params) {
      if (param.type.isStreamType) {
        streamingParams.add(param);
      } else {
        nonStreamingParams.add(param);
      }
    }

    return (streamingParams, nonStreamingParams);
  }

  Expression _referMethodStreamParam(ParameterDefinition param) {
    if (param.type.isStreamType) {
      return refer('streamParams')
          .index(literalString(param.name))
          .nullChecked
          .property('cast')
          .call(
        [],
        {},
        [param.type.generics.first.reference(true, config: config)],
      );
    } else {
      return refer('params').index(literalString(param.name));
    }
  }

  Iterable<Method> _deserializationMethodsForRecordTypes(
    List<TypeDefinition> recordTypesToDeserialize,
  ) {
    return [
      Method(
        (m) => m
          ..docs.add('''
            /// Maps any `Record`s known to this [Protocol] to their JSON representation
            ///
            /// Throws in case the record type is not known.
            ///
            /// This method will return `null` (only) for `null` inputs.''')
          ..name = _mapRecordToJsonFuncName
          ..returns = refer('Map<String, dynamic>?')
          ..requiredParameters.add(Parameter((p) => p
            ..name = 'record'
            ..type = refer('Record?')))
          ..body = _buildRecordEncode(
            recordTypesToDeserialize,
            'record',
            serverCode: serverCode,
            config: config,
          ),
      ),
      Method((m) => m
        ..docs.add('''
          /// Maps container types (like [List], [Map], [Set]) containing [Record]s to their JSON representation.
          ///
          /// It should not be called for [SerializableModel] types. These handle the "[Record] in container" mapping internally already.
          ///
          /// It is only supposed to be called from generated protocol code.
          ///
          /// Returns either a `List<dynamic>` (for List, Sets, and Maps with non-String keys) or a `Map<String, dynamic>` in case the input was a `Map<String, …>`.''')
        ..name = 'mapRecordContainingContainerToJson'
        ..returns = refer('Object?')
        ..requiredParameters.add(Parameter((p) => p
          ..name = 'obj'
          ..type = refer('Object')))
        ..body = const Code('''
          if (obj is! Iterable && obj is! Map) {
            throw ArgumentError.value(
              obj, 'obj',
              'The object to serialize should be of type List, Map, or Set',
            );
          }

          dynamic mapIfNeeded(Object? obj) {
            return switch (obj) {
              Record record => mapRecordToJson(record),
              Iterable iterable => mapRecordContainingContainerToJson(iterable),
              Map map => mapRecordContainingContainerToJson(map),
              Object? value => value,
            };
          }

          switch (obj) {
            case Map<String, dynamic>():
              return {
                for (var entry in obj.entries)
                  entry.key: mapIfNeeded(entry.value),
              };
            case Map():
              return [
                for (var entry in obj.entries)
                  {
                    'k': mapIfNeeded(entry.key),
                    'v': mapIfNeeded(entry.value),
                  }
              ];

            case Iterable():
              return [
                for (var e in obj)
                  mapIfNeeded(e),
              ];
          }

          return obj;''')),
    ];
  }
}

extension TypeDefinitionReturnsRecordInContainer on TypeDefinition {
  bool get returnsRecordInContainer {
    return ((isMapType || isListType || isSetType) &&
        generics.any((g) =>
            g.isRecordType ||
            // Important to only check default container types, there is not need to descent into model classes
            (g.isMapType || g.isListType || g.isSetType) &&
                g.returnsRecordInContainer));
  }
}

extension on ProtocolDefinition {
  void _addTypeAndCollectRecords(
    TypeDefinition classDef,
    List<TypeDefinition> recordTypes,
    Set<String> handledTypes,
  ) {
    var typeName = classDef.dartType?.toString() ?? classDef.toString();
    if (handledTypes.contains(typeName)) {
      return;
    }

    handledTypes.add(typeName);
    recordTypes.add(classDef);

    for (var generic in classDef.generics) {
      if (generic.isRecordType) {
        _addRecordType(generic, recordTypes, handledTypes);
      } else {
        _addTypeAndCollectRecords(generic, recordTypes, handledTypes);
      }
    }
  }

  void _addRecordType(
    TypeDefinition recordType,
    List<TypeDefinition> recordTypes,
    Set<String> handledTypes,
  ) {
    var typeName = recordType.dartType?.toString() ?? recordType.toString();
    if (handledTypes.contains(typeName)) {
      return;
    }

    handledTypes.add(typeName);
    recordTypes.add(recordType);

    for (var fieldType in recordType.generics.map((f) => f)) {
      if (fieldType.isRecordType) {
        _addRecordType(fieldType, recordTypes, handledTypes);
      } else {
        _addTypeAndCollectRecords(fieldType, recordTypes, handledTypes);
      }
    }
  }

  /// Returns all top-level types and record types referenced by the protocol.
  ///
  /// For records it also returns sub record types, as these are also required
  /// to be supported by `deserialize` on the `Protocol`.
  List<TypeDefinition> get typesToDeserialize {
    var recordTypes = <TypeDefinition>[];

    var handledTypes = <String>{};

    for (var method in endpoints.expand((e) => e.methods)) {
      var returnType = method.returnType;
      // all endpoints are either Stream or Future, but may also use containers like `Stream<List<(int,)>>`
      _addTypeAndCollectRecords(returnType, recordTypes, handledTypes);

      for (var parameter in method.allParameters) {
        var type = parameter.type;

        if (type.isRecordType) {
          _addRecordType(type, recordTypes, handledTypes);
        } else {
          _addTypeAndCollectRecords(type, recordTypes, handledTypes);
        }
      }
    }

    for (var model in models.whereType<ClassDefinition>()) {
      for (var field in model.fields) {
        if (field.type.isRecordType) {
          _addRecordType(field.type, recordTypes, handledTypes);
        } else if (field.type.returnsRecordInContainer) {
          _addTypeAndCollectRecords(field.type, recordTypes, handledTypes);
        }
      }
    }

    return recordTypes;
  }

  /// Returns whether the endpoints use records in combination with `Stream`s
  /// Either as return type or parameters, and either directly or wrapped in a container.
  bool get usesRecordsInStreams {
    for (var method in endpoints.expand((e) => e.methods)) {
      for (var type in [
        method.returnType,
        ...method.allParameters.map((p) => p.type)
      ]) {
        if (type.isStreamType &&
            (type.generics.first.isRecordType ||
                type.generics.first.returnsRecordInContainer)) {
          return true;
        }
      }
    }

    return false;
  }

  //// Returns all non-model/non-primitive types used with `Streams`
  ///
  /// E.g. for a return or parameter type of `Stream<Set<(int,)>>` this would return the `Set<(int,)>`.
  ///
  /// This is because those containers can not be handled by the normal (de)serialize flow but need custom code generated
  List<TypeDefinition> getNonModelOrPrimitiveStreamTypes({
    required List<ModuleConfig> modules,
  }) {
    var nonModelOrPrimitiveStreamTypes = <TypeDefinition>[];

    for (var topLevelType in endpoints
        .expand((e) => e.methods)
        .expand((m) => [m.returnType, ...m.allParameters.map((p) => p.type)])
        .where((t) => t.isStreamType)) {
      var valueType = topLevelType.generics.first;
      if (valueType.isSetType ||
          valueType.isListType ||
          valueType.isMapType ||
          valueType.isRecordType) {
        if (!nonModelOrPrimitiveStreamTypes.any((type) =>
            type.classNameWithGenericsForProtocol(modules: modules) ==
            valueType.classNameWithGenericsForProtocol(modules: modules))) {
          nonModelOrPrimitiveStreamTypes.add(valueType);
        }
      }
    }

    return nonModelOrPrimitiveStreamTypes;
  }
}

Code _buildRecordEncode(
  Iterable<TypeDefinition> recordTypes,
  String name, {
  required bool serverCode,
  required GeneratorConfig config,
}) {
  var codes = <Code>[
    const Code('if (record == null ) {return null;}'),
  ];

  var handledTypes = <String>{};

  for (var recordType in recordTypes) {
    assert(recordType.isRecordType);
    var nonNullTypeName = recordType.asNonNullable.toString();

    if (handledTypes.contains(nonNullTypeName)) {
      continue;
    }
    handledTypes.add(nonNullTypeName);

    codes.addAll([
      Code('if ($name is '),
      recordType.reference(serverCode, config: config, nullable: false).code,
      const Code(') {'),
      const Code('return '),
      recordType.recordToJsonMapCode(
        name: name,
        serverCode: serverCode,
        config: config,
        nullable: false,
      ),
      const Code(';'),
      const Code('}'),
    ]);
  }

  codes.add(
    const Code(
      "throw Exception('Unsupported record type \${record.runtimeType}');",
    ),
  );

  return Block.of(codes);
}

extension on Expression {
  Expression transformRecordReturnType(
    TypeDefinition returnType, {
    required bool serverCode,
    required GeneratorConfig config,
  }) {
    var mapRecordToJsonRef = refer(
      _mapRecordToJsonFuncName,
      serverCode
          ? 'package:${config.serverPackage}/src/generated/protocol.dart'
          : 'package:${config.dartClientPackage}/src/protocol/protocol.dart',
    );
    var mapRecordContainingContainerToJsonRef = refer(
      'mapRecordContainingContainerToJson',
      serverCode
          ? 'package:${config.serverPackage}/src/generated/protocol.dart'
          : 'package:${config.dartClientPackage}/src/protocol/protocol.dart',
    );

    if (returnType.generics.isNotEmpty &&
        returnType.generics.first.isRecordType) {
      return property('then').call([
        CodeExpression(
          Block.of([
            const Code('(record) => '),
            mapRecordToJsonRef.call([refer('record')]).code,
          ]),
        ),
      ]);
    }

    if (returnType.generics.isNotEmpty &&
        returnType.generics.first.returnsRecordInContainer) {
      return property('then').call(
        [
          CodeExpression(
            Block.of([
              const Code('(container) => '),
              if (returnType.generics.first.nullable)
                const Code('container == null ? null : '),
              mapRecordContainingContainerToJsonRef.call([
                refer('container'),
              ]).code,
            ]),
          ),
        ],
      );
    }

    return this;
  }
}

extension on TypeDefinition {
  Code recordToJsonMapCode({
    required String name,
    required bool serverCode,
    required GeneratorConfig config,
    bool? nullable,
  }) {
    assert(isRecordType);

    var positionalFields =
        generics.where((f) => f.recordFieldName == null).toList();
    var namedFields = generics.where((f) => f.recordFieldName != null).toList();

    return Block.of([
      if (nullable ?? this.nullable) Code('$name == null ? null : '),
      const Code('{'),
      if (positionalFields.isNotEmpty) ...[
        const Code('"p": ['),
        for (var (index, positionalField) in positionalFields.indexed) ...[
          if (positionalField.isRecordType) ...[
            Code(
              '$_mapRecordToJsonFuncName($name.\$${index + 1})',
            ),
          ] else
            Code('$name.\$${index + 1}'),
          const Code(','),
        ],
        const Code('],'),
      ],
      if (namedFields.isNotEmpty) ...[
        const Code('"n": {'),
        for (final namedField in namedFields) ...[
          Code('"${namedField.recordFieldName!}"'),
          const Code(':'),
          if (namedField.isRecordType)
            Code(
              '$_mapRecordToJsonFuncName($name.${namedField.recordFieldName!})',
            )
          else
            Code('$name.${namedField.recordFieldName!}'),
          const Code(','),
        ],
        const Code('},'),
      ],
      const Code('}'),
    ]);
  }
}

extension on TypeDefinition {
  /// Returns the class name with generic parameters (without any optional formatting whitespace),
  /// but strips all import path for a succinct representation.
  ///
  /// A simple `List<int>` becomes `"List<int>"`, a list referring to a model object in the project for example `"List<MyModel>"`
  /// Using a model from another module will look like `"List<serverpod_auth.UserInfo>"`
  String classNameWithGenericsForProtocol({
    required List<ModuleConfig> modules,
  }) {
    if (isRecordType) {
      var positionalFields =
          generics.where((f) => f.recordFieldName == null).toList();
      var namedFields =
          generics.where((f) => f.recordFieldName != null).toList();

      return [
        '(',
        positionalFields
            .map((t) => t.classNameWithGenericsForProtocol(modules: modules))
            .join(','),
        if (namedFields.isNotEmpty || positionalFields.length == 1) ',',
        if (namedFields.isNotEmpty) ...[
          '{',
          namedFields
              .map((f) =>
                  '${f.classNameWithGenericsForProtocol(modules: modules)} ${f.recordFieldName!}')
              .join(','),
          '}',
        ],
        ')',
        if (nullable) '?',
      ].join();
    }

    String? moduleName;
    for (var module in modules) {
      // NOTE(tp): Since we're iterating over types used in the endpoints, the import always refers to the server package
      if (url != null && url!.startsWith('package:${module.serverPackage}/')) {
        moduleName = module.name;
      }
    }

    return '${moduleName != null ? '$moduleName.' : ''}$className${generics.isNotEmpty ? '<${generics.map((e) => e.classNameWithGenericsForProtocol(modules: modules)).join(',')}>' : ''}${nullable ? '?' : ''}';
  }
}

extension on DatabaseDefinition {
  Code toCode({
    required List<Expression> additionalTables,
    required bool serverCode,
    required GeneratorConfig config,
  }) {
    return literalList([
      for (var table in tables)
        refer('TableDefinition', serverpodProtocolUrl(serverCode)).call([], {
          'name': literalString(table.name),
          if (table.dartName != null)
            'dartName': literalString(table.dartName!),
          'schema': literalString(table.schema),
          'module': literalString(config.name),
          'columns': literalList([
            for (var column in table.columns)
              refer('ColumnDefinition', serverpodProtocolUrl(serverCode))
                  .call([], {
                'name': literalString(column.name),
                'columnType': refer('ColumnType.${column.columnType.name}',
                    serverpodProtocolUrl(serverCode)),
                // The id column is not null, since it is auto incrementing.
                'isNullable': literalBool(column.isNullable),
                if (column.dartType != null)
                  'dartType': literalString(column.dartType!),
                if (column.columnDefault != null)
                  'columnDefault': literalString(column.columnDefault!),
                if (column.vectorDimension != null)
                  'vectorDimension': literalNum(column.vectorDimension!),
              }),
          ]),
          'foreignKeys': literalList([
            for (var foreignKey in table.foreignKeys)
              refer('ForeignKeyDefinition', serverpodProtocolUrl(serverCode))
                  .call([], {
                'constraintName': literalString(foreignKey.constraintName),
                'columns': literalList([
                  for (var column in foreignKey.columns) literalString(column),
                ]),
                'referenceTable': literalString(foreignKey.referenceTable),
                'referenceTableSchema':
                    literalString(foreignKey.referenceTableSchema),
                'referenceColumns': literalList([
                  for (var column in foreignKey.referenceColumns)
                    literalString(column),
                ]),
                'onUpdate': foreignKey.onUpdate != null
                    ? refer('ForeignKeyAction.${foreignKey.onUpdate!.name}',
                        serverpodProtocolUrl(serverCode))
                    : literalNull,
                'onDelete': foreignKey.onDelete != null
                    ? refer('ForeignKeyAction.${foreignKey.onDelete!.name}',
                        serverpodProtocolUrl(serverCode))
                    : literalNull,
                'matchType': foreignKey.matchType != null
                    ? refer('ForeignKeyMatchType.${foreignKey.matchType!.name}',
                        serverpodProtocolUrl(serverCode))
                    : literalNull,
              }),
          ]),
          'indexes': literalList([
            for (var index in table.indexes)
              refer('IndexDefinition', serverpodProtocolUrl(serverCode))
                  .call([], {
                'indexName': literalString(index.indexName),
                'tableSpace': literalNull,
                'elements': literalList([
                  for (var element in index.elements)
                    refer('IndexElementDefinition',
                            serverpodProtocolUrl(serverCode))
                        .call([], {
                      'type': refer(
                          'IndexElementDefinitionType.${element.type.name}',
                          serverpodProtocolUrl(serverCode)),
                      'definition': literalString(element.definition),
                    })
                ]),
                'type': literalString(index.type),
                'isUnique': literalBool(index.isUnique),
                'isPrimary': literalBool(index.isPrimary),
                if (index.vectorDistanceFunction != null)
                  'vectorDistanceFunction': refer(
                      'VectorDistanceFunction.${index.vectorDistanceFunction!.name}',
                      serverpodProtocolUrl(serverCode)),
                if (index.vectorColumnType != null)
                  'vectorColumnType': refer(
                      'ColumnType.${index.vectorColumnType!.name}',
                      serverpodProtocolUrl(serverCode)),
                if (index.parameters != null)
                  'parameters': literalMap(index.parameters!),
              }),
          ]),
          'managed': literalBool(table.isManaged),
        }),
      ...additionalTables,
    ]).code;
  }
}

/// Sorts child classes before their parents, such that serialization order is stable.
int _byChildClassesBeforeParents(
  SerializableModelDefinition a,
  SerializableModelDefinition b,
) {
  if (a is! ModelClassDefinition || b is! ModelClassDefinition) {
    return 0;
  }

  if (a.extendsClass != null && b.extendsClass == null) {
    return -1;
  }

  if (a.extendsClass == null && b.extendsClass != null) {
    return 1;
  }

  if (a.extendsClass is ResolvedInheritanceDefinition &&
      (a.extendsClass as ResolvedInheritanceDefinition).classDefinition == b) {
    return -1;
  }

  if (b.extendsClass is ResolvedInheritanceDefinition &&
      (b.extendsClass as ResolvedInheritanceDefinition).classDefinition == a) {
    return 1;
  }

  return 0;
}
