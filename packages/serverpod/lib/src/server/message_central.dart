import 'dart:convert';

import '../../serverpod.dart';

// TODO: Support for server clusters.

/// The callback used by listeners of the [MessageCentral].
typedef MessageCentralListenerCallback = void Function(
    SerializableEntity message);

/// The [MessageCentral] handles communication within the server, and between
/// servers in a cluster. It is especially useful when working with streaming
/// endpoints. The message central can pass on any serializable to a channel.
/// The channel can be listened to by from any place in the server.
class MessageCentral {
  final Map<String, Set<MessageCentralListenerCallback>> _channels = <String, Set<MessageCentralListenerCallback>>{};
  final Map<Session, Set<String>> _sessionToChannelNamesLookup = <Session, Set<String>>{};
  final Map<Session, Set<MessageCentralListenerCallback>> _sessionToCallbacksLookup =
      <Session, Set<MessageCentralListenerCallback>>{};

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
      Set<MessageCentralListenerCallback>? channel = _channels[channelName];
      if (channel == null) return;

      for (MessageCentralListenerCallback callback in channel) {
        callback(message);
      }
    } else {
      // Send to Redis
      assert(
        Serverpod.instance!.redisController != null,
        'Redis needs to be enabled to use this method',
      );

      String data = jsonEncode(message.serializeAll());
      Serverpod.instance!.redisController!.publish(channelName, data);
    }
  }

  Set<MessageCentralListenerCallback> _getChannel(String channelName) {
    // Find or create channel
    Set<MessageCentralListenerCallback>? channel = _channels[channelName];
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
    MessageCentralListenerCallback listener, {
    bool local = false,
  }) {
    // Find or create channel
    Set<MessageCentralListenerCallback> channel = _getChannel(channelName);
    channel.add(listener);

    Set<String>? subscribedChannels = _sessionToChannelNamesLookup[session];
    if (subscribedChannels == null) {
      subscribedChannels = <String>{};
      _sessionToChannelNamesLookup[session] = subscribedChannels;
    }
    subscribedChannels.add(channelName);

    Set<MessageCentralListenerCallback>? callbacks = _sessionToCallbacksLookup[session];
    if (callbacks == null) {
      callbacks = <void Function(SerializableEntity)>{};
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
    Map<String, dynamic> serialization = jsonDecode(message);
    SerializableEntity? messageObj = Serverpod.instance!.serializationManager
        .createEntityFromSerialization(serialization);
    if (messageObj == null) {
      return;
    }
    postMessage(channelName, messageObj, local: true);
  }

  /// Removes a listener from a named channel.
  void removeListener(Session session, String channelName,
      MessageCentralListenerCallback listener) {
    Set<MessageCentralListenerCallback>? channel = _channels[channelName];
    if (channel != null) {
      channel.remove(listener);
      if (channel.isEmpty) {
        _channels.remove(channelName);
        if (session.serverpod.redisController != null) {
          session.serverpod.redisController!.unsubscribe(channelName);
        }
      }
    }

    Set<String>? subscribedChannels = _sessionToChannelNamesLookup[session];
    if (subscribedChannels != null) {
      subscribedChannels.remove(channelName);
      if (subscribedChannels.isEmpty) {
        _sessionToChannelNamesLookup.remove(session);
      }
    }

    Set<MessageCentralListenerCallback>? callbacks = _sessionToCallbacksLookup[session];
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
    Set<String>? channelNames = _sessionToChannelNamesLookup[session];
    if (channelNames == null) return;
    Set<MessageCentralListenerCallback>? listeners = _sessionToCallbacksLookup[session];
    if (listeners == null) return;

    for (String channelName in channelNames) {
      for (MessageCentralListenerCallback listener in listeners) {
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
    Set<MessageCentralListenerCallback> channel = _getChannel(channelName);
    channel.remove(listener);
    if (channel.isEmpty) {
      _channels.remove(channelName);
      if (session.serverpod.redisController != null) {
        session.serverpod.redisController!.unsubscribe(channelName);
      }
    }
  }
}
