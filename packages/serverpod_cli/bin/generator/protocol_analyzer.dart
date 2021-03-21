import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';

ProtocolAnalyzer _analyzer;

Future<void> performAnalysis(String path) async {
//  var analyzer = _analyzer ?? ProtocolAnalyzer('lib/src/endpoints/');
  var analyzer = ProtocolAnalyzer(path);
  await analyzer.analyze();
}

class ProtocolAnalyzer {
  final File file;
  AnalysisContextCollection collection;

  ProtocolAnalyzer(String filePath) : file = File(filePath) {
    collection = AnalysisContextCollection(
      includedPaths: [file.absolute.path],
      resourceProvider: PhysicalResourceProvider.INSTANCE,
    );
  }

  Future<Map<String, dynamic>> analyze() async {
    for (final context in collection.contexts) {
      print('Analyzing ${context.contextRoot.root.path} ...');

      for (final filePath in context.contextRoot.analyzedFiles()) {
        if (!filePath.endsWith('.dart')) {
          continue;
        }

        print('Checking variables');
        var variables = await context.currentSession.declaredVariables;
        for (var variable in variables.variableNames) {
          print('Variable: $variable');
        }

        var library = await context.currentSession.getResolvedLibrary(filePath);
        var element = library.element;
        var topElements = element.topLevelElements;
        for (var element in topElements) {
          if (element is ClassElement) {
            String className = element.name;
            String superclassName = element.supertype.element.name;

            print('Class: $className');
            print('Supertype: $superclassName');

            if (superclassName == 'Endpoint') {
              print('Found Endpoint');

              var methods = element.methods;
              for (var method in methods) {
                String methodName = method.name;
                if (methodName.startsWith('_'))
                  continue;

                print(' - ${method.name}');

                var parameters = method.parameters;
                for (var param in parameters) {
                  print('   - ${param.name} type: ${param.type.element.name} optional: ${param.isOptionalPositional}');
                }
              }
            }
          }
        }
      }
    }
  }
}
