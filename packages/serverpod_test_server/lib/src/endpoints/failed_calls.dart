import 'package:serverpod/server.dart';

class FailedCallsEndpoint extends Endpoint {
  Future<void> failedCall(Session session) async {
    throw Exception('Test exception');
  }
}