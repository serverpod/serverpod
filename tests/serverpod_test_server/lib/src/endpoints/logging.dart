import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

class LoggingEndpoint extends Endpoint {
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
    await session.dbNext.insertRow(data);
    data = (await session.dbNext.findFirstRow<SimpleData>())!;
  }
}
