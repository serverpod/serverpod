import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';
import 'package:serverpod_cli/src/config/config.dart';

extension ProtocolDefinitionExtension on ProtocolDefinition {
  bool get shouldGenerateFutureCalls =>
      futureCalls.isNotEmpty && !futureCalls.every((f) => f.isAbstract);

  /// Whether generated [Endpoints] should override `onStartup`.
  ///
  /// Host packages fan out to nested modules; any package with a local
  /// [Module] emits a local call. Module packages never fan out (flat root
  /// invocation avoids double-init under nested Endpoint maps).
  bool shouldGenerateOnStartup(GeneratorConfig config) {
    if (module != null) return true;
    return config.type == PackageType.server && config.modules.isNotEmpty;
  }
}
