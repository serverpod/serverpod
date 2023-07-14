import 'package:source_span/source_span.dart';

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
    String message,
    SourceSpan? span, {
    this.severity = SourceSpanSeverity.error,
    this.tags,
  }) : super(message, span);

  @override
  String toString({Object? color}) {
    if (span == null) return message;
    var severity = _capitalize(this.severity.name.toString());
    var highlightColor = color ?? _highlightColor(this.severity);

    return '$severity on ${span!.message(message, color: highlightColor)}';
  }

  Object? _highlightColor(SourceSpanSeverity severity) {
    switch (severity) {
      case SourceSpanSeverity.error:
        return '\x1B[31m'; // Red
      case SourceSpanSeverity.warning:
        return '\x1B[33m'; // Yellow
      case SourceSpanSeverity.info:
        return '\x1B[34m'; // Blue
      case SourceSpanSeverity.hint:
        return '\x1B[36m'; // Cyan
    }
  }

  String _capitalize(String string) {
    if (string.isEmpty) return string;
    return '${string[0].toUpperCase()}${string.substring(1)}';
  }
}
