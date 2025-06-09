import 'package:serverpod/src/server/command_line_args.dart';
import 'package:serverpod/src/server/run_mode.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given command line arguments with all valid options when parsing then all arguments are parsed correctly',
      () {
    final args = CommandLineArgs([
      '--mode',
      'production',
      '--server-id',
      'test-server',
      '--logging',
      'verbose',
      '--role',
      'serverless',
      '--apply-migrations',
      '--apply-repair-migration',
    ]);

    expect(args.runMode, equals('production'));
    expect(args.serverId, equals('test-server'));
    expect(args.loggingMode, equals(ServerpodLoggingMode.verbose));
    expect(args.role, equals(ServerpodRole.serverless));
    expect(args.applyMigrations, isTrue);
    expect(args.applyRepairMigration, isTrue);
  });

  test(
      'Given command line arguments with abbreviated options when parsing then abbreviated arguments are parsed correctly',
      () {
    final args = CommandLineArgs([
      '-m',
      'staging',
      '-i',
      'staging-server',
      '-l',
      'normal',
      '-r',
      'maintenance',
      '-a',
      '-A',
    ]);

    expect(args.runMode, equals('staging'));
    expect(args.serverId, equals('staging-server'));
    expect(args.loggingMode, equals(ServerpodLoggingMode.normal));
    expect(args.role, equals(ServerpodRole.maintenance));
    expect(args.applyMigrations, isTrue);
    expect(args.applyRepairMigration, isTrue);
  });

  test(
      'Given no command line arguments when parsing then default values are used',
      () {
    final args = CommandLineArgs([]);

    expect(args.runMode, equals(ServerpodRunMode.development));
    expect(args.serverId, equals('default'));
    expect(args.loggingMode, equals(ServerpodLoggingMode.normal));
    expect(args.role, equals(ServerpodRole.monolith));
    expect(args.applyMigrations, isFalse);
    expect(args.applyRepairMigration, isFalse);
  });

  test(
      'Given partially provided command line arguments when parsing then provided arguments are used and defaults for others',
      () {
    final args = CommandLineArgs(['--mode', 'test', '--apply-migrations']);

    expect(args.runMode, equals('test'));
    expect(args.serverId, equals('default'));
    expect(args.loggingMode, equals(ServerpodLoggingMode.normal));
    expect(args.role, equals(ServerpodRole.monolith));
    expect(args.applyMigrations, isTrue);
    expect(args.applyRepairMigration, isFalse);
  });

  test(
      'Given command line arguments with invalid mode when parsing then default mode is used',
      () {
    final args = CommandLineArgs(['--mode', 'invalid-mode']);

    expect(args.runMode, equals(ServerpodRunMode.development));
    expect(args.isRunModeDefault, isTrue);
  });

  test(
      'Given command line arguments with invalid logging mode when parsing then default logging mode is used',
      () {
    final args = CommandLineArgs(['--logging', 'invalid-logging']);

    expect(args.loggingMode, equals(ServerpodLoggingMode.normal));
    expect(args.isLoggingModeDefault, isTrue);
  });

  test(
      'Given command line arguments with invalid role when parsing then default role is used',
      () {
    final args = CommandLineArgs(['--role', 'invalid-role']);

    expect(args.role, equals(ServerpodRole.monolith));
    expect(args.isRoleDefault, isTrue);
  });

  test(
      'Given completely malformed command line arguments when parsing then all default values are used gracefully',
      () {
    final args = CommandLineArgs(['--invalid', '--also-invalid', 'value']);

    expect(args.runMode, equals(ServerpodRunMode.development));
    expect(args.serverId, equals('default'));
    expect(args.loggingMode, equals(ServerpodLoggingMode.normal));
    expect(args.role, equals(ServerpodRole.monolith));
    expect(args.applyMigrations, isFalse);
    expect(args.applyRepairMigration, isFalse);
  });

  test(
      'Given command line arguments mixing valid and invalid options when parsing then all values fall back to defaults',
      () {
    final args = CommandLineArgs([
      '--mode', 'production', // Valid
      '--server-id', 'test-server', // Valid
      '--logging', 'invalid-logging', // Invalid - should trigger catch
      '--apply-migrations', // Valid
    ]);

    // All should fall back to defaults because one invalid arg triggers catch
    expect(args.runMode, equals(ServerpodRunMode.development));
    expect(args.serverId, equals('default'));
    expect(args.loggingMode, equals(ServerpodLoggingMode.normal));
    expect(args.role, equals(ServerpodRole.monolith));
    expect(args.applyMigrations, isFalse);
    expect(args.applyRepairMigration, isFalse);

    // And all should be considered defaults
    expect(args.isRunModeDefault, isTrue);
    expect(args.isServerIdDefault, isTrue);
    expect(args.isLoggingModeDefault, isTrue);
    expect(args.isRoleDefault, isTrue);
    expect(args.isApplyMigrationsDefault, isTrue);
    expect(args.isApplyRepairMigrationDefault, isTrue);
  });

  group('Given CommandLineArgs instance when checking default values then', () {
    test(
        'isDefault methods correctly identify default values when no arguments provided',
        () {
      final args = CommandLineArgs([]);

      expect(args.isRunModeDefault, isTrue);
      expect(args.isServerIdDefault, isTrue);
      expect(args.isLoggingModeDefault, isTrue);
      expect(args.isRoleDefault, isTrue);
      expect(args.isApplyMigrationsDefault, isTrue);
      expect(args.isApplyRepairMigrationDefault, isTrue);
    });

    test(
        'isDefault methods correctly identify explicitly provided values even when same as defaults',
        () {
      final args = CommandLineArgs([
        '--mode', 'development', // Same as default but explicitly provided
        '--server-id', 'default', // Same as default but explicitly provided
        '--logging', 'normal', // Same as default but explicitly provided
        '--role', 'monolith', // Same as default but explicitly provided
      ]);

      expect(args.isRunModeDefault, isFalse);
      expect(args.isServerIdDefault, isFalse);
      expect(args.isLoggingModeDefault, isFalse);
      expect(args.isRoleDefault, isFalse);
      expect(args.isApplyMigrationsDefault, isTrue); // Flags default to false
      expect(args.isApplyRepairMigrationDefault, isTrue);
    });

    test(
        'isDefault methods correctly identify mixed default and explicit values',
        () {
      final args =
          CommandLineArgs(['--mode', 'production', '--apply-migrations']);

      expect(args.isRunModeDefault, isFalse);
      expect(args.isServerIdDefault, isTrue);
      expect(args.isLoggingModeDefault, isTrue);
      expect(args.isRoleDefault, isTrue);
      expect(args.isApplyMigrationsDefault, isFalse);
      expect(args.isApplyRepairMigrationDefault, isTrue);
    });
  });

  group('Given CommandLineArgs instance when using copyWith method then', () {
    test('copy is created with replaced values', () {
      final original = CommandLineArgs(['--mode', 'development']);
      final copy = original.copyWith(
        runMode: 'production',
        serverId: 'new-server',
        loggingMode: ServerpodLoggingMode.verbose,
        role: ServerpodRole.serverless,
        applyMigrations: true,
        applyRepairMigration: true,
      );

      expect(copy.runMode, equals('production'));
      expect(copy.serverId, equals('new-server'));
      expect(copy.loggingMode, equals(ServerpodLoggingMode.verbose));
      expect(copy.role, equals(ServerpodRole.serverless));
      expect(copy.applyMigrations, isTrue);
      expect(copy.applyRepairMigration, isTrue);

      // Original should be unchanged
      expect(original.runMode, equals('development'));
      expect(original.serverId, equals('default'));
    });

    test('original values are preserved when null passed to copyWith', () {
      final original = CommandLineArgs([
        '--mode',
        'staging',
        '--server-id',
        'test',
        '--logging',
        'verbose',
        '--role',
        'maintenance',
        '--apply-migrations',
      ]);
      final copy = original.copyWith();

      expect(copy.runMode, equals(original.runMode));
      expect(copy.serverId, equals(original.serverId));
      expect(copy.loggingMode, equals(original.loggingMode));
      expect(copy.role, equals(original.role));
      expect(copy.applyMigrations, equals(original.applyMigrations));
      expect(copy.applyRepairMigration, equals(original.applyRepairMigration));
    });
  });

  group('Given CommandLineArgs instance when converting to string then', () {
    test('all values are formatted correctly', () {
      final args = CommandLineArgs([
        '--mode',
        'production',
        '--server-id',
        'prod-server',
        '--logging',
        'verbose',
        '--role',
        'serverless',
        '--apply-migrations',
        '--apply-repair-migration',
      ]);

      final str = args.toString();
      expect(str, contains('mode: production'));
      expect(str, contains('role: serverless'));
      expect(str, contains('logging: verbose'));
      expect(str, contains('serverId: prod-server'));
      expect(str, contains('applyMigrations: true'));
      expect(str, contains('applyRepairMigration: true'));
    });

    test('default values are formatted correctly', () {
      final args = CommandLineArgs([]);

      final str = args.toString();
      expect(str, contains('mode: development'));
      expect(str, contains('role: monolith'));
      expect(str, contains('logging: normal'));
      expect(str, contains('serverId: default'));
      expect(str, contains('applyMigrations: false'));
      expect(str, contains('applyRepairMigration: false'));
    });
  });

  group('Given CommandLineArgs when validating enum values then', () {
    test('all valid run modes are supported', () {
      final modes = [
        ServerpodRunMode.development,
        ServerpodRunMode.test,
        ServerpodRunMode.staging,
        ServerpodRunMode.production,
      ];

      for (final mode in modes) {
        final args = CommandLineArgs(['--mode', mode]);
        expect(args.runMode, equals(mode));
        expect(args.isRunModeDefault, isFalse);
      }
    });

    test('all valid logging modes are supported', () {
      final args1 = CommandLineArgs(['--logging', 'normal']);
      expect(args1.loggingMode, equals(ServerpodLoggingMode.normal));

      final args2 = CommandLineArgs(['--logging', 'verbose']);
      expect(args2.loggingMode, equals(ServerpodLoggingMode.verbose));
    });

    test('all valid roles are supported', () {
      final args1 = CommandLineArgs(['--role', 'monolith']);
      expect(args1.role, equals(ServerpodRole.monolith));

      final args2 = CommandLineArgs(['--role', 'serverless']);
      expect(args2.role, equals(ServerpodRole.serverless));

      final args3 = CommandLineArgs(['--role', 'maintenance']);
      expect(args3.role, equals(ServerpodRole.maintenance));
    });
  });
}
