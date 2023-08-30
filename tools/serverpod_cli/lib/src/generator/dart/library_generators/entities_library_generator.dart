import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/generator/shared.dart';
import 'package:serverpod_cli/src/logger/logger.dart';

/// Generates the dart libraries for [SerializableEntityDefinition]s.
class SerializableEntityLibraryGenerator {
  final bool serverCode;
  final GeneratorConfig config;

  SerializableEntityLibraryGenerator({
    required this.serverCode,
    required this.config,
  });

  /// Generate the file for a protocol entity.
  Library generateEntityLibrary(
      SerializableEntityDefinition protocolEntityDefinition) {
    if (protocolEntityDefinition is ClassDefinition) {
      return _generateClassLibrary(protocolEntityDefinition);
    }
    if (protocolEntityDefinition is EnumDefinition) {
      return _generateEnumLibrary(protocolEntityDefinition);
    }

    throw Exception('Unsupported protocol entity type.');
  }

  /// Handle ordinary classes for [generateEntityLibrary].
  Library _generateClassLibrary(ClassDefinition classDefinition) {
    String? tableName = classDefinition.tableName;
    var className = classDefinition.className;
    var fields = classDefinition.fields;
    var objectRelationFields =
        fields.where((field) => field.relation is ObjectRelationDefinition);

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
                    subDirParts: classDefinition.subDirParts, config: config);
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
                            subDirParts: classDefinition.subDirParts,
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
                  // TODO: better name
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
                  if (objectRelationFields.isNotEmpty)
                    Parameter((p) => p
                      ..type = TypeReference((b) => b
                        ..isNullable = true
                        ..symbol = '${className}Include')
                      ..name = 'include'
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
                      if (objectRelationFields.isNotEmpty)
                        'include': refer('include'),
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
                  if (objectRelationFields.isNotEmpty)
                    Parameter((p) => p
                      ..type = TypeReference((b) => b
                        ..isNullable = true
                        ..symbol = '${className}Include')
                      ..name = 'include'
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
                      if (objectRelationFields.isNotEmpty)
                        'include': refer('include'),
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
                ..optionalParameters.addAll([
                  if (objectRelationFields.isNotEmpty)
                    Parameter((p) => p
                      ..type = TypeReference((b) => b
                        ..isNullable = true
                        ..symbol = '${className}Include')
                      ..name = 'include'
                      ..named = true),
                ])
                ..modifier = MethodModifier.async
                ..body = refer('session')
                    .property('db')
                    .property('findById')
                    .call(
                      [refer('id')],
                      {
                        if (objectRelationFields.isNotEmpty)
                          'include': refer('include'),
                      },
                      [refer(className)],
                    )
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

              // count
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

              // include
              classBuilder.methods.add(Method(
                (m) => m
                  ..static = true
                  ..name = 'include'
                  ..returns =
                      TypeReference((r) => r..symbol = '${className}Include')
                  ..optionalParameters.addAll([
                    for (var field in objectRelationFields)
                      Parameter(
                        (p) => p
                          ..type = field.type.reference(
                            serverCode,
                            subDirParts: classDefinition.subDirParts,
                            config: config,
                            typeSuffix: 'Include',
                          )
                          ..name = field.name
                          ..named = true,
                      ),
                  ])
                  ..body = refer('${className}Include')
                      .property('_')
                      .call([], {
                        for (var field in objectRelationFields)
                          field.name: refer(field.name),
                      })
                      .returned
                      .statement,
              ));
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
              constructor.optionalParameters.add(
                Parameter(
                  (p) => p
                    ..name = 'queryPrefix'
                    ..toSuper = true
                    ..named = true,
                ),
              );
              constructor.optionalParameters.add(
                Parameter(
                  (p) => p
                    ..name = 'tableRelations'
                    ..toSuper = true
                    ..named = true,
                ),
              );
              constructor.initializers.add(refer('super')
                  .call([], {'tableName': literalString(tableName)}).code);

              constructor.body = Block.of([
                for (var field in fields.where((field) =>
                    field.shouldSerializeFieldForDatabase(serverCode)))
                  if (!(field.name == 'id' && serverCode))
                    refer(field.name)
                        .assign(TypeReference((t) => t
                          ..symbol = field.type.columnType
                          ..url = 'package:serverpod/serverpod.dart'
                          ..types.addAll(field.type.isEnum
                              ? [
                                  field.type.reference(
                                    serverCode,
                                    nullable: false,
                                    subDirParts: classDefinition.subDirParts,
                                    config: config,
                                  )
                                ]
                              : [])).call([
                          literalString(field.name)
                        ], {
                          'queryPrefix': refer('super').property('queryPrefix'),
                          'tableRelations':
                              refer('super').property('tableRelations')
                        }))
                        .statement,
              ]);
            }));

            // Column fields
            for (var field in fields) {
              // Simple column field
              if (field.shouldSerializeFieldForDatabase(serverCode) &&
                  !(field.name == 'id' && serverCode)) {
                c.fields.add(Field((f) => f
                  ..late = true
                  ..modifier = FieldModifier.final$
                  ..name = field.name
                  ..docs.addAll(field.documentation ?? [])
                  ..type = TypeReference((t) => t
                    ..symbol = field.type.columnType
                    ..url = 'package:serverpod/serverpod.dart'
                    ..types.addAll(field.type.isEnum
                        ? [
                            field.type.reference(
                              serverCode,
                              nullable: false,
                              subDirParts: classDefinition.subDirParts,
                              config: config,
                            )
                          ]
                        : []))));
              } else if (field.relation is ObjectRelationDefinition) {
                // Complex relation fields
                var objectRelation = field.relation as ObjectRelationDefinition;
                var foreignRelationField = fields
                    .cast<SerializableEntityFieldDefinition?>()
                    .firstWhere(
                        (f) =>
                            f?.name == objectRelation.fieldName &&
                            f?.relation is ForeignRelationDefinition,
                        orElse: () => null);

                if (foreignRelationField == null) {
                  log.error(
                      'Could not find foreign relation field ${objectRelation.fieldName} for ${field.name} in ${classDefinition.className}.');
                  continue;
                }

                var foreignRelation =
                    foreignRelationField.relation as ForeignRelationDefinition;

                // Add internal nullable table field
                c.fields.add(Field((f) => f
                  ..name = '_${field.name}'
                  ..docs.addAll(field.documentation ?? [])
                  ..type = field.type.reference(
                    serverCode,
                    subDirParts: classDefinition.subDirParts,
                    config: config,
                    nullable: true,
                    typeSuffix: 'Table',
                  )));

                // Add getter method for relation table that creates the table
                c.methods.add(Method((m) => m
                  ..name = field.name
                  ..type = MethodType.getter
                  ..returns = field.type.reference(
                    serverCode,
                    subDirParts: classDefinition.subDirParts,
                    config: config,
                    nullable: false,
                    typeSuffix: 'Table',
                  )
                  ..body = Block.of([
                    Code('if (_${field.name} != null) return _${field.name}!;'),
                    refer('_${field.name}')
                        .assign(refer('createRelationTable',
                                'package:serverpod/serverpod.dart')
                            .call([], {
                          'queryPrefix': refer('queryPrefix'),
                          'fieldName': literalString(field.name),
                          'foreignTableName': field.type
                              .reference(
                                serverCode,
                                subDirParts: classDefinition.subDirParts,
                                config: config,
                                nullable: false,
                              )
                              .property('t')
                              .property('tableName'),
                          'column': refer(foreignRelationField.name),
                          'foreignColumnName': field.type
                              .reference(
                                serverCode,
                                subDirParts: classDefinition.subDirParts,
                                config: config,
                                nullable: false,
                              )
                              .property('t')
                              .property(foreignRelation.foreignFieldName)
                              .property('columnName'),
                          'createTable': Method((m) => m
                            ..requiredParameters.addAll([
                              Parameter((p) => p..name = 'relationQueryPrefix'),
                              Parameter(
                                  (p) => p..name = 'foreignTableRelation'),
                            ])
                            ..lambda = true
                            ..body = field.type
                                .reference(
                              serverCode,
                              subDirParts: classDefinition.subDirParts,
                              config: config,
                              nullable: false,
                              typeSuffix: 'Table',
                            )
                                .call([], {
                              'queryPrefix': refer('relationQueryPrefix'),
                              'tableRelations': literalList([
                                refer('tableRelations').nullSafeSpread,
                                refer('foreignTableRelation'),
                              ]),
                            }).code).closure
                        }))
                        .statement,
                    Code('return _${field.name}!;'),
                  ])));
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

            // getRelation method if we have relation fields
            var objectRelationFields =
                fields.where((f) => f.relation is ObjectRelationDefinition);
            if (objectRelationFields.isNotEmpty) {
              c.methods.add(Method(
                (m) => m
                  ..annotations.add(refer('override'))
                  ..returns = TypeReference((t) => t
                    ..symbol = 'Table'
                    ..isNullable = true
                    ..url = 'package:serverpod/serverpod.dart')
                  ..name = 'getRelationTable'
                  ..requiredParameters.add(
                    Parameter(
                      (p) => p
                        ..type = refer('String')
                        ..name = 'relationField',
                    ),
                  )
                  ..body = (BlockBuilder()
                        ..statements.addAll([
                          for (var objectRelationField in objectRelationFields)
                            Block.of([
                              Code(
                                  'if (relationField == ${literalString(objectRelationField.name)}) {'),
                              lazyCode(() {
                                return refer(objectRelationField.name)
                                    .returned
                                    .statement;
                              }),
                              const Code('}'),
                            ]),
                          const Code('return null;'),
                        ]))
                      .build(),
              ));
            }
          }));

          // Create instance of table
          library.body.add(Field((f) => f
            ..annotations.add(refer('Deprecated')
                .call([literalString('Use ${className}Table.t instead.')]))
            ..name = 't$className'
            ..type = refer('${className}Table')
            ..assignment = refer('${className}Table').call([]).code));

          // Includes class definition
          library.body.add(Class(((c) {
            c.extend = refer('Include', 'package:serverpod/serverpod.dart');
            c.name = '${className}Include';
            var objectRelationFields = fields
                .where((f) => f.relation is ObjectRelationDefinition)
                .toList();

            // Add constructor
            c.constructors.add(Constructor((constructor) {
              constructor.name = '_';
              for (var field in objectRelationFields) {
                constructor.optionalParameters.add(Parameter(
                  (p) => p
                    ..name = field.name
                    ..named = true
                    ..toThis = true,
                ));
              }
            }));

            // Add field declarations
            for (var field in objectRelationFields) {
              c.fields.add(Field((f) => f
                ..name = field.name
                ..type = field.type.reference(
                  serverCode,
                  subDirParts: classDefinition.subDirParts,
                  config: config,
                  typeSuffix: 'Include',
                )));
            }

            // Add includes getter
            c.methods.add(Method(
              (m) => m
                ..annotations.add(refer('override'))
                ..returns = TypeReference((t) => t
                  ..symbol = 'Map'
                  ..types.addAll([
                    refer('String'),
                    refer('Include?', 'package:serverpod/serverpod.dart'),
                  ]))
                ..name = 'includes'
                ..lambda = true
                ..type = MethodType.getter
                ..body = literalMap({
                  for (var field in objectRelationFields)
                    literalString(field.name): refer(field.name)
                }).code,
            ));

            // Add table getter
            c.methods.add(Method(
              (m) => m
                ..annotations.add(refer('override'))
                ..returns = TypeReference((t) => t
                  ..symbol = 'Table'
                  ..url = serverpodUrl(serverCode))
                ..name = 'table'
                ..lambda = true
                ..type = MethodType.getter
                ..body = refer('$className.t').code,
            ));
          })));
        }
      },
    );

    return library;
  }

  /// Handle enums for [generateEntityLibrary]
  Library _generateEnumLibrary(EnumDefinition enumDefinition) {
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

  /// Generate a temporary protocol library, that just exports the entities.
  /// This is needed, since analyzing the endpoints requires a valid
  /// protocol.dart file.
  Library generateTemporaryProtocol({
    required List<SerializableEntityDefinition> entities,
  }) {
    var library = LibraryBuilder();

    library.name = 'protocol';

    // exports
    library.directives.addAll([
      for (var classInfo in entities) Directive.export(classInfo.fileRef()),
      if (!serverCode) Directive.export('client.dart'),
    ]);

    return library.build();
  }
}
