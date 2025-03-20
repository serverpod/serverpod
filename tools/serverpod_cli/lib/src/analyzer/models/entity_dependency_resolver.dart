import 'dart:math';

import 'package:serverpod_cli/src/analyzer/models/checker/analyze_checker.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:super_string/super_string.dart';

class ModelDependencyResolver {
  /// Resolves dependencies between models, this method mutates the input.
  static void resolveModelDependencies(
    List<SerializableModelDefinition> modelDefinitions,
  ) {
    modelDefinitions.whereType<ClassDefinition>().forEach((classDefinition) {
      if (classDefinition is ModelClassDefinition) {
        _resolveInheritance(classDefinition, modelDefinitions);
      }
      _resolveImplements(classDefinition, modelDefinitions);

      var fields = classDefinition is ModelClassDefinition
          ? classDefinition.allFields
          : classDefinition.fields;

      for (var fieldDefinition in fields) {
        _resolveProtocolReference(fieldDefinition, modelDefinitions);
        _resolveEnumType(fieldDefinition.type, modelDefinitions);

        if (classDefinition is! ModelClassDefinition) continue;

        _resolveFieldIndexes(fieldDefinition, classDefinition);
        _resolveObjectRelationReference(
          classDefinition,
          fieldDefinition,
          modelDefinitions,
        );
        _resolveListRelationReference(
          classDefinition,
          fieldDefinition,
          modelDefinitions,
        );
      }
    });
  }

  static void _resolveInheritance(
    ModelClassDefinition classDefinition,
    List<SerializableModelDefinition> modelDefinitions,
  ) {
    var extendedClass = classDefinition.extendsClass;
    if (extendedClass is! UnresolvedInheritanceDefinition) {
      return;
    }
    var parentClassName = extendedClass.className;

    var parentClass = modelDefinitions
        .whereType<ModelClassDefinition>()
        .where((element) => element.className == parentClassName)
        .firstOrNull;

    if (parentClass == null) {
      return;
    }

    classDefinition.extendsClass = ResolvedInheritanceDefinition(parentClass);

    parentClass.childClasses.add(
      ResolvedInheritanceDefinition(classDefinition),
    );
  }

  static void _resolveImplements(
    ClassDefinition classDefinition,
    List<SerializableModelDefinition> modelDefinitions,
  ) {
    if (classDefinition.isImplementing.isEmpty) {
      return;
    }

    var resolvedImplements = <ImplementsDefinition>[];

    for (var implementedClass in classDefinition.isImplementing) {
      if (implementedClass is! UnresolvedImplementsDefinition) {
        continue;
      }

      var interfaceClass = modelDefinitions
          .whereType<InterfaceClassDefinition>()
          .where((element) => element.className == implementedClass.className)
          .where((element) =>
              element.type.moduleAlias == classDefinition.type.moduleAlias)
          .firstOrNull;

      if (interfaceClass != null) {
        resolvedImplements.add(ResolvedImplementsDefinition(interfaceClass));
      }
    }
    classDefinition.isImplementing = resolvedImplements;
  }

  static void _resolveFieldIndexes(
    SerializableModelFieldDefinition fieldDefinition,
    ModelClassDefinition classDefinition,
  ) {
    var indexes = classDefinition.indexes;
    if (indexes.isEmpty) return;

    var indexesContainingField = indexes
        .where((index) => index.fields.contains(fieldDefinition.name))
        .toList();

    fieldDefinition.indexes = indexesContainingField;
  }

  static TypeDefinition _resolveProtocolReference(
      SerializableModelFieldDefinition fieldDefinition,
      List<SerializableModelDefinition> modelDefinitions) {
    return fieldDefinition.type = fieldDefinition.type.applyProtocolReferences(
      modelDefinitions,
    );
  }

