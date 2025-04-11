import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_shared/annotations.dart';

extension ElementIgnoreEndpointExtensions on Element {
  bool get markedAsIgnored {
    return metadata.any((annotation) {
      var constant = annotation.computeConstantValue();
      var type = constant?.type;
      var typeName = type?.element?.name;
      return typeName == ServerpodAnnotationClassNames.ignoreEndpoint;
    });
  }
}
