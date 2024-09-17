import 'package:serverpod/serverpod.dart';

/// Internal test endpoints interface that contains implementation details
/// that should only be used internally by the test tools.
abstract interface class InternalTestEndpoints {
  /// Initializes the endpoints.
  void initialize(
    SerializationManagerServer serializationManager,
    EndpointDispatch endpoints,
  );
}

/// A serverpod session used internally by the test tools.
/// This is needed to modify the transaction which is not mutable on the [Session] base class.
class InternalServerpodSession extends Session {
  /// The transaction that is used by the session.
  @override
  Transaction? transaction;

  /// Creates a new internal serverpod session.
  InternalServerpodSession({
    required super.endpoint,
    required super.method,
    required super.server,
    required super.enableLogging,
    this.transaction,
  });
}

/// A facade for the real Serverpod instance.
class TestServerpod<T extends InternalTestEndpoints> {
  /// The test endpoints that are exposed to the user.
  T testEndpoints;

  final Serverpod _serverpod;

  /// Creates a new test serverpod instance.
  TestServerpod({
    required this.testEndpoints,
    required SerializationManagerServer serializationManager,
    required EndpointDispatch endpoints,
    String? runMode,
  }) : _serverpod = Serverpod(
          ['-m', runMode ?? ServerpodRunMode.test],
          serializationManager,
          endpoints,
        ) {
    endpoints.initializeEndpoints(_serverpod.server);
    testEndpoints.initialize(serializationManager, endpoints);
  }

  /// Starts the underlying serverpod instance.
  Future<void> start() async {
    await _serverpod.start();
  }

  /// Shuts down the underlying serverpod instance.
  Future<void> shutdown() async {
    return _serverpod.shutdown(exitProcess: false);
  }

  /// Creates a new Serverpod session.
  InternalServerpodSession createSession({
    bool enableLogging = false,
    Transaction? transaction,
    String endpoint = '',
    String method = '',
  }) {
    return InternalServerpodSession(
      server: _serverpod.server,
      enableLogging: enableLogging,
      endpoint: endpoint,
      method: method,
      transaction: transaction,
    );
  }
}
