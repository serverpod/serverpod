import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/file_system/physical_file_system.dart';

import 'config.dart';
import 'protocol_definition.dart';

const _excludedMethodNameSet = {
  'setupStream',
  'handleStreamMessage',
  'sendStreamMessage',
};

ProtocolAnalyzer? _analyzer;

Future<ProtocolDefinition> performAnalysis(bool verbose) async {
  var analyzer = _analyzer ?? ProtocolAnalyzer(config.endpointsSourcePath);
  return await analyzer.analyze(verbose);
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

  Future<ProtocolDefinition> analyze(bool verbose) async {
    var endpointDefs = <EndpointDefinition>[];
    var filePaths = <String>[];

    for (final context in collection.contexts) {
      var analyzedFiles = context.contextRoot.analyzedFiles().toList();
      analyzedFiles.sort();
      for (final filePath in analyzedFiles) {
        if (!filePath.endsWith('.dart')) {
          continue;
        }
        filePaths.add(filePath);

        // TODO: Test and fix
        // ignore: deprecated_member_use
        var library = await context.currentSession.getResolvedLibrary(filePath);
        var element = library.element!;
        var topElements = element.topLevelElements;

        for (var element in topElements) {
          if (element is ClassElement) {
            var className = element.name;
            var superclassName = element.supertype!.element.name;
            var endpointName = _formatEndpointName(className);

            if (superclassName == 'Endpoint') {
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
                      param.type.element?.librarySource?.uri.pathSegments[0];
                  var paramDef = ParameterDefinition(
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
                  var returnType = method.returnType;
                  if (returnType is InterfaceType) {
                    var interfaceType = returnType;
                    if (interfaceType.typeArguments.length == 1) {
                      package = interfaceType.typeArguments[0].element
                          ?.librarySource?.uri.pathSegments[0];
                    }
                  }

                  var methodDef = MethodDefinition(
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

              var endpointDef = EndpointDefinition(
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
    const removeEnding = 'Endpoint';

    var endpointName = '${className[0].toLowerCase()}${className.substring(1)}';
    if (endpointName.endsWith(removeEnding)) {
      endpointName =
          endpointName.substring(0, endpointName.length - removeEnding.length);
    }

    return endpointName;
  }
}
