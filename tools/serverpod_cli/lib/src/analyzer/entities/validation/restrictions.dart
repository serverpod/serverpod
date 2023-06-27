import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/util/string_validators.dart';
import 'package:source_span/source_span.dart';

class Restrictions {
  String documentType;

  Restrictions(this.documentType);

  void isValidClassName(
    dynamic content,
    SourceSpan? span,
    CodeAnalysisCollector collector,
  ) {
    if (content is! String) {
      collector.addError(SourceSpanException(
        'The "$documentType" type must be a String.',
        span,
      ));
      return;
    }

    if (!StringValidators.isValidClassName(content)) {
      collector.addError(SourceSpanException(
        'The "$documentType" type must be a valid class name (e.g. PascalCaseString).',
        span,
      ));
    }
  }

  void isValidTableName(
    dynamic content,
    SourceSpan? span,
    CodeAnalysisCollector collector,
  ) {
    if (content is! String) {
      collector.addError(SourceSpanException(
        'The "table" property must be a snake_case_string.',
        span,
      ));
      return;
    }

    if (!StringValidators.isValidTableName(content)) {
      collector.addError(SourceSpanException(
        'The "table" property must be a snake_case_string.',
        span,
      ));
    }
  }

  void isValidServerOnlyValue(
    dynamic content,
    SourceSpan? span,
    CodeAnalysisCollector collector,
  ) {
    if (content is! bool) {
      collector.addError(SourceSpanException(
        'The "serverOnly" property must be a bool.',
        span,
      ));
      return;
    }
  }
}
