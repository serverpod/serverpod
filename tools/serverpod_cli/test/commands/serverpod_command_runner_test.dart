import 'package:cli_tools/cli_tools.dart';
import 'package:config/command.dart';
import 'package:config/config.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/create.dart';
import 'package:serverpod_cli/src/commands/language_server.dart';
import 'package:serverpod_cli/src/commands/serverpod_command.dart';
import 'package:serverpod_cli/src/commands/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/commands/version.dart';
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
    // The real logger drops messages below the active level before they reach
    // any output; mirror that here so a debug-level diagnostic does not show
    // up in assertions about what a command actually printed.
    if (logLevel.index > LogLevel.debug.index) return;
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
  void track({
    required String event,
    Map<String, dynamic> properties = const {},
  }) {
    trackedEvents.add(event);
  }

  void identify({String? email, Map<String, dynamic>? properties}) {}

  @override
  void cleanUp() {
    numberOfCleanups++;
  }

  @override
  Future<void> flush() async {}

  @override
  Future<void> sendEvent({
    required String event,
    Map<String, dynamic> properties = const {},
  }) async {}
}

class MockCommand extends ServerpodCommand<OptionDefinition> {
  static const String commandName = 'mock-command';

  MockCommand() : super(options: const []);

  @override
  final name = commandName;

  @override
  final description = 'Mock command used for testing.';

  @override
  void run(CommandContext<OptionDefinition, void> context) {}
}

class LanguageServerMockCommand extends ServerpodCommand<OptionDefinition> {
  LanguageServerMockCommand() : super(options: const []);

  @override
  final name = LanguageServerCommand.commandName;

  @override
  final description = 'Language Server Mock command used for testing.';

  @override
  void run(CommandContext<OptionDefinition, void> context) {}
}

class TestFixture {
  final MockAnalytics analytics;
  final ServerpodCommandRunner runner;
  final MockLogOutput logOutput;
  final ContextProvider provider;

  TestFixture(
    this.analytics,
    this.runner,
    this.logOutput,
    this.provider,
  );

  Future<void> run(List<String> args) {
    return runner.run(args, env: const {}, provider: provider);
  }
}

TestFixture createTestFixture(MockLogger testLogger, Version version) {
  var analytics = MockAnalytics();
  var runner = ServerpodCommandRunner.createCommandRunner(
    analytics,
    false,
    version,
    preCommandHooks: false,
  );
  runner.addCommand(MockCommand());
  runner.addCommand(LanguageServerMockCommand());
  runner.addCommand(VersionCommand(version));
  runner.addCommand(CreateCommand());
  return TestFixture(
    analytics,
    runner,
    testLogger.output.reset(),
    ContextProvider(),
  );
}

