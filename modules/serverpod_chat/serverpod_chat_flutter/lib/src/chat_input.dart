import 'package:flutter/material.dart';
import 'package:serverpod_chat_client/module.dart';
import 'package:serverpod_chat_flutter/src/chat_dispatch.dart';

class ChatInput extends StatefulWidget {
  final Caller caller;
  final String channel;

  const ChatInput({
    Key? key,
    required this.caller,
    required this.channel,
  }) : super(key: key);

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _textController = TextEditingController();
  late ChatDispatch _chatDispatch;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _chatDispatch = ChatDispatch.getInstance(widget.caller);
  }

  void _sendMessage() {
    _chatDispatch.postMessage(
      ChatMessagePost(
        channel: widget.channel,
        type: 'text',
        message: _textController.text,
      ),
    );
    _textController.text = '';
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            autofocus: true,
            controller: _textController,
            onSubmitted: (_) { _sendMessage(); },
            focusNode: _focusNode,
          ),
        ),
        MaterialButton(
          child: const Text('Send'),
          onPressed: _sendMessage,
        ),
      ],
    );
  }
}
