import 'dart:async';
import 'package:async/async.dart';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class MethodStreaming extends Endpoint {
  Map<String, Completer> _delayedResponses = {};

  /// Returns a simple stream of integers from 0 to 9.
  Stream<int> simpleStream(Session session) async* {
    for (var i = 0; i < 10; i++) {
      yield i;
    }
  }

  Stream<int> neverEndingStreamWithDelay(
    Session session,
    int millisecondsDelay,
  ) async* {
    int i = 0;
    while (true) {
      await Future.delayed(Duration(milliseconds: millisecondsDelay));
      yield i++;
    }
  }

  Future<void> methodCallEndpoint(Session session) async {}

  Future<int> intReturnFromStream(
    Session session,
    Stream<int> stream,
  ) async {
    return stream.first;
  }

  Future<int?> nullableIntReturnFromStream(
    Session session,
    Stream<int?> stream,
  ) async {
    return stream.first;
  }

  static const cancelStreamChannelName = 'cancelStreamChannel';
  static const sessionClosedChannelName = 'sessionClosedChannel';
  Stream<int?> getBroadcastStream(Session session) {
    session.addWillCloseListener((localSession) {
      localSession.messages
          .postMessage(sessionClosedChannelName, SimpleData(num: 1));
    });
    var stream = StreamController<int?>.broadcast(
      onCancel: () {
        session.messages
            .postMessage(cancelStreamChannelName, SimpleData(num: 1));
      },
    );
    return stream.stream;
  }

  Future<bool> wasBroadcastStreamCanceled(Session session) async {
    var streamWasCanceled = Completer<bool>();
    session.messages.addListener(cancelStreamChannelName, (data) {
      streamWasCanceled.complete(true);
    });
    return streamWasCanceled.future;
  }

  Future<bool> wasSessionWillCloseListenerCalled(Session session) async {
    var sessionWillCloseListenerWasCalled = Completer<bool>();
    session.messages.addListener(sessionClosedChannelName, (data) {
      sessionWillCloseListenerWasCalled.complete(true);
    });
    return sessionWillCloseListenerWasCalled.future;
  }

  Stream<int> intStreamFromValue(Session session, int value) async* {
    for (var i in List.generate(value, (index) => index)) {
      yield i;
    }
  }

  Stream<int> intEchoStream(Session session, Stream<int> stream) async* {
    await for (var value in stream) {
      yield value;
    }
  }

  Stream dynamicEchoStream(Session session, Stream stream) async* {
    await for (var value in stream) {
      yield value;
    }
  }

  Stream<int?> nullableIntEchoStream(
    Session session,
    Stream<int?> stream,
  ) async* {
    await for (var value in stream) {
      yield value;
    }
  }

  Future<void> voidReturnAfterStream(
    Session session,
    Stream<int> stream,
  ) async {
    await for (var _ in stream) {
      // Do nothing
    }
    return;
  }

  Stream<int> multipleIntEchoStreams(
    Session session,
    Stream<int> stream1,
    Stream<int> stream2,
  ) async* {
    var streamGroup = StreamGroup.merge([stream1, stream2]);

    await for (var value in streamGroup) {
      yield value;
    }
  }

  Future<void> directVoidReturnWithStreamInput(
    Session session,
    Stream<int> stream,
  ) async {
    stream.listen((event) {
      // Do nothing
    });

    return;
  }

  Future<int> directOneIntReturnWithStreamInput(
    Session session,
    Stream<int> stream,
  ) async {
    stream.listen((event) {
      // Do nothing
    });

    return 1;
  }

  Future<int> simpleInputReturnStream(
    Session session,
    Stream<int> stream,
  ) async {
    return stream.first;
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

  Stream<SimpleData> simpleInOutDataStream(
    Session session,
    Stream<SimpleData> simpleDataStream,
  ) async* {
    await for (var data in simpleDataStream) {
      yield data;
    }
  }

  Future<void> simpleEndpoint(Session session) async {}

  Future<void> intParameter(Session session, int value) async {}

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

  Future<void> delayedNeverListenedInputStream(
      Session session, int delay, Stream<int> stream) async {
    var uuid = Uuid().v4();
    var completer = Completer<void>();
    _delayedResponses[uuid] = completer;

    Future.delayed(Duration(seconds: delay), () {
      _delayedResponses.remove(uuid)?.complete();
    });

    await completer.future;
  }

  Future<void> delayedPausedInputStream(
      Session session, int delay, Stream<int> stream) async {
    var uuid = Uuid().v4();
    var completer = Completer<void>();
    _delayedResponses[uuid] = completer;

    Future.delayed(Duration(seconds: delay), () {
      _delayedResponses.remove(uuid)?.complete();
    });

    stream.listen((event) {
      // Do nothing
    }).pause(completer.future);

    await completer.future;
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

  Future<void> inStreamThrowsException(
    Session session,
    Stream<int> stream,
  ) async {
    throw Exception('This is an exception');
  }

  Future<void> inStreamThrowsSerializableException(
    Session session,
    Stream<int> stream,
  ) async {
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

  Stream<int> outStreamThrowsException(Session session) async* {
    throw Exception('This is an exception');
  }

  Stream<int> outStreamThrowsSerializableException(Session session) async* {
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

  Future<void> throwsExceptionVoid(Session session, Stream<int> stream) async {
    throw Exception('This is an exception');
  }

  Future<void> throwsSerializableExceptionVoid(
    Session session,
    Stream<int> stream,
  ) async {
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

  Future<int> throwsException(Session session, Stream<int> stream) async {
    throw Exception('This is an exception');
  }

  Future<int> throwsSerializableException(
    Session session,
    Stream<int> stream,
  ) async {
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

  Stream<int> exceptionThrownBeforeStreamReturn(Session session) {
    throw Exception('This is an exception');
  }

  Stream<int> exceptionThrownInStreamReturn(Session session) {
    var controller = StreamController<int>();
    controller.addError(Exception('This is an exception'));
    return controller.stream;
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

  Future<bool> didInputStreamHaveError(
    Session session,
    Stream<int> stream,
  ) async {
    var errorCompleter = Completer<bool>();
    await stream.listen(
      (event) {},
      onDone: () => errorCompleter.complete(false),
      onError: (e) => errorCompleter.complete(true),
      cancelOnError: true,
    );

    var value = await errorCompleter.future;
    return value;
  }

  Future<bool> didInputStreamHaveSerializableExceptionError(
    Session session,
    Stream<int> stream,
  ) async {
    var errorCompleter = Completer<bool>();
    await stream.listen(
      (event) {},
      onDone: () => errorCompleter.complete(false),
      onError: (e) => errorCompleter.complete(e is SerializableException),
      cancelOnError: true,
    );

    var value = await errorCompleter.future;
    return value;
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

  Stream<int> intEchoStream(Session session, Stream<int> stream) async* {
    await for (var value in stream) {
      yield value;
    }
  }
}
