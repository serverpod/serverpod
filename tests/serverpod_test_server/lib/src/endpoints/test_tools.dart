import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class TestToolsEndpoint extends Endpoint {
  Future<UuidValue> returnsSessionId(Session session) async {
    return session.sessionId;
  }

  Future<List<String?>> returnsSessionEndpointAndMethod(Session session) async {
    return [session.endpoint, session.method];
  }

  Stream<UuidValue> returnsSessionIdFromStream(Session session) async* {
    yield session.sessionId;
  }

  Stream<String?> returnsSessionEndpointAndMethodFromStream(
      Session session) async* {
    yield session.endpoint;
    yield session.method;
  }

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

  Future<List<SimpleData>> returnsSimpleDataListFromInputStream(
      Session session, Stream<SimpleData> simpleDatas) async {
    return simpleDatas.toList();
  }

  Stream<int> returnsStreamFromInputStream(
      Session session, Stream<int> numbers) async* {
    await for (var number in numbers) {
      yield number;
    }
  }

  static const sharedStreamName = 'shared-stream';
  Future<void> postNumberToSharedStream(Session session, int number) async {
    await session.messages
        .postMessage(sharedStreamName, SimpleData(num: number));
  }

  // This obscure scenario is to demonstrate that the stream is consumed right away by the test tools.
  // The test code does not have to start to start listening to the returned stream for it to execute up to the yield.
  Stream<int> postNumberToSharedStreamAndReturnStream(
      Session session, int number) async* {
    await session.messages
        .postMessage(sharedStreamName, SimpleData(num: number));
    yield 1;
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

  Future<void> createSimpleDatasInsideTransactions(
    Session session,
    int data,
  ) async {
    await session.db.transaction((transaction) async {
      await SimpleData.db.insertRow(
        session,
        SimpleData(
          num: data,
        ),
        transaction: transaction,
      );
    });

    await session.db.transaction((transaction) async {
      await SimpleData.db.insertRow(
        session,
        SimpleData(
          num: data,
        ),
        transaction: transaction,
      );
    });
  }

  Future<void> createSimpleDataAndThrowInsideTransaction(
    Session session,
    int data,
  ) async {
    await session.db.transaction((transaction) async {
      await SimpleData.db.insertRow(
        session,
        SimpleData(
          num: data,
        ),
        transaction: transaction,
      );
    });

    await session.db.transaction((transaction) async {
      await SimpleData.db.insertRow(
        session,
        SimpleData(
          num: data,
        ),
        transaction: transaction,
      );

      throw Exception(
          'Some error occurred and transaction should not be committed.');
    });
  }

  Future<void> createSimpleDatasInParallelTransactionCalls(
    Session session,
  ) async {
    Future<void> createSimpleDataInTransaction(int num) async {
      await session.db.transaction((transaction) async {
        await SimpleData.db.insertRow(
          session,
          SimpleData(
            num: num,
          ),
          transaction: transaction,
        );
      });
    }

    await Future.wait([
      createSimpleDataInTransaction(1),
      createSimpleDataInTransaction(2),
      createSimpleDataInTransaction(3),
      createSimpleDataInTransaction(4),
    ]);
  }

  Future<SimpleData> echoSimpleData(
    Session session,
    SimpleData simpleData,
  ) async {
    return simpleData;
  }

  Future<List<SimpleData>> echoSimpleDatas(
    Session session,
    List<SimpleData> simpleDatas,
  ) async {
    return simpleDatas;
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

  Future<List<int>> returnsListFromInputStream(
      Session session, Stream<int> numbers) async {
    return numbers.toList();
  }

  Stream<int> intEchoStream(Session session, Stream<int> stream) async* {
    await for (var value in stream) {
      yield value;
    }
  }
}
