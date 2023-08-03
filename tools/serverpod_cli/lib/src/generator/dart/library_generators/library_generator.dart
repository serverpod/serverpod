import 'package:code_builder/code_builder.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_cli/src/generator/shared.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

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

    library.name = 'protocol';

    var entities = protocolDefinition.entities
        .where((entity) => serverCode || !entity.serverOnly)
        .toList();

    // exports
    library.directives.addAll([
      for (var classInfo in entities) Directive.export(classInfo.fileRef()),
      if (!serverCode) Directive.export('client.dart'),
    ]);

    var protocol = ClassBuilder();

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

    protocol.fields.addAll([
      Field((f) => f
        ..name = 'customConstructors'
        ..static = true
        ..type = TypeReference((t) => t
          ..symbol = 'Map'
          ..types.addAll([
            refer('Type'),
            refer('constructor', serverpodUrl(serverCode)),
          ]))
        ..modifier = FieldModifier.final$
        ..assignment = literalMap({}).code),
      Field((f) => f
        ..name = '_instance'
        ..static = true
        ..type = refer('Protocol')
        ..modifier = FieldModifier.final$
        ..assignment = const Code('Protocol._()')),
      if (serverCode)
        Field(
          (f) => f
            ..name = 'targetDatabaseDefinition'
            ..static = true
            ..modifier = FieldModifier.final$
            ..assignment =
                createDatabaseDefinitionFromEntities(entities).toCode(
              config: config,
              serverCode: serverCode,
              additionalTables: [
                for (var module in config.modules)
                  refer('Protocol.targetDatabaseDefinition.tables',
                          module.dartImportUrl(serverCode))
                      .spread,
                if (config.name != 'serverpod' &&
                    config.type != PackageType.module)
                  refer('Protocol.targetDatabaseDefinition.tables',
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
          const Code(
              'if(customConstructors.containsKey(t)){return customConstructors[t]!(data, this) as T;}'),
          ...(<Expression, Code>{
            for (var classInfo in entities)
              refer(classInfo.className, classInfo.fileRef()): Code.scope(
                  (a) => '${a(refer(classInfo.className, classInfo.fileRef()))}'
                      '.fromJson(data'
                      '${classInfo is ClassDefinition ? ',this' : ''}) as T'),
            for (var classInfo in entities)
              refer('getType', serverpodUrl(serverCode)).call([], {}, [
                TypeReference(
                  (b) => b
                    ..symbol = classInfo.className
                    ..url = classInfo.fileRef()
                    ..isNullable = true,
                )
              ]): Code.scope((a) => '(data!=null?'
                  '${a(refer(classInfo.className, classInfo.fileRef()))}'
                  '.fromJson(data'
                  '${classInfo is ClassDefinition ? ',this' : ''})'
                  ':null)as T'),
          }..addEntries([
                  for (var classInfo in entities)
                    if (classInfo is ClassDefinition)
                      for (var field in classInfo.fields)
                        ...field.type.generateDeserialization(serverCode,
                            config: config),
                  for (var endPoint in protocolDefinition.endpoints)
                    for (var method in endPoint.methods) ...[
                      ...method.returnType
                          .stripFuture()
                          .generateDeserialization(serverCode, config: config),
                      for (var parameter in method.parameters)
                        ...parameter.type.generateDeserialization(serverCode,
                            config: config),
                      for (var parameter in method.parametersPositional)
                        ...parameter.type.generateDeserialization(serverCode,
                            config: config),
                      for (var parameter in method.parametersNamed)
                        ...parameter.type.generateDeserialization(serverCode,
                            config: config),
                    ],
                  for (var extraClass in config.extraClasses)
                    ...extraClass.generateDeserialization(serverCode,
                        config: config),
                  for (var extraClass in config.extraClasses)
                    ...extraClass.asNullable
                        .generateDeserialization(serverCode, config: config)
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
                'try{return ${a(refer('Protocol', module.dartImportUrl(serverCode)))}().deserialize<T>(data,t);}catch(_){}'),
          if (config.name != 'serverpod' &&
              (serverCode || config.dartClientDependsOnServiceClient))
            Code.scope((a) =>
                'try{return ${a(refer('Protocol', serverCode ? 'package:serverpod/protocol.dart' : 'package:serverpod_service_client/serverpod_service_client.dart'))}().deserialize<T>(data,t);}catch(_){}'),
          const Code('return super.deserialize<T>(data,t);'),
        ])),
      Method((m) => m
        ..annotations.add(refer('override'))
        ..name = 'getClassNameForObject'
        ..returns = refer('String?')
        ..requiredParameters.add(Parameter((p) => p
          ..name = 'data'
          ..type = refer('Object')))
        ..body = Block.of([
          if (config.modules.isNotEmpty) const Code('String? className;'),
          for (var module in config.modules)
            Block.of([
              Code.scope((a) =>
                  'className = ${a(refer('Protocol', module.dartImportUrl(serverCode)))}().getClassNameForObject(data);'),
              Code(
                  'if(className != null){return \'${module.name}.\$className\';}'),
            ]),
          for (var extraClass in config.extraClasses)
            Code.scope((a) =>
                'if(data is ${a(extraClass.reference(serverCode, config: config))}) {return \'${extraClass.className}\';}'),
          for (var classInfo in entities)
            Code.scope((a) =>
                'if(data is ${a(refer(classInfo.className, classInfo.fileRef()))}) {return \'${classInfo.className}\';}'),
          const Code('return super.getClassNameForObject(data);'),
        ])),
      Method((m) => m
        ..annotations.add(refer('override'))
        ..name = 'deserializeByClassName'
        ..returns = refer('dynamic')
        ..requiredParameters.add(Parameter((p) => p
          ..name = 'data'
          ..type = refer('Map<String,dynamic>')))
        ..body = Block.of([
          for (var module in config.modules)
            Block.of([
              Code('if(data[\'className\'].startsWith(\'${module.name}.\')){'
                  'data[\'className\'] = data[\'className\'].substring(${module.name.length + 1});'),
              Code.scope((a) =>
                  'return ${a(refer('Protocol', module.dartImportUrl(serverCode)))}().deserializeByClassName(data);'),
              const Code('}'),
            ]),
          for (var extraClass in config.extraClasses)
            Code.scope((a) =>
                'if(data[\'className\'] == \'${extraClass.className}\'){'
                'return deserialize<${a(extraClass.reference(serverCode, config: config))}>(data[\'data\']);}'),
          for (var classInfo in entities)
            Code.scope((a) =>
                'if(data[\'className\'] == \'${classInfo.className}\'){'
                'return deserialize<${a(refer(classInfo.className, classInfo.fileRef()))}>(data[\'data\']);}'),
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
              if (entities.any((classInfo) =>
                  classInfo is ClassDefinition && classInfo.tableName != null))
                Block.of([
                  const Code('switch(t){'),
                  for (var classInfo in entities)
                    if (classInfo is ClassDefinition &&
                        classInfo.tableName != null)
                      Code.scope((a) =>
                          'case ${a(refer(classInfo.className, classInfo.fileRef()))}:'
                          'return ${a(refer(classInfo.className, classInfo.fileRef()))}.t;'),
                  const Code('}'),
                ]),
              const Code('return null;'),
            ]),
        ),
      if (serverCode)
        Method(
          (m) => m
            ..name = 'getTargetDatabaseDefinition'
            ..annotations.add(refer('override'))
            ..returns = TypeReference((t) => t
              ..symbol = 'DatabaseDefinition'
              ..url = serverpodProtocolUrl(serverCode))
            ..body = refer('targetDatabaseDefinition').code,
        ),
    ]);

    library.body.add(protocol.build());

    return library.build();
  }

  /// Generates the EndpointDispatch for the server side.
  /// Executing this only makes sens for the server code
  /// (if [serverCode] is `true`).
  Library generateServerEndpointDispatch() {
    var library = LibraryBuilder();

    /// Get the path to a endpoint.
    String endpointPath(EndpointDefinition endpoint) {
      return p.posix.joinAll([
        '..',
        'endpoints',
        ...endpoint.subDirParts,
        p.basename(endpoint.filePath),
      ]);
    }

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
                  // Endpoints lookup map
                  refer('var endpoints')
                      .assign(literalMap({
                        for (var endpoint in protocolDefinition.endpoints)
                          endpoint.name:
                              refer(endpoint.className, endpointPath(endpoint))
                                  .call([])
                                  .cascade('initialize')
                                  .call([
                                    refer('server'),
                                    literalString(endpoint.name),
                                    config.type != PackageType.module
                                        ? refer('null')
                                        : literalString(config.name)
                                  ])
                      }, refer('String'),
                          refer('Endpoint', serverpodUrl(true))))
                      .statement,
                  // Connectors
                  for (var endpoint in protocolDefinition.endpoints)
                    refer('connectors')
                        .index(literalString(endpoint.name))
                        .assign(refer('EndpointConnector', serverpodUrl(true))
                            .call([], {
                          'name': literalString(endpoint.name),
                          'endpoint': refer('endpoints')
                              .index(literalString(endpoint.name))
                              .nullChecked,
                          'methodConnectors': literalMap({
                            for (var method in endpoint.methods)
                              literalString(method.name):
                                  refer('MethodConnector', serverpodUrl(true))
                                      .call([], {
                                'name': literalString(method.name),
                                'params': literalMap({
                                  for (var param in [
                                    ...method.parameters,
                                    ...method.parametersPositional,
                                    ...method.parametersNamed,
                                  ])
                                    literalString(param.name): refer(
                                            'ParameterDescription',
                                            serverpodUrl(true))
                                        .call([], {
                                      'name': literalString(param.name),
                                      'type':
                                          refer('getType', serverpodUrl(true))
                                              .call([], {}, [
                                        param.type
                                            .reference(true, config: config)
                                      ]),
                                      'nullable':
                                          literalBool(param.type.nullable),
                                    })
                                }),
                                'call': Method(
                                  (m) => m
                                    ..requiredParameters.addAll([
                                      Parameter((p) => p
                                        ..name = 'session'
                                        ..type = refer(
                                            'Session', serverpodUrl(true))),
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
                                        .asA(refer(endpoint.className,
                                            endpointPath(endpoint)))
                                        .property(method.name)
                                        .call([
                                      refer('session'),
                                      for (var param in [
                                        ...method.parameters,
                                        ...method.parametersPositional
                                      ])
                                        refer('params')
                                            .index(literalString(param.name)),
                                    ], {
                                      for (var param in [
                                        ...method.parametersNamed
                                      ])
                                        param.name: refer('params')
                                            .index(literalString(param.name)),
                                    }).code,
                                ).closure,
                              }),
                          })
                        }))
                        .statement,
                  // Hook up modules
                  for (var module in config.modules)
                    refer('modules')
                        .index(literalString(module.name))
                        .assign(refer('Endpoints',
                                'package:${module.serverPackage}/module.dart')
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
              ? refer('ServerpodClient', serverpodUrl(false))
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
                ..type = refer('_Modules')),
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
                      .assign(refer(getEndpointClassName(endpointDef.name))
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
}

extension on DatabaseDefinition {
  Code toCode({
    required List<Expression> additionalTables,
    required bool serverCode,
    required GeneratorConfig config,
  }) {
    return refer('DatabaseDefinition', serverpodProtocolUrl(serverCode))
        .call([], {
      if (name != null) 'name': literalString(name!),
      'tables': literalList([
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
                }),
            ]),
            'foreignKeys': literalList([
              for (var foreignKey in table.foreignKeys)
                refer('ForeignKeyDefinition', serverpodProtocolUrl(serverCode))
                    .call([], {
                  'constraintName': literalString(foreignKey.constraintName),
                  'columns': literalList([
                    for (var column in foreignKey.columns)
                      literalString(column),
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
                      ? refer(
                          'ForeignKeyMatchType.${foreignKey.matchType!.name}',
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
                }),
            ]),
            if (table.managed != null) 'managed': literalBool(table.managed!),
          }),
        ...additionalTables,
      ])
    }).code;
  }
}
