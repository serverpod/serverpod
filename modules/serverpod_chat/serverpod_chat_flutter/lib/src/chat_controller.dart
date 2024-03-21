import 'dart:math';

import 'package:flutter/material.dart';

import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:serverpod_chat_client/serverpod_chat_client.dart';
import 'package:serverpod_chat_flutter/serverpod_chat_flutter.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as auth;

/// Callback for when a message is received from the server. If [addedByUser] is
/// true, the message was added by the current user.
typedef ChatControllerReceivedMessageCallback = void Function(
    ChatMessage message, bool addedByUser);

/// Handles all interaction with a chat channel.
class ChatController {
  /// The identifiying channel name of chat this controller is handling.
  late final String channel;

  /// Reference to the module.
  final Caller module;

  /// The [SessionManager] handling authentication.
  final SessionManager sessionManager;

  /// True if the chat is ephemeral and shouldn't be saved to the database.
  final bool ephemeral;

  /// Name of an autheticated user.
  final String? unauthenticatedUserName;

  /// Reference to the dispatch that handles multiple chat channels.
  late final ChatDispatch dispatch;

  /// List of received chat messages.
  final messages = <ChatMessage>[];

  bool _joinedChannel = false;

  /// True if the user has joined this channel.
  bool get joinedChannel => _joinedChannel;

  bool _joinFailed = false;

  /// True if the user failed to join this channel.
  bool get joinFailed => _joinFailed;

  String? _joinFailedReason;

  /// A description of the reason we were not allowed to join this channel.
  /// Only set if [joinFailed] is true.
  String? get joinFailedReason => _joinFailedReason;

  bool _hasOlderMessages = true;

  /// True if there are older messages than the ones that we have received so
  /// far.
  bool get hasOlderMessages => _hasOlderMessages;

  int _clientMessageId = 0;

  bool _postedMessageChunkRequest = false;

  final _receivedMessageListeners = <ChatControllerReceivedMessageCallback>{};
  final _receivedMessageChunkListeners = <VoidCallback>{};
  final _messageUpdatedListeners = <VoidCallback>{};
  final _unreadMessagesListeners = <VoidCallback>{};
  final _connectionStatusListeners = <VoidCallback>{};

  /// The [scrollOffset] of a connected scroll view.
  double scrollOffset = 0;

  /// We have scrolled to the bottom of the chat.
  bool scrollAtBottom = true;

  int _lastReadMessage = 0;

  /// Counter for fake IDs for the ephemeral messages
  /// (Used in order to keep track of their read state)
  int _ephemeralMessageId = 0;

  auth.UserInfo? _joinedAsUserInfo;

  @visibleForTesting

  /// True if we have received a [UserInfo] for the current user.
  bool get hasUserInfo => _joinedAsUserInfo != null;

  /// Creates a new [ChatController].
  ChatController({
    required String channel,
    required this.module,
    required this.sessionManager,
    this.ephemeral = false,
    this.unauthenticatedUserName,
  }) {
    this.channel = ephemeral ? 'ephemeral.$channel' : channel;

    // Pick a random number and hope no other client with the same user logged
    // in picks the same. If so, messages may be incorrectly marked as delivered.
    _clientMessageId = Random().nextInt(10000000);
    dispatch = ChatDispatch.getInstance(module);
    dispatch.addListener(
      this.channel,
      _handleServerMessage,
      unauthenticatedUserName: unauthenticatedUserName,
    );
  }

  /// Disposes the [ChatController] when it is no longer used.
  void dispose() {
    dispatch.removeListener(channel);
    _receivedMessageListeners.clear();
    _messageUpdatedListeners.clear();
    _unreadMessagesListeners.clear();
    _connectionStatusListeners.clear();
  }

  void _handleServerMessage(SerializableEntity serverMessage) {
    if (serverMessage is ChatMessage) {
      if (ephemeral && serverMessage.id == null) {
        serverMessage.id = ++_ephemeralMessageId;
      }

      // Mark as read if a view is attached and scroll is at bottom.
      if (scrollAtBottom && _receivedMessageListeners.isNotEmpty) {
        markLastMessageRead();
      }

      var updated = false;
      if (serverMessage.sender == _joinedAsUserInfo?.id) {
        // This user is the sender of the message, mark message as sent
        for (var message in messages) {
          if (message.clientMessageId == serverMessage.clientMessageId) {
            message.sent = true;
            message.id = serverMessage.id;
            updated = true;
          }
        }
        if (updated) {
          _notifyMessageUpdatedListeners();
        }
      }
      if (!updated) {
        messages.add(serverMessage);
        _notifyMessageListeners(serverMessage, false);
      }

      _updateUnreadMessages();
    } else if (serverMessage is ChatMessageChunk) {
      _hasOlderMessages = serverMessage.hasOlderMessages;
      messages.insertAll(0, serverMessage.messages);
      _postedMessageChunkRequest = false;
      _notifyReceivedMessageChunkListeners();
    } else if (serverMessage is ChatJoinedChannel) {
      messages.addAll(serverMessage.initialMessageChunk.messages);
      _joinedAsUserInfo = serverMessage.userInfo;
      _hasOlderMessages = serverMessage.initialMessageChunk.hasOlderMessages;
      _lastReadMessage = serverMessage.lastReadMessageId;
      _joinedChannel = true;
      _updateUnreadMessages();
      _notifyConnectionStatusListener();
    } else if (serverMessage is ChatJoinChannelFailed) {
      _joinFailed = true;
      _joinFailedReason = serverMessage.reason;
      _notifyConnectionStatusListener();
    }
  }

