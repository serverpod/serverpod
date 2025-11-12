import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class SessionAuthenticationStreamingEndpoint extends Endpoint {
  @override
  Future<void> streamOpened(StreamingSession session) async {
    var auth = session.authenticated;
    // ignore: deprecated_member_use
    await sendStreamMessage(
      session,
      SimpleData(num: auth != null ? 1 : 0),
    );
  }

  @override
  Future<void> handleStreamMessage(
    StreamingSession session,
    SerializableModel message,
  ) async {
    var auth = session.authenticated;
    // ignore: deprecated_member_use
    await sendStreamMessage(
      session,
      SimpleData(num: auth != null ? 1 : 0),
    );
  }

  @override
  Future<void> streamClosed(StreamingSession session) async {}
}
