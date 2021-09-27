import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';
import '../generated/protocol.dart';

class ChatEndpoint extends Endpoint {
  static const _channelPrefix = 'serverpod_chat_';

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
      print('Join channel');
      // TODO: Check if we are allowed to join this channel
      var messageListener = (SerializableEntity message) {
        print('passing on message');
        sendStreamMessage(session, message);
      };
      session.messages.addListener(session, _channelPrefix + message.channel, messageListener);
      chatSession.messageListeners[message.channel] = messageListener;

      // TODO: Fetch old messages
      await sendStreamMessage(
        session,
        ChatJoinedChannel(channel: message.channel, messages: []),
      );
    }
    else if (message is ChatLeaveChannel) {
      // TODO: Remove listener
    }
    else if (message is ChatMessagePost) {
      print('Got message');
      var chatMessage = ChatMessage(
        channel: message.channel,
        type: message.type,
        message: message.message,
        time: DateTime.now(),
        sender: (await session.auth.authenticatedUserId)!,
        senderInfo: chatSession.userInfo,
        removed: false,
      );

      session.messages.postMessage(_channelPrefix + message.channel, chatMessage);
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