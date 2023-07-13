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

class SourceSpanSeverityException extends SourceSpanException {
  final SourceSpanSeverity severity;

  SourceSpanSeverityException(
    String message,
    SourceSpan? span, [
    this.severity = SourceSpanSeverity.error,
  ]) : super(message, span);
}
