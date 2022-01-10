import 'class_generator.dart';
import 'config.dart';
import 'dart_format.dart';
import 'protocol_generator.dart';

Future<void> performGenerate(bool verbose, bool format) async {
  if (!config.load()) return;

  print('Generating classes');
  performGenerateClasses(verbose);

  print('Generating protocol');
  await performGenerateProtocol(verbose);

  if (format) {
    print('Dart format');
    performDartFormat(verbose);
  }

  print('Done.');
}
