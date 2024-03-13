import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/endpoints.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class IntegrationTestServer extends TestServerpod {
  IntegrationTestServer()
      : super(
          ['-m', 'production'],
          Protocol(),
          Endpoints(),
        );
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
    _serverpod = Serverpod(args, serializationManager, endpoints);

    _serverpodFinalizer.attach(this, _serverpod, detach: this);
  }

  Future<Session> session() async {
    await _serverpod.start();
    _session = await _serverpod.createSession();
    _sessionFinalizer.attach(this, _session, detach: this);
    return _session;
  }
}
