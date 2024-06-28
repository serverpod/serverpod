import 'package:intl/intl.dart';
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

    var errors = <SourceSpanSeverityException>[];

    if (value is! String) {
      errors.add(
        SourceSpanSeverityException(
          'The "$key" value must be a valid UTC DateTime String or "now"',
          span,
        ),
      );
    }

    if (value == 'now') return [];

    var format = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

    DateTime? dateTime = DateFormat(format).tryParseStrict(value);

    if (dateTime == null) {
      errors.add(
        SourceSpanSeverityException(
          'The "$key" value must be a valid UTC ($format) DateTime String or "now"',
          span,
        ),
      );
    }

    return errors;
  }
}
