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
      'Given a bad request message when building websocket message from string then BadRequestMessage is returned.',
      () {
    var message = BadRequestMessage.buildMessage('This is a bad request');
    var result = WebSocketMessage.fromJsonString(message);
    expect(result, isA<BadRequestMessage>());
  });

  test(
      'Given a bad request message without mandatory field building websocket message from string then UnknownMessageException is thrown having TypeError error type.',
      () {
    /// Missing mandatory field 'request'
    var message = '{"messageType": "bad_request_message"}';
    expect(
      () => WebSocketMessage.fromJsonString(message),
      throwsA(
        isA<UnknownMessageException>()
            .having((e) => e.error, 'error', isA<TypeError>()),
      ),
    );
  });

  test(
      'Given a upper cased command message when building websocket message from string then UnknownMessageException is thrown.',
      () {
    var message = PingCommand.buildMessage().toUpperCase();
    expect(
      () => WebSocketMessage.fromJsonString(message),
      throwsA(isA<UnknownMessageException>()),
    );
  });

  test(
      'Given an unknown command json String when building websocket message from string then UnknownMessageException is thrown.',
      () {
    var message = '{"messageType": "this is not a known message type"}';
    expect(
      () => WebSocketMessage.fromJsonString(message),
      throwsA(isA<UnknownMessageException>()),
    );
  });

  test(
      'Given an invalid json String when building websocket message from string then UnknownMessageException is thrown having FormatException error type.',
      () {
    var message = 'This is not a valid json string';
    expect(
      () => WebSocketMessage.fromJsonString(message),
      throwsA(
        isA<UnknownMessageException>()
            .having((e) => e.error, 'error', isA<FormatException>()),
      ),
    );
  });

  test(
      'Given a null messageType when building websocket message from string then UnknownMessageException is thrown.',
      () {
    var message = '{"messageType": null}';
    expect(
      () => WebSocketMessage.fromJsonString(message),
      throwsA(isA<UnknownMessageException>()),
    );
  });

  test(
      'Given an open method stream command when building websocket message from string then OpenMethodStreamCommand is returned.',
      () {
    var message = OpenMethodStreamCommand.buildMessage(
      endpoint: 'endpoint',
      method: 'method',
      args: {'arg1': 'value1', 'arg2': 2},
      uuid: 'uuid',
      auth: 'auth',
    );
    var result = WebSocketMessage.fromJsonString(message);
    expect(result, isA<OpenMethodStreamCommand>());
  });

  test(
      'Given an invalid open method stream command json String that is missing mandatory endpoint field when building websocket message from string then UnknownMessageException is thrown having FormatException error type.',
      () {
    // This message is missing the mandatory endpoint field.
    var message = '''{
      "messageType": "open_method_stream_command',
      "method": "method',
      "args": {"arg1": "value1", "arg2": 2},
      "uuid": "uuid",
      "auth": "auth",
    }''';

    expect(
      () => WebSocketMessage.fromJsonString(message),
      throwsA(
        isA<UnknownMessageException>()
            .having((e) => e.error, 'error', isA<FormatException>()),
      ),
    );
  });
}
