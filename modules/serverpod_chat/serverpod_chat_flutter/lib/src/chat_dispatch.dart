import 'package:serverpod_chat_client/module.dart';

/// Callback for received chat messages.
typedef ChatMessageListener = void Function(SerializableEntity message);

/// The [ChatDispatch] receives chat related messages from the server and
/// passes them on to the correct [ChatController].
class ChatDispatch {
  static ChatDispatch? _singleton;

  /// Returns a singleton instance of the [ChatDispatch].
  static ChatDispatch getInstance(Caller caller) {
    _singleton ??= ChatDispatch(caller: caller);
    return _singleton!;
  }

  final _listeners = <String, ChatMessageListener>{};

  /// A reference to the chat module.
  final Caller caller;

  /// Creates a new [ChatDispatch].
  ChatDispatch({
    required this.caller,
  }) {
    _handleStreamMessages();
  }

  /// Adds a listener to a specifiec chat channel. It's only allowed to add one
  /// listener per channel.
  void addListener(String channel, ChatMessageListener listener,
      {String? unauthenticatedUserName}) {
    assert(_listeners[channel] == null,
        'Only one listener per channel is allowed. channel: $channel');
    _listeners[channel] = listener;
    caller.chat.sendStreamMessage(
      ChatJoinChannel(
        channel: channel,
        userName: unauthenticatedUserName,
      ),
    );
  }

  /// Removes a listener for the specified channel.
  void removeListener(String channel) {
    _listeners.remove(channel);
  }

  Future<void> _handleStreamMessages() async {
    await for (var message in caller.chat.stream) {
      if (message is ChatMessage) {
        _routeMessageToChannel(message.channel, message);
      } else if (message is ChatJoinedChannel) {
        _routeMessageToChannel(message.channel, message);
      } else if (message is ChatJoinChannelFailed) {
        _routeMessageToChannel(message.channel, message);
      } else if (message is ChatMessageChunk) {
        _routeMessageToChannel(message.channel, message);
      }
    }
  }

  void _routeMessageToChannel(String channel, SerializableEntity message) {
    var listener = _listeners[channel];
    if (listener != null) {
      listener(message);
    }
  }

  /// Posts a chat message.
  Future<void> postMessage(ChatMessagePost message) async {
    await caller.chat.sendStreamMessage(message);
  }

  /// Requests a new chunk of messages.
  Future<void> postRequestMessageChunk(
      ChatRequestMessageChunk chunkRequest) async {
    await caller.chat.sendStreamMessage(chunkRequest);
  }
}
