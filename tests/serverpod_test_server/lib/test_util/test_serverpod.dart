import 'dart:io';

import 'package:serverpod/protocol.dart' as serverpod;
import 'package:serverpod/serverpod.dart';
// ignore: implementation_imports
import 'package:serverpod/src/server/serverpod.dart'
    show ServerpodInternalMethods;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
import 'package:serverpod_test_server/src/generated/endpoints.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

var _integrationTestMode =
    Platform.environment['INTEGRATION_TEST_SERVERPOD_MODE'] ?? 'production';

var _integrationTestFlags = ['-m', _integrationTestMode];

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
    final server = Serverpod(
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

    // Runtime settings persist in the serverpod_runtime_settings table
    // across tests in the same run. Without a reset, a test that calls
    // `server.updateRuntimeSettings(LogSettingsBuilder().withLoggingTurnedDown()...)`
    // leaves logLevel=fatal for every subsequent test, silently filtering
    // all log.warning / log.error output and breaking assertions in
    // unrelated tests (future_call_manager, broken_future_calls, ...).
    //
    // Register a reset hook so each test leaves a clean slate. addTearDown
    // is registered after the enclosing group's `tearDown(...)` block, so
    // it runs earlier in LIFO order - i.e. before the caller's explicit
    // `server.shutdown(...)` - while the session/pool are still live.
    //
    // If `create` is called at group-declaration time rather than inside
    // a test/setUp, `addTearDown` throws and there's no test-scoped place
    // to hang cleanup. Swallow that case: those tests don't touch
    // runtime settings themselves (websockets/*), so nothing pollutes.
    try {
      addTearDown(() async {
        try {
          await server.internalSession.db.unsafeExecute(
            'DELETE FROM serverpod_runtime_settings',
          );
        } catch (_) {
          // Server or pool may already be gone; nothing to clean up.
        }
      });
    } on StateError {
      // Called outside a running test (group declaration time). Skip.
    }

    return server;
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
    DatabaseSerializationManager serializationManager,
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
