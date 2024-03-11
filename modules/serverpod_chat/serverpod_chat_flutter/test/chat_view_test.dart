import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:serverpod_chat_client/serverpod_chat_client.dart';

import 'package:serverpod_chat_flutter/serverpod_chat_flutter.dart';

void main() {
  testWidgets(
      'ChatView: Does not show `leading` while there are still earlier messages to load',
      (tester) async {
    var mockController = MockChatController();
    var mockMessage = ChatMessage(
      message: 'Test message',
      channel: '',
      removed: false,
      sender: 1,
      time: DateTime.utc(2021),
    );

    when(() => mockController.scrollOffset).thenReturn(0);
    when(() => mockController.scrollAtBottom).thenReturn(true);
    when(() => mockController.messages).thenReturn(
      [mockMessage, mockMessage, mockMessage],
    );
    when(() => mockController.hasOlderMessages).thenReturn(true);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChatView(
            controller: mockController,
            leading: const Text('Intro text'),
          ),
        ),
      ),
    );

    var leadingFinder = find.text('Intro text');
    expect(leadingFinder, findsNothing);

    expect(find.text('Test message'), findsNWidgets(3));
  });

  testWidgets(
      'ChatView: Shows `leading` when there are no more earlier messages to load',
      (tester) async {
    var mockController = MockChatController();
    var mockMessage = ChatMessage(
      message: 'Test message',
      channel: '',
      removed: false,
      sender: 1,
      time: DateTime.utc(2021),
    );

    when(() => mockController.scrollOffset).thenReturn(0);
    when(() => mockController.scrollAtBottom).thenReturn(true);
    when(() => mockController.messages).thenReturn(
      [mockMessage, mockMessage, mockMessage],
    );
    when(() => mockController.hasOlderMessages).thenReturn(false);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChatView(
            controller: mockController,
            leading: const Text('Intro text'),
          ),
        ),
      ),
    );

    var leadingFinder = find.text('Intro text');
    expect(leadingFinder, findsOneWidget);

    expect(find.text('Test message'), findsNWidgets(3));
  });
}

class MockChatController extends Mock implements ChatController {}
