import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

import 'util.dart';

void main() {
  group(
    'Given a new server project with PostgreSQL enabled,',
    () {
      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.server,
          postgres: true,
        ),
      );

      test(
        'when its test configuration is loaded, '
        'then the embedded database requests an available TCP port.',
        () {
          final config = ServerpodConfig.load(
            'test',
            null,
            PasswordManager(
              runMode: 'test',
            ).loadPasswords(serverDir: project.serverDir),
            serverDir: project.serverDir,
          );
          final database = config.database as PostgresDatabaseConfig;

          expect(database.dataPath, '.serverpod/test/pgdata');
          expect(database.port, 0);
        },
      );
    },
  );

  group(
    'Given a new module project with PostgreSQL enabled,',
    () {
      final project = setUpPerformCreateInTempDir(
        context: TemplateContext(
          template: ServerpodTemplateType.module,
          postgres: true,
        ),
      );

      test(
        'when its test configuration is loaded, '
        'then the embedded database requests an available TCP port.',
        () {
          final config = ServerpodConfig.load(
            'test',
            null,
            PasswordManager(
              runMode: 'test',
            ).loadPasswords(serverDir: project.serverDir),
            serverDir: project.serverDir,
          );
          final database = config.database as PostgresDatabaseConfig;

          expect(database.dataPath, '.serverpod/test/pgdata');
          expect(database.port, 0);
        },
      );
    },
  );
}
