import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class StreamingLoggingEndpoint extends Endpoint {
  static int _logCount = 0;

  @override
  Future<void> streamOpened(StreamingSession session) async {
    _logCount = 0;
    session.log('streamOpened');
  }

  @override
  Future<void> handleStreamMessage(
    StreamingSession session,
    SerializableEntity message,
  ) async {
    if (message is SimpleData) {
      session.log('handleStreamMessage $_logCount');
      _logCount += 1;
    }
  }
}
