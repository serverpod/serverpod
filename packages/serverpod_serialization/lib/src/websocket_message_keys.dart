// ignore_for_file: public_member_api_docs

/// Keys used in the top level of messages.
abstract class WebSocketMessageKey {
  static const String type = 'type';
  static const String data = 'data';
}

/// Keys used to identify message types.
abstract class WebSocketMessageTypeKey {
  static const String badRequestMessage = 'brm';
  static const String closeMethodStreamCommand = 'cmsc';
  static const String methodStreamMessage = 'msm';
  static const String methodStreamSerializableException = 'msse';
  static const String openMethodStreamCommand = 'omsc';
  static const String pingCommand = 'ping';
  static const String pongCommand = 'pong';
}

/// Keys used inside the "data" part of messages.
abstract class WebSocketMessageDataKey {
  static const String args = 'args';
  static const String authentication = 'auth';
  static const String closeReason = 'cr';
  static const String connectionId = 'cid';
  static const String endpoint = 'en';
  static const String exception = 'ex';
  static const String inputStreams = 'is';
  static const String method = 'm';
  static const String object = 'o';
  static const String parameter = 'p';
  static const String request = 'req';
  static const String responseType = 'res';
}
