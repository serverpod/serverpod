import 'package:config/config.dart';
import 'package:serverpod_cli/src/commands/start.dart';
import 'package:test/test.dart';

void main() {
  group('Given a StartCommand', () {
    late StartCommand command;

    setUp(() {
      command = StartCommand();
    });

    test(
      'when checking command name, '
      'then it is "start"',
      () {
        expect(command.name, 'start');
      },
    );

    test(
      'when checking command description, '
      'then it describes code generation and server start',
      () {
        expect(command.description, contains('Generate code'));
        expect(command.description, contains('start the server'));
      },
    );

    test(
      'when checking options, '
      'then it has a watch flag',
      () {
        expect(
          StartOption.watch.option.argName,
          'watch',
        );
      },
    );

    test(
      'when checking options, '
      'then watch flag abbreviation is "w"',
      () {
        expect(
          StartOption.watch.option.argAbbrev,
          'w',
        );
      },
    );

    test(
      'when checking options, '
      'then it has a directory option',
      () {
        expect(
          StartOption.directory.option.argName,
          'directory',
        );
      },
    );

    test(
      'when checking options, '
      'then directory option abbreviation is "d"',
      () {
        expect(
          StartOption.directory.option.argAbbrev,
          'd',
        );
      },
    );

    test(
      'when checking options, '
      'then it has a docker flag',
      () {
        expect(
          StartOption.docker.option.argName,
          'docker',
        );
      },
    );

    test(
      'when checking options, '
      'then docker flag defaults to true',
      () {
        expect(
          (StartOption.docker.option as FlagOption).defaultsTo,
          isTrue,
        );
      },
    );

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
