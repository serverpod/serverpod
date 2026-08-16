import 'package:serverpod/serverpod.dart';

class StreamingEndpoint extends Endpoint {
  Stream<int> intEchoStream(Session session, Stream<int> stream) async* {
    await for (var value in stream) {
      yield value;
    }
  }

  Future<int> simpleInputReturnStream(
    Session session,
    Stream<int> stream,
  ) async {
    return stream.first;
  }
}
