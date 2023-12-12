import 'package:analyzer/dart/element/element.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';

abstract class ClassAnalyzer {
  static EndpointDefinition? analyze(
    ClassElement element,
    List<MethodDefinition> methodDefinitions,
    CodeAnalysisCollector collector,
    String filePath,
    List<String> subDirectoryParts,
  ) {
    var className = element.name;
    var endpointName = _formatEndpointName(className);
    var classDocumentationComment = element.documentationComment;
    var endpointDef = EndpointDefinition(
      name: endpointName,
      documentationComment: classDocumentationComment,
      className: className,
      methods: methodDefinitions,
      filePath: filePath,
      subDirParts: subDirectoryParts,
    );

    return endpointDef;
  }

  static bool isEndpointClass(ClassElement element) {
    if (element.supertype?.element.name != 'Endpoint') return false;

    return true;
  }

  static String _formatEndpointName(String className) {
    const removeEnding = 'Endpoint';

    var endpointName = '${className[0].toLowerCase()}${className.substring(1)}';
    if (endpointName.endsWith(removeEnding)) {
      endpointName =
          endpointName.substring(0, endpointName.length - removeEnding.length);
    }

    return endpointName;
  }
}
