import 'dart:io';

import 'package:serverpod_cli/analyzer.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/util/print.dart';

import 'dart/endpoints_analyzer.dart';

/// Analyzes the protocol of a Serverpod server package.
/// This includes mainly endpoints and the yaml
/// files in the protocol directory.
class ProtocolAnalyzer {
  final String packageDirectory;
  final GeneratorConfig config;

  late final EndpointsAnalyzer _endpointsAnalyzer;

  /// Create a new [ProtocolAnalyzer].
  ProtocolAnalyzer({
    required this.packageDirectory,
    required this.config,
  }) {
    _endpointsAnalyzer = EndpointsAnalyzer(
      Directory(p.join(
        packageDirectory,
        config.relativeEndpointsSourcePath,
      )),
    );
  }

  /// Analyze the protocol of the [packageDirectory] using the [config].
  Future<ProtocolDefinition> analyze({
    bool verbose = false,
    required CodeAnalysisCollector collector,
    Set<String>? changedFiles,
  }) async {
    if (verbose) {
      printww('Analyzing protocol yaml files.');
    }
    var protocolFileDefinitions = await ProtocolEntityAnalyzer.analyzeFiles(
      protocolDirectory: Directory(p.join(
        packageDirectory,
        config.relativeProtocolSourcePath,
      )),
      collector: collector,
      config: config,
    );

    if (verbose) {
      collector.printErrors();
      collector.clearErrors();
      printww('Analyzing server code.');
    }

    var endpoints = await _endpointsAnalyzer.analyze(
      verbose: verbose,
      collector: collector,
      changedFiles: changedFiles,
    );

    return ProtocolDefinition(
      endpoints: endpoints,
      entities: protocolFileDefinitions,
    );
  }
}
