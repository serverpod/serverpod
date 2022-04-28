// Add your modules' endpoints to the `endpoints` directory. Run
// `serverpod generate` to produce the modules server and client code. Refer to
// the documentation on how to add endpoints to your server.

import 'dart:convert';

import 'package:googleapis/people/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
// ignore: implementation_imports
import 'package:googleapis_auth/src/auth_http_utils.dart';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/protocol.dart';
import '../business/config.dart';
import '../business/google_auth.dart';
import '../business/user_images.dart';

import '../business/users.dart';
import '../generated/protocol.dart';

const String _authMethod = 'google';

/// Endpoint for handling Sign in with Google.
class GoogleEndpoint extends Endpoint {
  /// Authenticates a user with Google using the serverAuthCode.
  Future<AuthenticationResponse> authenticateWithServerAuthCode(
    Session session,
    String authenticationCode,
    String? redirectUri,
  ) async {
    assert(
        GoogleAuth.clientSecret != null, 'Google client secret is not loaded.');

    AutoRefreshingClient authClient =
        await _GoogleUtils.clientViaClientSecretAndCode(
      GoogleAuth.clientSecret!,
      authenticationCode,
      <String>[
        'https://www.googleapis.com/auth/userinfo.profile',
        'profile',
        'email',
      ],
      redirectUri,
    );

    PeopleServiceApi api = PeopleServiceApi(authClient);
    Person person = await api.people.get(
      'people/me',
      personFields: 'emailAddresses,names,photos',
    );

    if (person.names == null) return AuthenticationResponse(success: false);

    String? fullName = person.names?[0].displayName; // TODO: Double check
    String? name = person.names?[0].givenName;
    String? image = person.photos?[0].url;
    String? email = person.emailAddresses?[0].value;

    if (fullName == null || name == null || image == null || email == null) {
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    email = email.toLowerCase();

    UserInfo? userInfo =
        await _setupUserInfo(session, email, name, fullName, image);

    if (userInfo == null) {
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.userCreationDenied,
      );
    }

    if (authClient.credentials.refreshToken != null) {
      // Store refresh token, so that we can access this data at a later time.
      GoogleRefreshToken? token = await GoogleRefreshToken.findSingleRow(
        session,
        where: (GoogleRefreshTokenTable t) => t.userId.equals(userInfo.id!),
      );
      if (token == null) {
        token = GoogleRefreshToken(
          userId: userInfo.id!,
          refreshToken: jsonEncode(authClient.credentials.toJson()),
        );
        await GoogleRefreshToken.insert(session, token);
      } else {
        token.refreshToken = jsonEncode(authClient.credentials.toJson());
        await GoogleRefreshToken.update(session, token);
      }
    }

    AuthKey authKey = await session.auth.signInUser(userInfo.id!, _authMethod);

    authClient.close();

    return AuthenticationResponse(
      success: true,
      keyId: authKey.id,
      key: authKey.key,
      userInfo: userInfo,
    );
  }

  /// Authenticates a user using an id token.
  Future<AuthenticationResponse> authenticateWithIdToken(
      Session session, String idToken) async {
    try {
      assert(GoogleAuth.clientSecret != null,
          'Google client secret is not loaded');
      String clientId = GoogleAuth.clientSecret!.clientId;

      // Verify the token with Google's servers.
      // TODO: This should probably be done on this server.
      http.Response response = await http.get(Uri.parse(
          'https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=$idToken'));

      if (response.statusCode != 200) {
        session.log('Invalid token received', level: LogLevel.debug);
        return AuthenticationResponse(
          success: false,
          failReason: AuthenticationFailReason.invalidCredentials,
        );
      }

      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['iss'] != 'accounts.google.com') {
        session.log('Invalid token received', level: LogLevel.debug);
        return AuthenticationResponse(
          success: false,
          failReason: AuthenticationFailReason.invalidCredentials,
        );
      }

      if (data['aud'] != clientId) {
        session.log('Client ID doesn\'t match', level: LogLevel.debug);
        return AuthenticationResponse(
          success: false,
          failReason: AuthenticationFailReason.invalidCredentials,
        );
      }

      String? email = data['email'];
      String? fullName = data['name'];
      String? image = data['picture'];
      String? name = data['given_name'];

      if (email == null || fullName == null || image == null || name == null) {
        session.log(
            'Failed to get info, email: $email name: $name fullName: $fullName image: $image',
            level: LogLevel.debug);
        return AuthenticationResponse(
          success: false,
          failReason: AuthenticationFailReason.invalidCredentials,
        );
      }

      UserInfo? userInfo =
          await _setupUserInfo(session, email, name, fullName, image);
      if (userInfo == null) {
        session.log('Failed to create UserInfo', level: LogLevel.debug);
        return AuthenticationResponse(
          success: false,
          failReason: AuthenticationFailReason.userCreationDenied,
        );
      }

      // Authentication looks ok!

      AuthKey authKey = await session.auth.signInUser(userInfo.id!, 'google');

      return AuthenticationResponse(
        success: true,
        keyId: authKey.id,
        key: authKey.key,
        userInfo: userInfo,
      );
    } catch (e, stackTrace) {
      session.log(
        'Failed authenticateWithIdToken',
        level: LogLevel.debug,
        exception: e,
        stackTrace: stackTrace,
      );
      return AuthenticationResponse(success: false);
    }
  }

  Future<UserInfo?> _setupUserInfo(Session session, String email, String name,
      String fullName, String? image) async {
    UserInfo? userInfo = await Users.findUserByEmail(session, email);
    if (userInfo == null) {
      userInfo = UserInfo(
        userIdentifier: email,
        userName: name,
        fullName: fullName,
        email: email,
        active: true,
        blocked: false,
        created: DateTime.now().toUtc(),
        scopeNames: <String>[],
      );
      userInfo = await Users.createUser(session, userInfo, _authMethod);

      // Set the user image.
      if (userInfo?.id != null && image != null) {
        String url = image;
        if (url.endsWith('s100')) {
          url = url.substring(0, url.length - 4) +
              's${AuthConfig.current.userImageSize}';
        }
        await UserImages.setUserImageFromUrl(
            session, userInfo!.id!, Uri.parse(url));
      }
    }
    return userInfo;
  }
}

class _GoogleUtils {
  static Future<AutoRefreshingClient> clientViaClientSecretAndCode(
    GoogleClientSecret secret,
    String authenticationCode,
    List<String> scopes, [
    String? redirectUri,
  ]) async {
    redirectUri = redirectUri ?? secret.redirectUris[0];
    ClientId clientId = ClientId(secret.clientId, secret.clientSecret);
    http.Client client = http.Client();

    AccessCredentials credentials =
        await obtainAccessCredentialsViaCodeExchange(
      client,
      clientId,
      authenticationCode,
      redirectUrl: redirectUri,
    );

    return AutoRefreshingClient(
      client,
      clientId,
      credentials,
      closeUnderlyingClient: true,
    );
  }
}
