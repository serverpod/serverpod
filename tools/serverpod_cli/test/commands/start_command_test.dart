import 'package:serverpod_cli/src/commands/start.dart';
import 'package:test/test.dart';

void main() {
  group('Given a StartCommand', () {
    late StartCommand command;

    setUp(() {
      command = StartCommand();
    });

    test(
      'when resolving configuration with passthrough args after --, '
      'then it succeeds without errors',
      () {
        final argResults = command.argParser.parse(
          ['--', '--apply-migrations'],
        );

        final config = command.resolveConfiguration(argResults);

        expect(config.errors, isEmpty);
      },
    );

    test(
      'when resolving configuration with passthrough args after --, '
      'then passthrough args are in argResults.rest',
      () {
        final argResults = command.argParser.parse(
          ['--', '--apply-migrations', '--mode', 'production'],
        );

        expect(argResults.rest, ['--apply-migrations', '--mode', 'production']);
      },
    );
  });
}
