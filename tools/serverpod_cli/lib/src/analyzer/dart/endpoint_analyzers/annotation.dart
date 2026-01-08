import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_cli/src/analyzer/dart/annotation_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/endpoint_class_analyzer.dart';

extension AnnotationExtensions on Element {
  List<AnnotationDefinition> get endpointAnnotations {
    return AnnotationAnalyzer.parseAnnotations(
      this,
      parentClassPredicate: EndpointClassAnalyzer.isEndpointInterface,
      annotationBuilders: {
        'Deprecated': (annotation, annotationName) => AnnotationDefinition(
          name: annotationName,
          arguments: AnnotationAnalyzer.parseAnnotationStringArgument(
            annotation,
            'message',
          ),
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

  bool get markedAsIgnored => endpointAnnotations.has('doNotGenerate');

  bool get markedAsUnauthenticated =>
      endpointAnnotations.has('unauthenticatedClientCall');
}
