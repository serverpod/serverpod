import 'package:serverpod/server.dart';

class FailedCallsEndpoint extends Endpoint {
  Future<void> failedCall(Session session) async {
    throw Exception('Test exception');
  }

  Future<void> failedDatabaseQuery(Session session) async {
    // This call should fail and throw an exception
    await session.dbNext.dangerouslyQuery(
      'SELECT * FROM non_existing_table LIMIT 1',
    );
  }

  Future<bool> failedDatabaseQueryCaughtException(Session session) async {
    try {
      await session.dbNext.dangerouslyQuery(
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

  Future<void> caughtException(Session session) async {
    try {
      throw Exception('Test exception');
    } catch (e, stackTrace) {
      session.log(
        'Exception logging',
        exception: e,
        stackTrace: stackTrace,
      );
    }

    try {
      throw Exception('Test exception');
    } catch (e, stackTrace) {
      session.log(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
        exception: e,
        stackTrace: stackTrace,
      );
    }

    session.log('No exception');
  }
}
