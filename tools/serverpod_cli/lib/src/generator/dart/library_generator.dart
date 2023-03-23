import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:recase/recase.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:path/path.dart' as p;

import '../config.dart';
import '../../analyzer/dart/definitions.dart';

/// The import url of the main serverpod package.
String serverpodUrl(bool serverCode) {
  return serverCode
      ? 'package:serverpod/serverpod.dart'
      : 'package:serverpod_client/serverpod_client.dart';
}

/// The import url of the serverpod protocol.
String serverpodProtocolUrl(bool serverCode) {
  return serverCode
      ? 'package:serverpod/protocol.dart'
      : 'package:serverpod_client/serverpod_client.dart';
}

/// Generates all dart libraries (basically the content of a standalone dart file).
class LibraryGenerator {
  final bool serverCode;

  final ProtocolDefinition protocolDefinition;
  final GeneratorConfig config;

  LibraryGenerator({
    required this.serverCode,
    required this.protocolDefinition,
    required this.config,
  });

  /// Generate the file for a protocol entity.
  Library generateEntityLibrary(
      ProtocolEntityDefinition protocolFileDefinition) {
    if (protocolFileDefinition is ProtocolClassDefinition) {
      return _generateClassLibrary(protocolFileDefinition);
    }
    if (protocolFileDefinition is ProtocolEnumDefinition) {
      return _generateEnumLibrary(protocolFileDefinition);
    }

    throw Exception('Unsupported protocol file type.');
  }

  /// Handle ordinary classes for [generateEntityLibrary].
  Library _generateClassLibrary(ProtocolClassDefinition classDefinition) {
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
                    subDirectory: classDefinition.subDir, config: config);
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
                            subDirectory: classDefinition.subDir,
                            config: config)
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
                              config: config,
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

  /// Handle enums for [generateEntityLibrary]
  Library _generateEnumLibrary(ProtocolEnumDefinition enumDefinition) {
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

  /// Generate the protocol library.
  Library generateProtocol({
    bool verbose = false,
  }) {
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
                refer('DatabaseDefinition', serverpodProtocolUrl(serverCode))
                    .call([], {
              'tables': literalList([
                for (var classDefinition in entities)
                  if (classDefinition is ProtocolClassDefinition &&
                      classDefinition.tableName != null)
                    refer('TableDefinition', serverpodProtocolUrl(serverCode))
                        .call([], {
                      'name': literalString(classDefinition.tableName!),
                      'schema': literalString('public'),
                      'columns': literalList([
                        for (var column in classDefinition.fields)
                          if (column
                              .shouldSerializeFieldForDatabase(serverCode))
                            refer('ColumnDefinition',
                                    serverpodProtocolUrl(serverCode))
                                .call([], {
                              'name': literalString(column.name),
                              'columnType': refer(
                                  'ColumnType.${column.type.databaseTypeEnum}',
                                  serverpodProtocolUrl(serverCode)),
                              // The id column is not null, since it is auto incrementing.
                              'isNullable': literalBool(
                                  column.name != 'id' && column.type.nullable),
                              'dartType': literalString(column.type.toString()),
                              if (column.name == 'id')
                                'columnDefault': literalString(
                                    "nextval('${classDefinition.tableName!}_id_seq'::regclass)"),
                            }),
                      ]),
                      'foreignKeys': literalList([
                        for (var i = 0;
                            i <
                                classDefinition.fields
                                    .where((field) => field.parentTable != null)
                                    .length;
                            i++)
                          () {
                            var column = classDefinition.fields
                                .where((field) => field.parentTable != null)
                                .toList()[i];
                            return refer('ForeignKeyDefinition',
                                    serverpodProtocolUrl(serverCode))
                                .call([], {
                              'constraintName': literalString(
                                  '${classDefinition.tableName!}_fk_$i'),
                              'columns': literalList([
                                literalString(column.name),
                              ]),
                              'referenceTable':
                                  literalString(column.parentTable!),
                              'referenceTableSchema': literalString('public'),
                              'referenceColumns': literalList([
                                literalString('id'),
                              ]),
                              'onUpdate': literalNull,
                              'onDelete': refer('ForeignKeyAction.cascade',
                                  serverpodProtocolUrl(serverCode)),
                              'matchType': literalNull,
                            });
                          }(),
                      ]),
                      'indexes': literalList([
                        refer('IndexDefinition',
                                serverpodProtocolUrl(serverCode))
                            .call([], {
                          'indexName': literalString(
                              '${classDefinition.tableName!}_pkey'),
                          'tableSpace': literalNull,
                          'elements': literalList([
                            refer('IndexElementDefinition',
                                    serverpodProtocolUrl(serverCode))
                                .call([], {
                              'type': refer('IndexElementDefinitionType.column',
                                  serverpodProtocolUrl(serverCode)),
                              'definition': literalString('id'),
                            }),
                          ]),
                          'type': literalString('btree'),
                          'isUnique': literalTrue,
                          'isPrimary': literalTrue,
                        }),
                        for (var index in classDefinition.indexes ??
                            <ProtocolIndexDefinition>[])
                          refer('IndexDefinition',
                                  serverpodProtocolUrl(serverCode))
                              .call([], {
                            'indexName': literalString(index.name),
                            'tableSpace': literalNull,
                            'elements': literalList([
                              for (var field in index.fields)
                                refer('IndexElementDefinition',
                                        serverpodProtocolUrl(serverCode))
                                    .call([], {
                                  'type': refer(
                                      'IndexElementDefinitionType.column',
                                      serverpodProtocolUrl(serverCode)),
                                  'definition': literalString(field),
                                })
                            ]),
                            'type': literalString(index.type),
                            'isUnique': literalBool(index.unique),
                            'isPrimary': literalFalse,
                          }),
                      ]),
                      'managed':
                          literalTrue, //TODO: Add an option in the yaml-protocol specification for this.
                    }),
                for (var module in config.modules)
                  refer('Protocol.targetDatabaseDefinition.tables',
                          module.dartImportUrl(serverCode))
                      .spread,
                if (config.name != 'serverpod' &&
                    config.type == PackageType.server)
                  refer('Protocol.targetDatabaseDefinition.tables',
                          serverpodProtocolUrl(serverCode))
                      .spread,
              ]),
            }).code,
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
              refer(classInfo.className, classInfo.fileRef()): Code.scope((a) =>
                  '${a(refer(classInfo.className, classInfo.fileRef()))}'
                  '.fromJson(data'
                  '${classInfo is ProtocolClassDefinition ? ',this' : ''}) as T'),
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
                  '${classInfo is ProtocolClassDefinition ? ',this' : ''})'
                  ':null)as T'),
          }..addEntries([
                  for (var classInfo in entities)
                    if (classInfo is ProtocolClassDefinition)
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
                  classInfo is ProtocolClassDefinition &&
                  classInfo.tableName != null))
                Block.of([
                  const Code('switch(t){'),
                  for (var classInfo in entities)
                    if (classInfo is ProtocolClassDefinition &&
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
      var subDir = endpoint.subDir;
      return p.posix.joinAll([
        '..',
        'endpoints',
        if (subDir != null) ...p.split(subDir),
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
                                    config.type == PackageType.server
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
      return '_Endpoint${ReCase(endpointName).pascalCase}';
    }

    var library = LibraryBuilder();

    var hasModules =
        config.modules.isNotEmpty && config.type == PackageType.server;

    var modulePrefix =
        config.type == PackageType.server ? '' : '${config.name}.';

    for (var endpointDef in protocolDefinition.endpoints) {
      var endpointClassName = getEndpointClassName(endpointDef.name);

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
}
