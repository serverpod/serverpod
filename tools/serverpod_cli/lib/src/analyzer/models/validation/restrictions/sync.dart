/// Rules that models with `database: sync` must satisfy so that the
/// `serverpod_offline_sync` package can merge conflicting changes.
///
/// The rules mirror the runtime checks performed by the sync engine when it
/// initializes, so violations are reported by `serverpod generate` instead of
/// failing when the server or the client starts.
library;

import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/utils/model_relation_utils.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/model_relations.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';

/// The field every synced model must declare to hold the owner space of a row.
const String syncSpaceIdFieldName = 'spaceId';

/// The table holding the sync spaces, owned by the `serverpod_offline_sync`
/// module.
const String syncSpacesTableName = 'offline_sync_spaces';

/// The name of the `serverpod_offline_sync` module.
const String syncModuleName = 'serverpod_offline_sync';

extension GeneratorConfigSyncModule on GeneratorConfig {
  /// The `serverpod_offline_sync` module, when the `databaseSync` experimental
  /// feature is enabled and the module is a dependency of the project.
  ModuleConfig? get syncModule {
    if (!isExperimentalFeatureEnabled(ExperimentalFeature.databaseSync)) {
      return null;
    }
    for (var module in modules) {
      if (module.name == syncModuleName) return module;
    }
    return null;
  }
}

extension ModelClassDefinitionSync on ModelClassDefinition {
  /// Whether this model is a table synchronized between client and server.
  bool get isSyncTable =>
      tableName != null && database == ModelDatabaseDefinition.sync;

  /// The `spaceId` field of this model, including inherited fields.
  SerializableModelFieldDefinition? get syncSpaceIdField =>
      fieldsIncludingInherited
          .where((field) => field.name == syncSpaceIdFieldName)
          .firstOrNull;
}

/// Whether [foreignKeyField] is the `spaceId` ownership link of a sync table.
///
/// The link is identified by the field name alone. Its parent table, delete
/// action and column name are validated separately, so a mistake on one of
/// them is reported once instead of cascading into the errors meant for the
/// remaining relations.
bool isSyncSpaceRelation(SerializableModelFieldDefinition foreignKeyField) {
  return foreignKeyField.name == syncSpaceIdFieldName &&
      foreignKeyField.relation is ForeignRelationDefinition;
}

/// The error reported when the primary key of a sync table is not a UUID.
const String syncIdFieldError =
    'Tables with "database: sync" must have a UUID primary key. Declare the '
    'id field as "id: UuidValue?, defaultPersist=random_v7".';

/// The error reported when the spaces table is unknown, which happens when
/// the `serverpod_offline_sync` module is not part of the project.
const String syncModuleMissingError =
    'The "database: sync" option requires the "serverpod_offline_sync" '
    'module. Add it to the "modules" section of the generator.yaml file.';

/// Validates that the primary key [idField] of a sync table is a UUID.
bool isSyncIdFieldValid(SerializableModelFieldDefinition idField) {
  if (idField.type.className == 'UuidValue') return true;
  return false;
}

/// Validates the type of the `spaceId` [field] of a sync table.
String? validateSyncSpaceIdFieldType(SerializableModelFieldDefinition field) {
  if (field.type.className == 'int' && field.type.nullable) return null;
  return 'The "$syncSpaceIdFieldName" field must be of type "int?" on tables '
      'with "database: sync".';
}

/// Validates that the `spaceId` [field] of a sync table declares a relation
/// to the spaces table.
String? validateSyncSpaceIdFieldRelation(
  SerializableModelFieldDefinition field,
) {
  var relation = field.relation;
  if (relation is ForeignRelationDefinition) return null;
  return 'The "$syncSpaceIdFieldName" field must declare the relation '
      '"relation(parent=$syncSpacesTableName, onDelete=Cascade)" on tables '
      'with "database: sync".';
}

/// Validates that the `spaceId` field of a sync table references the spaces
/// table through [parentTable].
String? validateSyncSpaceIdParentTable(String parentTable) {
  if (parentTable == syncSpacesTableName) return null;
  return 'The "$syncSpaceIdFieldName" field must reference the '
      '"$syncSpacesTableName" table on tables with "database: sync".';
}

/// The error reported when the `spaceId` field of a sync table overrides its
/// column name.
const String syncSpaceIdColumnNameError =
    'The "$syncSpaceIdFieldName" field must not override its column name on '
    'tables with "database: sync".';

/// The error reported when the `spaceId` relation of a sync table does not
/// cascade on delete.
const String syncSpaceRelationOnDeleteError =
    'The "$syncSpaceIdFieldName" relation must use "onDelete=Cascade".';

/// The error reported when a required foreign key of a sync table is not
/// deferred.
const String syncRelationDeferredError =
    'Non-optional relations on tables with "database: sync" must be deferred. '
    'Add the "deferred" keyword to the relation.';

/// Whether the foreign key originated by [field] on the sync table [model]
/// must be deferred.
///
/// Nullable foreign keys can be repaired by the sync engine, so only
/// non-nullable ones other than the `spaceId` link must be deferred.
bool requiresSyncDeferredRelation(
  ModelClassDefinition model,
  SerializableModelFieldDefinition field,
) {
  var foreignKeyField = model.foreignKeyField(field);
  if (foreignKeyField == null) return false;
  if (isSyncSpaceRelation(foreignKeyField)) return false;
  return !foreignKeyField.type.nullable;
}

/// Validates that a relation between [model] and [relatedModel] does not
/// cross the boundary between synced and non-synced tables.
///
/// The only allowed relation crossing the boundary is the `spaceId` link from
/// a synced table to the spaces table. [foreignKeyField] is the field on
/// [model] carrying the foreign key, when [model] originates it.
String? validateSyncRelationBoundary({
  required ModelClassDefinition model,
  required ModelClassDefinition relatedModel,
  required SerializableModelFieldDefinition? foreignKeyField,
}) {
  if (model.isSyncTable == relatedModel.isSyncTable) return null;

  if (model.isSyncTable) {
    if (foreignKeyField != null && isSyncSpaceRelation(foreignKeyField)) {
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
/// Unique indexes must include the `spaceId` column to partition by space and
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
      .where((field) => field.columnName != syncSpaceIdFieldName)
      .toList();

  if (otherColumns.length != columns.length) {
    if (otherColumns.any(_isSyncReleasableColumn)) return null;

    return 'The unique index "${index.name}" must include at least one '
        'field besides "$syncSpaceIdFieldName" that is nullable, a String, '
        'or a UuidValue without a relation, so the sync engine can resolve '
        'conflicts.';
  }

  var isForeignKeyOnly = columns.every(
    (field) => _isSyncForeignKeyColumn(field, parsedModels),
  );
  if (!isForeignKeyOnly) {
    return 'The unique index "${index.name}" must include the '
        '"$syncSpaceIdFieldName" field on tables with "database: sync". '
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