void main() {
  final version = Version(1, 1, 0);
  var testLogger = MockLogger();
  setUpAll(() {
    initializeLoggerWith(testLogger);
  });

  tearDownAll(() async {
    await closeLogger();
  });

  late TestFixture fixture;
  setUp(() {
    fixture = createTestFixture(testLogger, version);
  });
  group('Given the command runner,', () {
    test('when no log level flag is provided', () async {
      List<String> args = [];

      await fixture.run(args);

      expect(log.logLevel, equals(LogLevel.info));
    });

    test(
      'when only --${BetterCommandRunnerFlags.verbose} flag is provided',
      () async {
        List<String> args = [
          '--${BetterCommandRunnerFlags.verbose}',
        ];

        await fixture.run(args);

        expect(log.logLevel, equals(LogLevel.debug));
      },
    );
    test(
      'when only --${BetterCommandRunnerFlags.quiet} flag is provided',
      () async {
        List<String> args = [
          '--${BetterCommandRunnerFlags.quiet}',
        ];

        await fixture.run(args);

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

        await fixture.run(args);

        expect(log.logLevel, equals(LogLevel.debug));
      },
    );

    test(
      'when ${LanguageServerCommand.commandName} command is provided',
      () async {
        List<String> args = [LanguageServerCommand.commandName];

        await fixture.run(args);

        expect(log.logLevel, equals(LogLevel.nothing));
      },
    );
  });

  test(
    'Given version subcommand, when run, then prints only version',
    () async {
      await fixture.run(['version']);

      var logOutput = fixture.logOutput;
      expect(logOutput.messages, hasLength(1));
      expect(logOutput.messages.first, equals('Serverpod version: 1.1.0'));
    },
  );

  test(
    'Given --version flag, when run, then should exit early and not show help',
    () async {
      await fixture.run(['--version']);

      var logOutput = fixture.logOutput;
      expect(logOutput.messages, hasLength(1));
      expect(logOutput.messages.first, equals('Serverpod version: 1.1.0'));
    },
  );

  test(
    'Given command runner, when its commands are listed, '
    'then completion command is registered',
    () {
      expect(
        fixture.runner.subcommands.any(
          (command) => command.name == 'completion',
        ),
        isTrue,
      );
    },
  );

  group('Given the command runner,', () {
    test(
      'when no interactive flag is provided, then value should be null',
      () async {
        List<String> args = [MockCommand.commandName];

        await fixture.run(args);

        var interactiveValue = fixture.provider
            .fetch<GlobalConfiguration>()
            .optionalValue(GlobalOption.interactive);
        expect(interactiveValue, isNull);
      },
    );

    test(
      'when --interactive flag is provided, then value should be true',
      () async {
        List<String> args = [
          '--interactive',
          MockCommand.commandName,
        ];

        await fixture.run(args);

        var interactiveValue = fixture.provider
            .fetch<GlobalConfiguration>()
            .optionalValue(GlobalOption.interactive);
        expect(interactiveValue, isTrue);
      },
    );

    test(
      'when --no-interactive flag is provided, then value should be false',
      () async {
        List<String> args = [
          '--no-interactive',
          MockCommand.commandName,
        ];

        await fixture.run(args);

        var interactiveValue = fixture.provider
            .fetch<GlobalConfiguration>()
            .optionalValue(GlobalOption.interactive);
        expect(interactiveValue, isFalse);
      },
    );
  });

  group('Given the command runner,', () {
    late ServerpodCommandRunner runner;
    late ContextProvider provider;

    setUp(() {
      provider = ContextProvider();
      runner = ServerpodCommandRunner.createCommandRunner(
        MockAnalytics(),
        false,
        version,
        preCommandHooks: false,
      )..addCommand(MockCommand());
    });

    Future<void> run(List<String> args) {
      return runner.run(args, env: const {}, provider: provider);
    }

    test(
      'when run without --no-analytics, '
      'then analytics is enabled for the run',
      () async {
        await run([MockCommand.commandName]);

        expect(provider.fetch<AnalyticsEnabled>().enabled, isTrue);
      },
    );

    test(
      'when run with --no-analytics, '
      'then analytics is disabled for the run',
      () async {
        await run(['--no-analytics', MockCommand.commandName]);

        expect(provider.fetch<AnalyticsEnabled>().enabled, isFalse);
      },
    );
  });

  group('Given analytics is enabled,', () {
    test(
      'when the welcome page URL is built for the first run, '
      'then it is the welcome page with the Serverpod CLI ID',
      () {
        final url = welcomePageUrl(
          runCount: 1,
          serverpodCliId: 'cli-id',
          analyticsEnabled: true,
        );

        expect(
          url,
          Uri.parse('https://serverpod.dev/welcome?serverpod_cli_id=cli-id'),
        );
      },
    );

    test(
      'when the welcome page URL is built for the 20th run, '
      'then it is the check-in page with the Serverpod CLI ID',
      () {
        final url = welcomePageUrl(
          runCount: 20,
          serverpodCliId: 'cli-id',
          analyticsEnabled: true,
        );

        expect(
          url,
          Uri.parse('https://serverpod.dev/checkin?serverpod_cli_id=cli-id'),
        );
      },
    );

    test(
      'when the welcome page URL is built for any other run, '
      'then there is no page to open',
      () {
        final url = welcomePageUrl(
          runCount: 2,
          serverpodCliId: 'cli-id',
          analyticsEnabled: true,
        );

        expect(url, isNull);
      },
    );
  });

  group('Given analytics is disabled,', () {
    test(
      'when the welcome page URL is built for the first run, '
      'then it is the welcome page without any ID',
      () {
        final url = welcomePageUrl(
          runCount: 1,
          serverpodCliId: 'cli-id',
          analyticsEnabled: false,
        );

        expect(url, Uri.parse('https://serverpod.dev/welcome'));
      },
    );

    test(
      'when the welcome page URL is built for the 20th run, '
      'then it is the check-in page without any ID',
      () {
        final url = welcomePageUrl(
          runCount: 20,
          serverpodCliId: 'cli-id',
          analyticsEnabled: false,
        );

        expect(url, Uri.parse('https://serverpod.dev/checkin'));
      },
    );
  });

  group('Given the global --version action,', () {
    test(
      'when it is used before a subcommand, then only the version is printed',
      () async {
        await fixture.run(['--version', MockCommand.commandName]);

        expect(fixture.logOutput.messages, ['Serverpod version: 1.1.0']);
      },
    );

    test(
      'when it is used after a subcommand, then only the version is printed',
      () async {
        await fixture.run([MockCommand.commandName, '--version']);

        expect(fixture.logOutput.messages, ['Serverpod version: 1.1.0']);
      },
    );

    test(
      'when a mandatory argument is missing, then the version is still printed',
      () async {
        await fixture.run(['create', '--version']);

        expect(fixture.logOutput.messages, ['Serverpod version: 1.1.0']);
      },
    );
  });

  group('Given the run middlewares,', () {
    const featureArgs = ['--experimental-features', 'databaseSync'];
    const featureMessage = 'Enabling experimental feature: databaseSync.';

    test(
      'when a project command runs, then the feature announcement is printed',
      () async {
        await fixture.run([...featureArgs, MockCommand.commandName]);

        expect(fixture.logOutput.messages, contains(featureMessage));
        expect(fixture.provider.fetch<GlobalConfiguration>(), isNotNull);
      },
    );

    test(
      'when --help is requested, then the feature announcement is printed',
      () async {
        await fixture.run([...featureArgs, '--help']);

        expect(fixture.logOutput.messages, contains(featureMessage));
      },
    );

    test(
      'when --version is requested, then the feature announcement is skipped',
      () async {
        await fixture.run([...featureArgs, '--version']);

        expect(fixture.logOutput.messages, isNot(contains(featureMessage)));
        expect(
          fixture.logOutput.messages,
          contains('Serverpod version: 1.1.0'),
        );
      },
    );

    test(
      'when the command line is invalid, then no run middleware runs',
      () async {
        log.logLevel = LogLevel.error;

        await expectLater(
          fixture.run([...featureArgs, 'not-a-command']),
          throwsA(isA<UsageException>()),
        );

        expect(log.logLevel, LogLevel.error);
        expect(fixture.provider.maybeFetch<GlobalConfiguration>(), isNull);
        expect(fixture.logOutput.messages, isNot(contains(featureMessage)));
      },
    );

    test(
      'when an option value is completed, then the run middleware does not act',
      () async {
        await fixture.run([
          '__complete',
          '--experimental-features',
          '',
        ]);

        expect(fixture.provider.maybeFetch<GlobalConfiguration>(), isNull);
        expect(fixture.logOutput.messages, isNot(contains(featureMessage)));
      },
    );
  });
}
