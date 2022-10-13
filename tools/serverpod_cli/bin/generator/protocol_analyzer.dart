import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:source_span/source_span.dart';

import 'config.dart';
import 'protocol_definition.dart';
import 'code_analysis_collector.dart';
import 'types.dart';

const _excludedMethodNameSet = {
  'streamOpened',
  'streamClosed',
  'handleStreamMessage',
  'sendStreamMessage',
  'setUserObject',
  'getUserObject',
};

ProtocolAnalyzer? _analyzer;

Future<ProtocolDefinition> performAnalyzeServerCode({
  required bool verbose,
  required CodeAnalysisCollector collector,
  bool requestNewAnalyzer = true,
  required Set<String> changedFiles,
}) async {
  // Invalidate the old analyzer if requested to do so.
  if (requestNewAnalyzer) {
    _analyzer = null;
  }

  // Attempt to use old analyzer or create a new one if no one exists.
  if (_analyzer == null) {
    _analyzer = ProtocolAnalyzer(config.endpointsSourcePath);
  } else if (changedFiles.isNotEmpty) {
    // Make sure that the analyzer is up-to-date with recent changes.
    var contexts = _analyzer!.collection.contexts;
    for (var context in contexts) {
      for (var changedFile in changedFiles) {
        var file = File(changedFile);
        context.changeFile(file.absolute.path);
      }
      await context.applyPendingFileChanges();
    }
  }

  // Perform the code analysis.
  return await _analyzer!.analyze(
    verbose: verbose,
    collector: collector,
  );
}

Future<List<String>> performAnalysisGetSevereErrors() async {
  _analyzer = ProtocolAnalyzer(config.endpointsSourcePath);
  return await _analyzer!.getErrors();
}

class ProtocolAnalyzer {
  final Directory endpointDirectory;
  late AnalysisContextCollection collection;

  ProtocolAnalyzer(String filePath) : endpointDirectory = Directory(filePath) {
    collection = AnalysisContextCollection(
      includedPaths: [endpointDirectory.absolute.path],
      resourceProvider: PhysicalResourceProvider.INSTANCE,
    );
  }

  Future<List<String>> getErrors() async {
    var errorMessages = <String>[];

    for (var context in collection.contexts) {
      var analyzedFiles = context.contextRoot.analyzedFiles();
      for (var filePath in analyzedFiles) {
        var errors = await context.currentSession.getErrors(filePath);
        if (errors is ErrorsResult) {
          for (var error in errors.errors) {
            if (error.severity == Severity.error) {
              // TODO: Figure out how to include line number
              errorMessages.add(
                '${error.problemMessage.filePath} Error: ${error.message}',
              );
            }
          }
        }
      }
    }
    return errorMessages;
  }

