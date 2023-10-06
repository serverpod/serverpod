import 'package:code_builder/code_builder.dart';
import 'package:recase/recase.dart';
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
          if (hasAttachRowOperations(fields))
            Field((fieldBuilder) {
              fieldBuilder
                ..name = 'attachRow'
                ..modifier = FieldModifier.final$
                ..assignment =
                    Code('const ${className}AttachRowRepository._()');
            }),
          if (hasDetachRowOperations(fields))
            Field((fieldBuilder) {
              fieldBuilder
                ..name = 'detachRow'
                ..modifier = FieldModifier.final$
                ..assignment =
                    Code('const ${className}DetachRowRepository._()');
            }),
        ])
        ..methods.addAll([
          _buildFindMethod(className, objectRelationFields),
          _buildFindRow(className, objectRelationFields),
          _buildFindByIdMethod(className, objectRelationFields),
          _buildInsertMethod(className),
          _buildInsertRowMethod(className),
          _buildUpdateMethod(className),
          _buildUpdateRowMethod(className),
          _buildDeleteMethod(className),
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

  Class buildEntityAttachRowRepositoryClass(
    String className,
    List<SerializableEntityFieldDefinition> fields,
    ClassDefinition classDefinition,
  ) {
    return Class((classBuilder) {
      classBuilder
        ..name = '${className}AttachRowRepository'
        ..constructors.add(Constructor((constructorBuilder) {
          constructorBuilder
            ..name = '_'
            ..constant = true;
        }))
        ..methods.addAll(_buildAttachRowMethods(
          fields,
          className,
          classDefinition,
        ));
    });
  }

  Class buildEntityDetachRowRepositoryClass(
    String className,
    List<SerializableEntityFieldDefinition> fields,
    ClassDefinition classDefinition,
  ) {
    return Class((classBuilder) {
      classBuilder
        ..name = '${className}DetachRowRepository'
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
    return fields.any((f) => _isListRelation(f));
  }

  bool hasAttachRowOperations(List<SerializableEntityFieldDefinition> fields) {
    return fields.any((f) => _isObjectRelation(f) || _isListRelation(f));
  }

  bool hasDetachRowOperations(List<SerializableEntityFieldDefinition> fields) {
    return fields
        .any((f) => _isNullableObjectRelation(f) || _isNullableListRelation(f));
  }

  bool hasImplicitClassOperations(
      List<SerializableEntityFieldDefinition> fields) {
    return fields.any((e) => e.hiddenSerializableField(serverCode));
  }

  bool _isListRelation(SerializableEntityFieldDefinition field) {
    return field.relation is ListRelationDefinition;
  }

  bool _isNullableListRelation(SerializableEntityFieldDefinition field) {
    var relation = field.relation;
    return relation is ListRelationDefinition && relation.nullableRelation;
  }

  bool _isObjectRelation(
    SerializableEntityFieldDefinition field,
  ) {
    return field.relation is ObjectRelationDefinition;
  }

  bool _isNullableObjectRelation(
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

  Method _buildInsertMethod(String className) {
    return Method((methodBuilder) {
      methodBuilder
        ..name = 'insert'
        ..returns = TypeReference(
          (r) => r
            ..symbol = 'Future'
            ..types.add(refer('List<$className>')),
        )
        ..requiredParameters.addAll([
          Parameter((p) => p
            ..type = refer('Session', 'package:serverpod/serverpod.dart')
            ..name = 'session'),
          Parameter((p) => p
            ..type = refer('List<$className>')
            ..name = 'rows'),
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
            .property('insert')
            .call([
              refer('rows')
            ], {
              'transaction': refer('transaction'),
            }, [
              refer(className)
            ])
            .returned
            .statement;
    });
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

  Method _buildUpdateMethod(String className) {
    return Method((methodBuilder) {
      methodBuilder
        ..name = 'update'
        ..returns = TypeReference(
          (r) => r
            ..symbol = 'Future'
            ..types.add(refer('List<$className>')),
        )
        ..requiredParameters.addAll([
          Parameter((p) => p
            ..type = refer('Session', 'package:serverpod/serverpod.dart')
            ..name = 'session'),
          Parameter((p) => p
            ..type = refer('List<$className>')
            ..name = 'rows'),
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
            .property('update')
            .call([
              refer('rows')
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

  Method _buildDeleteMethod(String className) {
    return Method((methodBuilder) {
      methodBuilder
        ..name = 'delete'
        ..returns = TypeReference(
          (r) => r
            ..symbol = 'Future'
            ..types.add((refer('List<int>'))),
        )
        ..requiredParameters.addAll([
          Parameter((p) => p
            ..type = refer('Session', 'package:serverpod/serverpod.dart')
            ..name = 'session'),
          Parameter((p) => p
            ..type = refer('List<$className>')
            ..name = 'rows'),
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
            .property('delete')
            .call([
              refer('rows')
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
    return fields.where(_isListRelation).map(
          (field) => _buildAttachFromListRelationField(
            className,
            field,
            classDefinition,
          ),
        );
  }

  Iterable<Method> _buildAttachRowMethods(
    List<SerializableEntityFieldDefinition> fields,
    String className,
    ClassDefinition classDefinition,
  ) {
    return [
      ...fields.where(_isObjectRelation).map(
            (field) => _buildAttachRowFromObjectRelationField(
              className,
              field,
              classDefinition,
            ),
          ),
      ...fields.where(_isListRelation).map(
            (field) => _buildAttachRowFromListRelationField(
              className,
              field,
              classDefinition,
            ),
          )
    ];
  }

  Method _buildAttachFromListRelationField(
    String className,
    SerializableEntityFieldDefinition field,
    ClassDefinition classDefinition,
  ) {
    return Method((methodBuilder) {
      var classFieldName = className.camelCase;
      var fieldName = field.type.generics.first.className.camelCase;
      var otherClassFieldName =
          fieldName == classFieldName ? 'nested$className' : fieldName;

      var foreignType = field.type.generics.first.reference(
        serverCode,
        nullable: false,
        subDirParts: classDefinition.subDirParts,
        config: config,
      );

      var relation = field.relation as ListRelationDefinition;

      methodBuilder
        ..returns = refer('Future<void>')
        ..name = field.name
        ..requiredParameters.addAll([
          Parameter((parameterBuilder) {
            parameterBuilder
              ..name = 'session'
              ..type = refer('Session', 'package:serverpod/serverpod.dart');
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
        ..body = relation.implicitForeignField
            ? _buildImplicitAttachImplementationBlock(
                className,
                otherClassFieldName,
                classFieldName,
                relation.foreignFieldName,
                foreignType,
              )
            : _buildAttachImplementationBlock(
                otherClassFieldName,
                classFieldName,
                relation.foreignFieldName,
                foreignType,
              );
      const Code('');
    });
  }

  Method _buildAttachRowFromListRelationField(
    String className,
    SerializableEntityFieldDefinition field,
    ClassDefinition classDefinition,
  ) {
    return Method((methodBuilder) {
      var classFieldName = className.camelCase;
      var fieldName = field.type.generics.first.className.camelCase;
      var otherClassFieldName =
          fieldName == classFieldName ? 'nested$className' : fieldName;

      var foreignType = field.type.generics.first.reference(
        serverCode,
        nullable: false,
        subDirParts: classDefinition.subDirParts,
        config: config,
      );

      var relation = field.relation as ListRelationDefinition;

      methodBuilder
        ..returns = refer('Future<void>')
        ..name = field.name
        ..requiredParameters.addAll([
          Parameter((parameterBuilder) {
            parameterBuilder
              ..name = 'session'
              ..type = refer('Session', 'package:serverpod/serverpod.dart');
          }),
          Parameter((parameterBuilder) {
            parameterBuilder
              ..name = classFieldName
              ..type = refer(className);
          }),
          Parameter((parameterBuilder) {
            parameterBuilder
              ..name = otherClassFieldName
              ..type = foreignType;
          })
        ])
        ..modifier = MethodModifier.async
        ..body = relation.implicitForeignField
            ? _buildImplicitAttachRowImplementationBlock(
                className,
                otherClassFieldName,
                classFieldName,
                relation.foreignFieldName,
                foreignType,
              )
            : _buildAttachRowImplementationBlock(
                otherClassFieldName,
                classFieldName,
                relation.foreignFieldName,
                foreignType,
              );
      const Code('');
    });
  }

  Method _buildAttachRowFromObjectRelationField(
    String className,
    SerializableEntityFieldDefinition field,
    ClassDefinition classDefinition,
  ) {
    return Method((methodBuilder) {
      var classFieldName = className.camelCase;
      var otherClassFieldName =
          field.name == classFieldName ? 'nested$className' : field.name;

      var relation = field.relation as ObjectRelationDefinition;

      var foreignType = field.type.reference(
        serverCode,
        nullable: false,
        subDirParts: classDefinition.subDirParts,
        config: config,
      );

      methodBuilder
        ..returns = refer('Future<void>')
        ..name = field.name
        ..requiredParameters.addAll([
          Parameter((parameterBuilder) {
            parameterBuilder
              ..name = 'session'
              ..type = refer('Session', 'package:serverpod/serverpod.dart');
          }),
          Parameter((parameterBuilder) {
            parameterBuilder
              ..name = classFieldName
              ..type = refer(className);
          }),
          Parameter((parameterBuilder) {
            parameterBuilder
              ..name = otherClassFieldName
              ..type = foreignType;
          })
        ])
        ..modifier = MethodModifier.async
        ..body = relation.isForeignKeyOrigin
            ? _buildAttachRowImplementationBlock(
                classFieldName,
                otherClassFieldName,
                relation.fieldName,
                refer(className),
              )
            : _buildAttachRowImplementationBlock(
                otherClassFieldName,
                classFieldName,
                relation.foreignFieldName,
                foreignType,
              );
      const Code('');
    });
  }

  Block _buildImplicitAttachImplementationBlock(
    String className,
    String classFieldName,
    String otherClassFieldName,
    String foreignKeyField,
    Reference classReference,
  ) {
    return (BlockBuilder()
          ..statements.addAll([
            _buildCodeBlockThrowIfIdIsNull(classFieldName),
            _buildCodeBlockThrowIfAnyIdIsNull(otherClassFieldName),
            const Code(''),
            _buildImplicitCopyClassListField(
              className,
              classFieldName,
              foreignKeyField,
              refer(otherClassFieldName).property('id'),
            ),
            _buildUpdateListField(
              classFieldName,
              foreignKeyField,
              classReference,
              refer(otherClassFieldName).property('id'),
            ),
          ]))
        .build();
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
            _buildCodeBlockThrowIfAnyIdIsNull(otherClassFieldName),
            const Code(''),
            _buildCopyWithListField(
              classFieldName,
              foreignKeyField,
              refer(otherClassFieldName).property('id'),
            ),
            _buildUpdateListField(
              classFieldName,
              foreignKeyField,
              classReference,
              refer(otherClassFieldName).property('id'),
            ),
          ]))
        .build();
  }

  Block _buildAttachRowImplementationBlock(
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
            _buildCopyWithSingleField(
              classFieldName,
              foreignKeyField,
              refer(otherClassFieldName).property('id'),
            ),
            _buildUpdateSingleField(
              classFieldName,
              foreignKeyField,
              classReference,
              refer(otherClassFieldName).property('id'),
            ),
          ]))
        .build();
  }

  Block _buildImplicitAttachRowImplementationBlock(
    String className,
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
            _buildImplicitCopyClassSingleField(
              className,
              classFieldName,
              foreignKeyField,
              refer(otherClassFieldName).property('id'),
            ),
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
    ClassDefinition classDefinition,
  ) {
    return [
      ...fields.where(_isNullableObjectRelation).map(
            (field) => _buildDetachRowFromObjectRelationField(
              className,
              field,
              classDefinition,
            ),
          ),
      ...fields
          .where(_isNullableListRelation)
          .map((field) => _buildDetachRowFromListRelationField(
                className,
                field,
                classDefinition,
              )),
    ];
  }

  Method _buildDetachRowFromListRelationField(
    String className,
    SerializableEntityFieldDefinition field,
    ClassDefinition classDefinition,
  ) {
    return Method((methodBuilder) {
      var classFieldName = field.type.generics.first.className;
      var fieldName = field.type.generics.first.className.camelCase;

      var relation = field.relation as ListRelationDefinition;
      var foreignType = field.type.generics.first.reference(
        serverCode,
        nullable: false,
        subDirParts: classDefinition.subDirParts,
        config: config,
      );

      methodBuilder
        ..name = field.name
        ..requiredParameters.addAll([
          Parameter((parameterBuilder) {
            parameterBuilder
              ..name = 'session'
              ..type = refer('Session', 'package:serverpod/serverpod.dart');
          }),
          Parameter((parameterBuilder) {
            parameterBuilder
              ..name = fieldName
              ..type =
                  refer(classFieldName, 'package:serverpod/serverpod.dart');
          })
        ])
        ..returns = refer('Future<void>')
        ..modifier = MethodModifier.async
        ..body = relation.implicitForeignField
            ? _buildDetachRowImplementationBlockImplicitListRelation(
                className,
                fieldName,
                classFieldName,
                relation.foreignFieldName,
                foreignType,
              )
            : _buildDetachRowImplementationBlockExplicitListRelation(
                className,
                fieldName,
                classFieldName,
                relation.foreignFieldName,
                foreignType,
              );
      const Code('');
    });
  }

  Method _buildDetachRowFromObjectRelationField(
      String className,
      SerializableEntityFieldDefinition field,
      ClassDefinition classDefinition) {
    return Method((methodBuilder) {
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
              ..type = refer('Session', 'package:serverpod/serverpod.dart');
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
            ? _buildDetachRowImplementationBlockOriginSide(
                fieldName,
                classFieldName,
                relation.fieldName,
                className,
              )
            : _buildDetachRowImplementationBlockForeignSide(
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
    });
  }

  Block _buildDetachRowImplementationBlockOriginSide(
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
              _buildCopyWithSingleField(
                classFieldName,
                foreignKeyField,
                refer('null'),
              ),
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

  Block _buildDetachRowImplementationBlockForeignSide(
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
              _buildCopyWithSingleField(
                classFieldName,
                foreignKeyField,
                refer('null'),
              ),
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

  Block _buildDetachRowImplementationBlockExplicitListRelation(
    String className,
    String fieldName,
    String classFieldName,
    String foreignKeyField,
    Reference foreignClass,
  ) {
    return (BlockBuilder()
          ..statements.addAll(
            [
              _buildCodeBlockThrowIfIdIsNull(fieldName),
              const Code(''),
              _buildCopyWithSingleField(
                fieldName,
                foreignKeyField,
                refer('null'),
              ),
              _buildUpdateSingleField(
                fieldName,
                foreignKeyField,
                foreignClass,
                refer('null'),
              ),
            ],
          ))
        .build();
  }

  Block _buildDetachRowImplementationBlockImplicitListRelation(
    String className,
    String fieldName,
    String classFieldName,
    String foreignKeyField,
    Reference foreignClass,
  ) {
    return (BlockBuilder()
          ..statements.addAll(
            [
              _buildCodeBlockThrowIfIdIsNull(fieldName),
              const Code(''),
              _buildImplicitCopyClassSingleField(
                className,
                fieldName,
                foreignKeyField,
                refer('null'),
              ),
              _buildUpdateSingleField(
                fieldName,
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

  Block _buildCodeBlockThrowIfAnyIdIsNull(String className,
      [String? errorRef]) {
    return _buildCodeBlockThrowIfAnyFieldIsNull(className, 'id', errorRef);
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

  Block _buildCodeBlockThrowIfAnyFieldIsNull(
    String className,
    String nullCheckField, [
    String? errorRef,
  ]) {
    var error = errorRef ?? '$className.$nullCheckField';
    return Block.of([
      Code('if ($className.any((e) => e.$nullCheckField == null)) {'),
      refer('ArgumentError', 'dart:core')
          .property('notNull')
          .call([refer('\'$error\'')])
          .thrown
          .statement,
      const Code('}'),
    ]);
  }

  Code _buildCopyWithSingleField(
    String rowName,
    String fieldName,
    Expression assignment,
  ) {
    var localCopyVariable = '\$$rowName';
    return (BlockBuilder()
          ..statements.add(
            declareVar(localCopyVariable)
                .assign(refer(rowName).property('copyWith').call([], {
                  fieldName: assignment,
                }))
                .statement,
          ))
        .build();
  }

  Code _buildCopyWithListField(
    String rowName,
    String fieldName,
    Expression assignment,
  ) {
    var localCopyVariable = '\$$rowName';

    return (BlockBuilder()
          ..statements.add(
            declareVar(localCopyVariable)
                .assign(refer(rowName)
                    .property('map')
                    .call([
                      Method((b) => b
                        ..requiredParameters.add(Parameter((p) => p.name = 'e'))
                        ..body = refer('e').property('copyWith').call([], {
                          fieldName: assignment,
                        }).code).closure
                    ])
                    .property('toList')
                    .call([]))
                .statement,
          ))
        .build();
  }

  Code _buildImplicitCopyClassSingleField(
    String className,
    String rowName,
    String fieldName,
    Expression assignment,
  ) {
    var localCopyVariable = '\$$rowName';
    return (BlockBuilder()
          ..statements.add(
            declareVar(localCopyVariable)
                .assign(refer(
                  '${className}Implicit',
                  'package:serverpod/serverpod.dart',
                ).call([
                  refer(rowName)
                ], {
                  fieldName: assignment,
                }))
                .statement,
          ))
        .build();
  }

  Code _buildImplicitCopyClassListField(
    String className,
    String rowName,
    String fieldName,
    Expression assignment,
  ) {
    var localCopyVariable = '\$$rowName';

    return (BlockBuilder()
          ..statements.add(
            declareVar(localCopyVariable)
                .assign(refer(rowName)
                    .property('map')
                    .call([
                      Method((b) => b
                        ..requiredParameters.add(Parameter((p) => p.name = 'e'))
                        ..body = refer(
                          '${className}Implicit',
                          'package:serverpod/serverpod.dart',
                        ).call([
                          refer('e')
                        ], {
                          fieldName: assignment,
                        }).code).closure
                    ])
                    .property('toList')
                    .call([]))
                .statement,
          ))
        .build();
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
            refer('session')
                .property('dbNext')
                .property('updateRow')
                .call([
                  refer(localCopyVariable)
                ], {
                  'columns': literalList(
                    [classReference.property('t').property(fieldName)],
                  )
                }, [
                  classReference,
                ])
                .awaited
                .statement,
          ]))
        .build();
  }

  Code _buildUpdateListField(
    String rowName,
    String fieldName,
    Reference classReference,
    Expression assignment,
  ) {
    var localCopyVariable = '\$$rowName';
    return (BlockBuilder()
          ..statements.addAll([
            refer('session')
                .property('dbNext')
                .property('update')
                .call([
                  refer(localCopyVariable)
                ], {
                  'columns': literalList(
                    [classReference.property('t').property(fieldName)],
                  )
                }, [
                  classReference,
                ])
                .awaited
                .statement,
          ]))
        .build();
  }
}
