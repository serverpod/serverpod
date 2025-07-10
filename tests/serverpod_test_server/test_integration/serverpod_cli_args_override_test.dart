import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:serverpod_test_server/src/generated/endpoints.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  group(
      'Given a ServerpodConfig with specific values and command line args that override them',
      () {
    test(
        'when runMode is set to development in config and production in CLI args '
        'then server uses production mode', () {
      final config = ServerpodConfig(
        runMode: 'development',
        serverId: 'test-server',
        role: ServerpodRole.monolith,
        loggingMode: ServerpodLoggingMode.normal,
        applyMigrations: false,
        applyRepairMigration: false,
        apiServer: ServerConfig(
          port: 8080,
          publicHost: 'localhost',
          publicPort: 8080,
          publicScheme: 'http',
        ),
        maxRequestSize: 524288,
      );

      final serverpod = Serverpod(
        ['--mode', 'production'],
        Protocol(),
        Endpoints(),
        config: config,
      );

      expect(serverpod.config.runMode, equals('production'));
    });

    test(
        'when serverId is set to config-server in config and cli-server in CLI args '
        'then server uses cli-server id', () {
      final config = ServerpodConfig(
        runMode: 'development',
        serverId: 'config-server',
        role: ServerpodRole.monolith,
        loggingMode: ServerpodLoggingMode.normal,
        applyMigrations: false,
        applyRepairMigration: false,
        apiServer: ServerConfig(
          port: 8080,
          publicHost: 'localhost',
          publicPort: 8080,
          publicScheme: 'http',
        ),
        maxRequestSize: 524288,
      );

      final serverpod = Serverpod(
        ['--server-id', 'cli-server'],
        Protocol(),
        Endpoints(),
        config: config,
      );

      expect(serverpod.config.serverId, equals('cli-server'));
    });

    test(
        'when loggingMode is set to normal in config and verbose in CLI args '
        'then server uses verbose logging', () {
      final config = ServerpodConfig(
        runMode: 'development',
        serverId: 'test-server',
        role: ServerpodRole.monolith,
        loggingMode: ServerpodLoggingMode.normal,
        applyMigrations: false,
        applyRepairMigration: false,
        apiServer: ServerConfig(
          port: 8080,
          publicHost: 'localhost',
          publicPort: 8080,
          publicScheme: 'http',
        ),
        maxRequestSize: 524288,
      );

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
    });

    test(
        'when role is set to monolith in config and maintenance in CLI args '
        'then server uses maintenance role', () {
      final config = ServerpodConfig(
        runMode: 'development',
        serverId: 'test-server',
        role: ServerpodRole.monolith,
        loggingMode: ServerpodLoggingMode.normal,
        applyMigrations: false,
        applyRepairMigration: false,
        apiServer: ServerConfig(
          port: 8080,
          publicHost: 'localhost',
          publicPort: 8080,
          publicScheme: 'http',
        ),
        maxRequestSize: 524288,
      );

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
        'then server applies migrations', () {
      final config = ServerpodConfig(
        runMode: 'development',
        serverId: 'test-server',
        role: ServerpodRole.monolith,
        loggingMode: ServerpodLoggingMode.normal,
        applyMigrations: false,
        applyRepairMigration: false,
        apiServer: ServerConfig(
          port: 8080,
          publicHost: 'localhost',
          publicPort: 8080,
          publicScheme: 'http',
        ),
        maxRequestSize: 524288,
      );

      final serverpod = Serverpod(
        ['--apply-migrations'],
        Protocol(),
        Endpoints(),
        config: config,
      );

      expect(serverpod.config.applyMigrations, isTrue);
    });

    test(
        'when applyRepairMigration is set to false in config and true in CLI args '
        'then server applies repair migration', () {
      final config = ServerpodConfig(
        runMode: 'development',
        serverId: 'test-server',
        role: ServerpodRole.monolith,
        loggingMode: ServerpodLoggingMode.normal,
        applyMigrations: false,
        applyRepairMigration: false,
        apiServer: ServerConfig(
          port: 8080,
          publicHost: 'localhost',
          publicPort: 8080,
          publicScheme: 'http',
        ),
        maxRequestSize: 524288,
      );

      final serverpod = Serverpod(
        ['--apply-repair-migration'],
        Protocol(),
        Endpoints(),
        config: config,
      );

      expect(serverpod.config.applyRepairMigration, isTrue);
    });

    test(
        'when multiple values are overridden by CLI args '
        'then server uses CLI values for overridden fields and config values for others',
        () {
      final config = ServerpodConfig(
        runMode: 'development',
        serverId: 'config-server',
        role: ServerpodRole.monolith,
        loggingMode: ServerpodLoggingMode.normal,
        applyMigrations: false,
        applyRepairMigration: false,
        apiServer: ServerConfig(
          port: 8080,
          publicHost: 'localhost',
          publicPort: 8080,
          publicScheme: 'http',
        ),
        maxRequestSize: 524288,
      );

      final serverpod = Serverpod(
        [
          '--mode',
          'production',
          '--server-id',
          'cli-server',
          '--apply-migrations'
        ],
        Protocol(),
        Endpoints(),
        config: config,
      );

      expect(serverpod.config.runMode, equals('production'));
      expect(serverpod.config.serverId, equals('cli-server'));
      expect(serverpod.config.applyMigrations, isTrue);
    });

    test(
        'when no CLI args are provided and only config is given '
        'then server uses config values except runMode which defaults to development',
        () {
      final config = ServerpodConfig(
        runMode: 'staging',
        serverId: 'config-server',
        role: ServerpodRole.serverless,
        loggingMode: ServerpodLoggingMode.verbose,
        applyMigrations: true,
        applyRepairMigration: true,
        apiServer: ServerConfig(
          port: 8080,
          publicHost: 'localhost',
          publicPort: 8080,
          publicScheme: 'http',
        ),
        maxRequestSize: 524288,
      );

      final serverpod = Serverpod(
        [],
        Protocol(),
        Endpoints(),
        config: config,
      );

      expect(serverpod.config.runMode, equals('development'));
    });

    test(
        'when invalid CLI args are provided with valid config '
        'then server uses config values', () {
      final config = ServerpodConfig(
        runMode: 'development',
        serverId: 'config-server',
        role: ServerpodRole.monolith,
        loggingMode: ServerpodLoggingMode.normal,
        applyMigrations: true,
        applyRepairMigration: false,
        apiServer: ServerConfig(
          port: 8080,
          publicHost: 'localhost',
          publicPort: 8080,
          publicScheme: 'http',
        ),
        maxRequestSize: 524288,
      );

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
  });
}
