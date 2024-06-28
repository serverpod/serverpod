import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class MethodStreaming extends Endpoint {
  Map<String, Completer> _delayedResponses = {};

  /// Check Null and Object in validation.
  Stream<int> simpleStream(Session session) async* {
    for (var i = 0; i < 10; i++) {
      yield i;
    }
  }

  Stream<int> simpleStreamWithParameter(Session session, int value) async* {
    for (var i in List.generate(value, (index) => index)) {
      yield i;
    }
  }

  Stream<SimpleData> simpleDataStream(Session session, int value) async* {
    for (var i in List.generate(value, (index) => index)) {
      yield SimpleData(
        num: i,
      );
    }
  }

  Future<void> simpleEndpoint(Session session) async {}

  Future<void> intParameter(Session session, int value) async {}

  Future<int?> nullableResponse(Session session, int? value) async {
    return value;
  }

  Future<int> doubleInputValue(Session session, int value) async {
    return value * 2;
  }

  /// Delays the response for [delay] seconds.
  ///
  /// Responses can be closed by calling [completeAllDelayedResponses].
  Future<void> delayedResponse(Session session, int delay) async {
    var uuid = Uuid().v4();
    var completer = Completer<void>();
    _delayedResponses[uuid] = completer;

    Future.delayed(Duration(seconds: delay), () {
      _delayedResponses.remove(uuid)?.complete();
    });

    return completer.future;
  }

  Stream<int> delayedStreamResponse(Session session, int delay) async* {
    var uuid = Uuid().v4();
    var completer = Completer<void>();
    _delayedResponses[uuid] = completer;

    Future.delayed(Duration(seconds: delay), () {
      _delayedResponses.remove(uuid)?.complete();
    });

    await completer.future;

    yield 42;
  }

  /// Completes all delayed responses.
  /// This makes the delayedResponse return directly.
  Future<void> completeAllDelayedResponses(Session session) async {
    var delayedResponses = _delayedResponses.values.toList();
    _delayedResponses.clear();
    for (var response in delayedResponses) {
      response.complete();
    }
  }

  Future<void> throwsException(Session session) async {
    throw Exception('This is an exception');
  }

  Future<void> throwsSerializableException(Session session) async {
    throw ExceptionWithData(
      message: 'Throwing an exception',
      creationDate: DateTime.now(),
      errorFields: [
        'first line error',
        'second line error',
      ],
      someNullableField: 1,
    );
  }

  Stream<int> throwsExceptionStream(Session session) async* {
    throw Exception('This is an exception');
  }

  Stream<int> throwsSerializableExceptionStream(Session session) async* {
    throw ExceptionWithData(
      message: 'Throwing an exception',
      creationDate: DateTime.now(),
      errorFields: [
        'first line error',
        'second line error',
      ],
      someNullableField: 1,
    );
  }
}

class AuthenticatedMethodStreaming extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {Scope.admin};

  Stream<int> simpleStream(Session session) async* {
    for (var i = 0; i < 10; i++) {
      yield i;
    }
  }
}
