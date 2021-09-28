import 'package:flutter/material.dart';
import 'package:serverpod_chat_client/module.dart';
import 'package:serverpod_chat_flutter/serverpod_chat_flutter.dart';
import 'package:serverpod_chat_flutter/src/chat_dispatch.dart';

typedef ChatTileBuilder = Widget Function(BuildContext context, ChatMessage message, ChatMessage? previous);

class ChatView extends StatefulWidget {
  final Caller caller;
  final String channel;
  final ChatTileBuilder? tileBuilder;

  const ChatView({
    Key? key,
    required this.caller,
    required this.channel,
    this.tileBuilder,
  }) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _messages = <ChatMessage>[];
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    var dispatch = ChatDispatch.getInstance(widget.caller);
    dispatch.addListener(widget.channel, _handleChatMessage);
  }

  void _handleChatMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      controller: _scrollController,
      itemBuilder: _chatItemBuilder,
      itemCount: _messages.length,
    );
  }

  Widget _chatItemBuilder(BuildContext context, int item) {
    // Revers the list, because the scroll view is reversed
    var message = _messages[_messages.length - item - 1];
    ChatMessage? previous;
    if (item < _messages.length - 1) {
      previous = _messages[_messages.length - item - 2];
    }
    var tileBuilder = widget.tileBuilder ?? _defaultTileBuilder;
    return tileBuilder(context, message, previous);
  }

  Widget _defaultTileBuilder(BuildContext context, ChatMessage message) {
    return ListTile(
      title: Text(message.message),
      subtitle: Text(message.senderInfo?.userName ?? 'Unknown user'),
    );
  }
}
