import 'package:flutter/cupertino.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:serverpod_chat_client/module.dart';
import 'package:serverpod_chat_flutter/serverpod_chat_flutter.dart';

typedef ChatControllerReceivedMessageCallback = void Function(ChatMessage message);

class ChatController {
  final String channel;
  final Caller module;
  final SessionManager sessionManager;

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
  final _messageUpdatedListeners = <VoidCallback>{};

  double scrollOffset = 0;
  bool scrollAtBottom = true;

  ChatController({
    required this.channel,
    required this.module,
    required this.sessionManager,
  }) {
    dispatch = ChatDispatch.getInstance(module);
    dispatch.addListener(channel, _handleServerMessage);
  }

  void dispose() {
    dispatch.removeListener(channel);
    _receivedMessageListeners.clear();
  }

  void _handleServerMessage(SerializableEntity serverMessage) {
    if (serverMessage is ChatMessage) {
      if (serverMessage.sender == sessionManager.signedInUser?.id!) {
        // This user is the sender of the message, mark message as sent
        var updated = false;
        for (var message in messages) {
          if (message.clientMessageId == serverMessage.clientMessageId) {
            message.sent = true;
            updated = true;
          }
        }
        if (updated) {
          _notifyMessageUpdatedListeners();
        }
      }
      else {
        messages.add(serverMessage);
        _notifyMessageListeners(serverMessage);
      }
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
    if (!sessionManager.isSignedIn) {
      return;
    }

    const type = 'text';

    // Send to server
    dispatch.postMessage(
      ChatMessagePost(
        channel: channel,
        type: type,
        message: message,
        clientMessageId: _clientMessageId,
      ),
    );

    // Post dummy message
    var dummy = ChatMessage(
        channel: channel,
        type: type,
        message: message,
        time: DateTime.now().toUtc(),
        sent: false,
        sender: sessionManager.signedInUser!.id!,
        senderInfo: sessionManager.signedInUser!,
        removed: false,
        clientMessageId: _clientMessageId,
    );
    messages.add(dummy);

    _notifyMessageListeners(dummy);
    _clientMessageId += 1;
  }

  void addMessageReceivedListener(ChatControllerReceivedMessageCallback listener) {
    _receivedMessageListeners.add(listener);
  }

  void removeMessageReceivedListener(ChatControllerReceivedMessageCallback listener) {
    _receivedMessageListeners.remove(listener);
  }

  void _notifyMessageListeners(ChatMessage message) {
    for (var listener in _receivedMessageListeners) {
      listener(message);
    }
  }

  void addMessageUpdatedListener(VoidCallback listener) {
    _messageUpdatedListeners.add(listener);
  }

  void removeMessageUpdatedListener(VoidCallback listener) {
    _messageUpdatedListeners.remove(listener);
  }

  void _notifyMessageUpdatedListeners() {
    for (var listener in _messageUpdatedListeners) {
      listener();
    }
  }
}