import 'package:serverpod_cli/src/internal_tools/analyze_pubspecs.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/exit_exception.dart';

class AnalyzePubspecsCommand extends ServerpodCommand {
  @override
  final name = 'analyze-pubspecs';

  @override
  final description = '';

  AnalyzePubspecsCommand() {
    argParser.addFlag(
      'check-latest-version',
      defaultsTo: false,
    );
  }

  @override
  Future run() async {
    bool checkLatestVersion = argResults!['check-latest-version'];
    if (!await pubspecDependenciesMatch(checkLatestVersion)) {
      throw ExitException();
    }
  }
}
