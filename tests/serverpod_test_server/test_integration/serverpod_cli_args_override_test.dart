import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:serverpod_test_server/src/generated/endpoints.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'utils/serverpod_config_builder.dart';

void main() {
  group(
    'Given a ServerpodConfig with specific values and command line args that override them',
    () {
      test(
        'when runMode is set to development in config and production in CLI args '
        'then server uses production mode',
        () {
          final config = ServerpodConfigBuilder()
              .withRunMode('development')
              .build();

          final serverpod = Serverpod(
            ['--mode', 'production'],
            Protocol(),
            Endpoints(),
            config: config,
          );

          expect(serverpod.config.runMode, equals('production'));
        },
      );

      test(
        'when serverId is set to config-server in config and cli-server in CLI args '
        'then server uses cli-server id',
        () {
          final config = ServerpodConfigBuilder()
              .withServerId('config-server')
              .build();

          final serverpod = Serverpod(
            ['--server-id', 'cli-server'],
            Protocol(),
            Endpoints(),
            config: config,
          );

          expect(serverpod.config.serverId, equals('cli-server'));
        },
      );

      test(
        'when loggingMode is set to normal in config and verbose in CLI args '
        'then server uses verbose logging',
        () {
          final config = ServerpodConfigBuilder()
              .withLoggingMode(ServerpodLoggingMode.normal)
              .build();

          final serverpod = Serverpod(
            ['--logging', 'verbose'],
            Protocol(),
            Endpoints(),
            config: config,
          );

          expect(
            serverpod.config.loggingMode,
            equals(ServerpodLoggingMode.verbose),
          );
        },
      );

      test('when role is set to monolith in config and maintenance in CLI args '
          'then server uses maintenance role', () {
        final config = ServerpodConfigBuilder()
            .withRole(ServerpodRole.monolith)
            .build();

        final serverpod = Serverpod(
          ['--role', 'maintenance'],
          Protocol(),
          Endpoints(),
          config: config,
        );

        expect(serverpod.config.role, equals(ServerpodRole.maintenance));
      });

      test(
        'when applyMigrations is set to false in config and true in CLI args '
        'then server applies migrations',
        () {
          final config = ServerpodConfigBuilder()
              .withApplyMigrations(false)
              .build();

          final serverpod = Serverpod(
            ['--apply-migrations'],
            Protocol(),
            Endpoints(),
            config: config,
          );

          expect(serverpod.config.applyMigrations, isTrue);
        },
      );

      test(
        'when applyRepairMigration is set to false in config and true in CLI args '
        'then server applies repair migration',
        () {
          final config = ServerpodConfigBuilder()
              .withApplyRepairMigration(false)
              .build();

          final serverpod = Serverpod(
            ['--apply-repair-migration'],
            Protocol(),
            Endpoints(),
            config: config,
          );

          expect(serverpod.config.applyRepairMigration, isTrue);
        },
      );

      test(
        'when multiple values are overridden by CLI args '
        'then server uses CLI values for overridden fields and config values for others',
        () {
          final config = ServerpodConfigBuilder()
              .withRunMode('development')
              .withServerId('config-server')
              .withRole(ServerpodRole.monolith)
              .withLoggingMode(ServerpodLoggingMode.normal)
              .withApplyMigrations(false)
              .withApplyRepairMigration(false)
              .build();

          final serverpod = Serverpod(
            [
              '--mode',
              'production',
              '--server-id',
              'cli-server',
              '--apply-migrations',
            ],
            Protocol(),
            Endpoints(),
            config: config,
          );

          expect(serverpod.config.runMode, equals('production'));
          expect(serverpod.config.serverId, equals('cli-server'));
          expect(serverpod.config.applyMigrations, isTrue);
        },
      );

      test(
        'when runMode is set to staging in config and no CLI args are provided '
        'then server uses staging mode',
        () {
          final config = ServerpodConfigBuilder()
              .withRunMode('staging')
              .withServerId('config-server')
              .withRole(ServerpodRole.serverless)
              .withLoggingMode(ServerpodLoggingMode.verbose)
              .withApplyMigrations(true)
              .withApplyRepairMigration(true)
              .build();

          final serverpod = Serverpod(
            [],
            Protocol(),
            Endpoints(),
            config: config,
          );

          expect(serverpod.config.runMode, equals('staging'));
        },
      );

      test('when invalid CLI args are provided with valid config '
          'then server uses config values', () {
        final config = ServerpodConfigBuilder()
            .withRunMode('development')
            .withServerId('config-server')
            .withRole(ServerpodRole.monolith)
            .withLoggingMode(ServerpodLoggingMode.normal)
            .withApplyMigrations(true)
            .withApplyRepairMigration(false)
            .build();

        final serverpod = Serverpod(
          ['--invalid-option', 'value', '--another-invalid'],
          Protocol(),
          Endpoints(),
          config: config,
        );

        expect(serverpod.config.runMode, equals('development'));
        expect(serverpod.config.serverId, equals('config-server'));
        expect(serverpod.config.applyMigrations, isTrue);
      });
    },
  );

  test('Given no config, no CLI args, and no env variable are provided '
      'then server defaults to development mode', () {
    final serverpod = Serverpod(
      [],
      Protocol(),
      Endpoints(),
    );

    expect(serverpod.config.runMode, equals('development'));
  });
}
