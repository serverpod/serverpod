import 'package:args/command_runner.dart';
import 'package:serverpod_cli/src/runner/better_command_runner.dart';
import 'package:serverpod_cli/src/util/exit_exception.dart';
import 'package:test/test.dart';

class MockCommand extends Command {
  static String commandName = 'mock-command';

  @override
  String get description => 'Mock command used for testing';

  @override
  void run() {}

  MockCommand() {
    argParser.addOption(
      'name',
      // To make an option truly mandatory, you need to set mandatory to true.
      // and also define a callback.
      mandatory: true,
      callback: (name) {},
      allowed: <String>['serverpod'],
    );
  }

  @override
  String get name => commandName;
}

void main() {
  group('Given runner with registered command', () {
    var runner = BetterCommandRunner(
      'test',
      'this is a test cli',
    )..addCommand(MockCommand());

    test(
        'when running with unknown command then ExitException with command not found exit code is thrown.',
        () async {
      var args = ['unknown-command'];

      await expectLater(
        () => runner.run(args),
        throwsA(predicate<ExitException>(
            (e) => e.exitCodeType == ExitCodeType.commandNotFound)),
      );
    });

    test(
        'when running with invalid command then ExitException with command not found exit code is thrown.',
        () async {
      List<String> args = ['this it not a valid command'];

      await expectLater(
        () => runner.run(args),
        throwsA(predicate<ExitException>(
            (e) => e.exitCodeType == ExitCodeType.commandNotFound)),
      );
    });

    test(
        'when running command without mandatory option then ExitException with command not found exit code is thrown.',
        () async {
      List<String> args = [MockCommand.commandName];

      await expectLater(
        () => runner.run(args),
        throwsA(predicate<ExitException>(
            (e) => e.exitCodeType == ExitCodeType.commandNotFound)),
      );
    });
  });
}
