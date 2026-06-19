import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';

import 'test_helpers/empty_endpoints.dart';

final _portZeroConfig = ServerConfig(
  port: 0,
  publicScheme: 'http',
  publicHost: 'localhost',
  publicPort: 0,
);

void main() {
  group('Given a Serverpod,', () {
    late Directory tempDir;
    late Serverpod pod;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('with_session_');
      pod = Serverpod(
        [],
        internal.Protocol(),
        EmptyEndpoints(),
        config: ServerpodConfig(
          apiServer: _portZeroConfig,
          webServer: _portZeroConfig,
          database: SqliteDatabaseConfig(
            filePath: p.join(tempDir.path, 'test.db'),
          ),
        ),
      );
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    group('when calling withSession with a callback that succeeds,', () {
      late Session? sessionUsedByCallback;
      late bool sessionWasClosed;
      late String result;

      setUp(() async {
        sessionUsedByCallback = null;
        sessionWasClosed = false;

        result = await pod.withSession((session) async {
          sessionUsedByCallback = session;
          session.addWillCloseListener((_) {
            sessionWasClosed = true;
          });
          return 'the result';
        });
      });

      test('then the callback is called with a session.', () {
        expect(sessionUsedByCallback, isNotNull);
      });

      test('then the returned value is the value produced by the callback.',
          () {
        expect(result, equals('the result'));
      });

      test('then the session is closed once the callback completes.', () {
        expect(sessionWasClosed, isTrue);
      });
    });

    group('when calling withSession with a callback that throws,', () {
      late bool sessionWasClosed;
      late Object caughtError;
      late Object? thrownError;

      setUp(() async {
        sessionWasClosed = false;
        caughtError = Exception('boom');
        thrownError = null;

        try {
          await pod.withSession((session) async {
            session.addWillCloseListener((_) {
              sessionWasClosed = true;
            });
            throw caughtError;
          });
        } catch (e) {
          thrownError = e;
        }
      });

      test('then the error from the callback is rethrown.', () {
        expect(thrownError, same(caughtError));
      });

      test('then the session is still closed.', () {
        expect(sessionWasClosed, isTrue);
      });
    });
  });
}
