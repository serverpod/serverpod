import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';
import 'package:yaml/yaml.dart';

const _defaultPasswordConfig = '''
shared:
  mySharedPassword: 'my password'

development:
  database: 'development db pass'
  redis: 'development redis pass'

  serviceSecret: 'development service secret'

staging:
  database: 'staging db pass'
  serviceSecret: 'staging service secret'

production:
  database: 'production db pass'
  serviceSecret: 'production service secret'
''';

void main() {
  group(
      'Given default password config when loading Map in runMode development then',
      () {
    const runMode = 'development';

    var passwords = PasswordManager(runMode: runMode)
        .loadPasswordsFromMap(loadYaml(_defaultPasswordConfig));

    test('passwords are not null', () {
      expect(passwords, isNotNull);
    });

    test('shared password matches expected value', () {
      expect(passwords['mySharedPassword'], 'my password');
    });

    test('database password matches expected value', () {
      expect(passwords['database'], 'development db pass');
    });
  });

  group(
      'Given default password config when loading Map in runMode production then',
      () {
    const runMode = 'production';

    var passwords = PasswordManager(runMode: runMode)
        .loadPasswordsFromMap(loadYaml(_defaultPasswordConfig));

    test('passwords are not null', () {
      expect(passwords, isNotNull);
    });

    test('shared password matches expected value', () {
      expect(passwords['mySharedPassword'], 'my password');
    });

    test('database password matches expected value', () {
      expect(passwords['database'], 'production db pass');
    });
  });

  group('Given an empty config when loading Map in runMode development then',
      () {
    const runMode = 'development';

    var passwords = PasswordManager(runMode: runMode).loadPasswordsFromMap({});

    test('passwords are not null', () {
      expect(passwords, isNotNull);
    });

    test('shared password is null', () {
      expect(passwords['mySharedPassword'], isNull);
    });

    test('database password matches expected value', () {
      expect(passwords['database'], isNull);
    });
  });

  group('Given a runMode that does not exist in the config file', () {
    var passwords = PasswordManager(runMode: 'unknown_run_mode')
        .loadPasswordsFromMap(loadYaml(_defaultPasswordConfig));
    test('then the shared password is set.', () {
      expect(passwords['mySharedPassword'], 'my password');
    });

    test('then the database password is null.', () {
      expect(passwords['database'], isNull);
    });
  });

  test('Given a config file with invalid nested data', () {
    var passwordsContent = '''
shared:
  mySharedPassword: 'my password'

development:
  database:
    host: 'localhost'
    password: 'development db pass'
''';

    var passwordManager = PasswordManager(runMode: 'development');

    expect(
      () => passwordManager.loadPasswordsFromMap(
        loadYaml(passwordsContent),
      ),
      throwsA(isA<StateError>()),
    );
  });

  group('Given an empty config file with all env passwords defined', () {
    var passwords =
        PasswordManager(runMode: 'development').loadPasswordsFromMap(
      {},
      environment: {
        'SERVERPOD_DATABASE_PASSWORD': 'password',
        'SERVERPOD_SERVICE_SECRET': 'secret',
        'SERVERPOD_REDIS_PASSWORD': 'redis',
      },
    );

    test('then the database password is set.', () {
      expect(passwords['database'], 'password');
    });

    test('then the service secret is set.', () {
      expect(passwords['serviceSecret'], 'secret');
    });

    test('then the redis password is set.', () {
      expect(passwords['redis'], 'redis');
    });

    test('then the shared password is null.', () {
      expect(passwords['mySharedPassword'], isNull);
    });
  });

  group('Given a config map and set environment variables', () {
    var databasePassword = const Uuid().v4();
    var serviceSecret = const Uuid().v4();
    var redisPassword = const Uuid().v4();

    var passwords =
        PasswordManager(runMode: 'development').loadPasswordsFromMap(
      loadYaml(_defaultPasswordConfig),
      environment: {
        'SERVERPOD_DATABASE_PASSWORD': databasePassword,
        'SERVERPOD_SERVICE_SECRET': serviceSecret,
        'SERVERPOD_REDIS_PASSWORD': redisPassword,
      },
    );

    test('then the database password is set from the env.', () {
      expect(passwords['database'], databasePassword);
    });

    test('then the service secret is set from the env.', () {
      expect(passwords['serviceSecret'], serviceSecret);
    });

    test('then the redis password is set from the env.', () {
      expect(passwords['redis'], redisPassword);
    });

    test('then the shared password is set.', () {
      expect(passwords['mySharedPassword'], 'my password');
    });
  });
}