  static void _resolveEnumType(
    TypeDefinition typeDefinition,
    List<SerializableModelDefinition> modelDefinitions,
  ) {
    if (typeDefinition.generics.isNotEmpty) {
      for (var genericType in typeDefinition.generics) {
        _resolveEnumType(genericType, modelDefinitions);
      }
      return;
    }

    var enumDefinitionList = modelDefinitions.whereType<EnumDefinition>().where(
        (e) =>
            e.className == typeDefinition.className &&
            e.type.moduleAlias == typeDefinition.moduleAlias);

    if (enumDefinitionList.isEmpty) return;

    typeDefinition.enumDefinition = enumDefinitionList.first;
  }

  static void _resolveObjectRelationReference(
    ModelClassDefinition classDefinition,
    SerializableModelFieldDefinition fieldDefinition,
    List<SerializableModelDefinition> modelDefinitions,
  ) {
    var relation = fieldDefinition.relation;
    if (relation is! UnresolvedObjectRelationDefinition) return;

    var referenceClass = modelDefinitions
        .cast<SerializableModelDefinition?>()
        .firstWhere(
            (model) =>
                model?.className == fieldDefinition.type.className &&
                model?.type.moduleAlias == fieldDefinition.type.moduleAlias,
            orElse: () => null);

    if (referenceClass is! ModelClassDefinition) return;

    var tableName = referenceClass.tableName;
    if (tableName is! String) return;

    var foreignField = _findForeignFieldByRelationName(
      classDefinition,
      referenceClass,
      fieldDefinition.name,
      relation.name,
    );

    var relationFieldName = relation.fieldName;
    if (relationFieldName != null) {
      _resolveManualDefinedRelation(
        classDefinition,
        referenceClass,
        fieldDefinition,
        relation,
        tableName,
        relationFieldName,
      );
    } else if (relation.name == null ||
        (foreignField != null && foreignField.type.isListType)) {
      _resolveImplicitDefinedRelation(
        classDefinition,
        referenceClass,
        fieldDefinition,
        relation,
        tableName,
      );
    } else if (foreignField != null) {
      _resolveNamedForeignObjectRelation(
        classDefinition,
        referenceClass,
        fieldDefinition,
        relation,
        tableName,
        foreignField,
      );
    }
  }

  static void _resolveNamedForeignObjectRelation(
    ModelClassDefinition classDefinition,
    ModelClassDefinition referenceClass,
    SerializableModelFieldDefinition fieldDefinition,
    UnresolvedObjectRelationDefinition relation,
    String tableName,
    SerializableModelFieldDefinition foreignField,
  ) {
    String? foreignFieldName;

    SerializableModelFieldDefinition? foreignContainerField;

    // No need to check ObjectRelationDefinition as it will never be named on
    // the relational origin side. This case is covered by
    // checking the ForeignRelationDefinition.
    var foreignRelation = foreignField.relation;
    if (foreignRelation is UnresolvedObjectRelationDefinition) {
      foreignFieldName = foreignRelation.fieldName;
      foreignContainerField = foreignField;
    } else if (foreignRelation is ForeignRelationDefinition) {
      foreignFieldName = foreignField.name;
      foreignRelation.foreignContainerField = fieldDefinition;
      foreignContainerField = foreignRelation.containerField;
    }

    if (foreignFieldName == null) return;

    fieldDefinition.relation = ObjectRelationDefinition(
      name: relation.name,
      parentTableIdType: relation.isForeignKeyOrigin
          ? classDefinition.idField.type
          : referenceClass.idField.type,
      parentTable: tableName,
      fieldName: defaultPrimaryKeyName,
      foreignFieldName: foreignFieldName,
      foreignContainerField: foreignContainerField,
      isForeignKeyOrigin: relation.isForeignKeyOrigin,
      nullableRelation: foreignField.type.nullable,
    );
  }

