import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// A minimal stand-in for a Redis server, speaking just enough RESP to drive
/// [RedisController] in tests.
///
/// Its purpose is control over *when* a subscription is confirmed. A real Redis
/// confirms so fast that a controller which never waits for the confirmation
/// still passes, which makes the wait itself untestable against a real server.
class FakeRedisServer {
  final ServerSocket _socketServer;
  final List<Socket> _connections = [];
  final List<_HeldConfirmation> _held = [];
  final Map<String, Set<Socket>> _subscribers = {};

  /// Every command received so far, in arrival order.
  final List<List<String>> receivedCommands = [];
  final StreamController<List<String>> _commands =
      StreamController<List<String>>.broadcast();

  /// When true, `SUBSCRIBE` and `UNSUBSCRIBE` are received and acknowledged in
  /// the test's own time via [releaseHeldConfirmations], rather than at once.
  bool holdConfirmations = false;

  FakeRedisServer._(this._socketServer) {
    _socketServer.listen(_handleConnection);
  }

  static Future<FakeRedisServer> start() async {
    var socketServer = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    return FakeRedisServer._(socketServer);
  }

  int get port => _socketServer.port;

  /// Every command the server has received, as its RESP arguments.
  Stream<List<String>> get commands => _commands.stream;

  /// Completes once a command named [name] has been received.
  Future<List<String>> nextCommand(String name) => commands.firstWhere(
    (command) => command.first.toUpperCase() == name.toUpperCase(),
  );

  /// Acknowledges everything withheld while [holdConfirmations] was set.
  void releaseHeldConfirmations() {
    for (var confirmation in _held) {
      _writeConfirmation(
        confirmation.socket,
        confirmation.kind,
        confirmation.channel,
      );
    }
    _held.clear();
  }

  /// Pushes a message to everyone subscribed to [channel], the way a real
  /// server does when another client publishes.
  void deliverMessage(String channel, String data) {
    for (var socket in _subscribers[channel] ?? <Socket>{}) {
      socket.add(
        utf8.encode(
          '*3\r\n'
          '\$7\r\nmessage\r\n'
          '\$${channel.length}\r\n$channel\r\n'
          '\$${data.length}\r\n$data\r\n',
        ),
      );
    }
  }

  /// Drops every open connection, as an unresponsive server or a network
  /// failure would.
  Future<void> dropConnections() async {
    var connections = List.of(_connections);
    _connections.clear();
    _held.clear();
    _subscribers.clear();
    for (var connection in connections) {
      await connection.close();
    }
  }

  Future<void> close() async {
    await dropConnections();
    await _socketServer.close();
    await _commands.close();
  }

  void _handleConnection(Socket socket) {
    _connections.add(socket);

    var buffer = <int>[];
    socket.listen(
      (data) {
        buffer.addAll(data);

        for (
          var command = _takeCommand(buffer);
          command != null;
          command = _takeCommand(buffer)
        ) {
          _handleCommand(socket, command);
        }
      },
      onDone: () => _connections.remove(socket),
      onError: (_) => _connections.remove(socket),
      cancelOnError: true,
    );
  }

  void _handleCommand(Socket socket, List<String> command) {
    receivedCommands.add(command);
    _commands.add(command);

    var name = command.first.toUpperCase();
    switch (name) {
      case 'SUBSCRIBE':
      case 'UNSUBSCRIBE':
        var kind = name.toLowerCase();
        var channel = command[1];
        if (name == 'SUBSCRIBE') {
          _subscribers.putIfAbsent(channel, () => {}).add(socket);
        } else {
          _subscribers[channel]?.remove(socket);
        }
        if (holdConfirmations) {
          _held.add(_HeldConfirmation(socket, kind, channel));
        } else {
          _writeConfirmation(socket, kind, channel);
        }
      case 'PING':
        socket.add(utf8.encode('+PONG\r\n'));
      case 'PUBLISH':
        // Reply shape of a real PUBLISH: the number of clients that got it.
        socket.add(utf8.encode(':0\r\n'));
      default:
        socket.add(utf8.encode('+OK\r\n'));
    }
  }

  void _writeConfirmation(Socket socket, String kind, String channel) {
    socket.add(
      utf8.encode(
        '*3\r\n'
        '\$${kind.length}\r\n$kind\r\n'
        '\$${channel.length}\r\n$channel\r\n'
        ':1\r\n',
      ),
    );
  }

  /// Removes and returns the next complete RESP command in [buffer], or null
  /// while it still holds only a partial one.
  List<String>? _takeCommand(List<int> buffer) {
    if (buffer.isEmpty || buffer.first != 0x2a /* '*' */ ) return null;

    var position = 0;

    String? takeLine() {
      for (var i = position; i + 1 < buffer.length; i++) {
        if (buffer[i] == 0x0d /* CR */ && buffer[i + 1] == 0x0a /* LF */ ) {
          var line = utf8.decode(buffer.sublist(position, i));
          position = i + 2;
          return line;
        }
      }
      return null;
    }

    var header = takeLine();
    if (header == null) return null;

    var argumentCount = int.parse(header.substring(1));
    var arguments = <String>[];
    for (var i = 0; i < argumentCount; i++) {
      var lengthLine = takeLine();
      if (lengthLine == null) return null;

      var length = int.parse(lengthLine.substring(1));
      if (buffer.length < position + length + 2) return null;

      arguments.add(utf8.decode(buffer.sublist(position, position + length)));
      position += length + 2;
    }

    buffer.removeRange(0, position);
    return arguments;
  }
}

class _HeldConfirmation {
  final Socket socket;
  final String kind;
  final String channel;

  _HeldConfirmation(this.socket, this.kind, this.channel);
}
