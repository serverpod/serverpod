import 'package:serverpod_cli/src/internal_tools/generate_pubspecs.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';

class GeneratePubspecsCommand extends ServerpodCommand {
  @override
  final name = 'generate-pubspecs';

  @override
  final description = '';

  @override
  bool get hidden => true;

  GeneratePubspecsCommand() {
    argParser.addOption('version', mandatory: true);
    argParser.addOption('dart-version', mandatory: true);
    argParser.addOption('flutter-version', mandatory: true);
    argParser.addOption(
      'mode',
      defaultsTo: 'development',
      allowed: ['development', 'production'],
    );
  }

  @override
  void run() {
    var version = argResults!['version'];
    var dartVersion = argResults!['dart-version'];
    var flutterVersion = argResults!['flutter-version'];
    var mode = argResults!['mode'];

    performGeneratePubspecs(
      version: version,
      dartVersion: dartVersion,
      flutterVersion: flutterVersion,
      mode: mode,
    );
  }
}
