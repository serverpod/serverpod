import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions/base.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:source_span/source_span.dart';

class DefaultValueRestriction extends ValueRestriction {
  final String key;
  final SerializableModelDefinition? documentDefinition;

  DefaultValueRestriction(this.key, this.documentDefinition);

  @override
  List<SourceSpanSeverityException> validate(
    String parentNodeName,
    dynamic value,
    SourceSpan? span,
  ) {
    var definition = documentDefinition;
    if (definition is! ClassDefinition) return [];

    var field = definition.findField(parentNodeName);
    switch (field?.type.valueType) {
      case ValueType.dateTime:
        return _dateDateValidation(value, span);
      default:

        /// Currently, we only provide defaults for DateTime types.
        /// No errors are returned for other types due to existing key restrictions.
        return [];
    }
  }

  List<SourceSpanSeverityException> _dateDateValidation(
    dynamic value,
    SourceSpan? span,
  ) {
    if (value is DateTime) return [];

    if (value is! String) {
      return [
        SourceSpanSeverityException(
          'The "$key" value must be a valid UTC DateTime String or "now"',
          span,
        )
      ];
    }

    if (value == 'now') return [];

    DateTime? dateTime = DateTime.tryParse(value);
    if (dateTime == null) {
      return [
        SourceSpanSeverityException(
          'The "$key" value must be a valid UTC DateTime String or "now"',
          span,
        )
      ];
    }

    if (!dateTime.isUtc) {
      return [
        SourceSpanSeverityException(
          'The "$key" value should be a valid UTC DateTime.',
          span,
        )
      ];
    }

    return [];
  }
}
