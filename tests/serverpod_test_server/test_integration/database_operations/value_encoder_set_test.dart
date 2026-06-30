import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart';
import 'package:serverpod_database/src/adapters/postgres/value_encoder.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
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
    // A minimal server with no database: starting it must not create a pool, so
    // the encoder stays unavailable. Start it directly rather than via
    // IntegrationTestServer.start, which would provision a database.
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
    late final pod = IntegrationTestServer.create(
      config: ServerpodConfig(
        database: DatabaseConfig(
          host: 'postgres',
          port: 5432,
          name: 'serverpod_test',
          user: 'postgres',
          password: 'password',
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
      await IntegrationTestServer.start(pod);
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('when ValueEncoder instance is accessed '
        'then returns the PostgresValueEncoder instance', () {
      expect(ValueEncoder.instance, isA<PostgresValueEncoder>());
    });
  });
}

class _EmptyEndpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {}
}
