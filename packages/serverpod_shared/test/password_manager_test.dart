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
        () => passwordManager.mergePasswords(
          [(envName: 'SERVERPOD_DATABASE_PASSWORD', alias: 'any')],
          {},
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('SERVERPOD_SERVICE_SECRET', () {
      expect(
        () => passwordManager.mergePasswords(
          [(envName: 'SERVERPOD_SERVICE_SECRET', alias: 'any')],
          {},
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('SERVERPOD_REDIS_PASSWORD', () {
      expect(
        () => passwordManager.mergePasswords(
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
        () => passwordManager.mergePasswords(
          [(envName: 'ANY_CUSTOM_ENV', alias: 'database')],
          {},
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('serviceSecret', () {
      expect(
        () => passwordManager.mergePasswords(
          [(envName: 'ANY_CUSTOM_ENV', alias: 'serviceSecret')],
          {},
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('redis', () {
      expect(
        () => passwordManager.mergePasswords(
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

    var passwords = passwordManager.mergePasswords(
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

    var passwords = passwordManager.mergePasswords(
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

    var passwords = passwordManager.mergePasswords(
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

    var passwords = passwordManager.mergePasswords(
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

  test(
      'Given user-defined environment passwords when loading passwords then custom passwords are included',
      () {
    final passwords =
        PasswordManager(runMode: 'development').loadPasswordsFromMap(
      {},
      environment: {
        'SERVERPOD_PASSWORD_CUSTOM_1': 'custom1',
        'SERVERPOD_PASSWORD_CUSTOM_2': 'custom2',
      },
    );

    expect(passwords['CUSTOM_1'], 'custom1');
    expect(passwords['CUSTOM_2'], 'custom2');
  });

  test(
      'Given user-defined environment passwords when loading passwords then non-password environment variables are ignored',
      () {
    final passwords =
        PasswordManager(runMode: 'development').loadPasswordsFromMap(
      {},
      environment: {
        'SERVERPOD_PASSWORD_CUSTOM_1': 'custom1',
        'OTHER_ENV_VAR': 'other',
      },
    );

    expect(passwords['CUSTOM_1'], 'custom1');
    expect(passwords['OTHER_ENV_VAR'], isNull);
  });

  test(
      'Given user-defined environment passwords when loading passwords then custom passwords override config passwords',
      () {
    final passwords =
        PasswordManager(runMode: 'development').loadPasswordsFromMap(
      loadYaml('''
development:
  CUSTOM_1: 'config_value'
'''),
      environment: {
        'SERVERPOD_PASSWORD_CUSTOM_1': 'env_value',
      },
    );

    expect(passwords['CUSTOM_1'], 'env_value');
  });

  test(
      'Given user-defined environment passwords when loading passwords then custom passwords are merged with standard passwords',
      () {
    final passwords =
        PasswordManager(runMode: 'development').loadPasswordsFromMap(
      {},
      environment: {
        'SERVERPOD_DATABASE_PASSWORD': 'db_pass',
        'SERVERPOD_PASSWORD_CUSTOM_1': 'custom1',
      },
    );

    expect(passwords['database'], 'db_pass');
    expect(passwords['CUSTOM_1'], 'custom1');
  });

  test(
      'Given user-defined environment passwords when loading passwords then custom SERVERPOD_PASSWORD_ prefixed variables override built-in passwords',
      () {
    final passwords =
        PasswordManager(runMode: 'development').loadPasswordsFromMap(
      loadYaml(_defaultPasswordConfig),
      environment: {
        'SERVERPOD_DATABASE_PASSWORD': 'built_in_pass',
        'SERVERPOD_PASSWORD_database': 'custom_override_pass',
      },
    );

    expect(passwords['database'], 'custom_override_pass');
  });

  test(
      'Given user-defined environment passwords when loading passwords then environment variables with empty suffix are ignored',
      () {
    final passwords =
        PasswordManager(runMode: 'development').loadPasswordsFromMap(
      {},
      environment: {
        'SERVERPOD_PASSWORD_': 'empty_suffix',
        'SERVERPOD_PASSWORD_CUSTOM_1': 'custom1',
      },
    );

    expect(passwords[''], isNull);
    expect(passwords['CUSTOM_1'], 'custom1');
  });

  test(
      'Given user-defined environment passwords when loading passwords then environment variables with only prefix are ignored',
      () {
    final passwords =
        PasswordManager(runMode: 'development').loadPasswordsFromMap(
      {},
      environment: {
        'SERVERPOD_PASSWORD': 'only_prefix',
        'SERVERPOD_PASSWORD_CUSTOM_1': 'custom1',
      },
    );

    expect(passwords['SERVERPOD_PASSWORD'], isNull);
    expect(passwords['CUSTOM_1'], 'custom1');
  });
}
