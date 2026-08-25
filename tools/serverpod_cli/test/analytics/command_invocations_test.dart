import 'package:cli_tools/cli_tools.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/analytics/payload_builder.dart';
import 'package:serverpod_cli/src/commands/analyze_pubspecs.dart';
import 'package:serverpod_cli/src/commands/cloud.dart';
import 'package:serverpod_cli/src/commands/create.dart';
import 'package:serverpod_cli/src/commands/create_migration.dart';
import 'package:serverpod_cli/src/commands/create_repair_migration.dart';
import 'package:serverpod_cli/src/commands/database.dart';
import 'package:serverpod_cli/src/commands/generate.dart';
import 'package:serverpod_cli/src/commands/generate_pubspecs.dart';
import 'package:serverpod_cli/src/commands/language_server.dart';
import 'package:serverpod_cli/src/commands/mcp.dart';
import 'package:serverpod_cli/src/commands/migrate.dart';
import 'package:serverpod_cli/src/commands/quickstart.dart';
import 'package:serverpod_cli/src/commands/run.dart';
import 'package:serverpod_cli/src/commands/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/commands/start.dart';
import 'package:serverpod_cli/src/commands/upgrade.dart';
import 'package:serverpod_cli/src/commands/version.dart';
import 'package:test/test.dart';

class _SilentAnalytics extends Analytics {
  @override
  Future<void> sendEvent({
    required String event,
    Map<String, dynamic> properties = const {},
  }) async {}
}

void main() {
  group('Given every registered Serverpod command, ', () {
    late Iterable<String> commandNames;

    setUp(() {
      final version = Version.parse('1.0.0');
      final runner =
          ServerpodCommandRunner.createCommandRunner(
            _SilentAnalytics(),
            true,
            version,
          )..addCommands([
            AnalyzePubspecsCommand(),
            CloudCommand(),
            CreateCommand(),
            DatabaseCommand(),
            QuickstartCommand(),
            GenerateCommand(),
            GeneratePubspecsCommand(),
            LanguageServerCommand(),
            McpCommand(),
            CreateMigrationCommand(),
            CreateRepairMigrationCommand(),
            MigrateCommand(),
            RunCommand(),
            StartCommand(),
            UpgradeCommand(),
            VersionCommand(version),
          ]);
      commandNames = runner.commands.keys;
    });

    test(
      'when its name is checked against the analytics command pattern, '
      'then it is accepted.',
      () {
        // `command_invocations` keys are subcommand names taken straight from
        // the runner. If a command is ever named outside this shape it would be
        // silently dropped from the histogram, so pin the two together.
        expect(commandNames, isNotEmpty);
        for (final name in commandNames) {
          expect(
            AnalyticsPayloadBuilder.commandNamePattern.hasMatch(name),
            isTrue,
            reason: 'Command "$name" would not be counted in analytics.',
          );
        }
      },
    );
  });
}
