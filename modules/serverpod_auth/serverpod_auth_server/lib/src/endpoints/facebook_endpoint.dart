// Add your modules' endpoints to the `endpoints` directory. Run
// `serverpod generate` to produce the modules server and client code. Refer to
// the documentation on how to add endpoints to your server.

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/src/business/facebook_auth.dart';
import 'package:serverpod_auth_server/src/business/user_images.dart';

import '../business/users.dart';
import '../generated/protocol.dart';

const _authMethod = 'facebook';

const _fbAPIVersion = 'v16.0';
const _graphURL = 'https://graph.facebook.com/$_fbAPIVersion';

/// Endpoint for handling Sign in with Facebook.
class FacebookEndpoint extends Endpoint {
  /// Authenticates a user with Facebook using the access token obtained
  /// on the client.
  Future<AuthenticationResponse> authenticateWithAccessToken(
      Session session, String userAccessToken, String redirectUri) async {
    assert(
        FacebookAuth.appSecret != null, 'Facebook app secret is not loaded.');

    var appAccessTokenResponse =
        await http.get(Uri.parse('$_graphURL/oauth/access_token'
            '?client_id=${FacebookAuth.appSecret!.appId}'
            '&client_secret=${FacebookAuth.appSecret!.appSecret}'
            '&grant_type=client_credentials'));

    if (appAccessTokenResponse.statusCode != 200) {
      session.log('Could not authenticate with Facebook using client secret',
          level: LogLevel.debug);
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    var appAccessTokenData = jsonDecode(appAccessTokenResponse.body);
    var appAccessToken = appAccessTokenData?['access_token'];

    if (appAccessToken == null) {
      session.log('Could not fetch server access token', level: LogLevel.debug);
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    var debugTokenResponse = await http.get(Uri.parse('$_graphURL/debug_token'
        '?input_token=$userAccessToken'
        '&access_token=$appAccessToken'));

    if (debugTokenResponse.statusCode != 200) {
      session.log(
          'Could not authenticate with Facebook using user access token',
          level: LogLevel.debug);
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    var debugTokenData = jsonDecode(debugTokenResponse.body)['data'];
    var isValid = debugTokenData?['is_valid'] ?? false;
    var userId = debugTokenData?['user_id'];

    if (!isValid || userId == null) {
      session.log('User access token has expired', level: LogLevel.debug);
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    var profileId = debugTokenData?['profile_id'];
    // var userAccessTokenExpiresAt = debugTokenData?['expires_at'];
    var scopes = debugTokenData?['scopes'];

    // Exchange the short-lived user access token for a long-lived user
    // access token
    var longLivedUserAccessTokenResponse =
        await http.get(Uri.parse('$_graphURL/oauth/access_token'
            '?client_id=${FacebookAuth.appSecret!.appId}'
            '&client_secret=${FacebookAuth.appSecret!.appSecret}'
            '&fb_exchange_token=$userAccessToken'
            '&grant_type=fb_exchange_token'));

    if (longLivedUserAccessTokenResponse.statusCode != 200) {
      session.log('Could not get long-lived user access token',
          level: LogLevel.debug);
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    var longLivedAccessTokenData =
        jsonDecode(longLivedUserAccessTokenResponse.body);
    var longLivedAccessToken = longLivedAccessTokenData?['access_token'];
    var expiresIn = longLivedAccessTokenData?['expires_in'];

    if (longLivedAccessToken == null || expiresIn == null) {
      session.log('Could not get long-lived user access token',
          level: LogLevel.debug);
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    var longLivedAccessTokenExpiresAt =
        DateTime.now().add(Duration(seconds: expiresIn));

    // Could also generate long-lived access tokens to ship back to the client:
    // https://developers.facebook.com/docs/facebook-login/guides/access-tokens/get-long-lived/

    // Get user info
    var publicProfileResponse = await http.get(Uri.parse('$_graphURL/$userId'
        '?access_token=$longLivedAccessToken'));

    if (publicProfileResponse.statusCode != 200) {
      session.log('Could not get user info', level: LogLevel.debug);
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    var publicProfileData = jsonDecode(publicProfileResponse.body);
    var email = publicProfileData?['email'];
    var firstName = publicProfileData?['first_name'];
    var fullName = publicProfileData?['name'];
    var image = publicProfileData?['profile_pic'];

    if (fullName == null ||
        firstName == null ||
        image == null ||
        email == null) {
      session.log(
          'Could not get all required profile information for user: '
          'email=$email, first_name=$firstName, name=$fullName, '
          'profile_pic=$image',
          level: LogLevel.debug);
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.invalidCredentials,
      );
    }

    email = email.toLowerCase();

    var userInfo = await _setupUserInfo(
        session, email, name, fullName, image, scopes ?? []);

    if (userInfo == null) {
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.userCreationDenied,
      );
    } else if (userInfo.banned) {
      return AuthenticationResponse(
        success: false,
        failReason: AuthenticationFailReason.banned,
      );
    }

    // Store long-lived access token for future use
    var tokenRecord = FacebookLongLivedToken(
      userId: userInfo.id!,
      fbProfileId: profileId,
      expiresAt: longLivedAccessTokenExpiresAt,
      token: longLivedAccessToken,
    );
    if (await FacebookLongLivedToken.findSingleRow(session,
            where: (t) => t.userId.equals(userInfo.id!)) ==
        null) {
      await FacebookLongLivedToken.insert(session, tokenRecord);
    } else {
      await FacebookLongLivedToken.update(session, tokenRecord);
    }

    var authKey = await session.auth.signInUser(userInfo.id!, _authMethod);

    return AuthenticationResponse(
      success: true,
      keyId: authKey.id,
      key: authKey.key,
      userInfo: userInfo,
    );
  }

  Future<UserInfo?> _setupUserInfo(Session session, String email, String name,
      String fullName, String? image, List<String> scopeNames) async {
    var userInfo = await Users.findUserByEmail(session, email);
    if (userInfo == null) {
      userInfo = UserInfo(
        userIdentifier: email,
        userName: name,
        fullName: fullName,
        email: email,
        blocked: false,
        created: DateTime.now().toUtc(),
        scopeNames: scopeNames,
      );
      userInfo = await Users.createUser(session, userInfo, _authMethod);

      if (userInfo?.id != null && image != null) {
        await UserImages.setUserImageFromUrl(
            session, userInfo!.id!, Uri.parse(image));
      }
    }
    return userInfo;
  }
}
