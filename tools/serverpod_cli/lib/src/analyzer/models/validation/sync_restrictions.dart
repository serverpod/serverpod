/// Rules that models with `database: sync` must satisfy so that the
/// `serverpod_offline_sync` package can merge conflicting changes.
///
/// The rules mirror the runtime checks performed by the sync engine when it
/// initializes, so violations are reported by `serverpod generate` instead of
/// failing when the server or the client starts.
library;

import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/model_relations.dart';

/// The field every synced model must declare to hold the owner scope of a row.
const String syncScopeIdFieldName = 'scopeId';

/// The table holding the sync scopes, owned by the `serverpod_offline_sync`
/// module.
const String syncScopesTableName = 'crdt_scopes';

extension ModelClassDefinitionSync on ModelClassDefinition {
  /// Whether this model is a table synchronized between client and server.
  bool get isSyncTable =>
      tableName != null && database == ModelDatabaseDefinition.sync;

  /// The `scopeId` field of this model, including inherited fields.
  SerializableModelFieldDefinition? get syncScopeIdField =>
      fieldsIncludingInherited
          .where((field) => field.name == syncScopeIdFieldName)
          .firstOrNull;
}

/// Whether [foreignKeyField] is the `scopeId` ownership link of a sync table.
///
/// The link is identified by the field name alone. Its parent table, delete
/// action and column name are validated separately, so a mistake on one of
/// them is reported once instead of cascading into the errors meant for the
/// remaining relations.
bool isSyncScopeRelation(SerializableModelFieldDefinition foreignKeyField) {
  return foreignKeyField.name == syncScopeIdFieldName &&
      foreignKeyField.relation is ForeignRelationDefinition;
}

/// The error reported when the primary key of a sync table is not a UUID.
const String syncIdFieldError =
    'Tables with "database: sync" must have a UUID primary key. Declare the '
    'id field as "id: UuidValue?, defaultPersist=random_v7".';

/// The error reported when the scopes table is unknown, which happens when
/// the `serverpod_offline_sync` module is not part of the project.
const String syncModuleMissingError =
    'The "database: sync" option requires the "serverpod_offline_sync" '
    'module. Add it to the "modules" section of the generator.yaml file.';

/// Validates that the primary key [idField] of a sync table is a UUID.
bool isSyncIdFieldValid(SerializableModelFieldDefinition idField) {
  if (idField.type.className == 'UuidValue') return true;
  return false;
}

/// Validates the type of the `scopeId` [field] of a sync table.
String? validateSyncScopeIdFieldType(SerializableModelFieldDefinition field) {
  if (field.type.className == 'int' && field.type.nullable) return null;
  return 'The "$syncScopeIdFieldName" field must be of type "int?" on tables '
      'with "database: sync".';
}

/// Validates that the `scopeId` [field] of a sync table declares a relation
/// to the scopes table.
String? validateSyncScopeIdFieldRelation(
  SerializableModelFieldDefinition field,
) {
  var relation = field.relation;
  if (relation is ForeignRelationDefinition) return null;
  return 'The "$syncScopeIdFieldName" field must declare the relation '
      '"relation(parent=$syncScopesTableName, onDelete=Cascade)" on tables '
      'with "database: sync".';
}

/// Validates that the `scopeId` field of a sync table references the scopes
/// table through [parentTable].
String? validateSyncScopeIdParentTable(String parentTable) {
  if (parentTable == syncScopesTableName) return null;
  return 'The "$syncScopeIdFieldName" field must reference the '
      '"$syncScopesTableName" table on tables with "database: sync".';
}

/// The error reported when the `scopeId` field of a sync table overrides its
/// column name.
const String syncScopeIdColumnNameError =
    'The "$syncScopeIdFieldName" field must not override its column name on '
    'tables with "database: sync".';

/// The error reported when the `scopeId` relation of a sync table does not
/// cascade on delete.
const String syncScopeRelationOnDeleteError =
    'The "$syncScopeIdFieldName" relation must use "onDelete=Cascade".';

