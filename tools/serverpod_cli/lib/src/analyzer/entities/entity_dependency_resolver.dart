import 'dart:math';

import 'package:serverpod_cli/src/analyzer/entities/checker/analyze_checker.dart';
import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:super_string/super_string.dart';

class EntityDependencyResolver {
  /// Resolves dependencies between entities, this method mutates the input.
  static void resolveEntityDependencies(
    List<SerializableEntityDefinition> entityDefinitions,
  ) {
    entityDefinitions.whereType<ClassDefinition>().forEach((classDefinition) {
      for (var fieldDefinition in classDefinition.fields) {
        _resolveProtocolReference(fieldDefinition, entityDefinitions);
        _resolveEnumType(fieldDefinition, entityDefinitions);
        _resolveObjectRelationReference(
          classDefinition,
          fieldDefinition,
          entityDefinitions,
        );
        _resolveListRelationReference(
          classDefinition,
          fieldDefinition,
          entityDefinitions,
        );
      }
    });
  }

  static TypeDefinition _resolveProtocolReference(
      SerializableEntityFieldDefinition fieldDefinition,
      List<SerializableEntityDefinition> entityDefinitions) {
    return fieldDefinition.type = fieldDefinition.type.applyProtocolReferences(
      entityDefinitions,
    );
  }

  static void _resolveEnumType(
      SerializableEntityFieldDefinition fieldDefinition,
      List<SerializableEntityDefinition> entityDefinitions) {
    if (fieldDefinition.type.url == 'protocol') {
      var enumDefinitionList = entityDefinitions
          .whereType<EnumDefinition>()
          .where((e) => e.className == fieldDefinition.type.className)
          .toList();
      if (enumDefinitionList.isNotEmpty) {
        fieldDefinition.type.isEnum = true;
        fieldDefinition.type.enumSerializedAsName =
            enumDefinitionList.first.serializedAsName;
      }
    }
  }

