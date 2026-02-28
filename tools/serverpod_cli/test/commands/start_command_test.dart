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
  });
}
