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
    // First resolve inheritance to allow evaluating inherited id fields.
    modelDefinitions.whereType<ModelClassDefinition>().forEach((
      classDefinition,
    ) {
      _resolveInheritance(classDefinition, modelDefinitions);
    });

    // Then resolve inherited id fields or create default id fields.
    modelDefinitions.whereType<ModelClassDefinition>().forEach((
      classDefinition,
    ) {
      _resolveIdField(classDefinition);
    });

    // Then resolve everything else, including relations on inherited ids.
    // Class order still matters: list resolution on the owner reads the element
    // type's fields, so process list element models before list owners.
    final classDefs = modelDefinitions.whereType<ClassDefinition>().toList();
    final originalIndex = {
      for (var i = 0; i < classDefs.length; i++) classDefs[i]: i,
    };
    final modelClasses = classDefs.whereType<ModelClassDefinition>().toList();
    final topologicalRank = _topologicalRankForListDependencies(
      modelClasses,
      modelDefinitions,
    );

    classDefs.sort((a, b) {
      if (a is ModelClassDefinition && b is ModelClassDefinition) {
        final cmp = topologicalRank[a.className]!.compareTo(
          topologicalRank[b.className]!,
        );
        if (cmp != 0) return cmp;
      }
      return originalIndex[a]!.compareTo(originalIndex[b]!);
    });

    for (final classDefinition in classDefs) {
      var fields = classDefinition is ModelClassDefinition
          ? classDefinition.fieldsIncludingInherited
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
    }
  }

  /// Lower rank = process earlier. For each list field `List<R>`, [R] is
  /// ordered before the owner so list resolution sees the foreign class ready.
  static Map<String, int> _topologicalRankForListDependencies(
    List<ModelClassDefinition> models,
    List<SerializableModelDefinition> modelDefinitions,
  ) {
    final nameToModel = {for (final m in models) m.className: m};
    final firstOrder = <String, int>{};
    for (var i = 0; i < modelDefinitions.length; i++) {
      final m = modelDefinitions[i];
      if (m is ModelClassDefinition) {
        firstOrder.putIfAbsent(m.className, () => i);
      }
    }

    final inDegree = <String, int>{};
    final adj = <String, List<String>>{};

    for (final m in models) {
      inDegree[m.className] = 0;
    }

    for (final owner in models) {
      for (final field in owner.fields) {
        if (field.relation is! UnresolvedListRelationDefinition) continue;
        if (field.type.generics.isEmpty) continue;
        final refName = field.type.generics.first.className;
        if (!nameToModel.containsKey(refName)) continue;
        if (refName == owner.className) continue;
        adj.putIfAbsent(refName, () => []).add(owner.className);
        inDegree[owner.className] = (inDegree[owner.className] ?? 0) + 1;
      }
    }

    final ready =
        models
            .where((m) => inDegree[m.className] == 0)
            .map((m) => m.className)
            .toList()
          ..sort((a, b) => firstOrder[a]!.compareTo(firstOrder[b]!));

    final rank = <String, int>{};
    var r = 0;
    while (ready.isNotEmpty) {
      final n = ready.removeAt(0);
      rank[n] = r++;
      for (final owner in adj[n] ?? []) {
        inDegree[owner] = inDegree[owner]! - 1;
        if (inDegree[owner] == 0) {
          ready.add(owner);
          ready.sort((a, b) => firstOrder[a]!.compareTo(firstOrder[b]!));
        }
      }
    }

    var next = r;
    final remaining =
        models.where((m) => !rank.containsKey(m.className)).toList()..sort(
          (a, b) =>
              firstOrder[a.className]!.compareTo(firstOrder[b.className]!),
        );
    for (final m in remaining) {
      rank[m.className] = next++;
    }
    return rank;
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

  static void _resolveIdField(ModelClassDefinition classDefinition) {
    if (classDefinition.tableName == null) return;

    final defaultIdType = SupportedIdType.int;

    var maybeIdField =
        classDefinition.parentClass?.fieldsIncludingInherited
            .where((f) => f.name == defaultPrimaryKeyName)
            .firstOrNull ??
        classDefinition.fields
            .where((f) => f.name == defaultPrimaryKeyName)
            .firstOrNull;

    var idFieldType = maybeIdField?.type ?? defaultIdType.type.asNullable;

    var defaultPersistValue = (maybeIdField != null)
        ? maybeIdField.defaultPersistValue
        : defaultIdType.defaultValue;

    // The 'int' id type can be specified without a default value.
    if (maybeIdField?.type.className == 'int') {
      defaultPersistValue ??= SupportedIdType.int.defaultValue;
    }

    var defaultModelValue = maybeIdField?.defaultModelValue;
    if (maybeIdField == null && defaultIdType.type.className != 'int') {
      defaultModelValue ??= defaultIdType.defaultValue;
    }

    late List<String> defaultIdFieldDoc;
    if (idFieldType.nullable && defaultModelValue == null) {
      defaultIdFieldDoc = [
        '/// The database id, set if the object has been inserted into the',
        '/// database or if it has been fetched from the database. Otherwise,',
        '/// the id will be null.',
      ];
    } else {
      defaultIdFieldDoc = [
        '/// The id of the object.',
      ];
    }

    classDefinition.fields.removeWhere((f) => f.name == defaultPrimaryKeyName);
    classDefinition.fields.insert(
      0,
      SerializableModelFieldDefinition(
        name: defaultPrimaryKeyName,
        type: idFieldType,
        scope: maybeIdField?.scope ?? ModelFieldScopeDefinition.all,
        defaultModelValue: defaultModelValue,
        defaultPersistValue: defaultPersistValue ?? defaultModelValue,
        shouldPersist: true,
        documentation: maybeIdField?.documentation ?? defaultIdFieldDoc,
        isRequired: false, // ID fields are typically optional
      ),
    );
  }

  static void _resolveFieldIndexes(
    SerializableModelFieldDefinition fieldDefinition,
    ModelClassDefinition classDefinition,
  ) {
    var indexes = classDefinition.indexesIncludingInherited;
    if (indexes.isEmpty) return;

    var indexesContainingField = indexes
        .where((index) => index.fields.contains(fieldDefinition.columnName))
        .toList();

    fieldDefinition.indexes = indexesContainingField;
  }

  static TypeDefinition _resolveProtocolReference(
    SerializableModelFieldDefinition fieldDefinition,
    List<SerializableModelDefinition> modelDefinitions,
  ) {
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
          e.type.moduleAlias == typeDefinition.moduleAlias,
    );

    // If no enum in same module (e.g. protocol), allow reference from shared package
    if (enumDefinitionList.isEmpty) {
      enumDefinitionList = modelDefinitions
          .whereType<EnumDefinition>()
          .where((e) => e.className == typeDefinition.className)
          .toList();
    }

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
          orElse: () => null,
        );

    if (referenceClass is! ModelClassDefinition) return;

    var tableName = referenceClass.tableName;
    if (tableName is! String) return;

    // Skip resolution if the class defining the relation doesn't have a table.
    // The validation layer will report the appropriate error message.
    if (classDefinition.tableName == null) return;

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
      isRequired: false,
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

    var referenceClass = modelDefinitions
        .cast<SerializableModelDefinition?>()
        .firstWhere(
          (model) => model?.className == referenceClassName,
          orElse: () => null,
        );

    if (referenceClass is! ModelClassDefinition) return;

    var tableName = classDefinition.tableName;
    if (tableName == null) return;

    // Skip resolution if the referenced class doesn't have a table.
    // The validation layer will report the appropriate error message.
    if (referenceClass.tableName == null) return;

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
        isRequired: false,
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
        // Include [ObjectRelationDefinition]: the foreign side may already be
        // resolved when the list side runs (model definition order-dependent).
        // Include [UnresolvableObjectRelationDefinition]: when the list owner is
        // processed after the element type, object resolution may fail on the
        // foreign row until the owner exists; the list side must still see the
        // object field for nullableRelation (detach) and not only the id field.
        if (!(fieldRelation is UnresolvedObjectRelationDefinition ||
            fieldRelation is ForeignRelationDefinition ||
            fieldRelation is ObjectRelationDefinition ||
            fieldRelation is UnresolvableObjectRelationDefinition)) {
          return false;
        }
        if (fieldRelation?.name == relation.name) return true;
        return _objectFieldPairsWithNamedForeignKey(
          referenceClass,
          field,
          relation.name,
        );
      });

      if (foreignFields.isEmpty) return;

      var foreignField = foreignFields.first;

      String? foreignFieldName;

      var foreignRelation = foreignField.relation;
      if (foreignRelation is ForeignRelationDefinition) {
        foreignFieldName = foreignField.name;
      } else if (foreignRelation is UnresolvedObjectRelationDefinition) {
        foreignFieldName =
            foreignRelation.fieldName ??
            _createImplicitForeignIdFieldName(foreignField.name);
      } else if (foreignRelation is ObjectRelationDefinition) {
        foreignFieldName = foreignField.name;
      } else if (foreignRelation is UnresolvableObjectRelationDefinition) {
        foreignFieldName =
            foreignRelation.objectRelationDefinition.fieldName ??
            _createImplicitForeignIdFieldName(foreignField.name);
      }

      SerializableModelFieldDefinition? foreignContainerField;
      if (foreignRelation is ForeignRelationDefinition) {
        foreignRelation.foreignContainerField = fieldDefinition;
        foreignContainerField = foreignRelation.containerField;
      } else if (foreignRelation is UnresolvedObjectRelationDefinition) {
        foreignContainerField = foreignField;
      } else if (foreignRelation is ObjectRelationDefinition) {
        foreignRelation.foreignContainerField = fieldDefinition;
        foreignContainerField = foreignField;
      } else if (foreignRelation is UnresolvableObjectRelationDefinition) {
        foreignContainerField = foreignField;
      }

      if (foreignFieldName == null) return;

      fieldDefinition.relation = ListRelationDefinition(
        name: relation.name,
        foreignKeyOwnerIdType: referenceClass.idField.type,
        fieldName: defaultPrimaryKeyName,
        foreignFieldName: foreignFieldName,
        foreignContainerField: foreignContainerField,
        nullableRelation: _nullableRelationForListSide(foreignFields),
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

  /// Implicit/named object resolution stores [RelationDefinition.name] only on
  /// the FK field, not on [ObjectRelationDefinition], so list resolution must
  /// still associate the object field with the named relation for nullableRelation.
  static bool _objectFieldPairsWithNamedForeignKey(
    ModelClassDefinition referenceClass,
    SerializableModelFieldDefinition field,
    String? relationName,
  ) {
    if (relationName == null) return false;
    final fieldRelation = field.relation;
    if (fieldRelation is! ObjectRelationDefinition) return false;
    if (fieldRelation.name != null) return false;
    return referenceClass.fields.any(
      (f) =>
          f.relation is ForeignRelationDefinition &&
          f.relation?.name == relationName &&
          f.name == fieldRelation.fieldName,
    );
  }

  /// Prefer the object-side field when both it and an injected id field share
  /// the same relation name (id is non-nullable; optional relations are on the
  /// object field).
  static bool _nullableRelationForListSide(
    Iterable<SerializableModelFieldDefinition> foreignFields,
  ) {
    final objectSideFields = foreignFields.where(
      (f) =>
          f.relation is ObjectRelationDefinition ||
          f.relation is UnresolvedObjectRelationDefinition ||
          f.relation is UnresolvableObjectRelationDefinition,
    );
    if (objectSideFields.isNotEmpty) {
      return objectSideFields.first.type.nullable;
    }
    return foreignFields.first.type.nullable;
  }
}
