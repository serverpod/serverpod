import 'package:args/command_runner.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/analytics/analytics.dart';
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

class TestFixture {
  final MockAnalytics analytics;
  final MockCommand command;
  final ServerpodCommandRunner runner;

  TestFixture(this.analytics, this.command, this.runner);
}

TestFixture createTestRunner() {
  var analytics = MockAnalytics();
  var runner = ServerpodCommandRunner.createCommandRunner(
      analytics, false, Version(1, 1, 0));
  var command = MockCommand();
  runner.addCommand(command);
  return TestFixture(analytics, command, runner);
}

void main() {
  initializeLoggerWith(VoidLogger());
  group('Analytics Reporting - ', () {
    late TestFixture fixture;
    setUp(() {
      fixture = createTestRunner();
    });
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
      List<String> args = ['--${GlobalFlags.developmentPrint}'];

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
      expect(fixture.command.numberOfRuns, equals(1));
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
        '--${GlobalFlags.developmentPrint}',
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
      expect(fixture.command.numberOfRuns, equals(1));
    });
  });
}
