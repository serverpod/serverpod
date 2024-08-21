// ignore_for_file: public_member_api_docs

/// Keys used in the top level of messages.
abstract class WebSocketMessageKey {
  static const String messageTypeKey = 'type';
  static const String messageDataKey = 'data';
}

/// Keys used to identify message types.
abstract class WebSocketMessageTypeKey {
  static const String badRequestMessageTypeKey = 'brm';
  static const String closeMethodStreamCommandTypeKey = 'cmsc';
  static const String methodStreamMessageTypeKey = 'msm';
  static const String methodStreamSerializableExceptionTypeKey = 'msse';
  static const String openMethodStreamCommandTypeKey = 'omsc';
  static const String pingCommandTypeKey = 'ping';
  static const String pongCommandTypeKey = 'pong';
}

/// Keys used inside the "data" part of messages.
abstract class WebSocketMessageDataKey {
  static const String argsKey = 'args';
  static const String authenticationKey = 'auth';
  static const String closeReasonKey = 'cr';
  static const String connectionIdKey = 'cid';
  static const String endpointKey = 'en';
  static const String exceptionKey = 'ex';
  static const String inputStreamsKey = 'is';
  static const String methodKey = 'm';
  static const String objectKey = 'o';
  static const String parameterKey = 'p';
  static const String requestKey = 'req';
  static const String responseTypeKey = 'res';
}
