import 'package:serverpod/serverpod.dart';
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
      await pod.start();
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test('when ValueEncoder instance is accessed '
        'then returns the ValueEncoder instance', () {
      expect(ValueEncoder.instance, isA<ValueEncoder>());
    });
  });
}

class _EmptyEndpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {}
}
