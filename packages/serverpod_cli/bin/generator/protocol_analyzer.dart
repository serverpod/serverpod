import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import 'config.dart';
import 'protocol_definition.dart';

ProtocolAnalyzer? _analyzer;

Future<ProtocolDefinition> performAnalysis(bool verbose) async {
  var analyzer = _analyzer ?? ProtocolAnalyzer(config.sourceEndpoints);
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
    List<EndpointDefinition> endpointDefs = [];
    List<String> filePaths = [];

    for (final context in collection.contexts) {
      for (final filePath in context.contextRoot.analyzedFiles()) {
        if (!filePath.endsWith('.dart')) {
          continue;
        }
        filePaths.add(filePath);

        var library = await context.currentSession.getResolvedLibrary(filePath);
        var element = library.element!;
        var topElements = element.topLevelElements;

        for (var element in topElements) {
          if (element is ClassElement) {
            String className = element.name;
            String superclassName = element.supertype!.element.name;
            String endpointName = _formatEndpointName(className);

            if (superclassName == 'Endpoint') {

              List<MethodDefinition> methodDefs = [];
              var methods = element.methods;
              for (var method in methods) {
                // Skip private methods
                if (method.isPrivate)
                  continue;
                
                List<ParameterDefinition> paramDefs = [];
                List<ParameterDefinition> paramPositionalDefs = [];
                List<ParameterDefinition> paramNamedDefs = [];
                var parameters = method.parameters;
                for (var param in parameters) {
                  String? package = param.type.element?.librarySource?.uri.pathSegments[0];
                  var paramDef = ParameterDefinition(
                    name: param.name,
                    type: TypeDefinition(param.type.getDisplayString(withNullability: true), package),
                  );
                  
                  if (param.isRequiredPositional)
                    paramDefs.add(paramDef);
                  else if (param.isOptionalPositional)
                    paramPositionalDefs.add(paramDef);
                  else if (param.isNamed)
                    paramNamedDefs.add(paramDef);
                }

                if (paramDefs.length >= 1 && paramDefs[0].type.type == 'Session' && method.returnType.isDartAsyncFuture) {
                  String? package;
                  var returnType = method.returnType;
                  if (returnType is InterfaceType) {
                    InterfaceType interfaceType = returnType;
                    if (interfaceType.typeArguments.length == 1) {
                      package = interfaceType.typeArguments[0].element?.librarySource?.uri.pathSegments[0];
                    }
                  }

                  var methodDef = MethodDefinition(
                    name: method.name,
                    parameters: paramDefs.sublist(1), // Skip session parameter
                    parametersNamed: paramNamedDefs,
                    parametersPositional: paramPositionalDefs,
                    returnType: TypeDefinition(method.returnType.getDisplayString(withNullability: true), package, stripFuture: true),
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
    if (endpointName.endsWith(removeEnding))
      endpointName = endpointName.substring(0, endpointName.length - removeEnding.length);

    return endpointName;
  }
}
