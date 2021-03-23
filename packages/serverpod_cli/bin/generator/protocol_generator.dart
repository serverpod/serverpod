import 'protocol_definition.dart';
import 'protocol_analyzer.dart';
import 'protocol_generator_dart.dart';

Future<void> performGenerateProtocol(bool verbose) async {
  if (verbose)
    print('Analyzing protol');
  ProtocolDefinition definition = await performAnalysis(verbose);
  var generator = ProtocolGeneratorDart(protocolDefinition: definition);

  if (verbose)
    print('Generating client endpoints');
  var protocol = generator.generateClientEndpoints();
  if (verbose)
    print(protocol);


}

abstract class ProtocolGenerator {
  final ProtocolDefinition protocolDefinition;

  ProtocolGenerator({this.protocolDefinition});

  String generateServerEndpointGlue() {

  }

  String generateClientEndpoints();
}