  /// Sends a chat message with optional [attachments].
  void postMessage(String message, [List<ChatMessageAttachment>? attachments]) {
    if (!sessionManager.isSignedIn && unauthenticatedUserName == null) {
      return;
    }

    // Send to server
    dispatch.postMessage(
      ChatMessagePost(
        channel: channel,
        message: message,
        clientMessageId: _clientMessageId,
        attachments: attachments,
      ),
    );

    // Post dummy message
    var dummy = ChatMessage(
      channel: channel,
      message: message,
      time: DateTime.now().toUtc(),
      sent: false,
      sender: _joinedAsUserInfo!.id!,
      senderInfo: _joinedAsUserInfo?.toPublic(),
      removed: false,
      clientMessageId: _clientMessageId,
      attachments: attachments,
    );
    messages.add(dummy);

    _notifyMessageListeners(dummy, true);
    _clientMessageId += 1;
  }

  /// Marks last message as read.
  void markLastMessageRead() {
    var messageId = _getLastMessageId();
    if (messageId == null) {
      return;
    }

    if (messageId > _lastReadMessage) {
      _lastReadMessage = messageId;

      if (!ephemeral) {
        module.chat.sendStreamMessage(
          ChatReadMessage(
            channel: channel,
            userId: sessionManager.signedInUser!.id!,
            lastReadMessageId: messageId,
          ),
        );
      }

      _updateUnreadMessages();
    }
  }

  bool _unreadMessagesLast = false;
  void _updateUnreadMessages() {
    var hasUnread = hasUnreadMessages;
    if (_unreadMessagesLast != hasUnread) {
      _unreadMessagesLast = hasUnread;
      _notifyUnreadMessagesListeners();
    }
  }

  int? _getLastMessageId() {
    int? lastMessageId;

    for (var message in messages.reversed) {
      if (message.sender != _joinedAsUserInfo!.id! && message.id != null) {
        lastMessageId = message.id!;
        break;
      }
    }

    return lastMessageId;
  }

  /// True if there are unread messages.
  bool get hasUnreadMessages {
    // Find last message that user didn't send
    int? lastMessageId = _getLastMessageId();

    if (lastMessageId == null) {
      return false;
    }
    return lastMessageId != _lastReadMessage;
  }

  /// Request a new chunk of messages.
  void requestNextMessageChunk() {
    if (!_hasOlderMessages ||
        !sessionManager.isSignedIn ||
        messages.isEmpty ||
        _postedMessageChunkRequest) {
      return;
    }
    _postedMessageChunkRequest = true;

    var messageId = messages[0].id;
    if (messageId == null) {
      return;
    }

    var request =
        ChatRequestMessageChunk(channel: channel, lastMessageId: messageId);
    dispatch.postRequestMessageChunk(request);
  }

  // Listeners for received messages

  /// Adds a listener for received messages.
  void addMessageReceivedListener(
      ChatControllerReceivedMessageCallback listener) {
    _receivedMessageListeners.add(listener);
  }

  /// Removes a listener for received messages.
  void removeMessageReceivedListener(
      ChatControllerReceivedMessageCallback listener) {
    _receivedMessageListeners.remove(listener);
  }

  void _notifyMessageListeners(ChatMessage message, bool addedByUser) {
    for (var listener in _receivedMessageListeners) {
      listener(message, addedByUser);
    }
  }

  // Listeners for updated messages

  /// Adds a listener for updates messages.
  void addMessageUpdatedListener(VoidCallback listener) {
    _messageUpdatedListeners.add(listener);
  }

  /// Removes a listener for updated messages.
  void removeMessageUpdatedListener(VoidCallback listener) {
    _messageUpdatedListeners.remove(listener);
  }

  void _notifyMessageUpdatedListeners() {
    for (var listener in _messageUpdatedListeners) {
      listener();
    }
  }

  // Listeners for recevied message chunks

  /// Adds a listener for received chunks of messages.
  void addReceivedMessageChunkListener(VoidCallback listener) {
    _receivedMessageChunkListeners.add(listener);
  }

  /// Removes a listener for received chunks of messages.
  void removeReceivedMessageChunkListener(VoidCallback listener) {
    _receivedMessageChunkListeners.remove(listener);
  }

  void _notifyReceivedMessageChunkListeners() {
    for (var listener in _receivedMessageChunkListeners) {
      listener();
    }
  }

  // Listeners for unread messages

  /// Adds a listener for unread messages.
  void addUnreadMessagesListener(VoidCallback listener) {
    _unreadMessagesListeners.add(listener);
  }

  /// Removes a listener for unread messages.
  void removeUnreadMessagesListener(VoidCallback listener) {
    _unreadMessagesListeners.remove(listener);
  }

  void _notifyUnreadMessagesListeners() {
    for (var listener in _unreadMessagesListeners) {
      listener();
    }
  }

  // Listeners for connection status

  /// Adds a listener for connection status.
  void addConnectionStatusListener(VoidCallback listener) {
    _connectionStatusListeners.add(listener);
  }

  /// Removes a listener for connection status.
  void removeConnectionStatusListener(VoidCallback listener) {
    _connectionStatusListeners.remove(listener);
  }

  void _notifyConnectionStatusListener() {
    for (var listener in _connectionStatusListeners) {
      listener();
    }
  }
}
