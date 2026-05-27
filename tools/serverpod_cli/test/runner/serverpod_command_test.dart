import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:test/test.dart';

class _TestCommand extends ServerpodCommand<OptionDefinition> {
  @override
  final name = 'test-command';

  @override
  final description = 'Test command used for verifying usage output.';

  _TestCommand() : super(options: const []);

  @override
  void runWithConfig(Configuration<OptionDefinition> commandConfig) {}
}

class _MockAnalytics implements Analytics {
  @override
  void track({
    required String event,
    Map<String, dynamic> properties = const {},
  }) {}

  @override
  void cleanUp() {}
}

void main() {
  group('Given a Serverpod command registered on the command runner', () {
    late _TestCommand command;

    setUp(() {
      var runner = ServerpodCommandRunner.createCommandRunner(
        _MockAnalytics(),
        false,
        Version(1, 1, 0),
        onBeforeRunCommand: (_) async {},
      );
      command = _TestCommand();
      runner.addCommand(command);
    });

    test('when reading the usage then the global options are listed', () {
      expect(command.usage, contains('Global options:'));
    });

    test(
      'when reading the usage then the interactive global option is listed',
      () {
        expect(command.usage, contains('--[no-]interactive'));
      },
    );

    test(
      'when reading the usage then the command specific options are still listed',
      () {
        expect(command.usage, contains('-h, --help'));
      },
    );

    test(
      'when reading the usage then the top-level help reference note is removed',
      () {
        expect(command.usage, isNot(contains('to see global options')));
      },
    );
  });
}
