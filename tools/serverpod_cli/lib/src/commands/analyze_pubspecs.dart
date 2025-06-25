import 'package:cli_tools/cli_tools.dart';
import 'package:serverpod_cli/src/internal_tools/analyze_pubspecs.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';

enum AnalyzePubspecsOption<V> implements OptionDefinition<V> {
  checkLatest(FlagOption(
    argName: 'check-latest-version',
    defaultsTo: false,
    helpText: 'Check if the latest version of the dependencies is used.',
  )),
  onlyMajor(FlagOption(
    argName: 'only-major',
    defaultsTo: false,
    helpText: 'Only check for major updates when checking for latest version.',
  )),
  ignoreServerpod(FlagOption(
    argName: 'ignore-serverpod',
    defaultsTo: false,
    helpText: 'Ignore serverpod packages when checking for latest version.',
  ));

  const AnalyzePubspecsOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

class AnalyzePubspecsCommand extends ServerpodCommand<AnalyzePubspecsOption> {
  @override
  final name = 'analyze-pubspecs';

  @override
  final description = '';

  @override
  bool get hidden => true;

  AnalyzePubspecsCommand() : super(options: AnalyzePubspecsOption.values);

  @override
  Future<void> runWithConfig(
    final Configuration<AnalyzePubspecsOption> commandConfig,
  ) async {
    final checkLatestVersion =
        commandConfig.value(AnalyzePubspecsOption.checkLatest);
    final onlyMajor = commandConfig.value(AnalyzePubspecsOption.onlyMajor);
    final ignoreServerpod =
        commandConfig.value(AnalyzePubspecsOption.ignoreServerpod);

    var checkLatestVersionObj = switch (checkLatestVersion) {
      true => CheckLatestVersion(
          onlyMajorUpdate: onlyMajor,
          ignoreServerpodPackages: ignoreServerpod,
        ),
      false => null,
    };

    if (!await pubspecDependenciesMatch(
      checkLatestVersion: checkLatestVersionObj,
    )) {
      throw ExitException.error();
    }
  }
}
