import 'package:serverpod_chat_client/module.dart';

typedef ChatMessageListener = void Function(SerializableEntity message);

class ChatDispatch {
  static ChatDispatch? _singleton;
  static ChatDispatch getInstance(Caller caller) {
    _singleton ??= ChatDispatch(caller: caller);
    return _singleton!;
  }

  final Map<String, ChatMessageListener> _listeners = <String, ChatMessageListener>{};

  final Caller caller;
  ChatDispatch({
    required this.caller,
  }) {
    _handleStreamMessages();
  }

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

  void removeListener(String channel) {
    _listeners.remove(channel);
  }

  Future<void> _handleStreamMessages() async {
    await for (SerializableEntity message in caller.chat.stream) {
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
    ChatMessageListener? listener = _listeners[channel];
    if (listener != null) {
      listener(message);
    }
  }

  Future<void> postMessage(ChatMessagePost message) async {
    await caller.chat.sendStreamMessage(message);
  }

  Future<void> postRequestMessageChunk(
      ChatRequestMessageChunk chunkRequest) async {
    await caller.chat.sendStreamMessage(chunkRequest);
  }
}
