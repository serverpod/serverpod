// ignore_for_file: public_member_api_docs

/// Keys used in the top level of messages.
abstract class WebSocketMessageKey {
  static const String messageTypeKey = 'type';
  static const String messageDataKey = 'data';
}

/// Keys used to identify message types.
abstract class WebSocketMessageTypeKey {
  static const String badRequestMessageTypeKey = 'bad_request_message';
  static const String closeMethodStreamCommandTypeKey =
      'close_method_stream_command';
  static const String methodStreamMessageTypeKey = 'method_message';
  static const String methodStreamSerializableExceptionTypeKey =
      'method_stream_serializable_exception';
  static const String openMethodStreamCommandTypeKey =
      'open_method_stream_command';
  static const String pingCommandTypeKey = 'ping_command';
  static const String pongCommandTypeKey = 'pong_command';
}

/// Keys used inside the "data" part of messages.
abstract class WebSocketMessageDataKey {
  static const String argsKey = 'args';
  static const String authenticationKey = 'authentication';
  static const String closeReasonKey = 'reason';
  static const String connectionIdKey = 'connectionId';
  static const String endpointKey = 'endpoint';
  static const String exceptionKey = 'exception';
  static const String inputStreamsKey = 'inputStreams';
  static const String methodKey = 'method';
  static const String objectKey = 'object';
  static const String parameterKey = 'parameter';
  static const String requestKey = 'request';
  static const String responseTypeKey = 'responseType';
}
