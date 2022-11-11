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

/// The [MessageCentral] handles communication within the server, and between
/// servers in a cluster. It is especially useful when working with streaming
/// endpoints. The message central can pass on any serializable to a channel.
/// The channel can be listened to by from any place in the server.
class MessageCentral {
  final _channels =
      <String, Set<_SessionBoundMessageCentralListenerCallback>>{};
  final _sessionToChannelNamesLookup = <Session, Set<String>>{};

  /// Posts a [message] to a named channel. Optionally a [destinationServerId]
  /// can be provided, in which case the message is sent only to that specific
  /// server within the cluster. If no [destinationServerId] is provided, the
  /// message is passed on to all servers in the cluster.
  void postMessage(
    String channelName,
    SerializableEntity message, {
    bool local = false,
    bool ignoreTypeIncompatibility = false,
  }) {
    if (local) {
      // Handle internally in this server instance
      var channel = _channels[channelName];
      if (channel == null) return;

      for (var sessionCallback in channel) {
        try {
          sessionCallback(message);
        } on TypeError catch (_) {
          // Ignore since the developer has added callbacks taking different types to this Channel.
        } catch (e, stackTrace) {
          sessionCallback.session.log(
            'Failed to execute callback in channel $channelName',
            exception: e,
            level: LogLevel.error,
            stackTrace: stackTrace,
          );
        }
      }
    } else {
      // Send to Redis
      assert(
        Serverpod.instance!.redisController != null,
        'Redis needs to be enabled to use this method',
      );

      var data = SerializationManager.serialize(message.allToJson());
      Serverpod.instance!.redisController!.publish(channelName, data);
    }
  }

  Set<_SessionBoundMessageCentralListenerCallback>
      _getChannel<T extends SerializableEntity>(String channelName) {
    // Find or create channel
    var channel = _channels[channelName];
    if (channel == null) {
      var newChannel = <_SessionBoundMessageCentralListenerCallback>{};
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
    bool ignoreTypeIncompatibility = false,
  }) {
    // Find or create channel
    var channel = _getChannel<T>(channelName);

    channel.add(_SessionBoundMessageCentralListenerCallback(session, listener));

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

    var messageObj = Serverpod.instance!.serializationManager
        .deserializeString(message, channel.messageType);
    if (messageObj == null) {
      return;
    }
    postMessage(channelName, messageObj, local: true);
  }

  /// Removes a listener from a named channel.
  void removeListener<T extends SerializableEntity>(Session session,
      String channelName, MessageCentralListenerCallback<T> listener) {
    var channel = _channels[channelName];
    if (channel != null) {
      channel.removeWhere(
        (element) => element._callback == listener,
      );
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
  }

  /// Removes all listeners from the specified [Session]. This method is
  /// automatically called when [StreamingSession] is closed.
  void removeListenersForSession(Session session) {
    // Get subscribed channels
    var channelNames = _sessionToChannelNamesLookup[session];
    if (channelNames == null) return;

    for (var channelName in channelNames) {
      var sessionBoundCallbacks = _channels[channelName]?.toSet();

      for (var sessionBoundCallback in sessionBoundCallbacks ??
          <_SessionBoundMessageCentralListenerCallback>{}) {
        _removeListener(session, channelName, sessionBoundCallback._callback);
      }
    }

    _sessionToChannelNamesLookup.remove(session);
  }

  void _removeListener(
    Session session,
    String channelName,
    // An explicit type can't be used here
    dynamic listener,
  ) {
    var channel = _channels[channelName];
    if (channel != null) {
      channel.removeWhere(
        (element) => element._callback == listener,
      );
      if (channel.isEmpty) {
        _channels.remove(channelName);
        if (session.serverpod.redisController != null) {
          session.serverpod.redisController!.unsubscribe(channelName);
        }
      }
    }
  }
}
