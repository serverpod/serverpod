import 'dart:async';
import 'dart:io';

import 'package:redis/redis.dart';
import 'package:serverpod_shared/log.dart';

/// Callback when messages are received on a specific channel from Redis.
typedef RedisSubscriptionCallback =
    void Function(String channel, String message);

/// A type alias for the [Command] class from the `redis` package.
///
/// Use this to call custom Redis commands via [RedisCommand.send_object] or
/// other methods from the `redis` package.
typedef RedisCommand = Command;

/// The [RedisController] maintains an active connection to the Redis server. It
/// handles caching, publishing, and subscriptions of strings. If the connection
/// is broken the controller automatically tries to reconnect. Messages sent
/// across Redis are best effort and not guaranteed to be delivered, if a
/// message fails to be sent it will not retry.
class RedisController {
  /// The host of the Redis server.
  final String host;

  /// The port of the Redis server.
  final int port;

  /// The user name if the Redis server requires it.
  final String? user;

  /// The password of the Redis server. Not required, but recommended.
  final String? password;

  /// require ssl
  final bool requireSsl;

  /// Maximum time to wait while opening the TCP/TLS connection to Redis.
  ///
  /// After this duration, the attempt fails with [TimeoutException] instead of
  /// relying on OS-level connect timeouts (which can be very long when traffic
  /// is dropped).
  final Duration connectTimeout;

  final Map<String, RedisSubscriptionCallback> _subscriptions = {};

  /// `SUBSCRIBE` commands that Redis has not confirmed yet, keyed by channel.
  final Map<String, List<_PendingConfirmation>> _pendingSubscribes = {};

  /// `UNSUBSCRIBE` commands that Redis has not confirmed yet, keyed by channel.
  final Map<String, List<_PendingConfirmation>> _pendingUnsubscribes = {};

  /// Backstop for how long to wait for Redis to confirm a subscription change.
  /// A broken connection resolves the pending commands through
  /// [_invalidatePubSub] well before this elapses.
  static const _subscriptionConfirmationTimeout = Duration(seconds: 10);

  Command? _command;
  bool _connecting = false;

  Command? _pubSubCommand;
  bool _connectingPubSub = false;
  PubSub? _pubSub;

  bool _running = true;

  /// Creates a new RedisController with the provided connection details.
  RedisController({
    required this.host,
    required this.port,
    required this.requireSsl,
    this.user,
    this.password,
    this.connectTimeout = const Duration(seconds: 10),
  });

  /// Starts the controller and connects to Redis. Maintains an open connection
  /// until [stop] is called.
  ///
  /// If [connectTimeout] is set, it overrides [RedisController.connectTimeout]
  /// for the TCP/TLS connections opened during this [start] call only.
  Future<void> start({
    bool Function(Exception e)? handleError,
    Duration? connectTimeout,
  }) async {
    // Reset so a controller that was previously stopped can be started again.
    _running = true;

    final connected = await _connect(handleError, connectTimeout);
    if (!connected && handleError != null) {
      return;
    }
    await _connectPubSub(connectTimeout);

    unawaited(_keepAlive());
  }

  /// Stops the controller and closes all open connections.
  Future<void> stop() async {
    _running = false;

    var command = _command;
    var pubSubCommand = _pubSubCommand;

    // Cleared alongside closing, so a later [start] reconnects instead of
    // handing out the closed connections.
    _command = null;
    _pubSub = null;
    _pubSubCommand = null;

    _failAllPending(_pendingSubscribes);
    _failAllPending(_pendingUnsubscribes);

    await command?.get_connection().close();
    await pubSubCommand?.get_connection().close();
  }

  Future<Socket> _openRedisSocket([Duration? connectTimeoutOverride]) async {
    final timeout = connectTimeoutOverride ?? connectTimeout;
    if (requireSsl) {
      return SecureSocket.connect(host, port, timeout: timeout);
    }
    return Socket.connect(host, port, timeout: timeout);
  }

  /// Whether the last connect attempt failed and has been logged.
  bool _connectFailureLogged = false;

  /// Shared helper to create and authenticate a Redis Command connection.
  Future<Command?> _createAndAuthCommand({
    bool Function(Exception e)? handleError,
    Duration? connectTimeoutOverride,
  }) async {
    try {
      final socket = await _openRedisSocket(connectTimeoutOverride);
      var connection = RedisConnection();
      var command = await connection.connectWithSocket(socket);

      if (password != null) {
        dynamic result = switch (user) {
          String user => await command.send_object(['AUTH', user, password]),
          null => await command.send_object(['AUTH', password]),
        };

        if (result != 'OK') return null;
      }
      _connectFailureLogged = false;
      return command;
    } catch (e) {
      if (handleError != null && e is Exception && handleError(e)) {
        return null;
      }
      if (!_connectFailureLogged) {
        _connectFailureLogged = true;
        log.warning('Failed to connect to Redis at $host:$port ($e).');
      }
      return null;
    }
  }

