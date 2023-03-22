import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/generator/dart/class_generator_dart.dart';
import 'package:serverpod_cli/src/util/print.dart';

/// A [CodeGenerator], that generates dart code.
class DartCodeGenerator extends CodeGenerator {
  @override
  Map<String, Future<String> Function()> generateCode({
    required bool verbose,
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  }) {
    var serverClassGenerator = ClassGeneratorDart(
      serverCode: true,
      protocolDefinition: protocolDefinition,
      config: config,
    );
    var clientClassGenerator = ClassGeneratorDart(
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
            .generateEntityFile(protocolFile)
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
            config.relativeGeneratedClientProtocolPath,
            ...?protocolFile.subDir?.split('/'),
            '${protocolFile.fileName}.dart',
          ]): () async => clientClassGenerator
              .generateEntityFile(protocolFile)
              .generateCode(true),
      p.joinAll([config.relativeGeneratedClientProtocolPath, 'protocol.dart']):
          () async => clientClassGenerator
              .generateProtocol(verbose: verbose)
              .generateCode(true),
      p.join(config.relativeGeneratedClientProtocolPath, 'client.dart'):
          () async => clientClassGenerator
              .generateClientEndpointCalls()
              .generateCode(true),
    };
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
