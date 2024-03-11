import 'package:args/command_runner.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/analytics/analytics.dart';
import 'package:serverpod_cli/src/commands/language_server.dart';
import 'package:serverpod_cli/src/logger/logger.dart';
import 'package:serverpod_cli/src/logger/loggers/void_logger.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:serverpod_cli/src/util/exit_exception.dart';
import 'package:test/test.dart';

class MockAnalytics extends Analytics {
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
  static String commandName = 'mock-command';
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
    onPreCommandEnvironmentCheck: () => Future(() => {}),
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
  group('Analytics Reporting - ', () {
    test('when no arguments are provided', () async {
      List<String> args = [];

      await fixture.runner.run(args);

      expect(fixture.analytics.trackedEvents.length, equals(1));
      expect(fixture.analytics.trackedEvents.first, equals('help'));
    });

    test('when invalid command is provided', () async {
      List<String> args = ['this could be a command argument'];

      await expectLater(
        () => fixture.runner.run(args),
        throwsA(const TypeMatcher<ExitException>()),
      );

      expect(fixture.analytics.trackedEvents.length, equals(1));
      expect(fixture.analytics.trackedEvents.first, equals('invalid'));
    });

    test('when only valid flag is provided', () async {
      List<String> args = ['--${GlobalFlags.verbose}'];

      await fixture.runner.run(args);

      expect(fixture.analytics.trackedEvents.length, equals(1));
      expect(fixture.analytics.trackedEvents.first, equals('help'));
    });

    test('when unknown command is provided', () async {
      List<String> args = ['--unknown-command'];

      await expectLater(
        () => fixture.runner.run(args),
        throwsA(const TypeMatcher<ExitException>()),
      );

      expect(fixture.analytics.trackedEvents.length, equals(1));
      expect(fixture.analytics.trackedEvents.first, equals('invalid'));
    });

    test('when valid command and option is provided', () async {
      List<String> args = [MockCommand.commandName, '--name', 'isak'];

      await fixture.runner.run(args);

      expect(fixture.analytics.trackedEvents.length, equals(1));
      expect(
        fixture.analytics.trackedEvents.first,
        equals(MockCommand.commandName),
      );
      expect(fixture.mockCommand.numberOfRuns, equals(1));
    });

    test('when valid command but invalid option is provided', () async {
      List<String> args = [MockCommand.commandName, '--name', 'steve'];

      await expectLater(
        () => fixture.runner.run(args),
        throwsA(const TypeMatcher<ExitException>()),
      );

      expect(fixture.analytics.trackedEvents.length, equals(1));
      expect(fixture.analytics.trackedEvents.first, equals('invalid'));
    });

    test('when valid command and global flag is provided', () async {
      List<String> args = [
        '--${GlobalFlags.verbose}',
        MockCommand.commandName,
        '--name',
        'alex'
      ];

      await fixture.runner.run(args);

      expect(fixture.analytics.trackedEvents.length, equals(1));
      expect(
        fixture.analytics.trackedEvents.first,
        equals(MockCommand.commandName),
      );
      expect(fixture.mockCommand.numberOfRuns, equals(1));
    });

    test('when analytics flag is omitted', () async {
      List<String> args = [MockCommand.commandName, '--name', 'alex'];

      await fixture.runner.run(args);

      expect(fixture.mockCommand.numberOfRuns, equals(1));
      expect(fixture.analytics.enabled, isTrue);
    });

    test('when analytics flag is provided', () async {
      List<String> args = [
        '--${GlobalFlags.analytics}',
        MockCommand.commandName,
        '--name',
        'alex',
      ];

      await fixture.runner.run(args);

      expect(fixture.mockCommand.numberOfRuns, equals(1));
      expect(fixture.analytics.enabled, isTrue);
    });

    test('when no-analytics flag is provided', () async {
      List<String> args = [
        '--no-${GlobalFlags.analytics}',
        MockCommand.commandName,
        '--name',
        'alex',
      ];

      await fixture.runner.run(args);

      expect(fixture.mockCommand.numberOfRuns, equals(1));
      expect(fixture.analytics.enabled, isFalse);
    });
  });
  group('Logger Initialization - ', () {
    test('when no log level flag is provided', () async {
      List<String> args = [];

      await fixture.runner.run(args);

      expect(log.logLevel, equals(LogLevel.info));
    });

    test('when only --${GlobalFlags.verbose} flag is provided', () async {
      List<String> args = [
        '--${GlobalFlags.verbose}',
      ];

      await fixture.runner.run(args);

      expect(log.logLevel, equals(LogLevel.debug));
    });
    test('when only --${GlobalFlags.quiet} flag is provided', () async {
      List<String> args = [
        '--${GlobalFlags.quiet}',
      ];

      await fixture.runner.run(args);

      expect(log.logLevel, equals(LogLevel.nothing));
    });

    test(
        'when --${GlobalFlags.verbose} and --${GlobalFlags.quiet} flags are provided',
        () async {
      List<String> args = [
        '--${GlobalFlags.verbose}',
        '--${GlobalFlags.quiet}',
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
