import 'package:serverpod_chat_client/module.dart';

typedef ChatMessageListener = void Function(ChatMessage);

class ChatDispatch {
  static ChatDispatch? _singleton;
  static getInstance(Caller caller) {
    _singleton ??= ChatDispatch(caller: caller);
    return _singleton;
  }

  final _listeners = <String, ChatMessageListener>{};

  final Caller caller;
  ChatDispatch({
    required this.caller,
  }) {
    _handleStreamMessages();
  }

  void addListener(String channel, ChatMessageListener listener) {
    assert(_listeners[channel] == null, 'Only one listener per channel is allowed.');
    _listeners[channel] = listener;
    caller.chat.sendStreamMessage(ChatJoinChannel(channel: channel));
  }

  void removeListener(String channel) {
    _listeners.remove(channel);
  }

  Future<void> _handleStreamMessages() async {
    await for (var message in caller.chat.stream) {
      print('Received message: ${message.runtimeType}');
      if (message is ChatMessage) {
        var listener = _listeners[message.channel];
        if (listener != null) {
          listener(message);
        }
      }
    }
  }

  Future<void> postMessage(ChatMessagePost message) async {
    await caller.chat.sendStreamMessage(message);
  }
}