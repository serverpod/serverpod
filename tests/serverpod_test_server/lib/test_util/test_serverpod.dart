import 'package:serverpod/protocol.dart' as serverpod;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
import 'package:serverpod_test_server/src/generated/endpoints.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

const _integrationTestFlags = ['-m', 'production'];

class IntegrationTestServer extends TestServerpod {
  IntegrationTestServer()
      : super(
          _integrationTestFlags,
          Protocol(),
          Endpoints(),
        );

  static Serverpod create({ServerpodConfig? config}) {
    return Serverpod(
      _integrationTestFlags,
      Protocol(),
      Endpoints(),
      config: config,
      authenticationHandler: auth.authenticationHandler,
    );
  }
}

class TestServerpod {
  static final Finalizer<Serverpod> _serverpodFinalizer = Finalizer(
      (serverpod) async => await serverpod.shutdown(exitProcess: false));

  static final Finalizer<Session> _sessionFinalizer =
      Finalizer((session) async => await session.close());

  late final Serverpod _serverpod;

  late final Session _session;

  TestServerpod(
    List<String> args,
    SerializationManagerServer serializationManager,
    EndpointDispatch endpoints,
  ) {
    _serverpod = Serverpod(
      args,
      serializationManager,
      endpoints,
      authenticationHandler: auth.authenticationHandler,
    );

    _serverpodFinalizer.attach(this, _serverpod, detach: this);
  }

  Future<void> updateRuntimeSettings(serverpod.RuntimeSettings settings) async {
    await _serverpod.updateRuntimeSettings(settings);
  }

  Future<Session> session() async {
    await _serverpod.start();
    _session = await _serverpod.createSession();
    _sessionFinalizer.attach(this, _session, detach: this);
    return _session;
  }
}
