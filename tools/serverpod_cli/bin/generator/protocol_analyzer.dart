import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/file_system/physical_file_system.dart';

import 'config.dart';
import 'protocol_definition.dart';

const _excludedMethodNameSet = {
  'streamOpened',
  'streamClosed',
  'handleStreamMessage',
  'sendStreamMessage',
  'setUserObject',
  'getUserObject',
};

ProtocolAnalyzer? _analyzer;

Future<ProtocolDefinition> performAnalysis(
  bool verbose, {
  bool requestNewAnalyzer = true,
}) async {
  if (requestNewAnalyzer) {
    _analyzer = null;
  }
  _analyzer ??= ProtocolAnalyzer(config.endpointsSourcePath);
  return await _analyzer!.analyze(verbose);
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

  Future<ProtocolDefinition> analyze(bool verbose) async {
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
                    type: TypeDefinition(
                      param.type.getDisplayString(withNullability: true),
                      package,
                      _getInnerPackage(param.type),
                    ),
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
                    paramDefs[0].type.type == 'Session' &&
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

                  var methodDef = MethodDefinition(
                    name: method.name,
                    documentationComment: method.documentationComment,
                    parameters: paramDefs.sublist(1), // Skip session parameter
                    parametersNamed: paramNamedDefs,
                    parametersPositional: paramPositionalDefs,
                    returnType: TypeDefinition(
                      method.returnType.getDisplayString(withNullability: true),
                      package,
                      innerPackage,
                      stripFuture: true,
                    ),
                  );
                  methodDefs.add(methodDef);
                }
              }

              var endpointDef = EndpointDefinition(
                name: endpointName,
                documentationComment: classDocumentationComment,
                className: className,
                methods: methodDefs,
              );
              endpointDefs.add(endpointDef);
            }
          }
        }
      }
    }
    return ProtocolDefinition(
      endpoints: endpointDefs,
      filePaths: filePaths,
    );
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
}
