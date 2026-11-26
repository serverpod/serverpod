import 'package:cli_tools/cli_tools.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/quickstart.dart';
import 'package:serverpod_cli/src/commands/serverpod_command_runner.dart';
import 'package:test/test.dart';

import '../test_util/resolve_command_config.dart';

void main() {
  group('Given a QuickstartCommand', () {
    late QuickstartCommand command;

    setUp(() {
      command = QuickstartCommand();
    });

    test(
      'when parsing configuration with valid name, then there are no errors',
      () {
        final config = resolveCommandConfig(command.options, ['myproject']);

        expect(config.errors, isEmpty);
        expect(config.value(QuickstartOption.name), equals('myproject'));
      },
    );

    test('when parsing configuration then default template is fullstack', () {
      final config = resolveCommandConfig(command.options, ['myproject']);

      expect(config.value(QuickstartOption.template).name, equals('fullstack'));
    });

    test('when parsing configuration then default force is false', () {
      final config = resolveCommandConfig(command.options, ['myproject']);

      expect(config.value(QuickstartOption.force), isFalse);
    });

    test('when parsing configuration with force flag, then force is true', () {
      final config = resolveCommandConfig(command.options, [
        'myproject',
        '--force',
      ]);

      expect(config.errors, isEmpty);
      expect(config.value(QuickstartOption.force), isTrue);
    });

    test(
      'when parsing configuration with -f flag, then force is true',
      () {
        final config = resolveCommandConfig(command.options, [
          'myproject',
          '-f',
        ]);

        expect(config.errors, isEmpty);
        expect(config.value(QuickstartOption.force), isTrue);
      },
    );

    test(
      'when parsing configuration with server template, '
      'then template is server',
      () {
        final config = resolveCommandConfig(command.options, [
          'myproject',
          '--template=server',
        ]);

        expect(config.errors, isEmpty);
        expect(config.value(QuickstartOption.template).name, equals('server'));
      },
    );

    test(
      'when parsing configuration with module template, '
      'then template is module',
      () {
        final config = resolveCommandConfig(command.options, [
          'myproject',
          '--template=module',
        ]);

        expect(config.errors, isEmpty);
        expect(config.value(QuickstartOption.template).name, equals('module'));
      },
    );

    test(
      'when parsing configuration with -t module, '
      'then template is module',
      () {
        final config = resolveCommandConfig(command.options, [
          'myproject',
          '-t',
          'module',
        ]);

        expect(config.errors, isEmpty);
        expect(config.value(QuickstartOption.template).name, equals('module'));
      },
    );

    test(
      'when parsing configuration with name flag, '
      'then name is parsed correctly',
      () {
        final config = resolveCommandConfig(command.options, [
          '--name=myproject',
        ]);

        expect(config.errors, isEmpty);
        expect(config.value(QuickstartOption.name), equals('myproject'));
      },
    );

    test(
      'when parsing configuration with -n flag, '
      'then name is parsed correctly',
      () {
        final config = resolveCommandConfig(command.options, [
          '-n',
          'myproject',
        ]);

        expect(config.errors, isEmpty);
        expect(config.value(QuickstartOption.name), equals('myproject'));
      },
    );

    test(
      'when parsing configuration without name, '
      'then it fails with missing required option error',
      () {
        final config = resolveCommandConfig(command.options, []);

        expect(
          config.errors,
          anyElement(contains('option "--name" is mandatory')),
        );
      },
    );

    test(
      'when resolving configuration with all options, '
      'then all values are parsed correctly',
      () {
        final config = resolveCommandConfig(command.options, [
          'myproject',
          '--force',
          '--template=module',
        ]);

        expect(config.errors, isEmpty);
        expect(config.value(QuickstartOption.name), equals('myproject'));
        expect(config.value(QuickstartOption.force), isTrue);
        expect(config.value(QuickstartOption.template).name, equals('module'));
      },
    );

    test(
      'when running with restricted name and without force,'
      'then an ExitException is thrown',
      () async {
        final runner = ServerpodCommandRunner.createCommandRunner(
          CompoundAnalytics([]),
          false,
          Version(1, 1, 0),
          preCommandHooks: false,
        )..addCommand(command);

        await expectLater(
          runner.run(['quickstart', 'create'], env: const {}),
          throwsA(isA<ExitException>()),
        );
      },
    );
  });
}
