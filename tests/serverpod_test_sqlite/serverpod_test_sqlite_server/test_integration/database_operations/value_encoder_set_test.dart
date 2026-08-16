import 'package:serverpod/serverpod.dart';
import 'package:serverpod_database/src/adapters/sqlite/value_encoder.dart';
import 'package:serverpod/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  test('Given no database is created '
      'when ValueEncoder instance is accessed '
      'then throws StateError', () {
    expect(
      () => ValueEncoder.instance,
      throwsA(
        isA<StateError>().having(
          (e) => e.message,
          'message',
          'Encoder not available. No Database has been created.',
        ),
      ),
    );
  });

  group('Given a Serverpod instance with no database configured', () {
    late final pod = Serverpod(
      [],
      Protocol(),
      _EmptyEndpoints(),
      config: ServerpodConfig(
        apiServer: ServerConfig(
          port: 0,
          publicScheme: 'http',
          publicHost: 'localhost',
          publicPort: 0,
        ),
      ),
    );

    setUp(() async {
      await pod.start();
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('when ValueEncoder instance is accessed '
        'then throws StateError', () {
      expect(
        () => ValueEncoder.instance,
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            'Encoder not available. No Database has been created.',
          ),
        ),
      );
    });
  });

  group('Given a Serverpod instance with a database configured', () {
    late final pod = Serverpod(
      [],
      Protocol(),
      _EmptyEndpoints(),
      config: ServerpodConfig(
        // Must match config/*.yaml `database.filePath` (under sqlite_data/).
        // A bare `serverpod_test_prod.db` resolves to the package root; Docker
        // only clears sqlite_data/*.db*, so WAL files beside the root file could
        // go stale and trigger SqliteException "database disk image is malformed".
        database: SqliteDatabaseConfig(
          filePath: 'sqlite_data/serverpod_test_prod.db',
        ),
        apiServer: ServerConfig(
          port: 0,
          publicScheme: 'http',
          publicHost: 'localhost',
          publicPort: 0,
        ),
      ),
    );

    setUp(() async {
      await pod.start();
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('when ValueEncoder instance is accessed '
        'then returns the SqliteValueEncoder instance', () {
      expect(ValueEncoder.instance, isA<SqliteValueEncoder>());
    });
  });
}

class _EmptyEndpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {}
}
