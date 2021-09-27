import 'package:flutter/material.dart';
import 'package:serverpod_chat_client/module.dart';
import 'package:serverpod_chat_flutter/src/chat_dispatch.dart';

class ChatView extends StatefulWidget {
  final Caller caller;
  final String channel;

  const ChatView({
    Key? key,
    required this.caller,
    required this.channel,
  }) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _messages = <ChatMessage>[];

  @override
  void initState() {
    super.initState();
    var dispatch = ChatDispatch.getInstance(widget.caller);
    dispatch.addListener(widget.channel, _handleChatMessage);
  }

  void _handleChatMessage(ChatMessage message) {
    print('adding chat message');
    setState(() {
      _messages.add(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    var tiles = <ListTile>[];
    for (var message in _messages) {
      tiles.add(
        ListTile(
          title: Text(message.message),
          subtitle: Text(message.senderInfo?.userName ?? 'Unknown user'),
        ),
      );
    }

    return ListView(
      children: tiles,
    );
  }
}
