import 'package:serverpod_cli/src/analyzer/models/definitions.dart';

extension ModelClassDefinitionRelations on ModelClassDefinition {
  /// The field carrying the foreign key column that [field] originates, or
  /// null when [field] does not originate a foreign key on this table.
  ///
  /// For id fields this is the field itself. For object relations declared
  /// on the foreign key side, it is the (explicit or implicit) id field.
  /// Relations declared on the referenced side, including list relations,
  /// hold no foreign key column and therefore resolve to null.
  SerializableModelFieldDefinition? foreignKeyField(
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
