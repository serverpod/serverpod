import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart';
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

  Stream<SimpleData> returnsSimpleDataStreamFromInputStream(
      Session session, Stream<SimpleData> simpleDatas) async* {
    await for (var simpleData in simpleDatas) {
      yield simpleData;
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

  Future<Types> echoTypes(
    Session session,
    Types typesModel,
  ) async {
    return typesModel;
  }

  Future<List<Types>> echoTypesList(
    Session session,
    List<Types> typesList,
  ) async {
    return typesList;
  }

  /// Returns a model class which fields reference `ModuleClass` defined in another module
  Future<ModuleDatatype> echoModuleDatatype(
    Session session,
    ModuleDatatype moduleDatatype,
  ) async {
    return moduleDatatype;
  }

  Stream<ModuleDatatype?> streamModuleDatatype(
    Session session,
    ModuleDatatype? initialValue,
    Stream<ModuleDatatype?> values,
  ) async* {
    yield initialValue;

    await for (var value in values) {
      yield value;
    }
  }

  /// Returns the given `ModuleClass` instance
  ///
  /// `ModuleClass` is defined in another module
  Future<ModuleClass> echoModuleClass(
    Session session,
    ModuleClass moduleClass,
  ) async {
    return moduleClass;
  }

  Stream<ModuleClass?> streamModuleClass(
    Session session,
    ModuleClass? initialValue,
    Stream<ModuleClass?> values,
  ) async* {
    yield initialValue;

    await for (var value in values) {
      yield value;
    }
  }

  Future<(String, (int, bool))> echoRecord(
    Session session,
    (String, (int, bool)) record,
  ) async {
    return record;
  }

  Future<List<(String, (int, bool))>> echoRecords(
    Session session,
    List<(String, (int, bool))> records,
  ) async {
    return records;
  }

  Stream<(String, (Map<String, int>, {SimpleData simpleData, bool flag}))>
      recordEchoStream(
    Session session,
    (
      String,
      (Map<String, int>, {SimpleData simpleData, bool flag})
    ) initialValue,
    Stream<(String, (Map<String, int>, {SimpleData simpleData, bool flag}))>
        stream,
  ) async* {
    yield initialValue;
    await for (var value in stream) {
      yield value;
    }
  }

  Stream<List<(String, int)>> listOfRecordEchoStream(
    Session session,
    List<(String, int)> initialValue,
    Stream<List<(String, int)>> stream,
  ) async* {
    yield initialValue;
    await for (var value in stream) {
      yield value;
    }
  }

  Stream<(String, (Map<String, int>, {SimpleData simpleData, bool flag}))?>
      nullableRecordEchoStream(
    Session session,
    (
      String,
      (Map<String, int>, {SimpleData simpleData, bool flag})
    )? initialValue,
    Stream<(String, (Map<String, int>, {SimpleData simpleData, bool flag}))?>
        stream,
  ) async* {
    yield initialValue;
    await for (var value in stream) {
      yield value;
    }
  }

  Stream<List<(String, int)>?> nullableListOfRecordEchoStream(
    Session session,
    List<(String, int)>? initialValue,
    Stream<List<(String, int)>?> stream,
  ) async* {
    yield initialValue;
    await for (var value in stream) {
      yield value;
    }
  }

  Stream<TypesRecord?> modelWithRecordsEchoStream(
    Session session,
    TypesRecord? initialValue,
    Stream<TypesRecord?> stream,
  ) async* {
    yield initialValue;
    await for (var value in stream) {
      yield value;
    }
  }

  Future<void> logMessageWithSession(Session session) async {
    session.log('test session log in endpoint');
  }

  static Completer<void>? willCloseListenerCalled;

  Future<void> addWillCloseListenerToSessionAndThrow(Session session) async {
    session.addWillCloseListener((Session s) {
      willCloseListenerCalled?.complete();
    });

    throw Exception();
  }

  Stream<int> addWillCloseListenerToSessionIntStreamMethodAndThrow(
    Session session,
  ) {
    session.addWillCloseListener((Session s) {
      willCloseListenerCalled?.complete();
    });

    throw Exception();
  }

  // Cache testing methods
  Future<void> putInLocalCache(
      Session session, String key, SimpleData data) async {
    await session.caches.local.put(key, data);
  }

  Future<SimpleData?> getFromLocalCache(Session session, String key) async {
    return await session.caches.local.get<SimpleData>(key);
  }

  Future<void> putInLocalPrioCache(
      Session session, String key, SimpleData data) async {
    await session.caches.localPrio.put(key, data);
  }

  Future<SimpleData?> getFromLocalPrioCache(Session session, String key) async {
    return await session.caches.localPrio.get<SimpleData>(key);
  }

  Future<void> putInQueryCache(
      Session session, String key, SimpleData data) async {
    await session.caches.query.put(key, data);
  }

  Future<SimpleData?> getFromQueryCache(Session session, String key) async {
    return await session.caches.query.get<SimpleData>(key);
  }

  Future<void> putInLocalCacheWithGroup(
      Session session, String key, SimpleData data, String group) async {
    await session.caches.local.put(key, data, group: group);
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
