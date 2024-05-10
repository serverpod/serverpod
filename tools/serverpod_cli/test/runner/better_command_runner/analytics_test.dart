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

  MockCommand() {
    argParser.addOption(
      'name',
      defaultsTo: 'serverpod',
      allowed: <String>['serverpod'],
    );
  }
}

void main() {
  late BetterCommandRunner runner;
  group('Given runner with null onAnalyticsEvent callback', () {
    var runner = BetterCommandRunner(
      'test',
      'this is a test cli',
      onAnalyticsEvent: null,
    );

    test('when checking if analytics is enabled then false is returned.', () {
      expect(runner.analyticsEnabled(), isFalse);
    });

    test('when checking available flags then analytics flag is not present.',
        () {
      expect(runner.argParser.options.keys, isNot(contains('analytics')));
    });
  });

  group('Given runner with onAnalyticsEvent callback defined', () {
    var runner = BetterCommandRunner(
      'test',
      'this is a test cli',
      onAnalyticsEvent: (event) {},
    );

    test('when checking if analytics is enabled then true is returned.', () {
      expect(runner.analyticsEnabled(), isTrue);
    });

    test('when checking available flags then analytics is defined.', () {
      expect(runner.argParser.options.keys, contains('analytics'));
    });
  });

  group('Given runner with analytics enabled', () {
    List<String> events = [];
    setUp(() {
      runner = BetterCommandRunner(
        'test',
        'this is a test cli',
        onAnalyticsEvent: (event) => events.add(event),
      );
      assert(runner.analyticsEnabled());
    });

    tearDown(() {
      events = [];
    });

    test(
        'when running command with no-analytics flag then analytics is disabled.',
        () async {
      var args = ['--no-${BetterCommandRunnerFlags.analytics}'];
      await runner.run(args);

      expect(runner.analyticsEnabled(), isFalse);
    });

    test('when running invalid command then "invalid" analytics event is sent.',
        () async {
      var args = ['this could be a command argument'];

      try {
        await runner.run(args);
      } catch (_) {
        // Ignore any exception
      }

      expect(events, hasLength(1));
      expect(events.first, equals('invalid'));
    });

    test(
        'when running with unknown command then "invalid" analytics event is sent.',
        () async {
      var args = ['--unknown-command'];

      try {
        await runner.run(args);
      } catch (_) {
        // Ignore any exception
      }

      expect(events, hasLength(1));
      expect(events.first, equals('invalid'));
    });

    test('when running with no command then "help" analytics event is sent.',
        () async {
      await runner.run([]);

      expect(events, hasLength(1));
      expect(events.first, equals('help'));
    });

    test(
        'when running with only registered flag then "help" analytics event is sent.',
        () async {
      await runner.run(['--${BetterCommandRunnerFlags.analytics}']);

      expect(events, hasLength(1));
      expect(events.first, equals('help'));
    });
  });

  group('Given runner with registered command and analytics enabled', () {
    List<String> events = [];
    setUp(() {
      runner = BetterCommandRunner(
        'test',
        'this is a test cli',
        onAnalyticsEvent: (event) => events.add(event),
      )..addCommand(MockCommand());
      assert(runner.analyticsEnabled());
    });

    tearDown(() {
      events = [];
    });

    test('when running with registered command then command name is sent,',
        () async {
      var args = [MockCommand.commandName];

      await runner.run(args);

      expect(events, hasLength(1));
      expect(events.first, equals(MockCommand.commandName));
    });

    test(
        'when running with registered command and option then command name is sent,',
        () async {
      var args = [MockCommand.commandName, '--name', 'serverpod'];

      await runner.run(args);

      expect(events, hasLength(1));
      expect(events.first, equals(MockCommand.commandName));
    });

    test(
        'when running with registered command but invalid option then "invalid" analytics event is sent,',
        () async {
      var args = [MockCommand.commandName, '--name', 'invalid'];

      try {
        await runner.run(args);
      } catch (_) {
        // Ignore any exception
      }

      expect(events, hasLength(1));
      expect(events.first, equals('invalid'));
    });
  });
}
