import 'package:serverpod/serverpod.dart' show Session;
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() {
  late Session session;
  setUpAll(() async {
    session = await IntegrationTestServer().session();
  });
  tearDownAll(() => session.close());

  test(
    'Given a Postgres database, '
    'when watching a raw SQL query, '
    'then an UnsupportedError is thrown.',
    () {
      expect(
        () => session.db.unsafeWatch('SELECT 1;'),
        throwsA(
          isA<UnsupportedError>().having(
            (error) => error.message,
            'message',
            'Database.unsafeWatch is not supported on PostgreSQL.',
          ),
        ),
      );
    },
  );

  test(
    'Given a Postgres database, '
    'when watching a typed query, '
    'then an UnsupportedError is thrown.',
    () {
      expect(
        () => session.db.watch<SimpleData>(),
        throwsA(
          isA<UnsupportedError>().having(
            (error) => error.message,
            'message',
            'Database.watch is not supported on PostgreSQL.',
          ),
        ),
      );
    },
  );

  test(
    'Given a Postgres database, '
    'when watching through the generated repository, '
    'then an UnsupportedError is thrown.',
    () {
      expect(
        () => SimpleData.db.watch(session),
        throwsA(
          isA<UnsupportedError>().having(
            (error) => error.message,
            'message',
            'Database.watch is not supported on PostgreSQL.',
          ),
        ),
      );
    },
  );
}
