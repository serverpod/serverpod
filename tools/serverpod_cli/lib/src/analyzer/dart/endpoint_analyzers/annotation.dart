import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/endpoint_class_analyzer.dart';

abstract class AnnotationAnalyzer {
  static List<AnnotationDefinition> parseAnnotations(Element dartElement) {
    var annotations = _parseElementAnnotations(dartElement);
    for (var annotation in _parseInheritedAnnotations(dartElement)) {
      if (!annotations.any((e) => e.name == annotation.name)) {
        annotations.add(annotation);
      }
    }
    return annotations;
  }

  /// Parses annotations directly from an element's metadata.
  static List<AnnotationDefinition> _parseElementAnnotations(Element element) {
    return element.metadata.annotations.expand<AnnotationDefinition>((
      annotation,
    ) {
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
        // @ignoreEndpoint is deprecated in favor of @doNotGenerate
        'ignoreEndpoint' => [
          const AnnotationDefinition(
            name: 'doNotGenerate',
          ),
        ],
        'doNotGenerate' => [
          AnnotationDefinition(
            name: annotationName,
          ),
        ],
        'unauthenticatedClientCall' => [
          AnnotationDefinition(
            name: annotationName,
          ),
        ],
        _ => [],
      };
    }).toList();
  }

  /// Parses annotations inherited from parent classes. May contain duplicates.
  static List<AnnotationDefinition> _parseInheritedAnnotations(
    Element dartElement,
  ) {
    if (dartElement is! ClassElement) return [];

    var parentClasses = dartElement.allSupertypes
        .map((s) => s.element)
        .whereType<ClassElement>()
        .where(EndpointClassAnalyzer.isEndpointInterface);

    return [
      for (var parentClass in parentClasses)
        for (var annotation in _parseElementAnnotations(parentClass))
          if (annotation.name != 'doNotGenerate') annotation,
    ];
  }

  static List<String>? _parseAnnotationStringArgument(
    ElementAnnotation annotation,
    String fieldName,
  ) {
    var argument = annotation
        .computeConstantValue()
        ?.getField(fieldName)
        ?.toStringValue();
    return argument != null ? ["'$argument'"] : null;
  }
}

extension AnnotationExtensions on Element {
  bool get markedAsIgnored =>
      AnnotationAnalyzer.parseAnnotations(this).has('doNotGenerate');

  bool get markedAsUnauthenticated => AnnotationAnalyzer.parseAnnotations(
    this,
  ).has('unauthenticatedClientCall');
}
