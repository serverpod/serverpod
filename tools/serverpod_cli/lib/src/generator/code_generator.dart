import 'package:serverpod_cli/analyzer.dart';

/// A code generator is responsible for generating the code for the target
/// language.
abstract class CodeGenerator {
  /// Create a new [CodeGenerator].
  const CodeGenerator();

  /// Generates the content of files that only depend the SerializableEntities.
  ///
  /// Returns a map where they key is the path of the file and the the value is
  /// the files content.
  ///
  /// Relative paths start at the server package directory.
  ///
  /// Called and generated before [generateProtocolCode].
  Map<String, String> generateSerializableEntitiesCode({
    required List<SerializableEntityDefinition> entities,
    required GeneratorConfig config,
  });

  /// Generate the content of files that depend on the entire
  /// [ProtocolDefinition].
  ///
  /// Returns a map where they key is the path of the file and the the value is
  /// the files content.
  ///
  /// Relative paths start at the server package directory.
  ///
  /// At the time this is called, [generateSerializableEntitiesCode] should
  /// already be called and generated.
  Map<String, String> generateProtocolCode({
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  });
}
