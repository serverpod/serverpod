import 'package:serverpod_cli/src/commands/cloud.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';

void main() {
  group('Given a CloudCommand', () {
    late CloudCommand command;

    setUp(() {
      command = CloudCommand();
    });

    tearDownAll(closeLogger);

    test(
      'when parsing configuration with no args, '
      'then there are no errors',
      () {
        final argResults = command.argParser.parse([]);
        final config = command.resolveConfiguration(argResults);

        expect(config.errors, isEmpty);
      },
    );

    group('when parsing configuration with scloud args, ', () {
      late final argResults = command.argParser.parse([
        'deploy',
        '--project',
        'my-project',
      ]);

      test('then there are no errors', () {
        final config = command.resolveConfiguration(argResults);

        expect(config.errors, isEmpty);
      });

      test('then args are forwarded via argResults.rest', () {
        expect(argResults.rest, ['deploy', '--project', 'my-project']);
      });
    });
  });
}
