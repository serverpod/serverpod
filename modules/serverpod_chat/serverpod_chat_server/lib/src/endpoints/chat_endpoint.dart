import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';
import '../generated/protocol.dart';
import '../business/config.dart';

class ChatEndpoint extends Endpoint {
  static const _channelPrefix = 'serverpod_chat.';
  static const _initialMessageChunkSize = 20;
  static const _messageChunkSize = 100;

  @override
  bool get requireLogin => true;

  @override
  Future<void> streamOpened(StreamingSession session) async {
    print('streamOpened');
    setUserObject(session, ChatSessionInfo(
      userInfo: await Users.findUserByUserId(session, (await session.auth.authenticatedUserId)!),
    ));
  }

  @override
  Future<void> handleStreamMessage(StreamingSession session, SerializableEntity message) async {
    print('handleStreamMessage ${message.runtimeType}');
    var chatSession = getUserObject(session) as ChatSessionInfo;

    if (message is ChatJoinChannel) {
      print('Join channel: ${message.channel}');
      // Check if user is allowed to access this channel
      if (!await ChatConfig.current.channelAccessVerification(session, (await session.auth.authenticatedUserId)!, message.channel)) {
        print(' - Access denied');
        await sendStreamMessage(session, ChatJoinChannelFailed(channel: message.channel, reason: 'Access denied'));
        return;
      }

      // Setup a listener that passes on messages from the subscribed channel
      var messageListener = (SerializableEntity message) {
        print('passing on message');
        sendStreamMessage(session, message);
      };
      session.messages.addListener(_channelPrefix + message.channel, messageListener);
      chatSession.messageListeners[message.channel] = messageListener;

      var initialMessageChunk = await _fetchMessageChunk(session, message.channel, _initialMessageChunkSize);

      await sendStreamMessage(
        session,
        ChatJoinedChannel(
          channel: message.channel,
          initialMessageChunk: initialMessageChunk,
          lastReadMessageId: await _getLastReadMessage(session, message.channel, chatSession.userInfo!.id!),
        ),
      );
    }
    else if (message is ChatLeaveChannel) {
      // Remove listener for a subscribed channel
      var listener = chatSession.messageListeners[message.channel];
      if (listener != null) {
        session.messages.removeListener(message.className, listener);
        chatSession.messageListeners.remove(message.channel);
      }
    }
    else if (message is ChatMessagePost) {
      // Check that the message is in a channel we're subscribed to
      if (!chatSession.messageListeners.containsKey(message.channel)) {
        print('Got message, but client is not subscribed to channel: ${message.channel}');
        return;
      }

      print('Got message');

      // Write the message to the database, then pass it on to this and other clients.
      var chatMessage = ChatMessage(
        channel: message.channel,
        type: message.type,
        message: message.message,
        time: DateTime.now(),
        sender: (await session.auth.authenticatedUserId)!,
        senderInfo: chatSession.userInfo,
        removed: false,
        clientMessageId: message.clientMessageId,
        sent: true,
      );

      await session.db.insert(chatMessage);

      session.messages.postMessage(_channelPrefix + message.channel, chatMessage);
    }
    else if (message is ChatReadMessage) {
      // Store last read message.
      await _setLastReadMessage(
        session,
        message.channel,
        (await session.auth.authenticatedUserId)!,
        message.lastReadMessageId,
      );
    }
  }

  Future<ChatMessageChunk> _fetchMessageChunk(Session session, String channel, int size, [int? lastId]) async {
    List<ChatMessage> messages;
    if (lastId != null) {
      messages = (await session.db.find(
        tChatMessage,
        where: (tChatMessage.channel.equals(channel)) & tChatMessage.id < lastId,
        orderBy: tChatMessage.id,
        orderDescending: true,
        limit: size + 1,
      )).cast<ChatMessage>();
    }
    else {
      messages = (await session.db.find(
        tChatMessage,
        where: (tChatMessage.channel.equals(channel)),
        orderBy: tChatMessage.id,
        orderDescending: true,
        limit: size + 1,
      )).cast<ChatMessage>();
    }

    var hasOlderMessages = false;
    if (messages.length > size) {
      hasOlderMessages = true;
      messages.removeLast();
    }

    for (var message in messages) {
      await _formatChatMessage(session, message);
    }

    return ChatMessageChunk(
      messages: messages.reversed.toList(),
      hasOlderMessages: hasOlderMessages,
    );
  }

  Future<void> _formatChatMessage(Session session, ChatMessage message) async {
    message.senderInfo = await Users.findUserByUserId(session, message.sender);
  }

  Future<int> _getLastReadMessage(Session session, String channel, int userId) async {
    var readMessageRow = (await session.db.findSingleRow(
      tChatReadMessage,
      where: tChatReadMessage.channel.equals(channel) & tChatReadMessage.userId.equals(userId),
    )) as ChatReadMessage?;

    if (readMessageRow == null) {
      return 0;
    }
    return readMessageRow.lastReadMessageId;
  }

  Future<void> _setLastReadMessage(Session session, String channel, int userId, int lastReadMessageId) async {
    print('setLastReadMessage channel: $channel user: $userId message: $lastReadMessageId');
    var readMessageRow = (await session.db.findSingleRow(
      tChatReadMessage,
      where: tChatReadMessage.channel.equals(channel) & tChatReadMessage.userId.equals(userId),
    )) as ChatReadMessage?;

    if (readMessageRow == null) {
      readMessageRow = ChatReadMessage(
        channel: channel,
        userId: userId,
        lastReadMessageId: lastReadMessageId,
      );
      await session.db.insert(readMessageRow);
    }
    else {
      readMessageRow.lastReadMessageId = lastReadMessageId;
      await session.db.update(readMessageRow);
    }
  }
}

class ChatSessionInfo {
  final messageListeners = <String, MessageCentralListenerCallback>{};
  final UserInfo? userInfo;

  ChatSessionInfo({
    this.userInfo,
  });
}