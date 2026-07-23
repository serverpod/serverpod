import 'package:serverpod_cli/src/commands/upgrade.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';

void main() {
  group('Given an UpgradeCommand', () {
    late UpgradeCommand command;

    setUp(() {
      command = UpgradeCommand();
    });

    tearDownAll(closeLogger);

    test('then command name is upgrade', () {
      expect(command.name, equals('upgrade'));
    });

    test('then command has update alias', () {
      expect(command.aliases, contains('update'));
    });

    test('when parsing configuration with no args, then there are no errors', () {
      final argResults = command.argParser.parse([]);
      final config = command.resolveConfiguration(argResults);

      expect(config.errors, isEmpty);
      expect(config.value(UpgradeOption.check), isFalse);
    });

    test('when parsing configuration with --check, then check is true', () {
      final argResults = command.argParser.parse(['--check']);
      final config = command.resolveConfiguration(argResults);

      expect(config.errors, isEmpty);
      expect(config.value(UpgradeOption.check), isTrue);
    });

    test('when parsing configuration with -c, then check is true', () {
      final argResults = command.argParser.parse(['-c']);
      final config = command.resolveConfiguration(argResults);

      expect(config.errors, isEmpty);
      expect(config.value(UpgradeOption.check), isTrue);
    });
  });
}
