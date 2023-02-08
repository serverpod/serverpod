import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';

import 'class_generator.dart';
import 'config.dart';
import 'protocol_definition.dart';
import 'types.dart';

String serverpodUrl(bool serverCode) {
  return serverCode
      ? 'package:serverpod/serverpod.dart'
      : 'package:serverpod_client/serverpod_client.dart';
}

class ClassGeneratorDart extends ClassGenerator {
  @override
  String get outputExtension => '.dart';

  ClassGeneratorDart({
    required super.outputDirectoryPath,
    required super.verbose,
    required super.serverCode,
    required super.classDefinitions,
    required super.protocolDefinition,
  });

  @override
  Library generateFile(ProtocolFileDefinition protocolFileDefinition) {
    if (protocolFileDefinition is ClassDefinition) {
      return _generateClassFile(protocolFileDefinition);
    }
    if (protocolFileDefinition is EnumDefinition) {
      return _generateEnumFile(protocolFileDefinition);
    }

    throw Exception('Unsupported protocol file type.');
  }

  // Handle ordinary classes
  Library _generateClassFile(ClassDefinition classDefinition) {
    String? tableName = classDefinition.tableName;
    var className = classDefinition.className;
    var fields = classDefinition.fields;

    var library = Library(
      (library) {
        library.body.add(Class((classBuilder) {
          classBuilder
            ..name = className
            ..docs.addAll(classDefinition.documentation ?? []);
          if (classDefinition.isException) {
            classBuilder.implements = ListBuilder(
                [refer('SerializableException', serverpodUrl(serverCode))]);
          }

          if (serverCode && tableName != null) {
            classBuilder.extend =
                refer('TableRow', 'package:serverpod/serverpod.dart');

            classBuilder.fields.add(Field((f) => f
              ..static = true
              ..modifier = FieldModifier.final$
              ..name = 't'
              ..assignment = refer('${className}Table').call([]).code));

            // add tableName getter
            classBuilder.methods.add(Method(
              (m) => m
                ..name = 'tableName'
                ..annotations.add(refer('override'))
                ..type = MethodType.getter
                ..returns = refer('String')
                ..lambda = true
                ..body = Code('\'$tableName\''),
            ));
          } else {
            classBuilder.extend =
                refer('SerializableEntity', serverpodUrl(serverCode));
          }

          // Fields
          for (var field in fields) {
            if (field.shouldIncludeField(serverCode) &&
                !(field.name == 'id' && serverCode && tableName != null)) {
              classBuilder.fields.add(Field((f) {
                f.type = field.type.reference(serverCode,
                    subDirectory: classDefinition.subDir);
                f
                  ..name = field.name
                  ..docs.addAll(field.documentation ?? []);
              }));
            }
          }

          // Default constructor
          classBuilder.constructors.add(Constructor((c) {
            for (var field in fields) {
              if (field.shouldIncludeField(serverCode)) {
                if (field.name == 'id' && serverCode && tableName != null) {
                  c.optionalParameters.add(Parameter((p) {
                    p.named = true;
                    p.name = 'id';
                    p.type = TypeReference(
                      (t) => t
                        ..symbol = 'int'
                        ..isNullable = true,
                    );
                  }));
                } else {
                  c.optionalParameters.add(Parameter((p) {
                    p.named = true;
                    p.required = !field.type.nullable;
                    p.toThis = true;
                    p.name = field.name;
                  }));
                }
              }
            }
            if (serverCode && tableName != null) {
              c.initializers.add(refer('super').call([refer('id')]).code);
            }
          }));

          // Deserialization
          classBuilder.constructors.add(Constructor((c) {
            c.factory = true;
            c.name = 'fromJson';
            c.requiredParameters.addAll([
              Parameter((p) {
                p.name = 'jsonSerialization';
                p.type = refer('Map<String,dynamic>');
              }),
              Parameter((p) {
                p.name = 'serializationManager';
                p.type =
                    refer('SerializationManager', serverpodUrl(serverCode));
              }),
            ]);
            c.body = refer(className)
                .call([], {
                  for (var field in fields)
                    if (field.shouldIncludeField(serverCode))
                      field.name: refer('serializationManager')
                          .property('deserialize')
                          .call([
                        refer('jsonSerialization')
                            .index(literalString(field.name))
                      ], {}, [
                        field.type.reference(serverCode,
                            subDirectory: classDefinition.subDir)
                      ])
                })
                .returned
                .statement;
          }));

          // Serialization
          classBuilder.methods.add(Method(
            (m) {
              m.returns = refer('Map<String,dynamic>');
              m.name = 'toJson';
              m.annotations.add(refer('override'));

              m.body = literalMap(
                {
                  for (var field in fields)
                    if (field.shouldSerializeField(serverCode))
                      literalString(field.name): refer(field.name)
                },
              ).returned.statement;
            },
          ));

          // Serialization for database and everything
          if (serverCode) {
            if (tableName != null) {
              classBuilder.methods.add(Method(
                (m) {
                  m.returns = refer('Map<String,dynamic>');
                  //TODO: better name
                  m.name = 'toJsonForDatabase';
                  m.annotations.add(refer('override'));

                  m.body = literalMap(
                    {
                      for (var field in fields)
                        if (field.shouldSerializeFieldForDatabase(serverCode))
                          literalString(field.name): refer(field.name)
                    },
                  ).returned.statement;
                },
              ));
            }

            classBuilder.methods.add(Method(
              (m) {
                m.returns = refer('Map<String,dynamic>');
                m.name = 'allToJson';
                m.annotations.add(refer('override'));

                m.body = literalMap(
                  {
                    for (var field in fields)
                      literalString(field.name): refer(field.name)
                  },
                  //  refer('String'), refer('dynamic')
                ).returned.statement;
              },
            ));

            if (tableName != null) {
              // Column setter
              classBuilder.methods.add(Method((m) => m
                ..annotations.add(refer('override'))
                ..name = 'setColumn'
                ..returns = refer('void')
                ..requiredParameters.addAll([
                  Parameter((p) => p
                    ..name = 'columnName'
                    ..type = refer('String')),
                  Parameter((p) => p..name = 'value'),
                ])
                ..body = Block.of([
                  const Code('switch(columnName){'),
                  for (var field in fields)
                    if (field.shouldSerializeFieldForDatabase(serverCode))
                      Block.of([
                        Code('case \'${field.name}\':'),
                        refer(field.name).assign(refer('value')).statement,
                        refer('').returned.statement,
                      ]),
                  const Code('default:'),
                  refer('UnimplementedError').call([]).thrown.statement,
                  const Code('}'),
                ])));

              // find
              classBuilder.methods.add(Method((m) => m
                ..static = true
                ..name = 'find'
                ..returns = TypeReference(
                  (r) => r
                    ..symbol = 'Future'
                    ..types.add(TypeReference(
                      (r) => r
                        ..symbol = 'List'
                        ..types.add(
                          TypeReference(
                            (r) => r..symbol = className,
                          ),
                        ),
                    )),
                )
                ..requiredParameters.addAll([
                  Parameter((p) => p
                    ..type =
                        refer('Session', 'package:serverpod/serverpod.dart')
                    ..name = 'session'),
                ])
                ..optionalParameters.addAll([
                  Parameter((p) => p
                    ..type = TypeReference((b) => b
                      ..isNullable = true
                      ..symbol = '${className}ExpressionBuilder')
                    ..name = 'where'
                    ..named = true),
                  Parameter((p) => p
                    ..type = TypeReference((b) => b
                      ..isNullable = true
                      ..symbol = 'int')
                    ..name = 'limit'
                    ..named = true),
                  Parameter((p) => p
                    ..type = TypeReference((b) => b
                      ..isNullable = true
                      ..symbol = 'int')
                    ..name = 'offset'
                    ..named = true),
                  Parameter((p) => p
                    ..type = TypeReference((b) => b
                      ..isNullable = true
                      ..symbol = 'Column'
                      ..url = 'package:serverpod/serverpod.dart')
                    ..name = 'orderBy'
                    ..named = true),
                  Parameter((p) => p
                    ..type = TypeReference((t) => t
                      ..symbol = 'List'
                      ..isNullable = true
                      ..types.add(
                          refer('Order', 'package:serverpod/serverpod.dart')))
                    ..name = 'orderByList'
                    ..named = true),
                  Parameter((p) => p
                    ..type = refer('bool')
                    ..name = 'orderDescending'
                    ..defaultTo = const Code('false')
                    ..named = true),
                  Parameter((p) => p
                    ..type = refer('bool')
                    ..name = 'useCache'
                    ..defaultTo = const Code('true')
                    ..named = true),
                  Parameter((p) => p
                    ..type = TypeReference((b) => b
                      ..isNullable = true
                      ..symbol = 'Transaction'
                      ..url = 'package:serverpod/serverpod.dart')
                    ..name = 'transaction'
                    ..named = true),
                ])
                ..modifier = MethodModifier.async
                ..body = refer('session')
                    .property('db')
                    .property('find')
                    .call([], {
                      'where': refer('where')
                          .notEqualTo(refer('null'))
                          .conditional(
                              refer('where')
                                  .call([refer(className).property('t')]),
                              refer('null')),
                      'limit': refer('limit'),
                      'offset': refer('offset'),
                      'orderBy': refer('orderBy'),
                      'orderByList': refer('orderByList'),
                      'orderDescending': refer('orderDescending'),
                      'useCache': refer('useCache'),
                      'transaction': refer('transaction'),
                    }, [
                      refer(className)
                    ])
                    .returned
                    .statement));

              // find single row
              classBuilder.methods.add(Method((m) => m
                ..static = true
                ..name = 'findSingleRow'
                ..returns = TypeReference(
                  (r) => r
                    ..symbol = 'Future'
                    ..types.add(TypeReference(
                      (r) => r
                        ..symbol = className
                        ..isNullable = true,
                    )),
                )
                ..requiredParameters.addAll([
                  Parameter((p) => p
                    ..type =
                        refer('Session', 'package:serverpod/serverpod.dart')
                    ..name = 'session'),
                ])
                ..optionalParameters.addAll([
                  Parameter((p) => p
                    ..type = TypeReference((b) => b
                      ..isNullable = true
                      ..symbol = '${className}ExpressionBuilder')
                    ..name = 'where'
                    ..named = true),
                  Parameter((p) => p
                    ..type = TypeReference((b) => b
                      ..isNullable = true
                      ..symbol = 'int')
                    ..name = 'offset'
                    ..named = true),
                  Parameter((p) => p
                    ..type = TypeReference((b) => b
                      ..isNullable = true
                      ..symbol = 'Column'
                      ..url = 'package:serverpod/serverpod.dart')
                    ..name = 'orderBy'
                    ..named = true),
                  Parameter((p) => p
                    ..type = refer('bool')
                    ..name = 'orderDescending'
                    ..defaultTo = const Code('false')
                    ..named = true),
                  Parameter((p) => p
                    ..type = refer('bool')
                    ..name = 'useCache'
                    ..defaultTo = const Code('true')
                    ..named = true),
                  Parameter((p) => p
                    ..type = TypeReference((b) => b
                      ..isNullable = true
                      ..symbol = 'Transaction'
                      ..url = 'package:serverpod/serverpod.dart')
                    ..name = 'transaction'
                    ..named = true),
                ])
                ..modifier = MethodModifier.async
                ..body = refer('session')
                    .property('db')
                    .property('findSingleRow')
                    .call([], {
                      'where': refer('where')
                          .notEqualTo(refer('null'))
                          .conditional(
                              refer('where')
                                  .call([refer(className).property('t')]),
                              refer('null')),
                      'offset': refer('offset'),
                      'orderBy': refer('orderBy'),
                      'orderDescending': refer('orderDescending'),
                      'useCache': refer('useCache'),
                      'transaction': refer('transaction'),
                    }, [
                      refer(className)
                    ])
                    .returned
                    .statement));

              // findById
              classBuilder.methods.add(Method((m) => m
                ..static = true
                ..name = 'findById'
                ..returns = TypeReference(
                  (r) => r
                    ..symbol = 'Future'
                    ..types.add(TypeReference(
                      (r) => r
                        ..symbol = className
                        ..isNullable = true,
                    )),
                )
                ..requiredParameters.addAll([
                  Parameter((p) => p
                    ..type =
                        refer('Session', 'package:serverpod/serverpod.dart')
                    ..name = 'session'),
                  Parameter((p) => p
                    ..type = refer('int')
                    ..name = 'id'),
                ])
                ..modifier = MethodModifier.async
                ..body = refer('session')
                    .property('db')
                    .property('findById')
                    .call([refer('id')], {}, [refer(className)])
                    .returned
                    .statement));

              // delete
              classBuilder.methods.add(Method((m) => m
                ..static = true
                ..name = 'delete'
                ..returns = TypeReference(
                  (r) => r
                    ..symbol = 'Future'
                    ..types.add(refer('int')),
                )
                ..requiredParameters.addAll([
                  Parameter((p) => p
                    ..type =
                        refer('Session', 'package:serverpod/serverpod.dart')
                    ..name = 'session'),
                ])
                ..optionalParameters.addAll([
                  Parameter((p) => p
                    ..required = true
                    ..type = refer('${className}ExpressionBuilder')
                    ..name = 'where'
                    ..named = true),
                  Parameter((p) => p
                    ..type = TypeReference((b) => b
                      ..isNullable = true
                      ..symbol = 'Transaction'
                      ..url = 'package:serverpod/serverpod.dart')
                    ..name = 'transaction'
                    ..named = true),
                ])
                ..modifier = MethodModifier.async
                ..body = refer('session')
                    .property('db')
                    .property('delete')
                    .call([], {
                      'where':
                          refer('where').call([refer(className).property('t')]),
                      'transaction': refer('transaction'),
                    }, [
                      refer(className)
                    ])
                    .returned
                    .statement));

              // deleteRow
              classBuilder.methods.add(Method((m) => m
                ..static = true
                ..name = 'deleteRow'
                ..returns = TypeReference(
                  (r) => r
                    ..symbol = 'Future'
                    ..types.add(refer('bool')),
                )
                ..requiredParameters.addAll([
                  Parameter((p) => p
                    ..type =
                        refer('Session', 'package:serverpod/serverpod.dart')
                    ..name = 'session'),
                  Parameter((p) => p
                    ..type = refer(className)
                    ..name = 'row'),
                ])
                ..optionalParameters.addAll([
                  Parameter((p) => p
                    ..type = TypeReference((b) => b
                      ..isNullable = true
                      ..symbol = 'Transaction'
                      ..url = 'package:serverpod/serverpod.dart')
                    ..name = 'transaction'
                    ..named = true),
                ])
                ..modifier = MethodModifier.async
                ..body = refer('session')
                    .property('db')
                    .property('deleteRow')
                    .call([
                      refer('row')
                    ], {
                      'transaction': refer('transaction'),
                    })
                    .returned
                    .statement));

              // update
              classBuilder.methods.add(Method((m) => m
                ..static = true
                ..name = 'update'
                ..returns = TypeReference(
                  (r) => r
                    ..symbol = 'Future'
                    ..types.add(refer('bool')),
                )
                ..requiredParameters.addAll([
                  Parameter((p) => p
                    ..type =
                        refer('Session', 'package:serverpod/serverpod.dart')
                    ..name = 'session'),
                  Parameter((p) => p
                    ..type = refer(className)
                    ..name = 'row'),
                ])
                ..optionalParameters.addAll([
                  Parameter((p) => p
                    ..type = TypeReference((b) => b
                      ..isNullable = true
                      ..symbol = 'Transaction'
                      ..url = 'package:serverpod/serverpod.dart')
                    ..name = 'transaction'
                    ..named = true),
                ])
                ..modifier = MethodModifier.async
                ..body = refer('session')
                    .property('db')
                    .property('update')
                    .call([
                      refer('row')
                    ], {
                      'transaction': refer('transaction'),
                    })
                    .returned
                    .statement));

              // insert
              classBuilder.methods.add(Method((m) => m
                ..static = true
                ..name = 'insert'
                ..returns = TypeReference(
                  (r) => r
                    ..symbol = 'Future'
                    ..types.add(refer('void')),
                )
                ..requiredParameters.addAll([
                  Parameter((p) => p
                    ..type =
                        refer('Session', 'package:serverpod/serverpod.dart')
                    ..name = 'session'),
                  Parameter((p) => p
                    ..type = refer(className)
                    ..name = 'row'),
                ])
                ..optionalParameters.addAll([
                  Parameter((p) => p
                    ..type = TypeReference((b) => b
                      ..isNullable = true
                      ..symbol = 'Transaction'
                      ..url = 'package:serverpod/serverpod.dart')
                    ..name = 'transaction'
                    ..named = true),
                ])
                ..modifier = MethodModifier.async
                ..body = refer('session')
                    .property('db')
                    .property('insert')
                    .call([
                      refer('row')
                    ], {
                      'transaction': refer('transaction'),
                    })
                    .returned
                    .statement));

              //count
              classBuilder.methods.add(Method((m) => m
                ..static = true
                ..name = 'count'
                ..returns = TypeReference(
                  (r) => r
                    ..symbol = 'Future'
                    ..types.add(refer('int')),
                )
                ..requiredParameters.addAll([
                  Parameter((p) => p
                    ..type =
                        refer('Session', 'package:serverpod/serverpod.dart')
                    ..name = 'session'),
                ])
                ..optionalParameters.addAll([
                  Parameter((p) => p
                    ..type = TypeReference((b) => b
                      ..isNullable = true
                      ..symbol = '${className}ExpressionBuilder')
                    ..name = 'where'
                    ..named = true),
                  Parameter((p) => p
                    ..type = TypeReference((b) => b
                      ..isNullable = true
                      ..symbol = 'int')
                    ..name = 'limit'
                    ..named = true),
                  Parameter((p) => p
                    ..type = refer('bool')
                    ..name = 'useCache'
                    ..defaultTo = const Code('true')
                    ..named = true),
                  Parameter((p) => p
                    ..type = TypeReference((b) => b
                      ..isNullable = true
                      ..symbol = 'Transaction'
                      ..url = 'package:serverpod/serverpod.dart')
                    ..name = 'transaction'
                    ..named = true),
                ])
                ..modifier = MethodModifier.async
                ..body = refer('session')
                    .property('db')
                    .property('count')
                    .call([], {
                      'where': refer('where')
                          .notEqualTo(refer('null'))
                          .conditional(
                              refer('where')
                                  .call([refer(className).property('t')]),
                              refer('null')),
                      'limit': refer('limit'),
                      'useCache': refer('useCache'),
                      'transaction': refer('transaction'),
                    }, [
                      refer(className)
                    ])
                    .returned
                    .statement));
            }
          }
        }));

        if (serverCode && tableName != null) {
          // Expression builder
          library.body.add(FunctionType(
            (f) {
              f.returnType = refer('Expression', serverpodUrl(serverCode));
              f.requiredParameters.add(refer('${className}Table'));
            },
          ).toTypeDef('${className}ExpressionBuilder'));

          // Table class definition
          library.body.add(Class((c) {
            c.name = '${className}Table';
            c.extend = refer('Table', serverpodUrl(serverCode));
            c.constructors.add(Constructor((constructor) {
              constructor.initializers.add(refer('super')
                  .call([], {'tableName': literalString(tableName)}).code);
            }));

            // Column descriptions
            for (var field in fields) {
              if (field.shouldSerializeFieldForDatabase(serverCode)) {
                c.fields.add(Field((f) => f
                  ..modifier = FieldModifier.final$
                  ..name = field.name
                  ..docs.addAll(field.documentation ?? [])
                  ..assignment = TypeReference((t) => t
                    ..symbol = field.type.columnType
                    ..url = 'package:serverpod/serverpod.dart'
                    ..types.addAll(field.type.isEnum
                        ? [
                            field.type.reference(
                              serverCode,
                              nullable: false,
                              subDirectory: classDefinition.subDir,
                            )
                          ]
                        : [])).call([literalString(field.name)]).code));
              }
            }

            // List of column values
            c.methods.add(Method(
              (m) => m
                ..annotations.add(refer('override'))
                ..returns = TypeReference((t) => t
                  ..symbol = 'List'
                  ..types
                      .add(refer('Column', 'package:serverpod/serverpod.dart')))
                ..name = 'columns'
                ..lambda = true
                ..type = MethodType.getter
                ..body = literalList([
                  for (var field in fields)
                    if (field.shouldSerializeFieldForDatabase(serverCode))
                      refer(field.name)
                ]).code,
            ));
          }));

          // Create instance of table
          library.body.add(Field((f) => f
            ..annotations.add(refer('Deprecated')
                .call([literalString('Use ${className}Table.t instead.')]))
            ..name = 't$className'
            ..type = refer('${className}Table')
            ..assignment = refer('${className}Table').call([]).code));
        }
      },
    );

    return library;
  }

