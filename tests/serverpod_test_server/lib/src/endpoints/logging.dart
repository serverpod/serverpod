import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

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
    SimpleData data = SimpleData(num: 42);
    await session.db.insert(data);
    data = (await session.db.findSingleRow<SimpleData>())!;
  }
}
