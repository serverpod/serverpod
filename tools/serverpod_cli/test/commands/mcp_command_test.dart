import 'package:serverpod_cli/src/commands/mcp.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';

void main() {
  group('Given an McpCommand', () {
    late McpCommand command;

    setUp(() {
      command = McpCommand();
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

    test(
      'when parsing configuration with no --server-dir, '
      'then server-dir is null',
      () {
        final argResults = command.argParser.parse([]);
        final config = command.resolveConfiguration(argResults);

        expect(config.optionalValue(McpOption.serverDir), isNull);
      },
    );

    test(
      'when parsing configuration with --server-dir=path, '
      'then server-dir is the path',
      () {
        final argResults = command.argParser.parse([
          '--server-dir=packages/my_server',
        ]);
        final config = command.resolveConfiguration(argResults);

        expect(config.errors, isEmpty);
        expect(
          config.optionalValue(McpOption.serverDir),
          equals('packages/my_server'),
        );
      },
    );

    test(
      'when parsing configuration with -s path, '
      'then server-dir is the path',
      () {
        final argResults = command.argParser.parse([
          '-s',
          'packages/my_server',
        ]);
        final config = command.resolveConfiguration(argResults);

        expect(config.errors, isEmpty);
        expect(
          config.optionalValue(McpOption.serverDir),
          equals('packages/my_server'),
        );
      },
    );
  });
}
