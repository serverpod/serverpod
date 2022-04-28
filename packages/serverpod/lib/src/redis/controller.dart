import 'dart:async';
import 'dart:io';

import 'package:redis/redis.dart';

/// Callback when messages are received on a specific channel from Redis.
typedef RedisSubscriptionCallback = void Function(
    String channel, String message);

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

  final Map<String, RedisSubscriptionCallback> _subscriptions =
      <String, RedisSubscriptionCallback>{};

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
    this.user,
    this.password,
  });

  /// Starts the controller and connects to Redis. Maintains an open connection
  /// until [stop] is called.
  Future<void> start() async {
    await _connect();
    await _connectPubSub();

    unawaited(_keepAlive());
  }

  /// Stops the controller and closes all open connections.
  Future<void> stop() async {
    _running = false;
    await _command?.get_connection().close();
    await _pubSubCommand?.get_connection().close();
  }

  Future<bool> _connect() async {
    if (_command != null) {
      return true;
    }
    if (_connecting || !_running) {
      return false;
    }
    _connecting = true;

    try {
      RedisConnection connection = RedisConnection();

      _command = await connection.connect(host, port);
      if (password != null) {
        // TODO: Username
        dynamic result =
            await _command!.send_object(<String?>['AUTH', password]);
        _connecting = false;
        return (result == 'OK');
      } else {
        _connecting = false;
        return true;
      }
    } catch (e, stackTrace) {
      _connecting = false;
      stderr.writeln(
          '${DateTime.now().toUtc()} Internal server error. Failed to connect to Redis.');
      stderr.writeln('$e');
      stderr.writeln('$stackTrace');
      return false;
    }
  }

  Future<void> _keepAlive() async {
    while (_running) {
      if (_pubSubCommand == null) {
        await _connectPubSub();
      }
      await Future<void>.delayed(const Duration(seconds: 5));
    }
  }

  Future<bool> _connectPubSub() async {
    if (_pubSub != null) {
      return true;
    }
    if (_connectingPubSub || !_running) {
      return false;
    }
    _connectingPubSub = true;

    try {
      RedisConnection connection = RedisConnection();
      _pubSubCommand = await connection.connect(host, port);
      if (password != null) {
        dynamic result =
            await _pubSubCommand!.send_object(<String?>['AUTH', password]);
        _connecting = false;
        if (result != 'OK') return false;
      }

      runZonedGuarded(() {
        _pubSub = PubSub(_pubSubCommand!);
      }, (Object e, StackTrace stackTrace) {
        _invalidatePubSub();

        stderr.writeln(
            '${DateTime.now().toUtc()} Internal server error. Failed to connect to Redis when creating PubSub.');
        stderr.writeln('$e');
        stderr.writeln('$stackTrace');
        stderr.writeln('Local stacktrace:');
        stderr.writeln('${StackTrace.current}');
      });

      Stream<List<dynamic>> stream = _pubSub!.getStream();
      unawaited(_listenToSubscriptions(stream));

      if (_subscriptions.keys.isNotEmpty) {
        _pubSub!.subscribe(_subscriptions.keys.toList());
      }

      _connectingPubSub = false;
      return true;
    } catch (e, stackTrace) {
      _connectingPubSub = false;
      _invalidatePubSub();

      stderr.writeln(
          '${DateTime.now().toUtc()} Internal server error. Failed to connect to Redis when creating PubSub.');
      stderr.writeln('$e');
      stderr.writeln('$stackTrace');

      return false;
    }
  }

  Future<void> _listenToSubscriptions(Stream<List<dynamic>> stream) async {
    try {
      await for (List<dynamic> message in stream) {
        if (message.length == 3) {
          if (message[0] == 'message') {
            // We got a message (can also be confirmation on publish)
            String channel = message[1];
            String data = message[2];

            RedisSubscriptionCallback? callback = _subscriptions[channel];
            if (callback != null) {
              callback(channel, data);
            }
          }
        }
      }
    } catch (e) {
      _invalidatePubSub();
      return;
    }
    _invalidatePubSub();
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
  }

  /// Sets a [String] in the Redis cache, which optionally expires.
  Future<bool> set(String key, String message, {Duration? lifetime}) async {
    await _connect();
    try {
      List<String> object = <String>['SET', key, message];
      if (lifetime != null) {
        object.addAll(<String>['PX', '${lifetime.inMilliseconds}']);
      }
      dynamic result = await _command?.send_object(object);
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
      dynamic result = await _command?.get(key);
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
      dynamic result = await _command?.send_object(<String?>['DEL', key]);
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
      dynamic result = await _command?.send_object(<String?>['FLUSHALL']);
      return (result == 'OK');
    } catch (e) {
      _invalidateCommand();
      return false;
    }
  }

  /// Subscribes to a Redis channel. When a message is published on the channel
  /// the [listener] callback is called. Only one subscription call should be
  /// made per channel.
  Future<bool> subscribe(
    String channel,
    RedisSubscriptionCallback listener,
  ) async {
    try {
      await _connectPubSub();
      _pubSub!.subscribe(<String>[channel]);
      _subscriptions[channel] = listener;
      return true;
    } catch (e) {
      _invalidatePubSub();
      return false;
    }
  }

  /// Unsubscribes from a Redis channel.
  Future<bool> unsubscribe(
    String channel,
  ) async {
    try {
      await _connectPubSub();
      _pubSub!.unsubscribe(<String>[channel]);
      _subscriptions.remove(channel);
      return true;
    } catch (e) {
      _invalidatePubSub();
      return false;
    }
  }

  /// Publishes a message to a Redis channel. All subscribed listeners will be
  /// notified across servers.
  Future<bool> publish(String channel, String message) async {
    try {
      if (!await _connect()) {
        return false;
      }
      dynamic result = await _command!.send_object(
        <String?>['PUBLISH', channel, message],
      );
      return result == 'OK';
    } catch (e) {
      _invalidateCommand();
      return false;
    }
  }

  /// Returns a list of
  List<String> get subscribedChannels => _subscriptions.keys.toList();
}
