//import 'package:recase/recase.dart';

import 'package:code_builder/code_builder.dart';

import 'class_generator.dart';
import 'config.dart';
import 'protocol_definition.dart';
import 'types.dart';

class ClassGeneratorDart extends ClassGenerator {
  @override
  String get outputExtension => '.dart';

  ClassGeneratorDart({
    required super.outputDirectoryPath,
    required super.verbose,
    required super.serverCode,
    required super.classDefinitions,
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
          classBuilder.name = className;

          // add className getter
          classBuilder.methods.add(Method(
            (m) => m
              ..name = 'className'
              ..annotations.add(refer('override'))
              ..type = MethodType.getter
              ..returns = refer('String')
              ..lambda = true
              ..body = Code('\'$classPrefix$className\''),
          ));

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
            classBuilder.extend = refer('SerializableEntity',
                'package:serverpod_serialization/serverpod_serialization.dart');
          }

          // Fields
          for (var field in fields) {
            if (field.shouldIncludeField(serverCode) &&
                !(field.name == 'id' && serverCode && tableName != null)) {
              classBuilder.fields.add(Field((f) {
                f.type = field.type.reference(serverCode);
                f.name = field.name;
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
                p.type = refer('SerializationManager',
                    'package:serverpod_serialization/serverpod_serialization.dart');
              }),
            ]);
            c.body = refer(className)
                .call([], {
                  for (var field in fields)
                    if (field.shouldIncludeField(serverCode))
                      field.name: refer('serializationManager')
                          .property('deserializeJson')
                          .call([
                        refer('jsonSerialization')
                            .index(literalString(field.name))
                      ], {}, [
                        field.type.reference(serverCode)
                      ])
                })
                .returned
                .statement;
            // m.body = Block((b) {
            //   for (var field in fields) {
            //     if (field.shouldIncludeField(serverCode)) {
            //       b.addExpression(refer(field.name).assign(
            //           refer('serializationManager')
            //               .property('deserializeJson')
            //               .call([
            //         refer('jsonSerialization').index(refer(field.name))
            //       ], {}, [
            //         field.type.reference(serverCode)
            //       ])));
            //     }
            //   }
            // });
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
                //  refer('String'), refer('dynamic')
              ).returned.statement;
            },
          ));

          // Serialization for database and everything
          if (serverCode) {
            if (tableName != null) {
              classBuilder.methods.add(Method(
                (m) {
                  m.returns = refer('Map<String,dynamic>');
                  m.name = 'toJsonForDatabase';
                  m.annotations.add(refer('override'));

                  m.body = literalMap(
                    {
                      for (var field in fields)
                        if (field.shouldSerializeFieldForDatabase(serverCode))
                          literalString(field.name): refer(field.name)
                    },
                    // refer('String'), refer('dynamic')
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

              //find
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

              //find single row
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

              //findById
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

              //delete
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

              //deleteRow
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

              //update
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

              //insert
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
              f.returnType =
                  refer('Expression', 'package:serverpod/serverpod.dart');
              f.requiredParameters.add(refer('${className}Table'));
            },
          ).toTypeDef('${className}ExpressionBuilder'));

          // Table class definition
          library.body.add(Class((c) {
            c.name = '${className}Table';
            c.extend = refer('Table', 'package:serverpod/serverpod.dart');
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
                  ..assignment = refer(field.type.columnType,
                          'package:serverpod/serverpod.dart')
                      .call([literalString(field.name)]).code));
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
          e.mixins.add(refer('SerializableEntity',
              'package:serverpod_serialization/serverpod_serialization.dart'));
          e.values.addAll([
            for (var value in enumDefinition.values)
              EnumValue((v) {
                v.name = value;
              })
          ]);
          e.methods.add(Method(
            (m) => m
              ..name = 'className'
              ..annotations.add(refer('override'))
              ..type = MethodType.getter
              ..returns = refer('String')
              ..lambda = true
              ..body = literalString(enumName).code,
          ));

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
                      Code('case $i: return ${enumDefinition.values[i]};'),
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
  Library generateFactory(List<ProtocolFileDefinition> classInfos) {
    var library = LibraryBuilder();

    var serverpodUrl = serverCode
        ? 'package:serverpod/serverpod.dart'
        : 'package:serverpod_client/serverpod_client.dart';

    library.name = 'protocol';

    // exports
    library.directives.addAll([
      for (var classInfo in classInfos)
        Directive.export('${classInfo.fileName}.dart')
    ]);
    if (!serverCode) {
      Directive.export('client.dart');
    }

    var protocol = ClassBuilder();

    protocol
      ..name = 'Protocol'
      ..extend = serverCode
          ? refer(
              'SerializationManagerServer', 'package:serverpod/serverpod.dart')
          : refer('SerializationManager',
              'package:serverpod_client/serverpod_client.dart');

    protocol.fields.add(Field(
      (f) => f
        ..static = true
        ..modifier = FieldModifier.final$
        ..type = refer('Protocol')
        ..name = 'instance'
        ..assignment = refer('Protocol').newInstance([]).code,
    ));

    protocol.fields.addAll([
      Field(
        (f) => f
          ..annotations.add(refer('override'))
          ..modifier = FieldModifier.final$
          ..type = TypeReference((t) => t
            ..symbol = 'Map'
            ..types.addAll([
              refer('Type'),
              refer('constructor', serverpodUrl),
            ]))
          ..name = 'constructors'
          ..assignment = literalMap({
            //TODO: Add types from endpoints
            for (var classInfo in classInfos)
              refer(classInfo.className, '${classInfo.fileName}.dart'): Code.scope((a) =>
                  '(jsonSerialization,${a(refer('SerializationManager', serverpodUrl))}'
                  ' serializationManager)=>'
                  '${a(refer(classInfo.className, '${classInfo.fileName}.dart'))}'
                  '.fromJson(jsonSerialization'
                  '${classInfo is ClassDefinition ? ',serializationManager' : ''})'),
            for (var classInfo in classInfos)
              refer('getType', serverpodUrl).call([], {}, [
                TypeReference(
                  (b) => b
                    ..symbol = classInfo.className
                    ..url = '${classInfo.fileName}.dart'
                    ..isNullable = true,
                )
              ]).code: Code.scope((a) =>
                  '(jsonSerialization,${a(refer('SerializationManager', serverpodUrl))}'
                  ' serializationManager)=>'
                  'jsonSerialization!=null?'
                  '${a(refer(classInfo.className, '${classInfo.fileName}.dart'))}'
                  '.fromJson(jsonSerialization'
                  '${classInfo is ClassDefinition ? ',serializationManager' : ''})'
                  ':null'),
          }).code,
      ),
      Field(
        (f) => f
          ..annotations.add(refer('override'))
          ..modifier = FieldModifier.final$
          ..type = TypeReference((t) => t
            ..symbol = 'Map'
            ..types.addAll([
              refer('String'),
              refer('Type'),
            ]))
          ..name = 'classNameTypeMapping'
          ..assignment = literalMap({}).code,
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
  final TypeDefinition type;

  final FieldScope scope;
  final String? parentTable;

  const FieldDefinition(
      {required this.name,
      required this.type,
      required this.scope,
      this.parentTable});

  // FieldDefinition(this.name, String description) {
  //   var genericsStartCounter = 0;
  //   var componentStart = 0;
  //   var components = <String>[];
  //   for (var i = 0; i < description.length; i++) {
  //     var char = description[i];
  //     switch(char){
  //       case '<':
  //         genericsStartCounter++;
  //         break;
  //       case '>':
  //         genericsStartCounter--;
  //         break;
  //       case ',':
  //         if(genericsStartCounter ==0){
  //           components.add(description.substring(componentStart, i+1).trim());
  //           componentStart = i+1;
  //         }
  //         break;
  //     }
  //   }

  //   var typeStr = components[0];

  //   if (components.length >= 2) {
  //     _parseOptions(components.sublist(1));
  //   }

  //   // TODO: Fix package?
  //   type = TypeDefinition(typeStr, null, null);
  // }

  // void _parseOptions(List<String> options) {
  //   for (var option in options) {
  //     if (option == 'database') {
  //       scope = FieldScope.database;
  //     } else if (option == 'api') {
  //       scope = FieldScope.api;
  //     } else if (option.startsWith('parent')) {
  //       var components = option.split('=').map((s) => s.trim()).toList();
  //       if (components.length == 2 && components[0] == 'parent') {
  //         parentTable = components[1];
  //       }
  //     }
  //   }
  // }

  // String get serialization {
  //   if (type.isTypedList) {
  //     if (type.listType!.typeNonNullable == 'String' ||
  //         type.listType!.typeNonNullable == 'int' ||
  //         type.listType!.typeNonNullable == 'double' ||
  //         type.listType!.typeNonNullable == 'bool') {
  //       return name;
  //     } else if (type.listType!.typeNonNullable == 'DateTime') {
  //       if (type.listType!.nullable) {
  //         return '$name${type.nullable ? '?' : ''}.map<String?>((a) => a?.toIso8601String()).toList()';
  //       } else {
  //         return '$name${type.nullable ? '?' : ''}.map<String>((a) => a.toIso8601String()).toList()';
  //       }
  //     } else if (type.listType!.typeNonNullable == 'ByteData') {
  //       if (type.listType!.nullable) {
  //         return '$name${type.nullable ? '?' : ''}.map<String?>((a) => a?.base64encodedString()).toList()';
  //       } else {
  //         return '$name${type.nullable ? '?' : ''}.map<String>((a) => a.base64encodedString()).toList()';
  //       }
  //     } else {
  //       return '$name${type.nullable ? '?' : ''}.map((${type.listType!.type} a) => a${type.listType!.nullable ? '?' : ''}.serialize()).toList()';
  //     }
  //   }

  //   if (type.isTypedMap) {
  //     if (type.mapType!.typeNonNullable == 'String' ||
  //         type.mapType!.typeNonNullable == 'int' ||
  //         type.mapType!.typeNonNullable == 'double' ||
  //         type.mapType!.typeNonNullable == 'bool') {
  //       return name;
  //     } else if (type.mapType!.typeNonNullable == 'DateTime') {
  //       if (type.mapType!.nullable) {
  //         return '$name${type.nullable ? '?' : ''}.map<String,String?>((key, value) => MapEntry(key, value?.toIso8601String()))';
  //       } else {
  //         return '$name${type.nullable ? '?' : ''}.map<String,String?>((key, value) => MapEntry(key, value.toIso8601String()))';
  //       }
  //     } else if (type.mapType!.typeNonNullable == 'ByteData') {
  //       if (type.mapType!.nullable) {
  //         return '$name${type.nullable ? '?' : ''}.map<String,String?>((key, value) => MapEntry(key, value?.base64encodedString()))';
  //       } else {
  //         return '$name${type.nullable ? '?' : ''}.map<String,String>((key, value) => MapEntry(key, value.base64encodedString()))';
  //       }
  //     } else {
  //       return '$name${type.nullable ? '?' : ''}.map<String, Map<String, dynamic>${type.mapType!.nullable ? '?' : ''}>((String key, ${type.mapType!.type} value) => MapEntry(key, value${type.mapType!.nullable ? '?' : ''}.serialize()))';
  //     }
  //   }

  //   if (type.typeNonNullable == 'String' ||
  //       type.typeNonNullable == 'int' ||
  //       type.typeNonNullable == 'double' ||
  //       type.typeNonNullable == 'bool') {
  //     return name;
  //   } else if (type.typeNonNullable == 'DateTime') {
  //     return '$name${type.nullable ? '?' : ''}.toUtc().toIso8601String()';
  //   } else if (type.typeNonNullable == 'ByteData') {
  //     return '$name${type.nullable ? '?' : ''}.base64encodedString()';
  //   } else {
  //     return '$name${type.nullable ? '?' : ''}.serialize()';
  //   }
  // }

  // @deprecated
  // String get deserialization {
  //   if (type.isTypedList) {
  //     if (type.listType!.typeNonNullable == 'String' ||
  //         type.listType!.typeNonNullable == 'int' ||
  //         type.listType!.typeNonNullable == 'double' ||
  //         type.listType!.typeNonNullable == 'bool') {
  //       return '_data[\'$name\']${type.nullable ? '?' : '!'}.cast<${type.listType!.type}>()';
  //     } else if (type.listType!.typeNonNullable == 'DateTime') {
  //       if (type.listType!.nullable) {
  //         return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<DateTime?>((a) => a != null ? DateTime.tryParse(a) : null).toList()';
  //       } else {
  //         return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<DateTime>((a) => DateTime.tryParse(a)!).toList()';
  //       }
  //     } else if (type.listType!.typeNonNullable == 'ByteData') {
  //       if (type.listType!.nullable) {
  //         return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<ByteData?>((a) => (a as String?)?.base64DecodedByteData()).toList()';
  //       } else {
  //         return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<ByteData>((a) => (a as String).base64DecodedByteData()!).toList()';
  //       }
  //     } else {
  //       if (type.listType!.nullable) {
  //         return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<${type.listType!.type}>((a) => a != null ? ${type.listType!.type}.fromSerialization(a) : null)?.toList()';
  //       } else {
  //         return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<${type.listType!.type}>((a) => ${type.listType!.type}.fromSerialization(a))?.toList()';
  //       }
  //     }
  //   }

  //   if (type.isTypedMap) {
  //     if (type.mapType!.typeNonNullable == 'String' ||
  //         type.mapType!.typeNonNullable == 'int' ||
  //         type.mapType!.typeNonNullable == 'double' ||
  //         type.mapType!.typeNonNullable == 'bool') {
  //       return '_data[\'$name\']${type.nullable ? '?' : '!'}.cast<String, ${type.mapType!.type}>()';
  //     } else if (type.mapType!.typeNonNullable == 'DateTime') {
  //       if (type.mapType!.nullable) {
  //         return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<String, DateTime?>((String key, dynamic value) => MapEntry(key, value == null ? null : DateTime.tryParse(value as String)))';
  //       } else {
  //         return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<String, DateTime>((String key, dynamic value) => MapEntry(key, DateTime.tryParse(value as String)!))';
  //       }
  //     } else if (type.mapType!.typeNonNullable == 'ByteData') {
  //       if (type.mapType!.nullable) {
  //         return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<String, ByteData?>((String key, dynamic value) => MapEntry(key, (value as String?)?.base64DecodedByteData()))';
  //       } else {
  //         return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<String, ByteData>((String key, dynamic value) => MapEntry(key, (value as String).base64DecodedByteData()!))';
  //       }
  //     } else {
  //       if (type.mapType!.nullable) {
  //         return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<String, ${type.mapType!.type}>((String key, dynamic value) => MapEntry(key, value != null ? ${type.mapType!.type}.fromSerialization(value) : null))';
  //       } else {
  //         return '_data[\'$name\']${type.nullable ? '?' : '!'}.map<String, ${type.mapType!.type}>((String key, dynamic value) => MapEntry(key, ${type.mapType!.type}.fromSerialization(value)))';
  //       }
  //     }
  //   }

  //   if (type.typeNonNullable == 'String' ||
  //       type.typeNonNullable == 'int' ||
  //       type.typeNonNullable == 'double' ||
  //       type.typeNonNullable == 'bool') {
  //     return '_data[\'$name\']${type.nullable ? '' : '!'}';
  //   } else if (type.typeNonNullable == 'DateTime') {
  //     if (type.nullable) {
  //       return '_data[\'$name\'] != null ? DateTime.tryParse(_data[\'$name\']) : null';
  //     } else {
  //       return 'DateTime.tryParse(_data[\'$name\'])!';
  //     }
  //   } else if (type.typeNonNullable == 'ByteData') {
  //     if (type.nullable) {
  //       return '_data[\'$name\'] == null ? null : (_data[\'$name\'] is String ? (_data[\'$name\'] as String).base64DecodedByteData() : ByteData.view((_data[\'$name\'] as Uint8List).buffer))';
  //     } else {
  //       return '_data[\'$name\'] is String ? (_data[\'$name\'] as String).base64DecodedByteData()! : ByteData.view((_data[\'$name\'] as Uint8List).buffer)';
  //     }
  //   } else {
  //     if (type.nullable) {
  //       return '_data[\'$name\'] != null ? $type.fromSerialization(_data[\'$name\']) : null';
  //     } else {
  //       return '$type.fromSerialization(_data[\'$name\'])';
  //     }
  //   }
  // }

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
