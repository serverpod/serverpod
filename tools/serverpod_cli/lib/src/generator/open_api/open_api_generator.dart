import 'dart:convert';

import 'package:serverpod_cli/analyzer.dart';
import 'package:path/path.dart' as p;
import 'open_api_definition.dart';

class OpenApiGenerator {
  OpenApiGenerator();

  String getOpenApiSchema(
    ProtocolDefinition protocolDefinition,
    GeneratorConfig config,
  ) {
    OpenApiDefinition definition = OpenApiDefinition.fromProtocolDefinition(
      protocolDefinition,
      config,
    );
    var encoder = const JsonEncoder.withIndent('    ');
    return encoder.convert(
      definition.toJson(),
    );
  }

  Map<String, String> generateOpenApiSchema({
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  }) {
    return {
      p.joinAll([
        ...config.generatedServerOpenApiPathParts,
        'openapi.json',
      ]): getOpenApiSchema(
        protocolDefinition,
        config,
      ),
    };
  }
}
