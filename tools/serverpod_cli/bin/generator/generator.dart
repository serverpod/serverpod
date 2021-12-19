import 'class_generator.dart';
import 'config.dart';
import 'dart_format.dart';
import 'protocol_generator.dart';

void performGenerate(bool verbose) {
  if (!config.load()) return;

  print('Generating classes');
  performGenerateClasses(verbose);

  print('Generating protocol');
  performGenerateProtocol(verbose);

  print('Dart format');
  performDartFormat(verbose);
}
