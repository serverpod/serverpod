import 'package:serverpod_serialization/src/websocket_messages.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a Ping command message when building websocket message from string then PingCommand is returned.',
      () {
    var message = PingCommand.buildMessage();
    var result = WebSocketMessage.fromJsonString(message);
    expect(result, isA<PingCommand>());
  });

  test(
      'Given a Pong command message when building websocket message from string then PongCommand is returned.',
      () {
    var message = PongCommand.buildMessage();
    var result = WebSocketMessage.fromJsonString(message);
    expect(result, isA<PongCommand>());
  });

  test(
      'Given a upper cased command message when building websocket message from string then UnknownMessage is returned.',
      () {
    var message = PingCommand.buildMessage().toUpperCase();
    var result = WebSocketMessage.fromJsonString(message);
    expect(result, isA<UnknownMessage>());
  });

  test(
      'Given an unknown command json String when building websocket message from string then UnknownMessage is returned.',
      () {
    var message = '{"messageType": "this is not a known message type"}';
    var result = WebSocketMessage.fromJsonString(message);
    expect(result, isA<UnknownMessage>());
  });

  test(
      'Given an invalid json String when building websocket message from string then UnknownMessage is returned.',
      () {
    var message = 'This is not a valid json string';
    var result = WebSocketMessage.fromJsonString(message);
    expect(result, isA<UnknownMessage>());
  });

  test(
      'Given a null messageType when building websocket message from string then UnknownMessage is returned.',
      () {
    var message = '{"messageType": null}';
    var result = WebSocketMessage.fromJsonString(message);
    expect(result, isA<UnknownMessage>());
  });
}
