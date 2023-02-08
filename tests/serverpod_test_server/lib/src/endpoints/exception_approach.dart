import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/user_not_found_exception.dart';

class ExceptionApproach extends Endpoint {
  Future<String> checkUserExist(Session session, int userId) async {
    if (userId == -1) {
      throw UserNotFound(message: 'User with id: $userId not found');
    } else if (userId == 0) {
      throw SerializableException();
    }
    return 'Success';
  }
}
