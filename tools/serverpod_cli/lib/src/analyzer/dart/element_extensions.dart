import 'package:analyzer/dart/element/element.dart';
import 'package:source_span/source_span.dart';

extension DartElementSourceSpan on Element {
  /// Returns the [SourceSpan] of the Dart element, if available.
  SourceSpan? get span {
    final lib = library;
    if (lib == null) return null;
    final offset = firstFragment.offset;
    final length = firstFragment.name?.length ?? 0;
    final sourceCode = lib.firstFragment.source.contents.data;
    return SourceFile.fromString(
      sourceCode,
      url: lib.uri,
    ).span(offset, offset + length);
  }
}
