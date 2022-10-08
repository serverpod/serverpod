import 'dart:collection';
import 'dart:convert';

import 'package:serverpod/serverpod.dart';

// TODO: Support for server clusters.

/// The callback used by listeners of the [MessageCentral].
typedef MessageCentralListenerCallback<T extends SerializableEntity> = void
    Function(T message);

class _SessionBoundMessageCentralListenerCallback {
  final Session session;
  final dynamic _callback;

  const _SessionBoundMessageCentralListenerCallback(
      this.session, this._callback);

  void call(SerializableEntity data) {
    _callback(data);
  }
}

class _Channel {
  final Type messageType;
  final Set<_SessionBoundMessageCentralListenerCallback> callbacks;

  _Channel(this.messageType, this.callbacks);
}

/// The [MessageCentral] handles communication within the server, and between
/// servers in a cluster. It is especially useful when working with streaming
/// endpoints. The message central can pass on any serializable to a channel.
/// The channel can be listened to by from any place in the server.
class MessageCentral {
  final _channels = <String, _Channel>{};
  final _sessionToChannelNamesLookup = <Session, Set<String>>{};

  /// Posts a [message] to a named channel. Optionally a [destinationServerId]
  /// can be provided, in which case the message is sent only to that specific
  /// server within the cluster. If no [destinationServerId] is provided, the
  /// message is passed on to all servers in the cluster.
  void postMessage(
    String channelName,
    SerializableEntity message, {
    bool local = false,
  }) {
    if (local) {
      // Handle internally in this server instance
      var channel = _channels[channelName];
      if (channel == null) return;
      //TODO: Decide if we want to throw or return here...
      if (message.runtimeType != channel.messageType) return;

      for (var sessionCallback in channel.callbacks) {
        sessionCallback(message);
      }
    } else {
      // Send to Redis
      assert(
        Serverpod.instance!.redisController != null,
        'Redis needs to be enabled to use this method',
      );

      var data = jsonEncode(message.allToJson());
      Serverpod.instance!.redisController!.publish(channelName, data);
    }
  }

  _Channel _getChannel<T extends SerializableEntity>(String channelName) {
    // Find or create channel
    var channel = _channels[channelName];
    if (channel == null) {
      var newChannel = _Channel(T, {});
      _channels[channelName] = newChannel;
      return newChannel;
    }
    return channel;
  }

  /// Adds a listener to a named channel. Whenever a message is posted using
  /// [postMessage], the [listener] will be notified.
  void addListener<T extends SerializableEntity>(
    Session session,
    String channelName,
    MessageCentralListenerCallback<T> listener, {
    bool local = false,
  }) {
    // Find or create channel
    var channel = _getChannel<T>(channelName);
    //TODO: Decide if we want to throw or return here...
    if (T != channel.messageType) return;

    channel.callbacks
        .add(_SessionBoundMessageCentralListenerCallback(session, listener));

    var subscribedChannels = _sessionToChannelNamesLookup[session];
    if (subscribedChannels == null) {
      subscribedChannels = {};
      _sessionToChannelNamesLookup[session] = subscribedChannels;
    }
    subscribedChannels.add(channelName);

    if (session.serverpod.redisController != null) {
      session.serverpod.redisController!.subscribe(
        channelName,
        _receivedRedisMessage,
      );
    }
  }

  void _receivedRedisMessage(String channelName, String message) {
    var channel = _channels[channelName];
    if (channel == null) return;

    var serialization = jsonDecode(message);
    var messageObj = Serverpod.instance!.serializationManager
        .deserializeJson(serialization, channel.messageType);
    if (messageObj == null) {
      return;
    }
    postMessage(channelName, messageObj, local: true);
  }

  /// Removes a listener from a named channel.
  void removeListener(Session session, String channelName,
      MessageCentralListenerCallback listener) {
    var channel = _channels[channelName];
    if (channel != null) {
      channel.callbacks.removeWhere(
        (element) => element._callback == listener,
      );
      if (channel.callbacks.isEmpty) {
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
  }

  /// Removes all listeners from the specified [Session]. This method is
  /// automatically called when [StreamingSession] is closed.
  void removeListenersForSession(Session session) {
    // Get subscribed channels
    var channelNames = _sessionToChannelNamesLookup[session];
    if (channelNames == null) return;

    for (var channelName in channelNames) {
      for (var sessionBoundCallback in _channels[channelName]?.callbacks ??
          <_SessionBoundMessageCentralListenerCallback>{}) {
        _removeListener(session, channelName, sessionBoundCallback._callback);
      }
    }

    _sessionToChannelNamesLookup.remove(session);
  }

  void _removeListener(
    Session session,
    String channelName,
    MessageCentralListenerCallback listener,
  ) {
    var channel = _channels[channelName];
    if (channel != null) {
      channel.callbacks.removeWhere(
        (element) => element._callback == listener,
      );
      if (channel.callbacks.isEmpty) {
        _channels.remove(channelName);
        if (session.serverpod.redisController != null) {
          session.serverpod.redisController!.unsubscribe(channelName);
        }
      }
    }
  }
}
