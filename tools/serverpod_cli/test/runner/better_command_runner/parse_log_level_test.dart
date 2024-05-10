import 'package:args/command_runner.dart';
import 'package:serverpod_cli/src/runner/better_command_runner.dart';
import 'package:test/test.dart';

class MockCommand extends Command {
  static String commandName = 'mock-command';

  @override
  String get description => 'Mock command used for testing';

  @override
  void run() {}

  @override
  String get name => commandName;
}

void main() {
  CommandRunnerLogLevel? logLevel;
  String? parsedCommandName;

  tearDown(() {
    parsedCommandName = null;
    logLevel = null;
  });
  group('Given runner with setLogLevel callback', () {
    var runner = BetterCommandRunner(
      'test',
      'this is a test cli',
      setLogLevel: ({
        required CommandRunnerLogLevel parsedLogLevel,
        String? commandName,
      }) {
        logLevel = parsedLogLevel;
        parsedCommandName = commandName;
      },
    );

    group('when no flags are provided', () {
      setUp(() async => await runner.run([]));
      test('then parsed log level is normal.', () {
        expect(logLevel, CommandRunnerLogLevel.normal);
      });

      test('then no command passed to setLogLevel.', () {
        expect(parsedCommandName, null);
      });
    });

    group('when only quiet flag is provided', () {
      var args = ['--${BetterCommandRunnerFlags.quiet}'];

      setUp(() async => await runner.run(args));
      test('then parsed log level is quiet.', () {
        expect(logLevel, CommandRunnerLogLevel.quiet);
      });

      test('then no command passed to setLogLevel.', () {
        expect(parsedCommandName, null);
      });
    });

    group('when only verbose flag is provided', () {
      var args = ['--${BetterCommandRunnerFlags.verbose}'];

      setUp(() async => await runner.run(args));
      test('then parsed log level is verbose.', () {
        expect(logLevel, CommandRunnerLogLevel.verbose);
      });

      test('then no command passed to setLogLevel.', () {
        expect(parsedCommandName, null);
      });
    });

    group('when both quiet and verbose flags are provided', () {
      var args = [
        '--${BetterCommandRunnerFlags.quiet}',
        '--${BetterCommandRunnerFlags.verbose}',
      ];

      setUp(() async => await runner.run(args));
      test('then parsed log level is verbose.', () {
        expect(logLevel, CommandRunnerLogLevel.verbose);
      });

      test('then no command passed to setLogLevel.', () {
        expect(parsedCommandName, null);
      });
    });
  });

  group('Given runner with setLogLevel callback and registered command', () {
    var runner = BetterCommandRunner(
      'test',
      'this is a test cli',
      setLogLevel: ({
        required CommandRunnerLogLevel parsedLogLevel,
        String? commandName,
      }) {
        logLevel = parsedLogLevel;
        parsedCommandName = commandName;
      },
    )..addCommand(MockCommand());

    test(
        'when running with registered command then command name is passed to setLogLevel callback.',
        () async {
      var args = [MockCommand.commandName];

      await runner.run(args);

      expect(parsedCommandName, MockCommand.commandName);
    });

    group('when verbose flag is passed before registered command', () {
      var args = [
        '--${BetterCommandRunnerFlags.verbose}',
        MockCommand.commandName,
      ];
      setUp(() async => await runner.run(args));

      test('then verbose log level is passed to setLogLevel callback.', () {
        expect(logLevel, CommandRunnerLogLevel.verbose);
      });

      test('then command name is passed to setLogLevel callback.', () {
        expect(parsedCommandName, MockCommand.commandName);
      });
    });

    group('when verbose flag is passed after registered command', () {
      var args = [
        MockCommand.commandName,
        '--${BetterCommandRunnerFlags.verbose}',
      ];
      setUp(() async => await runner.run(args));

      test('then verbose log level is passed to setLogLevel callback.', () {
        expect(logLevel, CommandRunnerLogLevel.verbose);
      });

      test('then command name is passed to setLogLevel callback.', () {
        expect(parsedCommandName, MockCommand.commandName);
      });
    });
  });
}
