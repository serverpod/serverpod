import 'package:serverpod/serverpod.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:serverpod_test_server/src/generated/endpoints.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  // These tests verify that command line arguments correctly override
  // ServerpodConfig values when both are provided to the Serverpod constructor.
  // Note: runMode has special handling where it's calculated from CLI args first,
  // then environment variables, then defaults to 'development'.
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
      // Other values should remain from config
      expect(serverpod.config.serverId, equals('test-server'));
      expect(serverpod.config.role, equals(ServerpodRole.monolith));
      expect(serverpod.config.loggingMode, equals(ServerpodLoggingMode.normal));
      expect(serverpod.config.applyMigrations, isFalse);
      expect(serverpod.config.applyRepairMigration, isFalse);
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
      // Other values should remain from config
      expect(serverpod.config.runMode, equals('development'));
      expect(serverpod.config.role, equals(ServerpodRole.monolith));
      expect(serverpod.config.loggingMode, equals(ServerpodLoggingMode.normal));
      expect(serverpod.config.applyMigrations, isFalse);
      expect(serverpod.config.applyRepairMigration, isFalse);
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
          serverpod.config.loggingMode, equals(ServerpodLoggingMode.verbose));
      // Other values should remain from config
      expect(serverpod.config.runMode, equals('development'));
      expect(serverpod.config.serverId, equals('test-server'));
      expect(serverpod.config.role, equals(ServerpodRole.monolith));
      expect(serverpod.config.applyMigrations, isFalse);
      expect(serverpod.config.applyRepairMigration, isFalse);
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
      // Other values should remain from config
      expect(serverpod.config.runMode, equals('development'));
      expect(serverpod.config.serverId, equals('test-server'));
      expect(serverpod.config.loggingMode, equals(ServerpodLoggingMode.normal));
      expect(serverpod.config.applyMigrations, isFalse);
      expect(serverpod.config.applyRepairMigration, isFalse);
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
      // Other values should remain from config
      expect(serverpod.config.runMode, equals('development'));
      expect(serverpod.config.serverId, equals('test-server'));
      expect(serverpod.config.role, equals(ServerpodRole.monolith));
      expect(serverpod.config.loggingMode, equals(ServerpodLoggingMode.normal));
      expect(serverpod.config.applyRepairMigration, isFalse);
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
      // Other values should remain from config
      expect(serverpod.config.runMode, equals('development'));
      expect(serverpod.config.serverId, equals('test-server'));
      expect(serverpod.config.role, equals(ServerpodRole.monolith));
      expect(serverpod.config.loggingMode, equals(ServerpodLoggingMode.normal));
      expect(serverpod.config.applyMigrations, isFalse);
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

      // CLI overridden values
      expect(serverpod.config.runMode, equals('production'));
      expect(serverpod.config.serverId, equals('cli-server'));
      expect(serverpod.config.applyMigrations, isTrue);
      // Config values (not overridden)
      expect(serverpod.config.role, equals(ServerpodRole.monolith));
      expect(serverpod.config.loggingMode, equals(ServerpodLoggingMode.normal));
      expect(serverpod.config.applyRepairMigration, isFalse);
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

      // runMode defaults to 'development' when no CLI args or env vars are set
      expect(serverpod.config.runMode, equals('development'));
      // Other values should come from config
      expect(serverpod.config.serverId, equals('config-server'));
      expect(serverpod.config.role, equals(ServerpodRole.serverless));
      expect(
          serverpod.config.loggingMode, equals(ServerpodLoggingMode.verbose));
      expect(serverpod.config.applyMigrations, isTrue);
      expect(serverpod.config.applyRepairMigration, isTrue);
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

      // All values should come from config since CLI parsing fails
      expect(serverpod.config.runMode, equals('development'));
      expect(serverpod.config.serverId, equals('config-server'));
      expect(serverpod.config.role, equals(ServerpodRole.monolith));
      expect(serverpod.config.loggingMode, equals(ServerpodLoggingMode.normal));
      expect(serverpod.config.applyMigrations, isTrue);
      expect(serverpod.config.applyRepairMigration, isFalse);
    });
  });
}
