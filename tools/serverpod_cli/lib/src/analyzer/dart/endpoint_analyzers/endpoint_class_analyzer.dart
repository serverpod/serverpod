import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';

abstract class EndpointClassAnalyzer {
  /// Parses an [ClassElement] into a [EndpointDefinition].
  /// Assumes that the [ClassElement] is a valid endpoint class.
  static EndpointDefinition parse(
    ClassElement element,
    List<MethodDefinition> methodDefinitions,
    String filePath,
    String rootPath,
  ) {
    var className = element.name;
    var endpointName = _formatEndpointName(className);
    var classDocumentationComment = element.documentationComment;
    var subDirectoryParts = _getSubdirectoryParts(filePath, rootPath);

    return EndpointDefinition(
      name: endpointName,
      documentationComment: classDocumentationComment,
      className: className,
      methods: methodDefinitions,
      filePath: filePath,
      subDirParts: subDirectoryParts,
    );
  }

  /// Creates a namespace for the [ClassElement] based on the [filePath].
  static String elementNamespace(ClassElement element, String filePath) {
    return '{$filePath}_${element.name}';
  }

  /// Returns true if the [ClassElement] is an endpoint class that should
  /// be validated and parsed.
  static bool isEndpointClass(ClassElement element) {
    if (element.supertype?.element.name != 'Endpoint') return false;

    return true;
  }

  /// Validates the [ClassElement] and returns a list of errors.
  static List<SourceSpanSeverityException> validate(
    ClassElement? classElement,
    List<EndpointDefinition> endpointDefs,
  ) {
    List<SourceSpanSeverityException> errors = [];

    String? duplicateClassName =
        _checkForDuplicateClassNames(classElement, endpointDefs);
    if (duplicateClassName != null) {
      errors.add(
        SourceSpanSeverityException(
          'Endpoint analysis skipped due to duplicate class names. '
          'Please rename your classes to make them unique. '
          'className: $duplicateClassName',
          null,
          severity: SourceSpanSeverity.error,
        ),
      );
    }

    return errors;
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

  /// Checks for duplicate class names in a list of [EndpointDefinition] objects.
  /// Returns the first duplicate class name found, or `null` if no duplicates are found.
  static String? _checkForDuplicateClassNames(
    ClassElement? classElement,
    List<EndpointDefinition> endpointDefs,
  ) {
    Set<String> classNames = {};
    //Adding the current class to be checked
    if (classElement != null) {
      classNames.add(classElement.name);
    }
    for (var element in endpointDefs) {
      // Assuming 'className' is a property of elements in endpointDefs
      if (classNames.contains(element.className)) {
        return element.className;
      }
      classNames.add(element.className);
    }

    return null;
  }
}
