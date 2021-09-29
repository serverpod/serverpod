import 'package:serverpod_chat_client/module.dart';
import 'package:serverpod_chat_flutter/serverpod_chat_flutter.dart';

typedef ChatControllerReceivedMessageCallback = void Function(ChatMessage message);

class ChatController {
  final String channel;
  final Caller caller;

  late final ChatDispatch dispatch;

  final messages = <ChatMessage>[];

  bool _joinedChannel = false;
  bool get joinedChannel => _joinedChannel;

  bool _joinFailed = false;
  bool get joinFailed => _joinFailed;

  String? _joinFailedReason;
  String? get joinFailedReason => _joinFailedReason;

  bool _hasOlderMessages = true;
  bool get hasOlderMessages => _hasOlderMessages;

  int _clientMessageId = 0;

  final _receivedMessageListeners = <ChatControllerReceivedMessageCallback>{};

  ChatController({
    required this.channel,
    required this.caller,
  }) {
    dispatch = ChatDispatch.getInstance(caller);
    dispatch.addListener(channel, _handleServerMessage);
  }

  void dispose() {
    dispatch.removeListener(channel);
    _receivedMessageListeners.clear();
  }

  void _handleServerMessage(SerializableEntity serverMessage) {
    if (serverMessage is ChatMessage) {
      messages.add(serverMessage);
      _notifyMessageListeners(serverMessage);
    }
    else if (serverMessage is ChatJoinedChannel) {
      messages.addAll(serverMessage.initialMessageChunk.messages);
      _hasOlderMessages = serverMessage.initialMessageChunk.hasOlderMessages;
      _joinedChannel = true;
    }
    else if (serverMessage is ChatJoinChannelFailed) {
      _joinFailed = true;
      _joinFailedReason = serverMessage.reason;
    }
  }

  void postTextMessage(String message) {
    dispatch.postMessage(
      ChatMessagePost(
        channel: channel,
        type: 'text',
        message: message,
        clientMessageId: _clientMessageId,
      ),
    );
    _clientMessageId += 1;
  }

  void addMessageListener(ChatControllerReceivedMessageCallback listener) {
    _receivedMessageListeners.add(listener);
  }

  void removeMessageListener(ChatControllerReceivedMessageCallback listener) {
    _receivedMessageListeners.remove(listener);
  }

  void _notifyMessageListeners(ChatMessage message) {
    for (var listener in _receivedMessageListeners) {
      listener(message);
    }
  }
}