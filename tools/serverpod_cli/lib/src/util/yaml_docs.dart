import 'dart:convert';

import 'package:source_span/source_span.dart';

class YamlDocumentationExtractor {
  final List<String> lines;

  /// Splits on LF, CR, and CRLF — the same line break set `package:yaml`
  /// (via `source_span`) uses for the line numbers in [SourceLocation],
  /// keeping the scan index-aligned for any line ending style.
  YamlDocumentationExtractor(String yaml)
    : lines = const LineSplitter().convert(yaml);

  List<String>? getDocumentation(SourceLocation keyStart) {
    var documentation = <String>[];
    var docStartExp = RegExp('^${''.padLeft(keyStart.column)}###(.*)');
    for (var i = keyStart.line - 1; i >= 0; i--) {
      var line = lines[i];
      var match = docStartExp.firstMatch(line);
      if (match != null) {
        documentation.insert(0, '///${match.group(1) ?? ''}');
      } else if (line.isNotEmpty && RegExp(r'^\ *?[^#]*$').hasMatch(line)) {
        break;
      }
    }
    return documentation.isNotEmpty ? documentation : null;
  }
}
