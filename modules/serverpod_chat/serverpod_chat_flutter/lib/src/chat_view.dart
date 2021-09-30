import 'package:flutter/material.dart';
import 'package:serverpod_chat_client/module.dart';
import 'package:serverpod_chat_flutter/serverpod_chat_flutter.dart';
import 'package:serverpod_chat_flutter/src/chat_dispatch.dart';

typedef ChatTileBuilder = Widget Function(BuildContext context, ChatMessage message, ChatMessage? previous);

class ChatView extends StatefulWidget {
  final ChatController controller;
  final ChatTileBuilder? tileBuilder;

  const ChatView({
    Key? key,
    required this.controller,
    this.tileBuilder,
  }) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _fadeInAnimation;

  var _scrollToBottom = true;
  var _messageAdded = false;
  var _offset = 0.0;
  var _maxExtent = 0.0;

  var _lastHeight = 0.0;

  @override
  void initState() {
    super.initState();
    widget.controller.addMessageReceivedListener(_handleNewChatMessage);
    widget.controller.addMessageUpdatedListener(_handleUpdatedChatMessage);

    // Restore scroll
    _scrollController = ScrollController(
      initialScrollOffset: widget.controller.scrollOffset,
    );
    _scrollToBottom = widget.controller.scrollAtBottom;

    _scrollController.addListener(() {
      widget.controller.scrollOffset = _scrollController.offset;
      widget.controller.scrollAtBottom = _scrollController.offset == _scrollController.position.maxScrollExtent;
    });

    // Fade in animation to mask initial jump to bottom of scroll view
    _fadeInAnimation = AnimationController(vsync: this);
    _fadeInAnimation.value = 0.0;
    _fadeInAnimation.addListener(() {
      setState(() {});
    });
    _fadeInAnimation.animateTo(1.0, duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    widget.controller.removeMessageReceivedListener(_handleNewChatMessage);
    widget.controller.removeMessageUpdatedListener(_handleUpdatedChatMessage);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleNewChatMessage(ChatMessage message) {
    _offset = _scrollController.offset;
    _maxExtent = _scrollController.position.maxScrollExtent;
    _messageAdded = true;

    setState(() {});
  }

  void _handleUpdatedChatMessage() {
    setState(() {});
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
    if (_scrollToBottom) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
        setState(() {
          _scrollToBottom = false;
        });
      });
    }

    return Opacity(
      opacity: _fadeInAnimation.value,
      child: LayoutBuilder(
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

          return Align(
            alignment: Alignment.bottomCenter,
            child: ListView.builder(
              shrinkWrap: true,
              reverse: false,
              controller: _scrollController,
              itemBuilder: _chatItemBuilder,
              itemCount: widget.controller.messages.length,
            ),
          );
        },
      ),
    );
  }

  Widget _chatItemBuilder(BuildContext context, int item) {
    // Revers the list, because the scroll view is reversed
    var message = widget.controller.messages[item];
    ChatMessage? previous;
    if (item > 0) {
      previous = widget.controller.messages[item - 1];
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
