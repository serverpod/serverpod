import 'package:analyzer/dart/element/element.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';

abstract class ClassAnalyzer {
  static EndpointDefinition? analyze(
    ClassElement element,
    List<MethodDefinition> methodDefinitions,
    CodeAnalysisCollector collector,
    String filePath,
    String rootPath,
  ) {
    var className = element.name;
    var endpointName = _formatEndpointName(className);
    var classDocumentationComment = element.documentationComment;
    var subDirectoryParts = _getSubdirectoryParts(filePath, rootPath);
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

  static String elementNamespace(ClassElement element, String filePath) {
    return '{$filePath}_${element.name}';
  }

  static bool isEndpointClass(ClassElement element) {
    if (element.supertype?.element.name != 'Endpoint') return false;

    return true;
  }

  static List<SourceSpanSeverityException> validate(
    ClassElement classElement,
  ) {
    return [];
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

  static List<String> _getSubdirectoryParts(String filePath, String rootPath) {
    // Get the subdirectory of the filePath by removing the first elements
    // of the root path and the file path as long as they match.
    var rootPathParts = path.split(rootPath);
    var fileDirPathParts = path.split(path.dirname(filePath));
    while (rootPathParts.isNotEmpty && fileDirPathParts.isNotEmpty) {
      if (rootPathParts.first == fileDirPathParts.first) {
        rootPathParts.removeAt(0);
        fileDirPathParts.removeAt(0);
      } else {
        break;
      }
    }

    return fileDirPathParts;
  }
}
