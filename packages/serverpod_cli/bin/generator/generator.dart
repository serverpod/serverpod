import 'config.dart';
import 'class_generator.dart';
import 'protocol_generator.dart';

void performGenerate(bool verbose) {
  if (!config.load())
    return;

  print('Generating classes');
  performGenerateClasses(verbose);
  print('Generating protocol');
  performGenerateProtocol(verbose);
}