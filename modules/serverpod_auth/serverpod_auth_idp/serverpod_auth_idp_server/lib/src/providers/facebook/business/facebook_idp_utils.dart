import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import 'facebook_idp_config.dart';

/// Details of the Facebook Account.
typedef FacebookAccountDetails = ({
  /// Facebook's user identifier for this account.
  String userIdentifier,

  /// The user's email address.
  ///
  /// This may be null if the user hasn't granted email permission.
  String? email,

  /// The user's full name.
  String? fullName,

  /// The user's first name.
  String? firstName,

  /// The user's last name.
  String? lastName,

  /// The user's profile picture URL.
  Uri? image,
});

/// Result of a successful authentication using Facebook as identity provider.
typedef FacebookAuthSuccess = ({
  /// The ID of the `FacebookAccount` database entity.
  UuidValue facebookAccountId,

  /// The ID of the associated `AuthUser`.
  UuidValue authUserId,

  /// Details of the Facebook account.
  FacebookAccountDetails details,

  /// Whether the associated `AuthUser` was newly created during authentication.
  bool newAccount,

  /// The scopes granted to the associated `AuthUser`.
  Set<Scope> scopes,
});

/// Utility functions for the Facebook identity provider.
///
/// These functions can be used to compose custom authentication and
/// administration flows if needed.
///
/// But for most cases, the methods exposed by [FacebookIdp] and
/// [FacebookIdpAdmin] should be sufficient.
class FacebookIdpUtils {
  /// Configuration for the Facebook identity provider.
  final FacebookIdpConfig config;

  final AuthUsers _authUsers;

  /// Creates a new instance of [FacebookIdpUtils].
  FacebookIdpUtils({
    required this.config,
    required final AuthUsers authUsers,
  }) : _authUsers = authUsers;

  /// Authenticates a user using a Facebook access token.
  ///
  /// This method verifies the token with Facebook's Debug Token API and fetches
  /// the user's profile information. If the Facebook user ID is not yet known
  /// in the system, a new `AuthUser` is created.
  Future<FacebookAuthSuccess> authenticate(
    final Session session, {
    required final String accessToken,
    required final Transaction? transaction,
  }) async {
    final accountDetails = await fetchAccountDetails(
      session,
      accessToken: accessToken,
    );

    var facebookAccount = await FacebookAccount.db.findFirstRow(
      session,
      where: (final t) => t.userIdentifier.equals(
        accountDetails.userIdentifier,
      ),
      transaction: transaction,
    );

    final createNewUser = facebookAccount == null;

    final AuthUserModel authUser = switch (createNewUser) {
      true => await _authUsers.create(
        session,
        transaction: transaction,
      ),
      false => await _authUsers.get(
        session,
        authUserId: facebookAccount!.authUserId,
        transaction: transaction,
      ),
    };

    if (createNewUser) {
      facebookAccount = await linkFacebookAuthentication(
        session,
        authUserId: authUser.id,
        accountDetails: accountDetails,
        transaction: transaction,
      );
    }

    return (
      facebookAccountId: facebookAccount.id!,
      authUserId: facebookAccount.authUserId,
      details: accountDetails,
      newAccount: createNewUser,
      scopes: authUser.scopes,
    );
  }

