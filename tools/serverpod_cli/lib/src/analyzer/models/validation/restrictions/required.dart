import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/keywords.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions/base.dart';
import 'package:source_span/source_span.dart';

class RequiredValueRestriction extends ValueRestriction {
  final Restrictions restrictions;

  RequiredValueRestriction({
    required this.restrictions,
  });

  @override
  List<SourceSpanSeverityException> validate(
    String parentNodeName,
    dynamic value,
    SourceSpan? span,
  ) {
    // First validate that it's a valid boolean value
    var boolValidation = BooleanValueRestriction().validate(parentNodeName, value, span);
    if (boolValidation.isNotEmpty) {
      return boolValidation;
    }
    
    // Convert to boolean for business logic validation
    bool boolValue;
    if (value is bool) {
      boolValue = value;
    } else if (value is String) {
      boolValue = value.toLowerCase() == 'true';
    } else {
      // This shouldn't happen since BooleanValueRestriction passed, but handle defensively
      return [
        SourceSpanSeverityException(
          'The "required" keyword must be a boolean value.',
          span,
        )
      ];
    }
    
    var document = restrictions.documentDefinition;
    if (document is! ClassDefinition) return [];

    var field = document.findField(parentNodeName);
    if (field == null) return [];

    // Only validate if the 'required' keyword is set to true
    if (!boolValue) return [];

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