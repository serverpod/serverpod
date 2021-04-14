import 'package:serverpod/serverpod.dart';

class LoggingEndpoint extends Endpoint {
  Future<void> logInfo(Session session, String message) async {
    session.log(message);
  }
}
