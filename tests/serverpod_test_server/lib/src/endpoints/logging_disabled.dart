import 'package:serverpod/serverpod.dart';

class LoggingDisabledEndpoint extends Endpoint {
  bool get logSessions => false;

  Future<void> logInfo(Session session, String message) async {
    session.log(message);
  }
}
