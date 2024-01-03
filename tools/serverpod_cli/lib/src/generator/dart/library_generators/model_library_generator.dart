import 'package:code_builder/code_builder.dart';
import 'package:recase/recase.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/class_generators/repository_classes.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/class_generators_util.dart';
import 'package:serverpod_cli/src/generator/shared.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

/// Generates the dart libraries for [SerializableModelDefinition]s.
class SerializableModelLibraryGenerator {
  final bool serverCode;
  final GeneratorConfig config;

  SerializableModelLibraryGenerator({
    required this.serverCode,
    required this.config,
  });

  /// Generate the file for a model.
  Library generateModelLibrary(SerializableModelDefinition modelDefinition) {
    if (modelDefinition is ClassDefinition) {
      return _generateClassLibrary(modelDefinition);
    }
    if (modelDefinition is EnumDefinition) {
      return _generateEnumLibrary(modelDefinition);
    }

    throw Exception('Unsupported model type.');
  }

  /// Handle ordinary classes for [generateModelLibrary].
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
          _buildModelClass(
            className,
            classDefinition,
            tableName,
            fields,
          ),
          // We need to generate the implementation class for the copyWith method
          // to support differentiating between null and undefined values.
          // https://stackoverflow.com/questions/68009392/dart-custom-copywith-method-with-nullable-properties
          if (_shouldCreateUndefinedClass(fields)) _buildUndefinedClass(),
          _buildModelImplClass(
            className,
            classDefinition,
            tableName,
            fields,
          ),
          if (buildRepository.hasImplicitClassOperations(fields))
            _buildModelImplicitClass(className, classDefinition),
        ]);

        if (serverCode && tableName != null) {
          libraryBuilder.body.addAll([
            _buildModelTableClass(
              className,
              tableName,
              fields,
              classDefinition,
            ),
            _buildDeprecatedStaticTableInstance(
              className,
            ),
            _buildModelIncludeClass(
              className,
              fields,
              classDefinition,
            ),
            _buildModelIncludeListClass(
              className,
              fields,
              classDefinition,
            ),
            buildRepository.buildModelRepositoryClass(
              className,
              fields,
              classDefinition,
            ),
            if (buildRepository.hasAttachOperations(fields))
              buildRepository.buildModelAttachRepositoryClass(
                className,
                fields,
                classDefinition,
              ),
            if (buildRepository.hasAttachRowOperations(fields))
              buildRepository.buildModelAttachRowRepositoryClass(
                className,
                fields,
                classDefinition,
              ),
            if (buildRepository.hasDetachOperations(fields))
              buildRepository.buildModelDetachRepositoryClass(
                className,
                fields,
                classDefinition,
              ),
            if (buildRepository.hasDetachRowOperations(fields))
              buildRepository.buildModelDetachRowRepositoryClass(
                className,
                fields,
                classDefinition,
              ),
          ]);
        }
      },
    );
  }

  Class _buildModelClass(
    String className,
    ClassDefinition classDefinition,
    String? tableName,
    List<SerializableModelFieldDefinition> fields,
  ) {
    var relationFields = fields.where((field) =>
        field.relation is ObjectRelationDefinition ||
        field.relation is ListRelationDefinition);
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
          _buildModelClassTableField(className),
        ]);

        classBuilder.fields.add(_buildModelClassDBField(className));

        classBuilder.methods.add(_buildModelClassTableGetter());
      } else {
        classBuilder.extend =
            refer('SerializableEntity', serverpodUrl(serverCode));
      }

      classBuilder.fields.addAll(_buildModelClassFields(
        fields,
        tableName,
        classDefinition.subDirParts,
      ));

      classBuilder.constructors.addAll([
        _buildModelClassConstructor(classDefinition, fields, tableName),
        _buildModelClassFactoryConstructor(
          className,
          classDefinition,
          fields,
          tableName,
        ),
        _buildModelClassFromJsonConstructor(className, fields, classDefinition)
      ]);

      classBuilder.methods.add(_buildAbstractCopyWithMethod(
        className,
        classDefinition,
        fields,
      ));

      // Serialization
      classBuilder.methods.add(_buildModelClassToJsonMethod(fields));

      // Serialization for database and everything
      if (serverCode) {
        if (tableName != null) {
          classBuilder.methods
              .add(_buildModelClassToJsonForDatabaseMethod(fields));
        }

        classBuilder.methods.add(_buildModelClassAllToJsonMethod(fields));

        if (tableName != null) {
          classBuilder.methods.addAll([
            _buildModelClassSetColumnMethod(fields),
            _buildModelClassFindMethod(className, relationFields),
            _buildModelClassFindSingleRowMethod(
              className,
              relationFields,
            ),
            _buildModelClassFindByIdMethod(className, relationFields),
            _buildModelClassDeleteMethod(className),
            _buildModelClassDeleteRowMethod(className),
            _buildModelClassUpdateMethod(className),
            _buildModelClassInsertMethod(className),
            _buildModelClassCountMethod(className),
            _buildModelClassIncludeMethod(
              className,
              relationFields,
              classDefinition.subDirParts,
            ),
            _buildModelClassIncludeListMethod(
              className,
            ),
          ]);
        }
      }
    });
  }

  bool _shouldCreateUndefinedClass(
      List<SerializableModelFieldDefinition> fields) {
    return fields
        .where((field) => field.shouldIncludeField(serverCode))
        .any((field) => field.type.nullable);
  }

  Class _buildUndefinedClass() {
    return Class((classBuilder) => classBuilder.name = '_Undefined');
  }

  Class _buildModelImplClass(
    String className,
    ClassDefinition classDefinition,
    String? tableName,
    List<SerializableModelFieldDefinition> fields,
  ) {
    return Class((classBuilder) {
      classBuilder
        ..name = '_${className}Impl'
        ..extend = refer(className)
        ..constructors.add(
          _buildModelImplClassConstructor(classDefinition, fields, tableName),
        )
        ..methods.add(_buildCopyWithMethod(classDefinition, fields));
    });
  }

  Class _buildModelImplicitClass(
    String className,
    ClassDefinition classDefinition,
  ) {
    var hiddenFields = classDefinition.fields
        .where((field) => field.hiddenSerializableField(serverCode));
    var visibleFields = classDefinition.fields
        .where((field) => field.shouldIncludeField(serverCode));
    return Class((classBuilder) {
      classBuilder
        ..name = '${className}Implicit'
        ..extend = refer('_${className}Impl')
        ..fields.addAll(hiddenFields.map((field) {
          return Field((fieldBuilder) {
            fieldBuilder
              ..name = createFieldName(serverCode, field)
              ..type = field.type.reference(
                serverCode,
                config: config,
              );
          });
        }))
        ..constructors.add(Constructor((constructorBuilder) {
          Map<String, Expression> namedParams =
              visibleFields.fold({}, (map, field) {
            return {
              ...map,
              field.name: refer(field.name),
            };
          });

          constructorBuilder
            ..name = '_'
            ..optionalParameters.addAll(
              _buildModelClassConstructorParameters(
                classDefinition,
                classDefinition.fields,
                classDefinition.tableName,
                setAsToThis: false,
              ),
            )
            ..optionalParameters.addAll(hiddenFields.map((field) {
              return Parameter(
                (p) => p
                  ..name = createFieldName(serverCode, field)
                  ..named = true
                  ..toThis = true,
              );
            }))
            ..initializers.add(refer('super').call([], namedParams).code);
        }))
        ..constructors.add(Constructor((constructorBuilder) {
          constructorBuilder
            ..factory = true
            ..requiredParameters.add(Parameter((p) => p
              ..name = className.camelCase
              ..type = refer(className)))
            ..optionalParameters.addAll(hiddenFields.map((field) {
              return Parameter((p) => p
                ..name = createFieldName(serverCode, field)
                ..named = true
                ..type = field.type.reference(serverCode, config: config));
            }))
            ..body = Block((blockBuilder) {
              blockBuilder.statements.add(refer('${className}Implicit')
                  .property('_')
                  .call([], {
                    ...visibleFields.fold({}, (map, field) {
                      return {
                        ...map,
                        field.name:
                            refer(className.camelCase).property(field.name),
                      };
                    }),
                    ...hiddenFields.fold({}, (map, field) {
                      return {
                        ...map,
                        createFieldName(serverCode, field):
                            refer(createFieldName(serverCode, field)),
                      };
                    })
                  })
                  .returned
                  .statement);
            });
        }))
        ..methods.add(Method((methodBuilder) {
          methodBuilder
            ..name = 'allToJson'
            ..annotations.add(refer('override'))
            ..returns = refer('Map<String, dynamic>')
            ..body = Block((blockBuilder) {
              blockBuilder.statements.add(
                refer('var jsonMap')
                    .assign(refer('super').property('allToJson').call([]))
                    .statement,
              );

              var values = hiddenFields.fold({}, (map, field) {
                return {
                  ...map,
                  "'${field.name}'": createFieldName(serverCode, field),
                };
              });

              blockBuilder.statements.add(
                refer('jsonMap').property('addAll').call(
                  [refer('$values')],
                ).statement,
              );
              blockBuilder.statements.add(refer('jsonMap').returned.statement);
            });
        }));
    });
  }

  Method _buildAbstractCopyWithMethod(
    String className,
    ClassDefinition classDefinition,
    List<SerializableModelFieldDefinition> fields,
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
    List<SerializableModelFieldDefinition> fields,
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
    List<SerializableModelFieldDefinition> fields,
  ) {
    return fields
        .where((field) => field.shouldIncludeField(serverCode))
        .fold({}, (map, field) {
      Expression assignment;

      if ((field.type.isEnumType ||
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
    SerializableModelFieldDefinition field,
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

  Method _buildModelClassTableGetter() {
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

  Field _buildModelClassTableField(String className) {
    return Field((f) => f
      ..static = true
      ..modifier = FieldModifier.final$
      ..name = 't'
      ..assignment = refer('${className}Table').call([]).code);
  }

  Field _buildModelClassDBField(String className) {
    return Field((f) => f
      ..static = true
      ..modifier = FieldModifier.constant
      ..name = 'db'
      ..assignment =
          refer('${className}Repository').property('_').call([]).code);
  }

  Method _buildModelClassIncludeMethod(
      String className,
      Iterable<SerializableModelFieldDefinition> relationFields,
      List<String> subDirParts) {
    return Method(
      (m) => m
        ..static = true
        ..name = 'include'
        ..returns = TypeReference((r) => r..symbol = '${className}Include')
        ..optionalParameters.addAll(
          relationFields.map((field) {
            var type = field.type.reference(
              serverCode,
              subDirParts: subDirParts,
              config: config,
              typeSuffix: 'Include',
              nullable: true,
            );

            if (field.relation is ListRelationDefinition) {
              type = field.type.generics.first.reference(
                serverCode,
                subDirParts: subDirParts,
                config: config,
                typeSuffix: 'IncludeList',
                nullable: true,
              );
            }

            return Parameter(
              (p) => p
                ..type = type
                ..name = field.name
                ..named = true,
            );
          }),
        )
        ..body = refer('${className}Include')
            .property('_')
            .call([], {
              for (var field in relationFields) field.name: refer(field.name),
            })
            .returned
            .statement,
    );
  }

  Method _buildModelClassIncludeListMethod(String className) {
    return Method(
      (m) => m
        ..static = true
        ..name = 'includeList'
        ..returns = TypeReference((r) => r..symbol = '${className}IncludeList')
        ..optionalParameters.addAll([
          Parameter(
            (p) => p
              ..name = 'where'
              ..type = typeWhereExpressionBuilder(
                className,
                serverCode,
              )
              ..named = true,
          ),
          Parameter(
            (p) => p
              ..name = 'limit'
              ..named = true
              ..type = refer('int?'),
          ),
          Parameter(
            (p) => p
              ..name = 'offset'
              ..named = true
              ..type = refer('int?'),
          ),
          Parameter(
            (p) => p
              ..name = 'orderBy'
              ..named = true
              ..type = typeOrderByBuilder(className, serverCode),
          ),
          Parameter(
            (p) => p
              ..name = 'orderDescending'
              ..named = true
              ..defaultTo = const Code('false')
              ..type = refer('bool'),
          ),
          Parameter(
            (p) => p
              ..name = 'orderByList'
              ..named = true
              ..type = typeOrderByListBuilder(className, serverCode),
          ),
          Parameter((p) => p
            ..name = 'include'
            ..named = true
            ..type = refer('${className}Include?'))
        ])
        ..body = refer('${className}IncludeList')
            .property('_')
            .call([], {
              'where': refer('where'),
              'limit': refer('limit'),
              'offset': refer('offset'),
              'orderBy': refer('orderBy').nullSafeProperty('call').call(
                [refer(className).property('t')],
              ),
              'orderDescending': refer('orderDescending'),
              'orderByList': refer('orderByList').nullSafeProperty('call').call(
                [refer(className).property('t')],
              ),
              'include': refer('include'),
            })
            .returned
            .statement,
    );
  }

  Method _buildModelClassCountMethod(String className) {
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
          ..type = typeWhereExpressionBuilder(
            className,
            serverCode,
          )
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

  Method _buildModelClassInsertMethod(String className) {
    return Method((m) => m
      ..annotations.addAll([
        refer(
            "Deprecated('Will be removed in 2.0.0. Use: db.insert instead. Important note: In db.insert, the object you pass in is no longer modified, instead a new copy with the added row is returned which contains the inserted id.')")
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

  Method _buildModelClassUpdateMethod(String className) {
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

  Method _buildModelClassDeleteRowMethod(String className) {
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

  Method _buildModelClassDeleteMethod(String className) {
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
          ..type = typeWhereExpressionBuilder(
            className,
            serverCode,
            nullable: false,
          )
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

  Method _buildModelClassFindByIdMethod(String className,
      Iterable<SerializableModelFieldDefinition> objectRelationFields) {
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

  Method _buildModelClassFindSingleRowMethod(String className,
      Iterable<SerializableModelFieldDefinition> objectRelationFields) {
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
          ..type = typeWhereExpressionBuilder(
            className,
            serverCode,
          )
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

  Method _buildModelClassFindMethod(
    String className,
    Iterable<SerializableModelFieldDefinition> objectRelationFields,
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
          ..type = typeWhereExpressionBuilder(
            className,
            serverCode,
          )
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

  Method _buildModelClassSetColumnMethod(
      List<SerializableModelFieldDefinition> fields) {
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

  Method _buildModelClassAllToJsonMethod(
      List<SerializableModelFieldDefinition> fields) {
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

  Method _buildModelClassToJsonForDatabaseMethod(
      List<SerializableModelFieldDefinition> fields) {
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

  Method _buildModelClassToJsonMethod(
      List<SerializableModelFieldDefinition> fields) {
    return Method(
      (m) {
        m.returns = refer('Map<String,dynamic>');
        m.name = 'toJson';
        m.annotations.add(refer('override'));

        var fieldExprs = fields
            .where((field) => field.shouldSerializeField(serverCode))
            .map((field) =>
                '${field.type.nullable ? 'if (${field.name} != null) ' : ''}'
                '\'${field.name}\':${field.name}')
            .join(',');

        m.body =
            Code('return { ${fieldExprs.isEmpty ? '' : '$fieldExprs,'} };');
      },
    );
  }

  Constructor _buildModelClassFromJsonConstructor(
      String className,
      List<SerializableModelFieldDefinition> fields,
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

  Constructor _buildModelClassConstructor(
    ClassDefinition classDefinition,
    List<SerializableModelFieldDefinition> fields,
    String? tableName,
  ) {
    return Constructor((c) {
      c.name = '_';
      c.optionalParameters.addAll(_buildModelClassConstructorParameters(
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

  Constructor _buildModelClassFactoryConstructor(
    String className,
    ClassDefinition classDefinition,
    List<SerializableModelFieldDefinition> fields,
    String? tableName,
  ) {
    return Constructor((c) {
      c.factory = true;
      c.optionalParameters.addAll(_buildModelClassConstructorParameters(
        classDefinition,
        fields,
        tableName,
        setAsToThis: false,
      ));

      c.redirect = refer('_${className}Impl');
    });
  }

  Constructor _buildModelImplClassConstructor(
    ClassDefinition classDefinition,
    List<SerializableModelFieldDefinition> fields,
    String? tableName,
  ) {
    return Constructor((c) {
      c.optionalParameters.addAll(_buildModelClassConstructorParameters(
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

  List<Parameter> _buildModelClassConstructorParameters(
    ClassDefinition classDefinition,
    List<SerializableModelFieldDefinition> fields,
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
    List<SerializableModelFieldDefinition> fields,
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

  List<Field> _buildModelClassFields(
      List<SerializableModelFieldDefinition> fields,
      String? tableName,
      List<String> subDirParts) {
    List<Field> modelClassFields = [];
    var classFields = fields
        .where((f) =>
            f.shouldIncludeField(serverCode) ||
            (tableName != null && f.hiddenSerializableField(serverCode)))
        .where((f) => !(f.name == 'id' && serverCode && tableName != null));

    for (var field in classFields) {
      modelClassFields.add(Field((f) {
        f.type = field.type
            .reference(serverCode, subDirParts: subDirParts, config: config);
        f
          ..name =
              _createSerializableFieldNameReference(serverCode, field).symbol
          ..docs.addAll(field.documentation ?? []);
      }));
    }

    return modelClassFields;
  }

  Class _buildModelTableClass(
      String className,
      String tableName,
      List<SerializableModelFieldDefinition> fields,
      ClassDefinition classDefinition) {
    return Class((c) {
      c.name = '${className}Table';
      c.extend = refer('Table', serverpodUrl(serverCode));

      c.constructors.add(
          _buildModelTableClassConstructor(tableName, fields, classDefinition));

      c.fields.addAll(
        _buildModelTableClassFields(fields, classDefinition.subDirParts),
      );

      c.methods.addAll([
        ..._buildModelTableClassRelationGetters(
          fields,
          classDefinition,
          classDefinition.subDirParts,
        ),
        ..._buildModelTableClassManyRelationGetters(fields, classDefinition),
        _buildModelTableClassColumnGetter(fields),
      ]);

      var relationFields = fields.where((f) =>
          f.relation is ObjectRelationDefinition ||
          f.relation is ListRelationDefinition);
      if (relationFields.isNotEmpty) {
        c.methods.add(_buildModelTableClassGetRelationTable(relationFields));
      }
    });
  }

  Method _buildModelTableClassGetRelationTable(
      Iterable<SerializableModelFieldDefinition> relationFields) {
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
                for (var relationField in relationFields)
                  Block.of([
                    Code(
                        'if (relationField == ${literalString(relationField.name)}) {'),
                    lazyCode(() {
                      var fieldName = relationField.name;
                      if (relationField.relation is ListRelationDefinition) {
                        fieldName = '__$fieldName';
                      }
                      return refer(fieldName).returned.statement;
                    }),
                    const Code('}'),
                  ]),
                const Code('return null;'),
              ]))
            .build(),
    );
  }

  Method _buildModelTableClassColumnGetter(
      List<SerializableModelFieldDefinition> fields) {
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
              refer(createFieldName(serverCode, field))
        ]).code,
    );
  }

  List<Field> _buildModelTableClassFields(
    List<SerializableModelFieldDefinition> fields,
    List<String> subDirParts,
  ) {
    List<Field> tableFields = [];

    for (var field in fields) {
      // Simple column field
      if (field.shouldSerializeFieldForDatabase(serverCode) &&
          !(field.name == 'id' && serverCode)) {
        tableFields.add(Field((f) => f
          ..late = true
          ..modifier = FieldModifier.final$
          ..name = createFieldName(serverCode, field)
          ..docs.addAll(field.documentation ?? [])
          ..type = TypeReference((t) => t
            ..symbol = field.type.columnType
            ..url = 'package:serverpod/serverpod.dart'
            ..types.addAll(field.type.isEnumType
                ? [
                    field.type.reference(
                      serverCode,
                      nullable: false,
                      subDirParts: subDirParts,
                      config: config,
                    )
                  ]
                : []))));
      } else if (field.relation is ObjectRelationDefinition) {
        // Add internal nullable table field
        tableFields.add(Field((f) => f
          ..name = '_${field.name}'
          ..docs.addAll(field.documentation ?? [])
          ..type = field.type.reference(
            serverCode,
            subDirParts: subDirParts,
            config: config,
            nullable: true,
            typeSuffix: 'Table',
          )));
      } else if (field.relation is ListRelationDefinition) {
        tableFields.add(Field((f) => f
          ..name = '___${field.name}'
          ..docs.addAll(field.documentation ?? [])
          ..type = field.type.generics.first.reference(
            serverCode,
            subDirParts: subDirParts,
            config: config,
            nullable: true,
            typeSuffix: 'Table',
          )));
        // Add internal nullable many relation field
        tableFields.add(Field((f) => f
          ..name = '_${field.name}'
          ..docs.addAll(field.documentation ?? [])
          ..type = TypeReference((t) => t
            ..symbol = 'ManyRelation'
            ..url = serverpodUrl(serverCode)
            ..isNullable = true
            ..types.add(field.type.generics.first.reference(
              serverCode,
              subDirParts: subDirParts,
              config: config,
              nullable: false,
              typeSuffix: 'Table',
            )))));
      }
    }

    return tableFields;
  }

  List<Method> _buildModelTableClassRelationGetters(
    List<SerializableModelFieldDefinition> fields,
    ClassDefinition classDefinition,
    List<String> subDirParts,
  ) {
    List<Method> getters = [];

    var fieldsWithObjectRelation = fields.where(
      (f) =>
          f.relation is ObjectRelationDefinition ||
          f.relation is ListRelationDefinition,
    );

    for (var field in fieldsWithObjectRelation) {
      String relationFieldName = '';
      String relationForeignFieldName = '';
      String fieldName = '';
      TypeReference fieldType = field.type.reference(
        serverCode,
        subDirParts: subDirParts,
        config: config,
        nullable: false,
      );
      TypeReference tableType = field.type.reference(serverCode,
          subDirParts: subDirParts,
          config: config,
          nullable: false,
          typeSuffix: 'Table');

      var relation = field.relation;
      if (relation is ObjectRelationDefinition) {
        relationFieldName = relation.fieldName;
        relationForeignFieldName = relation.foreignFieldName;
        fieldName = field.name;
      } else if (relation is ListRelationDefinition) {
        relationFieldName = relation.fieldName;
        relationForeignFieldName = createForeignFieldName(relation);
        fieldName = '__${field.name}';
        fieldType = field.type.generics.first.reference(
          serverCode,
          subDirParts: subDirParts,
          config: config,
          nullable: false,
        );
        tableType = field.type.generics.first.reference(
          serverCode,
          subDirParts: subDirParts,
          config: config,
          nullable: false,
          typeSuffix: 'Table',
        );
      }

      // Add getter method for relation table that creates the table
      getters.add(Method((m) => m
        ..name = fieldName
        ..type = MethodType.getter
        ..returns = tableType
        ..body = Block.of([
          Code('if (_$fieldName != null) return _$fieldName!;'),
          refer('_$fieldName')
              .assign(
                refer(
                  'createRelationTable',
                  'package:serverpod/serverpod.dart',
                ).call(
                  [],
                  {
                    'relationFieldName': literalString(fieldName),
                    'field': refer(classDefinition.className)
                        .property('t')
                        .property(relationFieldName),
                    'foreignField': fieldType
                        .property('t')
                        .property(relationForeignFieldName),
                    'tableRelation': refer('tableRelation'),
                    'createTable': Method(
                      (m) => m
                        ..requiredParameters.addAll([
                          Parameter((p) => p..name = 'foreignTableRelation'),
                        ])
                        ..lambda = true
                        ..body = tableType.call([], {
                          'tableRelation': refer('foreignTableRelation')
                        }).code,
                    ).closure
                  },
                ),
              )
              .statement,
          Code('return _$fieldName!;'),
        ])));
    }

    return getters;
  }

  List<Method> _buildModelTableClassManyRelationGetters(
    List<SerializableModelFieldDefinition> fields,
    ClassDefinition classDefinition,
  ) {
    List<Method> getters = [];

    var manyRelationFields =
        fields.where((f) => f.relation is ListRelationDefinition);

    for (var field in manyRelationFields) {
      var listRelation = field.relation as ListRelationDefinition;

      getters.add(Method((m) => m
        ..name = field.name
        ..type = MethodType.getter
        ..returns = TypeReference((t) => t
          ..symbol = 'ManyRelation'
          ..url = serverpodUrl(serverCode)
          ..types.add(field.type.generics.first.reference(
            serverCode,
            subDirParts: classDefinition.subDirParts,
            config: config,
            nullable: false,
            typeSuffix: 'Table',
          )))
        ..body = Block.of([
          Code('if (_${field.name} != null) return _${field.name}!;'),
          declareVar('relationTable')
              .assign(
                refer(
                  'createRelationTable',
                  'package:serverpod/serverpod.dart',
                ).call(
                  [],
                  {
                    'relationFieldName': literalString(field.name),
                    'field': refer(classDefinition.className)
                        .property('t')
                        .property(listRelation.fieldName),
                    'foreignField': field.type.generics.first
                        .reference(
                          serverCode,
                          subDirParts: classDefinition.subDirParts,
                          config: config,
                          nullable: false,
                        )
                        .property('t')
                        .property(
                          listRelation.implicitForeignField
                              ? createImplicitFieldName(
                                  listRelation.foreignFieldName)
                              : listRelation.foreignFieldName,
                        ),
                    'tableRelation': refer('tableRelation'),
                    'createTable': Method(
                      (m) => m
                        ..requiredParameters.addAll([
                          Parameter((p) => p..name = 'foreignTableRelation'),
                        ])
                        ..lambda = true
                        ..body = field.type.generics.first
                            .reference(
                          serverCode,
                          subDirParts: classDefinition.subDirParts,
                          config: config,
                          nullable: false,
                          typeSuffix: 'Table',
                        )
                            .call([], {
                          'tableRelation': refer('foreignTableRelation')
                        }).code,
                    ).closure
                  },
                ),
              )
              .statement,
          refer('_${field.name}')
              .assign(
                TypeReference((t) => t
                  ..symbol = 'ManyRelation'
                  ..url = serverpodUrl(serverCode)
                  ..types.add(field.type.generics.first.reference(
                    serverCode,
                    subDirParts: classDefinition.subDirParts,
                    config: config,
                    nullable: false,
                    typeSuffix: 'Table',
                  ))).call(
                  [],
                  {
                    'tableWithRelations': refer('relationTable'),
                    'table': field.type.generics.first
                        .reference(serverCode,
                            subDirParts: classDefinition.subDirParts,
                            config: config,
                            nullable: false,
                            typeSuffix: 'Table')
                        .call([], {
                      'tableRelation': refer('relationTable')
                          .property('tableRelation')
                          .nullChecked
                          .property('lastRelation')
                    })
                  },
                ),
              )
              .statement,
          Code('return _${field.name}!;'),
        ])));
    }

    return getters;
  }

  Constructor _buildModelTableClassConstructor(
      String tableName,
      List<SerializableModelFieldDefinition> fields,
      ClassDefinition classDefinition) {
    return Constructor((constructorBuilder) {
      constructorBuilder.optionalParameters.add(
        Parameter(
          (p) => p
            ..name = 'tableRelation'
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
            refer(createFieldName(serverCode, field))
                .assign(field.type.isEnumType
                    ? _buildModelTableEnumFieldTypeReference(field)
                    : _buildModelTableGeneralFieldExpression(field))
                .statement,
      ]);
    });
  }

  Expression _buildModelTableGeneralFieldExpression(
    SerializableModelFieldDefinition field,
  ) {
    assert(!field.type.isEnumType);
    return TypeReference((t) => t
      ..symbol = field.type.columnType
      ..url = 'package:serverpod/serverpod.dart'
      ..types.addAll([])).call([
      literalString(field.name),
      refer('this'),
    ]);
  }

  Expression _buildModelTableEnumFieldTypeReference(
    SerializableModelFieldDefinition field,
  ) {
    assert(field.type.isEnumType);
    var enumType = refer('EnumSerialization', serverpodUrl(serverCode));
    Expression serializedAs;

    switch (field.type.serializeEnum) {
      case null:
      case EnumSerialization.byIndex:
        serializedAs = enumType.property('byIndex');
        break;
      case EnumSerialization.byName:
        serializedAs = enumType.property('byName');
        break;
    }

    return TypeReference((t) => t
      ..symbol = field.type.columnType
      ..url = 'package:serverpod/serverpod.dart'
      ..types.addAll([])).call([
      literalString(field.name),
      refer('this'),
      serializedAs,
    ]);
  }

  Field _buildDeprecatedStaticTableInstance(String className) {
    return Field((f) => f
      ..annotations.add(refer('Deprecated')
          .call([literalString('Use ${className}Table.t instead.')]))
      ..name = 't$className'
      ..type = refer('${className}Table')
      ..assignment = refer('${className}Table').call([]).code);
  }

  Class _buildModelIncludeClass(
    String className,
    List<SerializableModelFieldDefinition> fields,
    ClassDefinition classDefinition,
  ) {
    return Class(((c) {
      c.extend = refer('IncludeObject', 'package:serverpod/serverpod.dart');
      c.name = '${className}Include';
      var relationFields = fields
          .where((f) =>
              f.relation is ObjectRelationDefinition ||
              f.relation is ListRelationDefinition)
          .toList();

      c.constructors.add(_buildModelIncludeClassConstructor(
        relationFields,
        classDefinition,
      ));

      c.fields.addAll(_buildModelIncludeClassFields(
        relationFields,
        classDefinition,
      ));

      c.methods.addAll([
        _buildModelIncludeClassIncludesGetter(relationFields),
        _buildModelIncludeClassTableGetter(className),
      ]);
    }));
  }

  Class _buildModelIncludeListClass(
    String className,
    List<SerializableModelFieldDefinition> fields,
    ClassDefinition classDefinition,
  ) {
    return Class(((c) {
      c.extend = refer('IncludeList', 'package:serverpod/serverpod.dart');
      c.name = '${className}IncludeList';

      c.constructors.add(_buildModelIncludeListClassConstructor(className));

      c.methods.addAll([
        _buildModelIncludeListClassIncludesGetter(),
        _buildModelIncludeClassTableGetter(className),
      ]);
    }));
  }

  Constructor _buildModelIncludeListClassConstructor(
    String className,
  ) {
    return Constructor((constructorBuilder) {
      constructorBuilder.name = '_';

      constructorBuilder.optionalParameters.addAll([
        Parameter(
          (p) => p
            ..name = 'where'
            ..type = typeWhereExpressionBuilder(
              className,
              serverCode,
            )
            ..named = true,
        ),
        Parameter(
          (p) => p
            ..name = 'limit'
            ..toSuper = true
            ..named = true,
        ),
        Parameter(
          (p) => p
            ..name = 'offset'
            ..toSuper = true
            ..named = true,
        ),
        Parameter(
          (p) => p
            ..name = 'orderBy'
            ..toSuper = true
            ..named = true,
        ),
        Parameter(
          (p) => p
            ..name = 'orderDescending'
            ..toSuper = true
            ..named = true,
        ),
        Parameter(
          (p) => p
            ..name = 'orderByList'
            ..toSuper = true
            ..named = true,
        ),
        Parameter(
          (p) => p
            ..name = 'include'
            ..toSuper = true
            ..named = true,
        )
      ]);

      constructorBuilder.body = Block.of([
        refer('super')
            .property('where')
            .assign(refer('where').nullSafeProperty('call').call(
              [refer(className).property('t')],
            ))
            .statement
      ]);
    });
  }

  Method _buildModelIncludeListClassIncludesGetter() {
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
        ..body = refer('include')
            .nullSafeProperty('includes')
            .ifNullThen(literalMap({}))
            .code,
    );
  }

  Method _buildModelIncludeClassTableGetter(String className) {
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

  Method _buildModelIncludeClassIncludesGetter(
      List<SerializableModelFieldDefinition> objectRelationFields) {
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

  List<Field> _buildModelIncludeClassFields(
      List<SerializableModelFieldDefinition> objectRelationFields,
      ClassDefinition classDefinition) {
    List<Field> modelIncludeClassFields = [];
    for (var field in objectRelationFields) {
      if (field.relation is ObjectRelationDefinition) {
        modelIncludeClassFields.add(Field((f) => f
          ..name = '_${field.name}'
          ..type = field.type.reference(
            serverCode,
            subDirParts: classDefinition.subDirParts,
            config: config,
            nullable: true,
            typeSuffix: 'Include',
          )));
      } else if (field.relation is ListRelationDefinition) {
        modelIncludeClassFields.add(Field((f) => f
          ..name = '_${field.name}'
          ..type = field.type.generics.first.reference(
            serverCode,
            subDirParts: classDefinition.subDirParts,
            config: config,
            nullable: true,
            typeSuffix: 'IncludeList',
          )));
      }
    }
    return modelIncludeClassFields;
  }

  Constructor _buildModelIncludeClassConstructor(
    List<SerializableModelFieldDefinition> relationFields,
    ClassDefinition classDefinition,
  ) {
    return Constructor((constructorBuilder) {
      constructorBuilder.name = '_';
      if (relationFields.isEmpty) {
        return;
      }

      for (var field in relationFields) {
        if (field.relation is ObjectRelationDefinition) {
          constructorBuilder.optionalParameters.add(Parameter(
            (p) => p
              ..name = field.name
              ..type = field.type.reference(
                serverCode,
                subDirParts: classDefinition.subDirParts,
                config: config,
                nullable: true,
                typeSuffix: 'Include',
              )
              ..named = true,
          ));
        } else if (field.relation is ListRelationDefinition) {
          constructorBuilder.optionalParameters.add(Parameter(
            (p) => p
              ..name = field.name
              ..type = field.type.generics.first.reference(
                serverCode,
                subDirParts: classDefinition.subDirParts,
                config: config,
                nullable: true,
                typeSuffix: 'IncludeList',
              )
              ..named = true,
          ));
        }
      }

      constructorBuilder.body = Block.of([
        for (var field in relationFields)
          refer('_${field.name}').assign(refer(field.name)).statement,
      ]);
    });
  }

  /// Handle enums for [generateModelLibrary]
  Library _generateEnumLibrary(EnumDefinition enumDefinition) {
    var library = Library((library) {
      library.body.add(
        Enum((e) {
          e.name = enumDefinition.className;
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

          switch (enumDefinition.serialized) {
            case EnumSerialization.byIndex:
              e.methods.addAll(enumSerializationMethodsByIndex(enumDefinition));
              break;
            case EnumSerialization.byName:
              e.methods.addAll(enumSerializationMethodsByName(enumDefinition));
              break;
          }
        }),
      );
    });
    return library;
  }

  List<Method> enumSerializationMethodsByIndex(EnumDefinition enumDefinition) {
    return [
      Method((m) => m
        ..static = true
        ..returns = refer('${enumDefinition.className}?')
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
            .build()),
      Method(
        (m) => m
          ..annotations.add(refer('override'))
          ..returns = refer('int')
          ..name = 'toJson'
          ..lambda = true
          ..body = refer('index').code,
      )
    ];
  }

  List<Method> enumSerializationMethodsByName(EnumDefinition enumDefinition) {
    return [
      Method((m) => m
        ..static = true
        ..returns = refer('${enumDefinition.className}?')
        ..name = 'fromJson'
        ..requiredParameters.add(Parameter((p) => p
          ..name = 'name'
          ..type = refer('String')))
        ..body = (BlockBuilder()
              ..statements.addAll([
                const Code('switch(name){'),
                for (var value in enumDefinition.values)
                  Code("case '${value.name}': return ${value.name};"),
                const Code('default: return null;'),
                const Code('}'),
              ]))
            .build()),
      Method(
        (m) => m
          ..annotations.add(refer('override'))
          ..returns = refer('String')
          ..name = 'toJson'
          ..lambda = true
          ..body = refer('name').code,
      ),
      Method(
        (m) => m
          ..annotations.add(refer('override'))
          ..returns = refer('String')
          ..name = 'toString'
          ..lambda = true
          ..body = refer('toJson').call([]).code,
      )
    ];
  }

  /// Generate a temporary protocol library, that just exports the models.
  /// This is needed, since analyzing the endpoints requires a valid
  /// protocol.dart file.
  Library generateTemporaryProtocol({
    required List<SerializableModelDefinition> models,
  }) {
    var library = LibraryBuilder();

    library.name = 'protocol';

    // exports
    library.directives.addAll([
      for (var classInfo in models) Directive.export(classInfo.fileRef()),
      if (!serverCode) Directive.export('client.dart'),
    ]);

    return library.build();
  }

  Reference _createSerializableFieldNameReference(
    bool serverCode,
    SerializableModelFieldDefinition field,
  ) {
    if (field.hiddenSerializableField(serverCode) &&
        !field.name.startsWith('_')) {
      return refer('_${field.name}');
    }

    return refer(field.name);
  }
}
