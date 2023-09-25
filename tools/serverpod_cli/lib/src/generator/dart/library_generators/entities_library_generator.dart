import 'package:code_builder/code_builder.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/repository_classes.dart';
import 'package:serverpod_cli/src/generator/shared.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

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

    var buildRepository = BuildRepositoryClass(
      serverCode: serverCode,
      config: config,
    );

    return Library(
      (libraryBuilder) {
        libraryBuilder.body.addAll([
          _buildEntityClass(
            className,
            classDefinition,
            tableName,
            fields,
          ),
          // We need to generate the implementation class for the copyWith method
          // to support differentiating between null and undefined values.
          // https://stackoverflow.com/questions/68009392/dart-custom-copywith-method-with-nullable-properties
          if (_shouldCreateUndefinedClass(fields)) _buildUndefinedClass(),
          _buildEntityImplClass(
            className,
            classDefinition,
            tableName,
            fields,
          ),
        ]);

        if (serverCode && tableName != null) {
          libraryBuilder.body.addAll([
            _buildExpressionBuilderTypeDef(
              className,
            ),
            _buildEntityTableClass(
              className,
              tableName,
              fields,
              classDefinition,
            ),
            _buildDeprecatedStaticTableInstance(
              className,
            ),
            _buildEntityIncludeClass(
              className,
              fields,
              classDefinition,
            ),
            buildRepository.buildEntityRepositoryClass(
              className,
              fields,
              classDefinition,
            ),
            if (buildRepository.hasAttachOperations(fields))
              buildRepository.buildEntityAttachRepositoryClass(
                className,
                fields,
                classDefinition,
              ),
            if (buildRepository.hasDetachOperations(fields))
              buildRepository.buildEntityDetachRepositoryClass(
                className,
                fields,
                classDefinition,
              ),
          ]);
        }
      },
    );
  }

  Class _buildEntityClass(
    String className,
    ClassDefinition classDefinition,
    String? tableName,
    List<SerializableEntityFieldDefinition> fields,
  ) {
    var objectRelationFields =
        fields.where((field) => field.relation is ObjectRelationDefinition);
    return Class((classBuilder) {
      classBuilder
        ..abstract = true
        ..name = className
        ..docs.addAll(classDefinition.documentation ?? []);

      if (classDefinition.isException) {
        classBuilder.implements
            .add(refer('SerializableException', serverpodUrl(serverCode)));
      }

      if (serverCode && tableName != null) {
        classBuilder.extend =
            refer('TableRow', 'package:serverpod/serverpod.dart');

        classBuilder.fields.addAll([
          _buildEntityClassTableField(className),
        ]);

        classBuilder.fields.add(_buildEntityClassDBField(className));

        classBuilder.methods.add(_buildEntityClassTableGetter());
      } else {
        classBuilder.extend =
            refer('SerializableEntity', serverpodUrl(serverCode));
      }

      classBuilder.fields.addAll(_buildEntityClassFields(
        fields,
        tableName,
        classDefinition.subDirParts,
      ));

      classBuilder.constructors.addAll([
        _buildEntityClassConstructor(classDefinition, fields, tableName),
        _buildEntityClassFactoryConstructor(
          className,
          classDefinition,
          fields,
          tableName,
        ),
        _buildEntityClassFromJsonConstructor(className, fields, classDefinition)
      ]);

      classBuilder.methods.add(_buildAbstractCopyWithMethod(
        className,
        classDefinition,
        fields,
      ));

      // Serialization
      classBuilder.methods.add(_buildEntityClassToJsonMethod(fields));

      // Serialization for database and everything
      if (serverCode) {
        if (tableName != null) {
          classBuilder.methods
              .add(_buildEntityClassToJsonForDatabaseMethod(fields));
        }

        classBuilder.methods.add(_buildEntityClassAllToJsonMethod(fields));

        if (tableName != null) {
          classBuilder.methods.addAll([
            _buildEntityClassSetColumnMethod(fields),
            _buildEntityClassFindMethod(className, objectRelationFields),
            _buildEntityClassFindSingleRowMethod(
              className,
              objectRelationFields,
            ),
            _buildEntityClassFindByIdMethod(className, objectRelationFields),
            _buildEntityClassDeleteMethod(className),
            _buildEntityClassDeleteRowMethod(className),
            _buildEntityClassUpdateMethod(className),
            _buildEntityClassInsertMethod(className),
            _buildEntityClassCountMethod(className),
            _buildEntityClassIncludeMethod(
              className,
              objectRelationFields,
              classDefinition.subDirParts,
            ),
          ]);
        }
      }
    });
  }

  bool _shouldCreateUndefinedClass(
      List<SerializableEntityFieldDefinition> fields) {
    return fields
        .where((field) => field.shouldIncludeField(serverCode))
        .any((field) => field.type.nullable);
  }

  Class _buildUndefinedClass() {
    return Class((classBuilder) => classBuilder.name = '_Undefined');
  }

  Class _buildEntityImplClass(
    String className,
    ClassDefinition classDefinition,
    String? tableName,
    List<SerializableEntityFieldDefinition> fields,
  ) {
    return Class((classBuilder) {
      classBuilder
        ..name = '_${className}Impl'
        ..extend = refer(className)
        ..constructors.add(
          _buildEntityImplClassConstructor(classDefinition, fields, tableName),
        )
        ..methods.add(_buildCopyWithMethod(classDefinition, fields));
    });
  }

  Method _buildAbstractCopyWithMethod(
    String className,
    ClassDefinition classDefinition,
    List<SerializableEntityFieldDefinition> fields,
  ) {
    return Method((methodBuilder) {
      methodBuilder
        ..name = 'copyWith'
        ..optionalParameters.addAll(
          _buildAbstractCopyWithParameters(classDefinition, fields),
        )
        ..returns = refer(className);
    });
  }

  Method _buildCopyWithMethod(
    ClassDefinition classDefinition,
    List<SerializableEntityFieldDefinition> fields,
  ) {
    return Method(
      (m) {
        m
          ..name = 'copyWith'
          ..annotations.add(refer('override'))
          ..optionalParameters.addAll(
            fields.where((field) => field.shouldIncludeField(serverCode)).map(
              (field) {
                var fieldType = field.type.reference(
                  serverCode,
                  nullable: true,
                  subDirParts: classDefinition.subDirParts,
                  config: config,
                );

                var type = field.type.nullable ? refer('Object?') : fieldType;
                var defaultValue =
                    field.type.nullable ? const Code('_Undefined') : null;

                return Parameter((p) {
                  p
                    ..name = field.name
                    ..named = true
                    ..type = type
                    ..defaultTo = defaultValue;
                });
              },
            ),
          )
          ..returns = refer(classDefinition.className)
          ..body = refer(classDefinition.className)
              .call(
                [],
                _buildCopyWithAssignment(classDefinition, fields),
              )
              .returned
              .statement;
      },
    );
  }

  Map<String, Expression> _buildCopyWithAssignment(
    ClassDefinition classDefinition,
    List<SerializableEntityFieldDefinition> fields,
  ) {
    return fields
        .where((field) => field.shouldIncludeField(serverCode))
        .fold({}, (map, field) {
      Expression assignment;

      if ((field.type.isEnum ||
          noneMutableTypeNames.contains(field.type.className))) {
        assignment = refer('this').property(field.name);
      } else if (clonableTypeNames.contains(field.type.className)) {
        assignment = _buildMaybeNullMethodCall(field, 'clone');
      } else {
        assignment = _buildMaybeNullMethodCall(field, 'copyWith');
      }

      Expression valueDefinition;

      if (field.type.nullable) {
        valueDefinition = refer(field.name)
            .isA(field.type.reference(
              serverCode,
              nullable: field.type.nullable,
              subDirParts: classDefinition.subDirParts,
              config: config,
            ))
            .conditional(
              refer(field.name),
              assignment,
            );
      } else {
        valueDefinition = refer(field.name).ifNullThen(
          assignment,
        );
      }

      return {
        ...map,
        field.name: valueDefinition,
      };
    });
  }

  Expression _buildMaybeNullMethodCall(
    SerializableEntityFieldDefinition field,
    String methodName,
  ) {
    if (field.type.nullable) {
      return refer('this')
          .property(field.name)
          .nullSafeProperty(methodName)
          .call([]);
    } else {
      return refer('this').property(field.name).property(methodName).call([]);
    }
  }

  Method _buildEntityClassTableGetter() {
    return Method(
      (m) => m
        ..name = 'table'
        ..annotations.add(refer('override'))
        ..type = MethodType.getter
        ..returns = refer('Table', serverpodUrl(serverCode))
        ..lambda = true
        ..body = const Code('t'),
    );
  }

  Field _buildEntityClassTableField(String className) {
    return Field((f) => f
      ..static = true
      ..modifier = FieldModifier.final$
      ..name = 't'
      ..assignment = refer('${className}Table').call([]).code);
  }

  Field _buildEntityClassDBField(String className) {
    return Field((f) => f
      ..static = true
      ..modifier = FieldModifier.final$
      ..name = 'db'
      ..assignment =
          refer('${className}Repository').property('_').call([]).code);
  }

  Method _buildEntityClassIncludeMethod(
      String className,
      Iterable<SerializableEntityFieldDefinition> objectRelationFields,
      List<String> subDirParts) {
    return Method(
      (m) => m
        ..static = true
        ..name = 'include'
        ..returns = TypeReference((r) => r..symbol = '${className}Include')
        ..optionalParameters.addAll([
          for (var field in objectRelationFields)
            Parameter(
              (p) => p
                ..type = field.type.reference(
                  serverCode,
                  subDirParts: subDirParts,
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
    );
  }

  Method _buildEntityClassCountMethod(String className) {
    return Method((m) => m
      ..annotations.addAll([
        refer("Deprecated('Will be removed in 2.0.0. Use: db.count instead.')")
      ])
      ..static = true
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
            'where': refer('where').notEqualTo(refer('null')).conditional(
                refer('where').call([refer(className).property('t')]),
                refer('null')),
            'limit': refer('limit'),
            'useCache': refer('useCache'),
            'transaction': refer('transaction'),
          }, [
            refer(className)
          ])
          .returned
          .statement);
  }

  Method _buildEntityClassInsertMethod(String className) {
    return Method((m) => m
      ..annotations.addAll([
        refer("Deprecated('Will be removed in 2.0.0. Use: db.insert instead.')")
      ])
      ..static = true
      ..name = 'insert'
      ..returns = TypeReference(
        (r) => r
          ..symbol = 'Future'
          ..types.add(refer('void')),
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
          .property('db')
          .property('insert')
          .call([
            refer('row')
          ], {
            'transaction': refer('transaction'),
          })
          .returned
          .statement);
  }

  Method _buildEntityClassUpdateMethod(String className) {
    return Method((m) => m
      ..annotations.addAll([
        refer("Deprecated('Will be removed in 2.0.0. Use: db.update instead.')")
      ])
      ..static = true
      ..name = 'update'
      ..returns = TypeReference(
        (r) => r
          ..symbol = 'Future'
          ..types.add(refer('bool')),
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
          .property('db')
          .property('update')
          .call([
            refer('row')
          ], {
            'transaction': refer('transaction'),
          })
          .returned
          .statement);
  }

  Method _buildEntityClassDeleteRowMethod(String className) {
    return Method((m) => m
      ..annotations.addAll([
        refer(
            "Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')")
      ])
      ..static = true
      ..name = 'deleteRow'
      ..returns = TypeReference(
        (r) => r
          ..symbol = 'Future'
          ..types.add(refer('bool')),
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
          .property('db')
          .property('deleteRow')
          .call([
            refer('row')
          ], {
            'transaction': refer('transaction'),
          })
          .returned
          .statement);
  }

  Method _buildEntityClassDeleteMethod(String className) {
    return Method((m) => m
      ..annotations.addAll([
        refer(
            "Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')")
      ])
      ..static = true
      ..name = 'delete'
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
            'where': refer('where').call([refer(className).property('t')]),
            'transaction': refer('transaction'),
          }, [
            refer(className)
          ])
          .returned
          .statement);
  }

  Method _buildEntityClassFindByIdMethod(String className,
      Iterable<SerializableEntityFieldDefinition> objectRelationFields) {
    return Method((m) => m
      ..annotations.addAll([
        refer(
            "Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')")
      ])
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
          ..type = refer('Session', 'package:serverpod/serverpod.dart')
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
              if (objectRelationFields.isNotEmpty) 'include': refer('include'),
            },
            [refer(className)],
          )
          .returned
          .statement);
  }

  Method _buildEntityClassFindSingleRowMethod(String className,
      Iterable<SerializableEntityFieldDefinition> objectRelationFields) {
    return Method((m) => m
      ..annotations.addAll([
        refer(
            "Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')")
      ])
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
            'where': refer('where').notEqualTo(refer('null')).conditional(
                refer('where').call([refer(className).property('t')]),
                refer('null')),
            'offset': refer('offset'),
            'orderBy': refer('orderBy'),
            'orderDescending': refer('orderDescending'),
            'useCache': refer('useCache'),
            'transaction': refer('transaction'),
            if (objectRelationFields.isNotEmpty) 'include': refer('include'),
          }, [
            refer(className)
          ])
          .returned
          .statement);
  }

  Method _buildEntityClassFindMethod(
    String className,
    Iterable<SerializableEntityFieldDefinition> objectRelationFields,
  ) {
    return Method((m) => m
      ..annotations.addAll([
        refer("Deprecated('Will be removed in 2.0.0. Use: db.find instead.')")
      ])
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
          ..type = TypeReference((t) => t
            ..symbol = 'List'
            ..isNullable = true
            ..types.add(refer('Order', 'package:serverpod/serverpod.dart')))
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
            'where': refer('where').notEqualTo(refer('null')).conditional(
                refer('where').call([refer(className).property('t')]),
                refer('null')),
            'limit': refer('limit'),
            'offset': refer('offset'),
            'orderBy': refer('orderBy'),
            'orderByList': refer('orderByList'),
            'orderDescending': refer('orderDescending'),
            'useCache': refer('useCache'),
            'transaction': refer('transaction'),
            if (objectRelationFields.isNotEmpty) 'include': refer('include'),
          }, [
            refer(className)
          ])
          .returned
          .statement);
  }

  Method _buildEntityClassSetColumnMethod(
      List<SerializableEntityFieldDefinition> fields) {
    var serializableFields =
        fields.where((f) => f.shouldSerializeFieldForDatabase(serverCode));

    return Method((m) => m
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
        for (var field in serializableFields)
          Block.of([
            Code('case \'${field.name}\':'),
            _createSerializableFieldNameReference(serverCode, field)
                .assign(refer('value'))
                .statement,
            refer('').returned.statement,
          ]),
        const Code('default:'),
        refer('UnimplementedError').call([]).thrown.statement,
        const Code('}'),
      ]));
  }

  Method _buildEntityClassAllToJsonMethod(
      List<SerializableEntityFieldDefinition> fields) {
    return Method(
      (m) {
        m.returns = refer('Map<String,dynamic>');
        m.name = 'allToJson';
        m.annotations.add(refer('override'));

        m.body = literalMap(
          {
            for (var field in fields)
              literalString(field.name):
                  _createSerializableFieldNameReference(serverCode, field)
          },
        ).returned.statement;
      },
    );
  }

  Method _buildEntityClassToJsonForDatabaseMethod(
      List<SerializableEntityFieldDefinition> fields) {
    var serializableFields =
        fields.where((f) => f.shouldSerializeFieldForDatabase(serverCode));

    return Method(
      (m) {
        m.returns = refer('Map<String,dynamic>');
        m.name = 'toJsonForDatabase';
        m.annotations.addAll([
          refer('override'),
          refer("Deprecated('Will be removed in 2.0.0')")
        ]);

        m.body = literalMap(
          {
            for (var field in serializableFields)
              literalString(field.name):
                  _createSerializableFieldNameReference(serverCode, field)
          },
        ).returned.statement;
      },
    );
  }

  Method _buildEntityClassToJsonMethod(
      List<SerializableEntityFieldDefinition> fields) {
    return Method(
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
    );
  }

  Constructor _buildEntityClassFromJsonConstructor(
      String className,
      List<SerializableEntityFieldDefinition> fields,
      ClassDefinition classDefinition) {
    return Constructor((c) {
      c.factory = true;
      c.name = 'fromJson';
      c.requiredParameters.addAll([
        Parameter((p) {
          p.name = 'jsonSerialization';
          p.type = refer('Map<String,dynamic>');
        }),
        Parameter((p) {
          p.name = 'serializationManager';
          p.type = refer('SerializationManager', serverpodUrl(serverCode));
        }),
      ]);
      c.body = refer(className)
          .call([], {
            for (var field in fields)
              if (field.shouldIncludeField(serverCode))
                field.name:
                    refer('serializationManager').property('deserialize').call([
                  refer('jsonSerialization').index(literalString(field.name))
                ], {}, [
                  field.type.reference(serverCode,
                      subDirParts: classDefinition.subDirParts, config: config)
                ])
          })
          .returned
          .statement;
    });
  }

  Constructor _buildEntityClassConstructor(
    ClassDefinition classDefinition,
    List<SerializableEntityFieldDefinition> fields,
    String? tableName,
  ) {
    return Constructor((c) {
      c.name = '_';
      c.optionalParameters.addAll(_buildEntityClassConstructorParameters(
        classDefinition,
        fields,
        tableName,
        setAsToThis: true,
      ));

      if (serverCode && tableName != null) {
        c.initializers.add(refer('super').call([refer('id')]).code);
      }
    });
  }

  Constructor _buildEntityClassFactoryConstructor(
    String className,
    ClassDefinition classDefinition,
    List<SerializableEntityFieldDefinition> fields,
    String? tableName,
  ) {
    return Constructor((c) {
      c.factory = true;
      c.optionalParameters.addAll(_buildEntityClassConstructorParameters(
        classDefinition,
        fields,
        tableName,
        setAsToThis: false,
      ));

      c.redirect = refer('_${className}Impl');
    });
  }

  Constructor _buildEntityImplClassConstructor(
    ClassDefinition classDefinition,
    List<SerializableEntityFieldDefinition> fields,
    String? tableName,
  ) {
    return Constructor((c) {
      c.optionalParameters.addAll(_buildEntityClassConstructorParameters(
        classDefinition,
        fields,
        tableName,
        setAsToThis: false,
      ));

      Map<String, Expression> namedParams = fields
          .where((field) => field.shouldIncludeField(serverCode))
          .fold({}, (map, field) {
        return {
          ...map,
          field.name: refer(field.name),
        };
      });

      c.initializers.add(refer('super._').call([], namedParams).code);
    });
  }

  List<Parameter> _buildEntityClassConstructorParameters(
    ClassDefinition classDefinition,
    List<SerializableEntityFieldDefinition> fields,
    String? tableName, {
    required bool setAsToThis,
  }) {
    return fields
        .where((field) => field.shouldIncludeField(serverCode))
        .map((field) {
      bool hasPrimaryKey =
          field.name == 'id' && tableName != null && serverCode;

      bool shouldIncludeType = !setAsToThis || hasPrimaryKey;
      var type = field.type.reference(
        serverCode,
        nullable: field.type.nullable,
        subDirParts: classDefinition.subDirParts,
        config: config,
      );

      return Parameter(
        (p) => p
          ..named = true
          ..required = !field.type.nullable
          ..type = shouldIncludeType ? type : null
          ..toThis = !shouldIncludeType
          ..name = field.name,
      );
    }).toList();
  }

  List<Parameter> _buildAbstractCopyWithParameters(
    ClassDefinition classDefinition,
    List<SerializableEntityFieldDefinition> fields,
  ) {
    return fields
        .where((field) => field.shouldIncludeField(serverCode))
        .map((field) {
      var type = field.type.reference(
        serverCode,
        nullable: true,
        subDirParts: classDefinition.subDirParts,
        config: config,
      );

      return Parameter(
        (p) => p
          ..named = true
          ..type = type
          ..name = field.name,
      );
    }).toList();
  }

  List<Field> _buildEntityClassFields(
      List<SerializableEntityFieldDefinition> fields,
      String? tableName,
      List<String> subDirParts) {
    List<Field> entityClassFields = [];
    var classFields = fields
        .where((f) =>
            f.shouldIncludeField(serverCode) ||
            (tableName != null && f.hiddenSerializableField(serverCode)))
        .where((f) => !(f.name == 'id' && serverCode && tableName != null));

    for (var field in classFields) {
      entityClassFields.add(Field((f) {
        f.type = field.type
            .reference(serverCode, subDirParts: subDirParts, config: config);
        f
          ..name =
              _createSerializableFieldNameReference(serverCode, field).symbol
          ..docs.addAll(field.documentation ?? []);
      }));
    }

    return entityClassFields;
  }

  Code _buildExpressionBuilderTypeDef(String className) {
    return FunctionType(
      (f) {
        f.returnType = refer('Expression', serverpodUrl(serverCode));
        f.requiredParameters.add(refer('${className}Table'));
      },
    ).toTypeDef('${className}ExpressionBuilder');
  }

  Class _buildEntityTableClass(
      String className,
      String tableName,
      List<SerializableEntityFieldDefinition> fields,
      ClassDefinition classDefinition) {
    return Class((c) {
      c.name = '${className}Table';
      c.extend = refer('Table', serverpodUrl(serverCode));

      c.constructors.add(_buildEntityTableClassConstructor(
          tableName, fields, classDefinition));

      // TODO - Fields and getters should be separated
      _buildEntityTableClassFieldsAndGetters(fields, c, classDefinition);

      c.methods.add(_buildEntityTableClassColumnGetter(fields));

      var objectRelationFields =
          fields.where((f) => f.relation is ObjectRelationDefinition);
      if (objectRelationFields.isNotEmpty) {
        c.methods
            .add(_buildEntityTableClassGetRelationTable(objectRelationFields));
      }
    });
  }

  Method _buildEntityTableClassGetRelationTable(
      Iterable<SerializableEntityFieldDefinition> objectRelationFields) {
    return Method(
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
                      return refer(objectRelationField.name).returned.statement;
                    }),
                    const Code('}'),
                  ]),
                const Code('return null;'),
              ]))
            .build(),
    );
  }

  Method _buildEntityTableClassColumnGetter(
      List<SerializableEntityFieldDefinition> fields) {
    return Method(
      (m) => m
        ..annotations.add(refer('override'))
        ..returns = TypeReference((t) => t
          ..symbol = 'List'
          ..types.add(refer('Column', 'package:serverpod/serverpod.dart')))
        ..name = 'columns'
        ..lambda = true
        ..type = MethodType.getter
        ..body = literalList([
          for (var field in fields)
            if (field.shouldSerializeFieldForDatabase(serverCode))
              refer(field.name)
        ]).code,
    );
  }

  void _buildEntityTableClassFieldsAndGetters(
      List<SerializableEntityFieldDefinition> fields,
      ClassBuilder c,
      ClassDefinition classDefinition) {
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
                  'column': refer(objectRelation.fieldName),
                  'foreignColumnName': field.type
                      .reference(
                        serverCode,
                        subDirParts: classDefinition.subDirParts,
                        config: config,
                        nullable: false,
                      )
                      .property('t')
                      .property(objectRelation.foreignFieldName)
                      .property('columnName'),
                  'createTable': Method((m) => m
                    ..requiredParameters.addAll([
                      Parameter((p) => p..name = 'relationQueryPrefix'),
                      Parameter((p) => p..name = 'foreignTableRelation'),
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
  }

  Constructor _buildEntityTableClassConstructor(
      String tableName,
      List<SerializableEntityFieldDefinition> fields,
      ClassDefinition classDefinition) {
    return Constructor((constructorBuilder) {
      constructorBuilder.optionalParameters.add(
        Parameter(
          (p) => p
            ..name = 'queryPrefix'
            ..toSuper = true
            ..named = true,
        ),
      );
      constructorBuilder.optionalParameters.add(
        Parameter(
          (p) => p
            ..name = 'tableRelations'
            ..toSuper = true
            ..named = true,
        ),
      );
      constructorBuilder.initializers.add(refer('super')
          .call([], {'tableName': literalString(tableName)}).code);

      constructorBuilder.body = Block.of([
        for (var field in fields.where(
            (field) => field.shouldSerializeFieldForDatabase(serverCode)))
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
                  'tableRelations': refer('super').property('tableRelations')
                }))
                .statement,
      ]);
    });
  }

  Field _buildDeprecatedStaticTableInstance(String className) {
    return Field((f) => f
      ..annotations.add(refer('Deprecated')
          .call([literalString('Use ${className}Table.t instead.')]))
      ..name = 't$className'
      ..type = refer('${className}Table')
      ..assignment = refer('${className}Table').call([]).code);
  }

  Class _buildEntityIncludeClass(
    String className,
    List<SerializableEntityFieldDefinition> fields,
    ClassDefinition classDefinition,
  ) {
    return Class(((c) {
      c.extend = refer('Include', 'package:serverpod/serverpod.dart');
      c.name = '${className}Include';
      var objectRelationFields =
          fields.where((f) => f.relation is ObjectRelationDefinition).toList();

      c.constructors.add(_buildEntityIncludeClassConstructor(
        objectRelationFields,
        classDefinition,
      ));

      c.fields.addAll(_buildEntityIncludeClassFields(
        objectRelationFields,
        classDefinition,
      ));

      c.methods.addAll([
        _buildEntityIncludeClassIncludesGetter(objectRelationFields),
        _buildEntityIncludeClassTableGetter(className),
      ]);
    }));
  }

  Method _buildEntityIncludeClassTableGetter(String className) {
    return Method(
      (m) => m
        ..annotations.add(refer('override'))
        ..returns = TypeReference((t) => t
          ..symbol = 'Table'
          ..url = serverpodUrl(serverCode))
        ..name = 'table'
        ..lambda = true
        ..type = MethodType.getter
        ..body = refer('$className.t').code,
    );
  }

  Method _buildEntityIncludeClassIncludesGetter(
      List<SerializableEntityFieldDefinition> objectRelationFields) {
    return Method(
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
            literalString(field.name): refer('_${field.name}')
        }).code,
    );
  }

  List<Field> _buildEntityIncludeClassFields(
      List<SerializableEntityFieldDefinition> objectRelationFields,
      ClassDefinition classDefinition) {
    List<Field> entityIncludeClassFields = [];
    for (var field in objectRelationFields) {
      entityIncludeClassFields.add(Field((f) => f
        ..name = '_${field.name}'
        ..type = field.type.reference(
          serverCode,
          subDirParts: classDefinition.subDirParts,
          config: config,
          typeSuffix: 'Include',
        )));
    }
    return entityIncludeClassFields;
  }

  Constructor _buildEntityIncludeClassConstructor(
    List<SerializableEntityFieldDefinition> objectRelationFields,
    ClassDefinition classDefinition,
  ) {
    return Constructor((constructorBuilder) {
      constructorBuilder.name = '_';
      if (objectRelationFields.isEmpty) {
        return;
      }

      for (var field in objectRelationFields) {
        constructorBuilder.optionalParameters.add(Parameter(
          (p) => p
            ..name = field.name
            ..type = field.type.reference(
              serverCode,
              subDirParts: classDefinition.subDirParts,
              config: config,
              typeSuffix: 'Include',
            )
            ..named = true,
        ));
      }

      constructorBuilder.body = Block.of([
        for (var field in objectRelationFields)
          refer('_${field.name}').assign(refer(field.name)).statement,
      ]);
    });
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

  Reference _createSerializableFieldNameReference(
    bool serverCode,
    SerializableEntityFieldDefinition field,
  ) {
    if (field.hiddenSerializableField(serverCode) &&
        !field.name.startsWith('_')) {
      return refer('_${field.name}');
    }

    return refer(field.name);
  }
}
