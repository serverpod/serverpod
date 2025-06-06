import 'package:serverpod/src/server/command_line_args.dart';
import 'package:serverpod/src/server/environment_cli_args_augmenter.dart';
import 'package:serverpod/src/server/run_mode.dart';
import 'package:test/test.dart';

void main() {
  group('EnvironmentCliArgsAugmenter', () {
    group('environment variable augmentation', () {
      test('should augment default CLI args with valid environment variables',
          () {
        final environment = {
          'SERVERPOD_MODE': 'production',
          'SERVERPOD_SERVER_ID': 'env-server',
          'SERVERPOD_LOGGING': 'verbose',
          'SERVERPOD_ROLE': 'serverless',
          'SERVERPOD_APPLY_MIGRATIONS': 'true',
          'SERVERPOD_APPLY_REPAIR_MIGRATION': 'true',
        };

        final augmenter = EnvironmentCliArgsAugmenter(environment);
        final originalArgs = CommandLineArgs([]); // All defaults
        final augmentedArgs = augmenter.createAugmentedFrom(originalArgs);

        expect(augmentedArgs.runMode, equals('production'));
        expect(augmentedArgs.serverId, equals('env-server'));
        expect(augmentedArgs.loggingMode, equals(ServerpodLoggingMode.verbose));
        expect(augmentedArgs.role, equals(ServerpodRole.serverless));
        expect(augmentedArgs.applyMigrations, isTrue);
        expect(augmentedArgs.applyRepairMigration, isTrue);
      });

      test('should not override explicitly provided CLI arguments', () {
        final environment = {
          'SERVERPOD_MODE': 'production',
          'SERVERPOD_SERVER_ID': 'env-server',
          'SERVERPOD_LOGGING': 'verbose',
          'SERVERPOD_ROLE': 'serverless',
          'SERVERPOD_APPLY_MIGRATIONS': 'true',
          'SERVERPOD_APPLY_REPAIR_MIGRATION': 'true',
        };

        final augmenter = EnvironmentCliArgsAugmenter(environment);
        final originalArgs = CommandLineArgs([
          '--mode',
          'staging',
          '--server-id',
          'cli-server',
          '--logging',
          'normal',
          '--role',
          'maintenance',
          '--apply-migrations',
        ]);
        final augmentedArgs = augmenter.createAugmentedFrom(originalArgs);

        // CLI values should be preserved
        expect(augmentedArgs.runMode, equals('staging'));
        expect(augmentedArgs.serverId, equals('cli-server'));
        expect(augmentedArgs.loggingMode, equals(ServerpodLoggingMode.normal));
        expect(augmentedArgs.role, equals(ServerpodRole.maintenance));
        expect(augmentedArgs.applyMigrations, isTrue);

        // Only the non-explicitly provided flag should be augmented
        expect(augmentedArgs.applyRepairMigration, isTrue); // From env
      });

      test('should handle partial environment variables', () {
        final environment = {
          'SERVERPOD_MODE': 'test',
          'SERVERPOD_LOGGING': 'verbose',
          // Missing other env vars
        };

        final augmenter = EnvironmentCliArgsAugmenter(environment);
        final originalArgs = CommandLineArgs([]);
        final augmentedArgs = augmenter.createAugmentedFrom(originalArgs);

        expect(augmentedArgs.runMode, equals('test')); // From env
        expect(augmentedArgs.loggingMode,
            equals(ServerpodLoggingMode.verbose)); // From env
        expect(augmentedArgs.serverId, equals('default')); // Default (no env)
        expect(augmentedArgs.role,
            equals(ServerpodRole.monolith)); // Default (no env)
        expect(augmentedArgs.applyMigrations, isFalse); // Default (no env)
        expect(augmentedArgs.applyRepairMigration, isFalse); // Default (no env)
      });
    });

    group('handling missing environment variables', () {
      test(
          'should fall back to defaults when environment variables are missing',
          () {
        final environment = <String, dynamic>{}; // Empty environment

        final augmenter = EnvironmentCliArgsAugmenter(environment);
        final originalArgs = CommandLineArgs([]);
        final augmentedArgs = augmenter.createAugmentedFrom(originalArgs);

        expect(augmentedArgs.runMode, equals(ServerpodRunMode.development));
        expect(augmentedArgs.serverId, equals('default'));
        expect(augmentedArgs.loggingMode, equals(ServerpodLoggingMode.normal));
        expect(augmentedArgs.role, equals(ServerpodRole.monolith));
        expect(augmentedArgs.applyMigrations, isFalse);
        expect(augmentedArgs.applyRepairMigration, isFalse);
      });

      test('should handle null environment variables', () {
        final environment = {
          'SERVERPOD_MODE': null,
          'SERVERPOD_SERVER_ID': null,
          'SERVERPOD_LOGGING': null,
          'SERVERPOD_ROLE': null,
          'SERVERPOD_APPLY_MIGRATIONS': null,
          'SERVERPOD_APPLY_REPAIR_MIGRATION': null,
        };

        final augmenter = EnvironmentCliArgsAugmenter(environment);
        final originalArgs = CommandLineArgs([]);
        final augmentedArgs = augmenter.createAugmentedFrom(originalArgs);

        expect(augmentedArgs.runMode, equals(ServerpodRunMode.development));
        expect(augmentedArgs.serverId, equals('default'));
        expect(augmentedArgs.loggingMode, equals(ServerpodLoggingMode.normal));
        expect(augmentedArgs.role, equals(ServerpodRole.monolith));
        expect(augmentedArgs.applyMigrations, isFalse);
        expect(augmentedArgs.applyRepairMigration, isFalse);
      });
    });

    group('handling invalid environment variables', () {
      test('should fall back to defaults for invalid enum values', () {
        final environment = {
          'SERVERPOD_MODE': 'development', // Valid
          'SERVERPOD_SERVER_ID': 'test-server', // Valid
          'SERVERPOD_LOGGING': 'invalid-logging', // Invalid
          'SERVERPOD_ROLE': 'invalid-role', // Invalid
          'SERVERPOD_APPLY_MIGRATIONS': 'true', // Valid
          'SERVERPOD_APPLY_REPAIR_MIGRATION': 'false', // Valid
        };

        final augmenter = EnvironmentCliArgsAugmenter(environment);
        final originalArgs = CommandLineArgs([]);
        final augmentedArgs = augmenter.createAugmentedFrom(originalArgs);

        expect(augmentedArgs.runMode, equals('development')); // Valid env value
        expect(
            augmentedArgs.serverId, equals('test-server')); // Valid env value
        expect(augmentedArgs.loggingMode,
            equals(ServerpodLoggingMode.normal)); // Default (invalid env)
        expect(augmentedArgs.role,
            equals(ServerpodRole.monolith)); // Default (invalid env)
        expect(augmentedArgs.applyMigrations, isTrue); // Valid env value
        expect(augmentedArgs.applyRepairMigration, isFalse); // Valid env value
      });

      test('should handle non-string environment values', () {
        final environment = {
          'SERVERPOD_MODE': 123, // Wrong type
          'SERVERPOD_SERVER_ID': true, // Wrong type
          'SERVERPOD_LOGGING': ['array'], // Wrong type
          'SERVERPOD_ROLE': {'key': 'value'}, // Wrong type
          'SERVERPOD_APPLY_MIGRATIONS': 'not-boolean', // Invalid boolean
          'SERVERPOD_APPLY_REPAIR_MIGRATION':
              'also-not-boolean', // Invalid boolean
        };

        final augmenter = EnvironmentCliArgsAugmenter(environment);
        final originalArgs = CommandLineArgs([]);
        final augmentedArgs = augmenter.createAugmentedFrom(originalArgs);

        // All should fall back to defaults due to wrong types
        expect(augmentedArgs.runMode, equals(ServerpodRunMode.development));
        expect(augmentedArgs.serverId, equals('default'));
        expect(augmentedArgs.loggingMode, equals(ServerpodLoggingMode.normal));
        expect(augmentedArgs.role, equals(ServerpodRole.monolith));
        expect(augmentedArgs.applyMigrations, isFalse);
        expect(augmentedArgs.applyRepairMigration, isFalse);
      });
    });

    group('boolean environment variable handling', () {
      test('should parse "true" as true for boolean flags', () {
        final environment = {
          'SERVERPOD_APPLY_MIGRATIONS': 'true',
          'SERVERPOD_APPLY_REPAIR_MIGRATION': 'true',
        };

        final augmenter = EnvironmentCliArgsAugmenter(environment);
        final originalArgs = CommandLineArgs([]);
        final augmentedArgs = augmenter.createAugmentedFrom(originalArgs);

        expect(augmentedArgs.applyMigrations, isTrue);
        expect(augmentedArgs.applyRepairMigration, isTrue);
      });

      test('should parse anything other than "true" as false for boolean flags',
          () {
        final testCases = [
          'false',
          'FALSE',
          'True',
          'TRUE',
          '1',
          '0',
          'yes',
          'no',
          '',
          'random-string',
        ];

        for (final testValue in testCases) {
          final environment = {
            'SERVERPOD_APPLY_MIGRATIONS': testValue,
            'SERVERPOD_APPLY_REPAIR_MIGRATION': testValue,
          };

          final augmenter = EnvironmentCliArgsAugmenter(environment);
          final originalArgs = CommandLineArgs([]);
          final augmentedArgs = augmenter.createAugmentedFrom(originalArgs);

          expect(augmentedArgs.applyMigrations, isFalse,
              reason: 'Expected false for value: "$testValue"');
          expect(augmentedArgs.applyRepairMigration, isFalse,
              reason: 'Expected false for value: "$testValue"');
        }
      });
    });

    group('enum parsing edge cases', () {
      test('should handle all valid logging mode values', () {
        final validValues = ['normal', 'verbose'];
        final expectedEnums = [
          ServerpodLoggingMode.normal,
          ServerpodLoggingMode.verbose
        ];

        for (int i = 0; i < validValues.length; i++) {
          final environment = {'SERVERPOD_LOGGING': validValues[i]};
          final augmenter = EnvironmentCliArgsAugmenter(environment);
          final originalArgs = CommandLineArgs([]);
          final augmentedArgs = augmenter.createAugmentedFrom(originalArgs);

          expect(augmentedArgs.loggingMode, equals(expectedEnums[i]),
              reason: 'Failed for logging mode: ${validValues[i]}');
        }
      });

      test('should handle all valid role values', () {
        final validValues = ['monolith', 'serverless', 'maintenance'];
        final expectedEnums = [
          ServerpodRole.monolith,
          ServerpodRole.serverless,
          ServerpodRole.maintenance
        ];

        for (int i = 0; i < validValues.length; i++) {
          final environment = {'SERVERPOD_ROLE': validValues[i]};
          final augmenter = EnvironmentCliArgsAugmenter(environment);
          final originalArgs = CommandLineArgs([]);
          final augmentedArgs = augmenter.createAugmentedFrom(originalArgs);

          expect(augmentedArgs.role, equals(expectedEnums[i]),
              reason: 'Failed for role: ${validValues[i]}');
        }
      });

      test('should be case sensitive for enum values', () {
        final environment = {
          'SERVERPOD_LOGGING': 'VERBOSE', // Wrong case
          'SERVERPOD_ROLE': 'SERVERLESS', // Wrong case
        };

        final augmenter = EnvironmentCliArgsAugmenter(environment);
        final originalArgs = CommandLineArgs([]);
        final augmentedArgs = augmenter.createAugmentedFrom(originalArgs);

        // Should fall back to defaults due to case mismatch
        expect(augmentedArgs.loggingMode, equals(ServerpodLoggingMode.normal));
        expect(augmentedArgs.role, equals(ServerpodRole.monolith));
      });
    });

    group('mixed CLI and environment scenarios', () {
      test('should handle complex mixed scenarios correctly', () {
        final environment = {
          'SERVERPOD_MODE': 'production',
          'SERVERPOD_SERVER_ID': 'env-server',
          'SERVERPOD_LOGGING': 'verbose',
          'SERVERPOD_ROLE': 'maintenance',
          'SERVERPOD_APPLY_MIGRATIONS': 'true',
          'SERVERPOD_APPLY_REPAIR_MIGRATION': 'true',
        };

        // Provide some CLI args but not others
        final originalArgs = CommandLineArgs([
          '--mode', 'staging', // This should override env
          '--logging', 'normal', // This should override env
          // server-id, role, flags not provided - should use env
        ]);

        final augmenter = EnvironmentCliArgsAugmenter(environment);
        final augmentedArgs = augmenter.createAugmentedFrom(originalArgs);

        expect(augmentedArgs.runMode, equals('staging')); // CLI override
        expect(augmentedArgs.serverId, equals('env-server')); // From env
        expect(augmentedArgs.loggingMode,
            equals(ServerpodLoggingMode.normal)); // CLI override
        expect(
            augmentedArgs.role, equals(ServerpodRole.maintenance)); // From env
        expect(augmentedArgs.applyMigrations, isTrue); // From env
        expect(augmentedArgs.applyRepairMigration, isTrue); // From env
      });
    });

    group('argument precedence validation', () {
      test('should maintain correct precedence: CLI > Env > Default', () {
        final environment = {
          'SERVERPOD_MODE': 'staging',
          'SERVERPOD_SERVER_ID': 'env-server',
        };

        // Test 1: No CLI args - should use env
        final args1 = CommandLineArgs([]);
        final augmenter = EnvironmentCliArgsAugmenter(environment);
        final result1 = augmenter.createAugmentedFrom(args1);

        expect(result1.runMode, equals('staging')); // Env value
        expect(result1.serverId, equals('env-server')); // Env value

        // Test 2: CLI args provided - should use CLI
        final args2 = CommandLineArgs(
            ['--mode', 'production', '--server-id', 'cli-server']);
        final result2 = augmenter.createAugmentedFrom(args2);

        expect(result2.runMode, equals('production')); // CLI value
        expect(result2.serverId, equals('cli-server')); // CLI value

        // Test 3: Mixed - CLI for some, env for others
        final args3 = CommandLineArgs(['--mode', 'test']); // Only mode via CLI
        final result3 = augmenter.createAugmentedFrom(args3);

        expect(result3.runMode, equals('test')); // CLI value
        expect(result3.serverId, equals('env-server')); // Env value
      });
    });
  });
}
