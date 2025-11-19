// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:serverpod_client/serverpod_client.dart';
import 'package:test/test.dart';

import 'test_utils/test_serverpod_client.dart';

/// Mock client that allows us to manually control connection status.
class MockServerpodClient extends TestServerpodClient {
  StreamingConnectionStatus _status = StreamingConnectionStatus.disconnected;
  final List<VoidCallback> _listeners = [];
  int openConnectionCallCount = 0;

  MockServerpodClient()
    : super(
        host: Uri.parse('http://localhost:8080'),
      );

  @override
  StreamingConnectionStatus get streamingConnectionStatus => _status;

  @override
  void addStreamingConnectionStatusListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeStreamingConnectionStatusListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  /// Simulate a connection status change.
  void simulateConnectionStatusChange(StreamingConnectionStatus newStatus) {
    _status = newStatus;
    for (var listener in _listeners) {
      listener();
    }
  }

  @override
  Future<void> openStreamingConnection({
    bool disconnectOnLostInternetConnection = true,
  }) async {
    openConnectionCallCount++;
    // Simulate connection attempt
    await Future.delayed(const Duration(milliseconds: 10));
    simulateConnectionStatusChange(StreamingConnectionStatus.connecting);
    await Future.delayed(const Duration(milliseconds: 10));
    simulateConnectionStatusChange(StreamingConnectionStatus.connected);
  }

  @override
  Future<void> closeStreamingConnection() async {
    simulateConnectionStatusChange(StreamingConnectionStatus.disconnected);
  }
}

void main() {
  const retryEverySeconds = 1;
  late MockServerpodClient client;
  late StreamingConnectionHandler handler;
  late List<StreamingConnectionHandlerState> receivedStates;

  setUp(() {
    client = MockServerpodClient();
    receivedStates = [];
  });

  tearDown(() {
    handler.dispose();
  });

  test('Given StreamingConnectionHandler '
      'when transitioning to connected status during countdown '
      'then timer is cancelled and old timer does not fire', () async {
    handler = StreamingConnectionHandler(
      client: client,
      listener: (state) => receivedStates.add(state),
      retryEverySeconds: retryEverySeconds,
    );
    handler.connect();

    // Establish connection then disconnect to start countdown
    client.simulateConnectionStatusChange(StreamingConnectionStatus.connected);
    await Future.delayed(const Duration(milliseconds: 100));

    client.simulateConnectionStatusChange(
      StreamingConnectionStatus.disconnected,
    );
    await Future.delayed(const Duration(milliseconds: 100));

    // Verify countdown started
    expect(
      receivedStates.any(
        (s) => s.status == StreamingConnectionStatus.waitingToRetry,
      ),
      isTrue,
    );

    var openConnectCallCountBeforeReconnect = client.openConnectionCallCount;

    // Reconnect during countdown (before it reaches 0)
    client.simulateConnectionStatusChange(StreamingConnectionStatus.connected);
    await Future.delayed(const Duration(milliseconds: 100));

    // Wait long enough for the old timer to have fired if it wasn't cancelled
    // Wait for the configured retry duration plus a small buffer of 100ms
    await Future.delayed(
      const Duration(milliseconds: (retryEverySeconds * 1000) + 100),
    );

    // If the timer wasn't cancelled, openStreamingConnection would be called
    // by the old timer callback
    expect(
      client.openConnectionCallCount,
      equals(openConnectCallCountBeforeReconnect),
      reason: 'Expected open connection call count to remain the same',
    );
  });
}
