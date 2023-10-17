import 'dart:convert';

import 'package:serverpod_cli/analyzer.dart';
import 'package:path/path.dart' as p;
import 'open_api_definition.dart';

///  Generates OpenAPI specifications for a Serverpod project.
class OpenAPIGenerator {
  const OpenAPIGenerator();

  String getOpenAPISchema(
    ProtocolDefinition protocolDefinition,
    GeneratorConfig config,
  ) {
    OpenAPIDefinition definition = OpenAPIDefinition.fromProtocolDefinition(
      protocolDefinition,
      config,
    );
    var encoder = const JsonEncoder.withIndent('    ');
    return encoder.convert(
      definition.toJson(),
    );
  }

  Map<String, String> generateOpenAPISchema({
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  }) {
    return {
      p.joinAll([
        ...config.generatedServerOpenAPIPathParts,
        'openapi.json',
      ]): getOpenAPISchema(
        protocolDefinition,
        config,
      ),
    };
  }
}