  static void _resolveImplicitDefinedRelation(
    ModelClassDefinition classDefinition,
    ModelClassDefinition referenceDefinition,
    SerializableModelFieldDefinition fieldDefinition,
    UnresolvedObjectRelationDefinition relation,
    String tableName,
  ) {
    var relationFieldType = relation.nullableRelation
        ? referenceDefinition.idField.type.asNullable
        : referenceDefinition.idField.type.asNonNullable;

    var foreignFields = AnalyzeChecker.filterRelationByName(
      classDefinition,
      referenceDefinition,
      fieldDefinition.name,
      relation.name,
    );

    SerializableModelFieldDefinition? foreignContainerField;

    if (foreignFields.isNotEmpty) {
      foreignContainerField = foreignFields.first;
    }

    var foreignRelationField = SerializableModelFieldDefinition(
      name: _createImplicitForeignIdFieldName(fieldDefinition.name),
      relation: ForeignRelationDefinition(
        name: relation.name,
        parentTable: tableName,
        foreignFieldName: defaultPrimaryKeyName,
        containerField: fieldDefinition,
        foreignContainerField: foreignContainerField,
        onUpdate: relation.onUpdate,
        onDelete: relation.onDelete,
      ),
      shouldPersist: true,
      scope: fieldDefinition.scope,
      type: relationFieldType,
    );

    _injectForeignRelationField(
      classDefinition,
      fieldDefinition,
      foreignRelationField,
    );

    fieldDefinition.relation = ObjectRelationDefinition(
      parentTable: tableName,
      parentTableIdType: classDefinition.idField.type,
      fieldName: foreignRelationField.name,
      foreignFieldName: defaultPrimaryKeyName,
      foreignContainerField: foreignContainerField,
      isForeignKeyOrigin: true,
      nullableRelation: relation.nullableRelation,
    );
  }

  static void _resolveManualDefinedRelation(
    ModelClassDefinition classDefinition,
    ModelClassDefinition referenceDefinition,
    SerializableModelFieldDefinition fieldDefinition,
    UnresolvedObjectRelationDefinition relation,
    String tableName,
    String relationFieldName,
  ) {
    var field = classDefinition.findField(relationFieldName);
    if (field == null) return;

    if (field.relation != null) {
      fieldDefinition.relation = UnresolvableObjectRelationDefinition(
        relation,
        UnresolvableReason.relationAlreadyDefinedForField,
      );
      return;
    }

    SerializableModelFieldDefinition? foreignContainerField;

    if (relation.name != null) {
      foreignContainerField = _findForeignFieldByRelationName(
        classDefinition,
        referenceDefinition,
        relationFieldName,
        relation.name,
      );
    }

    field.relation = ForeignRelationDefinition(
      name: relation.name,
      parentTable: tableName,
      foreignFieldName: defaultPrimaryKeyName,
      containerField: fieldDefinition,
      foreignContainerField: foreignContainerField,
      onUpdate: relation.onUpdate,
      onDelete: relation.onDelete,
    );

    fieldDefinition.relation = ObjectRelationDefinition(
      parentTable: tableName,
      parentTableIdType: classDefinition.idField.type,
      fieldName: relationFieldName,
      foreignFieldName: defaultPrimaryKeyName,
      foreignContainerField: foreignContainerField,
      isForeignKeyOrigin: true,
      nullableRelation: field.type.nullable,
    );
  }

  static SerializableModelFieldDefinition? _findForeignFieldByRelationName(
    ModelClassDefinition classDefinition,
    ModelClassDefinition foreignClass,
    String fieldName,
    String? relationName,
  ) {
    var foreignFields = AnalyzeChecker.filterRelationByName(
      classDefinition,
      foreignClass,
      fieldName,
      relationName,
    );
    if (foreignFields.isEmpty) return null;

    return foreignFields.first;
  }

  static void _injectForeignRelationField(
    ClassDefinition classDefinition,
    SerializableModelFieldDefinition fieldDefinition,
    SerializableModelFieldDefinition foreignRelationField,
  ) {
    var insertIndex = max(
      classDefinition.fields.indexOf(fieldDefinition),
      0,
    );
    classDefinition.fields = [
      ...classDefinition.fields.take(insertIndex),
      foreignRelationField,
      ...classDefinition.fields.skip(insertIndex),
    ];
  }

