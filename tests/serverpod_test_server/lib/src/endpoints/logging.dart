import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class LoggingEndpoint extends Endpoint {
  Future<void> slowMethod(Session session, int delayMillis) async {
    await Future.delayed(Duration(milliseconds: delayMillis));
  }

  Future<void> failingMethod(Session session) async {
    throw Exception('This is an exception');
  }

  Future<void> emptyMethod(Session session) async {
    // do nothing
  }

  Future<void> log(
      Session session, String message, List<LogLevel> logLevels) async {
    for (var logLevel in logLevels) {
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
}
