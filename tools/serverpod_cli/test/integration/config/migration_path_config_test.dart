import 'package:serverpod_cli/src/config/config.dart';
import 'package:test/test.dart';

import '../../test_util/builders/generator_config_builder.dart';

void main() {
  group('GeneratorConfig migration path', () {
    test(
      'Given no custom migration path configured '
      'when accessing relativeMigrationPathParts '
      'then returns default "migrations" path.',
      () {
        var config = GeneratorConfigBuilder().build();

        expect(
          config.relativeMigrationPathParts,
          equals(['migrations']),
        );
      },
    );

    test(
      'Given no custom migration path configured '
      'when accessing hasCustomMigrationPath '
      'then returns false.',
      () {
        var config = GeneratorConfigBuilder().build();

        expect(config.hasCustomMigrationPath, isFalse);
      },
    );

    test(
      'Given custom migration path configured '
      'when accessing relativeMigrationPathParts '
      'then returns the custom path.',
      () {
        var config = GeneratorConfigBuilder()
            .withRelativeMigrationPathParts(['custom', 'migrations'])
            .build();

        expect(
          config.relativeMigrationPathParts,
          equals(['custom', 'migrations']),
        );
      },
    );

    test(
      'Given custom migration path configured '
      'when accessing hasCustomMigrationPath '
      'then returns true.',
      () {
        var config = GeneratorConfigBuilder()
            .withRelativeMigrationPathParts(['custom', 'migrations'])
            .build();

        expect(config.hasCustomMigrationPath, isTrue);
      },
    );

    test(
      'Given custom migration path configured '
      'when accessing migrationPathParts '
      'then returns full path including server package directory.',
      () {
        var config = GeneratorConfigBuilder()
            .withServerPackageDirectoryPathParts(['project', 'server'])
            .withRelativeMigrationPathParts(['custom', 'migrations'])
            .build();

        expect(
          config.migrationPathParts,
          equals(['project', 'server', 'custom', 'migrations']),
        );
      },
    );

    test(
      'Given no custom migration path configured '
      'when accessing migrationPathParts '
      'then returns full path with default migrations directory.',
      () {
        var config = GeneratorConfigBuilder()
            .withServerPackageDirectoryPathParts(['project', 'server'])
            .build();

        expect(
          config.migrationPathParts,
          equals(['project', 'server', 'migrations']),
        );
      },
    );

    test(
      'Given single component migration path '
      'when accessing relativeMigrationPathParts '
      'then returns single component list.',
      () {
        var config = GeneratorConfigBuilder()
            .withRelativeMigrationPathParts(['db-migrations'])
            .build();

        expect(
          config.relativeMigrationPathParts,
          equals(['db-migrations']),
        );
      },
    );

    test(
      'Given default migration path parts constant '
      'then it equals ["migrations"].',
      () {
        expect(
          GeneratorConfig.defaultRelativeMigrationPathParts,
          equals(['migrations']),
        );
      },
    );
  });
}
