import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_cli/src/analyzer/dart/annotation_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/future_call_analyzers/future_call_class_analyzer.dart';

extension AnnotationExtensions on Element {
  List<AnnotationDefinition> get futureCallAnnotations {
    return AnnotationAnalyzer.parseAnnotations(
      this,
      parentClassPredicate: FutureCallClassAnalyzer.isFutureCallInterface,
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
      },
    );
  }
}
