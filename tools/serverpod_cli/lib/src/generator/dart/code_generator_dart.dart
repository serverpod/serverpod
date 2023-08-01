import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/generator/dart/entities_library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generator.dart';
import 'package:serverpod_cli/src/logger/logger.dart';

/// A [CodeGenerator], that generates dart code.
class DartCodeGenerator extends CodeGenerator {
  /// Create a new [DartCodeGenerator]
  const DartCodeGenerator();

  @override
  Map<String, String> generateSerializableEntitiesCode({
    required List<SerializableEntityDefinition> entities,
    required GeneratorConfig config,
  }) {
    var serverSideGenerator = SerializableEntityLibraryGenerator(
      serverCode: true,
      config: config,
    );
    var clientSideGenerator = SerializableEntityLibraryGenerator(
      serverCode: false,
      config: config,
    );

    return {
      // Server
      // Generate a temporary protocol.dart file. Since this is required to
      // analyze the endpoints.
      p.joinAll([...config.generatedServerProtocolPathParts, 'protocol.dart']):
          serverSideGenerator
              .generateTemporaryProtocol(entities: entities)
              .generateCode(),
      for (var protocolFile in entities)
        p.joinAll([
          ...config.generatedServerProtocolPathParts,
          ...protocolFile.subDirParts,
          '${protocolFile.fileName}.dart'
        ]): serverSideGenerator
            .generateEntityLibrary(protocolFile)
            .generateCode(),

      // Client
      for (var protocolFile in entities)
        if (!protocolFile.serverOnly)
          p.joinAll([
            ...config.generatedDartClientProtocolPathParts,
            ...protocolFile.subDirParts,
            '${protocolFile.fileName}.dart',
          ]): clientSideGenerator
              .generateEntityLibrary(protocolFile)
              .generateCode(),
    };
  }

  @override
  Map<String, String> generateProtocolCode({
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  }) {
    var serverClassGenerator = LibraryGenerator(
      serverCode: true,
      protocolDefinition: protocolDefinition,
      config: config,
    );
    var clientClassGenerator = LibraryGenerator(
      serverCode: false,
      protocolDefinition: protocolDefinition,
      config: config,
    );
    return {
      // Server
      p.joinAll([...config.generatedServerProtocolPathParts, 'protocol.dart']):
          serverClassGenerator.generateProtocol().generateCode(),
      p.joinAll([...config.generatedServerProtocolPathParts, 'endpoints.dart']):
          serverClassGenerator.generateServerEndpointDispatch().generateCode(),

      // Client
      p.joinAll([
        ...config.generatedDartClientProtocolPathParts,
        'protocol.dart'
      ]): clientClassGenerator.generateProtocol().generateCode(),
      p.joinAll(
              [...config.generatedDartClientProtocolPathParts, 'client.dart']):
          clientClassGenerator.generateClientEndpointCalls().generateCode(),
    };
  }

  @override
  Future<List<String>> getDirectoriesRequiringCleaning(
      {required ProtocolDefinition protocolDefinition,
      required GeneratorConfig config}) async {
    return [
      p.joinAll(config.generatedServerProtocolPathParts),
      p.joinAll(config.generatedDartClientProtocolPathParts),
    ];
  }

  @override
  List<String> get outputFileExtensions => ['.dart'];
}

extension on Library {
  String generateCode() {
    var code = accept(DartEmitter.scoped(useNullSafetySyntax: true)).toString();
    try {
      return DartFormatter().format('''
/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

$code
''');
    } on FormatterException catch (e) {
      log.error(e.toString());
    }
    return code;
  }
}
