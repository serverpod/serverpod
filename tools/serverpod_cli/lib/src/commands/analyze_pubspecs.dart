import 'package:cli_tools/cli_tools.dart';
import 'package:serverpod_cli/src/internal_tools/analyze_pubspecs.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';

class AnalyzePubspecsCommand extends ServerpodCommand {
  @override
  final name = 'analyze-pubspecs';

  @override
  final description = '';

  @override
  bool get hidden => true;

  AnalyzePubspecsCommand() {
    argParser.addFlag(
      'check-latest-version',
      defaultsTo: false,
    );
  }

  @override
  Future<void> run() async {
    bool checkLatestVersion = argResults!['check-latest-version'];
    if (!await pubspecDependenciesMatch(checkLatestVersion)) {
      throw ExitException();
    }
  }
}
