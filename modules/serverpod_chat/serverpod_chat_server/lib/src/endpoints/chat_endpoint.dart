import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image/image.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';

import '../business/config.dart';
import '../generated/protocol.dart';

/// Connect to the chat endpoint to send and receive chat messages.
class ChatEndpoint extends Endpoint {
  static const _channelPrefix = 'serverpod_chat.';
  static const _ephemeralChannelPrefix = 'ephemeral.';
  static const _initialMessageChunkSize = 25;
  static const _messageChunkSize = 50;

  static int _tempUserId = -1;

  @override
  Future<void> streamOpened(StreamingSession session) async {
    var userId = await session.auth.authenticatedUserId;

    if (userId != null) {
      setUserObject(
          session,
          _ChatSessionInfo(
            userInfo: await Users.findUserByUserId(session, userId),
          ));
    } else {
      setUserObject(session, _ChatSessionInfo());
    }
  }

  @override
  Future<void> handleStreamMessage(
      StreamingSession session, SerializableEntity message) async {
    var chatSession = getUserObject(session) as _ChatSessionInfo;

    if (message is ChatJoinChannel) {
      // TODO: Check if unauthenticated users is ok
      if (!ChatConfig.current.allowUnauthenticatedUsers &&
          (await session.auth.authenticatedUserId) == null) {
        await sendStreamMessage(
            session,
            ChatJoinChannelFailed(
                channel: message.channel,
                reason: 'User must be authenticated'));
      }

      if (message.userName != null && chatSession.userInfo == null) {
        // Setup a temporary userInfo
        chatSession.userInfo = UserInfo(
          id: _tempUserId,
          userIdentifier: '',
          userName: message.userName!,
          created: DateTime.now().toUtc(),
          scopeNames: [],
          active: true,
          blocked: false,
        );
        _tempUserId -= 1;
      }

      if (chatSession.userInfo?.id == null) {
        await sendStreamMessage(
            session,
            ChatJoinChannelFailed(
                channel: message.channel, reason: 'User not found'));
        return;
      }

      // Check if user is allowed to access this channel
      if (!await ChatConfig.current.channelAccessVerification(
          session, chatSession.userInfo!.id!, message.channel)) {
        await sendStreamMessage(
            session,
            ChatJoinChannelFailed(
                channel: message.channel, reason: 'Access denied'));
        return;
      }

      // Setup a listener that passes on messages from the subscribed channel
      void messageListener(SerializableEntity message) {
        sendStreamMessage(session, message);
      }

      session.messages
          .addListener(_channelPrefix + message.channel, messageListener);
      chatSession.messageListeners[message.channel] = messageListener;

      var initialMessageChunk = await _fetchMessageChunk(
          session, message.channel, _initialMessageChunkSize);

      await sendStreamMessage(
        session,
        ChatJoinedChannel(
          channel: message.channel,
          initialMessageChunk: initialMessageChunk,
          lastReadMessageId: await _getLastReadMessage(
              session, message.channel, chatSession.userInfo!.id!),
          userInfo: chatSession.userInfo!,
        ),
      );
    } else if (message is ChatLeaveChannel) {
      // Remove listener for a subscribed channel
      var listener = chatSession.messageListeners[message.channel];
      if (listener != null) {
        session.messages
            .removeListener(_channelPrefix + message.channel, listener);
        chatSession.messageListeners.remove(message.channel);
      }
    } else if (message is ChatMessagePost) {
      // Check that the message is in a channel we're subscribed to
      if (!chatSession.messageListeners.containsKey(message.channel)) {
        return;
      }

      // Write the message to the database, then pass it on to this and other clients.
      var chatMessage = ChatMessage(
        channel: message.channel,
        message: message.message,
        time: DateTime.now(),
        sender: chatSession.userInfo!.id!,
        senderInfo: chatSession.userInfo,
        removed: false,
        clientMessageId: message.clientMessageId,
        sent: true,
        attachments: message.attachments,
      );

      if (!_isEphemeralChannel(message.channel)) {
        await session.db.insert(chatMessage);
      }

      session.messages.postMessage(
        _channelPrefix + message.channel,
        chatMessage,
        local: ChatConfig.current.postMessagesLocallyOnly,
      );
    } else if (message is ChatReadMessage) {
      // Check that the message is in a channel we're subscribed to
      if (!chatSession.messageListeners.containsKey(message.channel)) {
        return;
      }

      // Store last read message.
      await _setLastReadMessage(
        session,
        message.channel,
        chatSession.userInfo!.id!,
        message.lastReadMessageId,
      );
    } else if (message is ChatRequestMessageChunk) {
      // Check that the message is in a channel we're subscribed to
      if (!chatSession.messageListeners.containsKey(message.channel)) {
        return;
      }

      var chunk = await _fetchMessageChunk(
          session, message.channel, _messageChunkSize, message.lastMessageId);
      await sendStreamMessage(session, chunk);
    }
  }

