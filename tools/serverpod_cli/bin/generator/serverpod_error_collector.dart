import 'package:source_span/source_span.dart';

class ServerpodErrorCollector {
  final List<SourceSpanException> errors = [];

  void addError(SourceSpanException error) {
    errors.add(error);
  }

  void addErrors(List<SourceSpanException> errors) {
    this.errors.addAll(errors);
  }
}
