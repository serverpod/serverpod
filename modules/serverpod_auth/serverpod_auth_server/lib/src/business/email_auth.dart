import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/src/business/user_images.dart';
import '../generated/protocol.dart';
import 'users.dart';

class Emails {
  static String generatePasswordHash(String password) {
    var salt = Serverpod.instance!.getPassword('email_password_salt') ?? 'serverpod password salt';
    return sha256.convert(utf8.encode(password + salt)).toString();
  }

  static Future<UserInfo?> createUser(Session session, String userName, String email, String password) async {
    var userInfo = UserInfo(
      userIdentifier: email,
      email: email,
      userName: userName,
      created: DateTime.now(),
      scopes: [],
      active: true,
      blocked: false,
    );

    print('creating user');
    var createdUser = await Users.createUser(session, userInfo);
    if (createdUser == null)
      return null;

    print('creating email auth');
    var auth = EmailAuth(
      userId: createdUser.id!,
      email: email,
      hash: generatePasswordHash(password),
    );
    await session.db.insert(auth);

    await UserImages.setDefaultUserImage(session, createdUser.id!);

    print('returning created user');
    return createdUser;
  }
}