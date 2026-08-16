import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';

extension ProtocolDefinitionExtension on ProtocolDefinition {
  bool get shouldGenerateFutureCalls =>
      futureCalls.isNotEmpty && !futureCalls.every((f) => f.isAbstract);
}
