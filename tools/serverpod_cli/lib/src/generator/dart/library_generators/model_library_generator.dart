import 'package:code_builder/code_builder.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/utils/duration_utils.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/class_generators/repository_classes.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/class_generators_util.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/model_generators_util.dart';
import 'package:serverpod_cli/src/generator/keywords.dart';
import 'package:serverpod_cli/src/generator/shared.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

/// The name of the method used to convert a model to JSON.
const String _toJsonMethodName = 'toJson';

/// The name of the method used to convert a model to JSON for protocol serialization.
const String _toJsonForProtocolMethodName = 'toJsonForProtocol';

/// Generates the dart libraries for [SerializableModelDefinition]s.
class SerializableModelLibraryGenerator {
  final bool serverCode;
  final GeneratorConfig config;

  SerializableModelLibraryGenerator({
    required this.serverCode,
    required this.config,
  });

  /// Generate the file for a model.
  Library generateModelLibrary(
    SerializableModelDefinition modelDefinition,
  ) {
    switch (modelDefinition) {
      case ClassDefinition():
        return _generateClassLibrary(modelDefinition);
      case EnumDefinition():
        return _generateEnumLibrary(modelDefinition);
    }
  }

  Library _generateClassLibrary(ClassDefinition classDefinition) {
    switch (classDefinition) {
      case ExceptionClassDefinition():
        return _generateExceptionLibrary(classDefinition);
      case ModelClassDefinition():
        return _generateModelClassLibrary(classDefinition);
    }
  }

  Library _generateExceptionLibrary(ExceptionClassDefinition definition) {
    var fields = definition.fields;
    var className = definition.className;
    var nonNullableField = fields
        .where((field) => field.shouldIncludeField(serverCode))
        .any((field) => field.type.nullable);

    return Library(
      (libraryBuilder) {
        libraryBuilder.body.addAll([
          _buildExceptionClass(
            className,
            definition,
            fields,
          ),
          if (nonNullableField) _buildUndefinedClass(),
          _buildModelImplClass(
            className,
            null,
            fields,
            subDirParts: definition.subDirParts,
            inheritedFields: [],
            isParentClass: false,
            hasImplicitClass: false,
          ),
        ]);
      },
    );
  }

