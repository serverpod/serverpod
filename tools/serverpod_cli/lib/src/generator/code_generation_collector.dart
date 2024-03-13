import 'dart:io';

import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:source_span/source_span.dart';

/// A [CodeAnalysisCollector] that also keeps track of generated files.
class CodeGenerationCollector extends CodeAnalysisCollector {
  /// All the errors reported.
  @override
  final List<SourceSpanException> errors = [];

  /// All the generated files reported.
  final Set<File> generatedFiles = {};

  @override
  void addError(SourceSpanException error) {
    errors.add(error);
  }

  @override
  void addErrors(List<SourceSpanException> errors) {
    this.errors.addAll(errors);
  }

  @override
  String toString() {
    var out = '';

    out += 'Found ${errors.length} issue${errors.length == 1 ? '' : 's'}.\n';
    out += '\n';

    for (var error in errors) {
      out += '$error\n\n';
    }

    return out;
  }

  @override
  void printErrors() {
    if (errors.isEmpty) {
      return;
    }

    var logMessage =
        'Found ${errors.length} issue${errors.length == 1 ? '' : 's'}.';

    var severityErrors = errors.whereType<SourceSpanSeverityException>();

    var hasErrors = severityErrors.isEmpty ||
        severityErrors
            .where((error) => error.severity == SourceSpanSeverity.error)
            .isNotEmpty;
    var hasWarnings = severityErrors
        .where((error) => error.severity == SourceSpanSeverity.warning)
        .isNotEmpty;

    if (hasErrors) {
      log.error(logMessage, newParagraph: true);
    } else if (hasWarnings) {
      log.warning(logMessage, newParagraph: true);
    } else {
      log.info(logMessage, newParagraph: true);
    }

    for (var error in errors) {
      log.sourceSpanException(error);
    }
  }

  @override
  void clearErrors() {
    errors.clear();
  }

  /// Report a generated file.
  void addGeneratedFile(File file) {
    generatedFiles.add(file);
  }

  /// Clear the list of generated files.
  void clearGeneratedFiles() {
    generatedFiles.clear();
  }
}
