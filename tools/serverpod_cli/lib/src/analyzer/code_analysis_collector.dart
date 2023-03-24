import 'package:source_span/source_span.dart';

abstract class CodeAnalysisCollector {
  void addError(SourceSpanException error);

  void addErrors(List<SourceSpanException> errors);

  void printErrors();

  void clearErrors();
}
