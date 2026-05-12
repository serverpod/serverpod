import 'package:cli_tools/cli_tools.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/quickstart.dart';
import 'package:serverpod_cli/src/runner/serverpod_command_runner.dart';
import 'package:test/test.dart';

void main() {
  group('Given a QuickstartCommand', () {
    late QuickstartCommand command;

    setUp(() {
      command = QuickstartCommand();
    });

    test(
      'when parsing configuration with valid name, then there are no errors',
      () {
        final argResults = command.argParser.parse(['myproject']);
        final config = command.resolveConfiguration(argResults);

        expect(config.errors, isEmpty);
        expect(config.value(QuickstartOption.name), equals('myproject'));
      },
    );

    test('when parsing configuration then default template is server', () {
      final argResults = command.argParser.parse(['myproject']);
      final config = command.resolveConfiguration(argResults);

      expect(config.value(QuickstartOption.template).name, equals('server'));
    });

    test('when parsing configuration then default force is false', () {
      final argResults = command.argParser.parse(['myproject']);
      final config = command.resolveConfiguration(argResults);

      expect(config.value(QuickstartOption.force), isFalse);
    });

    test('when parsing configuration with force flag, then force is true', () {
      final argResults = command.argParser.parse(['myproject', '--force']);
      final config = command.resolveConfiguration(argResults);

      expect(config.errors, isEmpty);
      expect(config.value(QuickstartOption.force), isTrue);
    });

    test(
      'when parsing configuration with -f flag, then force is true',
      () {
        final argResults = command.argParser.parse(['myproject', '-f']);
        final config = command.resolveConfiguration(argResults);

        expect(config.errors, isEmpty);
        expect(config.value(QuickstartOption.force), isTrue);
      },
    );

    test(
      'when parsing configuration with server template, '
      'then template is server',
      () {
        final argResults = command.argParser.parse([
          'myproject',
          '--template=server',
        ]);
        final config = command.resolveConfiguration(argResults);

        expect(config.errors, isEmpty);
        expect(config.value(QuickstartOption.template).name, equals('server'));
      },
    );

    test(
      'when parsing configuration with module template, '
      'then template is module',
      () {
        final argResults = command.argParser.parse([
          'myproject',
          '--template=module',
        ]);
        final config = command.resolveConfiguration(argResults);

        expect(config.errors, isEmpty);
        expect(config.value(QuickstartOption.template).name, equals('module'));
      },
    );

    test(
      'when parsing configuration with -t module, '
      'then template is module',
      () {
        final argResults = command.argParser.parse([
          'myproject',
          '-t',
          'module',
        ]);
        final config = command.resolveConfiguration(argResults);

        expect(config.errors, isEmpty);
        expect(config.value(QuickstartOption.template).name, equals('module'));
      },
    );

    test(
      'when parsing configuration with name flag, '
      'then name is parsed correctly',
      () {
        final argResults = command.argParser.parse(['--name=myproject']);
        final config = command.resolveConfiguration(argResults);

        expect(config.errors, isEmpty);
        expect(config.value(QuickstartOption.name), equals('myproject'));
      },
    );

    test(
      'when parsing configuration with -n flag, '
      'then name is parsed correctly',
      () {
        final argResults = command.argParser.parse(['-n', 'myproject']);
        final config = command.resolveConfiguration(argResults);

        expect(config.errors, isEmpty);
        expect(config.value(QuickstartOption.name), equals('myproject'));
      },
    );

    test(
      'when parsing configuration without name, '
      'then it fails with missing required option error',
      () {
        final argResults = command.argParser.parse([]);
        final config = command.resolveConfiguration(argResults);

        expect(
          config.errors,
          anyElement(contains('option `name` is mandatory')),
        );
      },
    );

    test(
      'when resolving configuration with all options, '
      'then all values are parsed correctly',
      () {
        final argResults = command.argParser.parse([
          'myproject',
          '--force',
          '--template=module',
        ]);
        final config = command.resolveConfiguration(argResults);

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
        final runner = ServerpodCommandRunner(
          'serverpod',
          'Manage your serverpod app development',
          productionMode: false,
          cliVersion: Version(1, 1, 0),
        );

        runner.addCommand(command);

        await expectLater(
          runner.run(['quickstart', 'create']),
          throwsA(isA<ExitException>()),
        );
      },
    );
  });
}
