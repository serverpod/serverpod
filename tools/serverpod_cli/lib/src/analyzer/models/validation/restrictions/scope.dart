import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/keywords.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions/base.dart';
import 'package:source_span/source_span.dart';

class ScopeValueRestriction
    extends CustomEnumValueRestriction<ModelFieldScopeDefinition> {
  final Restrictions restrictions;

  static const serverOnlyClassAllowedScopes = {
    ModelFieldScopeDefinition.serverOnly,
    ModelFieldScopeDefinition.none,
  };

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

    var nullableErrorMessage = SourceSpanSeverityException(
      'The field "$parentNodeName" must be nullable when the "${Keyword.scope}" property is set to "${value.name}".',
      span,
    );

    if (document.serverOnly && !serverOnlyClassAllowedScopes.contains(value)) {
      var allowedProperties = serverOnlyClassAllowedScopes.map((e) => e.name);
      return [
        SourceSpanSeverityException(
          'The field "$parentNodeName" cannot have the "${Keyword.scope}" property set to "${value.name}" when the class is marked as server only. Allowed properties are $allowedProperties.',
          span,
        ),
      ];
    } else if (document.serverOnly &&
        value == ModelFieldScopeDefinition.serverOnly) {
      return [
        SourceSpanSeverityException(
          'The field "$parentNodeName" belongs to a server only class which makes setting the "${Keyword.scope}" to "${value.name}" redundant.',
          span,
          severity: SourceSpanSeverity.info,
          tags: [SourceSpanTag.unnecessary],
        ),
      ];
    } else if (document.serverOnly &&
        value == ModelFieldScopeDefinition.none &&
        !field.type.nullable) {
      return [nullableErrorMessage];
    } else if (!document.serverOnly &&
        value != ModelFieldScopeDefinition.all &&
        !field.type.nullable) {
      return [nullableErrorMessage];
    }

    return [];
  }
}
