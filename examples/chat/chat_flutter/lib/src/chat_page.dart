import 'package:flutter/material.dart';
import 'package:serverpod_chat_flutter/serverpod_chat_flutter.dart';

/// Shows the ChatView and ChatInput for a chat controller.
class ChatPage extends StatelessWidget {
  const ChatPage({
    required this.controller,
    Key? key,
  }) : super(key: key);

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mq = MediaQuery.of(context);

    return Column(
      children: [
        Expanded(
          child: ChatView(controller: controller),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              top: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          padding: EdgeInsets.only(bottom: mq.padding.bottom),
          child: ChatInput(controller: controller),
        ),
      ],
    );
  }
}
