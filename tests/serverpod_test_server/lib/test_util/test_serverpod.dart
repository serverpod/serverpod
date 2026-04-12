import 'dart:io';

import 'package:serverpod/protocol.dart' as serverpod;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
import 'package:serverpod_test_server/src/generated/endpoints.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

var _integrationTestMode =
    Platform.environment['INTEGRATION_TEST_SERVERPOD_MODE'] ?? 'production';

var _integrationTestFlags = ['-m', _integrationTestMode, '--logging', 'normal'];

class IntegrationTestServer extends TestServerpod {
  IntegrationTestServer({
    ServerpodConfig? config,
    RuntimeParametersListBuilder? runtimeParametersBuilder,
  }) : super(
         _integrationTestFlags,
         Protocol(),
         Endpoints(),
         config: config,
         runtimeParametersBuilder: runtimeParametersBuilder,
       );

  static Serverpod create({
    ServerpodConfig? config,
    AuthenticationHandler? authenticationHandler,
    SecurityContextConfig? securityContextConfig,
    ExperimentalFeatures? experimentalFeatures,
    RuntimeParametersListBuilder? runtimeParametersBuilder,
  }) {
    return Serverpod(
      _integrationTestFlags,
      Protocol(),
      Endpoints(),
      config: config,
      authenticationHandler:
          authenticationHandler ?? auth.authenticationHandler,
      securityContextConfig: securityContextConfig,
      experimentalFeatures: experimentalFeatures,
      runtimeParametersBuilder: runtimeParametersBuilder,
    );
  }

  static Future<void> applyMigrations({ServerpodConfig? config}) async {
    final server = Serverpod(
      [..._integrationTestFlags, '--apply-migrations', '--role', 'maintenance'],
      Protocol(),
      Endpoints(),
      config: config,
    );
    try {
      await server.start(runInGuardedZone: false);
    } catch (e) {
      if (e.runtimeType.toString() == 'ExitException') {
        final exitCode = (e as dynamic).exitCode;
        if (exitCode != 0) {
          throw Exception(
            'Migrations failed with ExitException($exitCode): ${(e as dynamic).message}',
          );
        }
      } else {
        rethrow;
      }
    } finally {
      // Must explicitly shutdown Serverpod to release Postgres connections
      // since the maintenance role bypasses standard shutdown hooks.
      await server.shutdown(exitProcess: false);
    }
  }
}

class TestServerpod {
  static final Finalizer<Session> _sessionFinalizer = Finalizer(
    (session) async => await session.close(),
  );

  late final Serverpod _serverpod;

  late final Session _session;

  TestServerpod(
    List<String> args,
    SerializationManagerServer serializationManager,
    EndpointDispatch endpoints, {
    ServerpodConfig? config,
    RuntimeParametersListBuilder? runtimeParametersBuilder,
  }) {
    _serverpod = Serverpod(
      args,
      serializationManager,
      endpoints,
      config: config,
      authenticationHandler: auth.authenticationHandler,
      runtimeParametersBuilder: runtimeParametersBuilder,
    );
  }

  Future<void> updateRuntimeSettings(serverpod.RuntimeSettings settings) async {
    await _serverpod.updateRuntimeSettings(settings);
  }

  Future<Session> session() async {
    _session = await _serverpod.createSession();
    _sessionFinalizer.attach(this, _session, detach: this);
    return _session;
  }
}
