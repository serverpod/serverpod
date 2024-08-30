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

  group(
      'Given a reserved env variable when merging custom passwords then an ArgumentError is thrown for env',
      () {
    var passwordManager = PasswordManager(runMode: 'development');

    test('SERVERPOD_DATABASE_PASSWORD', () {
      expect(
        () => passwordManager.mergeCustomPasswords(
          [(envName: 'SERVERPOD_DATABASE_PASSWORD', alias: 'any')],
          {},
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('SERVERPOD_SERVICE_SECRET', () {
      expect(
        () => passwordManager.mergeCustomPasswords(
          [(envName: 'SERVERPOD_SERVICE_SECRET', alias: 'any')],
          {},
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('SERVERPOD_REDIS_PASSWORD', () {
      expect(
        () => passwordManager.mergeCustomPasswords(
          [(envName: 'SERVERPOD_REDIS_PASSWORD', alias: 'any')],
          {},
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group(
      'Given a reserved alias when merging custom passwords then an ArgumentError is thrown for ',
      () {
    var passwordManager = PasswordManager(runMode: 'development');

    test('database', () {
      expect(
        () => passwordManager.mergeCustomPasswords(
          [(envName: 'ANY_CUSTOM_ENV', alias: 'database')],
          {},
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('serviceSecret', () {
      expect(
        () => passwordManager.mergeCustomPasswords(
          [(envName: 'ANY_CUSTOM_ENV', alias: 'serviceSecret')],
          {},
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('redis', () {
      expect(
        () => passwordManager.mergeCustomPasswords(
          [(envName: 'ANY_CUSTOM_ENV', alias: 'redis')],
          {},
        ),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  test(
      'Given a custom password config and an environment variable then the env is loaded as the alias.',
      () {
    var passwordManager = PasswordManager(runMode: 'development');

    var passwords = passwordManager.mergeCustomPasswords(
      [(envName: 'CUSTOM_PASSWORD_1', alias: 'customPassword1')],
      {},
      environment: {
        'CUSTOM_PASSWORD_1': 'password1',
      },
    );

    expect(passwords['customPassword1'], 'password1');
  });

  test(
      'Given a custom password config and an existing password but no environment variable when merging the custom password then the existing password is loaded.',
      () {
    var passwordManager = PasswordManager(runMode: 'development');

    var passwords = passwordManager.mergeCustomPasswords(
      [(envName: 'CUSTOM_PASSWORD_1', alias: 'customPassword1')],
      {
        'customPassword1': 'default',
      },
      environment: {},
    );

    expect(passwords['customPassword1'], 'default');
  });

  test(
      'Given a custom password config and an existing password and an environment variable when merging the custom password then the env is loaded and override the existing password.',
      () {
    var passwordManager = PasswordManager(runMode: 'development');

    var passwords = passwordManager.mergeCustomPasswords(
      [(envName: 'CUSTOM_PASSWORD_1', alias: 'customPassword1')],
      {
        'customPassword1': 'default',
      },
      environment: {
        'CUSTOM_PASSWORD_1': 'password1',
      },
    );

    expect(passwords['customPassword1'], 'password1');
  });

  test(
      'Given a custom password config and an existing password and an environment variable when merging the custom password then the existing passwords are kept unmodified.',
      () {
    var passwordManager = PasswordManager(runMode: 'development');

    var passwords = passwordManager.mergeCustomPasswords(
      [(envName: 'CUSTOM_PASSWORD_1', alias: 'customPassword1')],
      {
        'database': 'password',
      },
      environment: {
        'CUSTOM_PASSWORD_1': 'password1',
      },
    );

    expect(passwords['database'], 'password');
  });
}
