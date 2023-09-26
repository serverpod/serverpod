import 'package:serverpod_cli/analyzer.dart';
import 'package:path/path.dart' as p;

class OpenApiGenerator {
  OpenApiGenerator();

  String getOpenApiSchema() {
    String dummyCode = '''
      {
        "openapi": "3.0.0",
        "info": {
          "title": "Serverpod API",
          "version": "1.0.0"
        },
        "paths": {}
      }''';

    return dummyCode;
  }

  Map<String, String> generateOpenApiSchema({
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  }) {
    return {
      p.joinAll([...config.generatedServerOpenApiPathParts, 'open-api.json']):
          getOpenApiSchema(),
    };
  }
}
