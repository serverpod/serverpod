import 'package:serverpod/server.dart';

class FailedCallsEndpoint extends Endpoint {
  Future<void> failedCall(Session session) async {
    throw Exception('Test exception');
  }

  Future<void> failedDatabaseQuery(Session session) async {
    // This call should fail and throw an exception
    await session.db.query(
      'SELECT * FROM non_existing_table LIMIT 1',
    );
  }

  Future<bool> failedDatabaseQueryCaughtException(Session session) async {
    try {
      await session.db.query(
        'SELECT * FROM non_existing_table LIMIT 1',
      );
    } catch (e) {
      // Ignore error handling
    }
    return true;
  }

  Future<void> slowCall(Session session) async {
    await Future.delayed(const Duration(seconds: 2));
  }
}
