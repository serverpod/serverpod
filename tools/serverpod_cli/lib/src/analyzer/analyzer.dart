import 'dart:io';

import 'package:serverpod_cli/analyzer.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/util/print.dart';

import 'dart/endpoints_analyzer.dart';
import 'protocol_definition.dart';

/// Analyzes the protocol of a Serverpod server package.
/// This includes mainly endpoints and the yaml
/// files in the protocol directory.
class ProtocolAnalyzer {
  final String packageDirectory;
  final GeneratorConfig config;

  /// Create a new [ProtocolAnalyzer].
  const ProtocolAnalyzer({
    required this.packageDirectory,
    required this.config,
  });

  /// Analyze the protocol of the [packageDirectory] using the [config].
  Future<ProtocolDefinition> analyze({
    bool verbose = false,
    required CodeAnalysisCollector collector,
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

    var endpoints = await EndpointsAnalyzer(
      Directory(p.join(
        packageDirectory,
        config.relativeEndpointsSourcePath,
      )),
    ).analyze(
      verbose: verbose,
      collector: collector,
    );

    return ProtocolDefinition(
      endpoints: endpoints,
      entities: protocolFileDefinitions,
    );
  }
}
