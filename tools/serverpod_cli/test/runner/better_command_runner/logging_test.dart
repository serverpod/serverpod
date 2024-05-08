import 'package:args/command_runner.dart';
import 'package:serverpod_cli/src/runner/better_command_runner.dart';
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
  group('Given runner with registered command and logging monitor', () {
    var errors = <String>[];
    var infos = <String>[];
    var runner = BetterCommandRunner(
      'test',
      'this is a test cli',
      logError: (message) => errors.add(message),
      logInfo: (message) => infos.add(message),
    )..addCommand(MockCommand());
    tearDown(() {
      errors.clear();
      infos.clear();
    });

    group('when running with no command', () {
      setUp(() async => await runner.run([]));

      test('then usage message is logged to info.', () async {
        expect(infos, hasLength(1));
        expect(infos.first, runner.usage);
      });

      test('then no message is logged to error.', () async {
        expect(errors, hasLength(0));
      });
    });

    group('when running with invalid command', () {
      setUp(() async {
        try {
          await runner.run(['this it not a valid command']);
        } catch (e) {
          // Ignore the exception.
        }
      });

      test('then no message is logged to info.', () async {
        expect(infos, hasLength(0));
      });

      test('then could not find message is logged to error.', () async {
        expect(errors, hasLength(1));
        expect(errors.first, contains('Could not find'));
      });
    });

    group('when running command without mandatory option', () {
      setUp(() async {
        try {
          await runner.run([MockCommand.commandName]);
        } catch (e) {
          // Ignore the exception.
        }
      });

      test('then no message is logged to info.', () async {
        expect(infos, hasLength(0));
      });

      test('then option name is mandatory message is logged to error.',
          () async {
        expect(errors, hasLength(1));
        expect(errors.first, contains('Option name is mandatory'));
      });
    });
  });
}
