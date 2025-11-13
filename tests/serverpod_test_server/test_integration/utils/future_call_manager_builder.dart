import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/future_call_manager/future_call_diagnostics_service.dart';
import 'package:serverpod/src/server/future_call_manager/future_call_manager.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

import '../test_tools/serverpod_test_tools.dart';

export 'package:serverpod/src/server/future_call_manager/future_call_manager.dart';

class FutureCallManagerBuilder {
  FutureCallSessionBuilder _sessionBuilder;

  Session _internalSession;

  InitializeFutureCall _initializeFutureCall =
      (
        FutureCall futureCall,
        String name,
      ) {
        // Skip initialization
      };

  FutureCallConfig _config = FutureCallConfig(
    concurrencyLimit: 1,
    scanInterval: const Duration(milliseconds: 10),
  );

  Protocol _protocol = Protocol();

  FutureCallDiagnosticsService _diagnosticsService = _MockDiagnosticsService();

  FutureCallManagerBuilder({
    required FutureCallSessionBuilder sessionProvider,
    required Session internalSession,
  }) : _sessionBuilder = sessionProvider,
       _internalSession = internalSession;

  factory FutureCallManagerBuilder.fromTestSessionBuilder(
    TestSessionBuilder sessionBuilder,
  ) {
    return FutureCallManagerBuilder(
      sessionProvider: (String futureCallName) => sessionBuilder.build(),
      internalSession: sessionBuilder.build(),
    );
  }

  FutureCallManager build() => FutureCallManager(
    _config,
    _protocol,
    diagnosticsService: _diagnosticsService,
    internalSession: _internalSession,
    sessionProvider: _sessionBuilder,
    initializeFutureCall: _initializeFutureCall,
  );

  FutureCallManagerBuilder withConfig(FutureCallConfig config) {
    _config = config;
    return this;
  }

  FutureCallManagerBuilder withDiagnosticsService(
    FutureCallDiagnosticsService diagnosticsService,
  ) {
    _diagnosticsService = diagnosticsService;
    return this;
  }

  FutureCallManagerBuilder withInitializeFutureCall(
    InitializeFutureCall initializeFutureCall,
  ) {
    _initializeFutureCall = initializeFutureCall;
    return this;
  }

  FutureCallManagerBuilder withInternalSession(
    Session internalSession,
  ) {
    _internalSession = internalSession;
    return this;
  }

  FutureCallManagerBuilder withProtocol(Protocol protocol) {
    _protocol = protocol;
    return this;
  }

  FutureCallManagerBuilder withSessionProvider(
    FutureCallSessionBuilder sessionProvider,
  ) {
    _sessionBuilder = sessionProvider;
    return this;
  }
}

class _MockDiagnosticsService implements FutureCallDiagnosticsService {
  @override
  void submitCallException(
    Object error,
    StackTrace stackTrace, {
    required Session session,
  }) {
    throw StateError('Diagnostics service not implemented');
  }

  @override
  void submitFrameworkException(
    Object error,
    StackTrace stackTrace, {
    String? message,
  }) {
    throw StateError('Diagnostics service not implemented');
  }
}
