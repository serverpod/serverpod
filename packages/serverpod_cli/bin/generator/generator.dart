import 'config.dart';
import 'class_generator.dart';
import 'protocol_generator.dart';

void performGenerate(bool verbose) {
  if (!config.load())
    return;

  print('Generating classes');
  performGenerateClasses(verbose);

  if (config.type == PackageType.server) {
    print('Generating protocol');
    performGenerateProtocol(verbose);
  }
}