import 'package:serverpod/src/server/command_line_args.dart';
import 'package:serverpod/src/server/run_mode.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  group('Given command line arguments with all valid options', () {
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

    test('when parsing then all arguments are parsed correctly', () {
      expect(args.runMode, equals('production'));
      expect(args.serverId, equals('test-server'));
      expect(args.loggingMode, equals(ServerpodLoggingMode.verbose));
      expect(args.role, equals(ServerpodRole.serverless));
      expect(args.applyMigrations, isTrue);
      expect(args.applyRepairMigration, isTrue);
    });

    test('when using getRaw method then returns correct raw values', () {
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

    test('when converting to string then all values are formatted correctly',
        () {
      final str = args.toString();
      expect(str, contains('mode: production'));
      expect(str, contains('role: serverless'));
      expect(str, contains('logging: verbose'));
      expect(str, contains('serverId: test-server'));
      expect(str, contains('applyMigrations: true'));
      expect(str, contains('applyRepairMigration: true'));
    });

    test('when correctly casting types then all argument types are correct',
        () {
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

  group('Given command line arguments with abbreviated options', () {
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

    test('when parsing then abbreviated arguments are parsed correctly', () {
      expect(args.runMode, equals('staging'));
      expect(args.serverId, equals('staging-server'));
      expect(args.loggingMode, equals(ServerpodLoggingMode.normal));
      expect(args.role, equals(ServerpodRole.maintenance));
      expect(args.applyMigrations, isTrue);
      expect(args.applyRepairMigration, isTrue);
    });
  });

  group('Given no command line arguments', () {
    final args = CommandLineArgs([]);

    test('when parsing then default values are used', () {
      expect(args.runMode, equals(ServerpodRunMode.development));
      expect(args.serverId, equals('default'));
      expect(args.loggingMode, equals(ServerpodLoggingMode.normal));
      expect(args.role, equals(ServerpodRole.monolith));
      expect(args.applyMigrations, isFalse);
      expect(args.applyRepairMigration, isFalse);
    });

    test('when using getRaw method then returns null for all arguments', () {
      expect(args.getRaw<String>(CliArgsConstants.runMode), isNull);
      expect(args.getRaw<String>(CliArgsConstants.serverId), isNull);
      expect(args.getRaw<ServerpodLoggingMode>(CliArgsConstants.loggingMode),
          isNull);
      expect(args.getRaw<ServerpodRole>(CliArgsConstants.role), isNull);
      expect(args.getRaw<bool>(CliArgsConstants.applyMigrations), isNull);
      expect(args.getRaw<bool>(CliArgsConstants.applyRepairMigration), isNull);
    });

    test(
        'when converting to string then default values are formatted correctly',
        () {
      final str = args.toString();
      expect(str, contains('mode: development'));
      expect(str, contains('role: monolith'));
      expect(str, contains('logging: normal'));
      expect(str, contains('serverId: default'));
      expect(str, contains('applyMigrations: false'));
      expect(str, contains('applyRepairMigration: false'));
    });

    test('when using getRaw with invalid key then throws ArgumentError', () {
      expect(() => args.getRaw<String>('invalid-key'), throwsArgumentError);
      expect(() => args.getRaw<String>(''), throwsArgumentError);
      expect(() => args.getRaw<String>('mode'),
          throwsArgumentError); // Should be CliArgsConstants.runMode
    });

    test('when using toMap method then returns null for all raw values', () {
      final map = args.toMap();
      expect(map[CliArgsConstants.runMode], isNull);
      expect(map[CliArgsConstants.serverId], isNull);
      expect(map[CliArgsConstants.loggingMode], isNull);
      expect(map[CliArgsConstants.role], isNull);
      expect(map[CliArgsConstants.applyMigrations], isNull);
      expect(map[CliArgsConstants.applyRepairMigration], isNull);
      expect(map.length, equals(6));
    });
  });

  group('Given partially provided command line arguments', () {
    final args = CommandLineArgs(['--mode', 'test', '--apply-migrations']);

    test(
        'when parsing then provided arguments are used and defaults for others',
        () {
      expect(args.runMode, equals('test'));
      expect(args.serverId, equals('default'));
      expect(args.loggingMode, equals(ServerpodLoggingMode.normal));
      expect(args.role, equals(ServerpodRole.monolith));
      expect(args.applyMigrations, isTrue);
      expect(args.applyRepairMigration, isFalse);
    });

    test('when using getRaw method then returns mixed raw values', () {
      expect(args.getRaw<String>(CliArgsConstants.runMode), equals('test'));
      expect(args.getRaw<String>(CliArgsConstants.serverId), isNull);
      expect(args.getRaw<ServerpodLoggingMode>(CliArgsConstants.loggingMode),
          isNull);
      expect(args.getRaw<ServerpodRole>(CliArgsConstants.role), isNull);
      expect(args.getRaw<bool>(CliArgsConstants.applyMigrations), isTrue);
      expect(args.getRaw<bool>(CliArgsConstants.applyRepairMigration), isNull);
    });

    test('when using toMap method then returns mixed raw values', () {
      final map = args.toMap();
      expect(map[CliArgsConstants.runMode], equals('test'));
      expect(map[CliArgsConstants.serverId], isNull);
      expect(map[CliArgsConstants.loggingMode], isNull);
      expect(map[CliArgsConstants.role], isNull);
      expect(map[CliArgsConstants.applyMigrations], isTrue);
      expect(map[CliArgsConstants.applyRepairMigration], isNull);
      expect(map.length, equals(6));
    });
  });

  group('Given command line arguments explicitly set to default values', () {
    final args = CommandLineArgs([
      '--mode', 'development', // Same as default but explicitly provided
      '--server-id', 'default', // Same as default but explicitly provided
      '--logging', 'normal', // Same as default but explicitly provided
      '--role', 'monolith', // Same as default but explicitly provided
    ]);

    test(
        'when using getRaw method then returns raw values for explicitly provided arguments even when same as defaults',
        () {
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

    test(
        'when using toMap method then returns raw values for explicitly provided arguments even when same as defaults',
        () {
      final map = args.toMap();
      expect(map[CliArgsConstants.runMode], equals('development'));
      expect(map[CliArgsConstants.serverId], equals('default'));
      expect(map[CliArgsConstants.loggingMode],
          equals(ServerpodLoggingMode.normal));
      expect(map[CliArgsConstants.role], equals(ServerpodRole.monolith));
      expect(map[CliArgsConstants.applyMigrations],
          isNull); // Flags default to false
      expect(map[CliArgsConstants.applyRepairMigration], isNull);
      expect(map.length, equals(6));
    });
  });

  group('Given command line arguments with invalid mode', () {
    final args = CommandLineArgs(['--mode', 'invalid-mode']);

    test('when parsing then default mode is used', () {
      expect(args.runMode, equals(ServerpodRunMode.development));
    });
  });

  group('Given command line arguments with invalid logging mode', () {
    final args = CommandLineArgs(['--logging', 'invalid-logging']);

    test('when parsing then default logging mode is used', () {
      expect(args.loggingMode, equals(ServerpodLoggingMode.normal));
    });
  });

  group('Given command line arguments with invalid role', () {
    final args = CommandLineArgs(['--role', 'invalid-role']);

    test('when parsing then default role is used', () {
      expect(args.role, equals(ServerpodRole.monolith));
    });
  });

  group('Given completely malformed command line arguments', () {
    final args = CommandLineArgs(['--invalid', '--also-invalid', 'value']);

    test('when parsing then all default values are used gracefully', () {
      expect(args.runMode, equals(ServerpodRunMode.development));
      expect(args.serverId, equals('default'));
      expect(args.loggingMode, equals(ServerpodLoggingMode.normal));
      expect(args.role, equals(ServerpodRole.monolith));
      expect(args.applyMigrations, isFalse);
      expect(args.applyRepairMigration, isFalse);
    });
  });

  group('Given command line arguments mixing valid and invalid options', () {
    final args = CommandLineArgs([
      '--mode', 'production', // Valid
      '--server-id', 'test-server', // Valid
      '--logging', 'invalid-logging', // Invalid - should trigger catch
      '--apply-migrations', // Valid
    ]);

    test('when parsing then all values fall back to defaults', () {
      // All should fall back to defaults because one invalid arg triggers catch
      expect(args.runMode, equals(ServerpodRunMode.development));
      expect(args.serverId, equals('default'));
      expect(args.loggingMode, equals(ServerpodLoggingMode.normal));
      expect(args.role, equals(ServerpodRole.monolith));
      expect(args.applyMigrations, isFalse);
      expect(args.applyRepairMigration, isFalse);
    });

    test(
        'when using getRaw method then returns null for all arguments due to invalid arguments causing fallback',
        () {
      // All should be null because invalid arg triggers catch block
      expect(args.getRaw<String>(CliArgsConstants.runMode), isNull);
      expect(args.getRaw<String>(CliArgsConstants.serverId), isNull);
      expect(args.getRaw<ServerpodLoggingMode>(CliArgsConstants.loggingMode),
          isNull);
      expect(args.getRaw<ServerpodRole>(CliArgsConstants.role), isNull);
      expect(args.getRaw<bool>(CliArgsConstants.applyMigrations), isNull);
      expect(args.getRaw<bool>(CliArgsConstants.applyRepairMigration), isNull);
    });
  });

  group('Given CommandLineArgs when validating enum values', () {
    test('when using all valid run modes then all are supported', () {
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

    test('when using all valid logging modes then all are supported', () {
      final args1 = CommandLineArgs(['--logging', 'normal']);
      expect(args1.loggingMode, equals(ServerpodLoggingMode.normal));

      final args2 = CommandLineArgs(['--logging', 'verbose']);
      expect(args2.loggingMode, equals(ServerpodLoggingMode.verbose));
    });

    test('when using all valid roles then all are supported', () {
      final args1 = CommandLineArgs(['--role', 'monolith']);
      expect(args1.role, equals(ServerpodRole.monolith));

      final args2 = CommandLineArgs(['--role', 'serverless']);
      expect(args2.role, equals(ServerpodRole.serverless));

      final args3 = CommandLineArgs(['--role', 'maintenance']);
      expect(args3.role, equals(ServerpodRole.maintenance));
    });
  });
}
