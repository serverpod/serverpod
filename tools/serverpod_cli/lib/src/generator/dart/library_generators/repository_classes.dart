import 'package:code_builder/code_builder.dart';
import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:super_string/super_string.dart';

class BuildRepositoryClass {
  final bool serverCode;
  final GeneratorConfig config;

  BuildRepositoryClass({
    required this.serverCode,
    required this.config,
  });

  Class buildEntityRepositoryClass(
    String className,
    List<SerializableEntityFieldDefinition> fields,
    ClassDefinition classDefinition,
  ) {
    var objectRelationFields =
        fields.where((field) => field.relation is ObjectRelationDefinition);
    return Class((classBuilder) {
      classBuilder
        ..name = '${className}Repository'
        ..constructors.add(Constructor((constructorBuilder) {
          constructorBuilder
            ..name = '_'
            ..constant = true;
        }))
        ..fields.addAll([
          if (hasAttachOperations(fields))
            Field((fieldBuilder) {
              fieldBuilder
                ..name = 'attach'
                ..modifier = FieldModifier.final$
                ..assignment = Code('const ${className}AttachRepository._()');
            }),
          if (hasDetachOperations(fields))
            Field((fieldBuilder) {
              fieldBuilder
                ..name = 'detach'
                ..modifier = FieldModifier.final$
                ..assignment = Code('const ${className}DetachRepository._()');
            }),
        ])
        ..methods.addAll([
          _buildFindMethod(className, objectRelationFields),
          _buildFindRow(className, objectRelationFields),
          _buildFindByIdMethod(className, objectRelationFields),
          _buildInsertRowMethod(className),
          _buildUpdateRowMethod(className),
          _buildDeleteRowMethod(className),
          _buildDeleteWhereMethod(className),
          _buildCountMethod(className),
        ]);
    });
  }

  Class buildEntityAttachRepositoryClass(
    String className,
    List<SerializableEntityFieldDefinition> fields,
    ClassDefinition classDefinition,
  ) {
    return Class((classBuilder) {
      classBuilder
        ..name = '${className}AttachRepository'
        ..constructors.add(Constructor((constructorBuilder) {
          constructorBuilder
            ..name = '_'
            ..constant = true;
        }))
        ..methods.addAll(_buildAttachMethods(
          fields,
          className,
          classDefinition,
        ));
    });
  }

  Class buildEntityDetachRepositoryClass(
    String className,
    List<SerializableEntityFieldDefinition> fields,
    ClassDefinition classDefinition,
  ) {
    return Class((classBuilder) {
      classBuilder
        ..name = '${className}DetachRepository'
        ..constructors.add(Constructor((constructorBuilder) {
          constructorBuilder
            ..name = '_'
            ..constant = true;
        }))
        ..methods.addAll(_buildDetachMethods(
          fields,
          className,
          classDefinition,
        ));
    });
  }

  bool hasAttachOperations(List<SerializableEntityFieldDefinition> fields) {
    return fields.any(_shouldCreateAttachMethodFromField);
  }

  bool hasDetachOperations(List<SerializableEntityFieldDefinition> fields) {
    return fields.any(_shouldCreateDetachMethodFromField);
  }

  bool _shouldCreateAttachMethodFromField(
    SerializableEntityFieldDefinition field,
  ) {
    return field.relation is ObjectRelationDefinition;
  }

  bool _shouldCreateDetachMethodFromField(
    SerializableEntityFieldDefinition field,
  ) {
    var relation = field.relation;
    return relation is ObjectRelationDefinition && relation.nullableRelation;
  }

