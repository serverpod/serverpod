import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/endpoint_class_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_class_analyzer.dart';

typedef AnnotationDefinitionBuilder =
    AnnotationDefinition Function(
      ElementAnnotation annotation,
      String annotationName,
    );

abstract class AnnotationAnalyzer {
  static List<AnnotationDefinition> parseEndpointAnnotations(
    Element dartElement,
  ) {
    return parseAnnotations(
      dartElement,
      parentClassPredicate: EndpointClassAnalyzer.isEndpointInterface,
      annotationBuilders: {
        'Deprecated': (annotation, annotationName) => AnnotationDefinition(
          name: annotationName,
          arguments: _parseAnnotationStringArgument(annotation, 'message'),
          methodCallAnalyzerIgnoreRule:
              'deprecated_member_use_from_same_package',
        ),

        'deprecated': (_, annotationName) =>
            // @deprecated is a shorthand for @Deprecated(..)
            // see https://api.flutter.dev/flutter/dart-core/deprecated-constant.html
            AnnotationDefinition(
              name: annotationName,
              methodCallAnalyzerIgnoreRule:
                  'deprecated_member_use_from_same_package',
            ),
        // @ignoreEndpoint is deprecated in favor of @doNotGenerate
        'ignoreEndpoint': (_, _) =>
            const AnnotationDefinition(name: 'doNotGenerate'),

        'doNotGenerate': (_, annotationName) =>
            AnnotationDefinition(name: annotationName),

        'unauthenticatedClientCall': (_, annotationName) =>
            AnnotationDefinition(name: annotationName),
      },
    );
  }

  static List<AnnotationDefinition> parseFutureCallAnnotations(
    Element dartElement,
  ) {
    return parseAnnotations(
      dartElement,
      parentClassPredicate: FutureCallClassAnalyzer.isFutureCallInterface,
      annotationBuilders: {
        'Deprecated': (annotation, annotationName) => AnnotationDefinition(
          name: annotationName,
          arguments: _parseAnnotationStringArgument(annotation, 'message'),
          methodCallAnalyzerIgnoreRule:
              'deprecated_member_use_from_same_package',
        ),

        'deprecated': (_, annotationName) =>
            // @deprecated is a shorthand for @Deprecated(..)
            // see https://api.flutter.dev/flutter/dart-core/deprecated-constant.html
            AnnotationDefinition(
              name: annotationName,
              methodCallAnalyzerIgnoreRule:
                  'deprecated_member_use_from_same_package',
            ),

        'doNotGenerate': (_, annotationName) =>
            AnnotationDefinition(name: annotationName),
      },
    );
  }

  static List<AnnotationDefinition> parseAnnotations(
    Element dartElement, {

    /// Used to match the classes from which annotations can be inherited
    required bool Function(ClassElement) parentClassPredicate,
    required Map<String, AnnotationDefinitionBuilder> annotationBuilders,
  }) {
    var annotations = _parseElementAnnotations(dartElement, annotationBuilders);
    for (var annotation in _parseInheritedAnnotations(
      dartElement,
      parentClassPredicate,
      annotationBuilders,
    )) {
      if (!annotations.any((e) => e.name == annotation.name)) {
        annotations.add(annotation);
      }
    }
    return annotations;
  }

  /// Parses annotations directly from an element's metadata.
  static List<AnnotationDefinition> _parseElementAnnotations(
    Element element,
    Map<String, AnnotationDefinitionBuilder> annotationBuilders,
  ) {
    return element.metadata.annotations.expand<AnnotationDefinition>((
      annotation,
    ) {
      var annotationElement = annotation.element;
      var annotationName = annotationElement is ConstructorElement
          ? annotationElement.enclosingElement.name
          : annotationElement?.name;
      if (annotationName == null) return [];

      var annotationBuilder = annotationBuilders[annotationName];
      var annotationDefinition = annotationBuilder?.call(
        annotation,
        annotationName,
      );

      return [?annotationDefinition];
    }).toList();
  }

  /// Parses annotations inherited from parent classes. May contain duplicates.
  static List<AnnotationDefinition> _parseInheritedAnnotations(
    Element dartElement,
    bool Function(ClassElement) parentClassPredicate,
    Map<String, AnnotationDefinitionBuilder> annotationBuilders,
  ) {
    if (dartElement is! ClassElement) return [];

    var parentClasses = dartElement.allSupertypes
        .map((s) => s.element)
        .whereType<ClassElement>()
        .where(parentClassPredicate);

    return [
      for (var parentClass in parentClasses)
        for (var annotation in _parseElementAnnotations(
          parentClass,
          annotationBuilders,
        ))
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
  bool get futureCallMarkedAsIgnored =>
      AnnotationAnalyzer.parseFutureCallAnnotations(this).has('doNotGenerate');

  bool get endpointMarkedAsIgnored =>
      AnnotationAnalyzer.parseEndpointAnnotations(this).has('doNotGenerate');

  bool get markedAsUnauthenticated =>
      AnnotationAnalyzer.parseEndpointAnnotations(
        this,
      ).has('unauthenticatedClientCall');
}