  static void _resolveListRelationReference(
    ModelClassDefinition classDefinition,
    SerializableModelFieldDefinition fieldDefinition,
    List<SerializableModelDefinition> modelDefinitions,
  ) {
    var relation = fieldDefinition.relation;
    if (relation is! UnresolvedListRelationDefinition) {
      return;
    }

    if (fieldDefinition.type.generics.isEmpty) {
      // Having other than 1 generics on a list type is an error, but we can not throw that here without breaking all parsing.
      // The appropriate check is being done in `restrictions.dart` (`_validateFieldDataType`)
      return;
    }

    var type = fieldDefinition.type;
    var referenceClassName = type.generics.first.className;

    var referenceClass =
        modelDefinitions.cast<SerializableModelDefinition?>().firstWhere(
              (model) => model?.className == referenceClassName,
              orElse: () => null,
            );

    if (referenceClass is! ModelClassDefinition) return;

    var tableName = classDefinition.tableName;
    if (tableName == null) return;

    if (relation.name == null) {
      var foreignFieldName = _createImplicitListForeignFieldName(
        classDefinition.tableName,
        fieldDefinition.name,
      );

      var autoRelationName = '#_relation_$foreignFieldName';

      var foreignField = SerializableModelFieldDefinition(
        name: foreignFieldName,
        type: classDefinition.idField.type.asNullable,
        scope: ModelFieldScopeDefinition.none,
        shouldPersist: true,
        relation: ForeignRelationDefinition(
          name: autoRelationName,
          parentTable: tableName,
          foreignFieldName: defaultPrimaryKeyName,
          containerField: null, // Will never be set on implicit list relations.
          foreignContainerField: fieldDefinition,
        ),
      );

      referenceClass.fields.add(
        foreignField,
      );

      fieldDefinition.relation = ListRelationDefinition(
        name: autoRelationName,
        foreignKeyOwnerIdType: classDefinition.idField.type,
        fieldName: defaultPrimaryKeyName,
        foreignFieldName: foreignFieldName,
        foreignContainerField:
            null, // Will never be set on implicit list relations.
        nullableRelation: true,
        implicitForeignField: true,
      );
    } else {
      var foreignFields = referenceClass.fields.where((field) {
        var fieldRelation = field.relation;
        if (!(fieldRelation is UnresolvedObjectRelationDefinition ||
            fieldRelation is ForeignRelationDefinition)) {
          return false;
        }
        return fieldRelation?.name == relation.name;
      });

      if (foreignFields.isEmpty) return;

      var foreignField = foreignFields.first;

      String? foreignFieldName;

      var foreignRelation = foreignField.relation;
      if (foreignRelation is ForeignRelationDefinition) {
        foreignFieldName = foreignField.name;
      } else if (foreignRelation is UnresolvedObjectRelationDefinition) {
        foreignFieldName = foreignRelation.fieldName ??
            _createImplicitForeignIdFieldName(foreignField.name);
      }

      SerializableModelFieldDefinition? foreignContainerField;
      if (foreignRelation is ForeignRelationDefinition) {
        foreignRelation.foreignContainerField = fieldDefinition;
        foreignContainerField = foreignRelation.containerField;
      } else if (foreignRelation is UnresolvedObjectRelationDefinition) {
        foreignContainerField = foreignField;
      }

      if (foreignFieldName == null) return;

      fieldDefinition.relation = ListRelationDefinition(
        name: relation.name,
        foreignKeyOwnerIdType: referenceClass.idField.type,
        fieldName: defaultPrimaryKeyName,
        foreignFieldName: foreignFieldName,
        foreignContainerField: foreignContainerField,
        nullableRelation: foreignFields.first.type.nullable,
      );
    }
  }

  static String _createImplicitListForeignFieldName(
    String? tableName,
    String fieldName,
  ) {
    return _createImplicitForeignIdFieldName(
      '_${tableName?.toCamelCase(isLowerCamelCase: true)}${fieldName.toCamelCase()}${tableName?.toCamelCase()}',
    );
  }

  static String _createImplicitForeignIdFieldName(String fieldName) {
    var truncatedFieldName = truncateIdentifier(
      fieldName,
      DatabaseConstants.pgsqlMaxNameLimitation - 2,
    );
    return '${truncatedFieldName}Id';
  }
}
