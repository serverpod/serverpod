import 'package:source_span/source_span.dart';

abstract class CodeAnalysisCollector {
  List<SourceSpanException> get errors;

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
    String message,
    SourceSpan? span, {
    this.severity = SourceSpanSeverity.error,
    this.tags,
  }) : super(message, span);
}
