import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/utils/model_relation_utils.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions/foreign_key_action.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions/sync.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:source_span/source_span.dart';

class OnDeleteValueRestriction extends ForeignKeyActionValueRestriction {
  OnDeleteValueRestriction({required super.restrictions});

  @override
  List<SourceSpanSeverityException> validate(
    String parentNodeName,
    ForeignKeyAction value,
    SourceSpan? span,
  ) {
    var syncErrors = _validateSyncSpaceRelation(parentNodeName, value, span);
    if (syncErrors.isNotEmpty) return syncErrors;

    return super.validate(parentNodeName, value, span);
  }

  List<SourceSpanSeverityException> _validateSyncSpaceRelation(
    String parentNodeName,
    ForeignKeyAction value,
    SourceSpan? span,
  ) {
    var document = restrictions.documentDefinition;
    if (document is! ModelClassDefinition || !document.isSyncTable) return [];

    var field = document.findField(parentNodeName);
    if (field == null) return [];

    var foreignKeyField = document.foreignKeyField(field);
    if (foreignKeyField == null || !isSyncSpaceRelation(foreignKeyField)) {
      return [];
    }

    if (value != ForeignKeyAction.cascade) {
      return [
        SourceSpanSeverityException(syncSpaceRelationOnDeleteError, span),
      ];
    }

    return [];
  }
}
