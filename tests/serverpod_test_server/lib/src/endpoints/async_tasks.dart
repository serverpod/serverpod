import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class AsyncTasksEndpoint extends Endpoint {
  Future<void> insertRowToSimpleDataAfterDelay(
      Session session, int num, int seconds) async {
    // No await, method will return immediately and execute task
    unawaited(_insertRowToSimpleDataAfterDelay(session, num, seconds));
  }

  Future<void> _insertRowToSimpleDataAfterDelay(
      Session session, int num, int seconds) async {
    await Future.delayed(Duration(seconds: seconds));
    var data = SimpleData(
      num: num,
    );
    await session.dbNext.insertRow(data);
  }

  Future<void> throwExceptionAfterDelay(Session session, int seconds) async {
    // No await, throw exception outside of this context
    unawaited(_throwExceptionAfterDelay(seconds));
  }

  Future<void> _throwExceptionAfterDelay(int seconds) async {
    await Future.delayed(Duration(seconds: seconds));
    throw Exception('Test exception');
  }
}
