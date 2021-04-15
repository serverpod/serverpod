import 'package:serverpod/serverpod.dart';

class LoggingEndpoint extends Endpoint {
  Future<void> logInfo(Session session, String message) async {
    session.log(message);
  }

  Future<void> logDebugAndInfoAndError(Session session, String debug, String info, String error) async {
    session.log(debug, level: LogLevel.debug);
    session.log(info);
    session.log(error, level: LogLevel.error);
  }
}
