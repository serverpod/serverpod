import 'package:serverpod_cli/src/commands/mcp.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:test/test.dart';

import '../test_util/resolve_command_config.dart';

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
        final config = resolveCommandConfig(command.options, []);

        expect(config.errors, isEmpty);
      },
    );

    test(
      'when parsing configuration with no --server-dir, '
      'then server-dir is null',
      () {
        final config = resolveCommandConfig(command.options, []);

        expect(config.optionalValue(McpOption.serverDir), isNull);
      },
    );

    test(
      'when parsing configuration with --server-dir=path, '
      'then server-dir is the path',
      () {
        final config = resolveCommandConfig(command.options, [
          '--server-dir=packages/my_server',
        ]);

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
        final config = resolveCommandConfig(command.options, [
          '-s',
          'packages/my_server',
        ]);

        expect(config.errors, isEmpty);
        expect(
          config.optionalValue(McpOption.serverDir),
          equals('packages/my_server'),
        );
      },
    );
  });
}
