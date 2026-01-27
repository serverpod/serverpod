import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:serverpod_cli/src/analytics/analytics_helper.dart';
import 'package:serverpod_cli/src/internal_tools/analyze_pubspecs.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';

enum AnalyzePubspecsOption<V> implements OptionDefinition<V> {
  checkLatest(
    FlagOption(
      argName: 'check-latest-version',
      defaultsTo: false,
      helpText: 'Check if the latest version of the dependencies is used.',
    ),
  ),
  onlyMajor(
    FlagOption(
      argName: 'only-major',
      defaultsTo: false,
      helpText:
          'Only check for major updates when checking for latest version.',
    ),
  ),
  ignoreServerpod(
    FlagOption(
      argName: 'ignore-serverpod',
      defaultsTo: false,
      helpText: 'Ignore serverpod packages when checking for latest version.',
    ),
  );

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
    final checkLatestVersion = commandConfig.value(
      AnalyzePubspecsOption.checkLatest,
    );
    final onlyMajor = commandConfig.value(AnalyzePubspecsOption.onlyMajor);
    final ignoreServerpod = commandConfig.value(
      AnalyzePubspecsOption.ignoreServerpod,
    );

    // Build full command string for tracking
    final fullCommandParts = ['serverpod', 'analyze-pubspecs'];
    if (checkLatestVersion) {
      fullCommandParts.add('--check-latest-version');
    }
    if (onlyMajor) {
      fullCommandParts.add('--only-major');
    }
    if (ignoreServerpod) {
      fullCommandParts.add('--ignore-serverpod');
    }
    final fullCommand = fullCommandParts.join(' ');

    var success = false;
    try {
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
      success = true;
    } finally {
      // Track the event
      serverpodRunner.analytics.trackWithProperties(
        event: 'cli:pubspecs_analyzed',
        properties: {
          'full_command': fullCommand,
          'command': 'analyze-pubspecs',
          'check_latest_version': checkLatestVersion,
          'only_major': onlyMajor,
          'ignore_serverpod': ignoreServerpod,
          'success': success,
        },
      );
    }
  }
}
