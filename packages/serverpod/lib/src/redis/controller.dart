import 'dart:async';

import 'package:redis/redis.dart';

typedef RedisSubscriptionCallback = void Function(
    String channel, String message);

class RedisController {
  final String host;
  final int port;
  final String? user;
  final String? password;

  final Map<String, RedisSubscriptionCallback> _subscriptions = {};

  Command? _command;
  bool _connecting = false;

  Command? _pubSubCommand;
  bool _connectingPubSub = false;
  PubSub? _pubSub;

  bool _running = true;

  RedisController({
    required this.host,
    required this.port,
    this.user,
    this.password,
  });

  Future<void> start() async {
    await _connect();
    await _connectPubSub();

    unawaited(_keepAlive());
  }

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
      final connection = RedisConnection();

      _command = await connection.connect(host, port);
      if (password != null) {
        // TODO: Username
        var result = await _command!.send_object(['AUTH', password]);
        _connecting = false;
        return (result == 'OK');
      } else {
        _connecting = false;
        return true;
      }
    } catch (e) {
      _connecting = false;
      return false;
    }
  }

  Future<void> _keepAlive() async {
    while (_running) {
      if (_pubSubCommand == null) {
        await _connectPubSub();
      }
      await Future.delayed(const Duration(seconds: 5));
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
      final connection = RedisConnection();
      _pubSubCommand = await connection.connect(host, port);
      if (password != null) {
        var result = await _pubSubCommand!.send_object(['AUTH', password]);
        _connecting = false;
        if (result != 'OK') return false;
      }

      _pubSub = PubSub(_pubSubCommand!);

      final stream = _pubSub!.getStream();
      unawaited(_listenToSubscriptions(stream));

      if (_subscriptions.keys.isNotEmpty) {
        _pubSub!.subscribe(_subscriptions.keys.toList());
      }

      _connectingPubSub = false;
      return true;
    } catch (e) {
      _connectingPubSub = false;
      _invalidatePubSub();
      return false;
    }
  }

  Future<void> _listenToSubscriptions(Stream stream) async {
    try {
      await for (var message in stream) {
        if (message is List && message.length == 3) {
          if (message[0] == 'message') {
            // We got a message (can also be confirmation on publish)
            final String channel = message[1];
            final String data = message[2];

            final callback = _subscriptions[channel];
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

  Future<bool> set(String key, String message, {Duration? lifetime}) async {
    await _connect();
    try {
      final object = ['SET', key, message];
      if (lifetime != null) {
        object.addAll(['PX', '${lifetime.inMilliseconds}']);
      }
      final result = await _command?.send_object(object);
      return result == 'OK';
    } catch (e) {
      _invalidateCommand();
      return false;
    }
  }

  Future<String?> get(String key) async {
    await _connect();
    try {
      final result = await _command?.get(key);
      if (result is String) {
        return result;
      }
      return null;
    } catch (e) {
      _invalidateCommand();
      return null;
    }
  }

  Future<bool> del(String key) async {
    await _connect();
    try {
      final result = await _command?.send_object(['DEL', key]);
      return result == 'OK';
    } catch (e) {
      _invalidateCommand();
      return false;
    }
  }

  Future<bool> clear() async {
    if (!await _connect()) {
      return false;
    }
    try {
      final result = await _command?.send_object(['FLUSHALL']);
      return (result == 'OK');
    } catch (e) {
      _invalidateCommand();
      return false;
    }
  }

  Future<bool> subscribe(
    String channel,
    RedisSubscriptionCallback listener,
  ) async {
    try {
      await _connectPubSub();
      _pubSub!.subscribe([channel]);
      _subscriptions[channel] = listener;
      return true;
    } catch (e) {
      _invalidatePubSub();
      return false;
    }
  }

  Future<bool> unsubscribe(
    String channel,
  ) async {
    try {
      await _connectPubSub();
      _pubSub!.unsubscribe([channel]);
      _subscriptions.remove(channel);
      return true;
    } catch (e) {
      _invalidatePubSub();
      return false;
    }
  }

  Future<bool> publish(String channel, String message) async {
    try {
      if (!await _connect()) {
        return false;
      }
      final result = await _command!.send_object(['PUBLISH', channel, message]);
      return result == 'OK';
    } catch (e) {
      _invalidatePubSub();
      return false;
    }
  }

  List<String> get subscribedChannels => _subscriptions.keys.toList();
}
