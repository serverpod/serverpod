import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

class _TestSerializationManager extends SerializationManager {
  _TestSerializationManager();
  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'] == '_SimpleData') {
      return deserialize<_SimpleData>(data['data']);
    }
    if (data['className'] == '_TestSerializableException') {
      return deserialize<_TestSerializableException>(data['data']);
    }

    return super.deserializeByClassName(data);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _SimpleData) {
      return '_SimpleData';
    }
    if (data is _TestSerializableException) {
      return '_TestSerializableException';
    }
    return null;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _SimpleData) {
      return _SimpleData.fromJson(data) as T;
    }
    if (t == _TestSerializableException) {
      return _TestSerializableException() as T;
    }

    return super.deserialize<T>(data, t);
  }
}

class _SimpleData implements SerializableModel, ProtocolSerialization {
  final String data;
  final String? serverOnlyField;

  _SimpleData(this.data, {this.serverOnlyField});

  @override
  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'serverOnlyField': serverOnlyField,
    };
  }

  @override
  factory _SimpleData.fromJson(Map<String, dynamic> json) {
    return _SimpleData(json['data'], serverOnlyField: json['serverOnlyField']);
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'data': data,
    };
  }
}

class _TestSerializableException
    implements SerializableException, ProtocolSerialization {
  @override
  Map<String, dynamic> toJson() {
    return {
      'serverOnlyField': 'serverOnly',
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }
}

void main() {
  test(
      'Given a Ping command message when building websocket message from string then PingCommand is returned.',
      () {
    var message = PingCommand.buildMessage();
    var result = WebSocketMessage.fromJsonString(
      message,
      _TestSerializationManager(),
    );
    expect(result, isA<PingCommand>());
  });

  test(
      'Given a Pong command message when building websocket message from string then PongCommand is returned.',
      () {
    var message = PongCommand.buildMessage();
    var result = WebSocketMessage.fromJsonString(
      message,
      _TestSerializationManager(),
    );
    expect(result, isA<PongCommand>());
  });

  test(
      'Given a bad request message when building websocket message from string then BadRequestMessage is returned.',
      () {
    var message = BadRequestMessage.buildMessage('This is a bad request');
    var result = WebSocketMessage.fromJsonString(
      message,
      _TestSerializationManager(),
    );
    expect(result, isA<BadRequestMessage>());
  });

  test(
      'Given a bad request message without mandatory field building websocket message from string then UnknownMessageException is thrown having TypeError error type.',
      () {
    /// Missing mandatory field 'request'
    var message = '{"messageType": "bad_request_message"}';
    expect(
      () => WebSocketMessage.fromJsonString(
        message,
        _TestSerializationManager(),
      ),
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
      () => WebSocketMessage.fromJsonString(
        message,
        _TestSerializationManager(),
      ),
      throwsA(isA<UnknownMessageException>()),
    );
  });

  test(
      'Given an unknown command json String when building websocket message from string then UnknownMessageException is thrown.',
      () {
    var message = '{"messageType": "this is not a known message type"}';
    expect(
      () => WebSocketMessage.fromJsonString(
        message,
        _TestSerializationManager(),
      ),
      throwsA(isA<UnknownMessageException>()),
    );
  });

  test(
      'Given an invalid json String when building websocket message from string then UnknownMessageException is thrown having FormatException error type.',
      () {
    var message = 'This is not a valid json string';
    expect(
      () => WebSocketMessage.fromJsonString(
        message,
        _TestSerializationManager(),
      ),
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
      () => WebSocketMessage.fromJsonString(
        message,
        _TestSerializationManager(),
      ),
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
      connectionId: const Uuid().v4obj(),
      authentication: 'auth',
    );
    var result = WebSocketMessage.fromJsonString(
      message,
      _TestSerializationManager(),
    );
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
      "authentication": "auth",
    }''';

    expect(
      () => WebSocketMessage.fromJsonString(
        message,
        _TestSerializationManager(),
      ),
      throwsA(
        isA<UnknownMessageException>()
            .having((e) => e.error, 'error', isA<FormatException>()),
      ),
    );
  });

  test(
      'Given an open method stream response when building websocket message from string then OpenMethodStreamResponse is returned.',
      () {
    var message = OpenMethodStreamResponse.buildMessage(
      connectionId: const Uuid().v4obj(),
      responseType: OpenMethodStreamResponseType.success,
    );
    var result = WebSocketMessage.fromJsonString(
      message,
      _TestSerializationManager(),
    );
    expect(result, isA<OpenMethodStreamResponse>());
  });

  test(
      'Given an open method stream response with an invalid response type when building websocket message from string then UnknownMessageException is thrown.',
      () {
    var message = '''{
      "messageType": "open_method_stream_response",
      "uuid": "uuid",
      "responseType": "this response type does not exist"
    }''';

    expect(
      () => WebSocketMessage.fromJsonString(
        message,
        _TestSerializationManager(),
      ),
      throwsA(isA<UnknownMessageException>()),
    );
  });

  test(
      'Given a close method stream command when building websocket message from string then CloseMethodStreamCommand is returned.',
      () {
    var message = CloseMethodStreamCommand.buildMessage(
      connectionId: const Uuid().v4obj(),
      endpoint: 'endpoint',
      parameter: 'parameter',
      method: 'method',
      reason: CloseReason.done,
    );
    var result = WebSocketMessage.fromJsonString(
      message,
      _TestSerializationManager(),
    );
    expect(result, isA<CloseMethodStreamCommand>());
  });

  test(
      'Given an invalid close method stream command json String that is missing mandatory uuid field when building websocket message from string then UnknownMessageException is thrown having FormatException error type.',
      () {
    // This message is missing the mandatory uuid field.
    var message = '''{
      "messageType": "close_method_stream_command",
      "endpoint": "endpoint",
      "parameter": "parameter",
      "method": "method",
      "reason": "done",
    }''';
    expect(
      () => WebSocketMessage.fromJsonString(
        message,
        _TestSerializationManager(),
      ),
      throwsA(
        isA<UnknownMessageException>()
            .having((e) => e.error, 'error', isA<FormatException>()),
      ),
    );
  });

  test(
      'Given an close method stream command with an invalid reason when building websocket message from string then UnknownMessageException is thrown.',
      () {
    var message = '''{
      "messageType": "close_method_stream_command",
      "uuid": "uuid",
      "endpoint": "endpoint",
      "parameter": "parameter",
      "method": "method",
      "reason": "this reason does not exist"
    }''';
    expect(
      () => WebSocketMessage.fromJsonString(
        message,
        _TestSerializationManager(),
      ),
      throwsA(isA<UnknownMessageException>()),
    );
  });

  test(
      'Given a method stream message when building websocket message from string then MethodStreamMessage is returned.',
      () {
    var serializationManager = _TestSerializationManager();
    var message = MethodStreamMessage.buildMessage(
      endpoint: 'endpoint',
      method: 'method',
      connectionId: const Uuid().v4obj(),
      object: _SimpleData('hello world'),
      serializationManager: serializationManager,
    );
    var result = WebSocketMessage.fromJsonString(
      message,
      _TestSerializationManager(),
    );
    expect(result, isA<MethodStreamMessage>());
  });

  test(
      'Given serializable model with server only field when building MethodStreamMessage then server only field is not included in serialization.',
      () {
    var serializationManager = _TestSerializationManager();
    var message = MethodStreamMessage.buildMessage(
      endpoint: 'endpoint',
      method: 'method',
      connectionId: const Uuid().v4obj(),
      object: _SimpleData('hello world', serverOnlyField: 'this is awesome'),
      serializationManager: serializationManager,
    );

    expect(message, isNot(contains('serverOnlyField')));
  });

  test(
      'Given an invalid method stream message json String that is missing mandatory endpoint field when building websocket message from string then UnknownMessageException is thrown.',
      () {
    // This message is missing the mandatory endpoint field.
    var message = '''{
      "messageType": "method_stream_message",
      "method": "method",
      "uuid": "uuid",
      "object": '{"className": "bamboo", "data": {"number": 2}}',
    }''';

    expect(
      () => WebSocketMessage.fromJsonString(
        message,
        _TestSerializationManager(),
      ),
      throwsA(
        isA<UnknownMessageException>()
            .having((e) => e.error, 'error', isA<FormatException>()),
      ),
    );
  });

  test(
      'Given method stream serializable exception when building websocket message from string then MethodStreamSerializableException is returned.',
      () {
    var serializationManager = _TestSerializationManager();
    var message = MethodStreamSerializableException.buildMessage(
      endpoint: 'endpoint',
      method: 'method',
      connectionId: const Uuid().v4obj(),
      object: _TestSerializableException(),
      serializationManager: serializationManager,
    );
    var result = WebSocketMessage.fromJsonString(
      message,
      _TestSerializationManager(),
    );
    expect(result, isA<MethodStreamSerializableException>());
  });

  test(
      'Given serializable exception with server only field when building MethodStreamSerializableException message then server only field is not included in serialization',
      () {
    var serializationManager = _TestSerializationManager();
    var message = MethodStreamSerializableException.buildMessage(
      endpoint: 'endpoint',
      method: 'method',
      connectionId: const Uuid().v4obj(),
      object: _TestSerializableException(),
      serializationManager: serializationManager,
    );

    expect(message, isNot(contains('serverOnlyField')));
  });

  test(
      'Given invalid method stream serializable exception json String when building websocket message from string then UnknownMessageException is thrown.',
      () {
    // This message is missing the mandatory endpoint field.
    var message = '''{
      "messageType": "method_stream_serializable_exception",
      "method": "method",
      "uuid": "uuid",
      "object": '{"className": "serializableException", "data": {"message": "error message"}}',
    }''';

    expect(
      () => WebSocketMessage.fromJsonString(
        message,
        _TestSerializationManager(),
      ),
      throwsA(
        isA<UnknownMessageException>()
            .having((e) => e.error, 'error', isA<FormatException>()),
      ),
    );
  });
}
