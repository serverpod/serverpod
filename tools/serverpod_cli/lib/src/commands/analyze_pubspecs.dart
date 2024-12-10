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

    argParser.addFlag(
      'only-major',
      defaultsTo: false,
      help: 'Only check for major updates when checking for latest version.',
    );

    argParser.addFlag(
      'ignore-serverpod',
      defaultsTo: false,
      help: 'Ignore serverpod packages when checking for latest version.',
    );
  }

  @override
  Future<void> run() async {
    bool checkLatestVersion = argResults!['check-latest-version'];
    var checkLatestVersionObj = switch (checkLatestVersion) {
      true => CheckLatestVersion(
          onlyMajorUpdate: argResults!['only-major'],
          ignoreServerpodPackages: argResults!['ignore-serverpod'],
        ),
      false => null,
    };

    if (!await pubspecDependenciesMatch(
      checkLatestVersion: checkLatestVersionObj,
    )) {
      throw ExitException();
    }
  }
}
