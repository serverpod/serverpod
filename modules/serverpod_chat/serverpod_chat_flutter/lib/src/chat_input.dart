import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serverpod_chat_flutter/serverpod_chat_flutter.dart';

class ChatInput extends StatefulWidget {
  final ChatController controller;
  final InputDecoration? inputDecoration;
  final BoxDecoration? boxDecoration;
  final EdgeInsets? padding;
  final String? hintText;
  final TextStyle? style;

  const ChatInput({
    Key? key,
    required this.controller,
    this.inputDecoration,
    this.boxDecoration,
    this.padding,
    this.hintText,
    this.style,
  }) : super(key: key);

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _textController = TextEditingController();

  late final _focusNode = FocusNode(
    onKey: (FocusNode node, RawKeyEvent evt) {
      if (!evt.isShiftPressed && evt.logicalKey.keyLabel == 'Enter') {
        if (evt is RawKeyDownEvent) {
          _sendMessage();
        }
        return KeyEventResult.handled;
      }
      else {
        return KeyEventResult.ignored;
      }
    },
  );

  void _sendMessage() {
    String text = _textController.text.trim();
    if (text.isEmpty)
      return;

    widget.controller.postTextMessage(text);

    _textController.text = '';
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.boxDecoration ?? BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TextField(
                autofocus: true,
                style: widget.style,
                minLines: 1,
                maxLines: 10,
                controller: _textController,
                focusNode: _focusNode,
                decoration: widget.inputDecoration ?? const InputDecoration(
                  hintText: 'Send a message...',
                  isDense: false,
                  border: InputBorder.none,
                ).copyWith(hintText: widget.hintText),
              ),
            ),
          ),
          // Icon(
          //   Icons.attach_file_rounded,
          //   color: Theme.of(context).textTheme.caption!.color,
          // ),
        ],
      ),
    );
  }
}
