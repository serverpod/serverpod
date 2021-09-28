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

  var _messageAdded = false;
  var _offset = 0.0;
  var _maxExtent = 0.0;

  var _lastHeight = 0.0;

  @override
  void initState() {
    super.initState();
    var dispatch = ChatDispatch.getInstance(widget.caller);
    dispatch.addListener(widget.channel, _handleChatMessage);
  }

  void _handleChatMessage(ChatMessage message) {
    _offset = _scrollController.offset;
    _maxExtent = _scrollController.position.maxScrollExtent;
    _messageAdded = true;

    setState(() {
      _messages.add(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_messageAdded) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (_offset == _maxExtent) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 300),
          );
        }
      });
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (_lastHeight != constraints.maxHeight) {
          _lastHeight = constraints.maxHeight;

          if (_scrollController.hasClients && _scrollController.offset == _scrollController.position.maxScrollExtent) {
            WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
            });
          }
        }

        // _pinnedToBottom = _scrollController.position == _scrollController.position.maxScrollExtent;

        return ListView.builder(
          reverse: false,
          controller: _scrollController,
          itemBuilder: _chatItemBuilder,
          itemCount: _messages.length,
        );
      },
    );
  }

  Widget _chatItemBuilder(BuildContext context, int item) {
    // Revers the list, because the scroll view is reversed
    var message = _messages[item];
    ChatMessage? previous;
    if (item > 0) {
      previous = _messages[item - 1];
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