  /// Handle ordinary classes for [generateModelLibrary].
  Library _generateModelClassLibrary(
    ModelClassDefinition classDefinition,
  ) {
    String? tableName = classDefinition.tableName;
    var className = classDefinition.className;
    var fields = classDefinition.fieldsIncludingInherited;
    var sealedTopNode = classDefinition.sealedTopNode;

    var buildRepository = BuildRepositoryClass(
      serverCode: serverCode,
      config: config,
    );

    var requiresImplicitClass =
        buildRepository.hasImplicitClassOperations(fields);

    return Library(
      (libraryBuilder) {
        if (classDefinition.isSealedTopNode) {
          for (var child in classDefinition.descendantClasses) {
            var childPath = p.relative(
              child.filePath,
              from: p.dirname(classDefinition.filePath),
            );
            libraryBuilder.directives.add(Directive.part(childPath));
          }
        }

        if (!classDefinition.isSealedTopNode && sealedTopNode != null) {
          var topNodePath = p.relative(
            sealedTopNode.filePath,
            from: p.dirname(classDefinition.filePath),
          );
          libraryBuilder.directives.add(Directive.partOf(topNodePath));
        }

        libraryBuilder.body.addAll([
          _buildModelClass(
            className,
            classDefinition,
            tableName,
            fields,
            hasImplicitClass: requiresImplicitClass,
          ),
          // We need to generate the implementation class for the copyWith method
          // to support differentiating between null and undefined values.
          // https://stackoverflow.com/questions/68009392/dart-custom-copywith-method-with-nullable-properties
          if (_shouldCreateUndefinedClass(classDefinition, fields))
            _buildUndefinedClass(),
          if (!classDefinition.isParentClass)
            _buildModelImplClass(
              className,
              tableName,
              fields,
              subDirParts: classDefinition.subDirParts,
              inheritedFields: classDefinition.inheritedFields,
              isParentClass: classDefinition.isParentClass,
              hasImplicitClass: requiresImplicitClass,
            ),
          if (requiresImplicitClass)
            _buildModelImplicitClass(className, classDefinition),
        ]);

        if (serverCode && tableName != null) {
          var idTypeReference = classDefinition.idField.type.reference(
            serverCode,
            subDirParts: classDefinition.subDirParts,
            config: config,
          ) as TypeReference;

          libraryBuilder.body.addAll([
            _buildModelTableClass(
              className,
              tableName,
              fields,
              classDefinition,
              idTypeReference,
            ),
            _buildModelIncludeClass(
              className,
              fields,
              classDefinition,
              idTypeReference,
            ),
            _buildModelIncludeListClass(
              className,
              fields,
              classDefinition,
              idTypeReference,
            ),
            buildRepository.buildModelRepositoryClass(
              className,
              fields,
              classDefinition,
              idTypeReference,
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

          // TODO: Remove this workaround when closing issue
          // https://github.com/serverpod/serverpod/issues/3462
          if (buildRepository.hasRelationWithNonNullableIds(fields)) {
            libraryBuilder.ignoreForFile.add('unnecessary_null_comparison');
          }
        }
      },
    );
  }

  Class _buildExceptionClass(
    String className,
    ExceptionClassDefinition classDefinition,
    List<SerializableModelFieldDefinition> fields,
  ) {
    return Class((classBuilder) {
      classBuilder
        ..name = className
        ..docs.addAll(classDefinition.documentation ?? []);

      classBuilder.abstract = true;

      classBuilder.implements
          .add(refer('SerializableException', serverpodUrl(serverCode)));

      classBuilder.implements
          .add(refer('SerializableModel', serverpodUrl(serverCode)));

      if (serverCode) {
        classBuilder.implements
            .add(refer('ProtocolSerialization', serverpodUrl(serverCode)));
      }

      classBuilder.fields.addAll(_buildModelClassFields(
        classDefinition.fields,
        null,
        classDefinition.subDirParts,
      ));

      classBuilder.constructors.addAll([
        _buildModelClassConstructor(
          fields,
          null,
          isParentClass: false,
          subDirParts: classDefinition.subDirParts,
          inheritedFields: [],
        ),
        _buildModelClassFactoryConstructor(
          className,
          fields,
          null,
          inheritedFields: [],
          subDirParts: classDefinition.subDirParts,
        ),
        _buildModelClassFromJsonConstructor(
          className,
          fields,
          subDirParts: classDefinition.subDirParts,
          hasImplicitClass: false,
        )
      ]);

      classBuilder.methods.add(_buildAbstractCopyWithMethod(
        className,
        fields,
        shouldOverrideAbstractCopyWith: () => false,
        subDirParts: classDefinition.subDirParts,
        inheritedFields: [],
      ));

      classBuilder.methods.add(_buildModelClassToJsonMethod(fields));

      // Serialization for database and everything
      if (serverCode) {
        classBuilder.methods.add(
          _buildModelClassToJsonForProtocolMethod(fields),
        );
      }

      classBuilder.methods.add(_buildToStringMethod(serverCode));
    });
  }

  Class _buildModelClass(
    String className,
    ModelClassDefinition classDefinition,
    String? tableName,
    List<SerializableModelFieldDefinition> fields, {
    required bool hasImplicitClass,
  }) {
    var relationFields = fields.where((field) =>
        field.relation is ObjectRelationDefinition ||
        field.relation is ListRelationDefinition);

    var parentClass = classDefinition.parentClass;

    return Class((classBuilder) {
      classBuilder
        ..name = className
        ..docs.addAll(classDefinition.documentation ?? []);

      if (!classDefinition.isParentClass) {
        classBuilder.abstract = true;
      }

      if (classDefinition.isSealed) {
        classBuilder.sealed = true;
      }

      if (parentClass != null) {
        classBuilder.extend = parentClass.type.reference(
          serverCode,
          subDirParts: classDefinition.subDirParts,
          config: config,
        );
      }

      if (serverCode && tableName != null) {
        var idTypeReference = classDefinition.idField.type.reference(
          serverCode,
          subDirParts: classDefinition.subDirParts,
          config: config,
        ) as TypeReference;

        classBuilder.implements.add(TypeReference(
          (f) => f
            ..symbol = 'TableRow'
            ..url = serverpodUrl(serverCode)
            ..types.add(idTypeReference),
        ));

        classBuilder.fields.addAll([
          _buildModelClassTableField(className),
        ]);

        classBuilder.fields.add(_buildModelClassDBField(className));

        classBuilder.fields.add(Field(
          (f) => f
            ..name = 'id'
            ..type = idTypeReference
            ..annotations.add(
              refer('override'),
            ),
        ));

        classBuilder.methods.add(_buildModelClassTableGetter(idTypeReference));
      } else {
        classBuilder.implements
            .add(refer('SerializableModel', serverpodUrl(serverCode)));
      }

      if (serverCode) {
        classBuilder.implements
            .add(refer('ProtocolSerialization', serverpodUrl(serverCode)));
      }

      classBuilder.fields.addAll(_buildModelClassFields(
        classDefinition.fields,
        tableName,
        classDefinition.subDirParts,
      ));

      classBuilder.constructors.addAll([
        _buildModelClassConstructor(
          fields,
          tableName,
          isParentClass: classDefinition.isParentClass,
          subDirParts: classDefinition.subDirParts,
          inheritedFields: classDefinition.inheritedFields,
        ),
        if (!classDefinition.isParentClass)
          _buildModelClassFactoryConstructor(
            className,
            fields,
            tableName,
            inheritedFields: classDefinition.inheritedFields,
            subDirParts: classDefinition.subDirParts,
          ),
        if (!classDefinition.isSealed)
          _buildModelClassFromJsonConstructor(
            className,
            fields,
            subDirParts: classDefinition.subDirParts,
            hasImplicitClass: hasImplicitClass,
          )
      ]);

      if (!classDefinition.isParentClass) {
        classBuilder.methods.add(_buildAbstractCopyWithMethod(
          className,
          fields,
          shouldOverrideAbstractCopyWith: () =>
              _shouldOverrideAbstractCopyWithMethod(classDefinition),
          subDirParts: classDefinition.subDirParts,
          inheritedFields: classDefinition.inheritedFields,
        ));
      } else if (!classDefinition.isSealed) {
        classBuilder.methods.add(_buildCopyWithMethod(
          fields,
          subDirParts: classDefinition.subDirParts,
          className: className,
          isParentClass: classDefinition.isParentClass,
          hasImplicitClass: hasImplicitClass,
        ));
      }
      // Serialization

      if (!classDefinition.isSealed) {
        classBuilder.methods.add(_buildModelClassToJsonMethod(fields));
      }

      // Serialization for database and everything
      if (serverCode) {
        if (!classDefinition.isSealed) {
          classBuilder.methods.add(
            _buildModelClassToJsonForProtocolMethod(fields),
          );
        }

        if (tableName != null) {
          classBuilder.methods.addAll([
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

      if (!classDefinition.isSealed) {
        classBuilder.methods.add(_buildToStringMethod(serverCode));
      }
    });
  }

  bool _shouldCreateUndefinedClass(
    ModelClassDefinition classDefinition,
    List<SerializableModelFieldDefinition> fields,
  ) {
    if (classDefinition.sealedTopNode == null) {
      return fields
          .where((field) => field.shouldIncludeField(serverCode))
          .any((field) => field.type.nullable);
    }

    if (!classDefinition.isSealedTopNode) {
      return false;
    }

    var descendantFields = <SerializableModelFieldDefinition>[];
    var descendants = classDefinition.descendantClasses;

    for (var descendant in descendants) {
      descendantFields.addAll(descendant.fields);
    }

    return descendantFields
        .where((field) => field.shouldIncludeField(serverCode))
        .any((field) => field.type.nullable);
  }

  Class _buildUndefinedClass() {
    return Class((classBuilder) => classBuilder.name = '_Undefined');
  }

  Class _buildModelImplClass(
    String className,
    String? tableName,
    List<SerializableModelFieldDefinition> fields, {
    required List<String> subDirParts,
    required List<SerializableModelFieldDefinition> inheritedFields,
    required bool isParentClass,
    required bool hasImplicitClass,
  }) {
    return Class((classBuilder) {
      classBuilder
        ..name = '_${className}Impl'
        ..extend = refer(className)
        ..constructors.add(
          _buildModelImplClassConstructor(
            fields,
            tableName,
            subDirParts: subDirParts,
            inheritedFields: inheritedFields,
          ),
        )
        ..methods.add(_buildCopyWithMethod(
          fields,
          subDirParts: subDirParts,
          className: className,
          isParentClass: isParentClass,
          hasImplicitClass: hasImplicitClass,
        ));
    });
  }

  Class _buildModelImplicitClass(
    String className,
    ModelClassDefinition classDefinition,
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
              ..name = _createSerializableFieldName(serverCode, field)
              ..type = field.type.reference(
                serverCode,
                config: config,
                subDirParts: classDefinition.subDirParts,
              )
              ..modifier = FieldModifier.final$
              ..annotations.add(refer('override'));
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
                classDefinition.fields,
                classDefinition.tableName,
                setAsToThis: false,
                subDirParts: classDefinition.subDirParts,
                inheritedFields: classDefinition.inheritedFields,
              ),
            )
            ..optionalParameters.addAll(hiddenFields.map((field) {
              return Parameter((p) => p
                ..name = createFieldName(serverCode, field)
                ..named = true
                ..type = field.type.reference(
                  serverCode,
                  config: config,
                  subDirParts: classDefinition.subDirParts,
                ));
            }))
            ..initializers.addAll([
              for (var field in hiddenFields)
                refer(_createSerializableFieldName(serverCode, field))
                    .assign(
                      refer(createFieldName(serverCode, field)),
                    )
                    .code,
              refer('super').call([], namedParams).code,
            ]);
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
                ..type = field.type.reference(
                  serverCode,
                  config: config,
                  subDirParts: classDefinition.subDirParts,
                ));
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
        }));
    });
  }

  bool _shouldOverrideAbstractCopyWithMethod(
    ModelClassDefinition classDefinition,
  ) {
    var parentClass = classDefinition.parentClass;

    if (parentClass == null) {
      return false;
    }

    if (classDefinition.everyParentIsSealed) {
      return false;
    }

    return true;
  }

  Method _buildAbstractCopyWithMethod(
    String className,
    List<SerializableModelFieldDefinition> fields, {
    required bool Function() shouldOverrideAbstractCopyWith,
    required List<String> subDirParts,
    required List<SerializableModelFieldDefinition> inheritedFields,
  }) {
    return Method((methodBuilder) {
      if (shouldOverrideAbstractCopyWith()) {
        methodBuilder.annotations.add(refer('override'));
      }

      methodBuilder
        ..docs.add('/// Returns a shallow copy of this [$className]\n'
            '/// with some or all fields replaced by the given arguments.')
        ..annotations
            .add(refer('useResult', serverpodUrl(serverCode)).expression)
        ..name = 'copyWith'
        ..optionalParameters.addAll(
          _buildAbstractCopyWithParameters(
            fields,
            subDirParts: subDirParts,
            inheritedFields: inheritedFields,
          ),
        )
        ..returns = refer(className);
    });
  }

  Method _buildCopyWithMethod(
    List<SerializableModelFieldDefinition> fields, {
    required List<String> subDirParts,
    required String className,
    required bool isParentClass,
    required hasImplicitClass,
  }) {
    return Method(
      (m) {
        m.name = 'copyWith';
        m.docs.add('/// Returns a shallow copy of this [$className] \n'
            '/// with some or all fields replaced by the given arguments.');
        m.annotations
            .add(refer('useResult', serverpodUrl(serverCode)).expression);
        if (!isParentClass) {
          m.annotations.add(refer('override'));
        }
        m.optionalParameters.addAll(
          fields.where((field) => field.shouldIncludeField(serverCode)).map(
            (field) {
              var fieldType = field.type.reference(
                serverCode,
                nullable: true,
                subDirParts: subDirParts,
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
        );
        m.returns = refer(className);
        m.body = createClassExpression(hasImplicitClass, className)
            .call(
              [],
              _buildCopyWithAssignment(
                fields,
                subDirParts: subDirParts,
              ),
            )
            .returned
            .statement;
      },
    );
  }

  Map<String, Expression> _buildCopyWithAssignment(
    List<SerializableModelFieldDefinition> fields, {
    required List<String> subDirParts,
  }) {
    var visibleFields =
        fields.where((field) => field.shouldIncludeField(serverCode));
    var hiddenSerializableFields =
        fields.where((field) => field.hiddenSerializableField(serverCode));

    var visibleAssignments = visibleFields.fold({}, (map, field) {
      Expression assignment = _buildDeepCloneTree(
        field.type,
        field.name,
        isRoot: true,
      );

      Expression valueDefinition;
      if (field.type.nullable) {
        valueDefinition = refer(field.name)
            .isA(field.type.reference(
              serverCode,
              nullable: field.type.nullable,
              subDirParts: subDirParts,
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

      return map..[field.name] = valueDefinition;
    });

    var hiddenAssignments = hiddenSerializableFields.fold({}, (map, field) {
      return map
        ..[createFieldName(serverCode, field)] = _buildDeepCloneTree(
          field.type,
          _createSerializableFieldName(serverCode, field),
          isRoot: true,
        );
    });

    return {
      ...visibleAssignments,
      ...hiddenAssignments,
    };
  }

  Expression _buildDeepCloneTree(
    TypeDefinition type,
    String variableName, {
    int depth = 0,
    bool isRoot = false,
  }) {
    var isLeafNode = type.generics.isEmpty;
    if (isLeafNode) {
      return _buildShallowClone(type, variableName, isRoot);
    }

    if (type.isRecordType) {
      return _buildRecordCloneCallback(
        variableName,
        type.nullable,
        type.generics,
        depth,
      );
    }

    // For now the model types do not contain records, so casting is valid
    var nextCallback = switch (type.className) {
      ListKeyword.className => _buildListCloneCallback(
          type.generics.first,
          depth,
        ),
      SetKeyword.className => _buildSetCloneCallback(
          type.generics.first,
          depth,
        ),
      MapKeyword.className => _buildMapCloneCallback(
          type.generics[0],
          type.generics[1],
          depth,
        ),
      _ => throw UnimplementedError("Can't clone type ${type.className}"),
    };

    Expression expression = switch (isRoot) {
      true => refer(Keyword.thisKeyword).property(variableName),
      false => refer(variableName),
    };

    expression = switch (type.nullable) {
      true => expression.nullSafeProperty(Keyword.mapFunctionName),
      false => expression.property(Keyword.mapFunctionName),
    }
        .call([nextCallback]);

    if (type.isListType) {
      return expression.property(ListKeyword.toList).call([]);
    } else if (type.isSetType) {
      return expression.property(SetKeyword.toSet).call([]);
    } else {
      return expression;
    }
  }

  Expression _buildShallowClone(
      TypeDefinition type, String variableName, bool isRoot) {
    var isNonMutableType =
        type.isEnumType || nonMutableTypeNames.contains(type.className);
    if (isNonMutableType) {
      return isRoot
          ? refer(Keyword.thisKeyword).property(variableName)
          : refer(variableName);
    } else if (hasCloneExtensionTypes.contains(type.className)) {
      return _buildMaybeNullMethodCall(
          type.nullable, variableName, Keyword.cloneExtensionName, isRoot);
    } else {
      return _buildMaybeNullMethodCall(
          type.nullable, variableName, Keyword.copyWithMethodName, isRoot);
    }
  }

  Expression _buildListCloneCallback(TypeDefinition type, int depth) {
    var variableName = 'e$depth';

    return Method(
      (p) {
        p
          ..lambda = true
          ..requiredParameters.add(
            Parameter((p) => p..name = variableName),
          )
          ..body =
              _buildDeepCloneTree(type, variableName, depth: depth + 1).code;
      },
    ).closure;
  }

  Expression _buildSetCloneCallback(TypeDefinition type, int depth) {
    var variableName = 'e$depth';

    return Method(
      (p) {
        p
          ..lambda = true
          ..requiredParameters.add(
            Parameter((p) => p..name = variableName),
          )
          ..body =
              _buildDeepCloneTree(type, variableName, depth: depth + 1).code;
      },
    ).closure;
  }

  Expression _buildMapCloneCallback(
    TypeDefinition keyType,
    TypeDefinition valueType,
    int depth,
  ) {
    var keyVariableName = 'key$depth';
    var valueVariableName = 'value$depth';

    return Method(
      (builder) {
        builder
          ..lambda = true
          ..requiredParameters.add(
            Parameter((p) => p..name = keyVariableName),
          )
          ..requiredParameters.add(
            Parameter((p) => p..name = valueVariableName),
          );

        var keyArg =
            _buildDeepCloneTree(keyType, keyVariableName, depth: depth + 1);
        var valueArg =
            _buildDeepCloneTree(valueType, valueVariableName, depth: depth + 1);

        builder.body = refer(MapKeyword.mapEntry).call([keyArg, valueArg]).code;
      },
    ).closure;
  }

  Expression _buildRecordCloneCallback(
    String name,
    bool nullable,
    List<TypeDefinition> fields,
    int depth,
  ) {
    var positionalFields =
        fields.where((f) => f.recordFieldName == null).toList();
    var namedFields = fields.where((f) => f.recordFieldName != null).toList();

    var prefix = depth == 0 ? 'this.' : '';
    var accessor = nullable && depth == 0 ? '!' : '';

    return CodeExpression(
      Block.of([
        if (nullable) ...[Code('$prefix$name == null ? null :')],
        const Code('('),
        for (var (i, positionalField) in positionalFields.indexed) ...[
          _buildDeepCloneTree(
                  positionalField, '$prefix$name$accessor.\$${i + 1}',
                  depth: depth + 1)
              .code,
          const Code(','),
        ],
        for (var namedField in namedFields) ...[
          Code('${namedField.recordFieldName!}:'),
          _buildDeepCloneTree(namedField,
                  '$prefix$name$accessor.${namedField.recordFieldName!}',
                  depth: depth + 1)
              .code,
          const Code(','),
        ],
        const Code(')'),
      ]),
    );
  }

  Expression _buildMaybeNullMethodCall(
    bool nullable,
    String fieldName,
    String methodName,
    bool isRoot,
  ) {
    Expression expression = switch (isRoot) {
      true => refer(Keyword.thisKeyword).property(fieldName),
      false => refer(fieldName),
    };

    return switch (nullable) {
      true => expression.nullSafeProperty(methodName).call([]),
      false => expression.property(methodName).call([]),
    };
  }

  Method _buildModelClassTableGetter(TypeReference idTypeReference) {
    return Method(
      (m) => m
        ..name = 'table'
        ..annotations.add(refer('override'))
        ..type = MethodType.getter
        ..returns = TypeReference(
          (f) => f
            ..symbol = 'Table'
            ..url = serverpodUrl(serverCode)
            ..types.add(idTypeReference),
        )
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

  Method _buildModelClassToJsonMethod(
      Iterable<SerializableModelFieldDefinition> fields) {
    return Method(
      (m) {
        m.returns = refer('Map<String,dynamic>');
        m.name = _toJsonMethodName;
        m.annotations.add(refer('override'));

        var filteredFields = fields;

        // since the [toJson] method is included both on server and client side models,
        // on the client side the server-only fields are missing and we should not
        // generate serialization for these fields.
        if (!serverCode) {
          filteredFields = filteredFields
              .where((field) => field.shouldSerializeField(serverCode));
        }

        m.body = _createToJsonBodyFromFields(
          filteredFields,
          _toJsonMethodName,
        );
      },
    );
  }

  Method _buildModelClassToJsonForProtocolMethod(
    Iterable<SerializableModelFieldDefinition> fields,
  ) {
    return Method(
      (m) {
        m.returns = refer('Map<String,dynamic>');
        m.name = _toJsonForProtocolMethodName;
        m.annotations.add(refer('override'));

        var filteredFields =
            fields.where((field) => field.shouldSerializeField(serverCode));

        m.body = _createToJsonBodyFromFields(
          filteredFields,
          _toJsonForProtocolMethodName,
        );
      },
    );
  }

  Method _buildToStringMethod(
    bool serverCode,
  ) {
    return Method(
      (m) {
        m.returns = refer('String');
        m.name = 'toString';
        m.annotations.add(refer('override'));
        m.body = Block.of([
          const Code('return '),
          refer('SerializationManager', serverpodUrl(serverCode))
              .property('encode')
              .call(
            [refer('this')],
          ).code,
          const Code(';'),
        ]);
      },
    );
  }

  Expression _toJsonCallConversionMethod(
    Reference fieldRef,
    TypeDefinition fieldType,
    String methodName, {
    bool nullCheckedReference = false,
  }) {
    if (fieldType.isSerializedValue) return fieldRef;

    // If the field is nullable and we have not already null checked it, we need
    // to treat it as potentially null.
    var nullableField = nullCheckedReference ? false : fieldType.nullable;

    if (fieldType.isRecordType) {
      var mapRecordToJsonRef = refer(
        'mapRecordToJson',
        serverCode
            ? 'package:${config.serverPackage}/src/generated/protocol.dart'
            : 'package:${config.dartClientPackage}/src/protocol/protocol.dart',
      );

      return mapRecordToJsonRef.call([fieldRef]);
    } else if (fieldType.returnsRecordInContainer) {
      var mapRecordContainingContainerToJsonRef = refer(
        'mapRecordContainingContainerToJson',
        serverCode
            ? 'package:${config.serverPackage}/src/generated/protocol.dart'
            : 'package:${config.dartClientPackage}/src/protocol/protocol.dart',
      );

      return mapRecordContainingContainerToJsonRef.call(
        [refer('${fieldRef.symbol}${nullableField ? '!' : ''}')],
      );
    }

    Expression fieldExpression = fieldRef;

    // If the field is a custom class and we are generating 'toJsonForProtocol',
    // we need to check if it implements the ProtocolSerialization interface. If
    // it does, we use the 'toJsonForProtocol' method to convert the field to
    // JSON. Otherwise we use the 'toJson' method.
    if (fieldType.customClass && methodName == _toJsonForProtocolMethodName) {
      var protocolSerialization = refer(
        'ProtocolSerialization',
        serverpodUrl(serverCode),
      );

      var toJsonForProtocolExpression = switch (nullableField) {
        true => fieldExpression
            .asA(protocolSerialization)
            .nullSafeProperty(_toJsonForProtocolMethodName),
        false => fieldExpression
            .asA(protocolSerialization)
            .property(_toJsonForProtocolMethodName),
      };

      var toJsonExpression = switch (nullableField) {
        true => fieldExpression.nullSafeProperty(_toJsonMethodName),
        false => fieldExpression.property(_toJsonMethodName),
      };

      fieldExpression = CodeExpression(
        Block.of(
          [
            const Code('\n// ignore: unnecessary_type_check'),
            fieldExpression.isA(protocolSerialization).code,
            const Code('?'),
            toJsonForProtocolExpression.call([]).code,
            const Code(':'),
            toJsonExpression.call([]).code,
          ],
        ),
      );
      return fieldExpression;
    }

    var toJson = fieldType.isSerializedByExtension || fieldType.isEnumType
        ? _toJsonMethodName
        : methodName;

    if (nullableField) {
      fieldExpression = fieldExpression.nullSafeProperty(toJson);
    } else {
      fieldExpression = fieldExpression.property(toJson);
    }

    Map<String, Expression> namedParams = {};

    if ((fieldType.isListType || fieldType.isSetType) &&
        !fieldType.generics.first.isSerializedValue) {
      namedParams = {
        'valueToJson': Method(
          (p) => p
            ..lambda = true
            ..requiredParameters.add(
              Parameter((p) => p..name = 'v'),
            )
            ..body = _toJsonCallConversionMethod(
              refer('v'),
              fieldType.generics.first,
              methodName,
            ).code,
        ).closure
      };
    } else if (fieldType.isMapType) {
      if (!fieldType.generics.first.isSerializedValue) {
        namedParams = {
          ...namedParams,
          'keyToJson': Method(
            (p) => p
              ..lambda = true
              ..requiredParameters.add(
                Parameter((p) => p..name = 'k'),
              )
              ..body = _toJsonCallConversionMethod(
                refer('k'),
                fieldType.generics.first,
                methodName,
              ).code,
          ).closure
        };
      }

      if (!fieldType.generics.last.isSerializedValue) {
        namedParams = {
          ...namedParams,
          'valueToJson': Method(
            (p) => p
              ..lambda = true
              ..requiredParameters.add(
                Parameter((p) => p..name = 'v'),
              )
              ..body = _toJsonCallConversionMethod(
                refer('v'),
                fieldType.generics.last,
                methodName,
              ).code,
          ).closure
        };
      }
    }

    return fieldExpression.call([], namedParams);
  }

  Code _createToJsonBodyFromFields(
    Iterable<SerializableModelFieldDefinition> fields,
    String toJsonMethodName,
  ) {
    var map = fields.fold<Map<Code, Expression>>({}, (map, field) {
      var fieldName = _createSerializableFieldNameReference(
        serverCode,
        field,
      );

      Expression fieldRef = _toJsonCallConversionMethod(
        fieldName,
        field.type,
        toJsonMethodName,
        // Hidden serializable fields are final so no additional null check
        // is needed.
        nullCheckedReference: field.hiddenSerializableField(serverCode),
      );

      return {
        ...map,
        if (field.type.nullable)
          Code("if (${fieldName.symbol} != null) '${field.name}'"): fieldRef,
        if (!field.type.nullable) Code("'${field.name}'"): fieldRef,
      };
    });

    return literalMap(map).returned.statement;
  }

  Constructor _buildModelClassFromJsonConstructor(
    String className,
    List<SerializableModelFieldDefinition> fields, {
    required List<String> subDirParts,
    required bool hasImplicitClass,
  }) {
    var visibleFields =
        fields.where((field) => field.shouldIncludeField(serverCode));
    var hiddenSerializableFields =
        fields.where((field) => field.hiddenSerializableField(serverCode));
    return Constructor((c) {
      c.factory = true;
      c.name = 'fromJson';
      c.requiredParameters.addAll([
        Parameter((p) {
          p.name = 'jsonSerialization';
          p.type = refer('Map<String,dynamic>');
        }),
      ]);
      c.body = createClassExpression(hasImplicitClass, className)
          .call([], {
            for (var field in visibleFields)
              field.name: buildFromJsonForField(
                field,
                serverCode,
                config,
                subDirParts,
              ),
            for (var field in hiddenSerializableFields)
              createFieldName(serverCode, field): buildFromJsonForField(
                field,
                serverCode,
                config,
                subDirParts,
              )
          })
          .returned
          .statement;
    });
  }

  Constructor _buildModelClassConstructor(
    List<SerializableModelFieldDefinition> fields,
    String? tableName, {
    required bool isParentClass,
    required List<String> subDirParts,
    required List<SerializableModelFieldDefinition> inheritedFields,
  }) {
    return Constructor((c) {
      if (!isParentClass) {
        c.name = '_';
      }
      c.optionalParameters.addAll(_buildModelClassConstructorParameters(
        fields,
        tableName,
        setAsToThis: true,
        subDirParts: subDirParts,
        inheritedFields: inheritedFields,
      ));

      var classFields =
          fields.where((field) => !inheritedFields.contains(field)).toList();

      var defaultValueFields = classFields.where((field) => field.hasDefaults);
      for (var field in defaultValueFields) {
        Code? defaultCode = _getDefaultValue(
          field,
          subDirParts: subDirParts,
        );
        if (defaultCode == null) continue;

        c.initializers.add(Block.of([
          refer(field.name).code,
          const Code('='),
          refer(field.name).ifNullThen(CodeExpression(defaultCode)).code,
        ]));
      }

      var implicitFields = classFields.where(
        (field) => field.hiddenSerializableField(serverCode),
      );
      for (var field in implicitFields) {
        c.initializers.add(Block.of([
          _createSerializableFieldNameReference(serverCode, field).code,
          const Code('='),
          literalNull.code,
        ]));
      }
    });
  }

  Constructor _buildModelClassFactoryConstructor(
    String className,
    List<SerializableModelFieldDefinition> fields,
    String? tableName, {
    required List<String> subDirParts,
    required List<SerializableModelFieldDefinition> inheritedFields,
  }) {
    return Constructor((c) {
      c.factory = true;
      c.optionalParameters.addAll(_buildModelClassConstructorParameters(
        fields,
        tableName,
        setAsToThis: false,
        subDirParts: subDirParts,
        inheritedFields: inheritedFields,
      ));

      c.redirect = refer('_${className}Impl');
    });
  }

  Constructor _buildModelImplClassConstructor(
    List<SerializableModelFieldDefinition> fields,
    String? tableName, {
    required List<String> subDirParts,
    required List<SerializableModelFieldDefinition> inheritedFields,
  }) {
    return Constructor((c) {
      c.optionalParameters.addAll(_buildModelClassConstructorParameters(
        fields,
        tableName,
        setAsToThis: false,
        subDirParts: subDirParts,
        inheritedFields: inheritedFields,
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
    List<SerializableModelFieldDefinition> fields,
    String? tableName, {
    required List<String> subDirParts,
    required bool setAsToThis,
    required List<SerializableModelFieldDefinition> inheritedFields,
  }) {
    return fields
        .where((field) => field.shouldIncludeField(serverCode))
        .map((field) {
      bool shouldIncludeType = !setAsToThis ||
          (field.defaultModelValue != null) &&
              (!inheritedFields.contains(field));

      bool hasDefaults = field.hasDefaults;

      var type = field.type.reference(
        serverCode,
        nullable: field.type.nullable || hasDefaults,
        subDirParts: subDirParts,
        config: config,
      );

      return Parameter((p) {
        p
          ..named = true
          ..name = field.name
          ..required = !(field.type.nullable || hasDefaults);

        if (shouldIncludeType) {
          p.type = type;
        } else {
          inheritedFields.contains(field) ? p.toSuper = true : p.toThis = true;
        }
      });
    }).toList();
  }

  Code? _getDefaultValue(
    SerializableModelFieldDefinition field, {
    required List<String> subDirParts,
  }) {
    var defaultValue = field.defaultModelValue;

    if (defaultValue == null) return null;

    var defaultValueType = field.type.defaultValueType;
    if (defaultValueType == null) return null;

    switch (defaultValueType) {
      case DefaultValueAllowedType.dateTime:
        if (defaultValue is! String) return null;

        if (defaultValue == defaultDateTimeValueNow) {
          return refer(field.type.className).property('now').call([]).code;
        }
        return refer(field.type.className)
            .property('parse')
            .call([CodeExpression(Code("'$defaultValue'"))]).code;
      case DefaultValueAllowedType.bool:
        return switch (defaultValue) {
          defaultBooleanTrue => literalBool(true).code,
          defaultBooleanFalse => literalBool(false).code,
          _ => null,
        };
      case DefaultValueAllowedType.int:
        if (defaultValue == defaultIntSerial) return null;
        return literalNum(int.parse(defaultValue)).code;
      case DefaultValueAllowedType.double:
        return literalNum(double.parse(defaultValue)).code;
      case DefaultValueAllowedType.string:
        return Code(defaultValue);
      case DefaultValueAllowedType.uuidValue:
        if (defaultValue is! String) return null;

        final uuidGeneratorMethod = switch (defaultValue) {
          defaultUuidValueRandom => 'v4obj',
          defaultUuidValueRandomV7 => 'v7obj',
          _ => null,
        };
        if (uuidGeneratorMethod != null) {
          return refer('Uuid()', serverpodUrl(serverCode))
              .property(uuidGeneratorMethod)
              .call([]).code;
        }

        return refer(field.type.className, serverpodUrl(serverCode))
            .property('fromString')
            .call([CodeExpression(Code(defaultValue))]).code;
      case DefaultValueAllowedType.uri:
        return refer(field.type.className)
            .property('parse')
            .call([CodeExpression(Code(defaultValue))]).code;
      case DefaultValueAllowedType.bigInt:
        return refer(field.type.className)
            .property('parse')
            .call([literalString(defaultValue)]).code;
      case DefaultValueAllowedType.duration:
        Duration parsedDuration = parseDuration(defaultValue);
        return refer(field.type.className).call([], {
          'days': literalNum(parsedDuration.days),
          'hours': literalNum(parsedDuration.hours),
          'minutes': literalNum(parsedDuration.minutes),
          'seconds': literalNum(parsedDuration.seconds),
          'milliseconds': literalNum(parsedDuration.milliseconds),
        }).code;
      case DefaultValueAllowedType.isEnum:
        var enumDefinition = field.type.enumDefinition;
        if (enumDefinition == null) return null;
        var reference = field.type.reference(
          serverCode,
          config: config,
          nullable: false,
          subDirParts: subDirParts,
        );
        return reference.property(defaultValue).code;
    }
  }

  List<Parameter> _buildAbstractCopyWithParameters(
    List<SerializableModelFieldDefinition> fields, {
    required List<String> subDirParts,
    required List<SerializableModelFieldDefinition> inheritedFields,
  }) {
    return fields
        .where((field) => field.shouldIncludeField(serverCode))
        .map((field) {
      var fieldType = field.type.reference(
        serverCode,
        nullable: true,
        subDirParts: subDirParts,
        config: config,
      );

      var isInheritedField = inheritedFields.contains(field);

      var type = field.type.nullable && isInheritedField
          ? refer('Object?')
          : fieldType;

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
        f
          ..type = field.type.reference(
            serverCode,
            subDirParts: subDirParts,
            config: config,
          )
          ..name =
              _createSerializableFieldNameReference(serverCode, field).symbol
          ..docs.addAll(field.documentation ?? []);
        if (field.hiddenSerializableField(serverCode)) {
          f.modifier = FieldModifier.final$;
        }
      }));
    }

    return modelClassFields;
  }

  Class _buildModelTableClass(
      String className,
      String tableName,
      List<SerializableModelFieldDefinition> fields,
      ClassDefinition classDefinition,
      TypeReference idTypeReference) {
    var serializedFields = fields
        .where((f) => f.shouldSerializeFieldForDatabase(serverCode))
        .toSet();
    var hiddenSerializedFields = serializedFields
        .where((f) => f.hiddenSerializableField(serverCode))
        .toSet();
    return Class((c) {
      c.name = '${className}Table';
      c.extend = TypeReference((f) => f
        ..symbol = 'Table'
        ..url = serverpodUrl(serverCode)
        ..types.add(idTypeReference));

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
        _buildModelTableClassColumnGetter(
          serializedFields,
          name: 'columns',
        ),
        if (hiddenSerializedFields.isNotEmpty)
          _buildModelTableClassColumnGetter(
            serializedFields.difference(hiddenSerializedFields),
            name: 'managedColumns',
          ),
      ]);

      var relationFields = fields.where((f) =>
          f.relation is ObjectRelationDefinition ||
          f.relation is ListRelationDefinition);
      if (relationFields.isNotEmpty) {
        c.methods.add(_buildModelTableClassGetRelationTable(
            relationFields, idTypeReference));
      }
    });
  }

  Method _buildModelTableClassGetRelationTable(
      Iterable<SerializableModelFieldDefinition> relationFields,
      TypeReference idTypeReference) {
    return Method(
      (m) => m
        ..annotations.add(refer('override'))
        ..returns = TypeReference(
          (t) => t
            ..symbol = 'Table'
            ..isNullable = true
            ..url = serverpodUrl(true),
        )
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
    Iterable<SerializableModelFieldDefinition> fields, {
    required String name,
  }) {
    return Method(
      (m) => m
        ..annotations.add(refer('override'))
        ..returns = TypeReference(
          (t) => t
            ..symbol = 'List'
            ..types.add(
              refer('Column', serverpodUrl(true)),
            ),
        )
        ..name = name
        ..lambda = true
        ..type = MethodType.getter
        ..body = literalList(
          fields.map((f) => refer(createFieldName(serverCode, f))),
        ).code,
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
            ..url = serverpodUrl(true)
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
      ) as TypeReference;
      TypeReference tableType = field.type.reference(
        serverCode,
        subDirParts: subDirParts,
        config: config,
        nullable: false,
        typeSuffix: 'Table',
      ) as TypeReference;

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
        ) as TypeReference;
        tableType = (field.type.generics.first).reference(
          serverCode,
          subDirParts: subDirParts,
          config: config,
          nullable: false,
          typeSuffix: 'Table',
        ) as TypeReference;
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
                  serverpodUrl(true),
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
                  serverpodUrl(true),
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
      ..url = serverpodUrl(true)
      ..types.addAll([])).call([
      literalString(field.name),
      refer('this'),
    ], {
      if (field.type.isVectorType)
        'dimension': literalNum(field.type.vectorDimension!),
      if (field.defaultPersistValue != null) 'hasDefault': literalBool(true),
    });
  }

  Expression _buildModelTableEnumFieldTypeReference(
    SerializableModelFieldDefinition field,
  ) {
    assert(field.type.isEnumType);
    var enumType = refer('EnumSerialization', serverpodUrl(serverCode));
    Expression serializedAs;

    switch (field.type.enumDefinition?.serialized) {
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
      ..url = serverpodUrl(true)
      ..types.addAll([])).call([
      literalString(field.name),
      refer('this'),
      serializedAs,
    ], {
      if (field.defaultPersistValue != null) 'hasDefault': literalBool(true),
    });
  }

  Class _buildModelIncludeClass(
    String className,
    List<SerializableModelFieldDefinition> fields,
    ClassDefinition classDefinition,
    TypeReference idTypeReference,
  ) {
    return Class(((c) {
      c.extend = refer('IncludeObject', serverpodUrl(true));
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
        _buildModelIncludeClassTableGetter(className, idTypeReference),
      ]);
    }));
  }

  Class _buildModelIncludeListClass(
    String className,
    List<SerializableModelFieldDefinition> fields,
    ClassDefinition classDefinition,
    TypeReference idTypeReference,
  ) {
    return Class(((c) {
      c.extend = refer('IncludeList', serverpodUrl(true));
      c.name = '${className}IncludeList';

      c.constructors.add(_buildModelIncludeListClassConstructor(className));

      c.methods.addAll([
        _buildModelIncludeListClassIncludesGetter(),
        _buildModelIncludeClassTableGetter(className, idTypeReference),
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
            refer('Include?', serverpodUrl(true)),
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

  Method _buildModelIncludeClassTableGetter(
    String className,
    TypeReference idTypeReference,
  ) {
    return Method(
      (m) => m
        ..annotations.add(refer('override'))
        ..returns = TypeReference((t) => t
          ..symbol = 'Table'
          ..types.add(idTypeReference)
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
            refer('Include?', serverpodUrl(true)),
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
          e.implements
              .add(refer('SerializableModel', serverpodUrl(serverCode)));
          e.values.addAll([
            for (var value in enumDefinition.values)
              EnumValue((v) {
                v
                  ..name = value.name
                  ..docs.addAll(value.documentation ?? []);
              })
          ]);

          // Check if the enum has a value named "name"
          bool hasValueNamedName =
              enumDefinition.values.any((v) => v.name == 'name');

          switch (enumDefinition.serialized) {
            case EnumSerialization.byIndex:
              e.methods.addAll(enumSerializationMethodsByIndex(enumDefinition));
              break;
            case EnumSerialization.byName:
              e.methods.addAll(enumSerializationMethodsByName(
                enumDefinition,
                hasValueNamedName: hasValueNamedName,
              ));
              break;
          }

          e.methods.add(
            Method(
              (m) => m
                ..annotations.add(refer('override'))
                ..returns = refer('String')
                ..name = 'toString'
                ..lambda = true
                ..body = refer(hasValueNamedName ? 'this.name' : 'name').code,
            ),
          );
        }),
      );
    });
    return library;
  }

  List<Method> enumSerializationMethodsByIndex(EnumDefinition enumDefinition) {
    return [
      Method((m) => m
        ..static = true
        ..returns = refer(enumDefinition.className)
        ..name = 'fromJson'
        ..requiredParameters.add(Parameter((p) => p
          ..name = 'index'
          ..type = refer('int')))
        ..body = (BlockBuilder()
              ..statements.addAll([
                const Code('switch(index){'),
                for (int i = 0; i < enumDefinition.values.length; i++)
                  Code(
                    'case $i: return ${enumDefinition.className}.${enumDefinition.values[i].name};',
                  ),
                _buildDefaultSwitchCase(enumDefinition, 'index'),
                const Code('}'),
              ]))
            .build()),
      Method(
        (m) => m
          ..annotations.add(refer('override'))
          ..returns = refer('int')
          ..name = _toJsonMethodName
          ..lambda = true
          ..body = refer('index').code,
      ),
    ];
  }

  List<Method> enumSerializationMethodsByName(
    EnumDefinition enumDefinition, {
    required bool hasValueNamedName,
  }) {
    return [
      Method((m) => m
        ..static = true
        ..returns = refer(enumDefinition.className)
        ..name = 'fromJson'
        ..requiredParameters.add(Parameter((p) => p
          ..name = 'name'
          ..type = refer('String')))
        ..body = (BlockBuilder()
              ..statements.addAll([
                const Code('switch(name){'),
                for (var value in enumDefinition.values)
                  Code(
                    "case '${value.name}': return ${enumDefinition.className}.${value.name};",
                  ),
                _buildDefaultSwitchCase(enumDefinition, 'name'),
                const Code('}'),
              ]))
            .build()),
      Method(
        (m) => m
          ..annotations.add(refer('override'))
          ..returns = refer('String')
          ..name = _toJsonMethodName
          ..lambda = true
          ..body = refer(hasValueNamedName ? 'this.name' : 'name').code,
      ),
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
    return refer(_createSerializableFieldName(serverCode, field));
  }

  String _createSerializableFieldName(
      bool serverCode, SerializableModelFieldDefinition field) {
    if (field.hiddenSerializableField(serverCode) &&
        !field.name.startsWith('_')) {
      return '_${field.name}';
    }

    return field.name;
  }

  Code _buildDefaultSwitchCase(
      EnumDefinition enumDefinition, String valueFieldName) {
    if (enumDefinition.defaultValue == null) {
      return Code(
        'default: throw ArgumentError(\'Value "\$$valueFieldName" cannot be converted to "${enumDefinition.className}"\');',
      );
    }
    return Code(
      'default: return ${enumDefinition.className}.${enumDefinition.defaultValue!.name};',
    );
  }
}

class SimpleData {}

extension on BuildRepositoryClass {
  bool hasRelationWithNonNullableIds(
      List<SerializableModelFieldDefinition> fields) {
    return hasAttachOperations(fields) ||
        hasAttachRowOperations(fields) ||
        hasDetachOperations(fields) ||
        hasDetachRowOperations(fields);
  }
}
