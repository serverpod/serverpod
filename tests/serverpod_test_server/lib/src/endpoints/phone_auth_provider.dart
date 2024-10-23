import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart';

class PhoneAuthTestMethods extends Endpoint {
  Future<String?> findVerificationCode(
    Session session,
    String userName,
    String phoneNumber,
  ) async {
    var authRequest = await PhoneCreateAccountRequest.db.findFirstRow(
      session,
      where: (t) =>
          t.userName.equals(userName) & t.phoneNumber.equals(phoneNumber),
    );

    return authRequest?.verificationCode;
  }

  Future<String?> findResetCode(Session session, String phoneNumber) async {
    var userInfo = await UserInfo.db.findFirstRow(
      session,
      where: (t) => t.phoneNumber.equals(phoneNumber),
    );

    var userId = userInfo?.id;
    if (userId == null) return null;

    var resetRequest = await PhoneReset.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    return resetRequest?.verificationCode;
  }

  Future<void> tearDown(Session session) async {
    await Future.wait([
      PhoneCreateAccountRequest.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      ),
      PhoneAuth.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      ),
      UserImage.db.deleteWhere(
        session,
        where: (t) => Constant.bool(true),
      ),
      UserInfo.db.deleteWhere(session, where: (t) => Constant.bool(true)),
      PhoneReset.db.deleteWhere(session, where: (t) => Constant.bool(true)),
    ]);
  }

  Future<bool> createUser(
    Session session,
    String userName,
    String phoneNumber,
    String password,
  ) async {
    var userInfo =
        await Phones.createUser(session, userName, phoneNumber, password);
    print('User info: $userInfo');
    return userInfo != null;
  }
}
