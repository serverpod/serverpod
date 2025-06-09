import 'package:serverpod/src/server/command_line_args.dart';
import 'package:serverpod/src/server/run_mode.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  group('CommandLineArgs', () {
    group('parsing command line arguments', () {
      test('should parse all valid arguments correctly', () {
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

      test('should parse abbreviated arguments correctly', () {
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

      test('should use default values when no arguments provided', () {
        final args = CommandLineArgs([]);

        expect(args.runMode, equals(ServerpodRunMode.development));
        expect(args.serverId, equals('default'));
        expect(args.loggingMode, equals(ServerpodLoggingMode.normal));
        expect(args.role, equals(ServerpodRole.monolith));
        expect(args.applyMigrations, isFalse);
        expect(args.applyRepairMigration, isFalse);
      });

      test('should parse partial arguments and use defaults for others', () {
        final args = CommandLineArgs(['--mode', 'test', '--apply-migrations']);

        expect(args.runMode, equals('test'));
        expect(args.serverId, equals('default'));
        expect(args.loggingMode, equals(ServerpodLoggingMode.normal));
        expect(args.role, equals(ServerpodRole.monolith));
        expect(args.applyMigrations, isTrue);
        expect(args.applyRepairMigration, isFalse);
      });
    });

    group('handling invalid arguments', () {
      test('should use defaults when invalid mode provided', () {
        final args = CommandLineArgs(['--mode', 'invalid-mode']);

        expect(args.runMode, equals(ServerpodRunMode.development));
        expect(args.isRunModeDefault, isTrue);
      });

      test('should use defaults when invalid logging mode provided', () {
        final args = CommandLineArgs(['--logging', 'invalid-logging']);

        expect(args.loggingMode, equals(ServerpodLoggingMode.normal));
        expect(args.isLoggingModeDefault, isTrue);
      });

      test('should use defaults when invalid role provided', () {
        final args = CommandLineArgs(['--role', 'invalid-role']);

        expect(args.role, equals(ServerpodRole.monolith));
        expect(args.isRoleDefault, isTrue);
      });

      test('should handle completely malformed arguments gracefully', () {
        final args = CommandLineArgs(['--invalid', '--also-invalid', 'value']);

        expect(args.runMode, equals(ServerpodRunMode.development));
        expect(args.serverId, equals('default'));
        expect(args.loggingMode, equals(ServerpodLoggingMode.normal));
        expect(args.role, equals(ServerpodRole.monolith));
        expect(args.applyMigrations, isFalse);
        expect(args.applyRepairMigration, isFalse);
      });

      test(
          'should fall back to defaults when mixing valid and invalid arguments',
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
    });

    group('isDefault methods', () {
      test('should correctly identify default values', () {
        final args = CommandLineArgs([]);

        expect(args.isRunModeDefault, isTrue);
        expect(args.isServerIdDefault, isTrue);
        expect(args.isLoggingModeDefault, isTrue);
        expect(args.isRoleDefault, isTrue);
        expect(args.isApplyMigrationsDefault, isTrue);
        expect(args.isApplyRepairMigrationDefault, isTrue);
      });

      test('should correctly identify explicitly provided values', () {
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

      test('should correctly identify mixed default and explicit values', () {
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

    group('copyWith method', () {
      test('should create copy with replaced values', () {
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

      test('should preserve original values when null passed', () {
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
        expect(
            copy.applyRepairMigration, equals(original.applyRepairMigration));
      });
    });

    group('toString method', () {
      test('should format all values correctly', () {
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

      test('should format default values correctly', () {
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

    group('enum value validation', () {
      test('should support all valid run modes', () {
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

      test('should support all valid logging modes', () {
        final args1 = CommandLineArgs(['--logging', 'normal']);
        expect(args1.loggingMode, equals(ServerpodLoggingMode.normal));

        final args2 = CommandLineArgs(['--logging', 'verbose']);
        expect(args2.loggingMode, equals(ServerpodLoggingMode.verbose));
      });

      test('should support all valid roles', () {
        final args1 = CommandLineArgs(['--role', 'monolith']);
        expect(args1.role, equals(ServerpodRole.monolith));

        final args2 = CommandLineArgs(['--role', 'serverless']);
        expect(args2.role, equals(ServerpodRole.serverless));

        final args3 = CommandLineArgs(['--role', 'maintenance']);
        expect(args3.role, equals(ServerpodRole.maintenance));
      });
    });
  });
}