  /// Returns the account details for the given [accessToken].
  ///
  /// This method first verifies the token using Facebook's Debug Token API,
  /// then fetches the user's profile information from the Graph API.
  ///
  /// Throws [FacebookAccessTokenVerificationException] if the user info retrieval fails.
  Future<FacebookAccountDetails> fetchAccountDetails(
    final Session session, {
    required final String accessToken,
  }) async {
    await _verifyAccessToken(session, accessToken: accessToken);

    final response = await http
        .get(
          Uri.https(
            'graph.facebook.com',
            '/me',
            {
              'fields':
                  'id,name,first_name,last_name,email,picture.type(large)',
              'access_token': accessToken,
            },
          ),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      session.logAndThrow(
        'Failed to fetch Facebook user data: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> data;
    try {
      data = json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      session.logAndThrow('Failed to parse Facebook user data response: $e');
    }

    FacebookAccountDetails details;
    try {
      details = _parseAccountDetails(data);
    } catch (e) {
      session.logAndThrow('Invalid user info from Facebook: $e');
    }

    try {
      final getExtraInfoCallback = config.getExtraFacebookInfoCallback;
      if (getExtraInfoCallback != null) {
        await getExtraInfoCallback(
          session,
          accountDetails: details,
          accessToken: accessToken,
          transaction: null,
        );
      }
    } catch (e) {
      session.logAndThrow('Failed to get extra Facebook account info: $e');
    }

    return details;
  }

  FacebookAccountDetails _parseAccountDetails(final Map<String, dynamic> data) {
    final userIdentifier = data['id'] as String?;
    if (userIdentifier == null) {
      throw FacebookUserInfoMissingDataException();
    }

    final details = (
      userIdentifier: userIdentifier,
      email: (data['email'] as String?)?.toLowerCase(),
      fullName: data['name'] as String?,
      firstName: data['first_name'] as String?,
      lastName: data['last_name'] as String?,
      image: _extractProfilePictureUrl(data),
    );

    try {
      config.facebookAccountDetailsValidation(details);
    } catch (e) {
      throw FacebookUserInfoMissingDataException();
    }

    return details;
  }

  /// Verifies a Facebook access token using the Debug Token API.
  Future<void> _verifyAccessToken(
    final Session session, {
    required final String accessToken,
  }) async {
    final appAccessToken = '${config.appId}|${config.appSecret}';

    final response = await http
        .get(
          Uri.https(
            'graph.facebook.com',
            '/debug_token',
            {
              'input_token': accessToken,
              'access_token': appAccessToken,
            },
          ),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      session.logAndThrow(
        'Failed to verify Facebook access token: ${response.statusCode}',
      );
    }

    final Map<String, dynamic> responseData;
    try {
      responseData = json.decode(response.body) as Map<String, dynamic>;
    } catch (e) {
      session.logAndThrow(
        'Failed to parse Facebook token verification response: $e',
      );
    }

    final data = responseData['data'] as Map<String, dynamic>?;
    if (data == null) {
      session.logAndThrow(
        'Invalid Facebook token verification response format',
      );
    }

    final isValid = data['is_valid'] as bool? ?? false;
    if (!isValid) {
      session.logAndThrow('Facebook access token is not valid');
    }

    final appId = data['app_id'] as String?;
    if (appId != config.appId) {
      session.logAndThrow('Facebook access token is for a different app');
    }

    final expiresAt = data['expires_at'] as int?;
    if (expiresAt != null && expiresAt > 0) {
      final expirationDate = DateTime.fromMillisecondsSinceEpoch(
        expiresAt * 1000,
      );
      if (DateTime.now().isAfter(expirationDate)) {
        session.logAndThrow('Facebook access token has expired');
      }
    }
  }

  /// Extracts the profile picture URL from Facebook user data.
  Uri? _extractProfilePictureUrl(final Map<String, dynamic> data) {
    final picture = data['picture'] as Map<String, dynamic>?;
    if (picture == null) return null;

    final pictureData = picture['data'] as Map<String, dynamic>?;
    if (pictureData == null) return null;

    final pictureUrl = pictureData['url'] as String?;
    if (pictureUrl == null || pictureUrl.isEmpty) return null;

    return Uri.tryParse(pictureUrl);
  }

  /// Links a Facebook authentication to an existing [AuthUser].
  ///
  /// This creates a new [FacebookAccount] entity in the database.
  Future<FacebookAccount> linkFacebookAuthentication(
    final Session session, {
    required final UuidValue authUserId,
    required final FacebookAccountDetails accountDetails,
    required final Transaction? transaction,
  }) async {
    final facebookAccount = FacebookAccount(
      authUserId: authUserId,
      userIdentifier: accountDetails.userIdentifier,
      email: accountDetails.email,
      fullName: accountDetails.fullName,
      firstName: accountDetails.firstName,
      lastName: accountDetails.lastName,
    );

    return await FacebookAccount.db.insertRow(
      session,
      facebookAccount,
      transaction: transaction,
    );
  }
}

extension on Session {
  Never logAndThrow(final String message) {
    log(message, level: LogLevel.debug);
    throw FacebookAccessTokenVerificationException();
  }
}
