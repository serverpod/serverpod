import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:serverpod_cli/src/runner/better_command_runner.dart';
import 'package:test/test.dart';

class MockCommand extends Command {
  void Function()? onRun;
  static String commandName = 'mock-command';
  List<String> trackedOptions = [];
  int numberOfRuns = 0;

  @override
  String get description => 'Mock command used for testing';

  @override
  void run() {
    onRun?.call();
    trackedOptions.add(argResults!['name']);
    numberOfRuns++;
  }

  @override
  String get name => commandName;

  MockCommand({this.onRun}) {
    argParser.addOption(
      'name',
      defaultsTo: 'serverpod',
      allowed: <String>['serverpod', 'stockholm'],
    );
  }
}

void main() {
  late BetterCommandRunner runner;
  late MockCommand mockCommand;
  group('Given runner with registered command', () {
    setUp(() {
      mockCommand = MockCommand();
      runner = BetterCommandRunner(
        'test',
        'this is a test cli',
      )..addCommand(mockCommand);
    });

    group('when running registered command with global flag', () {
      var args = [
        '--${BetterCommandRunnerFlags.quiet}',
        MockCommand.commandName
      ];
      setUp(() async => await runner.run(args));

      test('then command is run once', () {
        expect(mockCommand.numberOfRuns, equals(1));
      });
    });

    group('when running registered command without option', () {
      var args = [MockCommand.commandName];
      setUp(() async => await runner.run(args));

      test('then command is run once', () {
        expect(mockCommand.numberOfRuns, equals(1));
      });

      test('then default option is used in command', () {
        expect(mockCommand.trackedOptions, hasLength(1));
        expect(mockCommand.trackedOptions.first, equals('serverpod'));
      });
    });

    group('when running registered command and valid option', () {
      var args = [MockCommand.commandName, '--name', 'stockholm'];
      setUp(() async => await runner.run(args));

      test('then command is run once', () {
        expect(mockCommand.numberOfRuns, equals(1));
      });

      test('then provided option is used in command', () {
        expect(mockCommand.trackedOptions, hasLength(1));
        expect(mockCommand.trackedOptions.first, equals('stockholm'));
      });
    });

    test(
        'when running registered command with invalid option then command is never run.',
        () async {
      var args = [MockCommand.commandName, '--name', 'invalid'];

      try {
        await runner.run(args);
      } catch (_) {
        // ignore any exceptions.
      }
      expect(mockCommand.numberOfRuns, equals(0));
    });
  });

  test(
      'Given runner with registered command and onBeforeRunCommand callback then onBeforeRunCommand is called before running command',
      () async {
    List<String> calls = [];
    mockCommand = MockCommand(onRun: () => calls.add('command'));
    runner = BetterCommandRunner(
      'test',
      'this is a test cli',
      onBeforeRunCommand: (_) => Future(() => calls.add('callback')),
    )..addCommand(mockCommand);

    var args = [MockCommand.commandName];

    await runner.run(args);
    expect(calls, equals(['callback', 'command']));
  });
}
