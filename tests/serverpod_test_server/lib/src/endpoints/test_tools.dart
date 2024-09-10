import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class TestToolsEndpoint extends Endpoint {
  Future<String> returnsString(Session session, String string) async {
    return string;
  }

  Stream<int> returnsStream(Session session, int n) {
    return Stream<int>.fromIterable(
      List<int>.generate(n, (index) => index),
    );
  }

  Future<List<int>> returnsListFromInputStream(
      Session session, Stream<int> numbers) async {
    return numbers.toList();
  }

  Stream<int> returnsStreamFromInputStream(
      Session session, Stream<int> numbers) async* {
    await for (var number in numbers) {
      yield number;
    }
  }

  static const sharedStreamName = 'shared-stream';
  Future<void> pushNumberToSharedStream(Session session, int number) async {
    await session.messages
        .postMessage(sharedStreamName, SimpleData(num: number));
  }

  Stream<int> listenForNumbersOnSharedStream(Session session) async* {
    var sharedStream =
        session.messages.createStream<SimpleData>(sharedStreamName);

    await for (var message in sharedStream) {
      yield message.num;
    }
  }

  Future<void> createSimpleData(Session session, int data) async {
    await SimpleData.db.insertRow(
      session,
      SimpleData(
        num: data,
      ),
    );
  }

  Future<List<SimpleData>> getAllSimpleData(Session session) async {
    return SimpleData.db.find(session);
  }
}

class AuthenticatedTestToolsEndpoint extends Endpoint {
  @override
  get requireLogin => true;

  @override
  get requiredScopes => {Scope('user')};

  Future<String> returnsString(Session session, String string) async {
    return string;
  }

  Stream<int> returnsStream(Session session, int n) {
    return Stream<int>.fromIterable(
      List<int>.generate(n, (index) => index),
    );
  }
}