  // Handle enums.
  Library _generateEnumFile(EnumDefinition enumDefinition) {
    String enumName = enumDefinition.className;

    var library = Library((library) {
      library.body.add(
        Enum((e) {
          e.name = enumName;
          e.docs.addAll(enumDefinition.documentation ?? []);
          e.mixins.add(refer('SerializableEntity', serverpodUrl(serverCode)));
          e.values.addAll([
            for (var value in enumDefinition.values)
              EnumValue((v) {
                v
                  ..name = value.name
                  ..docs.addAll(value.documentation ?? []);
              })
          ]);

          e.methods.add(Method((m) => m
            ..static = true
            ..returns = refer('$enumName?')
            ..name = 'fromJson'
            ..requiredParameters.add(Parameter((p) => p
              ..name = 'index'
              ..type = refer('int')))
            ..body = (BlockBuilder()
                  ..statements.addAll([
                    const Code('switch(index){'),
                    for (int i = 0; i < enumDefinition.values.length; i++)
                      Code('case $i: return ${enumDefinition.values[i].name};'),
                    const Code('default: return null;'),
                    const Code('}'),
                  ]))
                .build()));

          e.methods.add(Method(
            (m) => m
              ..annotations.add(refer('override'))
              ..returns = refer('int')
              ..name = 'toJson'
              ..lambda = true
              ..body = refer('index').code,
          ));
        }),
      );
    });
    return library;
  }

