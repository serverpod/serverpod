import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jose/jose.dart';
import 'package:serverpod/serverpod.dart';

import '../business/users.dart';
import '../generated/protocol.dart';

List<Map<String, dynamic>>? _applePublicKeys;

/// Endpoint for handling Sign in with Apple.
class AppleEndpoint extends Endpoint {
  /// Authenticates a user with Apple.
  Future<AuthenticationResponse> authenticate(
      Session session, AppleAuthInfo authInfo) async {
    // Load public keys
    if (_applePublicKeys == null) {
      var result =
          await http.get(Uri.parse('https://appleid.apple.com/auth/keys'));
      if (result.statusCode != 200) {
        return AuthenticationResponse(
          success: false,
          failReason: AuthenticationFailReason.internalError,
        );
      }

      Map data = jsonDecode(result.body);
      List keysData = data['keys'];
      var keys = <Map<String, dynamic>>[];
      for (Map keyData in keysData) {
        keys.add(keyData.cast<String, dynamic>());
      }
      _applePublicKeys = keys;
    }

    var userIdentifier = authInfo.userIdentifier;
    var fullName = authInfo.fullName;
    var name = authInfo.nickname;
    var email = authInfo.email;

    // create a JsonWebSignature from the encoded string
    var jws = JsonWebSignature.fromCompactSerialization(authInfo.identityToken);

    // extract the payload
    var payload = jws.unverifiedPayload;

    var verified = false;
    for (var applePublicKey in _applePublicKeys!) {
      var jwk = JsonWebKey.fromJson(applePublicKey);

      var keyStore = JsonWebKeyStore()..addKey(jwk);

      // verify the signature
      if (await jws.verify(keyStore)) verified = true;
    }

    if (!verified) {
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    if (userIdentifier != payload.jsonContent['sub']) {
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    session.log('checking email', level: LogLevel.debug);
    if (email != null && email != payload.jsonContent['email']) {
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    email = email?.toLowerCase();

    UserInfo? userInfo;
    if (email != null) userInfo = await Users.findUserByEmail(session, email);
    userInfo ??= await Users.findUserByIdentifier(session, userIdentifier);
    if (userInfo == null) {
      userInfo = UserInfo(
        userIdentifier: userIdentifier,
        userName: name,
        fullName: fullName,
        email: email,
        active: true,
        blocked: false,
        created: DateTime.now().toUtc(),
        scopeNames: [],
      );
      userInfo = await Users.createUser(session, userInfo);
    }

    if (userInfo == null)
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.userCreationDenied,
      );

    var authKey = await session.auth.signInUser(userInfo.id!, 'apple');

    return AuthenticationResponse(
      success: true,
      keyId: authKey.id,
      key: authKey.key,
      userInfo: userInfo,
    );
  }
}