  Future<ProtocolDefinition> analyze({
    required bool verbose,
    required CodeAnalysisCollector collector,
  }) async {
    var endpointDefs = <EndpointDefinition>[];
    var filePaths = <String>[];

    for (var context in collection.contexts) {
      var analyzedFiles = context.contextRoot.analyzedFiles().toList();
      analyzedFiles.sort();
      for (var filePath in analyzedFiles) {
        if (!filePath.endsWith('.dart')) {
          continue;
        }
        filePaths.add(filePath);

        var library = await context.currentSession.getResolvedLibrary(filePath);
        library as ResolvedLibraryResult;
        var element = library.element;
        var topElements = element.topLevelElements;

        for (var element in topElements) {
          if (element is ClassElement) {
            var className = element.name;
            var superclassName = element.supertype!.element2.name;
            var endpointName = _formatEndpointName(className);

            if (superclassName == 'Endpoint') {
              var classDocumentationComment = element.documentationComment;

              var methodDefs = <MethodDefinition>[];
              var methods = element.methods;
              for (var method in methods) {
                // Skip private methods
                if (method.isPrivate) continue;
                // Skip overridden methods from the Endpoint class
                if (_excludedMethodNameSet.contains(method.name)) continue;

                var paramDefs = <ParameterDefinition>[];
                var paramPositionalDefs = <ParameterDefinition>[];
                var paramNamedDefs = <ParameterDefinition>[];
                var parameters = method.parameters;
                for (var param in parameters) {
                  var package =
                      param.type.element2?.librarySource?.uri.pathSegments[0];
                  var paramDef = ParameterDefinition(
                    name: param.name,
                    required: param.isRequiredPositional ||
                        param.isRequiredNamed ||
                        (param.isNamed &&
                            param.type.nullabilitySuffix ==
                                NullabilitySuffix.none),
                    type: TypeDefinition.fromDartType(param.type),
                    dartParameter: param,
                  );

                  if (param.isRequiredPositional) {
                    paramDefs.add(paramDef);
                  } else if (param.isOptionalPositional) {
                    paramPositionalDefs.add(paramDef);
                  } else if (param.isNamed) {
                    paramNamedDefs.add(paramDef);
                  }
                }

                if (paramDefs.isNotEmpty &&
                    paramDefs[0].type.className == 'Session' &&
                    method.returnType.isDartAsyncFuture) {
                  String? package;
                  String? innerPackage;
                  var returnType = method.returnType;
                  if (returnType is InterfaceType) {
                    var interfaceType = returnType;
                    if (interfaceType.typeArguments.length == 1) {
                      package = interfaceType.typeArguments[0].element2
                          ?.librarySource?.uri.pathSegments[0];
                      innerPackage =
                          _getInnerPackage(interfaceType.typeArguments[0]);
                    }
                  }

                  for (var parameter in paramDefs.sublist(1)) {
                    _validateDartType(
                      dartType: parameter.type.dartType,
                      dartElement: parameter.dartParameter,
                      collector: collector,
                    );
                  }

                  _validateReturnType(
                    dartType: method.returnType,
                    dartElement: method,
                    collector: collector,
                  );

                  var methodDef = MethodDefinition(
                    name: method.name,
                    documentationComment: method.documentationComment,
                    parameters: paramDefs.sublist(1), // Skip session parameter
                    parametersNamed: paramNamedDefs,
                    parametersPositional: paramPositionalDefs,
                    returnType: TypeDefinition.fromDartType(method.returnType),
                  );
                  methodDefs.add(methodDef);
                }
              }

              var endpointDef = EndpointDefinition(
                name: endpointName,
                documentationComment: classDocumentationComment,
                className: className,
                methods: methodDefs,
                fileName: filePath,
              );
              endpointDefs.add(endpointDef);
            }
          }
        }
      }
    }

    var protocolDefinition = ProtocolDefinition(
      endpoints: endpointDefs,
      filePaths: filePaths,
    );

    return protocolDefinition;
  }

  String? _getInnerPackage(DartType type) {
    if (type.isDartCoreList) {
      type as InterfaceType;
      if (type.typeArguments.length == 1) {
        return type
            .typeArguments[0].element2?.librarySource?.uri.pathSegments[0];
      }
    } else if (type.isDartCoreMap) {
      type as InterfaceType;
      if (type.typeArguments.length == 2) {
        return type
            .typeArguments[1].element2?.librarySource?.uri.pathSegments[0];
      }
    }
    return null;
  }

  String _formatEndpointName(String className) {
    const removeEnding = 'Endpoint';

    var endpointName = '${className[0].toLowerCase()}${className.substring(1)}';
    if (endpointName.endsWith(removeEnding)) {
      endpointName =
          endpointName.substring(0, endpointName.length - removeEnding.length);
    }

    return endpointName;
  }

  void _validateReturnType({
    required DartType dartType,
    required Element dartElement,
    required CodeAnalysisCollector collector,
  }) {
    if (dartType is! InterfaceType) {
      collector.addError(SourceSpanException(
        'This type is not supported as return type.',
        dartElement.span,
      ));
      return;
    }

    if (!dartType.isDartAsyncFuture) {
      collector.addError(SourceSpanException(
        'Return type must be a Future.',
        dartElement.span,
      ));
      return;
    }

    var typeArguments = dartType.typeArguments;
    if (typeArguments.length != 1) {
      collector.addError(SourceSpanException(
        'Future must have a type defined. E.g. Future<String>.',
        dartElement.span,
      ));
      return;
    }
    var innerType = typeArguments[0];

    if (innerType.isVoid) {
      return;
    }

    if (innerType.isDynamic) {
      collector.addError(SourceSpanException(
        'Future must have a type defined. E.g. Future<String>.',
        dartElement.span,
      ));
      return;
    }

    _validateDartType(
      dartType: innerType,
      dartElement: dartElement,
      collector: collector,
    );
  }

