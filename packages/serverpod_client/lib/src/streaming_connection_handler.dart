import 'dart:async';

import 'serverpod_client_shared.dart';

/// Represents the state of the connection handler.
class StreamingConnectionHandlerState {
  /// Time in seconds until next connection attempt. Only set if the connection
  /// [status] is StreaminConnectionStatus.waitingToRetry.
  final int? retryInSeconds;

  /// The status of the connection.
  final StreamingConnectionStatus status;

  StreamingConnectionHandlerState._({
    required this.retryInSeconds,
    required this.status,
  });
}

/// The StreamingConnection handler manages the web socket connection and its
/// state. It will automatically reconnect to the server if the connection is
/// lost. The [listener] will be notfied whenever the connection state changes
/// and once every second when counting down to reconnect. The time between
/// reconnection attempts is specified with [retryEverySeconds], default is 5
/// seconds.
class StreamingConnectionHandler {
  /// The Serverpod client this StremingConnectionHandler is managing.
  final ServerpodClientShared client;

  /// Time in seconds between connection attempts. Default is 5 seconds.
  final int retryEverySeconds;

  /// A listener that is called whenever the state of the connection handler
  /// changes.
  final void Function(StreamingConnectionHandlerState state) listener;

  late bool _keepAlive;
  int _countdown = 0;
  Timer? _countdownTimer;

  /// Creates a new connection handler with the specified listener and interval
  /// for reconnecting to the server.
  StreamingConnectionHandler({
    required this.client,
    required this.listener,
    this.retryEverySeconds = 5,
  }) {
    _keepAlive = client.streamingConnectionStatus !=
        StreamingConnectionStatus.disconnected;
    client.addStreamingConnectionStatusListener(_onConnectionStatusChanged);
  }

  /// Disposes the connection handler, but does not close the connection.
  void dispose() {
    client.addStreamingConnectionStatusListener(_onConnectionStatusChanged);
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  /// Opens a web socket channel to the server and attempts to keep it alive.
  void connect() {
    _keepAlive = true;
    if (client.streamingConnectionStatus ==
        StreamingConnectionStatus.disconnected) {
      client.openStreamingConnection();
    }
  }

  /// Disconnects the streaming connection if it is open.
  void close() {
    _keepAlive = false;
    client.closeStreamingConnection();
  }

  void _onConnectionStatusChanged() {
    if (client.streamingConnectionStatus ==
        StreamingConnectionStatus.connected) {
      _countdown = 0;
      listener(StreamingConnectionHandlerState._(
        status: StreamingConnectionStatus.connected,
        retryInSeconds: null,
      ));
    } else if (client.streamingConnectionStatus ==
        StreamingConnectionStatus.connecting) {
      _countdown = 0;
      listener(StreamingConnectionHandlerState._(
        status: StreamingConnectionStatus.connecting,
        retryInSeconds: null,
      ));
    } else {
      if (_keepAlive) {
        _countdown = retryEverySeconds;
        listener(StreamingConnectionHandlerState._(
          status: StreamingConnectionStatus.waitingToRetry,
          retryInSeconds: _countdown,
        ));
        // Make sure we're only running one timer.
        _countdownTimer?.cancel();
        _countdownTimer = null;

        _countdownTimer = Timer(
          const Duration(seconds: 1),
          _onCountDown,
        );
      } else {
        _countdown = 0;
        listener(StreamingConnectionHandlerState._(
          status: StreamingConnectionStatus.disconnected,
          retryInSeconds: null,
        ));
      }
    }
  }

  void _onCountDown() {
    _countdown -= 1;
    if (_countdown > 0) {
      // Countdown.
      listener(StreamingConnectionHandlerState._(
        status: StreamingConnectionStatus.waitingToRetry,
        retryInSeconds: _countdown,
      ));
    } else {
      // Try to reconnect.
      client.openStreamingConnection();
    }

    _countdownTimer = Timer(const Duration(seconds: 1), _onCountDown);
  }

  /// Returns the current status of the connection.
  StreamingConnectionHandlerState get status {
    if (client.streamingConnectionStatus ==
        StreamingConnectionStatus.connected) {
      return StreamingConnectionHandlerState._(
        status: StreamingConnectionStatus.connected,
        retryInSeconds: null,
      );
    } else if (client.streamingConnectionStatus ==
        StreamingConnectionStatus.connecting) {
      return StreamingConnectionHandlerState._(
        status: StreamingConnectionStatus.connecting,
        retryInSeconds: null,
      );
    } else {
      if (_keepAlive) {
        return StreamingConnectionHandlerState._(
          status: StreamingConnectionStatus.waitingToRetry,
          retryInSeconds: _countdown,
        );
      } else {
        return StreamingConnectionHandlerState._(
          status: StreamingConnectionStatus.disconnected,
          retryInSeconds: null,
        );
      }
    }
  }
}
