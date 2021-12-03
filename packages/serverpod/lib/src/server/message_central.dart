import 'package:serverpod/serverpod.dart';

// TODO: Support for server clusters.

/// The callback used by listeners of the [MessageCentral].
typedef MessageCentralListenerCallback = void Function(SerializableEntity message);

/// The [MessageCentral] handles communication within the server, and between
/// servers in a cluster. It is especially useful when working with streaming
/// endpoints. The message central can pass on any serializable to a channel.
/// The channel can be listened to by from any place in the server.
class MessageCentral {
  final _channels = <String, Set<MessageCentralListenerCallback>>{};
  final _sessionToChannelNamesLookup = <Session, Set<String>>{};
  final _sessionToCallbacksLookup = <Session, Set<MessageCentralListenerCallback>>{};

  /// Posts a [message] to a named channel. Optionally a [destinationServerId]
  /// can be provided, in which case the message is sent only to that specific
  /// server within the cluster. If no [destinationServerId] is provided, the
  /// message is passed on to all servers in the cluster.
  void postMessage(String channelName, SerializableEntity message, {int? destinationServerId}) {
    var channel = _channels[channelName];
    if (channel == null)
      return;

    for (var callback in channel) {
      callback(message);
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
  void addListener(Session session, String channelName, MessageCentralListenerCallback listener) {
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
  }

  /// Removes a listener from a named channel.
  void removeListener(Session session, String channelName, MessageCentralListenerCallback listener) {
    var channel = _channels[channelName];
    if (channel != null) {
      channel.remove(listener);
      if (channel.isEmpty) {
        _channels.remove(channelName);
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
    if (channelNames == null)
      return;
    var listeners = _sessionToCallbacksLookup[session];
    if (listeners == null)
      return;

    for (var channelName in channelNames) {
      for (var listener in listeners) {
        _removeListener(channelName, listener);
      }
    }

    _sessionToChannelNamesLookup.remove(session);
    _sessionToCallbacksLookup.remove(session);
  }

  void _removeListener(String channelName, MessageCentralListenerCallback listener) {
    var channel = _getChannel(channelName);
    channel.remove(listener);
    if (channel.isEmpty) {
      _channels.remove(channelName);
    }
  }
}