  static void _resolveObjectRelationReference(
    ClassDefinition classDefinition,
    SerializableEntityFieldDefinition fieldDefinition,
    List<SerializableEntityDefinition> entityDefinitions,
  ) {
    var relation = fieldDefinition.relation;
    if (relation is! UnresolvedObjectRelationDefinition) return;

    var referenceClass = entityDefinitions
        .cast<SerializableEntityDefinition?>()
        .firstWhere(
            (entity) => entity?.className == fieldDefinition.type.className,
            orElse: () => null);

    if (referenceClass is! ClassDefinition) return;

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
        fieldDefinition,
        relation,
        tableName,
        relationFieldName,
      );
    } else if (relation.name == null ||
        (foreignField != null && foreignField.type.isListType)) {
      _resolveImplicitDefinedRelation(
        classDefinition,
        fieldDefinition,
        relation,
        tableName,
      );
    } else if (foreignField != null) {
      _resolveNamedForeignObjectRelation(
        fieldDefinition,
        relation,
        tableName,
        foreignField,
      );
    }
  }

  static void _resolveNamedForeignObjectRelation(
    SerializableEntityFieldDefinition fieldDefinition,
    UnresolvedObjectRelationDefinition relation,
    String tableName,
    SerializableEntityFieldDefinition foreignField,
  ) {
    String? foreignFieldName;

    // No need to check ObjectRelationDefinition as it will never be named on
    // the relational origin side. This case is covered by
    // checking the ForeignRelationDefinition.
    var foreignRelation = foreignField.relation;
    if (foreignRelation is UnresolvedObjectRelationDefinition) {
      foreignFieldName = foreignRelation.fieldName;
    } else if (foreignRelation is ForeignRelationDefinition) {
      foreignFieldName = foreignField.name;
    }

    if (foreignFieldName == null) return;

    fieldDefinition.relation = ObjectRelationDefinition(
      name: relation.name,
      parentTable: tableName,
      fieldName: defaultPrimaryKeyName,
      foreignFieldName: foreignFieldName,
      isForeignKeyOrigin: relation.isForeignKeyOrigin,
      nullableRelation: foreignField.type.nullable,
    );
  }

  static void _resolveImplicitDefinedRelation(
    ClassDefinition classDefinition,
    SerializableEntityFieldDefinition fieldDefinition,
    UnresolvedObjectRelationDefinition relation,
    String tableName,
  ) {
    var relationFieldType = relation.nullableRelation
        ? TypeDefinition.int.asNullable
        : TypeDefinition.int;

    var foreignRelationField = SerializableEntityFieldDefinition(
      name: _createImplicitForeignIdFieldName(fieldDefinition.name),
      relation: ForeignRelationDefinition(
        name: relation.name,
        parentTable: tableName,
        foreignFieldName: defaultPrimaryKeyName,
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
      fieldName: '${fieldDefinition.name}Id',
      foreignFieldName: defaultPrimaryKeyName,
      isForeignKeyOrigin: true,
      nullableRelation: relation.nullableRelation,
    );
  }

  static void _resolveManualDefinedRelation(
    ClassDefinition classDefinition,
    SerializableEntityFieldDefinition fieldDefinition,
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

    field.relation = ForeignRelationDefinition(
      name: relation.name,
      parentTable: tableName,
      foreignFieldName: defaultPrimaryKeyName,
      onUpdate: relation.onUpdate,
      onDelete: relation.onDelete,
    );

    fieldDefinition.relation = ObjectRelationDefinition(
      parentTable: tableName,
      fieldName: relationFieldName,
      foreignFieldName: defaultPrimaryKeyName,
      isForeignKeyOrigin: true,
      nullableRelation: field.type.nullable,
    );
  }

  static SerializableEntityFieldDefinition? _findForeignFieldByRelationName(
    ClassDefinition classDefinition,
    ClassDefinition foreignClass,
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
    SerializableEntityFieldDefinition fieldDefinition,
    SerializableEntityFieldDefinition foreignRelationField,
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
    ClassDefinition classDefinition,
    SerializableEntityFieldDefinition fieldDefinition,
    List<SerializableEntityDefinition> entityDefinitions,
  ) {
    var relation = fieldDefinition.relation;
    if (relation is! UnresolvedListRelationDefinition) {
      return;
    }

    var type = fieldDefinition.type;
    var referenceClassName = type.generics.first.className;

    var referenceClass =
        entityDefinitions.cast<SerializableEntityDefinition?>().firstWhere(
              (entity) => entity?.className == referenceClassName,
              orElse: () => null,
            );

    if (referenceClass is! ClassDefinition) return;

    var tableName = classDefinition.tableName;
    if (tableName == null) return;

    if (relation.name == null) {
      var foreignFieldName =
          '_${classDefinition.tableName?.toCamelCase(isLowerCamelCase: true)}${fieldDefinition.name.toCamelCase()}${classDefinition.tableName?.toCamelCase()}Id';

      var autoRelationName = '#_relation_$foreignFieldName';

      referenceClass.fields.add(
        SerializableEntityFieldDefinition(
          name: foreignFieldName,
          type: TypeDefinition.int.asNullable,
          scope: EntityFieldScopeDefinition.none,
          shouldPersist: true,
          relation: ForeignRelationDefinition(
            name: autoRelationName,
            parentTable: tableName,
            foreignFieldName: defaultPrimaryKeyName,
          ),
        ),
      );

      fieldDefinition.relation = ListRelationDefinition(
        name: autoRelationName,
        fieldName: 'id',
        foreignFieldName: foreignFieldName,
        nullableRelation: true,
        implicitForeignField: true,
      );
    } else {
      var foreignFields = referenceClass.fields.where((field) {
        var fieldRelation = field.relation;
        if (!(fieldRelation is UnresolvedObjectRelationDefinition ||
            fieldRelation is ForeignRelationDefinition)) return false;
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

      if (foreignFieldName == null) return;

      fieldDefinition.relation = ListRelationDefinition(
        name: relation.name,
        fieldName: 'id',
        foreignFieldName: foreignFieldName,
        nullableRelation: foreignFields.first.type.nullable,
      );
    }
  }

  static String _createImplicitForeignIdFieldName(String fieldName) {
    return '${fieldName}Id';
  }
}