  // Check that the type is valid for use with Serverpod, otherwise add an error
  // to the error collector.
  void _validateDartType({
    required DartType? dartType,
    required Element? dartElement,
    required CodeAnalysisCollector collector,
  }) {
    // Only perform check if there is a declared Dart parameter and type.
    if (dartElement == null || dartType == null) {
      return;
    }

    if (dartType is! InterfaceType) {
      collector.addError(SourceSpanException(
        'This type is not supported as an argument or return type.',
        dartElement.span,
      ));
      return;
    }

    if (dartType.isDartCoreList) {
      // Check for supported lists.
      var typeArguments = dartType.typeArguments;
      if (typeArguments.length != 1) {
        collector.addError(SourceSpanException(
          'Lists in parameters must have a type defined. E.g. List<String>.',
          dartElement.span,
        ));
        return;
      }
      if (typeArguments[0].isDynamic) {
        collector.addError(SourceSpanException(
          'Lists in parameters must have a type defined. E.g. List<String>.',
          dartElement.span,
        ));
        return;
      } else if (_isSupportedBaseType(typeArguments[0])) {
        return;
      } else {
        collector.addError(SourceSpanException(
          'This type of List is not supported.',
          dartElement.span,
        ));
        return;
      }
    } else if (dartType.isDartCoreMap) {
      // Check for supported maps.
      var typeArguments = dartType.typeArguments;
      if (typeArguments.length != 2) {
        collector.addError(SourceSpanException(
          'Maps in parameters must have a type defined. E.g. Map<String, int>.',
          dartElement.span,
        ));
        return;
      }
      if (!typeArguments[0].isDartCoreString ||
          typeArguments[0].nullabilitySuffix != NullabilitySuffix.none) {
        collector.addError(SourceSpanException(
          'Maps in parameters must have a non-nullable String as key. E.g. Map<String, int?>.',
          dartElement.span,
        ));
        return;
      }
      if (typeArguments[1].isDynamic) {
        collector.addError(SourceSpanException(
          'Maps in parameters must have a type defined. E.g. List<String, int?>.',
          dartElement.span,
        ));
        return;
      } else if (_isSupportedBaseType(typeArguments[1])) {
        return;
      } else {
        collector.addError(SourceSpanException(
          'This type of Map is not supported.',
          dartElement.span,
        ));
        return;
      }
    } else {
      // Check base types.
      if (_isSupportedBaseType(dartType)) {
        return;
      }
    }

    collector.addError(SourceSpanException(
      'This type is not supported as an argument or return type.',
      dartElement.span,
    ));
  }
}

bool _isSupportedBaseType(DartType type) {
  if (type is! InterfaceType) {
    return false;
  }

  // Core types.
  if (_isSupportedDartCoreType(type)) {
    return true;
  }

  // Basic types.
  var typeName = type.getDisplayString(withNullability: false);
  if (typeName == 'DateTime' || typeName == 'ByteData') {
    return true;
  }

  // Serializable objects.
  for (var superType in type.allSupertypes) {
    if (superType.getDisplayString(withNullability: false) ==
        'SerializableEntity') {
      return true;
    }
  }

  return false;
}

bool _isSupportedDartCoreType(DartType type) {
  return type.isDartCoreBool ||
      type.isDartCoreInt ||
      type.isDartCoreDouble ||
      type.isDartCoreString;
}

extension _DartElementSourceSpan on Element {
  SourceSpan? get span {
    var sourceData = source?.contents.data;
    var sourceUri = source?.uri;
    var offset = nameOffset;
    var length = nameLength;

    if (sourceData != null && offset != 0 && length != -1) {
      var sourceFile = SourceFile.fromString(
        sourceData,
        url: sourceUri,
      );
      return sourceFile.span(offset, offset + length);
    } else {
      return null;
    }
  }
}
