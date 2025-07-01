import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';

class EmailAuthTestMethods extends Endpoint {
  Future<String?> findVerificationCode(
    Session session,
    String userName,
    String email,
  ) async {
    var authRequest = await EmailCreateAccountRequest.db.findFirstRow(
      session,
      where: (t) => t.userName.equals(userName) & t.email.equals(email),
    );

    return authRequest?.verificationCode;
  }

  Future<String?> findResetCode(Session session, String email) async {
    var userInfo = await UserInfo.db.findFirstRow(
      session,
      where: (t) => t.email.equals(email),
    );

    var userId = userInfo?.id;
    if (userId == null) return null;

    var resetRequest = await EmailReset.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    return resetRequest?.verificationCode;
  }

  Future<void> tearDown(Session session) async {
    await Future.wait([
      EmailCreateAccountRequest.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      ),
      EmailAuth.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      ),
      UserImage.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      ),
      UserInfo.db.deleteWhere(session, where: (t) => Constant.bool(true)),
      EmailReset.db.deleteWhere(session, where: (t) => Constant.bool(true)),
    ]);
  }

  Future<bool> createUser(
    Session session,
    String userName,
    String email,
    String password,
  ) async {
    var userInfo = await Emails.createUser(session, userName, email, password);
    print('User info: $userInfo');
    return userInfo != null;
  }
}
