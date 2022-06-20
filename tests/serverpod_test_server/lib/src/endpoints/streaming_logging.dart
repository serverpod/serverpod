import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class StreamingLoggingEndpoint extends Endpoint {
  @override
  Future<void> streamOpened(StreamingSession session) async {
    session.log('streamOpened');
  }

  @override
  Future<void> handleStreamMessage(
    StreamingSession session,
    SerializableEntity message,
  ) async {
    if (message is SimpleData) {
      session.log('handleStreamMessage');
    }
  }
}