  Future<ChatMessageChunk> _fetchMessageChunk(
      Session session, String channel, int size,
      [int? lastId]) async {
    if (_isEphemeralChannel(channel)) {
      return ChatMessageChunk(
        channel: channel,
        messages: [],
        hasOlderMessages: false,
      );
    }

    List<ChatMessage> messages;
    if (lastId != null) {
      messages = await ChatMessage.find(
        session,
        where: (t) => t.channel.equals(channel) & (t.id < lastId),
        orderBy: ChatMessage.t.id,
        orderDescending: true,
        limit: size + 1,
      );
    } else {
      messages = await ChatMessage.find(
        session,
        where: (t) => t.channel.equals(channel),
        orderBy: ChatMessage.t.id,
        orderDescending: true,
        limit: size + 1,
      );
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
      channel: channel,
      messages: messages.reversed.toList(),
      hasOlderMessages: hasOlderMessages,
    );
  }

  Future<void> _formatChatMessage(Session session, ChatMessage message) async {
    message.senderInfo = await Users.findUserByUserId(session, message.sender);
  }

  Future<int> _getLastReadMessage(
    Session session,
    String channel,
    int userId,
  ) async {
    var readMessageRow = await ChatReadMessage.findSingleRow(
      session,
      where: (t) => t.channel.equals(channel) & t.userId.equals(userId),
    );

    if (readMessageRow == null) {
      return 0;
    }
    return readMessageRow.lastReadMessageId;
  }

  Future<void> _setLastReadMessage(Session session, String channel, int userId,
      int lastReadMessageId) async {
    var readMessageRow = await ChatReadMessage.findSingleRow(
      session,
      where: (t) => t.channel.equals(channel) & t.userId.equals(userId),
    );

    if (readMessageRow == null) {
      readMessageRow = ChatReadMessage(
        channel: channel,
        userId: userId,
        lastReadMessageId: lastReadMessageId,
      );
      await session.db.insert(readMessageRow);
    } else {
      readMessageRow.lastReadMessageId = lastReadMessageId;
      await session.db.update(readMessageRow);
    }
  }

  /// Creates a description for uploading an attachment.
  Future<ChatMessageAttachmentUploadDescription?>
      createAttachmentUploadDescription(
          Session session, String fileName) async {
    var userId = (await session.auth.authenticatedUserId);
    if (userId == null) return null;

    var filePath = _generateAttachmentFilePath(userId, fileName);

    var uploadDescription = await session.storage
        .createDirectFileUploadDescription(storageId: 'public', path: filePath);
    if (uploadDescription == null) return null;

    return ChatMessageAttachmentUploadDescription(
        filePath: filePath, uploadDescription: uploadDescription);
  }

  /// Verifies that an attachment has been uploaded.
  Future<ChatMessageAttachment?> verifyAttachmentUpload(
      Session session, String fileName, String filePath) async {
    var success = await session.storage
        .verifyDirectFileUpload(storageId: 'public', path: filePath);
    var url =
        await session.storage.getPublicUrl(storageId: 'public', path: filePath);
    var userId = (await session.auth.authenticatedUserId);

    if (userId == null) return null;

    // Generate thumbnail
    Uri? thumbUrl;
    int? thumbWidth;
    int? thumbHeight;

    try {
      const maxImageWidth = 256;

      var ext = path.extension(filePath.toLowerCase());
      if ({'.jpg', '.jpeg', '.png', '.gif'}.contains(ext)) {
        var response = await http.get(url!);
        var bytes = response.bodyBytes;
        var image = decodeImage(bytes);
        if (image != null) {
          if (image.width > maxImageWidth) {
            image = copyResize(image, width: maxImageWidth);
          }
          var thumbPath = _generateAttachmentFilePath(userId, fileName);
          var encodedBytes = Uint8List.fromList(encodeJpg(image, quality: 70));
          var byteData = ByteData.view(encodedBytes.buffer);
          await session.storage.storeFile(
              storageId: 'public', path: thumbPath, byteData: byteData);
          thumbUrl = await session.storage
              .getPublicUrl(storageId: 'public', path: thumbPath);
          if (thumbUrl != null) {
            thumbWidth = image.width;
            thumbHeight = image.height;
          }
        }
      }
    } catch (e) {
      rethrow;
    }

    if (success && url != null) {
      return ChatMessageAttachment(
        fileName: fileName,
        url: url.toString(),
        contentType: 'application/octet-stream',
        previewWidth: thumbWidth,
        previewHeight: thumbHeight,
        previewImage: thumbUrl?.toString(),
      );
    }
    return null;
  }

  String _generateAttachmentFilePath(int userId, String fileName) {
    const len = 16;
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    var rnd = Random();
    var rndString = String.fromCharCodes(Iterable.generate(
        len, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    var dateString = DateTime.now().toUtc().toString().substring(0, 10);

    return 'serverpod/chat/$userId/$dateString/$rndString/$fileName';
  }

  bool _isEphemeralChannel(String channel) {
    return channel.startsWith(_ephemeralChannelPrefix);
  }
}

class _ChatSessionInfo {
  final messageListeners = <String, MessageCentralListenerCallback>{};
  UserInfo? userInfo;

  _ChatSessionInfo({
    this.userInfo,
  });
}
