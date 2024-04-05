import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/keywords.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions/base.dart';
import 'package:source_span/source_span.dart';

class ScopeValueRestriction
    extends CustomEnumValueRestriction<ModelFieldScopeDefinition> {
  final Restrictions restrictions;

  ScopeValueRestriction({
    required this.restrictions,
  });

  @override
  List<SourceSpanSeverityException> validate(
    String parentNodeName,
    ModelFieldScopeDefinition value,
    SourceSpan? span,
  ) {
    var document = restrictions.documentDefinition;
    if (document is! ClassDefinition) return [];

    var field = document.findField(parentNodeName);
    if (field == null) return [];

    if (value != ModelFieldScopeDefinition.all && !field.type.nullable) {
      return [
        SourceSpanSeverityException(
          'The field "$parentNodeName" must be nullable when the "${Keyword.scope}" property is set to "${value.name}".',
          span,
        )
      ];
    }

    return [];
  }
}
