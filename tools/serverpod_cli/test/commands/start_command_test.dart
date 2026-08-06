import 'package:serverpod_cli/src/commands/start.dart';
import 'package:test/test.dart';

void main() {
  group('Given a StartCommand,', () {
    late StartCommand command;

    setUp(() {
      command = StartCommand();
    });

    test(
      'when resolving configuration with passthrough args after --, '
      'then it succeeds without errors.',
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
      'then passthrough args are in argResults.rest.',
      () {
        final argResults = command.argParser.parse(
          ['--', '--apply-migrations', '--mode', 'production'],
        );

        expect(argResults.rest, ['--apply-migrations', '--mode', 'production']);
      },
    );

    test(
      'when resolving configuration without --docker, '
      'then the docker flag is unset.',
      () {
        final config = command.resolveConfiguration(
          command.argParser.parse([]),
        );

        expect(config.optionalValue(StartOption.docker), isNull);
      },
    );

    test(
      'when resolving configuration with --docker, '
      'then the docker flag is true.',
      () {
        final config = command.resolveConfiguration(
          command.argParser.parse(['--docker']),
        );

        expect(config.optionalValue(StartOption.docker), isTrue);
      },
    );

    test(
      'when resolving configuration with --no-docker, '
      'then the docker flag is false.',
      () {
        final config = command.resolveConfiguration(
          command.argParser.parse(['--no-docker']),
        );

        expect(config.optionalValue(StartOption.docker), isFalse);
      },
    );
  });
}
