import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

int globalInt = 0;

class StreamingEndpoint extends Endpoint {
  Future<void> handleStreamMessage(Session session, SerializableEntity message) async {
    if (message is SimpleData) {
      print('Got SimpleData: ${message.num}');

      Future.delayed(Duration(seconds: 1)).then((value) async {
        await sendStreamMessage(session, message);
      });
    }
  }
}