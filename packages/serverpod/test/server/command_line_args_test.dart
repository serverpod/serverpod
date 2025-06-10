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
  });

  test(
      'Given command line arguments with invalid logging mode when parsing then default logging mode is used',
      () {
    final args = CommandLineArgs(['--logging', 'invalid-logging']);

    expect(args.loggingMode, equals(ServerpodLoggingMode.normal));
  });

  test(
      'Given command line arguments with invalid role when parsing then default role is used',
      () {
    final args = CommandLineArgs(['--role', 'invalid-role']);

    expect(args.role, equals(ServerpodRole.monolith));
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
  });

  group('Given CommandLineArgs instance when using getRaw method then', () {
    test('returns null for all arguments when no arguments provided', () {
      final args = CommandLineArgs([]);

      expect(args.getRaw<String>(CliArgsConstants.runMode), isNull);
      expect(args.getRaw<String>(CliArgsConstants.serverId), isNull);
      expect(args.getRaw<ServerpodLoggingMode>(CliArgsConstants.loggingMode),
          isNull);
      expect(args.getRaw<ServerpodRole>(CliArgsConstants.role), isNull);
      expect(args.getRaw<bool>(CliArgsConstants.applyMigrations), isNull);
      expect(args.getRaw<bool>(CliArgsConstants.applyRepairMigration), isNull);
    });

    test('returns correct raw values when all arguments provided', () {
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

      expect(
          args.getRaw<String>(CliArgsConstants.runMode), equals('production'));
      expect(args.getRaw<String>(CliArgsConstants.serverId),
          equals('test-server'));
      expect(args.getRaw<ServerpodLoggingMode>(CliArgsConstants.loggingMode),
          equals(ServerpodLoggingMode.verbose));
      expect(args.getRaw<ServerpodRole>(CliArgsConstants.role),
          equals(ServerpodRole.serverless));
      expect(args.getRaw<bool>(CliArgsConstants.applyMigrations), isTrue);
      expect(args.getRaw<bool>(CliArgsConstants.applyRepairMigration), isTrue);
    });

    test(
        'returns raw values for explicitly provided arguments even when same as defaults',
        () {
      final args = CommandLineArgs([
        '--mode', 'development', // Same as default but explicitly provided
        '--server-id', 'default', // Same as default but explicitly provided
        '--logging', 'normal', // Same as default but explicitly provided
        '--role', 'monolith', // Same as default but explicitly provided
      ]);

      expect(
          args.getRaw<String>(CliArgsConstants.runMode), equals('development'));
      expect(args.getRaw<String>(CliArgsConstants.serverId), equals('default'));
      expect(args.getRaw<ServerpodLoggingMode>(CliArgsConstants.loggingMode),
          equals(ServerpodLoggingMode.normal));
      expect(args.getRaw<ServerpodRole>(CliArgsConstants.role),
          equals(ServerpodRole.monolith));
      expect(args.getRaw<bool>(CliArgsConstants.applyMigrations),
          isNull); // Flags default to false
      expect(args.getRaw<bool>(CliArgsConstants.applyRepairMigration), isNull);
    });

    test('returns mixed raw values when only some arguments provided', () {
      final args =
          CommandLineArgs(['--mode', 'production', '--apply-migrations']);

      expect(
          args.getRaw<String>(CliArgsConstants.runMode), equals('production'));
      expect(args.getRaw<String>(CliArgsConstants.serverId), isNull);
      expect(args.getRaw<ServerpodLoggingMode>(CliArgsConstants.loggingMode),
          isNull);
      expect(args.getRaw<ServerpodRole>(CliArgsConstants.role), isNull);
      expect(args.getRaw<bool>(CliArgsConstants.applyMigrations), isTrue);
      expect(args.getRaw<bool>(CliArgsConstants.applyRepairMigration), isNull);
    });

    test('returns null for all arguments when invalid arguments cause fallback',
        () {
      final args = CommandLineArgs([
        '--mode', 'production', // Valid
        '--server-id', 'test-server', // Valid
        '--logging', 'invalid-logging', // Invalid - should trigger catch
        '--apply-migrations', // Valid
      ]);

      // All should be null because invalid arg triggers catch block
      expect(args.getRaw<String>(CliArgsConstants.runMode), isNull);
      expect(args.getRaw<String>(CliArgsConstants.serverId), isNull);
      expect(args.getRaw<ServerpodLoggingMode>(CliArgsConstants.loggingMode),
          isNull);
      expect(args.getRaw<ServerpodRole>(CliArgsConstants.role), isNull);
      expect(args.getRaw<bool>(CliArgsConstants.applyMigrations), isNull);
      expect(args.getRaw<bool>(CliArgsConstants.applyRepairMigration), isNull);
    });

    test('throws ArgumentError when invalid key provided', () {
      final args = CommandLineArgs([]);

      expect(() => args.getRaw<String>('invalid-key'), throwsArgumentError);
      expect(() => args.getRaw<String>(''), throwsArgumentError);
      expect(() => args.getRaw<String>('mode'),
          throwsArgumentError); // Should be CliArgsConstants.runMode
    });

    test('correctly casts types for all argument types', () {
      final args = CommandLineArgs([
        '--mode',
        'staging',
        '--server-id',
        'my-server',
        '--logging',
        'verbose',
        '--role',
        'maintenance',
        '--apply-migrations',
        '--apply-repair-migration',
      ]);

      // Test correct type casting
      expect(args.getRaw<String>(CliArgsConstants.runMode), isA<String>());
      expect(args.getRaw<String>(CliArgsConstants.serverId), isA<String>());
      expect(args.getRaw<ServerpodLoggingMode>(CliArgsConstants.loggingMode),
          isA<ServerpodLoggingMode>());
      expect(args.getRaw<ServerpodRole>(CliArgsConstants.role),
          isA<ServerpodRole>());
      expect(args.getRaw<bool>(CliArgsConstants.applyMigrations), isA<bool>());
      expect(args.getRaw<bool>(CliArgsConstants.applyRepairMigration),
          isA<bool>());
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
