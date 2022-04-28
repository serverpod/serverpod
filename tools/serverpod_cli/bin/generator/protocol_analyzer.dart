import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/file_system/physical_file_system.dart';

import 'config.dart';
import 'protocol_definition.dart';

const Set<String> _excludedMethodNameSet = <String>{
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
    print('endpointDirectory: ${endpointDirectory.path}');
    print('endpointDirectory.absolute: ${endpointDirectory.absolute.path}');
    collection = AnalysisContextCollection(
      includedPaths: <String>[endpointDirectory.absolute.path],
      resourceProvider: PhysicalResourceProvider.INSTANCE,
    );
  }

  Future<List<String>> getErrors() async {
    List<String> errorMessages = <String>[];

    for (AnalysisContext context in collection.contexts) {
      Iterable<String> analyzedFiles = context.contextRoot.analyzedFiles();
      for (String filePath in analyzedFiles) {
        SomeErrorsResult errors =
            await context.currentSession.getErrors(filePath);
        if (errors is ErrorsResult) {
          for (AnalysisError error in errors.errors) {
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
    List<EndpointDefinition> endpointDefs = <EndpointDefinition>[];
    List<String> filePaths = <String>[];

    for (AnalysisContext context in collection.contexts) {
      List<String> analyzedFiles = context.contextRoot.analyzedFiles().toList();
      analyzedFiles.sort();
      for (String filePath in analyzedFiles) {
        if (!filePath.endsWith('.dart')) {
          continue;
        }
        filePaths.add(filePath);

        SomeResolvedLibraryResult library =
            await context.currentSession.getResolvedLibrary(filePath);
        library as ResolvedLibraryResult;
        LibraryElement element = library.element;
        Iterable<Element> topElements = element.topLevelElements;

        for (Element element in topElements) {
          if (element is ClassElement) {
            String className = element.name;
            String superclassName = element.supertype!.element.name;
            String endpointName = _formatEndpointName(className);

            if (superclassName == 'Endpoint') {
              List<MethodDefinition> methodDefs = <MethodDefinition>[];
              List<MethodElement> methods = element.methods;
              for (MethodElement method in methods) {
                // Skip private methods
                if (method.isPrivate) continue;
                // Skip overridden methods from the Endpoint class
                if (_excludedMethodNameSet.contains(method.name)) continue;

                List<ParameterDefinition> paramDefs = <ParameterDefinition>[];
                List<ParameterDefinition> paramPositionalDefs =
                    <ParameterDefinition>[];
                List<ParameterDefinition> paramNamedDefs =
                    <ParameterDefinition>[];
                List<ParameterElement> parameters = method.parameters;
                for (ParameterElement param in parameters) {
                  String? package =
                      param.type.element?.librarySource?.uri.pathSegments[0];
                  ParameterDefinition paramDef = ParameterDefinition(
                    name: param.name,
                    type: TypeDefinition(
                        param.type.getDisplayString(withNullability: true),
                        package),
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
                  DartType returnType = method.returnType;
                  if (returnType is InterfaceType) {
                    InterfaceType interfaceType = returnType;
                    if (interfaceType.typeArguments.length == 1) {
                      package = interfaceType.typeArguments[0].element
                          ?.librarySource?.uri.pathSegments[0];
                    }
                  }

                  MethodDefinition methodDef = MethodDefinition(
                    name: method.name,
                    parameters: paramDefs.sublist(1), // Skip session parameter
                    parametersNamed: paramNamedDefs,
                    parametersPositional: paramPositionalDefs,
                    returnType: TypeDefinition(
                        method.returnType
                            .getDisplayString(withNullability: true),
                        package,
                        stripFuture: true),
                  );
                  methodDefs.add(methodDef);
                }
              }

              EndpointDefinition endpointDef = EndpointDefinition(
                name: endpointName,
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

  String _formatEndpointName(String className) {
    const String removeEnding = 'Endpoint';

    String endpointName =
        '${className[0].toLowerCase()}${className.substring(1)}';
    if (endpointName.endsWith(removeEnding)) {
      endpointName =
          endpointName.substring(0, endpointName.length - removeEnding.length);
    }

    return endpointName;
  }
}
