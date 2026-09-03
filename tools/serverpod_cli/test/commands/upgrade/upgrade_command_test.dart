import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/upgrade.dart';
import 'package:serverpod_cli/src/commands/upgrade/upgrade_target.dart';
import 'package:test/test.dart';

void main() {
  group('Given an UpgradeCommand,', () {
    late UpgradeCommand command;

    setUp(() {
      command = UpgradeCommand();
    });

    test('when parsing configuration without arguments, '
        'then no version is requested', () {
      final config = command.resolveConfiguration(command.argParser.parse([]));

      expect(config.errors, isEmpty);
      expect(config.optionalValue(UpgradeOption.version), isNull);
      expect(config.value(UpgradeOption.force), isFalse);
      expect(config.optionalValue(UpgradeOption.channel), isNull);
    });

    test(
      'when parsing configuration with a channel, then the channel is set',
      () {
        final config = command.resolveConfiguration(
          command.argParser.parse(['--channel', 'any']),
        );

        expect(config.errors, isEmpty);
        expect(config.optionalValue(UpgradeOption.channel), UpgradeChannel.any);
      },
    );

    test(
      'when parsing configuration with an unknown channel, then parsing fails',
      () {
        expect(
          () => command.argParser.parse(['--channel', 'nightly']),
          throwsFormatException,
        );
      },
    );

    test(
      'when parsing configuration with a version, then the version is set',
      () {
        final config = command.resolveConfiguration(
          command.argParser.parse(['--version', '4.0.0-beta.4', '--force']),
        );

        expect(config.errors, isEmpty);
        expect(
          config.optionalValue(UpgradeOption.version),
          Version.parse('4.0.0-beta.4'),
        );
        expect(config.value(UpgradeOption.force), isTrue);
      },
    );
  });
}
