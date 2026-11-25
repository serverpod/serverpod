import 'package:cli_tools/cli_tools.dart';
import 'package:config/command.dart';
import 'package:config/config.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/serverpod_command.dart';
import 'package:serverpod_cli/src/commands/serverpod_command_runner.dart';
import 'package:test/test.dart';

class _TestCommand extends ServerpodCommand<OptionDefinition> {
  @override
  final name = 'test-command';

  @override
  final description = 'Test command used for verifying usage output.';

  _TestCommand() : super(options: const []);

  @override
  void run(CommandContext<OptionDefinition, void> context) {}
}

class _MockAnalytics implements Analytics {
  @override
  void track({
    required String event,
    Map<String, dynamic> properties = const {},
  }) {}

  @override
  void cleanUp() {}

  @override
  Future<void> flush() async {}

  @override
  Future<void> sendEvent({
    required String event,
    Map<String, dynamic> properties = const {},
  }) async {}
}

void main() {
  group('Given a Serverpod command registered on the command runner,', () {
    late ServerpodCommandRunner runner;
    late _TestCommand command;

    setUp(() {
      runner = ServerpodCommandRunner.createCommandRunner(
        _MockAnalytics(),
        false,
        Version(1, 1, 0),
        preCommandHooks: false,
      );
      command = _TestCommand();
      runner.addCommand(command);
    });

    test(
      'when reading the command usage, then it points at the global options',
      () {
        expect(
          command.usage,
          contains('Run "serverpod help" to see global options.'),
        );
        expect(command.usage, isNot(contains('-h, --help')));
      },
    );

    test(
      'when reading the runner usage, then the interactive option is listed',
      () {
        expect(runner.usage, contains('--[no-]interactive'));
      },
    );
  });
}
