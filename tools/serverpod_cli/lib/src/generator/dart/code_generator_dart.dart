import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/generator/dart/entities_library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generator.dart';
import 'package:serverpod_cli/src/util/print.dart';

/// A [CodeGenerator], that generates dart code.
class DartCodeGenerator extends CodeGenerator {
  /// Create a new [DartCodeGenerator]
  const DartCodeGenerator();

  @override
  Map<String, String> generateSerializableEntitiesCode({
    required bool verbose,
    required List<SerializableEntityDefinition> entities,
    required GeneratorConfig config,
  }) {
    var serverSideGenerator = EntityLibraryGenerator(
      serverCode: true,
      config: config,
    );
    var clientSideGenerator = EntityLibraryGenerator(
      serverCode: false,
      config: config,
    );

    return {
      // Server
      // Generate a temporary protocol.dart file. Since this is required to analyze the endpoints.
      p.joinAll([...config.generatedServerProtocolPathParts, 'protocol.dart']):
          serverSideGenerator
              .generateTemporaryProtocol(entities: entities)
              .generateCode(true),
      for (var protocolFile in entities)
        p.joinAll([
          ...config.generatedServerProtocolPathParts,
          ...protocolFile.subDirParts,
          '${protocolFile.fileName}.dart'
        ]): serverSideGenerator
            .generateEntityLibrary(protocolFile)
            .generateCode(true),

      // Client
      for (var protocolFile in entities)
        if (!protocolFile.serverOnly)
          p.joinAll([
            ...config.generatedDartClientProtocolPathParts,
            ...protocolFile.subDirParts,
            '${protocolFile.fileName}.dart',
          ]): clientSideGenerator
              .generateEntityLibrary(protocolFile)
              .generateCode(true),
    };
  }

  @override
  Map<String, String> generateProtocolCode({
    required bool verbose,
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
          serverClassGenerator
              .generateProtocol(verbose: verbose)
              .generateCode(true),
      p.joinAll([...config.generatedServerProtocolPathParts, 'endpoints.dart']):
          serverClassGenerator
              .generateServerEndpointDispatch()
              .generateCode(true),

      // Client
      p.joinAll([
        ...config.generatedDartClientProtocolPathParts,
        'protocol.dart'
      ]): clientClassGenerator
          .generateProtocol(verbose: verbose)
          .generateCode(true),
      p.joinAll(
              [...config.generatedDartClientProtocolPathParts, 'client.dart']):
          clientClassGenerator.generateClientEndpointCalls().generateCode(true),
    };
  }

  @override
  Future<List<String>> getDirectoriesRequiringCleaning(
      {required bool verbose,
      required ProtocolDefinition protocolDefinition,
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
  String generateCode(bool dartFormat) {
    var code = accept(DartEmitter.scoped(useNullSafetySyntax: true)).toString();
    if (dartFormat) {
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
        printww(e.toString());
      }
    }
    return code;
  }
}