  Method _buildFindMethod(String className,
      Iterable<SerializableEntityFieldDefinition> objectRelationFields) {
    return Method((m) => m
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
          ..type = refer('Session', 'package:serverpod/serverpod.dart')
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
          ..type = refer('bool')
          ..name = 'orderDescending'
          ..defaultTo = const Code('false')
          ..named = true),
        Parameter((p) => p
          ..type = TypeReference((t) => t
            ..symbol = 'List'
            ..isNullable = true
            ..types.add(refer('Order', 'package:serverpod/serverpod.dart')))
          ..name = 'orderByList'
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
          .property('dbNext')
          .property('find')
          .call([], {
            'where': refer('where').nullSafeProperty('call').call(
              [refer(className).property('t')],
            ),
            'limit': refer('limit'),
            'offset': refer('offset'),
            'orderBy': refer('orderBy'),
            'orderByList': refer('orderByList'),
            'orderDescending': refer('orderDescending'),
            'transaction': refer('transaction'),
            if (objectRelationFields.isNotEmpty) 'include': refer('include'),
          }, [
            refer(className)
          ])
          .returned
          .statement);
  }

  Method _buildFindRow(
    String className,
    Iterable<SerializableEntityFieldDefinition> objectRelationFields,
  ) {
    return Method((m) => m
      ..name = 'findRow'
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
          ..type = refer('Session', 'package:serverpod/serverpod.dart')
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
          .property('dbNext')
          .property('findRow')
          .call(
            [],
            {
              'where': refer('where').nullSafeProperty('call').call(
                [refer(className).property('t')],
              ),
              'transaction': refer('transaction'),
              if (objectRelationFields.isNotEmpty) 'include': refer('include'),
            },
            [refer(className)],
          )
          .returned
          .statement);
  }

