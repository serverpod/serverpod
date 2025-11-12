import 'package:args/command_runner.dart';
import 'package:cli_tools/cli_tools.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/language_server.dart';
import 'package:serverpod_cli/src/commands/version.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';

class MockLogOutput {
  List<String> messages = [];

  void info(String message) {
    messages.add(message);
  }

  void error(String message) {
    messages.add(message);
  }

  void debug(String message) {
    messages.add(message);
  }

  void warning(String message) {
    messages.add(message);
  }

  MockLogOutput reset() {
    messages.clear();
    return this;
  }
}

class MockLogger extends VoidLogger {
  final MockLogOutput output = MockLogOutput();

  MockLogger();

  @override
  void info(String message, {bool newParagraph = false, LogType? type}) {
    output.info(message);
  }

  @override
  void error(
    String message, {
    bool newParagraph = false,
    LogType? type,
    Object? exception,
    StackTrace? stackTrace,
  }) {
    output.error(message);
  }

  @override
  void debug(String message, {bool newParagraph = false, LogType? type}) {
    output.debug(message);
  }

  @override
  void warning(String message, {bool newParagraph = false, LogType? type}) {
    output.warning(message);
  }
}

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

class MockVersionCommand extends Command {
  int numberOfRuns = 0;

  @override
  final name = 'version';

  @override
  final description = 'Mock version command used for testing.';

  @override
  void run() {
    numberOfRuns++;
  }
}

class TestFixture {
  final MockAnalytics analytics;
  final MockCommand mockCommand;
  final ServerpodCommandRunner runner;
  final MockLogOutput logOutput;

  TestFixture(
    this.analytics,
    this.mockCommand,
    this.runner,
    this.logOutput,
  );
}

TestFixture createTestFixture(MockLogger testLogger, Version version) {
  var analytics = MockAnalytics();
  var runner = ServerpodCommandRunner.createCommandRunner(
    analytics,
    false,
    version,
    onBeforeRunCommand: (_) => Future(() => {}),
  );
  var mockCommand = MockCommand();
  runner.addCommand(mockCommand);
  runner.addCommand(LanguageServerMockCommand());
  runner.addCommand(VersionCommand(version));
  return TestFixture(analytics, mockCommand, runner, testLogger.output.reset());
}

void main() {
  final version = Version(1, 1, 0);
  var testLogger = MockLogger();
  initializeLoggerWith(testLogger);

  late TestFixture fixture;
  setUp(() {
    fixture = createTestFixture(testLogger, version);
  });
  group('Logger Initialization - ', () {
    test('when no log level flag is provided', () async {
      List<String> args = [];

      await fixture.runner.run(args);

      expect(log.logLevel, equals(LogLevel.info));
    });

    test(
      'when only --${BetterCommandRunnerFlags.verbose} flag is provided',
      () async {
        List<String> args = [
          '--${BetterCommandRunnerFlags.verbose}',
        ];

        await fixture.runner.run(args);

        expect(log.logLevel, equals(LogLevel.debug));
      },
    );
    test(
      'when only --${BetterCommandRunnerFlags.quiet} flag is provided',
      () async {
        List<String> args = [
          '--${BetterCommandRunnerFlags.quiet}',
        ];

        await fixture.runner.run(args);

        expect(log.logLevel, equals(LogLevel.nothing));
      },
    );

    test(
      'when --${BetterCommandRunnerFlags.verbose} and --${BetterCommandRunnerFlags.quiet} flags are provided',
      () async {
        List<String> args = [
          '--${BetterCommandRunnerFlags.verbose}',
          '--${BetterCommandRunnerFlags.quiet}',
        ];

        await fixture.runner.run(args);

        expect(log.logLevel, equals(LogLevel.debug));
      },
    );

    test(
      'when ${LanguageServerCommand.commandName} command is provided',
      () async {
        List<String> args = [LanguageServerCommand.commandName];

        await fixture.runner.run(args);

        expect(log.logLevel, equals(LogLevel.nothing));
      },
    );
  });

  test('Given version subcommand when run then prints only version', () async {
    await fixture.runner.run(['version']);

    var logOutput = fixture.logOutput;
    expect(logOutput.messages, hasLength(1));
    expect(logOutput.messages.first, equals('Serverpod version: 1.1.0'));
  });

  test(
    'Given --version flag when run then should exit early and not show help',
    () async {
      await fixture.runner.run(['--version']);

      var logOutput = fixture.logOutput;
      expect(logOutput.messages, hasLength(1));
      expect(logOutput.messages.first, equals('Serverpod version: 1.1.0'));
    },
  );
}
