import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

class ForeignRelationDefinitionBuilder {
  String parentTable = 'parent_table';
  String referenceFieldName = 'id';
  ForeignKeyAction onDelete = ForeignKeyAction.cascade;
  ForeignKeyAction onUpdate = ForeignKeyAction.noAction;

  ForeignRelationDefinitionBuilder withParentTable(String parentTable) {
    this.parentTable = parentTable;
    return this;
  }

  ForeignRelationDefinitionBuilder withReferenceFieldName(
      String referenceFieldName) {
    this.referenceFieldName = referenceFieldName;
    return this;
  }

  ForeignRelationDefinitionBuilder withOnDelete(ForeignKeyAction onDelete) {
    this.onDelete = onDelete;
    return this;
  }

  ForeignRelationDefinitionBuilder withOnUpdate(ForeignKeyAction onUpdate) {
    this.onUpdate = onUpdate;
    return this;
  }

  ForeignRelationDefinition build() {
    return ForeignRelationDefinition(
      parentTable: parentTable,
      foriegnFieldName: referenceFieldName,
      onDelete: onDelete,
      onUpdate: onUpdate,
    );
  }
}