  @override
  Library generateFactory(List<ProtocolFileDefinition> classInfos,
      ProtocolDefinition protocolDefinition) {
    var library = LibraryBuilder();

    library.body.add(const Code('// ignore_for_file: equal_keys_in_map\n'));

    library.name = 'protocol';

    // exports
    library.directives.addAll([
      for (var classInfo in classInfos) Directive.export(classInfo.fileRef()),
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
            for (var classInfo in classInfos)
              refer(classInfo.className, classInfo.fileRef()): Code.scope(
                  (a) => '${a(refer(classInfo.className, classInfo.fileRef()))}'
                      '.fromJson(data'
                      '${classInfo is ClassDefinition ? ',this' : ''}) as T'),
            for (var classInfo in classInfos)
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
                  for (var classInfo in classInfos)
                    if (classInfo is ClassDefinition)
                      for (var field in classInfo.fields)
                        ...field.type.generateDeserialization(serverCode),
                  for (var endPoint in protocolDefinition.endpoints)
                    for (var method in endPoint.methods) ...[
                      ...method.returnType
                          .stripFuture()
                          .generateDeserialization(serverCode),
                      for (var parameter in method.parameters)
                        ...parameter.type.generateDeserialization(serverCode),
                      for (var parameter in method.parametersPositional)
                        ...parameter.type.generateDeserialization(serverCode),
                      for (var parameter in method.parametersNamed)
                        ...parameter.type.generateDeserialization(serverCode),
                    ],
                  for (var extraClass in config.extraClasses)
                    ...extraClass.generateDeserialization(serverCode),
                  for (var extraClass in config.extraClasses)
                    ...extraClass.asNullable.generateDeserialization(serverCode)
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
                'try{return ${a(refer('Protocol', module.url(serverCode)))}().deserialize<T>(data,t);}catch(_){}'),
          if (config.name != 'serverpod' &&
              (serverCode || config.clientDependsOnServiceClient))
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
                  'className = ${a(refer('Protocol', module.url(serverCode)))}().getClassNameForObject(data);'),
              Code(
                  'if(className != null){return \'${module.name}.\$className\';}'),
            ]),
          for (var extraClass in config.extraClasses)
            Code.scope((a) =>
                'if(data is ${a(extraClass.reference(serverCode))}) {return \'${extraClass.className}\';}'),
          for (var classInfo in classInfos)
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
                  'return ${a(refer('Protocol', module.url(serverCode)))}().deserializeByClassName(data);'),
              const Code('}'),
            ]),
          for (var extraClass in config.extraClasses)
            Code.scope((a) =>
                'if(data[\'className\'] == \'${extraClass.className}\'){'
                'return deserialize<${a(extraClass.reference(serverCode))}>(data[\'data\']);}'),
          for (var classInfo in classInfos)
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
                    '{var table = ${a(refer('Protocol', module.url(serverCode)))}().getTableForType(t);'
                    'if(table!=null) {return table;}}'),
              if (config.name != 'serverpod' &&
                  (serverCode || config.clientDependsOnServiceClient))
                Code.scope((a) =>
                    '{var table = ${a(refer('Protocol', serverCode ? 'package:serverpod/protocol.dart' : 'package:serverpod_service_client/serverpod_service_client.dart'))}().getTableForType(t);'
                    'if(table!=null) {return table;}}'),
              if (classInfos.any((classInfo) =>
                  classInfo is ClassDefinition && classInfo.tableName != null))
                Block.of([
                  const Code('switch(t){'),
                  for (var classInfo in classInfos)
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
    ]);

    library.body.add(protocol.build());

    return library.build();
  }

  String get classPrefix {
    if (config.type == PackageType.server) {
      return '';
    } else {
      return '${config.serverPackage}.';
    }
  }
}

enum FieldScope {
  database,
  api,
  all,
}

class FieldDefinition {
  final String name;
  TypeDefinition type;

  final FieldScope scope;
  final String? parentTable;
  final List<String>? documentation;

  FieldDefinition({
    required this.name,
    required this.type,
    required this.scope,
    this.parentTable,
    this.documentation,
  });

  bool shouldIncludeField(bool serverCode) {
    if (serverCode) return true;
    if (scope == FieldScope.all || scope == FieldScope.api) return true;
    return false;
  }

  bool shouldSerializeField(bool serverCode) {
    if (scope == FieldScope.all || scope == FieldScope.api) return true;
    return false;
  }

  bool shouldSerializeFieldForDatabase(bool serverCode) {
    assert(serverCode);
    if (scope == FieldScope.all || scope == FieldScope.database) return true;
    return false;
  }
}
