import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/keywords.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions/base.dart';
import 'package:source_span/source_span.dart';

class RequiredValueRestriction extends ValueRestriction<bool> {
  final Restrictions restrictions;

  RequiredValueRestriction({
    required this.restrictions,
  });

  @override
  List<SourceSpanSeverityException> validate(
    String parentNodeName,
    bool value,
    SourceSpan? span,
  ) {
    var document = restrictions.documentDefinition;
    if (document is! ClassDefinition) return [];

    var field = document.findField(parentNodeName);
    if (field == null) return [];

    // Only validate if the 'required' keyword is set to true
    if (!value) return [];

    // The 'required' keyword should only be used with nullable fields
    if (!field.type.nullable) {
      return [
        SourceSpanSeverityException(
          'The "required" keyword can only be used with nullable fields. '
          'Non-nullable fields are already required by default.',
          span,
        )
      ];
    }

    return [];
  }
}