/// The error reported when the `scopeId` relation of a sync table is
/// deferrable or deferred.
const String syncScopeRelationDeferrableError =
    'The "$syncScopeIdFieldName" relation must not be deferrable or deferred.';

/// The error reported when a foreign key of a sync table is not deferred.
const String syncRelationDeferredError =
    'Relations on tables with "database: sync" must be deferred. Add the '
    '"deferred" keyword to the relation.';

/// Validates that a relation between [model] and [relatedModel] does not
/// cross the boundary between synced and non-synced tables.
///
/// The only allowed relation crossing the boundary is the `scopeId` link from
/// a synced table to the scopes table. [foreignKeyField] is the field on
/// [model] carrying the foreign key, when [model] originates it.
String? validateSyncRelationBoundary({
  required ModelClassDefinition model,
  required ModelClassDefinition relatedModel,
  required SerializableModelFieldDefinition? foreignKeyField,
}) {
  if (model.isSyncTable == relatedModel.isSyncTable) return null;

  if (model.isSyncTable) {
    if (foreignKeyField != null && isSyncScopeRelation(foreignKeyField)) {
      return null;
    }
    return 'Tables with "database: sync" can only have relations to other '
        'tables with "database: sync". The related class '
        '"${relatedModel.className}" has "database: '
        '${relatedModel.database.name}".';
  }

  return 'Tables without "database: sync" cannot have relations to tables '
      'with "database: sync". The related class "${relatedModel.className}" '
      'has "database: sync".';
}

/// Validates that the unique [index] on the sync table [model] can be merged
/// by the sync engine.
///
/// Unique indexes must be scoped by including the `scopeId` column and must
/// contain at least one other column that can be released on conflicts. The
/// only global unique indexes allowed are those composed exclusively of
/// nullable foreign keys to other sync tables.
String? validateSyncUniqueIndex(
  ModelClassDefinition model,
  SerializableModelIndexDefinition index,
  ParsedModelsCollection parsedModels,
) {
  if (!index.unique) return null;

  var fieldsByColumn = {
    for (var field in model.fieldsIncludingInherited) field.columnName: field,
  };
  var columns = index.fields
      .map((column) => fieldsByColumn[column])
      .nonNulls
      .toList();

  // Fields that could not be resolved are reported by the index validation.
  if (columns.length != index.fields.length) return null;

  var otherColumns = columns
      .where((field) => field.columnName != syncScopeIdFieldName)
      .toList();

  if (otherColumns.length != columns.length) {
    if (otherColumns.any(_isSyncReleasableColumn)) return null;

    return 'The unique index "${index.name}" must include at least one '
        'field besides "$syncScopeIdFieldName" that is nullable, a String, '
        'or a UuidValue without a relation, so the sync engine can resolve '
        'conflicts.';
  }

  var isForeignKeyOnly = columns.every(
    (field) => _isSyncForeignKeyColumn(field, parsedModels),
  );
  if (!isForeignKeyOnly) {
    return 'The unique index "${index.name}" must include the '
        '"$syncScopeIdFieldName" field on tables with "database: sync". '
        'Only unique indexes composed exclusively of relations to other '
        'tables with "database: sync" can be global.';
  }

  var requiredColumns = columns.where((field) => !field.type.nullable);
  if (requiredColumns.isNotEmpty) {
    return 'The unique index "${index.name}" requires the relation fields '
        '${requiredColumns.map((f) => '"${f.name}"').join(', ')} to be '
        'nullable on tables with "database: sync". Make the relations '
        'optional.';
  }

  return null;
}

bool _isSyncReleasableColumn(SerializableModelFieldDefinition field) {
  if (field.type.nullable) return true;
  if (field.type.className == 'String') return true;
  return field.type.className == 'UuidValue' &&
      field.relation is! ForeignRelationDefinition;
}

bool _isSyncForeignKeyColumn(
  SerializableModelFieldDefinition field,
  ParsedModelsCollection parsedModels,
) {
  var relation = field.relation;
  if (relation is! ForeignRelationDefinition) return false;

  var parent = parsedModels.findByTableName(relation.parentTable);
  return parent is ModelClassDefinition && parent.isSyncTable;
}
