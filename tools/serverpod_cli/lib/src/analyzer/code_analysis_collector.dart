import 'package:source_span/source_span.dart';

abstract class CodeAnalysisCollector {

  List<SourceSpanException> get errors;

  void addError(SourceSpanException error);

  void addErrors(List<SourceSpanException> errors);

  void printErrors();

  void clearErrors();
}
