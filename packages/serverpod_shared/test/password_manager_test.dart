import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';
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
      expect(passwords!['mySharedPassword'], 'my password');
    });

    test('database password matches expected value', () {
      expect(passwords!['database'], 'development db pass');
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
      expect(passwords!['mySharedPassword'], 'my password');
    });

    test('database password matches expected value', () {
      expect(passwords!['database'], 'production db pass');
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
      expect(passwords!['mySharedPassword'], isNull);
    });

    test('database password matches expected value', () {
      expect(passwords!['database'], isNull);
    });
  });
}
