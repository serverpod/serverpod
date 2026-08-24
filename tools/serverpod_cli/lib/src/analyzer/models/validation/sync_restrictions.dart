/// Rules that models with `database: sync` must satisfy so that the
/// `serverpod_offline_sync` package can merge conflicting changes.
///
/// The rules mirror the runtime checks performed by the sync engine when it
/// initializes, so violations are reported by `serverpod generate` instead of
/// failing when the server or the client starts.
library;

import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/model_relations.dart';
import 'package:serverpod_database/serverpod_database.dart';

/// The field every synced model must declare to hold the owner scope of a row.
const String syncScopeIdFieldName = 'scopeId';

/// The table holding the sync scopes, owned by the `serverpod_offline_sync`
/// module.
const String syncScopesTableName = 'crdt_scopes';

/// The declaration users are expected to add to every synced model.
const String syncScopeIdFieldDeclaration =
    '$syncScopeIdFieldName: int?, '
    'relation(parent=$syncScopesTableName, onDelete=Cascade)';

extension ModelClassDefinitionSync on ModelClassDefinition {
  /// Whether this model is a table synchronized between client and server.
  bool get isSyncTable =>
      tableName != null && database == ModelDatabaseDefinition.sync;

  /// The `scopeId` field of this model, including inherited fields.
  SerializableModelFieldDefinition? get syncScopeIdField =>
      fieldsIncludingInherited
          .where((field) => field.name == syncScopeIdFieldName)
          .firstOrNull;

  /// The field carrying the foreign key column that [field] originates, or
  /// null when [field] does not originate a foreign key on this table.
  ///
  /// For id fields this is the field itself. For object relations declared
  /// on the foreign key side, it is the (explicit or implicit) id field.
  SerializableModelFieldDefinition? syncForeignKeyField(
    SerializableModelFieldDefinition field,
  ) {
    var relation = field.relation;
    if (relation is ForeignRelationDefinition) return field;
    if (relation is ObjectRelationDefinition && relation.isForeignKeyOrigin) {
      var foreignKeyField = fieldsIncludingInherited
          .where((f) => f.name == relation.fieldName)
          .firstOrNull;
      if (foreignKeyField?.relation is ForeignRelationDefinition) {
        return foreignKeyField;
      }
    }
    return null;
  }
}

/// Whether [foreignKeyField] carries the ownership link to the scopes table.
bool isSyncScopeRelation(SerializableModelFieldDefinition foreignKeyField) {
  var relation = foreignKeyField.relation;
  return foreignKeyField.columnName == syncScopeIdFieldName &&
      relation is ForeignRelationDefinition &&
      relation.parentTable == syncScopesTableName;
}

/// Validates that the primary key of [model] is a UUID.
String? validateSyncIdField(ModelClassDefinition model) {
  if (model.idField.type.className == 'UuidValue') return null;

  return 'Tables with "database: sync" must have a UUID primary key. '
      'Declare the id field as "id: UuidValue?, defaultPersist=random_v7".';
}

/// Validates that [model] declares the `scopeId` ownership field with the
/// expected type and relation.
List<String> validateSyncScopeIdField(ModelClassDefinition model) {
  var field = model.syncScopeIdField;
  if (field == null) {
    return [
      'Tables with "database: sync" must declare the field '
          '"$syncScopeIdFieldDeclaration".',
    ];
  }

  var errors = <String>[];

  if (field.type.className != 'int' || !field.type.nullable) {
    errors.add(
      'The "$syncScopeIdFieldName" field must be of type "int?" on tables '
      'with "database: sync".',
    );
  }

  if (field.columnName != syncScopeIdFieldName) {
    errors.add(
      'The "$syncScopeIdFieldName" field must not override its column name '
      'on tables with "database: sync".',
    );
  }

  if (!field.shouldPersist) {
    errors.add(
      'The "$syncScopeIdFieldName" field must be persisted on tables with '
      '"database: sync".',
    );
  }

  var relation = field.relation;
  if (relation is! ForeignRelationDefinition ||
      relation.parentTable != syncScopesTableName) {
    errors.add(
      'The "$syncScopeIdFieldName" field must declare the relation '
      '"relation(parent=$syncScopesTableName, onDelete=Cascade)" on tables '
      'with "database: sync".',
    );
  }

  return errors;
}

/// Validates the relation on the `scopeId` field of a sync table.
///
/// [foreignKeyField] must satisfy [isSyncScopeRelation].
List<String> validateSyncScopeRelation(
  SerializableModelFieldDefinition foreignKeyField,
) {
  var relation = foreignKeyField.relation as ForeignRelationDefinition;
  return [
    if (relation.onDelete != ForeignKeyAction.cascade)
      'The "$syncScopeIdFieldName" relation must use "onDelete=Cascade".',
    if (relation.deferrable != null)
      'The "$syncScopeIdFieldName" relation must not be deferrable or '
          'deferred.',
  ];
}

/// Validates that the foreign key originated by [field] on the sync table
/// [model] is deferred, unless it is the `scopeId` ownership link.
String? validateSyncRelationDeferred(
  ModelClassDefinition model,
  SerializableModelFieldDefinition field,
) {
  var foreignKeyField = model.syncForeignKeyField(field);
  if (foreignKeyField == null) return null;
  if (isSyncScopeRelation(foreignKeyField)) return null;

  var relation = foreignKeyField.relation as ForeignRelationDefinition;
  if (relation.deferrable == DeferrableConstraint.initiallyDeferred) {
    return null;
  }

  return 'Relations on tables with "database: sync" must be deferred. Add '
      'the "deferred" keyword to the relation.';
}

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
