import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';

import 'test_helpers/empty_endpoints.dart';

final portZeroConfig = ServerConfig(
  port: 0,
  publicScheme: 'http',
  publicHost: 'localhost',
  publicPort: 0,
);

class _InterceptedDatabase implements Database {
  _InterceptedDatabase(this.inner);

  final Database inner;

  @override
  DatabaseAnalyzer get analyzer => inner.analyzer;

  @override
  DatabaseDialect get dialect => inner.dialect;

  @override
  DatabaseSerializationManager get serializationManager =>
      inner.serializationManager;

  @override
  Future<bool> testConnection() => inner.testConnection();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late Directory tempDir;
  late String databasePath;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('database_interceptor_');
    databasePath = p.join(tempDir.path, 'test.db');
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group(
    'Given a Serverpod with a database interceptor,',
    () {
      late Serverpod pod;
      late int interceptorCallCount;
      late Session? interceptedSession;
      late Database? interceptedInner;
      late _InterceptedDatabase interceptedDatabase;

      setUp(() {
        interceptorCallCount = 0;
        interceptedSession = null;
        interceptedInner = null;

        pod = Serverpod(
          [],
          internal.Protocol(),
          EmptyEndpoints(),
          config: ServerpodConfig(
            apiServer: portZeroConfig,
            webServer: portZeroConfig,
            database: SqliteDatabaseConfig(filePath: databasePath),
          ),
          databaseInterceptor: (session, inner) {
            interceptorCallCount++;
            interceptedSession = session;
            interceptedInner = inner;
            interceptedDatabase = _InterceptedDatabase(inner);
            return interceptedDatabase;
          },
        );
        interceptorCallCount = 0;
      });

      tearDown(() async {
        await pod.shutdown(exitProcess: false);
      });

      group('when creating a session,', () {
        late Session session;

        setUp(() async {
          session = await pod.createSession();
        });

        test(
          'then the interceptor is called once with the session and inner database.',
          () {
            expect(interceptorCallCount, equals(1));
            expect(identical(interceptedSession, session), isTrue);
            expect(interceptedInner, isA<Database>());
          },
        );

        test('then session.db returns the intercepted database instance.', () {
          expect(session.db, same(interceptedDatabase));
        });

        test(
          'then repeated access to session.db returns the same instance.',
          () {
            expect(identical(session.db, session.db), isTrue);
          },
        );
      });
    },
  );

  group(
    'Given a Serverpod without a database interceptor,',
    () {
      late Serverpod pod;

      setUp(() {
        pod = Serverpod(
          [],
          internal.Protocol(),
          EmptyEndpoints(),
          config: ServerpodConfig(
            apiServer: portZeroConfig,
            webServer: portZeroConfig,
            database: SqliteDatabaseConfig(filePath: databasePath),
          ),
        );
      });

      tearDown(() async {
        await pod.shutdown(exitProcess: false);
      });

      group('when creating a session,', () {
        late Session session;

        setUp(() async {
          session = await pod.createSession();
        });

        test('then session.db returns the framework database unchanged.', () {
          expect(session.db, isNot(isA<_InterceptedDatabase>()));
        });
      });
    },
  );

  group(
    'Given a Serverpod with a database interceptor,',
    () {
      late Serverpod pod;
      late int interceptorCallCount;

      setUp(() {
        interceptorCallCount = 0;

        pod = Serverpod(
          [],
          internal.Protocol(),
          EmptyEndpoints(),
          config: ServerpodConfig(
            apiServer: portZeroConfig,
            webServer: portZeroConfig,
            database: SqliteDatabaseConfig(filePath: databasePath),
          ),
          databaseInterceptor: (session, inner) {
            interceptorCallCount++;
            return _InterceptedDatabase(inner);
          },
        );
        interceptorCallCount = 0;
      });

      tearDown(() async {
        await pod.shutdown(exitProcess: false);
      });

      group('when creating multiple sessions,', () {
        setUp(() async {
          await pod.createSession();
          await pod.createSession();
        });

        test('then the interceptor is called once per session.', () {
          expect(interceptorCallCount, equals(2));
        });
      });
    },
  );
}