  Future<bool> _connect([
    bool Function(Exception e)? handleError,
    Duration? connectTimeoutOverride,
  ]) async {
    if (_command != null) {
      return true;
    }
    if (_connecting || !_running) {
      return false;
    }
    _connecting = true;

    _command = await _createAndAuthCommand(
      handleError: handleError,
      connectTimeoutOverride: connectTimeoutOverride,
    );
    _connecting = false;
    return _command != null;
  }

  Future<void> _keepAlive() async {
    while (_running) {
      if (_pubSubCommand == null) {
        await _connectPubSub();
      }
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  Future<bool> _connectPubSub([Duration? connectTimeoutOverride]) async {
    if (_pubSub != null) {
      return true;
    }
    if (_connectingPubSub || !_running) {
      return false;
    }
    _connectingPubSub = true;

    _pubSubCommand = await _createAndAuthCommand(
      connectTimeoutOverride: connectTimeoutOverride,
    );
    if (_pubSubCommand == null) {
      _connectingPubSub = false;
      return false;
    }

    runZonedGuarded(
      () {
        _pubSub = PubSub(_pubSubCommand!);
      },
      (e, stackTrace) {
        _invalidatePubSub();

        log.error(
          'Internal server error. Failed to connect to Redis when creating PubSub.',
          error: e,
          stackTrace: stackTrace,
        );
      },
    );

    var stream = _pubSub!.getStream();
    unawaited(_listenToSubscriptions(stream));

    if (_subscriptions.keys.isNotEmpty) {
      _pubSub!.subscribe(_subscriptions.keys.toList());
    }

    _connectingPubSub = false;
    return true;
  }

  Future<void> _listenToSubscriptions(Stream stream) async {
    try {
      await for (var message in stream) {
        if (message is! List || message.length != 3) continue;

        var channel = message[1];
        if (channel is! String) continue;

        switch (message[0]) {
          case 'message':
            // We got a message (can also be confirmation on publish)
            String data = message[2];

            var callback = _subscriptions[channel];
            if (callback != null) {
              callback(channel, data);
            }
          case 'subscribe':
            // The channel is now active on the server, so anyone waiting for
            // this subscription can safely start publishing to it.
            _resolvePending(_pendingSubscribes, channel, true);
          case 'unsubscribe':
            _resolvePending(_pendingUnsubscribes, channel, true);
        }
      }
    } catch (e) {
      _invalidatePubSub();
      return;
    }
    _invalidatePubSub();
  }

  /// Resolves every command outstanding for [channel]. One confirmation
  /// satisfies all of them, since they all describe the same server side
  /// state.
  void _resolvePending(
    Map<String, List<_PendingConfirmation>> register,
    String channel,
    bool result,
  ) {
    for (var pending in List.of(
      register[channel] ?? const <_PendingConfirmation>[],
    )) {
      pending.complete(result);
    }
  }

  /// Fails every outstanding command, used when the connection carrying the
  /// confirmations goes away.
  void _failAllPending(Map<String, List<_PendingConfirmation>> register) {
    for (var channel in register.keys.toList()) {
      _resolvePending(register, channel, false);
    }
  }

  void _invalidateCommand() {
    try {
      _command?.get_connection().close();
    } catch (e) {
      //
    }
    _command = null;
  }

  void _invalidatePubSub() {
    try {
      _pubSubCommand?.get_connection().close();
    } catch (e) {
      //
    }
    _pubSub = null;
    _pubSubCommand = null;

    _failAllPending(_pendingSubscribes);
    _failAllPending(_pendingUnsubscribes);
  }

  /// Sets a [String] in the Redis cache, which optionally expires.
  Future<bool> set(String key, String message, {Duration? lifetime}) async {
    await _connect();
    try {
      var object = ['SET', key, message];
      if (lifetime != null) {
        object.addAll(['PX', '${lifetime.inMilliseconds}']);
      }
      var result = await _command?.send_object(object);
      return result == 'OK';
    } catch (e) {
      _invalidateCommand();
      return false;
    }
  }

  /// Gets a [String] from the Redis cache. If there is no object matching the
  /// key, null is returned.
  Future<String?> get(String key) async {
    await _connect();
    try {
      var result = await _command?.get(key);
      if (result is String) {
        return result;
      }
      return null;
    } catch (e) {
      _invalidateCommand();
      return null;
    }
  }

  /// Deletes an entry from the Redis cache. Returns true if successful.
  Future<bool> del(String key) async {
    await _connect();
    try {
      var result = await _command?.send_object(['DEL', key]);
      return result == 'OK';
    } catch (e) {
      _invalidateCommand();
      return false;
    }
  }

  /// Removes all objects in the Redis cache, use with caution. Returns true if
  /// successful.
  Future<bool> clear() async {
    if (!await _connect()) {
      return false;
    }
    try {
      var result = await _command?.send_object(['FLUSHALL']);
      return (result == 'OK');
    } catch (e) {
      _invalidateCommand();
      return false;
    }
  }

  /// Subscribes to a Redis channel. When a message is published on the channel
  /// the [listener] callback is called. Only one subscription call should be
  /// made per channel.
  ///
  /// The returned future does not complete until Redis has confirmed the
  /// subscription. Awaiting it is optional: [publish] waits for an in-flight
  /// subscription to the same channel on its own, so a message published
  /// straight after this call is not delivered before the server is ready to
  /// route it.
  Future<bool> subscribe(
    String channel,
    RedisSubscriptionCallback listener,
  ) async {
    // Registered before the first await, so a publish issued immediately after
    // this call already observes the subscription as in flight.
    var pending = _PendingConfirmation(_pendingSubscribes, channel);

    try {
      if (!await _connectPubSub()) return pending.complete(false);

      // In place before the command is sent, so the listener is ready by the
      // time the server starts delivering messages for the channel.
      _subscriptions[channel] = listener;
      _pubSub!.subscribe([channel]);

      return await pending.confirmed.timeout(
        _subscriptionConfirmationTimeout,
        onTimeout: () => pending.complete(false),
      );
    } catch (e) {
      _invalidatePubSub();
      return pending.complete(false);
    }
  }

  /// Unsubscribes from a Redis channel.
  ///
  /// The returned future does not complete until Redis has confirmed that the
  /// subscription is gone.
  Future<bool> unsubscribe(
    String channel,
  ) async {
    var pending = _PendingConfirmation(_pendingUnsubscribes, channel);

    try {
      if (!await _connectPubSub()) return pending.complete(false);

      _subscriptions.remove(channel);
      _pubSub!.unsubscribe([channel]);

      return await pending.confirmed.timeout(
        _subscriptionConfirmationTimeout,
        onTimeout: () => pending.complete(false),
      );
    } catch (e) {
      _invalidatePubSub();
      return pending.complete(false);
    }
  }

  /// Publishes a message to a Redis channel. All subscribed listeners will be
  /// notified across servers.
  ///
  /// Returns true if the message was successfully published.
  Future<bool> publish(String channel, String message) async {
    await _awaitPendingSubscribe(channel);

    try {
      if (!await _connect()) {
        return false;
      }
      await _command?.send_object(
        ['PUBLISH', channel, message],
      );

      return true;
    } catch (e) {
      _invalidateCommand();
      return false;
    }
  }

  /// Waits for an in-flight [subscribe] on [channel] to be confirmed.
  ///
  /// Subscriptions are usually started without being awaited - [MessageCentral]
  /// registers listeners synchronously - and the `SUBSCRIBE` travels on the
  /// pub/sub connection while `PUBLISH` travels on the command connection.
  /// Without this wait the publish can reach the server first, and Redis drops
  /// a message that has no subscriber yet.
  ///
  /// Only subscriptions started through this controller are covered. A
  /// subscriber on another server in the cluster cannot be waited for, which
  /// is inherent to pub/sub rather than something this can solve.
  Future<void> _awaitPendingSubscribe(String channel) async {
    var pending = _pendingSubscribes[channel];
    if (pending == null || pending.isEmpty) return;

    await Future.wait([
      for (var confirmation in List.of(pending)) confirmation.confirmed,
    ]);
  }

  /// Returns the underlying Redis [Command] connection.
  ///
  /// Ensures a connection is established before returning. Returns null if the
  /// connection could not be established.
  ///
  /// Use this to call custom Redis commands via [RedisCommand.send_object] or
  /// other methods from the `redis` package.
  Future<RedisCommand?> getConnection() async {
    if (!await _connect()) {
      return null;
    }
    return _command;
  }

  /// Tests Redis connectivity with a PING command.
  ///
  /// Returns true if Redis responds with PONG, false otherwise.
  /// This is used by health checks to verify Redis availability.
  Future<bool> ping() async {
    if (!await _connect()) {
      return false;
    }
    try {
      var result = await _command?.send_object(['PING']);
      return result == 'PONG';
    } catch (e) {
      _invalidateCommand();
      return false;
    }
  }

  /// Returns a list of subscribed channels.
  List<String> get subscribedChannels => _subscriptions.keys.toList();
}

/// A subscription command that has been handed to Redis and is waiting for the
/// server's confirmation frame.
///
/// It registers itself on construction and unregisters itself on [complete], so
/// a command that fails, times out, or loses its connection can never leave a
/// publisher waiting on a confirmation that will never arrive.
class _PendingConfirmation {
  final Map<String, List<_PendingConfirmation>> _register;
  final String _channel;
  final Completer<bool> _completer = Completer<bool>();

  _PendingConfirmation(this._register, this._channel) {
    _register.putIfAbsent(_channel, () => []).add(this);
  }

  /// Completes once the server has answered, or the command was given up on.
  Future<bool> get confirmed => _completer.future;

  /// Settles this command with [result], which is also returned so callers can
  /// `return pending.complete(false)` on their failure paths.
  bool complete(bool result) {
    var pending = _register[_channel];
    if (pending != null) {
      pending.remove(this);
      if (pending.isEmpty) _register.remove(_channel);
    }

    if (!_completer.isCompleted) _completer.complete(result);
    return result;
  }
}
