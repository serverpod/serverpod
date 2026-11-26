import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';

import 'test_helpers/empty_endpoints.dart';

/// Regression coverage for https://github.com/serverpod/serverpod/issues/5944:
/// with `exitProcessOnInitializationError: false`, a construction failure is
/// rethrown to the caller instead of terminating the process, so an embedded
/// host can catch the error and run its own cleanup.
void main() {
  group('Given a server package with a malformed passwords.yaml', () {
    late Directory tempServerDir;

    setUp(() async {
      tempServerDir = await Directory.systemTemp.createTemp('sp_ctor_');
      final configDir = Directory(p.join(tempServerDir.path, 'config'))
        ..createSync(recursive: true);
      File(p.join(configDir.path, 'development.yaml')).writeAsStringSync('''
apiServer:
  port: 0
  publicHost: localhost
  publicPort: 0
  publicScheme: http
''');
      // A YAML sequence where a map is expected makes
      // PasswordManager.loadPasswords throw before `start()` is reached.
      File(p.join(configDir.path, 'passwords.yaml')).writeAsStringSync(
        'shared: [this-is-not-a-map]\n',
      );
    });

    tearDown(() async {
      try {
        tempServerDir.deleteSync(recursive: true);
      } on FileSystemException {
        // Best effort.
      }
    });

    test(
      'when constructed with exitProcessOnInitializationError: false, '
      'the error is thrown to the caller and construction cannot return '
      'a half-initialized instance',
      () async {
        var finallyRan = false;

        await expectLater(
          () async {
            try {
              final pod = Serverpod(
                [],
                internal.Protocol(),
                EmptyEndpoints(),
                serverDirectory: tempServerDir,
                exitProcessOnInitializationError: false,
              );
              fail('Construction should have thrown, got $pod');
            } finally {
              finallyRan = true;
            }
          }(),
          throwsA(isA<Object>()),
        );

        expect(finallyRan, isTrue);
      },
    );
  });
}
