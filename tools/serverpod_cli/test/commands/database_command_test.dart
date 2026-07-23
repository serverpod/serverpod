import 'package:serverpod_cli/src/commands/database.dart';
import 'package:test/test.dart';

void main() {
  group('Given a DatabaseCommand,', () {
    late DatabaseCommand command;
    late DatabaseStartCommand startCommand;

    setUp(() {
      command = DatabaseCommand();
      startCommand = command.subcommands['start']! as DatabaseStartCommand;
    });

    test(
      'when reading its subcommands, '
      'then the start command is available.',
      () {
        expect(command.subcommands, contains('start'));
      },
    );

    test(
      'when parsing the start command without options, '
      'then development mode is selected and discovery overrides are unset.',
      () {
        var argResults = startCommand.argParser.parse([]);
        var config = startCommand.resolveConfiguration(argResults);

        expect(config.errors, isEmpty);
        expect(config.optionalValue(DatabaseStartOption.serverDir), isNull);
        expect(config.value(DatabaseStartOption.mode), 'development');
        expect(config.optionalValue(DatabaseStartOption.port), isNull);
      },
    );

    test(
      'when parsing start command overrides, '
      'then the selected directory, mode, and port are used.',
      () {
        var argResults = startCommand.argParser.parse([
          '--server-dir',
          'example_server',
          '--mode',
          'test',
          '--port',
          '55432',
        ]);
        var config = startCommand.resolveConfiguration(argResults);

        expect(config.errors, isEmpty);
        expect(
          config.optionalValue(DatabaseStartOption.serverDir),
          'example_server',
        );
        expect(config.value(DatabaseStartOption.mode), 'test');
        expect(config.optionalValue(DatabaseStartOption.port), 55432);
      },
    );

    test(
      'when parsing the -s shorthand, '
      'then the server directory is selected.',
      () {
        var argResults = startCommand.argParser.parse([
          '-s',
          'example_server',
        ]);
        var config = startCommand.resolveConfiguration(argResults);

        expect(config.errors, isEmpty);
        expect(
          config.optionalValue(DatabaseStartOption.serverDir),
          'example_server',
        );
      },
    );
  });
}
