import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/generator/dart/library_generator.dart';
import 'package:serverpod_cli/src/util/print.dart';

/// A [CodeGenerator], that generates dart code.
class DartCodeGenerator extends CodeGenerator {
  /// Create a new [DartCodeGenerator]
  const DartCodeGenerator();

  @override
  Map<String, Future<String> Function()> getCodeGeneration({
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
      for (var protocolFile in protocolDefinition.entities)
        p.joinAll([
          config.relativeGeneratedServerProtocolPath,
          ...?protocolFile.subDir?.split('/'),
          '${protocolFile.fileName}.dart',
        ]): () async => serverClassGenerator
            .generateEntityLibrary(protocolFile)
            .generateCode(true),
      p.joinAll([config.relativeGeneratedServerProtocolPath, 'protocol.dart']):
          () async => serverClassGenerator
              .generateProtocol(verbose: verbose)
              .generateCode(true),
      p.join(config.relativeGeneratedServerProtocolPath, 'endpoints.dart'):
          () async => serverClassGenerator
              .generateServerEndpointDispatch()
              .generateCode(true),

      // Client
      for (var protocolFile in protocolDefinition.entities)
        if (!protocolFile.serverOnly)
          p.joinAll([
            config.relativeGeneratedDartClientProtocolPath,
            ...?protocolFile.subDir?.split('/'),
            '${protocolFile.fileName}.dart',
          ]): () async => clientClassGenerator
              .generateEntityLibrary(protocolFile)
              .generateCode(true),
      p.joinAll([
        config.relativeGeneratedDartClientProtocolPath,
        'protocol.dart'
      ]): () async => clientClassGenerator
          .generateProtocol(verbose: verbose)
          .generateCode(true),
      p.join(config.relativeGeneratedDartClientProtocolPath, 'client.dart'):
          () async => clientClassGenerator
              .generateClientEndpointCalls()
              .generateCode(true),
    };
  }

  @override
  Future<List<String>> getDirectoriesRequiringCleaning(
      {required bool verbose,
      required ProtocolDefinition protocolDefinition,
      required GeneratorConfig config}) async {
    return [
      config.relativeGeneratedServerProtocolPath,
      config.relativeGeneratedDartClientProtocolPath
    ];
  }
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
