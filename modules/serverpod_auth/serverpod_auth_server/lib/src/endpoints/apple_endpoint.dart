import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jose/jose.dart';
import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

import '../business/users.dart';
import '../generated/protocol.dart';

List<Map<String, dynamic>>? _applePublicKeys;
const String _authMethod = 'apple';

/// Endpoint for handling Sign in with Apple.
class AppleEndpoint extends Endpoint {
  /// Authenticates a user with Apple.
  Future<AuthenticationResponse> authenticate(
      Session session, AppleAuthInfo authInfo) async {
    // Load public keys
    if (_applePublicKeys == null) {
      http.Response result =
          await http.get(Uri.parse('https://appleid.apple.com/auth/keys'));
      if (result.statusCode != 200) {
        return AuthenticationResponse(
          success: false,
          failReason: AuthenticationFailReason.internalError,
        );
      }

      Map<String, dynamic> data = jsonDecode(result.body);
      List<Map<String, dynamic>> keysData = data['keys'];
      List<Map<String, dynamic>> keys = <Map<String, dynamic>>[];
      for (Map<String, dynamic> keyData in keysData) {
        keys.add(keyData.cast<String, dynamic>());
      }
      _applePublicKeys = keys;
    }

    String userIdentifier = authInfo.userIdentifier;
    String fullName = authInfo.fullName;
    String name = authInfo.nickname;
    String? email = authInfo.email;

    // create a JsonWebSignature from the encoded string
    JsonWebSignature jws =
        JsonWebSignature.fromCompactSerialization(authInfo.identityToken);

    // extract the payload
    JosePayload payload = jws.unverifiedPayload;

    bool verified = false;
    for (Map<String, dynamic> applePublicKey in _applePublicKeys!) {
      JsonWebKey jwk = JsonWebKey.fromJson(applePublicKey);

      JsonWebKeyStore keyStore = JsonWebKeyStore()..addKey(jwk);

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
        scopeNames: <String>[],
      );
      userInfo = await Users.createUser(session, userInfo, _authMethod);
    }

    if (userInfo == null) {
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.userCreationDenied,
      );
    }

    AuthKey authKey = await session.auth.signInUser(userInfo.id!, _authMethod);

    return AuthenticationResponse(
      success: true,
      keyId: authKey.id,
      key: authKey.key,
      userInfo: userInfo,
    );
  }
}
