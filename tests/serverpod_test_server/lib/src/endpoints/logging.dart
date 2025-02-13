import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class LoggingEndpoint extends Endpoint {
  Future<void> slowQueryMethod(Session session, int seconds) async {
    try {
      await session.db.unsafeQuery('SELECT pg_sleep($seconds);');
    } catch (e) {}
  }

  Future<void> queryMethod(Session session, int queries) async {
    try {
      for (var i = 0; i < queries; i++) {
        await Types.db.findFirstRow(session);
      }
    } catch (e) {}
  }

  Future<void> failedQueryMethod(Session session) async {
    try {
      await session.db.unsafeQuery('SELECT * FROM table_does_not_exist;');
    } catch (e) {}
  }

  Future<void> slowMethod(Session session, int delayMillis) async {
    await Future.delayed(Duration(milliseconds: delayMillis));
  }

  Future<void> failingMethod(Session session) async {
    throw Exception('This is an exception');
  }

  Future<void> emptyMethod(Session session) async {
    // do nothing
  }

  Future<void> log(Session session, String message, List<int> logLevels) async {
    var levels = logLevels.map((level) => LogLevel.fromJson(level));

    for (var logLevel in levels) {
      session.log(message, level: logLevel);
    }
  }

  Future<void> logInfo(Session session, String message) async {
    session.log(message);
  }

  Future<void> logDebugAndInfoAndError(
      Session session, String debug, String info, String error) async {
    session.log(debug, level: LogLevel.debug);
    session.log(info);
    session.log(error, level: LogLevel.error);
  }

  Future<void> twoQueries(Session session) async {
    var data = SimpleData(num: 42);
    await session.db.insertRow(data);
    data = (await session.db.findFirstRow<SimpleData>())!;
  }

  Stream<int> streamEmpty(Session session, Stream<int> input) async* {
    await for (var value in input) {
      yield value;
    }
  }

  Stream<int> streamLogging(Session session, Stream<int> input) async* {
    await for (var value in input) {
      session.log('Received value: $value', level: LogLevel.debug);

      yield value;
    }
  }

  Stream<int> streamQueryLogging(Session session, Stream<int> input) async* {
    await for (var value in input) {
      await session.db.findFirstRow<SimpleData>();
      yield value;
    }
  }

  Stream<int> streamException(Session session) async* {
    throw Exception('This is an exception');
  }

  @override
  Future<void> handleStreamMessage(
    StreamingSession session,
    SerializableModel message,
  ) async {
    // do nothing
  }
}

class StreamLogging extends Endpoint {
  @override
  Future<void> handleStreamMessage(
    StreamingSession session,
    SerializableModel message,
  ) async {
    session.log('This is a message', level: LogLevel.debug);
  }
}

class StreamQueryLogging extends Endpoint {
  @override
  Future<void> handleStreamMessage(
    StreamingSession session,
    SerializableModel message,
  ) async {
    await session.db.findFirstRow<SimpleData>();
  }
}
