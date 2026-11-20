import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_cli/src/analyzer/dart/annotation_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/dart/endpoint_analyzers/endpoint_class_analyzer.dart';

DartObject? _field(ElementAnnotation annotation, String name) =>
    annotation.computeConstantValue()?.getField(name);

List<String> _stringList(DartObject? object) =>
    object
        ?.toListValue()
        ?.map((e) => e.toStringValue())
        .whereType<String>()
        .toList() ??
    const [];

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
        'doNotGenerate': (_, annotationName) =>
            AnnotationDefinition(name: annotationName),

        'unauthenticatedClientCall': (_, annotationName) =>
            AnnotationDefinition(name: annotationName),

        // OpenAPI-only annotations. Their values are kept in `properties`
        // and are never emitted into generated Dart code.
        'OpenApiAuth': (annotation, annotationName) => AnnotationDefinition(
          name: annotationName,
          properties: {
            'scheme': _field(annotation, 'scheme')?.toStringValue(),
            'scopes': _stringList(_field(annotation, 'scopes')),
          },
        ),
        'OpenApiDoc': (annotation, annotationName) => AnnotationDefinition(
          name: annotationName,
          properties: {
            'summary': _field(annotation, 'summary')?.toStringValue(),
            'description': _field(annotation, 'description')?.toStringValue(),
            'operationId': _field(annotation, 'operationId')?.toStringValue(),
            'tags': _stringList(_field(annotation, 'tags')),
          },
        ),
        'OpenApiResponse': (annotation, annotationName) => AnnotationDefinition(
          name: annotationName,
          properties: {
            'statusCode': _field(annotation, 'statusCode')?.toIntValue(),
            'description': _field(annotation, 'description')?.toStringValue(),
          },
        ),
        'openApiExclude': (_, annotationName) =>
            AnnotationDefinition(name: annotationName),
      },
    );
  }

  bool get markedAsIgnored => endpointAnnotations.has('doNotGenerate');

  bool get markedAsUnauthenticated =>
      endpointAnnotations.has('unauthenticatedClientCall');
}
