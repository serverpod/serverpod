import 'package:serverpod_cli/src/commands/create.dart';
import 'package:test/test.dart';

void main() {
  group('Given a CreateCommand', () {
    late CreateCommand command;

    setUp(() {
      command = CreateCommand();
    });

    test('when parsing configuration without org, then org is null', () {
      final argResults = command.argParser.parse(['myproject']);
      final config = command.resolveConfiguration(argResults);

      expect(config.errors, isEmpty);
      expect(config.optionalValue(CreateOption.org), isNull);
    });

    test(
      'when parsing configuration with org flag, then org is parsed correctly',
      () {
        final argResults = command.argParser.parse([
          'myproject',
          '--org=com.example',
        ]);
        final config = command.resolveConfiguration(argResults);

        expect(config.errors, isEmpty);
        expect(
          config.optionalValue(CreateOption.org),
          equals('com.example'),
        );
      },
    );
  });
}
