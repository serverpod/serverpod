import 'dart:async';

import 'package:serverpod/serverpod.dart';

/// Channels that are listened to by the Serverpod Framework.
abstract class MessageCentralServerpodChannels {
  /// Used to revoke authentication tokens.
  /// The message should be of type [RevokedAuthenticationUser],
  /// [RevokedAuthenticationAuthId] or [RevokedAuthenticationScope].
  /// The [userIdentifier] should be the [AuthenticationInfo.userIdentifier] for the concerned
  /// user.
  static String revokedAuthentication(String userIdentifier) =>
      '_serverpod_revoked_authentication_$userIdentifier';
}

/// The callback used by listeners of the [MessageCentral].
typedef MessageCentralListenerCallback =
    void Function(SerializableModel message);

/// The [MessageCentral] handles communication within the server, and between
/// servers in a cluster. It is especially useful when working with streaming
/// endpoints. The message central can pass on any serializable to a channel.
/// The channel can be listened to by from any place in the server.
class MessageCentral {
  final _channels = <String, Set<MessageCentralListenerCallback>>{};
  final _sessionToChannelNamesLookup = <Session, Set<String>>{};
  final _sessionToCallbacksLookup =
      <Session, Set<MessageCentralListenerCallback>>{};
  final _sessionToCleanupCallbacksLookup = <Session, Set<Function()>>{};

  /// Posts a [message] to a named channel. Optionally a [destinationServerId]
  /// can be provided, in which case the message is sent only to that specific
  /// server within the cluster. If no [destinationServerId] is provided, the
  /// message is passed on to all servers in the cluster.
  ///
  /// Returns true if the message was successfully posted.
  ///
  /// Throws a [StateError] if Redis is not enabled and [global] is set to true.
  Future<bool> postMessage(
    String channelName,
    SerializableModel message, {
    bool global = false,
  }) async {
    if (global) {
      // Send to Redis
      var data = Serverpod.instance.serializationManager.encodeWithType(
        message,
      );
      var redisController = Serverpod.instance.redisController;
      if (redisController == null) {
        throw StateError('Redis needs to be enabled to use this method');
      }

      return await redisController.publish(channelName, data);
    } else {
      // Handle internally in this server instance
      var channel = _channels[channelName];
      if (channel == null) return true;

      for (var callback in channel.toList()) {
        callback(message);
      }
      return true;
    }
  }

  Set<MessageCentralListenerCallback> _getChannel(String channelName) {
    // Find or create channel
    var channel = _channels[channelName];
    if (channel == null) {
      channel = <MessageCentralListenerCallback>{};
      _channels[channelName] = channel;
    }
    return channel;
  }

  /// Adds a listener to a named channel. Whenever a message is posted using
  /// [postMessage], the [listener] will be notified.
  void addListener(
    Session session,
    String channelName,
    MessageCentralListenerCallback listener,
  ) {
    // Find or create channel
    var channel = _getChannel(channelName);
    channel.add(listener);

    var subscribedChannels = _sessionToChannelNamesLookup[session];
    if (subscribedChannels == null) {
      subscribedChannels = {};
      _sessionToChannelNamesLookup[session] = subscribedChannels;
    }
    subscribedChannels.add(channelName);

    var callbacks = _sessionToCallbacksLookup[session];
    if (callbacks == null) {
      callbacks = {};
      _sessionToCallbacksLookup[session] = callbacks;
    }
    callbacks.add(listener);

    if (session.serverpod.redisController != null) {
      session.serverpod.redisController!.subscribe(
        channelName,
        _receivedRedisMessage,
      );
    }
  }

  void _receivedRedisMessage(String channelName, String message) {
    // var serialization = jsonDecode(message);
    var messageObj = Serverpod.instance.serializationManager.decodeWithType(
      message,
    );
    if (messageObj == null) {
      return;
    }
    postMessage(channelName, messageObj as SerializableModel, global: false);
  }

  /// Removes a listener from a named channel.
  void removeListener(
    Session session,
    String channelName,
    MessageCentralListenerCallback listener,
  ) {
    var channel = _channels[channelName];
    if (channel != null) {
      channel.remove(listener);
      if (channel.isEmpty) {
        _channels.remove(channelName);
        if (session.serverpod.redisController != null) {
          session.serverpod.redisController!.unsubscribe(channelName);
        }
      }
    }

    var subscribedChannels = _sessionToChannelNamesLookup[session];
    if (subscribedChannels != null) {
      subscribedChannels.remove(channelName);
      if (subscribedChannels.isEmpty) {
        _sessionToChannelNamesLookup.remove(session);
      }
    }

    var callbacks = _sessionToCallbacksLookup[session];
    if (callbacks != null) {
      callbacks.remove(listener);
      if (callbacks.isEmpty) {
        _sessionToCallbacksLookup.remove(session);
      }
    }
  }

  /// Removes all listeners from the specified [Session]. This method is
  /// automatically called when [StreamingSession] is closed.
  void removeListenersForSession(Session session) {
    // Get subscribed channels
    var channelNames = _sessionToChannelNamesLookup[session];
    if (channelNames == null) return;
    var listeners = _sessionToCallbacksLookup[session];
    if (listeners == null) return;

    for (var channelName in channelNames) {
      for (var listener in listeners) {
        _removeListener(session, channelName, listener);
      }
    }

    _sessionToChannelNamesLookup.remove(session);
    _sessionToCallbacksLookup.remove(session);
  }

  void _removeListener(
    Session session,
    String channelName,
    MessageCentralListenerCallback listener,
  ) {
    var channel = _getChannel(channelName);
    channel.remove(listener);
    if (channel.isEmpty) {
      _channels.remove(channelName);
      if (session.serverpod.redisController != null) {
        session.serverpod.redisController!.unsubscribe(channelName);
      }
    }

    _executeCleanupCallbacks(session);
  }

  /// Creates a stream that listens to a specified channel.
  ///
  /// This stream emits messages of type [T] whenever a message is received on
  /// the specified channel.
  ///
  /// If messages on the channel does not match the type [T], the stream will
  /// emit an error.
  Stream<T> createStream<T>(
    Session session,
    String channelName,
  ) {
    var controller = StreamController<T>();
    void addToStream(dynamic message) {
      try {
        controller.add(message as T);
      } catch (e) {
        controller.addError(e);
      }
    }

    addListener(session, channelName, addToStream);
    _addCleanupCallback(session, controller.close);

    controller.onCancel = () {
      _removeCleanupCallback(session, controller.close);
      removeListener(session, channelName, addToStream);
    };

    return controller.stream;
  }

  void _addCleanupCallback(Session session, Function() callback) {
    var callbacks = _sessionToCleanupCallbacksLookup[session];
    if (callbacks == null) {
      callbacks = {};
      _sessionToCleanupCallbacksLookup[session] = callbacks;
    }
    callbacks.add(callback);
  }

  void _removeCleanupCallback(Session session, Function() callback) {
    var callbacks = _sessionToCleanupCallbacksLookup[session];
    if (callbacks == null) return;

    callbacks.remove(callback);
  }

  void _executeCleanupCallbacks(Session session) {
    var callbacks = _sessionToCleanupCallbacksLookup[session];
    if (callbacks == null) return;

    for (var callback in callbacks) {
      callback();
    }

    _sessionToCleanupCallbacksLookup.remove(session);
  }
}
