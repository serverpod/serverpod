import 'package:serverpod/serverpod.dart';

typedef void MessageCentralListenerCallback(SerializableEntity message);

class MessageCentral {
  final _channels = <String, Set<MessageCentralListenerCallback>>{};
  final _sessionToChannelNamesLookup = <Session, Set<String>>{};
  final _sessionToCallbacksLookup = <Session, Set<MessageCentralListenerCallback>>{};


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