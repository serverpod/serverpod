import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/element_extensions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/annotation.dart';

/// Validates the OpenAPI-only annotations on endpoint classes and methods.
abstract class OpenApiAnnotationValidator {
  /// Reports an error for every `@OpenApiAuth` on [element] that names a security
  /// scheme missing from [knownSchemes], the keys of
  /// `openapi.securitySchemes` in `config/generator.yaml`.
  static List<SourceSpanSeverityException> validate(
    Element element,
    Set<String> knownSchemes,
  ) {
    var errors = <SourceSpanSeverityException>[];

    for (var annotation in element.endpointAnnotations) {
      if (annotation.name != 'OpenApiAuth') continue;

      var scheme = annotation.properties['scheme'] as String?;
      if (scheme == null || knownSchemes.contains(scheme)) continue;

      var declared = knownSchemes.isEmpty
          ? 'No security schemes are declared.'
          : 'Declared schemes: ${(knownSchemes.toList()..sort()).join(', ')}.';

      errors.add(
        SourceSpanSeverityException(
          'The security scheme "$scheme" used by @OpenApiAuth is not declared '
          'under "openapi.securitySchemes" in config/generator.yaml. '
          '$declared',
          element.span,
          severity: SourceSpanSeverity.error,
        ),
      );
    }

    return errors;
  }
}
