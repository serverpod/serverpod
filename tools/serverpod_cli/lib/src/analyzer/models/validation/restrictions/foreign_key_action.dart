import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/utils/model_relation_utils.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions/base.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:source_span/source_span.dart';

/// Validates that the foreign key column can hold the value written by the
/// `onUpdate` and `onDelete` actions. Databases accept these constraints and
/// only fail when the referenced row is updated or deleted.
class ForeignKeyActionValueRestriction
    extends CustomEnumValueRestriction<ForeignKeyAction> {
  final Restrictions restrictions;

  ForeignKeyActionValueRestriction({required this.restrictions});

  @override
  List<SourceSpanSeverityException> validate(
    String parentNodeName,
    ForeignKeyAction value,
    SourceSpan? span,
  ) {
    var document = restrictions.documentDefinition;
    if (document is! ModelClassDefinition) return [];

    var field = document.findField(parentNodeName);
    if (field == null) return [];

    var foreignKeyField = document.foreignKeyField(field);
    if (foreignKeyField == null) return [];

    if (value == ForeignKeyAction.setNull && !foreignKeyField.type.nullable) {
      return [
        SourceSpanSeverityException(
          'The "SetNull" action requires the foreign key field '
          '"${foreignKeyField.name}" to be nullable.',
          span,
        ),
      ];
    }

    // Only "default" and "defaultPersist" produce a database default.
    if (value == ForeignKeyAction.setDefault &&
        foreignKeyField.defaultPersistValue == null) {
      return [
        SourceSpanSeverityException(
          'The "SetDefault" action requires the foreign key field '
          '"${foreignKeyField.name}" to have a database default. Declare the '
          'field with "default" or "defaultPersist" and reference it from an '
          'object relation with "field=${foreignKeyField.name}".',
          span,
        ),
      ];
    }

    return [];
  }
}
