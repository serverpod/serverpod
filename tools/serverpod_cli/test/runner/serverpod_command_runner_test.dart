import 'package:args/command_runner.dart';
import 'package:cli_tools/cli_tools.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/language_server.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';

class MockAnalytics implements Analytics {
  List<String> trackedEvents = [];

  int numberOfCleanups = 0;

  @override
  void track({required String event}) {
    trackedEvents.add(event);
  }

  @override
  void cleanUp() {
    numberOfCleanups++;
  }
}

class MockCommand extends Command {
  static const String commandName = 'mock-command';
  List<String> trackedOptions = [];
  int numberOfRuns = 0;

  @override
  final name = commandName;

  @override
  final description = 'Mock command used for testing.';

  @override
  void run() {
    trackedOptions.add(argResults!['name']);
    numberOfRuns++;
  }

  MockCommand() {
    argParser.addOption(
      'name',
      defaultsTo: 'alex',
      allowed: <String>['alex', 'isak', 'viktor'],
    );
  }
}

class LanguageServerMockCommand extends Command {
  @override
  final name = LanguageServerCommand.commandName;

  @override
  final description = 'Language Server Mock command used for testing.';

  @override
  void run() {}
}

class TestFixture {
  final MockAnalytics analytics;
  final MockCommand mockCommand;
  final ServerpodCommandRunner runner;

  TestFixture(
    this.analytics,
    this.mockCommand,
    this.runner,
  );
}

TestFixture createTestFixture() {
  var analytics = MockAnalytics();
  var runner = ServerpodCommandRunner.createCommandRunner(
    analytics,
    false,
    Version(1, 1, 0),
    onBeforeRunCommand: (_) => Future(() => {}),
  );
  var mockCommand = MockCommand();
  runner.addCommand(mockCommand);
  runner.addCommand(LanguageServerMockCommand());
  return TestFixture(analytics, mockCommand, runner);
}

void main() {
  initializeLoggerWith(VoidLogger());

  late TestFixture fixture;
  setUp(() {
    fixture = createTestFixture();
  });
  group('Logger Initialization - ', () {
    test('when no log level flag is provided', () async {
      List<String> args = [];

      await fixture.runner.run(args);

      expect(log.logLevel, equals(LogLevel.info));
    });

    test('when only --${BetterCommandRunnerFlags.verbose} flag is provided',
        () async {
      List<String> args = [
        '--${BetterCommandRunnerFlags.verbose}',
      ];

      await fixture.runner.run(args);

      expect(log.logLevel, equals(LogLevel.debug));
    });
    test('when only --${BetterCommandRunnerFlags.quiet} flag is provided',
        () async {
      List<String> args = [
        '--${BetterCommandRunnerFlags.quiet}',
      ];

      await fixture.runner.run(args);

      expect(log.logLevel, equals(LogLevel.nothing));
    });

    test(
        'when --${BetterCommandRunnerFlags.verbose} and --${BetterCommandRunnerFlags.quiet} flags are provided',
        () async {
      List<String> args = [
        '--${BetterCommandRunnerFlags.verbose}',
        '--${BetterCommandRunnerFlags.quiet}',
      ];

      await fixture.runner.run(args);

      expect(log.logLevel, equals(LogLevel.debug));
    });

    test('when ${LanguageServerCommand.commandName} command is provided',
        () async {
      List<String> args = [LanguageServerCommand.commandName];

      await fixture.runner.run(args);

      expect(log.logLevel, equals(LogLevel.nothing));
    });
  });
}