  Method _buildFindByIdMethod(String className,
      Iterable<SerializableEntityFieldDefinition> objectRelationFields) {
    return Method((m) => m
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
          ..type = refer('Session', 'package:serverpod/serverpod.dart')
          ..name = 'session'),
        Parameter((p) => p
          ..type = refer('int')
          ..name = 'id'),
      ])
      ..optionalParameters.addAll([
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
          .property('dbNext')
          .property('findById')
          .call(
            [refer('id')],
            {
              'transaction': refer('transaction'),
              if (objectRelationFields.isNotEmpty) 'include': refer('include'),
            },
            [refer(className)],
          )
          .returned
          .statement);
  }

  Method _buildInsertRowMethod(String className) {
    return Method((methodBuilder) {
      methodBuilder
        ..name = 'insertRow'
        ..returns = TypeReference(
          (r) => r
            ..symbol = 'Future'
            ..types.add(refer(className)),
        )
        ..requiredParameters.addAll([
          Parameter((p) => p
            ..type = refer('Session', 'package:serverpod/serverpod.dart')
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
            .property('dbNext')
            .property('insertRow')
            .call([
              refer('row')
            ], {
              'transaction': refer('transaction'),
            }, [
              refer(className)
            ])
            .returned
            .statement;
    });
  }

  Method _buildUpdateRowMethod(String className) {
    return Method((methodBuilder) {
      methodBuilder
        ..name = 'updateRow'
        ..returns = TypeReference(
          (r) => r
            ..symbol = 'Future'
            ..types.add(refer(className)),
        )
        ..requiredParameters.addAll([
          Parameter((p) => p
            ..type = refer('Session', 'package:serverpod/serverpod.dart')
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
            .property('dbNext')
            .property('updateRow')
            .call([
              refer('row')
            ], {
              'transaction': refer('transaction'),
            }, [
              refer(className)
            ])
            .returned
            .statement;
    });
  }

  Method _buildDeleteRowMethod(String className) {
    return Method((methodBuilder) {
      methodBuilder
        ..name = 'deleteRow'
        ..returns = TypeReference(
          (r) => r
            ..symbol = 'Future'
            ..types.add((refer('int'))),
        )
        ..requiredParameters.addAll([
          Parameter((p) => p
            ..type = refer('Session', 'package:serverpod/serverpod.dart')
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
            .property('dbNext')
            .property('deleteRow')
            .call([
              refer('row')
            ], {
              'transaction': refer('transaction'),
            }, [
              refer(className)
            ])
            .returned
            .statement;
    });
  }

  Method _buildDeleteWhereMethod(String className) {
    return Method((methodBuilder) {
      methodBuilder
        ..name = 'deleteWhere'
        ..returns = TypeReference(
          (r) => r
            ..symbol = 'Future'
            ..types.add((refer('List<int>'))),
        )
        ..requiredParameters.addAll([
          Parameter((p) => p
            ..type = refer('Session', 'package:serverpod/serverpod.dart')
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
            .property('dbNext')
            .property('deleteWhere')
            .call([], {
              'where': refer('where').call([refer(className).property('t')]),
              'transaction': refer('transaction'),
            }, [
              refer(className)
            ])
            .returned
            .statement;
    });
  }

  Method _buildCountMethod(String className) {
    return Method((methodBuilder) {
      methodBuilder
        ..name = 'count'
        ..returns = TypeReference(
          (r) => r
            ..symbol = 'Future'
            ..types.add(refer('int')),
        )
        ..requiredParameters.addAll([
          Parameter((p) => p
            ..type = refer('Session', 'package:serverpod/serverpod.dart')
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
              ..symbol = 'Transaction'
              ..url = 'package:serverpod/serverpod.dart')
            ..name = 'transaction'
            ..named = true),
        ])
        ..modifier = MethodModifier.async
        ..body = refer('session')
            .property('dbNext')
            .property('count')
            .call([], {
              'where': refer('where').nullSafeProperty('call').call(
                [refer(className).property('t')],
              ),
              'limit': refer('limit'),
              'transaction': refer('transaction'),
            }, [
              refer(className)
            ])
            .returned
            .statement;
    });
  }

  Iterable<Method> _buildAttachMethods(
    List<SerializableEntityFieldDefinition> fields,
    String className,
    ClassDefinition classDefinition,
  ) {
    return fields.where(_shouldCreateAttachMethodFromField).map(
          (field) => Method((methodBuilder) {
            var classFieldName = className.toCamelCase(isLowerCamelCase: true);
            var otherClassFieldName =
                field.name == classFieldName ? 'nested$className' : field.name;

            var relation = field.relation;
            (relation as ObjectRelationDefinition);

            methodBuilder
              ..returns = refer('Future<void>')
              ..name = field.name
              ..requiredParameters.addAll([
                Parameter((parameterBuilder) {
                  parameterBuilder
                    ..name = 'session'
                    ..type =
                        refer('Session', 'package:serverpod/serverpod.dart');
                }),
                Parameter((parameterBuilder) {
                  parameterBuilder
                    ..name = classFieldName
                    ..type = refer(className);
                }),
                Parameter((parameterBuilder) {
                  parameterBuilder
                    ..name = otherClassFieldName
                    ..type = field.type.reference(
                      serverCode,
                      nullable: false,
                      subDirParts: classDefinition.subDirParts,
                      config: config,
                    );
                })
              ])
              ..modifier = MethodModifier.async
              ..body = relation.isForeignKeyOrigin
                  ? _buildAttachImplementationBlock(
                      classFieldName,
                      otherClassFieldName,
                      relation.fieldName,
                      refer(className),
                    )
                  : _buildAttachImplementationBlock(
                      otherClassFieldName,
                      classFieldName,
                      relation.foreignFieldName,
                      field.type.reference(
                        serverCode,
                        nullable: false,
                        subDirParts: classDefinition.subDirParts,
                        config: config,
                      ));
            const Code('');
          }),
        );
  }

  Block _buildAttachImplementationBlock(
    String classFieldName,
    String otherClassFieldName,
    String foreignKeyField,
    Reference classReference,
  ) {
    return (BlockBuilder()
          ..statements.addAll([
            _buildCodeBlockThrowIfIdIsNull(classFieldName),
            _buildCodeBlockThrowIfIdIsNull(otherClassFieldName),
            const Code(''),
            _buildUpdateSingleField(
              classFieldName,
              foreignKeyField,
              classReference,
              refer(otherClassFieldName).property('id'),
            ),
          ]))
        .build();
  }

  Iterable<Method> _buildDetachMethods(
      List<SerializableEntityFieldDefinition> fields,
      String className,
      ClassDefinition classDefinition) {
    return fields.where(_shouldCreateDetachMethodFromField).map(
          (field) => Method((methodBuilder) {
            var classFieldName = className.toCamelCase(isLowerCamelCase: true);
            var fieldName = field.name;

            var relation = field.relation;
            (relation as ObjectRelationDefinition);

            methodBuilder
              ..name = field.name
              ..requiredParameters.addAll([
                Parameter((parameterBuilder) {
                  parameterBuilder
                    ..name = 'session'
                    ..type =
                        refer('Session', 'package:serverpod/serverpod.dart');
                }),
                Parameter((parameterBuilder) {
                  parameterBuilder
                    ..name = classFieldName
                    ..type = refer(className);
                })
              ])
              ..returns = refer('Future<void>')
              ..modifier = MethodModifier.async
              ..body = relation.isForeignKeyOrigin
                  ? _buildDetachImplementationBlockOriginSide(
                      fieldName,
                      classFieldName,
                      relation.fieldName,
                      className,
                    )
                  : _buildDetachImplementationBlockForeignSide(
                      fieldName,
                      classFieldName,
                      relation.foreignFieldName,
                      field.type.reference(
                        serverCode,
                        nullable: false,
                        subDirParts: classDefinition.subDirParts,
                        config: config,
                      ));
            const Code('');
          }),
        );
  }

  Block _buildDetachImplementationBlockOriginSide(
    String fieldName,
    String classFieldName,
    String foreignKeyField,
    String className,
  ) {
    return (BlockBuilder()
          ..statements.addAll(
            [
              _buildCodeBlockThrowIfIdIsNull(classFieldName),
              const Code(''),
              _buildUpdateSingleField(
                classFieldName,
                foreignKeyField,
                refer(className),
                refer('null'),
              ),
            ],
          ))
        .build();
  }

  Block _buildDetachImplementationBlockForeignSide(
    String fieldName,
    String classFieldName,
    String foreignKeyField,
    Reference foreignClass,
  ) {
    var localCopyVariable = '\$$fieldName';
    return (BlockBuilder()
          ..statements.addAll(
            [
              declareVar(localCopyVariable)
                  .assign(refer(classFieldName).property(fieldName))
                  .statement,
              const Code(''),
              _buildCodeBlockThrowIfFieldIsNull(
                localCopyVariable,
                '$classFieldName.$fieldName',
              ),
              _buildCodeBlockThrowIfIdIsNull(
                localCopyVariable,
                '$classFieldName.$fieldName.id',
              ),
              _buildCodeBlockThrowIfIdIsNull(classFieldName),
              const Code(''),
              _buildUpdateSingleField(
                localCopyVariable,
                foreignKeyField,
                foreignClass,
                refer('null'),
              ),
            ],
          ))
        .build();
  }

  Block _buildCodeBlockThrowIfIdIsNull(String className, [String? errorRef]) {
    return _buildCodeBlockThrowIfFieldIsNull('$className.id', errorRef);
  }

  Block _buildCodeBlockThrowIfFieldIsNull(
    String nullCheckRef, [
    String? errorRef,
  ]) {
    var error = errorRef ?? nullCheckRef;
    return Block.of([
      Code('if ($nullCheckRef == null) {'),
      refer('ArgumentError', 'dart:core')
          .property('notNull')
          .call([refer('\'$error\'')])
          .thrown
          .statement,
      const Code('}'),
    ]);
  }

  Code _buildUpdateSingleField(
    String rowName,
    String fieldName,
    Reference classReference,
    Expression assignment,
  ) {
    var localCopyVariable = '\$$rowName';
    return (BlockBuilder()
          ..statements.addAll([
            declareVar(localCopyVariable)
                .assign(refer(rowName).property('copyWith').call([], {
                  fieldName: assignment,
                }))
                .statement,
            refer('session')
                .property('db')
                .property('update')
                .call([
                  refer(localCopyVariable)
                ], {
                  'columns': literalList(
                    [classReference.property('t').property(fieldName)],
                  )
                })
                .awaited
                .statement,
          ]))
        .build();
  }
}
