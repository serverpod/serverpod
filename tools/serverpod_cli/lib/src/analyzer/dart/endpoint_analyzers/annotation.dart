import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';

abstract class AnnotationAnalyzer {
  static List<AnnotationDefinition> parseAnnotations(Element dartElement) {
    return dartElement.metadata.annotations
        .expand<AnnotationDefinition>((annotation) {
      var annotationElement = annotation.element;
      var annotationName = annotationElement is ConstructorElement
          ? annotationElement.enclosingElement.name
          : annotationElement?.name;
      if (annotationName == null) return [];
      return switch (annotationName) {
        'Deprecated' => [
            AnnotationDefinition(
              name: annotationName,
              arguments: _parseAnnotationStringArgument(annotation, 'message'),
              methodCallAnalyzerIgnoreRule:
                  'deprecated_member_use_from_same_package',
            ),
          ],
        'deprecated' =>
          // @deprecated is a shorthand for @Deprecated(..)
          // see https://api.flutter.dev/flutter/dart-core/deprecated-constant.html
          [
            AnnotationDefinition(
              name: annotationName,
              methodCallAnalyzerIgnoreRule:
                  'deprecated_member_use_from_same_package',
            ),
          ],
        'unauthenticated' => [
            AnnotationDefinition(
              name: annotationName,
            ),
          ],
        _ => [],
      };
    }).toList();
  }

  static List<String>? _parseAnnotationStringArgument(
    ElementAnnotation annotation,
    String fieldName,
  ) {
    var argument =
        annotation.computeConstantValue()?.getField(fieldName)?.toStringValue();
    return argument != null ? ["'$argument'"] : null;
  }
}
