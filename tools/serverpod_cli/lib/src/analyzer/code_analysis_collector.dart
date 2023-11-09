import 'package:source_span/source_span.dart';
import 'package:super_string/super_string.dart';

abstract class CodeAnalysisCollector {
  List<SourceSpanException> get errors;

  bool get hasSeverErrors => errors.where(
        (error) {
          return error is! SourceSpanSeverityException ||
              error.severity == SourceSpanSeverity.error ||
              error.severity == SourceSpanSeverity.warning;
        },
      ).isNotEmpty;

  void addError(SourceSpanException error);

  void addErrors(List<SourceSpanException> errors);

  void printErrors();

  void clearErrors();
}

enum SourceSpanSeverity {
  error,
  warning,
  info,
  hint,
}

enum SourceSpanTag {
  unnecessary,
  deprecated,
}

class SourceSpanSeverityException extends SourceSpanException {
  final SourceSpanSeverity severity;
  final List<SourceSpanTag>? tags;

  SourceSpanSeverityException(
    super.message,
    super.span, {
    this.severity = SourceSpanSeverity.error,
    this.tags,
  });

  @override
  String toString({Object? color}) {
    if (span == null) return message;
    var severity = this.severity.name.toString().capitalize();

    return '$severity on ${span!.message(message, color: color)}';
  }
}
